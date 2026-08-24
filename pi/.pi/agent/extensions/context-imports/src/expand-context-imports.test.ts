import assert from "node:assert/strict";
import { mkdtemp, mkdir, readFile, symlink, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { expandContextFiles } from "./expand-context-imports.ts";

async function fixture(files: Record<string, string>) {
	const directory = await mkdtemp(join(tmpdir(), "context-imports-"));
	for (const [path, content] of Object.entries(files)) {
		const target = join(directory, path);
		await mkdir(join(target, ".."), { recursive: true });
		await writeFile(target, content, "utf8");
	}
	return directory;
}

test("expands relative, absolute, home, and nested imports in place", async () => {
	const directory = await fixture({
		"root.md": "before @nested/one.md after\n@~/home.md\n",
		"nested/one.md": "one @../two.md",
		"two.md": "two",
		"home.md": "home",
	});
	const root = join(directory, "root.md");
	const content = await readFile(root, "utf8");
	const result = await expandContextFiles([{ path: root, content }], { home: directory });

	assert.equal(result.files[0]?.content, "before one two after\nhome\n");
	assert.deepEqual(result.diagnostics, []);
});

test("expands imports anywhere outside code", async () => {
	const directory = await fixture({
		"root.md": "Read @rules.md. Then @nested/more.md!",
		"rules.md": "these rules",
		"nested/more.md": "more",
	});
	const root = join(directory, "root.md");
	const result = await expandContextFiles([{ path: root, content: await readFile(root, "utf8") }]);

	assert.equal(result.files[0]?.content, "Read these rules. Then more!");
});

test("ignores imports in inline code and fenced code blocks", async () => {
	const directory = await fixture({
		"root.md": "`@literal.md`\n`start\n@literal.md\nend`\n```md\n@fenced.md\n```\n~~~\n@tilde.md\n~~~\n> ```md\n> @fenced.md\n> ```\n@loaded.md\n",
		"literal.md": "wrong",
		"fenced.md": "wrong",
		"tilde.md": "wrong",
		"loaded.md": "loaded",
	});
	const root = join(directory, "root.md");
	const result = await expandContextFiles([{ path: root, content: await readFile(root, "utf8") }]);

	assert.equal(
		result.files[0]?.content,
		"`@literal.md`\n`start\n@literal.md\nend`\n```md\n@fenced.md\n```\n~~~\n@tilde.md\n~~~\n> ```md\n> @fenced.md\n> ```\nloaded\n",
	);
});

test("deduplicates canonical files while preserving the first occurrence", async () => {
	const directory = await fixture({
		"root.md": "@a.md\n@alias.md\n@b.md\n",
		"a.md": "shared @shared.md",
		"b.md": "again @shared.md",
		"shared.md": "value",
	});
	await symlink(join(directory, "a.md"), join(directory, "alias.md"));
	const root = join(directory, "root.md");
	const result = await expandContextFiles([{ path: root, content: await readFile(root, "utf8") }]);

	assert.equal(result.files[0]?.content, "shared value\n\nagain \n");
	assert.equal(result.diagnostics.filter((item) => item.kind === "duplicate").length, 2);
});

test("marks cycles, missing files, and imports beyond four hops", async () => {
	const directory = await fixture({
		"root.md": "@cycle.md\n@missing.md\n@one.md",
		"cycle.md": "@root.md",
		"one.md": "@two.md",
		"two.md": "@three.md",
		"three.md": "@four.md",
		"four.md": "@five.md",
		"five.md": "too deep",
	});
	const root = join(directory, "root.md");
	const result = await expandContextFiles([{ path: root, content: await readFile(root, "utf8") }]);

	assert.match(result.files[0]?.content ?? "", /context import skipped: .*cycle:/);
	assert.match(result.files[0]?.content ?? "", /context import skipped: .*missing\.md/);
	assert.match(result.files[0]?.content ?? "", /maximum import depth 4 exceeded/);
	assert.deepEqual(new Set(result.diagnostics.map((item) => item.kind)), new Set(["cycle", "read", "depth"]));
});

test("can deny imports outside the root directory", async () => {
	const directory = await fixture({ "project/root.md": "@../secret.md", "secret.md": "secret" });
	const root = join(directory, "project", "root.md");
	const result = await expandContextFiles([{ path: root, content: await readFile(root, "utf8") }], {
		canRead: (_importer, target) => !target.endsWith("secret.md"),
	});

	assert.match(result.files[0]?.content ?? "", /permission denied/);
	assert.equal(result.diagnostics[0]?.kind, "read");
});

test("does not carry imported content between calls", async () => {
	const directory = await fixture({ "root.md": "@child.md", "child.md": "first" });
	const root = join(directory, "root.md");
	const context = [{ path: root, content: "@child.md" }];
	assert.equal((await expandContextFiles(context)).files[0]?.content, "first");

	await writeFile(join(directory, "child.md"), "second", "utf8");
	assert.equal((await expandContextFiles(context)).files[0]?.content, "second");
});
