---
name: to-goal
description: Turn a task or research note into a living spec plus a goal envelope — a ready-to-run work order for a condition-based agent loop.
---

# Spec + Envelope

One pass, two artifacts: a **contract** (the living spec — abstract, permanent,
user-observable) and its **work order** (the goal envelope — concrete, ephemeral,
file paths and commands). Concreteness lives only in the work order; the
contract must survive it.

## 1. Gate on blast radius

Judge the blast radius of the request:

- **Extreme** (restructuring across many areas) → decline in two sentences;
  work this size needs a real design pass before any spec is worth writing.
- **Genuine tradeoffs** → put them to the user as a brief checkpoint, record
  the choice, then continue.
- **Contained** → continue.

Either way the reasoning lands in `## Design Notes` in the work order.

Done when one route is chosen — and, if extreme, the decline is delivered and
the skill stops.

## 2. Ground

Read the input in full. Search the repo for existing specs, docs, or notes on
the topic and carry forward any decisions they have already settled, naming
where each came from. Walk the code.

Done when every Scope path and Verification command you are about to write
traces to a file:line you have read.

## 3. Draft

- The contract: problem, solution, and an extremely extensive numbered list
  of user stories, per [SPEC-FORMAT.md](SPEC-FORMAT.md). Stories speak the
  user's observable language — behaviour someone could watch happen, in
  domain terms. Name the file after its feature.
- The work order: requirements checklist covering every numbered story,
  Scope, Verification, and the goal condition, per
  [ENVELOPE-FORMAT.md](ENVELOPE-FORMAT.md).

## 4. Buy-in

Present both drafts and iterate until the user accepts.

## 5. Hand off

Save the contract under `specs/` and the work order under `goals/` (create
either lazily), the work order linking the contract. Print the ready-to-paste
goal condition in the session and stop: the loop is the user's to start. Suggest re-checking
the implementation against the contract's user stories once the goal clears.
