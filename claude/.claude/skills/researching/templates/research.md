<!-- Filing rules — delete this block when you write the artifact.

Destination: `.pakt/research/`, creating the directory if it does not exist.
Filename:    `YYYY-MM-DD-<topic-slug>.md`, e.g. `2026-03-13-auth-flow.md`. The
             slug is the topic lowercased with every run of non-alphanumeric
             characters replaced by a single hyphen.
Never clobber: if that path already exists, do not overwrite it — surface the
             collision and either extend the existing artifact or choose a
             distinct name.
Frontmatter: all four fields are required and no others are carried. `date` is
             an RFC 3339 timestamp with timezone. `tags` always begins with
             `research`; append further tags after it. `status` starts at
             `draft` and moves to `active` once the findings are filled in.
Optional:    `## Decisions` — delete the whole section when nothing was settled.
-->
---
date: <RFC 3339 timestamp, e.g. 2026-03-13T10:04:00+01:00>
topic: "<topic>"
tags: [research]
status: draft
---

# Research: <topic>

## Research Question
<!-- TODO: the specific question being investigated -->

## Problem Statement
<!-- TODO: the refined problem statement from the discovery interview -->

## Summary
<!-- TODO: fill in after research is complete -->

## Detailed Findings
<!-- TODO: findings organized by category -->

## Assessment
<!-- TODO: what the findings mean -->

## Suggested Next Steps
<!-- TODO: recommended next actions -->

## Decisions
<!-- TODO: Optional — key decisions settled during research, as self-contained
one-line statements ("Decided X because Y") so they can be quoted forward without
surrounding context. Omit this section when there is nothing to record. -->
