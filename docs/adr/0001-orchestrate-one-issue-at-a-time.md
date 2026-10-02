# Orchestrate one issue at a time; git and the PR hold the record

The `orchestrating` skill used to coordinate a whole issue graph handed over by `managing-projects`. At every step it wrote a tracker comment (delegation, commit, evidence, verdict, failed claim), and specialists returned a formal evidence contract. That made the tracker noisy and the loop slow.

We cut it down to one issue at a time. The operator names the issue. The orchestrator runs a fast implement → review loop in one worktree on the issue's branch, keeps the operator in the loop through chat, and ends by opening a PR. The tracker gets only state changes, plus one comment when the issue is blocked. Commit messages and the PR carry the record: a session that dies mid-run resumes from the branch, not from tracker comments.

## Considered Options

- **Keep tracker comments for in-flight work.** Rejected: it duplicates what git already guarantees and buries the issue's discussion.
- **A worktree per specialist run, with cherry-picks back.** Rejected: that only pays off with parallel specialists, and one issue at a time has none.

## Consequences

- A reviewer never runs on the same model as the specialist it reviews (`model-routing`), so a single-issue loop still gets an independent review.
- `managing-projects` returns ranked top picks; the operator chooses what to orchestrate.
