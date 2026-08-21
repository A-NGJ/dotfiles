import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

function formatTokens(count: number): string {
  if (count < 1_000) return `${count}`;
  if (count < 1_000_000) return `${(count / 1_000).toFixed(count < 10_000 ? 1 : 0)}k`;
  return `${(count / 1_000_000).toFixed(1)}M`;
}

function formatCwd(cwd: string): string {
  const home = process.env.HOME;
  return home && (cwd === home || cwd.startsWith(`${home}/`)) ? `~${cwd.slice(home.length)}` : cwd;
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx: ExtensionContext) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsubscribe = footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: unsubscribe,
        invalidate() {},
        render(width: number): string[] {
          const separator = theme.fg("dim", " │ ");
          const model = theme.fg("accent", ctx.model?.id ?? "no-model");

          const usage = ctx.getContextUsage();
          const contextWindow = usage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
          let context: string;
          if (!usage || usage.tokens === null || usage.percent === null) {
            context = theme.fg("dim", `—/${formatTokens(contextWindow)}`);
          } else {
            const label = `${formatTokens(usage.tokens)}/${formatTokens(contextWindow)} (${Math.round(usage.percent)}%)`;
            const color =
              usage.percent >= 90
                ? "error"
                : usage.percent >= 70
                  ? "syntaxNumber"
                  : usage.percent >= 50
                    ? "warning"
                    : "success";
            context = theme.fg(color, label);
          }

          const segments = [model, context];
          const branch = footerData.getGitBranch();
          if (branch) segments.push(theme.fg("success", branch));
          segments.push(theme.fg("border", formatCwd(ctx.cwd)));

          const line = segments.join(separator);
          if (visibleWidth(line) <= width) return [line];
          return [truncateToWidth(line, width, theme.fg("dim", "…"))];
        },
      };
    });
  });
}
