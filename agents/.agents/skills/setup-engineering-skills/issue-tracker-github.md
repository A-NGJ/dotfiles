# Issue tracker: GitHub

Issues and specs for this repo live as GitHub issues. Use the `gh` CLI for all operations.

_(GitHub Enterprise Server only: prefix every `gh` command with `GH_HOST=<host>`, e.g. `GH_HOST=example.ghe.com gh issue list`. `gh` doesn't reliably resolve a self-hosted host from the git remote the way it does for `github.com`.)_

## Conventions

- **Create an issue**: `gh issue create --title "..." --body "..."`. Use a heredoc for multi-line bodies.
- **Read an issue**: `gh issue view <number> --comments`, filtering comments by `jq` and also fetching labels.
- **List issues**: `gh issue list --state open --json number,title,body,labels,comments --jq '[.[] | {number, title, body, labels: [.labels[].name], comments: [.comments[].body]}]'` with appropriate `--label` and `--state` filters.
- **Comment on an issue**: `gh issue comment <number> --body "..."`
- **Apply / remove labels**: `gh issue edit <number> --add-label "..."` / `--remove-label "..."`
- **Close**: `gh issue close <number> --comment "..."`

Infer the repo from `git remote -v`; `gh` does this automatically when run inside a clone.

## Pull requests as a triage surface

**PRs as a request surface: no.** _(Set to `yes` if this repo treats external PRs as feature requests; `/triage` reads this flag.)_

When set to `yes`, PRs run through the same labels and states as issues, using the `gh pr` equivalents:

- **Read a PR**: `gh pr view <number> --comments` and `gh pr diff <number>` for the diff.
- **List external PRs for triage**: `gh pr list --state open --json number,title,body,labels,author,authorAssociation,comments` then keep only `authorAssociation` of `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, or `NONE` (drop `OWNER`/`MEMBER`/`COLLABORATOR`).
- **Comment / label / close**: `gh pr comment`, `gh pr edit --add-label`/`--remove-label`, `gh pr close`.

GitHub shares one number space across issues and PRs, so a bare `#42` may be either: resolve with `gh pr view 42` and fall back to `gh issue view 42`.

## Workflow state

_(Used by `/orchestrating`. Keep one of the two state options and delete the other.)_

- **State (board):** GitHub Project `<name or URL>`; in progress = column `<In Progress>`. Move the card with `gh project item-edit`. Done is the board's automation on issue close.
- **State (labels):** `todo`, `in-progress`. Swap with `gh issue edit <number> --add-label in-progress --remove-label todo`. A closed issue is done; there is no `done` label.
- **Branch naming:** `<type>/<issue-id>-<slug>`, type `feature` | `bugfix` | `hotfix`.
- **Create and link a branch:** `gh issue develop <number> --name <branch> --base <default-branch>`. Find a linked branch with `gh issue develop <number> --list`.
- **Pull request:** `gh pr create --base <default-branch> --head <branch> --title "..." --body-file <file>`, with `Closes #<number>` in the body.
- **On pull request open:** board, leave the card; labels, remove `in-progress`.

## Roadmap data

_(Used by `/roadmap`. Read-only.)_

Use `gh api`: `gh issue list` can't read milestone metadata or parent issues. `{owner}/{repo}` fill in from the current clone.

- **Milestones:** `gh api --paginate "repos/{owner}/{repo}/milestones?state=all&per_page=100" --jq '.[] | {number, title, description, state, due_on, closed_at}'`. Milestones have no start date. `due_on` is a UTC timestamp, so take its date part.
- **Issues in a milestone:** `gh api --paginate "repos/{owner}/{repo}/issues?milestone=<number>&state=all&per_page=100" --jq '.[] | select(.pull_request == null) | {number, title, state, created_at, labels: [.labels[].name]}'`. The issues endpoint also returns pull requests, which the `select` drops.
- **Issues with no milestone:** the same call with `milestone=none&state=open`, adding `parent: (.parent_issue_url // null | if . then split("/") | last | tonumber else null end)` to group them by parent issue. GitHub Enterprise Server older than 3.16 has no sub-issues, so `parent` is always null there.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --comments`.
</content>
