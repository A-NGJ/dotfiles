# Pull request template

Title: the issue title, or a `type(scope): subject` line following the `commit` skill.

Body: the common sections, then the extra sections for the branch type. Keep each section to what a reviewer needs; write `none` rather than dropping a section.

## Common

```md
Closes #<issue>

## Summary

<one or two sentences: what this changes and why>

## Changes

- <change>

## How it was tested

- <command or check, and its result>
```

## feature

```md
## User-visible behavior

<what a user can now do or see differently>
```

## bugfix

```md
## Root cause

<what was wrong and why>
```

## hotfix

```md
## Impact

<who or what was affected, and since when>

## Rollback

<how to revert safely>
```
