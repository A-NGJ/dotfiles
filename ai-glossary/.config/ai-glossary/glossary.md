# Personal Glossary

Operator meta-language — these terms are how the operator names things; use
them. Inside a repo, its CONTEXT.md wins on conflict.

Use terms naturally — never announce or narrate that you are applying the
glossary. When the operator uses an anti-term, gently point to the canonical
term; don't just avoid the anti-term in your own reply.

---

- **AFK ticket** — a ticket the agent resolves alone, without a human in the loop. *(not: automated task)*
- **agent trajectory** — the full recorded sequence of an agent run: prompts, tool calls, outputs.
- **agentic harness** — the agent runtime a tool plugs into. *(not: IDE, editor)*
- **alias** — an accepted alternative name for a term, mapped to the canonical one. *(aka: aka)*
- **anti-term** — a word deliberately avoided in favor of a canonical term.
- **assignment** — a bounded piece of work entrusted to one responsible party, with defined inputs, authority, and an exit criterion.
- **context hygiene** — actively curating the context window during a run instead of letting it silt up. *(aka: context pruning)*
- **context rot** — the decay of reasoning quality as stale or irrelevant content accumulates in the context window.
- **counterfeit record** — a record an agent wrote in a plausible-looking dialect its system can't parse, so it passes human inspection and carries no authority.
- **DAM** — digital asset management: a system for storing, cataloguing, and governing rich media assets. *(aka: digital asset manager)*
- **decision ticket** — a ticket resolved by making a decision, not by shipping a deliverable. *(not: task, story)*
- **evidence-linking** — anchoring generated or extracted assertions directly to verified source citations or passages. *(not: grounding)*
- **exit criterion** — the observable condition that ends a loop or session. *(not: done)*
- **Feynman style** — explaining mechanisms step-by-step with one concrete example before the general rule, instead of labeling.
- **FTE** — full-time equivalent: a unit of workforce capacity or staffing. *(aka: full-time employee)*
- **fog of war** — the part of a goal you can't plan yet because open decisions still hide it. *(aka: fog)*
- **foundational** — serving as an essential basis or core support in an abstract or figurative context. *(not: load-bearing)*
- **goal drift** — an agent gradually optimizing for something other than the stated objective.
- **grilling** — a structured interview that stress-tests a plan or decision. *(aka: interrogation)*
- **hard iteration cap** — a fixed maximum number of loop iterations, enforced outside the model.
- **HITL** — human in the loop: work that only resolves through live exchange with a human; the agent never stands in for them.
- **hook** — code fired deterministically when an event occurs, not invoked by choice (agent-harness hooks, git hooks, webhooks).
- **issue** — a work item recorded in a ticketing system such as GitHub Issues or Jira. *(not: ticket)*
- **issue tracker** — the tool hosting a repo's issues (GitHub Issues, Linear, local markdown). *(not: backlog, backlog manager)*
- **llm-wiki** — the operator's generated knowledge base in their Obsidian vault.
- **operator** — the human driving an agent session. *(not: user)*
- **orchestrator** — the agent that coordinates narrow specialist assignments, reconciles their results, and communicates with the operator.
- **paper gate** — a specified guarantee that never actually executes, so it reads as protection while providing none.
- **pilot** — a limited real-world use intended to reveal problems before broader adoption. *(not: dogfood)*
- **scratchpad** — a session-local directory for temporary files that never belong in the repo.
- **seed** — the hand-picked first content that bootstraps a system.
- **session capture** — folding what a session learned into a durable artifact before the session ends.
- **session compaction** — summarizing older conversation history so a session fits its context window. *(not: compaction)*
- **ubiquitous language** — one shared vocabulary used identically in conversation, docs, and code.
- **wayfinding** — breaking a foggy goal into decisions and resolving them one at a time until the route to build is clear.
- **worktree** — an isolated git checkout letting a parallel session change the repo without touching yours.
- **yolo mode** — running actions without asking for permission first (e.g. an agent with permission prompts disabled). *(not: autonomous mode)*
