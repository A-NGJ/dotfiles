---
name: model-routing
description: Pick a model tier (fast, standard, deep) for a subagent before dispatching it. Use whenever you are about to call a subagent, or when another skill asks you to route one.
---

A subagent's model lives in its agent definition. You pick the model by picking **which agent** to dispatch, never by passing a model.

## Tiered agents

An agent `<agent>` may have up to three tier variants:

| Tier     | Agent name      |
| -------- | --------------- |
| fast     | `<agent>-fast`  |
| standard | `<agent>`       |
| deep     | `<agent>-deep`  |

The variants of one agent share the same instructions and differ only in their frontmatter model. When you edit one variant's instructions, edit every variant in every runtime.

## Pick the tier

Judge each assignment by what the task observably needs, not by how hard it sounds:

- **fast.** The task is narrow and you know where the answer lives: one lookup, one page, one file.
- **standard.** The task spans several sources or files, and they should agree.
- **deep.** The task needs open-ended exploration such as tracing an API through source code, reconciling conflicting evidence, or a chain of reasoning where each step depends on the last.

If two tiers fit, take the higher one. Decide per assignment: parallel assignments from one request may land on different tiers.

## Reviewer rule

A `reviewer` never runs on the same model as the `implementation-specialist` whose work it reviews. Compare the `model` in both variants' frontmatter. On a match, take the nearest tier above the routed one whose model differs; when none above differs, take the nearest one below.

## Dispatch

Dispatch the agent name for the chosen tier. If that variant does not exist, dispatch `<agent>`: an agent without variants runs on its own fixed model at every tier.

Name the chosen tier when you tell the operator what you dispatched.
