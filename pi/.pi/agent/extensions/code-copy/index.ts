import type { ExtensionAPI, ExtensionCommandContext } from "@earendil-works/pi-coding-agent";
import { copyToClipboard } from "./src/clipboard";
import { extractSnippets, extractText, type Snippet } from "./src/snippets";
import { pickSnippet } from "./src/ui";

type ParsedArgs = {
	scope: "last" | "all";
	index?: number;
	includeInline: boolean;
	limit: number;
};

function parseArgs(args?: string): ParsedArgs {
	const tokens = args?.trim().split(/\s+/).filter(Boolean) ?? [];
	const parsed: ParsedArgs = { scope: "last", includeInline: true, limit: 200 };

	for (const token of tokens) {
		if (token === "all" || token === "last") parsed.scope = token;
		else if (token === "inline") parsed.includeInline = true;
		else if (token === "blocks") parsed.includeInline = false;
		else if (token.startsWith("limit=")) {
			const value = Number.parseInt(token.slice("limit=".length), 10);
			if (!Number.isNaN(value) && value > 0) parsed.limit = value;
		} else if (/^\d+$/.test(token)) {
			parsed.index = Math.max(0, Number.parseInt(token, 10) - 1);
		}
	}

	return parsed;
}

function collectSnippets(ctx: ExtensionCommandContext, parsed: ParsedArgs): Snippet[] {
	const assistantEntries = ctx.sessionManager
		.getBranch()
		.filter((entry) => entry.type === "message" && entry.message?.role === "assistant")
		.sort((a, b) => Date.parse(b.timestamp) - Date.parse(a.timestamp));
	const entries = parsed.scope === "all" ? assistantEntries : assistantEntries.slice(0, 1);

	let snippets: Snippet[] = [];
	for (const entry of entries) {
		if (snippets.length >= parsed.limit) break;
		const text = extractText(entry.message.content);
		if (!text) continue;
		const extracted = extractSnippets(
			text,
			new Date(entry.timestamp).toLocaleTimeString(),
			parsed.includeInline,
			parsed.limit - snippets.length,
		);
		snippets = snippets.concat(extracted);
	}
	return snippets;
}

export default function codeCopyExtension(pi: ExtensionAPI) {
	pi.registerCommand("code", {
		description: "Find and copy code snippets from assistant messages",
		handler: async (args, ctx) => {
			const parsed = parseArgs(args);
			const snippets = collectSnippets(ctx, parsed);
			if (snippets.length === 0) {
				if (ctx.hasUI) ctx.ui.notify("No code blocks or path-like inline snippets found.", "warning");
				return;
			}

			const snippet = parsed.index === undefined
				? ctx.hasUI ? await pickSnippet(ctx, snippets) : undefined
				: snippets[parsed.index];
			if (!snippet) {
				if (parsed.index !== undefined && ctx.hasUI) ctx.ui.notify("Snippet index out of range.", "warning");
				return;
			}

			const ok = await copyToClipboard(pi, snippet.content);
			if (ctx.hasUI) ctx.ui.notify(ok ? "Copied to clipboard." : "Failed to copy to clipboard.", ok ? "info" : "error");
		},
	});
}
