import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { homedir } from "node:os";
import { relative, resolve } from "node:path";
import { expandContextFiles, type ImportDiagnostic } from "./src/expand-context-imports";
import { rewriteContextFiles } from "./src/rewrite-system-prompt";

function reportDiagnostics(diagnostics: ImportDiagnostic[], notify: (message: string) => void): void {
	const actionable = diagnostics.filter((diagnostic) => diagnostic.kind !== "duplicate");
	if (actionable.length === 0) return;

	const details = actionable.slice(0, 3).map((diagnostic) => diagnostic.message).join("; ");
	const remaining = actionable.length - 3;
	notify(`Context imports: ${details}${remaining > 0 ? `; ${remaining} more` : ""}`);
}

function isWithin(parent: string, child: string): boolean {
	const path = relative(parent, child);
	return path === "" || (!path.startsWith("..") && !path.startsWith("/"));
}

export default function contextImports(pi: ExtensionAPI) {
	const approvedExternalImports = new Set<string>();

	pi.on("before_agent_start", async (event, ctx) => {
		const contextFiles = event.systemPromptOptions.contextFiles ?? [];
		if (contextFiles.length === 0) return;

		const globalContextDirectory = resolve(homedir(), ".pi", "agent");
		const expanded = await expandContextFiles(contextFiles, {
			canRead: async (_importer, target, root) => {
				if (isWithin(resolve(root, ".."), target) || isWithin(globalContextDirectory, resolve(root))) return true;
				if (approvedExternalImports.has(target)) return true;
				if (!ctx.hasUI) return false;

				const approved = await ctx.ui.confirm(
					"External context import",
					`${root} wants to include ${target}. Allow for this Pi process?`,
				);
				if (approved) approvedExternalImports.add(target);
				return approved;
			},
		});
		const rewritten = rewriteContextFiles(event.systemPrompt, contextFiles, expanded.files);
		const diagnostics = [...expanded.diagnostics, ...rewritten.diagnostics];

		reportDiagnostics(diagnostics, (message) => {
			if (ctx.hasUI) ctx.ui.notify(message, "warning");
			else console.warn(message);
		});

		return { systemPrompt: rewritten.systemPrompt };
	});
}
