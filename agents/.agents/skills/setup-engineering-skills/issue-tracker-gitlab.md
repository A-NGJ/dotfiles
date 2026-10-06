# Issue tracker: GitLab

Issues and specs for this repo live as GitLab issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations.

## Conventions

- **Create an issue**: `glab issue create --title "..." --description "..."`. Use a heredoc for multi-line descriptions. Pass `--description -` to open an editor.
- **Read an issue**: `glab issue view <number> --comments`. Use `-F json` for machine-readable output.
- **List issues**: `glab issue list -F json` with appropriate `--label` filters.
- **Comment on an issue**: `glab issue note <number> --message "..."`. GitLab calls comments "notes".
- **Apply / remove labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`. Multiple labels can be comma-separated or by repeating the flag.
- **Close**: `glab issue close <number>`. `glab issue close` does not accept a closing comment, so post the explanation first with `glab issue note <number> --message "..."`, then close.
- **Merge requests**: GitLab calls PRs "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note`, etc., the same shape as `gh pr ...` with `mr` in place of `pr` and `note`/`--message` in place of `comment`/`--body`.

Infer the repo from `git remote -v`; `glab` does this automatically when run inside a clone.

## Merge requests as a triage surface

**MRs as a request surface: no.** _(Set to `yes` if this repo treats external merge requests as feature requests; `/triage` reads this flag.)_

When set to `yes`, MRs run through the same labels and states as issues, using the `glab mr` equivalents:

- **Read an MR**: `glab mr view <number> --comments` and `glab mr diff <number>` for the diff.
- **List external MRs for triage**: `glab mr list -F json`, then keep only MRs whose author is not a project member/owner (a contributor's MR, not a maintainer's in-flight work).
- **Comment / label / close**: `glab mr note`, `glab mr update --label`/`--unlabel`, `glab mr close`.

Unlike GitHub, GitLab numbers issues and MRs separately, so `#42` is unambiguous once you know which surface the maintainer means.

## Workflow state

_(Used by `/orchestrating`. Keep one of the two state options and delete the other.)_

- **State (board):** issue board `<name>`; in progress = list `<label backing the In Progress list>`. Moving a card is swapping that label.
- **State (labels):** `todo`, `in-progress`. Swap with `glab issue update <number> --label in-progress --unlabel todo`. A closed issue is done; there is no `done` label.
- **Branch naming:** `<type>/<issue-id>-<slug>`, type `feature` | `bugfix` | `hotfix`.
- **Create and link a branch:** create it from the default branch and push it; the merge request's `Closes #<number>` links it to the issue.
- **Merge request:** `glab mr create --source-branch <branch> --description "..."`, with `Closes #<number>` in the description.
- **On merge request open:** board, leave the card; labels, remove `in-progress`.

## Roadmap data

_(Used by `/roadmap`. Read-only.)_

Use `glab api`: `glab milestone list` and `glab issue list` don't page through every result. `:fullpath` fills in from the current clone. For a self-hosted instance, set `GITLAB_HOST=<host>` or pass `--hostname <host>`.

- **Milestones:** `glab api --paginate "projects/:fullpath/milestones?include_ancestors=true"`. This returns active and closed milestones, including group milestones, each with `title`, `description`, `state`, `start_date`, and `due_date`.
- **Issues in a milestone:** `glab api --paginate "projects/:fullpath/milestones/<id>/issues"`. Each issue carries `labels` and `created_at`.
- **Issues with no milestone:** `glab api --paginate "projects/:fullpath/issues?milestone_id=None&state=opened"`. On Premium and Ultimate, group them by the issue's `epic`. On Free, use linked issues: `glab api "projects/:fullpath/issues/<iid>/links"`.

## When a skill says "publish to the issue tracker"

Create a GitLab issue.

## When a skill says "fetch the relevant ticket"

Run `glab issue view <number> --comments`.
</content>
