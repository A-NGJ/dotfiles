---
name: specifying-goals
description: Turns a task, feature request, or research note into a living spec plus a goal envelope — a self-contained work order for a condition-based agent loop. Use when the user wants to write a spec, prep a task for a background or autonomous agent, create a goal condition, or turn notes into something an agent can run unattended.
---

# Spec + Envelope

One pass, two artifacts: the **spec** (a behavioral contract — abstract,
permanent, user-observable) and the **goal envelope** (its work order —
concrete, ephemeral, file paths and commands). Concreteness lives only in the
envelope; the spec must survive it.

## 1. Gate on blast radius

Judge the blast radius of the request:

- **Extreme** (restructuring across many areas) → decline in two sentences;
  work this size needs a real design pass before any spec is worth writing.
- **Genuine tradeoffs** → put them to the user as a brief checkpoint, record
  the choice, then continue.
- **Contained** → continue.

Either way the reasoning lands in `## Design Notes` in the envelope.

Done when one route is chosen — and, if extreme, the decline is delivered and
the skill stops.

## 2. Ground

Read the input in full. Search the repo for existing specs, docs, or notes on
the topic and carry forward any decisions they have already settled, naming
where each came from. Walk the code.

Done when every Scope path and Verification command you are about to write
traces to a file:line you have read.

## 3. Draft

- The spec: problem, solution, and an exhaustive numbered list of user
  stories (coverage test in [SPEC-FORMAT.md](SPEC-FORMAT.md)). Stories speak the
  user's observable language — behaviour someone could watch happen, in
  domain terms. Name the file after its feature.
- The envelope: requirements checklist covering every numbered story,
  Scope, Verification, and the goal condition, per
  [ENVELOPE-FORMAT.md](ENVELOPE-FORMAT.md).

Done when a walk of story numbers 1..N finds each tagged in at least one
Requirements item — any miss means revise the checklist and walk again
before presenting.

## 4. Buy-in

Present both drafts and iterate until the user accepts.

## 5. Hand off

Save the spec under `specs/` and the envelope under `goals/` (create
either lazily), the envelope linking the spec. Print the ready-to-paste
goal condition and stop: the loop is the user's to start. Suggest re-checking
the implementation against the spec's user stories once the goal clears.
