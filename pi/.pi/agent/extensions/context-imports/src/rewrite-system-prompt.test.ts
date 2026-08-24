import assert from "node:assert/strict";
import test from "node:test";
import { rewriteContextFiles } from "./rewrite-system-prompt.ts";

const original = [
	{ path: "/one/AGENTS.md", content: "same" },
	{ path: "/two/CLAUDE.md", content: "same" },
];

function block(path: string, content: string): string {
	return `<project_instructions path="${path}">\n${content}\n</project_instructions>`;
}

test("rewrites only the path-scoped context bodies", () => {
	const prompt = `prefix same\n${block(original[0]!.path, "same")}\nbetween\n${block(original[1]!.path, "same")}\nsuffix`;
	const result = rewriteContextFiles(prompt, original, [
		{ path: original[0]!.path, content: "first" },
		{ path: original[1]!.path, content: "second" },
	]);

	assert.equal(
		result.systemPrompt,
		`prefix same\n${block(original[0]!.path, "first")}\nbetween\n${block(original[1]!.path, "second")}\nsuffix`,
	);
	assert.deepEqual(result.diagnostics, []);
});

test("fails closed when Pi's rendered wrapper cannot be found", () => {
	const prompt = "a prompt without context wrappers";
	const result = rewriteContextFiles(prompt, [original[0]!], [{ ...original[0]!, content: "expanded" }]);

	assert.equal(result.systemPrompt, prompt);
	assert.equal(result.diagnostics.length, 1);
});

test("does not append or accumulate content", () => {
	const prompt = block(original[0]!.path, original[0]!.content);
	const expanded = [{ ...original[0]!, content: "expanded" }];
	const first = rewriteContextFiles(prompt, [original[0]!], expanded).systemPrompt;
	const second = rewriteContextFiles(prompt, [original[0]!], expanded).systemPrompt;

	assert.equal(first, second);
	assert.equal(first.match(/expanded/g)?.length, 1);
});
