---
description: Create phased implementation plans with success criteria from approved design and structure docs
model: opus
---

# Implementation Plan

Create phased implementation plans that define the order of work, success criteria, and verification steps. This stage takes approved design and structure documents and turns them into an actionable, phase-by-phase execution guide.

**This stage does NOT own**: codebase research (→ `/research-codebase`), architectural decisions (→ `/create-design`), or file/module layout (→ `/create-structure`).

**This stage OWNS**: phasing, task ordering, dependency sequencing, implementation code snippets, success criteria, verification steps, and commit strategy.

## Initial Response

If a design or structure document path was provided, read it fully and begin. Otherwise respond:
```
I'll help you create a phased implementation plan.

Please provide:
1. The structure document from `.claude/thoughts/shared/structures/`
2. The design document from `.claude/thoughts/shared/designs/` (if not linked in structure doc)

Tip: `/create-plan thoughts/shared/structures/2025-01-08-authentication-flow.md`
```

## Process Steps

### Step 1: Read Inputs & Validate

1. **Read the structure document fully** (no limit/offset)
2. **Read the linked design document fully**
3. **Read the linked research document** if available
4. **Spot-check key files** from the structure doc to confirm they still match reality:
   - Read 2-3 of the most critical files listed in the structure doc
   - If anything has drifted, flag it before proceeding
5. **Present readiness:**
   ```
   I've read the design and structure docs:
   - Design: [path] — [1-line summary of approach]
   - Structure: [path] — [N modified files, M new files]

   Validation:
   - [Confirmed: key files match structure doc] or [Drift detected: explanation]

   Ready to define phases. Any constraints on ordering or phase size?
   ```

### Step 2: Phase Definition

1. **Create a todo list** using TodoWrite to track planning decisions
2. **Break the structure doc's file changes into ordered phases:**
   - Group related changes that must ship together
   - Respect dependency order (foundations before consumers)
   - Keep phases small enough to verify independently
   - Each phase should leave the codebase in a working state
3. **Present proposed phases for buy-in:**
   ```
   Proposed phases:

   ## Phase 1: [Name] — [what it accomplishes]
   - [File/component changes in this phase]
   - Depends on: nothing (foundation)

   ## Phase 2: [Name] — [what it accomplishes]
   - [File/component changes in this phase]
   - Depends on: Phase 1

   ## Phase 3: [Name] — [what it accomplishes]
   - [File/component changes in this phase]
   - Depends on: Phase 1, 2

   Does this phasing make sense? Should I adjust the order or granularity?
   ```

### Step 3: Success Criteria & Verification

After phase buy-in:

1. **Define success criteria for each phase:**
   - Automated checks (tests, linting, type checking, build)
   - Manual verification steps (UI testing, edge cases, integration)
2. **Define the commit strategy:**
   - How many commits per phase
   - Commit message conventions
3. **Present for review:**
   ```
   Success criteria for Phase 1:

   Automated: [list of commands]
   Manual: [list of human verification steps]
   Commit: [number of commits, brief message drafts]

   [Repeat for each phase]

   Are these criteria specific enough?
   ```

### Step 4: Write the Plan

Save to `.claude/thoughts/shared/plans/YYYY-MM-DD-ENG-XXXX-description.md`
- Format: `YYYY-MM-DD-ENG-XXXX-description.md`
- Without ticket: `2025-01-08-improve-error-handling.md`

**Template:**

````markdown
# [Feature/Task Name] Implementation Plan

## Overview
[1-2 sentence summary of what's being implemented]

## Source Documents
- **Design**: `[path to design doc]` — [key decisions summary]
- **Structure**: `[path to structure doc]` — [file change summary]
- **Research**: `[path to research doc]` (if applicable)

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes and why it comes first]

### Tasks:

#### 1. [Component/File Group]
**File**: `path/to/file.ext` (see structure doc for interface details)
**Changes**: [Summary of what to do]

```[language]
// Implementation code to add/modify
// The structure doc defines the interface; this is the concrete implementation
```

#### 2. [Component/File Group tests]
**File**: `path/to/test_file.ext`
**Changes**: [Summary of test additions]

```[language]
// Test code to add
```

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `make test`
- [ ] Type checking: `npm run typecheck`
- [ ] Linting: `make lint`

#### Manual Verification:
- [ ] [Specific thing to verify manually]
- [ ] [Edge case to test]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name]

### Overview
[What this phase accomplishes]
[Dependencies on prior phases]

### Tasks:
[Same task structure as Phase 1 — file, changes summary, implementation code]

### Success Criteria:

#### Automated Verification:
- [ ] [Specific automated check]

#### Manual Verification:
- [ ] [Specific manual check]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Testing Strategy

### Unit Tests:
- [What to test, key edge cases]
- References to test tasks in each phase

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing:
1. [Specific verification step]
2. [Another verification step]

## Migration Notes (if applicable)
[Ordering concerns, backward compatibility steps, rollback strategy]

## References
- Design: `[path to design doc]`
- Structure: `[path to structure doc]`
- Research: `[path to research doc]`
- Original ticket: `[path to ticket]`
````

### Step 5: Review & Iterate

1. Present the draft plan location
2. Iterate based on feedback
3. Continue until user is satisfied

## Guidelines

1. **Trust Prior Stages**: Don't redo research, design, or structure work — reference those docs
2. **Be Interactive**: Get buy-in on phases before writing the full plan
3. **Be Practical**: Focus on incremental, testable changes that keep the codebase working
4. **Separate Verification**: Always split success criteria into automated and manual
5. **No Open Questions**: If you discover ambiguity, resolve it before finalizing — check the design/structure docs first, ask the user only if they don't answer it
