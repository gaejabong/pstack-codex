---
name: setup-pstack
description: Configure pstack's Codex models and reasoning effort per role, or inspect its current choices. Use for pstack
  setup, pstack budget, or changes to pstack model choices.
metadata:
  source: https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack/skills/setup-pstack
  source-version: 0.15.36
---

Read [the Codex runtime adapter](../../CODEX.md) once per session before this workflow. Resolve this SKILL.md with realpath before following links outside its folder. Invoke this skill as `$pstack:setup-pstack`.


# Set up pstack for Codex

Keep pstack's role choices in `~/.agents/pstack/models.json`. Read this file whenever a pstack workflow delegates work. It is pstack data, not a Codex configuration file. Do not edit `config.toml`, provider credentials, `AGENTS.md`, or trust records for this setup.

## Inspect before changing

1. Read the current session's delegation tool schema. If it lists model identifiers and reasoning effort values, use those as the available choices. A host-provided model listing can add choices only when the delegation tool supports them. Do not infer availability from a model name in upstream pstack, a web page, or the parent chat's model.
2. Read `~/.agents/pstack/models.json` if it exists. If it is absent, every role inherits the parent model and reasoning effort. No setup file is required to use pstack.
3. For an inspection request, report the effective settings without writing. For a change request, apply the user's named choices. Ask only for a missing preference that matters. A request such as "use the parent model everywhere" already supplies the choice.

Never ask the user to obtain model identifiers when inheritance meets the request. If the host exposes no model override, retain inheritance and explain that limit. The aliases `auto` and `inherit-parent` both omit the model argument.

## Choose a budget and roles

When the user asks to choose a budget without specifying one, offer these choices using a structured question tool when available:

- `unlimited` requests `max` effort.
- `large` requests `xhigh` effort.
- `medium` requests `high` effort.
- `small` requests `medium` effort.
- `inherit-parent` keeps the parent session's effort.

An effort value is separate from the model identifier. Do not append effort or speed tokens to a model name. Choose only an effort supported for that model by the current host. If a requested effort is unavailable, use the highest supported effort at or below it and report the adjustment. If the host gives no effort values, use `inherit-parent`.

Preserve existing explicit model choices when changing only the budget. Preserve panel lengths and ordering. Panel roles use one runner per entry, including repeated inherited entries. Repeated parent models are independent attempts, not a review by different model families.

Use these role keys so other pstack skills can read the same settings:

- `feature, refactoring`
- `bug-fix`
- `perf-issue`
- `hillclimb`
- `judgment and prose`
- `hardest tasks`
- `how explorer`
- `how explainer`
- `why investigators`
- `why synthesizer`
- `reflect tooling`
- `reflect judgment, divergent, synthesizer`
- `arena runners`
- `arena cross-judge pool`
- `swarm workers`
- `architect runners`
- `interrogate reviewers`

For an ordinary role, the value is an object. For `arena runners`, `arena cross-judge pool`, `architect runners`, and `interrogate reviewers`, the value is an array of these objects. An omitted role inherits `defaults`. With no configured runner panel, use two independent inherited runners. With no model family different from the parent available for cross-judging, report the missing diversity and use an independent inherited reviewer when one is useful.

## Save requested changes

Use this file shape. Populate only requested overrides. The example expresses the default behavior and does not require writing a file:

```json
{
  "version": 1,
  "budget": "inherit-parent",
  "defaults": {
    "model": "inherit-parent",
    "reasoning_effort": "inherit-parent"
  },
  "roles": {}
}
```

For example, `roles["how explorer"]` can hold an object with `model` and `reasoning_effort`, while `roles["arena runners"]` holds an array of two such objects. Use real model identifiers only after confirming that the current host accepts them. Never write the angle-bracket placeholders used in explanatory examples into the configuration.

Validate the complete proposed document before writing. Require `version` to equal `1`, `roles` to be an object, model identifiers to be supported or inherited aliases, and effort values to be supported or `inherit-parent`. An explicitly configured panel must contain at least one entry. Report any retired or unrecognized role key before removing it. Retain unrelated recognized choices.

Write atomically with a temporary file in the same directory and rename it into place. Reload the saved JSON and compare its effective choices with the requested changes. Report its exact path, the changes, any effort adjustment, and the effective fallback. No second approval is needed for settings the user already requested. A later invocation reads the saved file again, so there is no need to restart Codex for this pstack file.

The runtime adapter must still check the current tool schema before each delegated call. A valid saved choice can become unavailable on another host. In that case, inherit the parent model and effort, report the fallback, and do not rewrite the user's saved choice automatically.

## Optional verification skills

When setup is complete, inspect whether the project has a scripted way to exercise real app behavior. If it lacks one, offer `pstack:create-verification-skill` once. If a formal property would benefit from a model checker or proof and no such skill exists, offer `pstack:create-formal-verification-skill` once. Create either only when requested. These offers do not block setup.
