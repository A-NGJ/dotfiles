---
name: skill-writing-doc
description: Compact reference of best practices for authoring Agent Skills (SKILL.md files), distilled from Anthropic's official skill-authoring guide. Use whenever writing a new skill, reviewing or improving an existing SKILL.md, deciding how to structure a skill's files, or when the user asks about skill conventions, descriptions, progressive disclosure, or skill quality — even if they don't say "best practices".
---

# Skill Writing Best Practices

Distilled from [Anthropic's skill authoring guide](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices). Apply these when writing or reviewing any SKILL.md.

## Core principles

- **Concise is key.** The context window is a shared resource: the skill body competes with the system prompt, conversation history, and other skills. Every paragraph must justify its token cost.
- **Assume Claude is already smart.** Only add context Claude doesn't have. Challenge each line: "Does Claude really need this explanation?" Don't explain what a PDF is or how pip works.
- **Explain the why, not just the what.** Reasoning transfers better than bare rules; prefer it over walls of ALL-CAPS MUSTs.
- **Match freedom to fragility:**
  - *High freedom* (prose heuristics) — many valid approaches, context-dependent decisions (e.g. code review).
  - *Medium freedom* (pseudocode / templates with parameters) — a preferred pattern exists.
  - *Low freedom* (exact scripts, "run exactly this, don't modify") — fragile, error-prone, sequence-critical operations (e.g. migrations).

## Frontmatter

- `name`: max 64 chars; lowercase letters, numbers, hyphens only; no XML tags; no reserved words ("anthropic", "claude"). Use consistent naming across your skill collection (e.g. gerund or noun-phrase style).
- `description`: non-empty, max 1,024 chars, no XML tags. **This is the sole triggering mechanism** — Claude picks this skill from potentially 100+ using only name + description.
  - Include both *what the skill does* and *when to use it*, with concrete key terms users would actually say (file types, tool names, task verbs).
  - Good: `Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.`
  - Bad: `Helps with documents`, `Processes data`.
  - Claude tends to *under*-trigger skills, so err on the side of a pushy, keyword-rich description.

## Structure and progressive disclosure

Three loading levels: metadata (always in context) → SKILL.md body (loaded on trigger) → bundled files (loaded/executed on demand).

- Keep the SKILL.md body **under 500 lines**; split overflow into `references/` files.
- SKILL.md is a table of contents: state when to read each bundled file, and link with markdown paths.
- Organize by domain/variant when a skill covers several (e.g. `references/aws.md`, `references/gcp.md`) so Claude reads only the relevant one.
- Keep file references **one level deep** — Claude may only partially read files referenced from other referenced files.
- Give reference files >300 lines a table of contents. For big reference files, offer grep patterns to find sections.
- Use forward slashes in all paths, even on Windows.

## Writing the body

- Use imperative voice; concrete examples over abstract advice.
- **Consistent terminology** — pick one term and stick with it (don't mix "field"/"box"/"element" or "extract"/"pull"/"get").
- **Templates** for output formats: strict template + "ALWAYS use this exact structure" when format matters; a flexible skeleton with "adjust as needed" when it doesn't.
- **Examples pattern**: input/output pairs, like few-shot prompting, when output quality depends on style.
- **Workflows**: number the steps; for long processes give a copyable checklist Claude checks off. Guide decision points explicitly ("Creating new content? → Creation workflow below"). Push large workflows into separate files.
- **Feedback loops**: run validator → fix → re-run until clean; "only proceed when validation passes." For high-stakes/batch operations, add a plan file step: analyze → write plan → validate plan → execute → verify.
- Provide **one default tool with an escape hatch**, not a menu of five libraries.

## Scripts and dependencies

- Bundle utility scripts for deterministic or repetitive steps — more reliable than generated code, and executing a script doesn't load it into context. Say whether each script is meant to be *executed* or *read as reference*.
- Scripts should handle their own errors (create missing files, fall back on permission errors) rather than failing and making Claude figure it out.
- No voodoo constants: justify config values in comments (`TIMEOUT = 47 # why 47?` is a bug magnet).
- Don't assume packages are installed — state the install command, then the usage.
- List required packages and mind platform limits: claude.ai can install from npm/PyPI; the Claude API code-execution environment has no network access.
- Reference MCP tools by fully qualified name (`ServerName:tool_name`) to avoid "tool not found".

## Anti-patterns

- Vague descriptions; "when to use" info buried in the body instead of the description.
- Time-sensitive content ("before August 2025 use the old API") — put legacy info in a collapsed "Old patterns" section instead.
- Windows-style paths; deeply nested file references; offering too many equivalent options.
- Over-explaining things Claude already knows; heavy-handed MUST/NEVER without reasoning.
- Overfitting the skill to the few examples you tested on — generalize from feedback.

## Evaluation and iteration

- **Build evals before writing extensive docs.** Run Claude on representative tasks *without* the skill, document the gaps, write minimal instructions to close them, measure against the baseline, iterate. Evals are the source of truth.
- Develop iteratively with Claude: one Claude helps author, a fresh Claude instance tests. Feed observed failures back as specifics ("it forgot to filter by date — add a section?").
- Watch how Claude navigates the skill in practice: unexpected read order, missed file references, and ignored instructions all signal structural problems.
- Test with every model you'll run the skill on — Haiku may need more guidance where Opus needs less.

## Pre-ship checklist

- [ ] Description is specific, includes key terms, and covers both what and when
- [ ] SKILL.md body under 500 lines; overflow in separate files
- [ ] File references one level deep; forward-slash paths
- [ ] Consistent terminology; concrete examples
- [ ] Workflows have clear steps (and checklists/validation loops where warranted)
- [ ] No time-sensitive info outside an "old patterns" section
- [ ] Scripts handle errors, document constants, state dependencies
- [ ] Tested against a no-skill baseline on realistic tasks, with all target models
