---
description: Create implementation plans — works standalone for simple tasks or with prior design/structure docs for complex ones
agent: build
---

# Implementation Plan

Create implementation plans with phased tasks, success criteria, and verification steps.

**Two modes — auto-detected from input:**

- **Standalone mode**: For simple/short tasks. You describe what needs to be done, the plan does its own lightweight research and produces a plan directly. No prior `/research-codebase`, `/create-design`, or `/create-structure` needed.
- **Pipeline mode**: For complex tasks with existing docs. You provide a design or structure document from the full pipeline (research -> design -> structure -> plan -> implement).

## Initial Response

When this command is invoked:

1. **Check what was provided:**
   - If a path to a structure or design document was provided → **Pipeline mode**
   - If a plain task description or ticket reference was provided → **Standalone mode**
   - If nothing was provided, respond:
   ```
   I'll help you create an implementation plan.

   You can use this in two ways:

   **Simple task** (standalone):
   `/create-plan Add a retry mechanism to the webhook handler`
   `/create-plan .thoughts/tickets/eng-1234.md`

   **Complex task** (with prior docs from the pipeline):
   `/create-plan .thoughts/structures/2025-01-08-feature-name.md`
   `/create-plan .thoughts/designs/2025-01-08-feature-name.md`
   ```

---

## Standalone Mode

For tasks that don't need a full research -> design -> structure pipeline. Typically: bug fixes, small features, refactors, config changes, adding tests, etc.

### Step 1: Understand the Task

1. **Read any provided files fully** (tickets, referenced files, etc.)
2. **Do lightweight codebase research** — spawn parallel sub-tasks:
   - Sub-task: "Load the `locate-codebase` skill, then find files related to [task]"
   - Sub-task: "Load the `find-patterns` skill, then find how similar things are done in the codebase for [task]"
   - Sub-task (@codebase-analyzer): Understand the specific code that needs to change
3. **Read the key files** identified by research
4. **Present your understanding:**
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
   - [Only if genuinely ambiguous — skip if clear enough]
   ```

### Step 2: Write the Plan

After understanding is confirmed (or immediately if no questions):

1. **Break the work into phases** (often just 1-2 for simple tasks)
2. **Write the plan** to `.thoughts/plans/YYYY-MM-DD-description.md`
3. Use the **Standalone plan template** below

### Standalone Plan Template

````markdown
# [Task Name] Implementation Plan

## Overview
[1-2 sentence summary of what we're implementing and why]

## Context
- **Task**: [Original task description or ticket reference]
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
**Changes**: [Summary of test additions]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `[test command]`
- [ ] Type checking: `[typecheck command]`
- [ ] Linting: `[lint command]`

#### Manual Verification:
- [ ] [Specific thing to verify]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name] (if needed)
[Same structure as Phase 1]

## References
- [file:line references to key code]
````

---

## Pipeline Mode

For complex tasks that already went through `/research-codebase`, `/create-design`, and/or `/create-structure`.

### Step 1: Read Inputs & Validate

1. **Read all provided documents immediately and FULLY**:
   - Structure documents (primary input)
   - Design documents (linked from structure doc or provided separately)
   - Research documents (linked from design doc)
   - Original ticket files (if referenced)
   - **IMPORTANT**: Read entire files — no limit/offset
   - **CRITICAL**: Read these yourself before spawning sub-tasks

2. **Spot-check critical files from the structure doc**:
   - Read 3-5 of the most important files listed
   - Verify the codebase still matches what the docs describe
   - If anything has drifted significantly, flag it immediately

3. **Present validation results**:
   ```
   I've read the pipeline docs:
   - Research: [path] — [topic summary]
   - Design: [path] — [key decisions: A, B, C]
   - Structure: [path] — [N modified files, M new files, key interfaces]

   Validation against current codebase:
   - [file:line] — confirmed, matches docs
   - [file:line] — DRIFT DETECTED: [explanation]

   Questions before I define phases:
   - [Phasing/ordering questions only — design decisions are already made]
   ```

### Step 2: Phase Definition

1. **Create a planning todo list** using TodoWrite
2. **Break the structure doc's file changes into ordered phases:**
   - Group related changes that must ship together
   - Respect dependency order (data model -> business logic -> API -> UI)
   - Each phase should leave the codebase in a working, testable state
   - Include test changes in the same phase as the code they test
3. **Present proposed phases for buy-in:**
   ```
   Proposed phases:

   ## Phase 1: [Name] — [what it accomplishes]
   Files: [list from structure doc]
   Depends on: nothing (foundation)

   ## Phase 2: [Name] — [what it accomplishes]
   Files: [list from structure doc]
   Depends on: Phase 1

   Does this phasing make sense?
   ```

### Step 3: Success Criteria & Verification

After phase buy-in:

1. **Define success criteria for each phase:**
   - **Automated Verification**: Commands that can be run (tests, linting, type checking, build)
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
// Key code to add/modify
```

#### 2. [Tests]
**File**: `path/to/test_file.ext`
**Changes**: [Summary of test additions]

### Success Criteria:

#### Automated Verification:
- [ ] Tests pass: `make test`
- [ ] Type checking: `npm run typecheck`
- [ ] Linting: `make lint`

#### Manual Verification:
- [ ] [Specific thing to verify]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Phase 2: [Descriptive Name]

### Overview
[What this phase accomplishes]
[Dependencies on prior phases]

### Tasks:
[Same structure as Phase 1]

### Success Criteria:
[Same structure as Phase 1]

**Note**: Pause for manual confirmation before proceeding to next phase.

---

## Testing Strategy

### Unit Tests:
- [What to test, key edge cases]

### Integration Tests:
- [End-to-end scenarios]

### Manual Testing:
1. [Specific verification step]
2. [Edge case to test]

## Migration Notes (if applicable)
[Ordering concerns, backward compatibility, rollback strategy]

## References
- Research: `[path to research doc]`
- Design: `[path to design doc]`
- Structure: `[path to structure doc]`
- Original ticket: `[path to ticket]`
- Similar implementation: `[file:line]`
````

### Step 5: Review & Iterate

1. Present the draft plan location
2. Iterate based on feedback
3. Continue until user is satisfied

---

## Guidelines (Both Modes)

1. **Be Interactive**: Get buy-in on approach/phases before writing the full plan
2. **Be Practical**: Focus on incremental, testable changes that keep the codebase working
3. **Separate Verification**: Always split success criteria into automated and manual
4. **No Open Questions**: Resolve ambiguity before finalizing — ask the user if needed
5. **Right-size the Plan**: Simple tasks get simple plans (1 phase, minimal ceremony). Complex tasks get detailed phasing with full verification

### Pipeline Mode Only
6. **Trust Prior Stages**: Don't redo research, design, or structure work — reference those docs
7. **Spot-check Reality**: Verify the codebase still matches the structure doc before planning
