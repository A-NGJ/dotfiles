---
description: Create implementation plans — works standalone for simple tasks or with prior design docs for complex ones
model: opus
---

# Implementation Plan

Create implementation plans with phased tasks, success criteria, and verification steps.

**Two modes — auto-detected from input:**

- **Standalone mode**: For simple/short tasks. You describe what needs to be done, the plan does its own lightweight research and produces a plan directly. No prior `/research-codebase` or `/create-design` needed.
- **Pipeline mode**: For complex tasks with existing docs. You provide a design document from the pipeline (research -> design -> plan -> implement). Structure docs from `/create-structure` are also accepted if available.

## Initial Response

When this command is invoked:

1. **Check what was provided:**
   - If a path to a design document (or structure document) was provided → **Pipeline mode**
   - If a plain task description or ticket reference was provided → **Standalone mode**
   - If nothing was provided, respond:
   ```
   I'll help you create an implementation plan.

   You can use this in two ways:

   **Simple task** (standalone):
   `/create-plan Add a retry mechanism to the webhook handler`
   `/create-plan .thoughts/tickets/eng-1234.md`

   **Complex task** (with prior docs from the pipeline):
   `/create-plan .thoughts/designs/2025-01-08-feature-name.md`
   ```

---

## Standalone Mode

For tasks that don't need a full research -> design -> structure pipeline. Typically: bug fixes, small features, refactors, config changes, adding tests, etc.

### Step 1: Understand the Task

1. **Read project conventions** — check for `CLAUDE.md` in the project root and note the actual commands for running tests, type checking, and linting. These will be used in success criteria instead of generic placeholders.
2. **Read any provided files fully** (tickets, referenced files, etc.)
3. **Research proportional to complexity** — scale effort to what the task actually needs:
   - **Obvious** (specific file/function named, single localized change): read those files directly, no sub-tasks needed
   - **Moderate** (area known, pattern unclear): spawn 1-2 targeted sub-tasks as needed
   - **Cross-cutting** (multiple systems, unclear file landscape): spawn all three in parallel:
     - Sub-task: "Load the `locate-codebase` skill, then find files related to [task]"
     - Sub-task: "Load the `find-patterns` skill, then find how similar things are done in the codebase for [task]"
     - Sub-task (@codebase-analyzer): Understand the specific code that needs to change
4. **Read the key files** identified by research
5. **If the task is ambiguous or you have questions**, present findings before proceeding:
   ```
   Here's what I found:

   Relevant files:
   - `path/to/file.ext:line` — [what it does, what needs to change]
   - `path/to/other.ext:line` — [what it does, what needs to change]

   Existing patterns:
   - [How similar things are handled in the codebase]

   My approach:
   - [1-3 sentences on what the plan will do]

   Questions before I write the plan:
   - [specific ambiguity to resolve]
   ```
   If everything is clear with no open questions, skip this step and write the plan directly.

### Step 2: Write the Plan

After understanding is confirmed (or immediately if the task is unambiguous):

1. **Break the work into phases** (often just 1-2 for simple tasks)
2. **Write the plan** to `.thoughts/plans/YYYY-MM-DD-description.md`
3. Use the **Standalone plan template** below

### Step 3: Review & Iterate

Present the plan with a brief summary:
```
Plan saved: `.thoughts/plans/YYYY-MM-DD-description.md`

Phases:
- Phase 1: [name] — [what it does] ([scope])

Anything you'd like to adjust?
```

When revising based on feedback:
- **Scope change** (add/remove tasks): update the Scope line and affected phase tasks
- **Approach change**: re-research if needed — say so rather than guessing
- Keep iterating until the user confirms or stops giving feedback

### Standalone Plan Template

````markdown
# [Task Name] Implementation Plan

## Overview
[1-2 sentence summary of what we're implementing and why]

## Context
- **Task**: [Original task description or ticket reference]
- **Scope**: [e.g. "2 files modified", "1 new file + 3 modified", "single function"]
- **Key files**: [Most important files involved]

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Tasks:

#### 1. [Component/File Group]
**File**: `path/to/file.ext`
**Changes**: [Summary of what to do]

```[language]
// Key code to add/modify
```

#### 2. [Tests]
**File**: `path/to/test_file.ext`
**Changes**: [Unit tests, integration tests, and edge cases for everything introduced in this phase]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `[actual test command from CLAUDE.md]`
- [ ] Type checking: `[actual typecheck command from CLAUDE.md]`
- [ ] Linting: `[actual lint command from CLAUDE.md]`

#### Manual Verification:
- [ ] [Specific thing to verify]

### Commit:
- [ ] Stage: [files changed in this phase]
- [ ] Message: `[type]: [what this phase accomplished]`

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name] (if needed)
[Same structure as Phase 1]

## References
- [file:line references to key code]
````

---

## Pipeline Mode

For complex tasks that already went through `/research-codebase` and `/create-design` (and optionally `/create-structure`).

### Step 1: Read Inputs & Validate

1. **Read project conventions** — check for `CLAUDE.md` in the project root and note the actual commands for running tests, type checking, and linting. These will be used in success criteria instead of generic placeholders.

2. **Read all provided documents immediately and FULLY**:
   - Design documents (primary input)
   - Structure documents (if available — provides file layout and interface details)
   - Research documents (linked from design doc)
   - Original ticket files (if referenced)
   - **IMPORTANT**: Read entire files — no limit/offset
   - **CRITICAL**: Read these yourself before spawning sub-tasks

3. **Spot-check critical files from the design doc** (or structure doc if available):
   - Read 3-5 of the most important files mentioned
   - Verify the codebase still matches what the docs describe
   - If anything has drifted significantly, flag it immediately

4. **Present validation results**:
   ```
   I've read the pipeline docs:
   - Research: [path] — [topic summary]
   - Design: [path] — [key decisions: A, B, C]
   - Structure: [path] — [N modified files, M new files, key interfaces] (if available)

   Validation against current codebase:
   - [file:line] — confirmed, matches docs
   - [file:line] — DRIFT DETECTED: [explanation]

   Questions before I define phases:
   - [Phasing/ordering questions only — design decisions are already made]
   ```

### Step 2: Phase Definition

1. **Create a planning todo list** using TodoWrite
2. **Break the design's changes into ordered phases:**
   - Group related changes that must ship together
   - Respect dependency order (data model -> business logic -> API -> UI)
   - Each phase should leave the codebase in a working, testable state
   - Include tests in the same phase as the code they test — do not put tests in a separate phase or bottom section
   - If a structure doc is available, use its file listings; otherwise, identify files from the design doc's architecture/integration sections
3. **Present proposed phases for buy-in:**
   ```
   Proposed phases:

   ## Phase 1: [Name] — [what it accomplishes]
   Files: [list from design/structure doc]
   Depends on: nothing (foundation)

   ## Phase 2: [Name] — [what it accomplishes]
   Files: [list from design/structure doc]
   Depends on: Phase 1

   Does this phasing make sense?
   ```

### Step 3: Success Criteria & Verification

After phase buy-in:

1. **Define success criteria for each phase:**
   - **Automated Verification**: Use actual commands from `CLAUDE.md` (tests, linting, type checking, build)
   - **Manual Verification**: Human testing steps (UI, edge cases, integration)
2. **Define commit strategy per phase**
3. **Present for review**

### Step 4: Write the Plan

Save to `.thoughts/plans/YYYY-MM-DD-ENG-XXXX-description.md`

Use the **Pipeline plan template** below.

### Pipeline Plan Template

````markdown
# [Feature/Task Name] Implementation Plan

## Overview
[Brief description — reference the design doc for full context]
**Scope**: [N files modified, M new files — summarised from design/structure doc]

## Source Documents
- **Research**: `[path]` — [1-line summary]
- **Design**: `[path]` — [key decisions]
- **Structure**: `[path]` — [scope summary]
- **Ticket**: `[path]` (if applicable)

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes and why it comes first]

### Tasks:

#### 1. [Component/File Group]
**File**: `path/to/file.ext` (see design doc for interface details)
**Changes**: [Summary of what to do]

```[language]
// Key code to add/modify
```

#### 2. [Tests]
**File**: `path/to/test_file.ext`
**Changes**: [Unit tests, integration tests, and edge cases for everything introduced in this phase]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `[actual test command from CLAUDE.md]`
- [ ] Type checking: `[actual typecheck command from CLAUDE.md]`
- [ ] Linting: `[actual lint command from CLAUDE.md]`

#### Manual Verification:
- [ ] [Specific thing to verify]

### Commit:
- [ ] Stage: [files changed in this phase]
- [ ] Message: `[type]: [what this phase accomplished]`

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name]

### Overview
[What this phase accomplishes]
[Dependencies on prior phases]

### Tasks:
[Same structure as Phase 1 — including tests for this phase's changes]

### Success Criteria:
[Same structure as Phase 1]

### Commit:
- [ ] Stage: [files changed in this phase]
- [ ] Message: `[type]: [what this phase accomplished]`

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Migration Notes (if applicable)
[Ordering concerns, backward compatibility, rollback strategy]

## References
- Research: `[path to research doc]`
- Design: `[path to design doc]`
- Structure: `[path to structure doc]` (if available)
- Original ticket: `[path to ticket]`
- Similar implementation: `[file:line]`
````

### Step 5: Review & Iterate

Present the plan with a brief summary:
```
Plan saved: `.thoughts/plans/YYYY-MM-DD-description.md`

Phases:
- Phase 1: [name] — [what it does] ([N files])
- Phase 2: [name] — [what it does] ([N files])

Anything you'd like to adjust?
```

When revising based on feedback:
- **Phase reordering**: update dependencies and the "why it comes first" rationale
- **Scope change** (add/remove tasks): update the Scope line and affected phase tasks
- **Approach change**: re-research if needed — say so rather than guessing
- Keep iterating until the user confirms or stops giving feedback

---

## Guidelines (Both Modes)

1. **Be Interactive**: Get buy-in on approach/phases before writing the full plan
2. **Be Practical**: Focus on incremental, testable changes that keep the codebase working
3. **Separate Verification**: Always split success criteria into automated and manual
4. **No Open Questions**: Resolve ambiguity before finalizing — ask the user if needed
5. **Right-size the Plan**: Simple tasks get simple plans (1 phase, minimal ceremony). Complex tasks get detailed phasing with full verification
6. **Commit After Each Phase**: Every phase ends with a commit step — stage only that phase's files, not everything at once
7. **Tests Belong to Their Phase**: Write tests alongside the code they cover, not in a separate section at the bottom

### Pipeline Mode Only
8. **Trust Prior Stages**: Don't redo research or design work — reference those docs
9. **Spot-check Reality**: Verify the codebase still matches the design doc before planning
