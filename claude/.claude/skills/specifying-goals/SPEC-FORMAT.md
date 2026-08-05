# Spec format — the living spec

A behavioral contract that outlives the envelope. It describes what a user
can observe, never how the code achieves it.

```yaml
---
feature: <kebab-case-name>   # also the filename: specs/<feature>.md
---
```

## Problem Statement

The problem the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story in the format:

1. As an <actor>, I want <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that
   I can make better informed decisions about my spending
</user-story-example>

The list is exhaustive when every actor the feature touches has stories for
its happy paths, edge cases, and error states — stop only when another pass
over the feature yields no new story.

The test for every story: could someone verify it by using the software,
without reading the source? Domain terms, screen states, command output, and
file contents a user would see all pass; structs, function names, and
internal file paths belong in the envelope's Scope instead.

## Constraints

Conditions that must hold across all stories (performance bounds,
compatibility, invariants).

## Out of Scope

What this feature deliberately does not do — the boundary that keeps future
readers from inferring intent that was never there.
