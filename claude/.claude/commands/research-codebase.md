---
description: Document codebase as-is with thoughts directory for historical context
model: opus
---

# Research Codebase

You are tasked with conducting comprehensive research across the codebase to answer user questions by spawning parallel sub-agents and synthesizing their findings.

## CRITICAL: YOUR ONLY JOB IS TO DOCUMENT AND EXPLAIN THE CODEBASE AS IT EXISTS TODAY
- DO NOT suggest improvements or changes unless the user explicitly asks for them
- DO NOT perform root cause analysis unless the user explicitly asks for them
- DO NOT propose future enhancements unless the user explicitly asks for them
- DO NOT critique the implementation or identify problems
- DO NOT recommend refactoring, optimization, or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact
- You are creating a technical map/documentation of the existing system

## Initial Setup:

When this command is invoked, respond with:
```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user's research query.

## Steps to follow after receiving the research query:

1. **Read any directly mentioned files first:**
   - If the user mentions specific files (tickets, docs, JSON), read them FULLY first
   - **IMPORTANT**: Use the Read tool WITHOUT limit/offset parameters to read entire files
   - **CRITICAL**: Read these files yourself in the main context before spawning any sub-tasks
   - This ensures you have full context before decomposing the research

2. **Analyze and decompose the research question:**
   - Break down the user's query into composable research areas
   - Take time to ultrathink about the underlying patterns, connections, and architectural implications the user might be seeking
   - Identify specific components, patterns, or concepts to investigate
   - Create a research plan using TodoWrite to track all subtasks
   - Consider which directories, files, or architectural patterns are relevant

3. **Spawn parallel sub-agent tasks for comprehensive research:**
   - Create multiple Task sub-agents to research different aspects concurrently
   - Each sub-agent should load the appropriate skill first, then perform its work

   **For codebase research:**
   - Sub-task: "Load the `locate-codebase` skill, then find WHERE files and components live for [topic]"
   - Sub-task (@codebase-analyzer): Understand HOW specific code works (without critiquing it)
   - Sub-task: "Load the `find-patterns` skill, then find examples of existing patterns for [topic] (without evaluating them)"

   **IMPORTANT**: All sub-agents are documentarians, not critics. They will describe what exists without suggesting improvements or identifying issues.

   **For thoughts directory:**
   - Sub-task: "Load the `locate-thoughts` skill, then discover what documents exist about [topic]"
   - Sub-task: "Load the `analyze-thoughts` skill, then extract key insights from [specific document paths] (only the most relevant ones)"

   **For web research (only when applicable):**
   - Web research is **optional** — only spawn web research sub-agents when:
     1. The project is **greenfield** (new project with little or no existing codebase to research)
     2. The user **explicitly asks** for web research (e.g., "also search the web", "include external docs", "what do the docs say")
   - When web research IS triggered, spawn 1-3 general-purpose sub-agents in parallel with codebase research, each focused on a different angle:
     - Sub-task: "Search the web for official documentation, APIs, and reference material related to [topic]. Use WebSearch to find relevant pages, then WebFetch to extract key details. Return all source URLs with your findings."
     - Sub-task: "Search the web for community knowledge — blog posts, Stack Overflow answers, GitHub issues/discussions — about [topic]. Focus on real-world usage patterns, common pitfalls, and practical examples. Use WebSearch and WebFetch. Return all source URLs."
     - Sub-task (if topic involves a library/framework/service): "Search the web for the latest changelog, migration guides, and version-specific documentation for [library/service]. Use WebSearch and WebFetch. Return all source URLs."
   - Each web research sub-agent MUST return:
     1. A summary of findings organized by subtopic
     2. All source URLs as markdown links `[Title](url)`
     3. Any code examples or configuration snippets found
   - Web findings supplement codebase findings — they provide external context (docs, known issues, best practices) for the patterns found in the code
   - When web research is NOT triggered, skip this section entirely and focus on codebase + thoughts research

   The key is to use these sub-agents with skills intelligently:
   - Start with locate skills (locate-codebase, locate-thoughts) to find what exists
   - Then use analyzer skills (analyze-thoughts) and @codebase-analyzer on the most promising findings
   - Run multiple sub-agents in parallel when they're searching for different things
   - Each skill provides the methodology — just tell the sub-agent what you're looking for
   - Remind sub-agents they are documenting, not evaluating or improving

4. **Wait for all sub-agents to complete and synthesize findings:**
   - IMPORTANT: Wait for ALL spawned sub-agent tasks to complete before proceeding
   - Compile all sub-agent results
   - Prioritize live codebase findings as primary source of truth
   - Use .thoughts/ findings as supplementary historical context
   - If web research was performed, use those findings to provide external context — connect what exists in the codebase to official docs, known patterns, and community knowledge
   - Connect findings across different components
   - Include specific file paths and line numbers for reference
   - If web research was performed, include source URLs as references
   - Highlight patterns, connections, and architectural decisions
   - Answer the user's specific questions with concrete evidence

5. **Gather metadata for the research document:**
   - Filename: `.thoughts/research/YYYY-MM-DD-ENG-XXXX-description.md`
      - Format: `YYYY-MM-DD-ENG-XXXX-description.md` where:
        - YYYY-MM-DD is today's date
        - ENG-XXXX is the ticket number (omit if no ticket)
        - description is a brief kebab-case description of the research topic
      - Examples:
        - With ticket: `2025-01-08-ENG-1478-parent-child-tracking.md`
        - Without ticket: `2025-01-08-authentication-flow.md`

5. **Generate research document:**
   - Use the metadata gathered in step 5
   - Structure the document with YAML frontmatter followed by content:
     ```markdown
     ---
     date: [Current date and time with timezone in ISO format]
      researcher: [Author name]
     git_commit: [Current commit hash]
     branch: [Current branch name]
     repository: [Repository name]
     topic: "[User's Question/Topic]"
     tags: [research, codebase, relevant-component-names]
     status: complete
     last_updated: [Current date in YYYY-MM-DD format]
     last_updated_by: [Researcher name]
     ---

     # Research: [User's Question/Topic]

     **Date**: [Current date and time with timezone from step 4]
      **Researcher**: [Author name]
     **Git Commit**: [Current commit hash from step 4]
     **Branch**: [Current branch name from step 4]
     **Repository**: [Repository name]

     ## Research Question
     [Original user query]

     ## Summary
     [High-level documentation of what was found, answering the user's question by describing what exists]

     ## Detailed Findings

     ### [Component/Area 1]
     - Description of what exists ([file.ext:line](link))
     - How it connects to other components
     - Current implementation details (without evaluation)

     ### [Component/Area 2]
     ...

     ## Code References
     - `path/to/file.py:123` - Description of what's there
     - `another/file.ts:45-67` - Description of the code block

     ## Architecture Documentation
     [Current patterns, conventions, and design implementations found in the codebase]

     ## Web Research Findings (include only if web research was performed)
     [External context from official docs, community knowledge, and related resources]

     ### Official Documentation
     - [Doc Title](url) - Key takeaway relevant to the codebase
     - ...

     ### Community Knowledge
     - [Article/Discussion Title](url) - Relevant insight
     - ...

     ### Version / Compatibility Notes
     [Any relevant version info, changelogs, or migration notes found]

      ## Historical Context (from .thoughts/)
      [Relevant insights from .thoughts/ directory with references]
      - `.thoughts/research/something.md` - Historical decision about X
      - `.thoughts/research/other.md` - Past exploration of Y

      ## Related Research
      [Links to other research documents in .thoughts/research/]

     ## Open Questions
     [Any areas that need further investigation]
     ```

8. **Sync and present findings:**
   - Present a concise summary of findings to the user
   - Include key file references for easy navigation
   - Ask if they have follow-up questions or need clarification

9. **Handle follow-up questions:**
   - If the user has follow-up questions, append to the same research document
   - Update the frontmatter fields `last_updated` and `last_updated_by` to reflect the update
   - Add `last_updated_note: "Added follow-up research for [brief description]"` to frontmatter
   - Add a new section: `## Follow-up Research [timestamp]`
   - Spawn new sub-agents as needed for additional investigation
   - Continue updating the document and syncing

## Important notes:
- Always use parallel Task agents to maximize efficiency and minimize context usage
- Always run fresh codebase research - never rely solely on existing research documents
- The .thoughts/ directory provides historical context to supplement live findings
- Focus on finding concrete file paths and line numbers for developer reference
- Research documents should be self-contained with all necessary context
- Each sub-agent prompt should be specific and focused on read-only documentation operations
- Document cross-component connections and how systems interact
- Include temporal context (when the research was conducted)
- Link to GitHub when possible for permanent references
- **Web research is conditional**: Only spawn web research sub-agents for greenfield projects (little/no existing codebase) or when the user explicitly requests it
- When web research IS performed, sub-agents must always return source URLs as markdown links
- Scale the number of web research sub-agents (1-3) based on topic breadth when applicable
- Keep the main agent focused on synthesis, not deep file reading
- Have sub-agents document examples and usage patterns as they exist
- Explore all of .thoughts/ directory, not just the research subdirectory
- **CRITICAL**: You and all sub-agents are documentarians, not evaluators
- **REMEMBER**: Document what IS, not what SHOULD BE
- **NO RECOMMENDATIONS**: Only describe the current state of the codebase
- **Workflow context**: This is the first stage of the pipeline: research → design → structure → plan → implement. Your output feeds into `/create-design`. Do NOT make design recommendations or propose solutions — only document what exists.
- **File reading**: Always read mentioned files FULLY (no limit/offset) before spawning sub-tasks
- **Critical ordering**: Follow the numbered steps exactly
  - ALWAYS read mentioned files first before spawning sub-tasks (step 1)
  - ALWAYS wait for all sub-agents to complete before synthesizing (step 4)
  - NEVER write the research document with placeholder values
- **Frontmatter consistency**:
  - Always include frontmatter at the beginning of research documents
  - Keep frontmatter fields consistent across all research documents
  - Update frontmatter when adding follow-up research
  - Use snake_case for multi-word field names (e.g., `last_updated`, `git_commit`)
  - Tags should be relevant to the research topic and components studied
