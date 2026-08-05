# Envelope format — the goal envelope

A work order for one condition-based agent loop: ephemeral, it drives the
loop and then retires. All concreteness lives here so the spec stays clean.

```yaml
---
spec: specs/<feature>.md
status: active
---
```

## Requirements

A `- [ ]` checklist derived from the spec's user stories, each item
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

One ready-to-paste condition, brief enough for its reader to hold in full —
no fixed size cap. Its reader is the loop's
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

<goal-condition-example>
Goal: the envelope at goals/csv-export.md is complete.

Finish line — both must hold:
- Every item under ## Requirements in goals/csv-export.md is checked ([x]).
- Every command under ## Verification, run exactly as written, produces its
  stated expected output or exit state.

Rails — on every iteration:
- Touch only files listed under ## Scope; src/report/render.rs is
  must-not-change.

Bounds — crossing any of these ends the loop with a status report against
the Requirements checklist:
- Turn cap: 25 iterations.
- No progress: an iteration that flips no checkbox and passes no new
  Verification command.
- Circuit breaker: the same Verification command failing 3 consecutive runs.
</goal-condition-example>
