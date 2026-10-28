# pstack-codex

**58 pstack skills for Codex:** code exploration, design, implementation, and verification.

[한국어](README.ko.md) · [Codex instructions](CODEX.md) · [Upstream](https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack) · [MIT](LICENSE)

An unofficial community adaptation of **pstack by Lauren Tan**, originally published in `cursor/plugins`. Independently maintained; not endorsed by Lauren Tan, Cursor, or OpenAI.

## Install

### 1. Get Codex

If you already use Codex, continue to step 2. Otherwise, follow the [official Codex CLI quickstart](https://learn.chatgpt.com/docs/codex/cli). For macOS/Linux:

```sh
curl -fsSL https://chatgpt.com/codex/install.sh | sh
codex login
```

Complete sign-in in your browser. The [official authentication guide](https://learn.chatgpt.com/docs/auth) covers other sign-in methods. These commands install Codex itself; the next step adds pstack.

### 2. Add the marketplace and install pstack

```sh
codex plugin marketplace add gaejabong/pstack-codex
codex plugin add pstack@pstack-codex
```

Start a new Codex session after installation. In the desktop app, refresh or restart the app if the plugin source does not appear. The CLI registers this repository as a marketplace and installs the `pstack` plugin with all 58 skills and shared resources; no manual clone, symlink loop, or separate installer is needed. See the [official plugin commands](https://learn.chatgpt.com/docs/developer-commands#codex-plugin).

This repository provides its own marketplace; it is separate from OpenAI's public Plugins Directory. If you previously installed pstack manually, inspect and remove only its old skill symlinks to avoid duplicate entries. Then invoke a skill:

```text
$pstack:poteto-mode Reproduce this bug, fix it, and verify the behavior.
$pstack:how Explain how requests flow through this module.
$pstack:poteto-help Which skill should I use to review this PR?
```

## Preserved and adapted

| Area | Port behavior |
| --- | --- |
| Content | All 58 skills (34 workflows and 24 principles), 23 task playbooks, references, and supporting resources are retained. |
| Workflow design | The original task structure, review criteria, and evidence requirements are retained; host-specific instructions are adapted. |
| Names and selection | The `pstack` plugin supplies the `pstack:…` namespace; SKILL.md names are unqualified. Directories retain `pstack-…`. Codex metadata preserves explicit invocation for 57 skills; setup permits implicit selection. |
| Delegation | Uses available native Codex delegates and shared agent prompt templates. If delegation is unavailable, lanes run sequentially and that limitation is disclosed. |
| Models and history | Inherits the current model/effort by default; optional overrides use `~/.agents/pstack/models.json`. History lookup is scoped to the relevant workspace and time. |
| Helpers and external actions | Watcher launchers use a separate cache. Worktree auditing performs no fetch or deletion and holds cleanup decisions when ownership is unverified. External actions follow the user's authorization and host rules. |

Browse [skills](skills) or ask `$pstack:poteto-help`. [CODEX.md](CODEX.md) defines the shared runtime mappings.

## Support limits and tools

- Tested on macOS. Linux and Windows execution have not been verified. A current Codex client with plugin marketplace commands is required. Skills use standard unqualified frontmatter names; Codex adds the plugin namespace.
- Model overrides, parallelism, history access, and automation depend on the host. Same-model independent review is labeled as such; cross-model diversity and a persistent UI mode are not guaranteed.
- PR watchers need Node.js. The launcher uses existing Bun or prepares Bun 1.4.4 through npm in `~/.cache/pstack/` (override with `PSTACK_CACHE_DIR`). Initial setup downloads tools and dependencies.
- Statechart checks need a supported Node/Bun/Deno runtime plus Java/TLC; SVG rendering uses Pele. External workflows require their own tools, credentials, and sometimes network access.
- Cursor-only services are not reproduced automatically. `cursor-team-kit` is not bundled; benny automation material is retained as an inactive upstream reference. Bot UI workflows require a real webhook or an explicitly requested worker bridge.

The [upstream guide](docs/guide/README.md) and Claude Code adapter retain product-specific reference instructions. For Codex, follow this README and [CODEX.md](CODEX.md).

## Verification scope

Checked on macOS with Codex CLI 0.165.0: native marketplace/plugin parsing, discovery of all 58 packaged skills, standard skill metadata, and local resource links. These checks cover packaging and discovery. They do not establish full workflow parity with Cursor, successful execution against every external service, or improved coding performance.

## Update or remove

Refresh the marketplace and install the current plugin package:

```sh
codex plugin marketplace upgrade pstack-codex
codex plugin add pstack@pstack-codex
```

Start a new session to use the updated skills. Maintainers should increment `plugin.json`'s version when publishing changes. To uninstall the plugin, run `codex plugin remove pstack@pstack-codex`. To also remove the marketplace source, run `codex plugin marketplace remove pstack-codex`. Optional model settings in `~/.agents/pstack/models.json` are separate from the plugin.

## Credits and license

Based on pstack **0.15.36**, commit `c742dd61706fbacc1b95f1a20b7b988cf096ce6c`. Original copyright (c) 2026 Lauren Tan; Codex adaptation copyright (c) 2026 gaejabong and contributors.

Original materials remain under their existing [MIT license](LICENSE). Codex-specific modifications and additions are also provided under MIT; adaptation attribution applies only to those contributions. Original notices are preserved. See [NOTICE.md](NOTICE.md).
