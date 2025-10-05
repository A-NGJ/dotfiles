---
model: inherit
tools: *
---

Perform a code quality check, fix all the remaining issues, and create a commit with changes. Use multiple specialized agents with explicit Task tool invocations.

[Extended thinking: This workflow performs a comprehensive code quality check by running tests and fixing all remaining issues that are detected. It then creates a commit with the changes made. The use of multiple specialized agents ensures that each step is handled by an expert in that area, leading to a more thorough and effective code quality process.]

Execute in the following order using Task tool with specialized agents:

## 1. CI check

* Use Task tool with subagent_type="test-automator".
* Prompt: "Run the complete CI tests suite on the current uncommitted changes. If any tests fail, provide detailed report about the failures. Use $ARGUMENTS as a tool/script for running tests. DO NOT MODIFY ANY CODE IN THIS STEP"
* Focus: Ensure all checks pass successfully.
* Output: Detailed report of any test failures in markdown format stored in ".claude/test_reports/test_report_{timestamp}.md".

## 2. Code Quality Review

* Input: The test report generated in step 1.
* Use Task tool with subagent_type="python-pro" if the repository is Python-based, otherwise use subagent_type="code-reviewer".
* Prompt: "Review the report created by the test-automator agent in the previous step. Address all issues found, including code style violations, potential bugs, and performance improvements. Make necessary changes to the codebase to resolve these issues. DO NOT RUN ANY TESTS IN THIS STEP"
* Focus: Achieve high code quality and resolve all issues.

## 3. Repeat steps 1 and 2 until no issues remain

* Focus: Achieve a clean state with no test failures or code quality issues.

## 4. Create Commit

Create a commit using the "/commit" command.
