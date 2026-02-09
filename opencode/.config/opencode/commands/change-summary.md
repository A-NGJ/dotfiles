---
description: Summarize changes on a current branch compared to the main branch
agent: build
---

# 1. Change detection

Perform a git diff between the current branch and the main branch. Summarize the changes made in the current branch compared to the main branch, highlighting key modifications, additions, and deletions in the codebase. Provide a concise overview of the changes for easy understanding.

Compare current branch with local main branch:

```bash
git diff main...HEAD
```

If the main branch is not local, fetch it first:

```bash
git fetch origin main:main
git diff main...HEAD
```

Summarize the output of the git diff command, focusing on significant changes such as new features, bug fixes, refactoring, and any other notable modifications.

# 2. Focus Area

Explain only complex, custom changes that require broader context to understand. Avoid trivial changes like formatting, comments, or minor tweaks unless they significantly impact functionality or readability.

Be thorough, if you spot any typos, syntax errors, bux, highlight them.


# 3. Example Summary

In the current branch, several key changes have been made compared to the main branch:

## **New Features**

### Feature 1: OAuth2 Authentication Module

#### Rationale

The `authenticateWithOAuth2` function was introduced to provide a more secure and user-friendly authentication method, addressing previous vulnerabilities in the login system.
Added a new authentication module that supports OAuth2, enhancing security and user experience.

#### Code changes

```diff
+ // New OAuth2 authentication module
+ function authenticateWithOAuth2(token) {
+     // Implementation details
+ }
```

Explanation: The new `authenticateWithOAuth2` function allows users to log in using OAuth2 tokens, providing a more secure authentication method compared to traditional username/password combinations...

### Feature 2: ...

[Follow similar structure for additional features.]

## **Bug Fixes**

### Bug Fix 1: Data Processing Algorithm

#### Rationale

Resolved an issue with the data processing algorithm that caused incorrect calculations under certain conditions.

[Follow analogical stucture to New Features]

## **Refactoring**

### Refactor 1: User Management Component

#### Rationale

Improved code readability and maintainability by refactoring the user management component.

[Follow analogical stucture to New Features]

## **Performance Improvements**

### Improvement 1: Database Query Optimization

[Follow analogical stucture to New Features]

## **Documentation Updates**

### Update 1: README File

[Follow analogical stucture to New Features]

# END of example summary

# 4. Save the summary

Save the markdown summary to the `.claude/thoughts/shared/change_summary/` directory with a filename indicating the current branch name, e.g., `change_summary_<branch_name>.md`.
