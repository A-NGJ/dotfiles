import { readFile as readFileFromDisk, realpath as realpathFromDisk, stat as statFromDisk } from "node:fs/promises";
import { homedir } from "node:os";
import { dirname, isAbsolute, resolve } from "node:path";

const MAX_IMPORT_DEPTH = 4;
const IMPORT_REFERENCE = /(^|[^A-Za-z0-9_])@((?:~\/|\.{1,2}\/|\/)?[A-Za-z0-9_.-]+(?:\/[A-Za-z0-9_.-]+)*[A-Za-z0-9_-]|(?:~\/|\.{1,2}\/|\/)?[A-Za-z0-9_-])/g;
const FENCE_LINE = /^(?:\s*>\s*)*\s*(`{3,}|~{3,})/;

export type ContextFile = {
	path: string;
	content: string;
};

export type ImportDiagnostic = {
	kind: "cycle" | "depth" | "duplicate" | "read";
	importer: string;
	target: string;
	message: string;
};

export type ExpandContextImportsOptions = {
	home?: string;
	readFile?: (path: string, encoding: "utf8") => Promise<string>;
	realpath?: (path: string) => Promise<string>;
	isFile?: (path: string) => Promise<boolean>;
	canRead?: (importer: string, target: string, root: string) => boolean | Promise<boolean>;
};

export type ExpandedContextFiles = {
	files: ContextFile[];
	diagnostics: ImportDiagnostic[];
};

type ExpansionState = {
	home: string;
	readFile: NonNullable<ExpandContextImportsOptions["readFile"]>;
	realpath: NonNullable<ExpandContextImportsOptions["realpath"]>;
	isFile: NonNullable<ExpandContextImportsOptions["isFile"]>;
	canRead: NonNullable<ExpandContextImportsOptions["canRead"]>;
	seen: Set<string>;
	diagnostics: ImportDiagnostic[];
};

function splitLines(content: string): Array<{ body: string; ending: string }> {
	const lines: Array<{ body: string; ending: string }> = [];
	const pattern = /([^\r\n]*)(\r\n|\n|\r|$)/g;
	let match: RegExpExecArray | null;

	while ((match = pattern.exec(content))) {
		if (match[0] === "") break;
		lines.push({ body: match[1] ?? "", ending: match[2] ?? "" });
	}
	return lines;
}

function resolveImportPath(specifier: string, importer: string, home: string): string {
	if (specifier === "~") return home;
	if (specifier.startsWith("~/")) return resolve(home, specifier.slice(2));
	if (isAbsolute(specifier)) return resolve(specifier);
	return resolve(dirname(importer), specifier);
}

function skipMarker(message: string): string {
	return `<!-- context import skipped: ${message} -->`;
}

async function canonicalPath(path: string, state: ExpansionState): Promise<string> {
	try {
		return await state.realpath(path);
	} catch {
		return resolve(path);
	}
}

async function expandReference(
	specifier: string,
	filePath: string,
	depth: number,
	active: string[],
	root: string,
	state: ExpansionState,
): Promise<string> {
	const target = resolveImportPath(specifier, filePath, state.home);
	const targetIdentity = await canonicalPath(target, state);

	if (active.includes(targetIdentity)) {
		const message = `${target} (cycle: ${[...active, targetIdentity].join(" -> ")})`;
		state.diagnostics.push({ kind: "cycle", importer: filePath, target, message });
		return skipMarker(message);
	}
	if (depth >= MAX_IMPORT_DEPTH) {
		const message = `${target} (maximum import depth ${MAX_IMPORT_DEPTH} exceeded)`;
		state.diagnostics.push({ kind: "depth", importer: filePath, target, message });
		return skipMarker(message);
	}
	if (state.seen.has(targetIdentity)) {
		state.diagnostics.push({ kind: "duplicate", importer: filePath, target, message: `${target} (already imported)` });
		return "";
	}

	try {
		if (!(await state.canRead(filePath, targetIdentity, root))) throw new Error("permission denied");
		if (!(await state.isFile(target))) throw new Error("not a regular file");
		const imported = await state.readFile(target, "utf8");
		state.seen.add(targetIdentity);
		return expandContent(imported, target, depth + 1, [...active, targetIdentity], root, state);
	} catch (error) {
		const reason = error instanceof Error ? error.message : String(error);
		const message = `${target} (${reason})`;
		state.diagnostics.push({ kind: "read", importer: filePath, target, message });
		return skipMarker(message);
	}
}

async function expandPlainText(
	text: string,
	filePath: string,
	depth: number,
	active: string[],
	root: string,
	state: ExpansionState,
): Promise<string> {
	let expanded = "";
	let cursor = 0;
	for (const match of text.matchAll(IMPORT_REFERENCE)) {
		const prefix = match[1] ?? "";
		const referenceStart = match.index + prefix.length;
		expanded += text.slice(cursor, referenceStart);
		expanded += await expandReference(match[2]!, filePath, depth, active, root, state);
		cursor = match.index + match[0].length;
	}
	return expanded + text.slice(cursor);
}

async function expandLine(
	line: string,
	filePath: string,
	depth: number,
	active: string[],
	root: string,
	inlineDelimiter: string | undefined,
	state: ExpansionState,
): Promise<{ content: string; inlineDelimiter: string | undefined }> {
	let expanded = "";
	let cursor = 0;
	let delimiter = inlineDelimiter;

	for (const run of line.matchAll(/(?<!\\)`+/g)) {
		if (delimiter) {
			expanded += line.slice(cursor, run.index + run[0].length);
			cursor = run.index + run[0].length;
			if (run[0] === delimiter) delimiter = undefined;
			continue;
		}

		expanded += await expandPlainText(line.slice(cursor, run.index), filePath, depth, active, root, state);
		expanded += run[0];
		cursor = run.index + run[0].length;
		delimiter = run[0];
	}

	expanded += delimiter
		? line.slice(cursor)
		: await expandPlainText(line.slice(cursor), filePath, depth, active, root, state);
	return { content: expanded, inlineDelimiter: delimiter };
}

async function expandContent(
	content: string,
	filePath: string,
	depth: number,
	active: string[],
	root: string,
	state: ExpansionState,
): Promise<string> {
	let fence: { marker: string; length: number } | undefined;
	let inlineDelimiter: string | undefined;
	let expanded = "";

	for (const line of splitLines(content)) {
		const fenceMatch = !inlineDelimiter ? line.body.match(FENCE_LINE) : null;
		if (fenceMatch) {
			const run = fenceMatch[1]!;
			if (!fence) fence = { marker: run[0]!, length: run.length };
			else if (run[0] === fence.marker && run.length >= fence.length) fence = undefined;
			expanded += line.body + line.ending;
			continue;
		}
		if (fence) {
			expanded += line.body + line.ending;
			continue;
		}

		const lineResult = await expandLine(line.body, filePath, depth, active, root, inlineDelimiter, state);
		inlineDelimiter = lineResult.inlineDelimiter;
		expanded += lineResult.content + line.ending;
	}
	return expanded;
}

export async function expandContextFiles(
	contextFiles: ContextFile[],
	options: ExpandContextImportsOptions = {},
): Promise<ExpandedContextFiles> {
	const state: ExpansionState = {
		home: options.home ?? homedir(),
		readFile: options.readFile ?? readFileFromDisk,
		realpath: options.realpath ?? realpathFromDisk,
		isFile: options.isFile ?? (async (path) => (await statFromDisk(path)).isFile()),
		canRead: options.canRead ?? (() => true),
		seen: new Set<string>(),
		diagnostics: [],
	};

	const files: ContextFile[] = [];
	for (const file of contextFiles) {
		const identity = await canonicalPath(file.path, state);
		if (state.seen.has(identity)) {
			files.push({ path: file.path, content: "" });
			continue;
		}
		state.seen.add(identity);
		files.push({
			path: file.path,
			content: await expandContent(file.content, file.path, 0, [identity], file.path, state),
		});
	}
	return { files, diagnostics: state.diagnostics };
}
