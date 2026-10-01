# Dotfiles

Personal machine configuration, including the skills and agents shared across agentic harnesses (Claude Code, OpenCode, Pi).

## Language

**Tier variant**:
One of the up to three copies of an agent (`<agent>-fast`, `<agent>`, `<agent>-deep`) that share one body and differ only in their model.
_Avoid_: model variant, agent tier

**Command shim**:
An OpenCode command whose whole body loads one skill, so the skill is reachable as a slash command.
_Avoid_: wrapper command, alias command

**Role skill**:
A skill that gives whichever agent loads it a role, such as orchestrator or project manager, until the request's exit criterion is met. It replaces a dedicated agent for that role.
_Avoid_: persona agent, mode agent
