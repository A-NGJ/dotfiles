---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done call the `code-reviewer` agent to review the work.

For every review finding that user requests a fix for, spawn a dedicated parallel subagent for the fix.

Once all fixes are in place commit your work to the current branch.
