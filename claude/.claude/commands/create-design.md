---
description: Create high-level solution designs with architectural decisions and trade-off analysis
model: opus
---

# Solution Design

Create high-level solution designs by exploring trade-offs, making architectural decisions, and documenting the chosen approach. This stage bridges research findings and structural planning.

## Initial Response

If a file path, ticket reference, or research document was provided, read it fully and begin analysis. Otherwise respond:
```
I'll help you create a solution design.

Please provide:
1. The task/ticket description (or reference to a ticket file)
2. Any relevant research documents from `.thoughts/research/`
3. Constraints, non-functional requirements, or preferences

Tip: `/create-design .thoughts/research/2025-01-08-authentication-flow.md`
```

## Process Steps

### Step 1: Context Gathering

1. **Read all mentioned files fully** (no limit/offset) before spawning sub-tasks
2. **Spawn parallel research sub-tasks** using the Task tool. Each sub-task should load the appropriate skill first, then perform its work:
   - Sub-task: "Load the `locate-codebase` skill, then find components related to [task description]"
   - Sub-task (@codebase-analyzer): Understand current architecture and patterns in use
   - Sub-task: "Load the `locate-thoughts` skill, then find existing research, designs, and plans about [topic]"
   - Sub-task: "Load the `find-patterns` skill, then find how similar problems were solved in the codebase for [topic]"
3. **Read all files identified by research tasks**
4. **Present current understanding:**
   ```
   Based on the research and my analysis:

   Current architecture:
   - [Component/system description with file:line reference]
   - [Relevant pattern or convention in use]

   Constraints I've identified:
   - [Technical constraint from codebase]
   - [Requirement from ticket/user]

   Questions before I explore design options:
   - [Question requiring human judgment or domain knowledge]
   ```

### Step 2: Design Exploration

After initial clarifications:

1. **Identify the design dimensions** - what are the key decisions to make?
2. **Create a research todo list** using TodoWrite
3. **Spawn parallel sub-tasks** using the Task tool for deeper investigation:
   - Sub-task: "Load the `find-patterns` skill, then find similar patterns in the codebase or adjacent systems for [topic]"
   - Sub-task: "Load the `analyze-thoughts` skill, then extract insights from [specific document paths] about [topic]"
   - Sub-task (if needed): Research external patterns, libraries, or prior art via web
4. **Wait for ALL sub-tasks to complete** before proceeding
5. **Present design options with trade-off analysis:**
   ```
   ## Design Decisions

   ### Decision 1: [e.g., State Management Approach]

   **Option A: [Name]**
   - How it works: [description]
   - Pros: [concrete advantages]
   - Cons: [concrete disadvantages]
   - Fits existing patterns: [yes/no, with evidence]

   **Option B: [Name]**
   - How it works: [description]
   - Pros: [concrete advantages]
   - Cons: [concrete disadvantages]
   - Fits existing patterns: [yes/no, with evidence]

   **Recommendation**: [Option] because [reasoning tied to constraints]

   ### Decision 2: [next key decision]
   ...

   Which options align with your goals?
   ```

### Step 3: Design Synthesis

After user selects directions:

1. **Validate the combined choices** - do the selected options work together?
2. **Identify integration points** - where does the design touch existing systems?
3. **Present the cohesive design for buy-in:**
   ```
   Proposed design summary:

   ## Approach
   [1-3 sentence high-level description]

   ## Key Decisions
   1. [Decision]: [Chosen option] - [one-line rationale]
   2. [Decision]: [Chosen option] - [one-line rationale]

   ## Component Interactions
   [How the parts connect - data flow, dependencies, event flow]

   ## Risks & Mitigations
   - [Risk]: [Mitigation strategy]

   Does this design direction look right before I document it?
   ```

### Step 4: Write the Design Document

Save to `.thoughts/designs/YYYY-MM-DD-ENG-XXXX-description.md`
- Format: `YYYY-MM-DD-ENG-XXXX-description.md`
- Without ticket: `2025-01-08-improve-error-handling.md`

**Template:**

````markdown
---
date: [Current date and time with timezone in ISO format]
designer: [Designer name]
git_commit: [Current commit hash]
branch: [Current branch name]
repository: [Repository name]
topic: "[Feature/Task Name]"
tags: [design, architecture, relevant-component-names]
status: draft
related_research: [path to research doc if available]
last_updated: [Current date in YYYY-MM-DD format]
last_updated_by: [Designer name]
---

# Design: [Feature/Task Name]

## Overview
[Brief description of what we're designing and the problem it solves]

## Context
- **Research**: [Link to research document if available]
- **Ticket**: [Link to ticket if available]
- **Current State**: [Brief description of the current system]

## Constraints & Requirements
- [Hard constraint from the system or business]
- [Non-functional requirement: performance, security, etc.]
- [Compatibility requirement]

## Design Decisions

### Decision 1: [Decision Title]
**Chosen**: [Option name]
**Alternatives considered**: [Other options briefly]
**Rationale**: [Why this option was chosen, tied to specific constraints]
**Evidence**: [File references, benchmarks, or patterns that support this]

### Decision 2: [Decision Title]
[Same structure...]

## High-Level Architecture

### Component Overview
[Description of the main components and their responsibilities]

### Data Flow
[How data moves through the system - inputs, transformations, outputs]

### Integration Points
[Where this design touches existing systems, with file:line references]

### API Contracts (if applicable)
[Key interfaces, function signatures, or API shapes that other components depend on]

## Risks & Mitigations
| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| [Risk description] | [High/Med/Low] | [High/Med/Low] | [Strategy] |

## What This Design Does NOT Cover
[Explicit out-of-scope items to prevent scope creep]

## Open Questions
[Any remaining questions - ideally empty before handoff to structure/plan stage]

## References
- Research: `[path to research doc]`
- Similar implementation: `[file:line]`
- External reference: [link if applicable]
````

### Step 5: Review & Iterate

1. Present the draft design document location
2. Iterate based on feedback
3. Resolve all open questions before marking status as `complete`
4. Continue until user is satisfied

## Guidelines

1. **Be Opinionated**: Present recommendations with clear reasoning, not just neutral options
2. **Be Interactive**: Get buy-in on key decisions before documenting the full design
3. **Be Evidence-Based**: Ground decisions in codebase patterns, constraints, and concrete trade-offs
4. **Be Focused**: Design at the right level of abstraction - architecture and key interfaces, not implementation details
5. **No Open Questions**: Resolve all questions before finalizing (mark status as `complete`)
6. **Respect Existing Patterns**: Prefer solutions that align with how the codebase already works unless there's a strong reason to diverge

## Common Design Patterns

**Data Pipeline:** Source -> Ingestion -> Transform -> Storage -> Query -> Presentation

**New Service/Module:** Identify boundary -> Define interface -> Design internals -> Plan integration

**Refactoring:** Map current state -> Identify target state -> Design migration path -> Define compatibility layer
