---
description: Create detailed implementation plans through interactive research and iteration
model: opus
---

# Implementation Plan

Create detailed, phased implementation plans that define the order of work, success criteria, and verification steps. This stage takes approved design and structure documents and turns them into an actionable execution guide.

**This stage does NOT own**: codebase research (→ `/research-codebase`), architectural decisions (→ `/create-design`), or file/module layout (→ `/create-structure`).

**This stage OWNS**: phasing, task ordering, dependency sequencing, implementation code snippets, success criteria, verification steps, and commit strategy.

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a file path to a structure or design document was provided, skip the default message
   - Immediately read the provided files FULLY
   - Begin the validation process

2. **If no parameters provided**, respond with:
```
I'll help you create a detailed implementation plan.

Please provide:
1. The structure document from `.claude/thoughts/shared/structures/`
2. The design document from `.claude/thoughts/shared/designs/` (if not linked in structure doc)
3. Any additional constraints on phasing or ordering

Tip: `/create-plan thoughts/shared/structures/2025-01-08-feature-name.md`
```

Then wait for the user's input.

## Process Steps

### Step 1: Read Inputs & Validate

1. **Read all provided documents immediately and FULLY**:
   - Structure documents (primary input)
   - Design documents (linked from structure doc or provided separately)
   - Research documents (linked from design doc)
   - Original ticket files (if referenced)
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: DO NOT spawn sub-tasks before reading these files yourself in the main context
   - **NEVER** read files partially - if a file is mentioned, read it completely

2. **Spot-check critical files from the structure doc**:
   - Read 3-5 of the most important files listed in the structure doc
   - Verify the codebase still matches what the structure doc describes
   - Check that integration points are where the structure doc says they are
   - If anything has drifted significantly, flag it immediately

3. **Present validation results**:
   ```
   I've read the full pipeline docs:
   - Research: [path] — [topic summary]
   - Design: [path] — [key decisions: A, B, C]
   - Structure: [path] — [N modified files, M new files, key interfaces]

   Validation against current codebase:
   - [file:line] — confirmed, matches structure doc
   - [file:line] — confirmed, matches structure doc
   - [file:line] — DRIFT DETECTED: [explanation of what changed]

   Questions before I define phases:
   - [Phasing question, e.g., "Should we parallelize the API and UI work?"]
   - [Constraint question, e.g., "Any deployment ordering requirements?"]
   ```

   Only ask questions about phasing and ordering — design and structure decisions are already made.

### Step 2: Phase Definition

After getting initial clarifications:

1. **If the user flags any drift issues**:
   - Read the specific files they mention to understand the current state
   - Adjust phasing accordingly
   - Do NOT redesign or restructure — flag back to those stages if changes are needed

2. **Create a planning todo list** using TodoWrite to track phase definition tasks

3. **Break the structure doc's file changes into ordered phases**:
   - Group related changes that must ship together for correctness
   - Respect dependency order (data model → business logic → API → UI)
   - Each phase should leave the codebase in a working, testable state
   - Keep phases small enough to verify independently but large enough to be meaningful
   - Include test changes in the same phase as the code they test

4. **Present proposed phases for buy-in**:
   ```
   Here's my proposed phasing:

   ## Phase 1: [Descriptive Name]
   [What this phase accomplishes]
   Files: [list from structure doc]
   Depends on: nothing (foundation)

   ## Phase 2: [Descriptive Name]
   [What this phase accomplishes]
   Files: [list from structure doc]
   Depends on: Phase 1

   ## Phase 3: [Descriptive Name]
   [What this phase accomplishes]
   Files: [list from structure doc]
   Depends on: Phase 1, Phase 2

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

5. **Get feedback on phases** before writing detailed success criteria

### Step 3: Success Criteria Development

Once phases are approved:

1. **Define success criteria for each phase**, separated into:
   - **Automated Verification**: Commands that can be run (tests, linting, type checking, build)
   - **Manual Verification**: Human testing steps (UI, edge cases, integration behavior)

2. **Define commit strategy per phase**:
   - Number of commits (one per logical unit of change)
   - Draft commit messages
   - Which files go in each commit

3. **Present criteria for review**:
   ```
   Phase 1 success criteria:

   Automated:
   - [ ] [Specific command]: `make test-unit`
   - [ ] [Specific command]: `npm run typecheck`

   Manual:
   - [ ] [Specific human verification step]
   - [ ] [Specific edge case to test]

   Commits:
   1. "[message]" — [files]
   2. "[message]" — [files]
   ```

### Step 4: Detailed Plan Writing

After criteria approval:

1. **Write the plan** to `.claude/thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`
   - Format: `YYYY-MM-DD-ENG-XXXX-description.md` where:
     - YYYY-MM-DD is today's date
     - ENG-XXXX is the ticket number (omit if no ticket)
     - description is a brief kebab-case description
   - Examples:
     - With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
     - Without ticket: `2025-01-08-improve-error-handling.md`

2. **Use this template structure**:

````markdown
# [Feature/Task Name] Implementation Plan

## Overview

[Brief description of what we're implementing — reference the design doc for full context]

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
**File**: `path/to/file.ext` (see structure doc for interface details)
**Changes**: [Summary of what to do]

```[language]
// Key code to add/modify (only when specificity helps the implementer)
```

#### 2. [Component/File Group tests]
**File**: `path/to/test_file.ext`
**Changes**: [Summary of test additions]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `make test`
- [ ] Type checking passes: `npm run typecheck`
- [ ] Linting passes: `make lint`

#### Manual Verification:
- [ ] [Specific manual verification step]
- [ ] [Edge case to verify]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name]

### Overview
[What this phase accomplishes]
[Dependencies on prior phases]

### Tasks:
[Same task structure as Phase 1...]

### Success Criteria:
[Same criteria structure as Phase 1...]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Testing Strategy

### Unit Tests:
- [What to test, key edge cases]
- References to test tasks in each phase

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing Steps:
1. [Specific step to verify feature]
2. [Another verification step]
3. [Edge case to test manually]

## Migration Notes (if applicable)

[Ordering concerns, backward compatibility, rollback strategy]

## References

- Research: `[path to research doc]`
- Design: `[path to design doc]`
- Structure: `[path to structure doc]`
- Original ticket: `[path to ticket]`
- Similar implementation: `[file:line]`
````

### Step 5: Sync and Review

1. **Present the draft plan location**:
   ```
   I've created the implementation plan at:
   `thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`

   Please review:
   - Are the phases properly scoped and ordered?
   - Are the success criteria specific enough?
   - Is the commit strategy reasonable?
   - Missing edge cases or verification steps?
   ```

2. **Iterate based on feedback** - be ready to:
   - Reorder phases
   - Split or merge phases
   - Adjust success criteria (both automated and manual)
   - Refine commit strategy

3. **Continue refining** until the user is satisfied

## Important Guidelines

1. **Trust Prior Stages**:
   - Don't redo research — the research doc has the findings
   - Don't revisit design decisions — the design doc has the rationale
   - Don't redefine file structure — the structure doc has the layout
   - Only flag back to those stages if you discover they're outdated

2. **Be Interactive**:
   - Don't write the full plan in one shot
   - Get buy-in on phases first, then criteria, then write
   - Allow course corrections

3. **Be Thorough**:
   - Read all source documents COMPLETELY before planning
   - Spot-check the codebase to validate structure doc accuracy
   - Write measurable success criteria with clear automated vs manual distinction
   - Include specific file paths from the structure doc

4. **Be Practical**:
   - Focus on incremental, testable changes
   - Each phase must leave the codebase in a working state
   - Consider migration ordering and rollback
   - Think about what happens if we stop after any given phase

5. **No Open Questions in Final Plan**:
   - If you encounter ambiguity, check the design/structure docs first
   - If those don't answer it, ask the user
   - Do NOT write the plan with unresolved questions
   - Every phasing decision must be made before finalizing

## Success Criteria Guidelines

**Always separate success criteria into two categories:**

1. **Automated Verification** (can be run by execution agents):
   - Commands that can be run: `make test`, `npm run lint`, etc.
   - Specific files that should exist
   - Code compilation/type checking
   - Automated test suites

2. **Manual Verification** (requires human testing):
   - UI/UX functionality
   - Performance under real conditions
   - Edge cases that are hard to automate
   - User acceptance criteria

**Format example:**
```markdown
### Success Criteria:

#### Automated Verification:
- [ ] Database migration runs successfully: `make migrate`
- [ ] All unit tests pass: `go test ./...`
- [ ] No linting errors: `golangci-lint run`
- [ ] API endpoint returns 200: `curl localhost:8080/api/new-endpoint`

#### Manual Verification:
- [ ] New feature appears correctly in the UI
- [ ] Performance is acceptable with 1000+ items
- [ ] Error messages are user-friendly
- [ ] Feature works correctly on mobile devices
```
