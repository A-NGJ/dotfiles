# Pi subagents package comparison

Researched 2026-08-21.

## Summary

These are independent packages by different maintainers, not two names for the same package.

| | `@tintinweb/pi-subagents` | `pi-subagents` |
|---|---|---|
| Maintainer/repository | tintinweb — <https://github.com/tintinweb/pi-subagents> | Nico Bailon — <https://github.com/nicobailon/pi-subagents> |
| Current npm release | 0.18.0 | 0.53.0 |
| Primary interface | Claude Code-compatible `Agent`, `get_subagent_result`, and `steer_subagent` tools | One `subagent` tool, including actions and JavaScript `workflowScript` orchestration |
| Built-in roles | `general-purpose`, `Explore`, `Plan` | `scout`, `researcher`, `worker`, `reviewer`, `oracle`, `delegate` |
| Main emphasis | Claude Code parity: familiar tool calls, agent mentions, nested agents, steering/resume, FleetView, worktrees, and scheduling | Structured orchestration: sequential/parallel workflows, missions, acceptance gates, budgets, watchdog review, observability, and extension APIs |
| Install | `pi install npm:@tintinweb/pi-subagents` | `pi install npm:pi-subagents` |

## Compatibility

They overlap in basic capabilities—custom agents, foreground/background execution, concurrency, steering, session/context handling, worktree isolation, and fleet-style UI—but they expose different tool schemas, role names, commands, configuration, and orchestration models. They are not drop-in replacements.

The current dotfiles and Pi prompt expect `@tintinweb/pi-subagents`: they refer to `Agent`, `get_subagent_result`, `steer_subagent`, and the `Explore`/`Plan` types. Migrating to the unscoped package would require updating those instructions and custom workflows to its `subagent`/`workflowScript` interface and role vocabulary.

Installing both is not recommended unless both APIs are deliberately needed: they provide overlapping delegation systems, add competing tools/UI, and increase model prompt surface.

## Maintenance

Both were actively published immediately before this comparison: npm records `@tintinweb/pi-subagents@0.18.0` on 2026-08-20 and `pi-subagents@0.53.0` on 2026-08-20. Their version numbers are independent and do not indicate relative compatibility or quality.

## Recommendation

Keep `@tintinweb/pi-subagents` if Claude Code-compatible tool names, existing `Explore`/`Plan` definitions, direct `Agent` calls, mentions, and nested agents are the priority. Consider migrating to `pi-subagents` if durable missions, scripted multi-agent pipelines, acceptance gates, watchdog checks, and a broader orchestration API are more important. Do not install both by default.

## Primary sources

- <https://pi.dev/packages/@tintinweb/pi-subagents>
- <https://github.com/tintinweb/pi-subagents>
- <https://www.npmjs.com/package/@tintinweb/pi-subagents>
- <https://pi.dev/packages/pi-subagents>
- <https://github.com/nicobailon/pi-subagents>
- <https://github.com/nicobailon/pi-subagents/blob/main/docs/tool-reference.md>
- <https://www.npmjs.com/package/pi-subagents>
