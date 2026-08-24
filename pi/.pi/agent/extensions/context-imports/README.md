# Context imports

Expands Claude Code-style `@path` references inside Pi's loaded `AGENTS.md` and `CLAUDE.md` context files.

```md
Read @docs/workflow.md before changing releases.
@~/.config/ai-glossary/glossary.md
```

- Relative paths resolve from the file containing the reference.
- Absolute paths and `~/...` paths are supported.
- Imported files can import other files, up to four hops.
- References inside inline code, backtick fences, and tilde fences stay literal.
- Each canonical file is included at its first reference only; cycles and unreadable files become explanatory HTML comments and produce a warning.
- Imports outside a project context file's directory require approval once per Pi process. Global context files may import freely because they are operator-controlled. Non-interactive modes deny external imports.
- Files are reread before each agent run, so edits take effect without `/reload` and expanded text never accumulates between runs.

The extension uses Pi's original `systemPromptOptions.contextFiles`, then replaces the matching `<project_instructions>` bodies in the already-built prompt. This preserves changes from earlier extensions. It currently depends on the context wrapper format used by Pi 0.84.3 and fails closed if that format changes.

Run the unit tests with Node 22 or newer:

```sh
node --test pi/.pi/agent/extensions/context-imports/src/*.test.ts
```
