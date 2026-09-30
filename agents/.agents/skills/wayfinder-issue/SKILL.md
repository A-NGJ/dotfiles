---
name: wayfinder-issue
description: Find a route through a complex issue or loose idea, using the issue itself as the parent and tracking only significant prerequisites as sub-issues.
disable-model-invocation: true
---

Wayfinding turns a foggy destination into decisions and evidence. The destination may be a spec, a decision, or a change to make later. **Plan by default**: stop when the route is clear; do not implement the destination unless the issue's Notes explicitly extend this effort into execution. Investigative scripts and prototypes are allowed when they help answer a question, not as an excuse to implement the destination.

## Parent issue

An existing issue supplied by the operator **is the parent**. Read its body, comments, existing sub-issues, dependencies, labels, and linked development branch before planning. Preserve the original body and append a compact wayfinding section only if one is missing; do not replace the issue's original exit criterion with a planning exit criterion. A decision that is itself the parent's outcome is resolved on the parent, not in a new child.

For a loose idea with no issue, first call the Skill tool for "grilling" and "domain-modeling" to settle the destination, then grill breadth-first for the first takeable decisions and fog. If the route is already clear and fits one session, ask whether the operator wants an issue at all. Otherwise create one parent issue. In both modes, name the destination before charting its frontier.

Append only the sections the parent needs, leaving its original text intact:

```markdown
## Destination

<the outcome this effort is finding a route to; for an existing issue, respect its original purpose>

## Notes

<standing preferences, relevant skills, and any explicit authorization to execute>

## Decisions so far

- [<resolved issue title>](link): <one-line gist, or a short pointer to a parent comment>

## Not yet specified

<in-scope questions too vague to state precisely yet>

## Out of scope

<work ruled beyond this destination, with a brief reason>
```

The parent is an **index**, not a second store of detailed answers. Put resolution details and citations in the relevant issue's comments; link them by title and gist in Decisions so far. In human-facing text, refer to issues by linked title, not bare number.

## Branch and labels

Once the parent exists, before working its decisions or prerequisites, find the branch already linked or assigned to it. Reuse it; otherwise create a branch for that issue using repository conventions and associate it with the issue where the tracker supports this. A parent created from a loose idea also gets a branch. If multiple branches could be the issue's branch, ask which one to use. Even a decision-only effort has a branch. Keep useful scripts and substantial evidence on it; do not create research or child-specific branches. Parallelize read-only agents, but coordinate writes to the shared branch one at a time.

Inspect existing repository labels. Apply a suitable existing label if useful; leave an issue unlabeled when none fits. Never create labels for wayfinding or require `wayfinder:*` labels. Treat any tracker-specific wayfinding recipe that prescribes a new map, fixed labels, or separate research branches as superseded by this skill; use its mechanics for sub-issue links, dependency edges, claims, and comments where applicable. If no tracker is configured, use the local-markdown tracker described by `/setup-matt-pocock-skills`.

## Prerequisites and frontier

Reuse existing sub-issues and dependencies, including ones without wayfinding formatting or labels. Add a sub-issue only for a **significant, distinct prerequisite** that must be resolved before the parent can continue, whether human-owned or agent-owned. Put its question or required work and its exit criterion in its body. A small question answered in the current session, or an agent dispatch by itself, does not earn a sub-issue. Ask the operator follow-up decisions live. Create a human-owned sub-issue for independent work the human cannot finish in the conversation; do not answer for them.

Use the tracker's native child links and blocking relationships when available; otherwise follow its documented fallback. For new children, create them first and wire blocking edges in a second pass. The **frontier** is open, unblocked prerequisites not yet claimed. Claim an agent-owned child before work (using the tracker's claim convention), and leave existing human assignees intact. Do not rewrite existing children to fit a template. When a decision clarifies the fog, add only newly specifiable, significant prerequisites; clear the graduated entry from Not yet specified. Out-of-scope work belongs in Out of scope, not the frontier.

## Investigate and resolve

- **Research**: Spin up sub-agents to investigate independent factual questions against primary sources; use the "research" skill for substantial investigations. Small investigations need no findings file or sub-issue: record a cited answer in a parent comment and a short pointer in Decisions so far. For significant child investigations, comment with the findings and close the child when its question is answered. Link substantial files or scripts from the relevant issue; coordinate any branch writes.
- **Grilling**: Call the Skill tool for "grilling" and "domain-modeling" when a decision needs the operator. Ask follow-up questions; wait for answers before recording a resolution.
- **Prototype or enabling task**: Use "prototype" when a rough artifact would make a decision possible. Delegate an agent-owned prerequisite where possible; for human-only work, give the operator a precise checklist. Record what was learned or done, not just that a task ran.

On invocation with an existing issue, inspect the parent and its open children. If the operator names a child, work it; otherwise select the first unclaimed, unblocked significant prerequisite. If only blocked or claimed prerequisites remain, report what is blocking progress and stop; if none remains open, work the parent's own decision directly. Resolve at most one non-research decision per session. Record its answer as a comment; close a resolved child and add a linked one-line pointer to the parent. A short investigation performed directly for the parent may be resolved alongside that decision. Research sub-agents may run in parallel when independent.

When all prerequisites and in-scope fog are cleared, stop at the planning boundary. Close a decision-only parent once its decision is recorded. Leave an implementation parent open until **its original exit criterion** is met; a clear plan alone does not close it. Expect other sessions to change the tracker concurrently, and recheck the frontier before writing.
