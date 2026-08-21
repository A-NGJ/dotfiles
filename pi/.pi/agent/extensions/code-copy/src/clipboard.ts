import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { mkdtemp, rm, writeFile } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";

type ClipboardCommand = (path: string) => { command: string; args: string[] };

function clipboardCommands(path: string): ClipboardCommand[] {
	if (process.platform === "darwin") {
		return [() => ({ command: "sh", args: ["-c", 'pbcopy < "$1"', "sh", path] })];
	}
	if (process.platform === "win32") {
		return [() => ({
			command: "powershell",
			args: ["-NoProfile", "-Command", "Get-Content -Raw -LiteralPath $args[0] | Set-Clipboard", path],
		})];
	}
	return [
		() => ({ command: "sh", args: ["-c", 'wl-copy < "$1"', "sh", path] }),
		() => ({ command: "sh", args: ["-c", 'xclip -selection clipboard < "$1"', "sh", path] }),
		() => ({ command: "sh", args: ["-c", 'xsel --clipboard --input < "$1"', "sh", path] }),
	];
}

export async function copyToClipboard(pi: ExtensionAPI, content: string): Promise<boolean> {
	const directory = await mkdtemp(join(tmpdir(), "pi-code-copy-"));
	const path = join(directory, "snippet.txt");
	try {
		await writeFile(path, content, "utf8");
		for (const makeCommand of clipboardCommands(path)) {
			try {
				const candidate = makeCommand(path);
				const result = await pi.exec(candidate.command, candidate.args);
				if (result.code === 0) return true;
			} catch {
				// Try the next clipboard implementation.
			}
		}
		return false;
	} finally {
		await rm(directory, { recursive: true, force: true });
	}
}
