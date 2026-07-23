# Work-order format — the goal envelope

Ephemeral: it exists to drive one condition-based agent loop, then retire.
All concreteness lives here so the contract stays clean.

```yaml
---
spec: specs/<feature>.md
status: active
---
```

## Requirements

A `- [ ]` checklist derived from the contract's user stories, each item
tagged with the story numbers it covers (e.g. `- [ ] ... (stories 3, 7)`).
Every numbered story appears in at least one item — unaccounted-for stories
mean the checklist is not done. The executing agent checks items off as it
works — this is the loop's progress ledger.

## Scope

File paths the work is expected to touch, each traced to grounding evidence,
plus explicit must-not-change boundaries.

## Design Notes

The reasoning from the gate: the route taken, any tradeoff the user settled
and why.

## Verification

Commands with their expected results — exact invocations, exact expected
output or exit state. The loop's finish line is measured here.

## Goal Condition

One ready-to-paste condition, ≤4,000 characters. Its reader is the loop's
**evaluator**, which sees this file and nothing else — so write observables
a cold reader can check: checkboxes flipped, commands exiting as expected.
Done is measured, never judged.

The condition names:

- **The finish line** — one measurable end state: every Requirements item
  checked and every Verification command passing.
- **The rails** — the Scope boundaries that must hold on every iteration,
  so a tempting tangent is recognisably out of bounds.
- **The bounds** — three, and crossing any of them ends the loop with a
  status report against the Requirements checklist, so a stopped run is a
  status update:
  - a turn cap — a maximum number of iterations,
  - a no-progress bound — an iteration that flips no checkbox and passes
    no new Verification command,
  - a circuit breaker — a retry limit on any single failing command.
