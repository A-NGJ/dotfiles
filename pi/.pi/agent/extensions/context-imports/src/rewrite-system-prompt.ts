import type { ContextFile, ImportDiagnostic } from "./expand-context-imports";

export type RewriteResult = {
	systemPrompt: string;
	diagnostics: ImportDiagnostic[];
};

function openingTag(path: string): string {
	return `<project_instructions path="${path}">\n`;
}

function closingTag(): string {
	return "\n</project_instructions>";
}

export function rewriteContextFiles(
	systemPrompt: string,
	originalFiles: ContextFile[],
	expandedFiles: ContextFile[],
): RewriteResult {
	const diagnostics: ImportDiagnostic[] = [];
	const replacements: Array<{ start: number; end: number; content: string }> = [];
	let cursor = 0;

	for (let index = 0; index < originalFiles.length; index += 1) {
		const original = originalFiles[index]!;
		const expanded = expandedFiles[index];
		if (!expanded) continue;

		const opening = openingTag(original.path);
		const bodyStart = systemPrompt.indexOf(opening, cursor);
		if (bodyStart < 0) {
			diagnostics.push({
				kind: "read",
				importer: original.path,
				target: original.path,
				message: `${original.path} (could not locate its rendered context block)`,
			});
			continue;
		}

		const contentStart = bodyStart + opening.length;
		const contentEnd = contentStart + original.content.length;
		if (systemPrompt.slice(contentStart, contentEnd) !== original.content || !systemPrompt.startsWith(closingTag(), contentEnd)) {
			diagnostics.push({
				kind: "read",
				importer: original.path,
				target: original.path,
				message: `${original.path} (rendered context body did not match the loaded file)`,
			});
			continue;
		}

		replacements.push({ start: contentStart, end: contentEnd, content: expanded.content });
		cursor = contentEnd + closingTag().length;
	}

	let rewritten = systemPrompt;
	for (const replacement of replacements.reverse()) {
		rewritten = rewritten.slice(0, replacement.start) + replacement.content + rewritten.slice(replacement.end);
	}

	return { systemPrompt: rewritten, diagnostics };
}
