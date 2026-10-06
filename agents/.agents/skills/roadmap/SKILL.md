---
name: roadmap
description: Build a stakeholder roadmap of milestones from the issue tracker, as theme swimlanes over a weekly time axis, in Markdown, HTML, or PowerPoint. Use when the operator or a project manager wants a roadmap, a milestone timeline for stakeholders, or roadmap slides.
---

A **roadmap** shows stakeholders when each milestone is expected to start and finish. It draws one swimlane per theme on an axis of weeks that start on Monday. It shows dates only: no progress, status, issue numbers, or blockers.

The tracker is read-only for this skill. Every value you can't read from it comes from the operator: suggest it, say where the suggestion came from, and let the operator settle it. Never invent a date. When an answer would be worth keeping in the tracker, such as a milestone you proposed, a theme, or a start date, list it as a suggestion for the operator or `managing-projects` to apply.

## Per request

1. **Load policy.** Read the `## Roadmap data` section of `docs/agents/issue-tracker.md` and the label tables in `docs/agents/labels.md`. If the section is missing, use the matching template's section from the `setup-engineering-skills` skill folder (`issue-tracker-github.md`, `issue-tracker-gitlab.md`, or `issue-tracker-local.md`), choosing the tracker from `git remote -v`. Then suggest re-running that skill so the repo records its own section.
2. **Read the tracker.** Fetch every milestone with its dates and description, the issues in each milestone with their labels and creation dates, and the open issues with no milestone along with their parents.
3. **First round: milestones and window.** Ask these together, then wait for the answers:
   - **Milestones.** List the milestones you'll put on the roadmap. Leave out closed milestones that finished before the window starts. If the tracker has no milestones, or open issues fall outside every milestone, propose groupings. Group by parent issue first, then by a shared label (see [Theme](#derivation)), then by your own reading of the issue titles. Name each source.
   - **Window.** Propose a start week and a length that fit the request. The default is 2 weeks back through 10 weeks ahead: 12 weekly columns, which is about what fits on one slide.
   - **Format.** Confirm the format. Markdown is the default; HTML and PowerPoint are optional. For PowerPoint, ask whether there's a corporate template.
4. **Derive.** For each confirmed milestone, fill in name, theme, start, and finish using [Derivation](#derivation). Record whether each value was read from the tracker or suggested.
5. **Second round: the gap table.** Show one table with a row per milestone and columns for name, theme, start, and finish. Mark every suggested value with its source, e.g. `~12 Oct (first issue created)`. Ask the operator to reply with corrections only. Rough dates the operator gives count as estimates. A milestone the operator can't date even roughly goes to `unscheduled`.
6. **Render.** Write the data file described in [Data file](#data-file) to the scratchpad, or to a path the operator gave. Then run:

   ```sh
   uv run <skill folder>/render.py roadmap.json --out <dir> --format md[,html,pptx] [--template corp.pptx]
   ```

   The script checks dates and milestone fields and stops on the first bad value. Fix the data file and run it again.
7. **Check.** Read the Markdown. For PowerPoint on macOS, preview it with `qlmanage -t -s 1600 -o <dir> <file>.pptx` and look at the image. Bar labels should be readable and no bar should run off the slide. If labels are cramped, shorten the names or shrink the window, after confirming with the operator.
8. **Hand over.** Give the file paths, the milestones listed as unscheduled or outside the window, and any suggested tracker changes. The roadmap is a disposable view of the tracker. Commit it only if the operator asks.

## Derivation

Work through each list in order until a source gives a value.

- **Name.** Rewrite the milestone title in plain terms a stakeholder recognizes, e.g. "v2.3 auth refactor" becomes "Faster, safer sign-in". The operator confirms every rewrite in the gap table.
- **Theme.** The most common label on the milestone's issues, counting only labels that don't appear in the `labels.md` tables. Those tables hold workflow labels such as triage, category, priority, and state, which never name an outcome. If two labels tie or none qualifies, mark the theme as a gap and offer the top candidates. Rename the label for stakeholders the same way as the name.
- **Start.**
  1. The milestone's recorded start date. GitLab has one; GitHub doesn't.
  2. A suggestion: the Monday of the week the milestone's earliest issue was created.
  3. A suggestion: the Monday after the previous milestone in the same theme finishes.
- **Finish.**
  1. The milestone's due date.
  2. A suggestion: start plus the median length of the repo's other dated milestones.
  3. Otherwise ask the operator, with no suggestion.

Suggested values the operator accepts unchanged stay marked as estimates. GitHub's `due_on` is a UTC timestamp, so take its date part.

## Data file

`render.py` reads JSON:

```json
{
  "title": "Product roadmap",
  "as_of": "2026-10-06",
  "window": {"start": "2026-09-21", "weeks": 12},
  "milestones": [
    {"theme": "Billing", "name": "Annual plans", "start": "2026-11-02", "finish": "2026-11-27", "finish_estimated": true}
  ],
  "unscheduled": [{"name": "Usage-based pricing", "theme": "Billing"}]
}
```

- `as_of` defaults to today.
- `window.start` defaults to two weeks before `as_of` and is snapped back to its Monday.
- `start_estimated` and `finish_estimated` mark dates that are estimates. The renders show them as `~` dates and as lighter bars with a dashed outline.
- Milestones outside the window are listed under "Outside this window" rather than dropped.

## Formats

- **Markdown:** a table with one row per theme and one column per week. The milestone's name goes in its start week, `▬` fills the remaining weeks, and overlapping milestones stack into extra rows. A milestone list with dates follows the table. The table is wide, so GitHub and GitLab scroll it sideways.
- **HTML:** a single self-contained file with swimlane bars and a line marking today. It prints to PDF from a browser.
- **PowerPoint:** a 16:9 slide with the same swimlane bars, plus a second slide when there are unscheduled milestones or milestones outside the window. `--template` takes the theme fonts, colours, and slide size from a corporate deck. Bars use the template's Accent 1 colour, and the template's own slides are dropped. The script uses python-pptx rather than pandoc, because pandoc renders a 13-column table onto one slide at 18pt and cuts it off.
