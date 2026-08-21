import type { SelectItem } from "@earendil-works/pi-tui";
import { getSnippetPreview, type Snippet } from "./snippets";

type SearchEntry = { item: SelectItem; index: number; raw: string; normalized: string };

function normalize(value: string): string {
	return value.toLowerCase().replace(/[^a-z0-9]+/g, " ").replace(/\s+/g, " ").trim();
}

export function buildSearchIndex(snippets: Snippet[], items: SelectItem[]): SearchEntry[] {
	return snippets.map((snippet, index) => {
		const raw = `${getSnippetPreview(snippet)} ${snippet.type} ${snippet.language ?? ""} ${snippet.sourceLabel}`.toLowerCase();
		return { item: items[index]!, index, raw, normalized: normalize(raw) };
	});
}

export function rankedFilterItems(filter: string, items: SelectItem[], index: SearchEntry[]): SelectItem[] {
	const lower = filter.toLowerCase();
	if (!lower) return items;
	const tokens = normalize(lower).split(" ").filter(Boolean);
	const matches: Array<{ item: SelectItem; index: number; score: number }> = [];

	for (const entry of index) {
		const exactPosition = entry.raw.indexOf(lower);
		if (exactPosition >= 0) {
			matches.push({ item: entry.item, index: entry.index, score: 1000 - exactPosition });
			continue;
		}
		const positions = tokens.map((token) => entry.normalized.indexOf(token));
		if (tokens.length && positions.every((position) => position >= 0)) {
			matches.push({ item: entry.item, index: entry.index, score: 500 - Math.min(...positions) });
		}
	}

	return matches
		.sort((a, b) => b.score - a.score || a.index - b.index)
		.map((entry) => entry.item);
}
