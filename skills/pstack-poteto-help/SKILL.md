---
name: poteto-help
description: Explain the Codex pstack installation, pstack-poteto-mode, costs, troubleshooting, and the skill, playbook, or
  principle that fits a task. Use when the user asks for pstack help.
metadata:
  source: https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack/skills/poteto-help
  source-version: 0.15.36
---

Read [the Codex runtime adapter](../../CODEX.md) once per session before this workflow. Resolve this SKILL.md with realpath before following links outside its folder. Invoke this skill as `$pstack:poteto-help`.


# Poteto help in Codex

Answer the user's pstack question, give them a prompt they can send, and link the installed file supporting the answer. A help question does not start a run. A request for work, such as "use pstack to fix this bug", does. For a work request, read [pstack-poteto-mode](../pstack-poteto-mode/SKILL.md) and perform the requested work under it.

Read the file you route to before recommending its details. The installed Codex copy and [runtime adapter](../../CODEX.md) own the Codex behavior. Link those local files using their actual resolved absolute paths. Do not give a public upstream URL containing a `pstack-` folder name, because those folders belong to this port. For upstream provenance, read the repository's `NOTICE.md` and the skill's `metadata.source`, and identify the source as upstream documentation.

## Find the need

Infer the situation from the question and conversation. A specific question, such as "which skill reviews a PR?", goes directly to its answer. If the need remains unclear, ask one concise question. Useful choices are setup, starting a task, picking a skill, fixing a run, and personalization. Respect the question tool's option limit by grouping or splitting these choices. A missing question tool does not block help.

Check only the state that changes the answer:

- The native plugin is `pstack@pstack-codex`. Resolve the selected skill path to its installed plugin package and preserve the shared `CODEX.md`, `agents/`, `docs/`, and sibling skill layout. Legacy manual links may still exist; they are separate installations.
- Role overrides live in `~/.agents/pstack/models.json`. When that file or a role is missing, the role inherits the parent model and reasoning effort. Missing configuration does not mean setup is broken.
- A project's verification skill or app driver supplies scripted proof of real behavior. When the question concerns proof and no driver exists, mention [pstack-create-verification-skill](../pstack-create-verification-skill/SKILL.md).
- A project's formal verification skill checks a stated property beyond ordinary test cases. Mention [pstack-create-formal-verification-skill](../pstack-create-formal-verification-skill/SKILL.md) for a race, invariant, or similar case. If one already exists and its covered code changed, mention [pstack-maintain-formal-verification-skill](../pstack-maintain-formal-verification-skill/SKILL.md).

Do not require model setup before answering. When model choice matters, explain inheritance and offer `$pstack:setup-pstack` once. A user who already supplied model or effort preferences has supplied the needed choice.

## Get set up

This is the Codex plugin port. Confirm that `pstack@pstack-codex` is installed and enabled and that the Codex skill loader lists its skills. The display name and registered name are both `pstack:poteto-mode`; invoke it as `$pstack:poteto-mode`. Physical folders retain their pstack- prefix for resource paths.

For installation or repair, follow the README's native marketplace commands: register `gaejabong/pstack-codex`, then install `pstack@pstack-codex`. No custom installer is required. Do not copy individual folders because shared resources would be missing. Native Codex plugin commands manage plugin configuration and cache; do not edit config.toml or trust records manually. Inspect legacy manual links before removing only those owned by pstack.

Model configuration is optional. [pstack-setup-pstack](../pstack-setup-pstack/SKILL.md) can inspect or change role choices and a reasoning budget. It stores only requested changes in `~/.agents/pstack/models.json`, preserving unrelated role choices. Each later pstack invocation reads that file. It can also offer project verification and formal verification skills when relevant.

Start real work with `$pstack:poteto-mode`, the goal, and an observable check for completion. Read [the prompting reference](references/prompting.md) before helping draft a prompt. Give one example suited to the user's actual situation.

## Explain cost without guessing prices

pstack's additional work comes from code exploration, independent attempts, review panels, verification, and long runs. Inheriting the parent model does not eliminate those additional calls. It also does not create a cross-model panel when every runner uses the same family.

To reduce usage, choose a smaller supported effort budget, use an appropriate supported model, shorten a configured panel, or invoke the specific workflow needed instead of the full mode. Panel length determines the number of independent runners. Do not quote an invented price or claim that an `auto` alias is cheaper. Resolve current model availability through the host's actual tool schema and consult current official pricing only when the user asks for prices.

## Start a task with pstack-poteto-mode

The mode chooses a playbook, records its steps, and runs other skills as those steps need them. A skipped step retains its reason. Without a todo tool, the runtime adapter uses a concise Markdown checklist. State the goal, proof, and real constraints. A handwritten list of every skill is unnecessary.

Explicitly invoking `$pstack:poteto-mode` applies it to the current request and the work continuing from that request. If the user explicitly asks to keep that style for this conversation, follow that conversation instruction while it remains relevant. This port does not install a persistent UI mode. For a new task, a fresh chat, or an uncertain context after a long conversation, invoke `$pstack:poteto-mode` again. Do not promise that a shortcut or skill-selector action pins it across turns.

A new task should name the new goal. A read-only question should say that no changes are requested. Native Codex delegates receive the bundled `poteto-agent` prompt template when appropriate. It is not an agent type that users must register or select.

## Pick a workflow

The default for substantial engineering work is [pstack-poteto-mode](../pstack-poteto-mode/SKILL.md). Recommend a narrower skill when the user's request calls for one. Read the selected skill and provide one example prompt.

The bundle has 34 workflow skills and 24 principle skills. The workflow skills are:

| The user wants to | Skill |
|---|---|
| Perform substantial work with a routed playbook and verification | [pstack-poteto-mode](../pstack-poteto-mode/SKILL.md) |
| Have the agent restate the goal and problem before starting | [pstack-in-your-own-words](../pstack-in-your-own-words/SKILL.md) |
| Deepen a prompt before sending it, without starting the task | [pstack-sharpen](../pstack-sharpen/SKILL.md) |
| Understand current behavior, ownership, or where code belongs | [pstack-how](../pstack-how/SKILL.md) |
| Understand the reasons behind code or the origin of a number | [pstack-why](../pstack-why/SKILL.md) |
| Understand a subsystem or change through a plain explanation | [pstack-teach](../pstack-teach/SKILL.md) |
| Rebuild recent context on a topic across scoped chats and shared records | [pstack-recall](../pstack-recall/SKILL.md) |
| Catch up on this chat since the last user message and decide pending items | [pstack-ketchup](../pstack-ketchup/SKILL.md) |
| Receive that catch-up as a short subtitled slide video | [pstack-ketchup-video](../pstack-ketchup-video/SKILL.md) |
| Prove what a small diff could break beyond the changed lines | [pstack-blast-radius](../pstack-blast-radius/SKILL.md) |
| Settle types and module structure before implementation | [pstack-architect](../pstack-architect/SKILL.md) |
| Compare independent attempts at one brief and combine their strongest parts | [pstack-arena](../pstack-arena/SKILL.md) |
| Divide parallel coverage or race workers and aggregate their results | [pstack-swarm](../pstack-swarm/SKILL.md) |
| Have independent reviewers try to break a diff | [pstack-interrogate](../pstack-interrogate/SKILL.md) |
| Fix a bug with a failing test first when a cheap local test path exists | [pstack-tdd](../pstack-tdd/SKILL.md) |
| Apply type-system discipline to TypeScript work | [pstack-typescript-best-practices](../pstack-typescript-best-practices/SKILL.md) |
| Review comments independently and address accepted findings | [pstack-no-comments](../pstack-no-comments/SKILL.md) |
| Remove AI writing patterns | [pstack-unslop](../pstack-unslop/SKILL.md) |
| Write or review technical documents and change descriptions | [pstack-technical-writing](../pstack-technical-writing/SKILL.md) |
| Restate the last reply in ordinary language | [pstack-bro](../pstack-bro/SKILL.md) |
| Generate a project skill that drives the real app and captures proof | [pstack-create-verification-skill](../pstack-create-verification-skill/SKILL.md) |
| Bring an app verification skill and feature map back in sync | [pstack-maintain-verification-skill](../pstack-maintain-verification-skill/SKILL.md) |
| Check a race, invariant, or another property beyond ordinary tests | [pstack-create-formal-verification-skill](../pstack-create-formal-verification-skill/SKILL.md) |
| Update formal verification after covered code changes | [pstack-maintain-formal-verification-skill](../pstack-maintain-formal-verification-skill/SKILL.md) |
| Draw behavior checked by a TLA+ model and the shortest path to a violation | [pstack-statechart](../pstack-statechart/SKILL.md) |
| Validate a measured performance number before acting on it | [pstack-benchmark-checklist](../pstack-benchmark-checklist/SKILL.md) |
| Design and carry out a rigorous workflow for a large or unusual change | [pstack-figure-it-out](../pstack-figure-it-out/SKILL.md) |
| Keep and review a decision trail | [pstack-show-me-your-work](../pstack-show-me-your-work/SKILL.md) |
| Inspect or configure models and effort per role | [pstack-setup-pstack](../pstack-setup-pstack/SKILL.md) |
| Turn personal working conventions into a mode skill | [pstack-automate-me](../pstack-automate-me/SKILL.md) |
| Turn lessons from a finished task into concrete skill changes | [pstack-reflect](../pstack-reflect/SKILL.md) |
| Address recurring mistakes through structural enforcement | [pstack-correct](../pstack-correct/SKILL.md) |
| Build a UI for a real bot webhook or an explicitly requested Codex bridge | [pstack-make-bot-ui](../pstack-make-bot-ui/SKILL.md) |
| Get help choosing and using pstack workflows | pstack-poteto-help |

If the checkout contains a workflow missing from this table, read its frontmatter and route by its description. Do not count principle directories as additional workflow skills.

Close choices have these distinctions:

- `pstack:how` explains mechanics. `pstack:why` reconstructs reasons from evidence. `pstack:teach` uses one or both to teach the result.
- `pstack:arena` gives runners the same brief and synthesizes a result. `pstack:swarm` divides coverage or races workers and returns one report.
- `pstack:architect` normally proceeds from design to implementation. Add "with checkpoint" when the user wants to inspect the design first.
- `pstack:interrogate` reviews the diff. `pstack:blast-radius` investigates effects outside it.
- `pstack:recall` rebuilds context across selected chats. `pstack:ketchup` covers the current chat's newest work. Session pickup resumes one specific chat or branch.
- `pstack:figure-it-out` designs one substantial run. Orchestrate coordinates a longer program. Autonomous run drives one task to a defined finish condition.

The upstream `deslop`, `control-cli`, and `control-ui` skills are not bundled. The runtime adapter maps their outcomes to an available simplification skill, terminal control, and browser or computer tools. `skill-creator` supplies skill authoring. Scheduled continuation uses a supported Codex automation only when requested. There is no separate `pstack-orchestrate` skill.

## Pick a playbook or principle

Playbooks are files within `pstack:poteto-mode`, not separately registered skills. Describe the task after `$pstack:poteto-mode` or name a playbook in that request. Read [its playbook index](../pstack-poteto-mode/SKILL.md) for the complete current list.

- "Babysit PR 123" runs Babysit and drives the PR to merge-ready. Merging requires the user's authorization.
- "Land this stack" selects Shipping, which verifies the stack before the authorized merge.
- "Take over this branch" selects Session pickup.
- "Pause safely" selects Pause safely and records a recoverable checkpoint.
- "Full autopilot on this queue" selects Autopilot-full. "Autopilot, don't merge" selects Autopilot-stack.
- "Run the eval playbook" selects Eval and its blinded comparisons.
- "Plan this multi-phase change without implementing it" selects [Multi-phase plan](../pstack-poteto-mode/playbooks/multi-phase-plan.md).

Planning availability depends on the current Codex host and mode. A skill cannot switch the host's collaboration mode by saying that it did. A design question may fit the Prototype playbook or `pstack:architect` instead of a prose plan.

The 24 `pstack-principle-*` skills each state one engineering rule. `pstack:poteto-mode` reads the relevant leaf file before applying and citing it. Users usually steer by intent, such as "prove it works with the real output", rather than invoking a principle alone. Explicit calls such as `$pstack:principle-prove-it-works` remain available. [The principle guide](../../docs/guide/08-principles.md) explains the rules; resolve each cited skill to its installed Codex copy.

## Fix a run that went wrong

| Symptom | What to check or change |
|---|---|
| The mode no longer appears to govern a new task | Explicitly invoke `$pstack:poteto-mode` again and state the new goal. There is no promised persistent UI mode. |
| A question became an implementation step | Say the request is a new read-only question and name the desired answer. |
| A model choice had no effect | Read the saved `models.json`, the role key, and the next invocation's effective settings. Confirm that the current delegation tool supports the model and effort. |
| Usage grew unexpectedly | Check the number of runners, review panels, effort, and iterations. Use the cost guidance above. |
| A skill did not load implicitly | Invoke it as `$pstack:name`. Most original pstack workflows preserve explicit invocation. If it remains absent, inspect the loader result and symlink target. |
| A newly installed skill is missing from the selector | Try the next turn, then restart Codex if the selector is stale. Verify loader discovery before diagnosing a UI cache issue. |
| Parallel workers overwrote each other | Give mutating workers separate worktrees or write locations and assign explicit ownership. Do not assume a remote machine was allocated. |
| An unattended run made activity without completing the task | Define a finish condition that each iteration can verify. Configure a supported continuation only when the user wants work to continue later. |
| A reply equates a passing build with completion | Ask for the actual command, user flow, stored value, or measured profile that proves the requested outcome. |
| A review claims different-model agreement while every seat inherited | Label it independent same-family review and use a different supported model only when available and authorized. |
| A help link leads to a nonexistent upstream file | Resolve and link the installed Codex file. Use NOTICE.md and the skill's source metadata only for upstream provenance. |
| A bot page works locally but no bot wakes | Separate mock delivery, real endpoint receipt, worker start, and worker completion. Follow `pstack:make-bot-ui` and report the missing stage. |

Read [the prompting reference](references/prompting.md) for scoped steers and [the recipe reference](references/recipes.md) for examples. Treat their upstream host examples through the Codex runtime adapter. Do not repeat a host-specific UI instruction that the active Codex environment does not provide.

## Make pstack personal

[pstack-automate-me](../pstack-automate-me/SKILL.md) can draft a personal mode skill from workspace-scoped history and stated preferences. [pstack-reflect](../pstack-reflect/SKILL.md) can turn the current task's lessons into changes to existing skills. Creating or applying those changes follows the user's actual request and the runtime adapter. Do not read unrelated conversations or file external backlog items merely because help was requested.

For a new task workflow, ask `$pstack:poteto-mode` to write the skill. Its authoring playbook uses `skill-creator`, checks frontmatter and references, and exercises structural behavior. The Eval playbook compares a proposed change. Keep a skill fix separate from unrelated feature work, preserve local changes, and compare with the pinned upstream source and review Git history when updating this port. A local user-skill change does not require inventing an upstream PR.

## Reply

Lead with the answer to the actual question. Give at most one ready-to-send prompt in a code block, then link the installed file that supports it. Keep the reply short unless the user asked for the complete map. If the message already requests work, perform it rather than ending with a suggested prompt.
