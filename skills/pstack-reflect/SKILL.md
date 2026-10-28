---
name: reflect
description: Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete
  edit on an existing skill. Use when the user says reflect.
metadata:
  source: https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack/skills/reflect
  source-version: 0.15.36
---

Read [the Codex runtime adapter](../../CODEX.md) once per session before this workflow. Resolve this SKILL.md with realpath before following links outside its folder. Invoke this skill as `$pstack:reflect`.


# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

Invoke when the user says "reflect" or "$pstack:reflect". Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## 1. Locate the active transcript

Use the Codex history procedure in the runtime adapter. Identify the current chat and workspace before reading messages. Use native thread tools when available. For an explicitly selected local rollout, inspect its session_meta record and match cwd and chat ID before reading response_item or event_msg records. Do not parse Codex JSONL as Cursor message.content data or scan unrelated workspace bodies. If the exact transcript is inaccessible, pass a labeled digest and name the evidence gap.

## 2. Spawn three reviewers in parallel

Dispatch three ordinary Codex delegates with scoped briefs and the connector access needed for each review. Reviewers need MCP access to look up the tickets, chat threads, and observability traces the transcript references, and connector access depends on the Codex tool schema.

Resolve each reviewer and synthesizer role from models.json through the runtime adapter. Apply role overrides over defaults, then inherit any missing fields. Validate model and effort against the current tool schema.

| Lens | Role line | Default `model` | Prompt template |
|---|---|---|---|
| Judgment | `reflect judgment, divergent, synthesizer` | `inherit-parent` | `references/judgment-reviewer.md` |
| Tooling | `reflect tooling` | `inherit-parent` | `references/tooling-reviewer.md` |
| Divergent | `reflect judgment, divergent, synthesizer` | `inherit-parent` | `references/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked. Reviewers return findings through the native subagent API.

## 3. Synthesize

Spawn one ordinary Codex delegate using the `reflect judgment, divergent, synthesizer` role (default `inherit-parent`) and a scoped brief with needed connector access. It spot-verifies citations through MCP, and connector access depends on the Codex tool schema. Pass `references/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. It returns an Accepted / Rejected / Backlog list.

## 4. Structural enforcement check

Move any Accepted item that a lint rule, script, metadata flag, or runtime check would enforce more reliably to Backlog. See the **encode-lessons-in-structure** principle skill.

## 5. Apply

Present the synthesizer's Accepted / Rejected / Backlog output. Apply edits already authorized by the user's request. If the request was for proposals only or did not authorize the edits, ask for the subset to apply. Keep the edit scope and destination explicit.

File Backlog items externally only when the user authorized tracker writes. Otherwise include them in the local report.

Never edit a skill under `plugins/cache/`. Before editing, show its destination, `.agents/skills/<skill>/` or `~/.agents/skills/<skill>/`. Within the user's authorized scope, copy the skill folder there and edit the copy. Never open a PR or push.

Follow each approved row's Routing exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): the parent does it directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): hand to Codex's built-in `skill-creator` skill and run its draft / test / iterate loop.
- `tune description: <skill path>` (the skill exists but didn't trigger when it should have): hand to `skill-creator` and run its description-optimization loop.
- `new skill via create-skill: <kebab-name>`: hand creation to `skill-creator`. Do not invent the shape ad hoc.

If your environment ships a SKILL.md validator, run it on every touched skill before declaring done.

## 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog filed to the devex tracker: `<issue title>` (`<tags>`). One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
