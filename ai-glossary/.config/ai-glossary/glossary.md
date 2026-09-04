# Personal Glossary

Operator meta-language — these terms are how the operator names things; use
them. Inside a repo, its CONTEXT.md wins on conflict.

Use terms naturally — never announce or narrate that you are applying the
glossary. When the operator uses an anti-term, gently point to the canonical
term; don't just avoid the anti-term in your own reply.

Curation: you maintain this file. Add explicit terminology corrections
immediately. Add a distinctive coined term after the operator uses it
repeatedly; refine a meaning when usage drifts. Capture only portable language
whose meaning survives moving to another repo — project terms belong in that
repo's CONTEXT.md. Mention every change in passing. Ask before deleting an
entry. An entry marked `locked` (or a leading 🔒) keeps its wording unless the
operator consents to change it.

Entry grammar — one line per term, flat and alphabetized:
`- **term** — one-line meaning. *(locked; not: anti-term, …; aka: alias, …)*`
(italic group optional; parts in that order)

What makes a good term: broad enough to apply beyond one tool or project,
yet still definable in one line; a word the operator genuinely uses; never a
common word narrowed to one niche sense — qualify it instead (**session
compaction**, not *compaction*; **fog of war**, not *fog*; **agent
trajectory**, not *trajectory*). Mechanics of this file — locks, the
one-line limit — belong in this header, never as entries.

Examples of good entries:

- **ubiquitous language** — one shared vocabulary used identically in conversation, docs, and code. *(locked)*
- **session compaction** — summarizing older conversation history so a session fits its context window. *(not: compaction)*
- **hook** — code fired deterministically when an event occurs, not invoked by choice (agent-harness hooks, git hooks, webhooks).

---

- **AFK ticket** — a ticket the agent resolves alone, without a human in the loop. *(not: automated task)*
- **agent trajectory** — the full recorded sequence of an agent run: prompts, tool calls, outputs.
- **agentic harness** — the agent runtime a tool plugs into. *(not: IDE, editor)*
- **alias** — an accepted alternative name for a term, mapped to the canonical one. *(locked; aka: aka)*
- **anti-term** — a word deliberately avoided in favor of a canonical term. *(locked)*
- **assignment** — a bounded piece of work entrusted to one responsible party, with defined inputs, authority, and an exit criterion.
- **context hygiene** — actively curating the context window during a run instead of letting it silt up. *(aka: context pruning)*
- **context rot** — the decay of reasoning quality as stale or irrelevant content accumulates in the context window.
- **DAM** — digital asset management: a system for storing, cataloguing, and governing rich media assets. *(aka: digital asset manager)*
- **decision ticket** — a ticket resolved by making a decision, not by shipping a deliverable. *(not: task, story)*
- **evidence-linking** — anchoring generated or extracted assertions directly to verified source citations or passages. *(not: grounding)*
- **exit criterion** — the observable condition that ends a loop or session. *(not: done)*
- **FTE** — full-time equivalent: a unit of workforce capacity or staffing. *(aka: full-time employee)*
- **Feynman style** — explaining mechanisms step-by-step with one concrete example before the general rule, instead of labeling.
- **fog of war** — the part of a goal you can't plan yet because open decisions still hide it. *(aka: fog)*
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
- **pilot** — a limited real-world use intended to reveal problems before broader adoption. *(not: dogfood)*
- **scratchpad** — a session-local directory for temporary files that never belong in the repo.
- **seed** — the hand-picked first content that bootstraps a system.
- **session capture** — folding what a session learned into a durable artifact before the session ends.
- **session compaction** — summarizing older conversation history so a session fits its context window. *(not: compaction)*
- **ubiquitous language** — one shared vocabulary used identically in conversation, docs, and code. *(locked)*
- **wayfinding** — breaking a foggy goal into decisions and resolving them one at a time until the route to build is clear.
- **worktree** — an isolated git checkout letting a parallel session change the repo without touching yours.
- **yolo mode** — running actions without asking for permission first (e.g. an agent with permission prompts disabled). *(not: autonomous mode)*
