# pstack in Codex

This is the Codex implementation of pstack's runtime contract. Read it once per session before a bundled workflow. It replaces the source host's tools, model rules, storage paths and implicit permissions. Keep the workflow's actual task, principles, review criteria and evidence requirements.

## Resolve skills and resources

Resolve the selected SKILL.md with realpath before following links outside its folder. The repository root contains this file, `skills/`, `agents/`, and `docs/`. Each SKILL.md uses its original unqualified `name`. The `pstack` plugin adds the namespace, so the registered name and invocation are `pstack:name` and `$pstack:name`. UI display names use the same qualified form. Files remain in `skills/pstack-name/` so existing resource paths stay valid. Read sibling workflows at `../pstack-name/SKILL.md`. Bare bold names, principle names and old slash aliases in inherited prose refer to the namespaced copy in this bundle. Never select an unrelated existing skill with the same unprefixed name.

## Delegate with the tools actually available

Use the current session's native subagent API, such as `collaboration.spawn_agent` or `spawn_agent`, and its declared schema. Never call a source `Task` tool or pass source-only fields. Read `agents/poteto-agent.md` from the bundle and include it as the delegate's instructions when a workflow requests poteto-agent. For comment-sicko, use `agents/comment-sicko.md`. These are prompt templates, not registered Codex agent types.

`generalPurpose` means an ordinary delegate. `readonly` means tell it not to modify files and verify the scoped working tree afterward. Do not assume readonly removes connectors. `run_in_background` means dispatch and later collect results with the native wait/message tools. `resume` means follow up only when its retained state is needed. Otherwise spawn a fresh delegate with consolidated instructions. `file_attachments` become absolute file paths in the brief. `cloud_base_branch` becomes the exact starting ref in the brief. A cloud environment becomes an isolated worktree only when repository mutation needs isolation. Local resources stay on the current host. Do not claim a remote VM was allocated. Respect the actual concurrent-agent limit and queue excess lanes. With no delegation API, perform the lanes sequentially and name the loss of independent execution.

## Models and effort

Read `~/.agents/pstack/models.json` when it exists. Source role labels and `pstack-models.mdc` references map to its `roles` object. Resolve a role by merging its explicit object over `defaults`, field by field. If either is absent, the missing model or reasoning_effort inherits the parent. With no file, both inherit the parent. A list defines separate seats, resolving each seat over `defaults`, even when every seat inherits the same model. An absent panel means two seats for arena, architect and interrogate and one for a single-worker role. Model and reasoning effort are separate values. Never send a Grok/Claude slug, append effort to a model ID, or invent a fast suffix. Confirm any override against the current subagent tool's model/effort schema. When the API requires a fresh context for model overrides, use that mode with a self-contained brief. Otherwise omit overrides and inherit the current model.

An independent judge is useful even when only the same model family is available. Run a fresh independent judge and disclose that this is same-family review. Do not call it cross-model evidence. A configured but unavailable model is reported and replaced by inheritance, without repeated rejected calls. The setup workflow owns changes to models.json. This port never needs config.toml changes or trust bypasses.

## Questions, planning and capabilities

Use a question tool only if present and valid in the current mode, such as request_user_input_async. Follow its option limits and approval restrictions. Otherwise ask in chat. A todo tool is optional. Without one, maintain a concise Markdown checklist in the task's working directory. Do not let a missing UI tool block authorized work.

Use skill-creator for source create-skill instructions. For deslop, use an available simplification skill or inspect the diff directly for unnecessary code. For control-cli use terminal tools. For control-ui use supported browser/computer tools or a project browser driver. Discover connected tools before inventing connector names. Named services in source examples are evidence categories, not required providers. Read-only investigations stay read-only.

## History and live chat state

Use Codex list_threads/read_thread or app-server thread/list and thread/read when available. Pin the requested workspace, topic and time window before opening content. Prefer the current conversation already in context. Do not mine unrelated chats. If an exact local rollout is explicitly supplied, read only that file. A local fallback may list session_meta records under CODEX_HOME/sessions and archived_sessions to select matching cwd and timestamp before reading the matching messages. Do not search message bodies across all workspaces, infer paths from Cursor slug rules, or treat memory as live state. If full transcripts are unavailable, use the accessible evidence and report the gap. Never claim a transcript audit from a summary alone.

For program coordination, keep notes in the task's directory and use native agent wait tools. Only create or message user-visible Codex chats when the user explicitly asks. Source event subscriptions map to native wait tools or a bounded check. Scheduled continuation uses Codex automation_update only when requested. Never pretend scheduled tasks provide inbound webhooks. `/loop` means a foreground bounded verification loop, or an explicitly requested heartbeat for work after the turn.

## External actions and cleanup

Keep the user's actual authorized scope. A skill does not grant permission to send chat/email, merge, deploy, publish, change access, delete data, force-push, or create unrelated PRs. Perform those actions only when the conversation authorizes them and required approvals are satisfied. Ordinary reversible work within the requested scope proceeds. A terminal script cannot infer that a managed worktree is unused from missing history. Check current native worktree and thread attachments before cleanup and use the managed archive tool for managed worktrees.

Bugbot findings that already exist on a PR can be reviewed through GitHub. Do not claim to configure or start a missing Cursor service. The bundled benny automation source is retained as upstream material, not registered or enabled. make-bot-ui uses an existing authenticated webhook or an explicitly requested local bridge. It never invents a native secret-request card or Cursor routine endpoint.

## Installation and maintenance

Install through the repository marketplace as described in README.md: register `gaejabong/pstack-codex`, then install `pstack@pstack-codex`. The plugin package keeps this file, shared agent templates, docs, and sibling skills together in Codex's managed plugin cache. Resolve a skill's actual installed path before following resource links. Do not rely on a manually cloned checkout or a legacy pstack release store. Copying just one skill directory through a generic installer omits shared resources.

Use native marketplace refresh and plugin install/remove commands for maintenance. Do not write config.toml, trust records, or delete cache directories manually as an installation shortcut. Existing manually installed skill links are separate; inspect ownership before removing them. Start a new session after installation or updates.

When a user requests a maintained skill change, edit the source checkout and publish a new plugin version; the managed cache is a deployed copy and may be replaced on update. If only a cached copy is available, prepare a source patch or locate the maintained checkout. NOTICE.md and skill metadata identify the pinned upstream source.
