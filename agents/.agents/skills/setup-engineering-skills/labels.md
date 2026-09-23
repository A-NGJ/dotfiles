# Labels

## Triage Labels

The skills speak in terms of five canonical triage roles. This table maps those roles to the actual label strings used in this repo's issue tracker.

| Label in our tracker | Meaning                                  |
| --------------------- | ----------------------------------------- |
| `needs-triage`         | Maintainer needs to evaluate this issue  |
| `needs-info`           | Waiting on reporter for more information |
| `ready-for-agent`      | Fully specified, ready for an AFK agent  |
| `ready-for-human`      | Requires human implementation            |
| `wontfix`              | Will not be actioned                     |

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

Edit the right-hand column to match whatever vocabulary you actually use.

<!--
Only include the tiers below if this repo's tracker already carries labels beyond the five triage roles above. Delete a tier entirely rather than leaving it empty — a category or priority split the repo doesn't use is a label a skill might invent by mistake.
-->

## Category Labels

Every triaged issue pairs a state role (above) with exactly one category role. Category answers "what kind of work is this"; state answers "what stage is it at".

| Label in our tracker | Meaning                                                                                        |
| --------------------- | ------------------------------------------------------------------------------------------------ |
| `bug`                  | Something is broken                                                                             |
| `enhancement`          | New feature or improvement                                                                       |
| `decision`             | A decision ticket: resolved by choosing an answer, not by shipping a deliverable. Pairs with a state role rather than driving implementation. |

## Priority Labels

Linear-style priority scale (No priority / Urgent / High / Medium / Low), reformatted as tracker label strings. Lower number = higher priority, except `p0` which means "not yet assessed" rather than "most urgent" — don't read it as a priority ordering.

| Label in our tracker | Meaning                                     |
| --------------------- | --------------------------------------------- |
| `p0:no-priority`      | Not yet assessed for priority                |
| `p1:urgent`           | Drop other work; fix now                     |
| `p2:high`             | Address in the current cycle                 |
| `p3:medium`           | Normal priority; schedule as capacity allows |
| `p4:low`              | Nice to have; no urgency                     |
</content>
