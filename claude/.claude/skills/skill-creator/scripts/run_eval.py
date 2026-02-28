#!/usr/bin/env python3
"""Run trigger evaluation for a skill description.

Tests whether a skill's description causes Claude to trigger (read the skill)
for a set of queries. Uses the Anthropic Messages API directly instead of
spawning nested `claude -p` subprocesses.
"""

import argparse
import json
import sys
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import anthropic  # type: ignore[import-untyped]

from scripts.utils import parse_skill_md  # type: ignore[import-untyped]


def run_single_query(
    query: str,
    skill_name: str,
    skill_description: str,
    model: str | None,
    client: anthropic.Anthropic,
) -> bool:
    """Run a single query via the Anthropic API and return whether the skill was triggered.

    Sends the query to Claude with a system prompt listing the skill and tool
    schemas for Skill and Read. Checks whether the model's first action is to
    invoke the skill (via the Skill tool or by reading the SKILL.md).
    """
    system_prompt = (
        "You are Claude Code, an AI assistant. "
        "The following skills are available for use with the Skill tool:\n"
        f"- {skill_name}: {skill_description}\n"
    )

    tools = [
        {
            "name": "Skill",
            "description": "Execute a skill by name.",
            "input_schema": {
                "type": "object",
                "properties": {
                    "skill": {
                        "type": "string",
                        "description": "The skill name to invoke.",
                    },
                    "args": {
                        "type": "string",
                        "description": "Optional arguments for the skill.",
                    },
                },
                "required": ["skill"],
            },
        },
        {
            "name": "Read",
            "description": "Read a file from the filesystem.",
            "input_schema": {
                "type": "object",
                "properties": {
                    "file_path": {
                        "type": "string",
                        "description": "The absolute path to the file to read.",
                    },
                },
                "required": ["file_path"],
            },
        },
    ]

    resolved_model = model or "claude-sonnet-4-20250514"

    try:
        response = client.messages.create(
            model=resolved_model,
            max_tokens=300,
            system=system_prompt,
            tools=tools,
            messages=[{"role": "user", "content": query}],
        )
    except Exception as e:
        print(f"Warning: API call failed: {e}", file=sys.stderr)
        return False

    for block in response.content:
        if block.type != "tool_use":
            continue
        if block.name == "Skill":
            invoked = block.input.get("skill", "")
            if skill_name in invoked:
                return True
        elif block.name == "Read":
            path = block.input.get("file_path", "")
            if skill_name in path or "SKILL.md" in path:
                return True
        # Any other tool use means the model chose a different action
        return False

    return False


def run_eval(
    eval_set: list[dict],
    skill_name: str,
    description: str,
    num_workers: int,
    client: anthropic.Anthropic,
    runs_per_query: int = 1,
    trigger_threshold: float = 0.5,
    model: str | None = None,
) -> dict:
    """Run the full eval set and return results."""
    results = []

    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        future_to_info = {}
        for item in eval_set:
            for run_idx in range(runs_per_query):
                future = executor.submit(
                    run_single_query,
                    item["query"],
                    skill_name,
                    description,
                    model,
                    client,
                )
                future_to_info[future] = (item, run_idx)

        query_triggers: dict[str, list[bool]] = {}
        query_items: dict[str, dict] = {}
        for future in as_completed(future_to_info):
            item, _ = future_to_info[future]
            query = item["query"]
            query_items[query] = item
            if query not in query_triggers:
                query_triggers[query] = []
            try:
                query_triggers[query].append(future.result())
            except Exception as e:
                print(f"Warning: query failed: {e}", file=sys.stderr)
                query_triggers[query].append(False)

    for query, triggers in query_triggers.items():
        item = query_items[query]
        trigger_rate = sum(triggers) / len(triggers)
        should_trigger = item["should_trigger"]
        if should_trigger:
            did_pass = trigger_rate >= trigger_threshold
        else:
            did_pass = trigger_rate < trigger_threshold
        results.append({
            "query": query,
            "should_trigger": should_trigger,
            "trigger_rate": trigger_rate,
            "triggers": sum(triggers),
            "runs": len(triggers),
            "pass": did_pass,
        })

    passed = sum(1 for r in results if r["pass"])
    total = len(results)

    return {
        "skill_name": skill_name,
        "description": description,
        "results": results,
        "summary": {
            "total": total,
            "passed": passed,
            "failed": total - passed,
        },
    }


def main():
    parser = argparse.ArgumentParser(description="Run trigger evaluation for a skill description")
    parser.add_argument("--eval-set", required=True, help="Path to eval set JSON file")
    parser.add_argument("--skill-path", required=True, help="Path to skill directory")
    parser.add_argument("--description", default=None, help="Override description to test")
    parser.add_argument("--num-workers", type=int, default=10, help="Number of parallel workers")
    parser.add_argument("--runs-per-query", type=int, default=3, help="Number of runs per query")
    parser.add_argument("--trigger-threshold", type=float, default=0.5, help="Trigger rate threshold")
    parser.add_argument("--model", default=None, help="Model to use for API calls")
    parser.add_argument("--verbose", action="store_true", help="Print progress to stderr")
    args = parser.parse_args()

    eval_set = json.loads(Path(args.eval_set).read_text())
    skill_path = Path(args.skill_path)

    if not (skill_path / "SKILL.md").exists():
        print(f"Error: No SKILL.md found at {skill_path}", file=sys.stderr)
        sys.exit(1)

    name, original_description, content = parse_skill_md(skill_path)
    description = args.description or original_description

    client = anthropic.Anthropic()

    if args.verbose:
        print(f"Evaluating: {description}", file=sys.stderr)

    output = run_eval(
        eval_set=eval_set,
        skill_name=name,
        description=description,
        num_workers=args.num_workers,
        client=client,
        runs_per_query=args.runs_per_query,
        trigger_threshold=args.trigger_threshold,
        model=args.model,
    )

    if args.verbose:
        summary = output["summary"]
        print(f"Results: {summary['passed']}/{summary['total']} passed", file=sys.stderr)
        for r in output["results"]:
            status = "PASS" if r["pass"] else "FAIL"
            rate_str = f"{r['triggers']}/{r['runs']}"
            print(f"  [{status}] rate={rate_str} expected={r['should_trigger']}: {r['query'][:70]}", file=sys.stderr)

    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
