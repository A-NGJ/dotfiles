import { DynamicBorder, type ExtensionCommandContext } from "@earendil-works/pi-coding-agent";
import { Container, matchesKey, type SelectItem, SelectList, Text } from "@earendil-works/pi-tui";
import { buildSearchIndex, rankedFilterItems } from "./search";
import { getSnippetPreview, truncatePreview, type Snippet } from "./snippets";

const PREVIEW_WIDTH = 52;

function buildLabel(snippet: Snippet, index: number, indexWidth: number, timeWidth: number): string {
	const preview = truncatePreview(getSnippetPreview(snippet), PREVIEW_WIDTH).padEnd(PREVIEW_WIDTH, " ");
	const number = String(index + 1).padStart(indexWidth, " ");
	const type = snippet.type === "block" ? "Block" : "Inline";
	const language = snippet.type === "block" && snippet.language ? ` (${snippet.language})` : "";
	return `${number}. ${preview} ${snippet.sourceLabel.padEnd(timeWidth, " ")} ${type}${language}`;
}

export async function pickSnippet(ctx: ExtensionCommandContext, snippets: Snippet[]): Promise<Snippet | undefined> {
	const indexWidth = String(snippets.length).length;
	const timeWidth = Math.max(...snippets.map((snippet) => snippet.sourceLabel.length));
	const items: SelectItem[] = snippets.map((snippet, index) => ({
		value: String(index),
		label: buildLabel(snippet, index, indexWidth, timeWidth),
		description: "",
	}));
	const searchIndex = buildSearchIndex(snippets, items);

	const selected = await ctx.ui.custom<string | null>((tui, theme, _kb, done) => {
		const container = new Container();
		container.addChild(new DynamicBorder((text: string) => theme.fg("accent", text)));
		container.addChild(new Text(theme.fg("accent", theme.bold("Copy Code Snippet")), 1, 0));
		const list = new SelectList(items, Math.min(items.length, 12), {
			selectedPrefix: (text) => theme.fg("accent", text),
			selectedText: (text) => theme.fg("accent", text),
			description: (text) => theme.fg("muted", text),
			scrollInfo: (text) => theme.fg("dim", text),
			noMatch: (text) => theme.fg("warning", text),
		});
		list.onSelect = (item) => done(item.value);
		list.onCancel = () => done(null);
		container.addChild(list);
		const help = new Text(theme.fg("dim", "Filter: (none)   Enter copy   Up/Down navigate   Esc cancel"), 1, 0);
		container.addChild(help);
		container.addChild(new DynamicBorder((text: string) => theme.fg("accent", text)));

		let filter = "";
		const updateFilter = (next: string) => {
			filter = next;
			const internal = list as unknown as { filteredItems: SelectItem[]; selectedIndex: number };
			internal.filteredItems = rankedFilterItems(filter, items, searchIndex);
			internal.selectedIndex = 0;
			help.setText(theme.fg("dim", `Filter: ${filter || "(none)"}   Enter copy   Up/Down navigate   Esc cancel`));
			list.invalidate();
			tui.requestRender();
		};

		return {
			render: (width: number) => container.render(width),
			invalidate: () => container.invalidate(),
			handleInput: (data: string) => {
				if (matchesKey(data, "backspace")) {
					if (filter) updateFilter(filter.slice(0, -1));
					return;
				}
				if (data.length === 1 && data >= " " && data <= "~") {
					updateFilter(filter + data);
					return;
				}
				list.handleInput?.(data);
				tui.requestRender();
			},
		};
	});

	if (selected === null || selected === undefined) return undefined;
	return snippets[Number.parseInt(selected, 10)];
}
