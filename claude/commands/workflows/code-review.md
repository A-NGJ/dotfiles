---
model: inherit
tools: Read, Glob, Grep, WebSearch, WebFetch, BashOutput, Bash
---

Perform a code review using multiple specialized agents with explicit Task tool invocations.

[Extended thinking: This workflow performs a thorough multi-perspective review by orchestrating specialized review agents. Each agent examines different aspects and the results are consolidated into a unified action plan.]

Execute parallel reviews using Task tool with specialized agents:


## 1. Code Quality Review
- Use Task tool with subagent_type="python-pro" if "--python-pro" is specified, otherwise subagent_type="code-reviewer"
- Prompt: "Review code quality and maintainability for: $ARGUMENTS. Check for code smells, readability, documentation, and adherence to best practices."
- Focus: Clean code principles, SOLID, DRY, naming conventions

## 2. Security Audit
- Use Task tool with subagent_type="security-auditor"
- Prompt: "Perform security audit on: $ARGUMENTS. Check for vulnerabilities, OWASP compliance, authentication issues, and data protection."
- Focus: Injection risks, authentication, authorization, data encryption

## 3. Test Coverage Assessment
- Use Task tool with subagent_type="test-automator"
- Prompt: "Evaluate test coverage and quality for: $ARGUMENTS. Assess unit tests, integration tests, and identify gaps in test coverage."
- Focus: Coverage metrics, test quality, edge cases, test maintainability

## Consolidated Report Structure
Compile all feedback into a unified report:
- **Critical Issues** (must fix): Security vulnerabilities, broken functionality, architectural flaws
- **Recommendations** (should fix): Performance bottlenecks, code quality issues, missing tests
- **Suggestions** (nice to have): Refactoring opportunities, documentation improvements
- **Positive Feedback** (what's done well): Good practices to maintain and replicate

## Review Options

- **--python-pro**: Use Python expert agent for code review

Target: $ARGUMENTS
