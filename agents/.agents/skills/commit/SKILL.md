---
name: commit
description: Atomic commits with conventional `type(scope):` subjects. Use when committing changes, splitting work into commits, or writing a commit message.
---

A commit is **atomic**: one reason to revert, so one type and one scope. Work is done when every changed hunk has landed in exactly one commit.

1. **Survey the whole diff** before touching `git commit` — `git status`, then `git diff` and `git diff --staged`. Read the hunks, not just the filenames: for a deleted or wholly rewritten file, read what was there (`git show HEAD:<path>`), since its contents decide which group it joins. Untracked paths need a decision too — commit, ignore, or ask when the call isn't yours to make (content whose real home is outside the repo, generated session state).

2. **Group the hunks into atomic commits.** Split by reason-to-revert, not by file: a refactor and the feature it enables are two commits even in one file, and a rename touching thirty files is one. Where a file mixes purposes, stage by hunk with `git add -p`. Every hunk is assigned to exactly one commit before you commit anything.

   Each commit in the batch stands on its own: the version it stages parses and builds, so it is one you'd be willing to check out. Where changes interleave too tightly for `git add -p` to separate them, write the intermediate version to a scratch file and stage it as a blob — `git hash-object -w <file>`, then `git update-index --cacheinfo 100644,<blob>,<path>` — which leaves the working tree holding the final content throughout.

3. **Derive the scope from the repo.** Read `git log --pretty=%s -50` for the scope vocabulary already in use and reuse the one that fits, matching its casing. For a new area, name the directory or module that owns the change. Leave the scope off when the change is genuinely repo-wide.

4. **Write the subject** as `type(scope): imperative summary` — imperative mood ("add", "drop", "fix"), lowercase after the colon, no trailing period, 72 characters or fewer. Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`. Mark a breaking change with `!` before the colon.

5. **Add a body** when the diff shows the what but not the why — the reason for the change, the alternative rejected, the trade-off accepted. Wrap at 72 characters. Mechanical changes ship subject-only.

6. **Commit each group in order**, staging explicitly by path or hunk so the staged set matches the subject you just wrote. Then confirm with `git status` that nothing you intended to commit is still sitting in the working tree.
