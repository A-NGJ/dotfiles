export type Snippet = {
	type: "block" | "inline";
	language?: string;
	content: string;
	sourceLabel: string;
};

const MIN_SLASH_COUNT = 2;
const HAS_FILE_EXTENSION = /\.[a-zA-Z0-9]{1,6}$/;
const IGNORED_INLINE = new Set([
	"main", "inline", "blocks", "bash -lc", "ls", "pwd", "cd", "git status", "git diff",
	"git add", "git commit", "git push", "git pull", "git checkout", "git switch",
	"npm install", "pnpm install", "yarn install", "bun install", "npm test", "pnpm test",
	"yarn test", "npm run", "pnpm run", "yarn run", "make", "make test", "make lint", "make build",
]);

export function extractText(content: unknown): string {
	if (typeof content === "string") return content;
	if (!Array.isArray(content)) return "";
	return content
		.filter((part): part is { type: "text"; text: string } =>
			Boolean(part && typeof part === "object" && part.type === "text" && typeof part.text === "string"),
		)
		.map((part) => part.text)
		.join("");
}

function looksLikePath(content: string): boolean {
	const slashCount = (content.match(/\//g) ?? []).length;
	if (/(?:^|[\s"'])~\//.test(content)) return true;
	if (content.startsWith("./")) return true;
	if (content.startsWith("/")) return slashCount >= MIN_SLASH_COUNT || HAS_FILE_EXTENSION.test(content);
	return slashCount >= MIN_SLASH_COUNT;
}

function shouldIncludeInline(content: string): boolean {
	const trimmed = content.trim();
	if (!trimmed || trimmed.startsWith("//") || trimmed.startsWith("/*") || trimmed.startsWith("*")) return false;
	if (IGNORED_INLINE.has(trimmed) || /^[A-Za-z0-9._-]{1,5}$/.test(trimmed)) return false;
	return looksLikePath(trimmed);
}

export function extractSnippets(
	text: string,
	sourceLabel: string,
	includeInline: boolean,
	limit: number,
): Snippet[] {
	const snippets: Snippet[] = [];
	const fencedRanges: Array<{ start: number; end: number }> = [];
	const fencedRegex = /```([^\n`]*)\n([\s\S]*?)```/g;
	let match: RegExpExecArray | null;

	while ((match = fencedRegex.exec(text))) {
		if (snippets.length >= limit) return snippets;
		snippets.push({
			type: "block",
			language: match[1]?.trim() || undefined,
			content: match[2]?.replace(/\n$/, "") ?? "",
			sourceLabel,
		});
		fencedRanges.push({ start: match.index, end: match.index + match[0].length });
	}

	if (!includeInline) return snippets;
	const inlineRegex = /`([^`\n]+)`/g;
	while ((match = inlineRegex.exec(text))) {
		if (snippets.length >= limit) return snippets;
		if (fencedRanges.some((range) => match!.index >= range.start && match!.index < range.end)) continue;
		const content = match[1] ?? "";
		if (shouldIncludeInline(content)) snippets.push({ type: "inline", content, sourceLabel });
	}
	return snippets;
}

export function getSnippetPreview(snippet: Snippet): string {
	const content = snippet.content.trim();
	return content ? content.replace(/\s+/g, " ") : "(empty)";
}

export function truncatePreview(value: string, width: number): string {
	if (value.length <= width) return value;
	if (width <= 1) return value.slice(0, width);
	return `${value.slice(0, width - 1)}…`;
}
