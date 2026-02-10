---
name: find-patterns
description: Find similar implementations, usage examples, or existing code patterns that can be modeled after. Returns concrete code snippets with file:line references. Use when you need to understand how something is currently done in the codebase.
---

## What I Do

Find code patterns and examples in the codebase that can serve as templates or inspiration. I locate similar implementations and extract concrete, reusable snippets with full context.

## Search Strategy

### Step 1: Identify Pattern Types
Based on the request, determine what to search for:
- **Feature patterns**: Similar functionality elsewhere
- **Structural patterns**: Component/class organization
- **Integration patterns**: How systems connect
- **Testing patterns**: How similar things are tested

### Step 2: Search
- Use grep to find keywords, function names, patterns
- Use glob for file patterns
- Use list to explore directory structures

### Step 3: Read and Extract
- Read files with promising patterns
- Extract the relevant code sections
- Note the context and usage
- Identify variations across the codebase

## Output Format

```
## Pattern Examples: [Pattern Type]

### Pattern 1: [Descriptive Name]
**Found in**: `src/api/users.js:45-67`
**Used for**: [What this pattern accomplishes]

[code snippet]

**Key aspects**:
- [Aspect 1]
- [Aspect 2]

### Pattern 2: [Alternative Approach]
**Found in**: `src/api/products.js:89-120`
**Used for**: [What this pattern accomplishes]

[code snippet]

### Testing Patterns
**Found in**: `tests/api/pagination.test.js:15-45`

[test code example]

### Pattern Usage in Codebase
- **[Variation A]**: Found in [locations]
- **[Variation B]**: Found in [locations]

### Related Utilities
- `src/utils/helper.js:12` - Shared helpers used by this pattern
```

## Pattern Categories to Search

### API Patterns
Route structure, middleware, error handling, authentication, validation, pagination

### Data Patterns
Database queries, caching, data transformation, migrations

### Component Patterns
File organization, state management, event handling, lifecycle, hooks

### Testing Patterns
Unit test structure, integration test setup, mock strategies, assertions

## Rules

- Show working code — not just snippets
- Include context — where patterns are used in the codebase
- Show multiple variations that exist
- Include test patterns alongside implementation patterns
- Full file paths with line numbers
- Don't recommend one pattern over another — just show what exists
- Don't critique or evaluate pattern quality
- Don't skip test examples
