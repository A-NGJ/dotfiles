---
description: Transform meeting transcriptions into structured, actionable summaries
---

# Meeting Transcript Summarizer

Transform the provided meeting transcript into a concise, structured summary. Read the full transcript before writing anything — you need the complete arc of the conversation to judge what's important.

## Understanding the input

Meeting transcripts are messy. They come from automatic speech-to-text and contain filler words, false starts, repeated syllables (stuttering artifacts), crosstalk, incomplete sentences, and names that may be misspelled or phonetically approximated. See through the noise to the signal.

## Participant identification

Before writing, identify all participants from the transcript. Names appear in greetings, when people get tagged in ("let me tag in Alan"), or are addressed directly. Build a roster. If a speaker's name is unclear, use a consistent placeholder like "Speaker A". Note each person's apparent role if it becomes clear from context.

## Output format

Save the file to `<input-filename>-summary.md` in the same directory as the input transcript.

## Output structure

Produce the summary in markdown with these sections in order:

### 1. Meeting Header

```
# Meeting Summary: [Meeting Title or Topic]
**Date:** [date from transcript or metadata]
**Participants:** [comma-separated list of identified participants]
```

If the transcript metadata includes a meeting ID, tags, or other identifiers, include them on a separate line.

### 2. Summary

A concise paragraph (3-6 sentences, under 150 words) capturing the meeting's purpose, the main topics covered, and the overall outcome. Think of this as what you'd tell someone who asks "what was that meeting about?" in the hallway. Focus on the throughline and the most consequential points.

### 3. Key Decisions

A bulleted list of concrete decisions made during the meeting. Each item should be a clear, self-contained statement of what was decided, with a timestamp reference. Only include things that were actually agreed upon — not suggestions that were floated and tabled, or ideas that need further discussion.

If no firm decisions were made, say so briefly rather than fabricating them.

### 4. Action Items

A table capturing commitments people made. Be thorough here — this is one of the most valuable parts of the summary. Capture everything, including seemingly minor items like "we'll meet with X tomorrow" or "send that document after the call."

| Owner | Task | Due | Transcript Reference | Timestamp |
|-------|------|-----|----------------------|-----------|

Column guidance:
- **Owner**: The person who took on the task.
- **Task**: A clear, specific, actionable description of what they committed to doing.
- **Due**: If a deadline was mentioned, include it. If not, write "Not specified". Don't invent deadlines.
- **Transcript Reference**: A brief quote or paraphrase of the relevant moment — enough to find and verify the commitment. Keep it to one sentence.
- **Timestamp**: The `[MM:SS]` timestamp from the transcript.

### 5. Discussion Highlights

Bullet points covering the important topics that don't fit neatly into "decisions" or "action items":
- Key insights or observations that shifted the conversation
- Open questions that were raised but not resolved
- Points of disagreement or different perspectives
- Important context that was shared (data points, constraints, dependencies)

Keep each bullet to 1-3 sentences with timestamp references. Aim for 4-8 bullets depending on meeting length.

### 6. Deep Dive

This section covers the topic(s) that received the most sustained, substantive discussion. Focus on **what was proposed, how people reacted, and what was decided or left open** — not on retelling the conversation chronologically.

Structure each deep-dive topic as:

- **Context**: A brief sentence or two on what was being discussed and why it matters.
- **The proposal or core content**: If someone presented a plan, framework, or structure, include it in detail (bullet points, sub-sections, etc.). This concrete content is the most valuable part — a reader who missed the meeting needs to see exactly what was proposed.
- **Reactions and feedback**: What did participants say about the proposal? Capture specific feedback, corrections, and concerns with attribution and timestamps (e.g., "Greg noted that rejection rates should be at the plan level, not HCP level [23:11]"). Distill each person's substantive input rather than narrating the back-and-forth.
- **Key design decisions and open questions**: End with a clear list of what was resolved and what remains open. This is the most actionable part for anyone picking up this thread later.

If the meeting was short or surface-level with no topic receiving deep treatment, skip the detailed write-up.

## General principles

- **Accuracy over completeness.** Better to omit something ambiguous than to misrepresent what was said. If the transcript is garbled at a critical moment, flag it.
- **Attribute carefully.** Only attribute statements you're confident about from the transcript. Transcription errors make speaker identification tricky.
- **Timestamps everywhere.** Always reference timestamps when citing specific moments — in Key Decisions, Discussion Highlights, and Deep Dive, not just Action Items. This is the reader's lifeline back to the source.
- **Adapt to meeting length.** A 10-minute standup gets a shorter summary than a 90-minute strategy session. Scale depth to match substance.

$ARGUMENTS
