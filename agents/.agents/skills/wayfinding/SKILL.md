---
name: wayfinding
description: Converge a foggy idea or issue into one fixed-scope work item through grilling, research, and prototypes in a single session, ending in a summary a builder or orchestrator can take.
disable-model-invocation: true
---

Wayfinding turns a foggy idea into one **fixed-scope work item**: a destination, the decisions that pin it, and testable acceptance criteria someone can later pick up and build. You converge through grilling, research, and prototypes, all inside this session. On the tracker you read and post one summary comment; creating issues, applying labels, and editing issue bodies belong to `managing-projects`.

## Start

1. **Load the input.** For an issue, read its body, comments, sub-issues, dependencies, and linked branch; its original purpose bounds the destination, and an earlier wayfinding summary comment is where you resume. For a summary file or a pasted summary, resume from its open questions and fog. Otherwise take the loose idea as stated.
2. **Name the destination.** Call the Skill tool for "grilling" and "domain-modeling". The first round settles what the work item delivers.
3. **Draft candidate research.** List the research questions the destination raises, and hold them until grilling narrows them.

## Converge

Run grilling rounds until the frontier is empty. Within the rounds:

- **Read back** each ambiguous or garbled answer: state your interpretation and have the operator confirm it in the next round before anything builds on it.
- **Research.** Once grilling has narrowed the candidates, call the Skill tool for "research"; its approval of the question list is a question in the current round. Findings land in chat and shape the next round.
- **Prototype.** When a question is how something should look or behave, call the Skill tool for "prototype", build it within the round, and have the operator pick in the next. Capture it on a throwaway `prototype/<slug>` branch and cite that branch under Evidence.
- **Scope.** When the idea holds several work items, narrow to one and record the rest as follow-ups.
- **Blocked on someone else.** Work only another person can do goes under Blocked on, with a precise checklist for them.

After about six rounds, offer to pause with a progress summary; the operator may continue.

## Checkpoint

Write the running summary before dispatching research or a prototype, after a session compaction, and at session end:

- **Issue:** one summary comment, created at the first checkpoint and edited in place after that, so the issue carries a single current summary.
- **Loose idea:** overwrite `/tmp/wayfinding-<slug>.md` and name the path in chat.

After a session compaction, re-read the checkpoint before continuing; it is the record, and your memory of the session is a lossy copy of it.

## Summaries

A **converged summary** is the exit:

```markdown
## Destination
## Decisions
- <question>: <answer>
## Out of scope
## Acceptance criteria
## Files and artifacts
## Evidence
<prototype branches, research citations>
## Follow-ups
## Blocked on
## Open questions
## Suggested skills
```

A **progress summary** is a pause. It holds Destination, Decisions so far, Open questions, Not yet specified (the fog you can't phrase as a question yet), and Candidate research. Starting the next session from it resumes the work.

## Finish

The exit criterion is a converged summary the operator confirms as a shared understanding. Write it as the final checkpoint and show it in chat. It is the handoff: to a builder, in this session or a fresh one, or to `managing-projects`, which turns it into an issue for `orchestrating`. Build in this session only on the operator's explicit go-ahead.

Commit durable artifacts, such as glossary entries, ADRs, and scripts, on the issue's linked branch when one exists, otherwise by repository convention. A branch exists only once there is something to commit on it.
