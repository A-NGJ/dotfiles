---
name: research
description: Investigate a question against high-trust primary sources with parallel researcher subagents and report cited findings. Use when the operator wants a topic researched, docs or API facts gathered, or reading legwork delegated.
---

1. **Settle the scope.** If the goal or scope is unclear, call the Skill tool with "grilling" and grill until you can state what the research must answer. If the question is already precise, skip this step.
2. **Decompose.** Split the question into research questions, each one independent, bounded, and answerable from sources. Propose the list to the operator, and wait for approval before dispatching anything.
3. **Route.** Call the Skill tool with "model-routing" and pick a tier for each approved question. For research, a single fact from one or two official pages is fast. An answer drawn from several primary sources is standard. Exploring an API through its source code, or reconciling sources that disagree, is deep.
4. **Dispatch.** Spin up one `researcher` subagent, at its routed tier, per question, all in parallel. Give each exactly one question, the intent behind it, and any artifacts or sources it should start from.
5. **Report.** Reconcile the findings into one report in chat. Answer the operator's original question first, then give each research question's finding with its citations. Name conflicts between researchers and gaps any of them reported; never paper over them.

Write the report to a file only when the operator or a calling skill explicitly asks for one. Save it where the repo already keeps such notes, match the existing convention, and say where it went.
