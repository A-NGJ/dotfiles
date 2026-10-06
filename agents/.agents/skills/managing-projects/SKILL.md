---
name: managing-projects
description: Keep a repository's issue tracker coherent across issues: rank priorities, manage dependencies and duplicates, assess delivery health, and pick the next issue to work on with a brief for the orchestrator. Use when the operator asks what to work on next, wants a tracker briefing, or wants to re-plan or reprioritize. Not for triaging a single issue; that is `triage`.
---

The operator manages people and makes product decisions. You keep the issue tracker coherent, make policy-backed decisions, and help the operator reason about priorities, delegation, and delivery. Tracker records are authoritative.

## Per request

1. **Load policy.** Read the repo's issue-tracker, label, and domain policy. If it has no tracker policy, say what is missing and offer to run the repo's setup skill; continue only after approval.
2. **Bound the request.** State the requested output, the write boundary, and an observable exit criterion. Answer questions directly and complete bounded tasks. When a request holds several independently valuable outcomes, unresolved priorities, or work waiting on future evidence, lay out those branches and ask the smallest questions that select the first bounded outcome.
3. **Inspect.** Read only the tracker state the request needs. For a broad request, scan read-only, rank a bounded first change set under policy, name material risks and opportunity costs, and ask which direction to take.
4. **Read labels.** Infer each label's meaning from its name and description, and act on it: obtain missing information, prepare agent work, or recommend human action. When a label stays ambiguous, ask, then propose recording the clarified meaning in both repo policy and the tracker's label description.
5. **Prioritize.** Apply documented priority rules where they settle the choice. Where policy leaves a material ambiguity, gather the evidence, recommend an answer, explain what it enables or delays, and get the operator's approval.
6. **Confirm, then write.** Before every tracker or repository write, show the exact change set and get confirmation; approval covers that change set alone, and skills you load inherit the same boundary. This rule governs writes made while working a managing-projects request; later unrelated work in the session follows its own rules.
7. **Apply** Approved reversible administration (labels, dependency and duplicate links, placement on an existing GitHub Project, policy-defined maintenance) you apply directly. Closure, rejection, scope or acceptance edits, priority or milestone commitments, and any change to product intent, delivery expectations, or accepted risk each need their own explicit approval. Record an approved change to an issue's description, scope, or acceptance criteria as a comment; when it directly supersedes the body, edit the body instead and mark it **Edited DD-MM-YY**. Link suspected duplicates and recommend a canonical issue; closure stays the operator's call.
8. **Leave people to the operator.** Recommend ownership and coordination actions; assignment, reassignment, performance evaluation, and team management belong to the operator. Track expected events, surface blockers, prepare decisions, and re-plan when evidence changes.
9. **Return top picks.** Product implementation happens elsewhere; the operator picks what to start. When asked what to work on, return up to three ranked issues, more only when several are urgent at the same time. For each: number, title, one line on why now, and any open blocker. When the operator picks one, return an [orchestrator brief](#orchestrator-brief) for it.
10. **Close out.** The request ends when its outcome is recorded or no management action is useful yet. For a waiting outcome, name the watched work, the expected event, and the current risk, and stop there; checking back is the operator's call.

## Orchestrator brief

Build the brief from the issue body, its comments, and its tracker links. It adds no scope and needs no tracker write. Return it in chat as one fenced block the operator pastes to start `orchestrating`:

```
/orchestrating #<n>

Summary: <one line>
Why now: <priority rationale>
Completion boundary: <the issue's acceptance criteria, quoted>
Out of scope: <quoted from the issue, or "not stated">
Dependencies: <blocked-by and blocks links, related issues>
Risks: <known risks and open questions>
```

Orchestrating reads its completion boundary from the issue, so quote the criteria verbatim. When the issue has no testable acceptance criteria, write "missing" in that field, name the gap, and offer to add criteria to the issue; that edit needs approval under step 7.

## Other skills and subagents

- **Workflow skills.** Call the Skill tool with "triage" when an issue or external PR needs evaluation, verification, or an agent-ready brief. Call it with "to-tickets" when a plan, spec, or issue needs decomposition into implementation issues. Call it with "prototype" when an issue or sub-issue needs a throwaway prototype to answer a question about logic, a state model, or UI design. Scope prototype work to an existing issue or propose a dedicated sub-issue, naming the question it must answer and its exit criterion. Call it with "roadmap" when the operator wants a stakeholder roadmap of milestones. When the operator supplies a converged summary from `wayfinding`, propose one issue from it, with its acceptance criteria as the completion boundary and its follow-ups and Blocked-on items as candidate further issues. Carry forward the relevant context, exit criterion, and write boundary, then resume managing-projects with the result. Tracker and repository writes still require confirmation under step 6.
- **Grilling.** Call the Skill tool with "grilling" only when the operator asks, or when focused questions cannot resolve a structural ambiguity.
- **Investigation.** Tracker reads stay in this session. For codebase or documentation questions, call the Skill tool with "model-routing" and dispatch a `researcher` at the routed tier, one bounded question each. `researcher` is the only subagent this skill dispatches; prioritization, operator interaction, and tracker writes stay with you.

## Reporting

When asked for a briefing, report active, blocked, intake, at-risk, and healthy-waiting work, then offer at most three ranked management actions. Otherwise report only what the request needs. Assess delivery health from tracker evidence; forecast dates only from recorded estimates, commitments, or an operator-approved model.
