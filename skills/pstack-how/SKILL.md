---
name: how
description: Use for "how does X work", code walkthroughs before changing something, and placement / ownership / layering
  questions ("where should this live", "which package owns this", "is this the right layer"). Explains subsystem architecture,
  runtime flow, onboarding mental models. Use why for motivation.
metadata:
  source: https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack/skills/how
  source-version: 0.15.36
---

Read [the Codex runtime adapter](../../CODEX.md) once per session before this workflow. Resolve this SKILL.md with realpath before following links outside its folder. Invoke this skill as `$pstack:how`.


# How

Explore the codebase to answer "how does X work?" questions. Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem, enough to build a working mental model, not so much that it reads like annotated source code.

Use ordinary native Codex delegates with read-only briefs. Resolve `how explorer` and `how explainer` from models.json through the runtime adapter. Resolve explicit role fields over defaults and inherit any remaining fields from the parent. Pass no source host fields.

## 1. Assess complexity

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

- **Simple** (a single module, a small utility, a narrow question such as "how does function X work"): no explorers. Spawn one explainer that explores and explains in one pass, built from `references/explainer-prompt.md` without the explorer-findings section. Go to step 4.
- **Complex** (a subsystem spanning multiple files or services, a cross-cutting feature, a full architectural overview): go to step 2.

When in doubt, take the simple path.

## 2. Explore (complex only)

Decompose the question into 2 to 4 angles, each a distinct slice of the subsystem. Spawn all explorers in a single message, each with `references/explorer-prompt.md` and its angle filled in.

## 3. Synthesize (complex only)

Once all explorers have returned, spawn one explainer with `references/explainer-prompt.md` and every explorer's findings filled in.

## 4. Present

Present the explainer's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.

## Output format

The explanation uses the sections defined in `references/explainer-prompt.md`, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.
