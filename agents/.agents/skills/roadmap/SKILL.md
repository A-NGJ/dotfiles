---
name: roadmap
description: Build a stakeholder roadmap of milestones from the issue tracker, as theme swimlanes over a weekly time axis, in Markdown, HTML, or PowerPoint. Use when the operator or a project manager wants a roadmap, a milestone timeline for stakeholders, or roadmap slides.
---

A **roadmap** shows stakeholders when each milestone is expected to start and finish. It draws one swimlane per theme on an axis of weeks that start on Monday. It shows dates only: no progress, status, issue numbers, or blockers.

The tracker is read-only for this skill. Every value you can't read from it comes from the operator: suggest it, say where the suggestion came from, and let the operator settle it. Never invent a date. When an answer would be worth keeping in the tracker, such as a milestone you proposed, a theme, or a start date, list it as a suggestion for the operator or `managing-projects` to apply.

## Per request

1. **Load policy.** Read the `## Roadmap data` section of `docs/agents/issue-tracker.md` and the label tables in `docs/agents/labels.md`. If the section is missing, use the matching template's section from the `setup-engineering-skills` skill folder (`issue-tracker-github.md`, `issue-tracker-gitlab.md`, or `issue-tracker-local.md`), choosing the tracker from `git remote -v`. Then suggest re-running that skill so the repo records its own section.
2. **Read the tracker.** Fetch every milestone with its dates and description, the issues in each milestone with their labels and creation dates, and the open issues with no milestone along with their parents.
3. **First round: lanes, milestones, and window.** Ask these together, then wait for the answers:
   - **Lanes.** Ask which work streams stakeholders think in. A lane is a work stream, and the tracker often doesn't record them. Offer label-derived themes (see [Theme](#derivation)) only as suggestions. Done when every lane is a work stream the operator named or confirmed.
   - **Milestones.** List the milestones you'll put on the roadmap. Leave out closed milestones that finished before the window starts. If the tracker has no milestones, or open issues fall outside every milestone, propose groupings. Group by parent issue first, then by a shared label, then by your own reading of the issue titles. Name each source.
   - **Window.** Propose a start week and a length that fit the request. The default is 2 weeks back through 10 weeks ahead: 12 weekly columns, which is about what fits on one slide.
   - **Format.** Confirm the format. Markdown is the default; HTML and PowerPoint are optional. For PowerPoint, ask for a corporate `.pptx` template or, failing that, a brand guideline (see [Brand template](#brand-template)).
4. **Derive.** For each confirmed milestone, fill in name, theme, start, and finish using [Derivation](#derivation). Record whether each value was read from the tracker or suggested.
5. **Second round: the gap table.** Show one table with a row per bar and columns for name, theme, start, finish, and source issues. A bar may split one milestone across lanes or merge several milestones into one, so the source-issues column says which issues each bar stands for. Mark every suggested value with its source, e.g. `~12 Oct (first issue created)`. Under the table, add the flags from [Derivation](#derivation): collapsed start dates and the sample size behind duration suggestions. Ask the operator to reply with corrections only. Rough dates the operator gives count as estimates. A bar the operator can't date even roughly goes to `unscheduled`. Done when every bar lists its source issues and every flag is answered.
6. **Capacity check (optional).** Ask how many people or teams can work at once, e.g. "2 FTE". Count the bars that overlap in each week. Where a week exceeds the capacity, name the week and its bars, and propose a sequence that fits, as new dates in the gap table. Skip the step when the operator has no capacity figure. Done when no week exceeds the stated capacity, or the operator accepts the overlap.
7. **Render.** Write the data file described in [Data file](#data-file) to the scratchpad, or to a path the operator gave. Then run:

   ```sh
   uv run <skill folder>/render.py roadmap.json --out <dir> --format md[,html,pptx] [--template corp.pptx] [--layout band|plain]
   ```

   The script checks dates and milestone fields and stops on the first bad value. Fix the data file and run it again. For HTML or PowerPoint, offer the style choice once the data is settled: render `--layout band` and `--layout plain` into two folders, show one preview of each, and write the operator's pick as `"layout"` in the data file. Done when the data file holds the chosen `layout`, so a re-render reproduces it.
8. **Check.** Read the Markdown. Treat any `overflow:` line on stderr as a failed check. Only the PowerPoint render measures text, so include `pptx` in this run even for an HTML deliverable. Fix a failed check by shortening that name or widening its bar after confirming with the operator, then render again. Then look at a preview image:
   - **PowerPoint on macOS.** `qlmanage -t -s 1600 -o <dir> <file>.pptx` gives a quick thumbnail. It drops shapes thinner than 1 pt, and it wraps text narrower than PowerPoint does, so a clean thumbnail can still overflow in the real deck. When PowerPoint is installed, the final check is a PDF exported through it:

     ```sh
     open -a "Microsoft PowerPoint" <abs path>.pptx
     osascript -e 'with timeout of 180 seconds' \
       -e 'tell application "Microsoft PowerPoint" to save presentation 1 in (POSIX file "<abs path>.pdf") as save as PDF' \
       -e 'end timeout'
     pdftoppm -png -r 120 <abs path>.pdf <prefix>
     ```

     The first export raises a macOS folder-access prompt that the operator must approve. Files under `~/Library/Containers/com.microsoft.Powerpoint/Data/` export without it.
   - **HTML.** `"/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" --headless=new --user-data-dir=<fresh dir> --screenshot=<png> --window-size=1280,720 file://<abs path>.html` writes a screenshot. Chrome takes the same flags. Edge can keep running after it writes the file, so run it in the background and stop it once the PNG exists.

   Bar labels should be readable and no bar should run off the slide. Done when stderr has no `overflow:` line and the preview from PowerPoint's own export (or the Edge screenshot for HTML) shows every name and date inside its box.
9. **Hand over.** Give the file paths, the milestones listed as unscheduled or outside the window, and any suggested tracker changes. The roadmap is a disposable view of the tracker. Commit it only if the operator asks.

## Derivation

Work through each list in order until a source gives a value.

- **Name.** Rewrite the milestone title in plain terms a stakeholder recognizes, e.g. "v2.3 auth refactor" becomes "Faster, safer sign-in". The operator confirms every rewrite in the gap table.
- **Theme.** The lane the operator named in the first round. As a suggestion, the most common label on the milestone's issues, counting only labels that don't appear in the `labels.md` tables. Those tables hold workflow labels such as triage, category, priority, and state, which never name an outcome. If two labels tie or none qualifies, mark the theme as a gap and offer the top candidates. Rename the label for stakeholders the same way as the name.
- **Start.**
  1. The milestone's recorded start date. GitLab has one; GitHub doesn't.
  2. A suggestion: the Monday of the week the milestone's earliest issue was created. When these suggestions collapse onto one or two dates, the backlog was probably created in one batch, and the dates say nothing. Flag the collapse under the gap table and ask for real dates. Done when the gap table states the collapse or the suggestions spread over more than two dates.
  3. A suggestion: the Monday after the previous milestone in the same theme finishes.
- **Finish.**
  1. The milestone's due date.
  2. A suggestion: start plus the median length of the repo's other dated milestones. State the sample size, e.g. "median of 4 dated milestones". With fewer than 3, ask for a duration instead of suggesting one. Done when every duration suggestion shows a sample of 3 or more.
  3. Otherwise ask the operator, with no suggestion.

Suggested values the operator accepts unchanged stay marked as estimates. GitHub's `due_on` is a UTC timestamp, so take its date part.

## Brand template

When the operator has a brand guideline, such as a PDF, but no `.pptx` template:

1. Extract the primary palette and the typeface. Read the PDF directly, or use `pdftotext` for hex codes and font names and `pdftoppm -png` for pages that show them only as swatches.
2. Map the colours to theme slots: `dk1` for body text, `lt1` for the page background, `accent1` for the primary brand colour, `accent2` for a secondary colour. Show the mapping as a table, with the typeface, and wait for the operator's answer. Done when the operator has confirmed or corrected every slot and the typeface. Build nothing before that.
3. Build the template from the confirmed mapping:

   ```sh
   uv run <skill folder>/render.py --make-template brand.pptx --colors accent1=RRGGBB,accent2=RRGGBB,dk1=RRGGBB --font "Typeface"
   ```

   Slots you leave out keep the python-pptx default theme.
4. Render with `--template brand.pptx`, show the preview, and confirm with the operator.

Done when the operator has confirmed a preview rendered with the built template.

## Data file

`render.py` reads JSON:

```json
{
  "title": "Product roadmap",
  "as_of": "2026-10-06",
  "window": {"start": "2026-09-21", "weeks": 12},
  "layout": "band",
  "logo": "logo.png",
  "milestones": [
    {"theme": "Billing", "name": "Annual plans", "start": "2026-11-02", "finish": "2026-11-27", "finish_estimated": true}
  ],
  "unscheduled": [{"name": "Usage-based pricing", "theme": "Billing"}]
}
```

- `as_of` defaults to today.
- `window.start` defaults to two weeks before `as_of` and is snapped back to its Monday.
- `start_estimated` and `finish_estimated` mark dates that are estimates. The renders show them as `~` dates and as bars with a light fill and a dashed outline.
- `layout` is `band` (the default) or `plain`. `--layout` overrides it.
- `logo` is an image path, relative to the data file. When the key is missing or the file doesn't exist, HTML and PowerPoint draw an empty labelled slot top right for the operator to paste the official file into. `false` draws nothing.
- Milestones outside the window are listed under "Outside this window" rather than dropped.

## Formats

- **Markdown:** a table with one row per theme and one column per week. The milestone's name goes in its start week, `▬` fills the remaining weeks, and overlapping milestones stack into extra rows. A milestone list with dates follows the table. The table is wide, so GitHub and GitLab scroll it sideways.
- **HTML:** a single self-contained file with swimlane bars and a line marking today. It prints to PDF from a browser.
- **PowerPoint:** a 16:9 slide with the same swimlane bars, plus a second slide when there are unscheduled milestones or milestones outside the window. `--template` takes the theme fonts, colours, and slide size from a corporate deck, and the template's own slides are dropped. The script uses python-pptx rather than pandoc, because pandoc renders a 13-column table onto one slide at 18pt and cuts it off.

HTML and PowerPoint take every colour from the theme's slots: Accent 1 for bars, the today line, and the grid tints, and `dk1`/`lt1` for text and background. Without `--template` the colours come from the python-pptx default theme. The HTML also takes the template theme's heading and body typefaces. Without a template, or when the theme names no typeface, it uses the system font stack. The `band` layout fills the header and the lane column with Accent 1. `plain` keeps a white header and lightly tinted lane labels. The PowerPoint render prints an `overflow:` line on stderr for each lane label or bar name that won't fit its box, in either layout. The exit code stays 0.
