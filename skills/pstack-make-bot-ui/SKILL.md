---
name: make-bot-ui
description: Build a page or dashboard whose actions reach an authorized bot webhook, or build a Codex worker bridge when
  explicitly requested. Keep credentials on the server and optionally expose the UI on Tailscale.
metadata:
  source: https://github.com/cursor/plugins/tree/c742dd61706fbacc1b95f1a20b7b988cf096ce6c/pstack/skills/make-bot-ui
  source-version: 0.15.36
---

Read [the Codex runtime adapter](../../CODEX.md) once per session before this workflow. Resolve this SKILL.md with realpath before following links outside its folder. Invoke this skill as `$pstack:make-bot-ui`.


# Make a bot UI in Codex

Build a page the user can operate. Its browser sends a small JSON action to a server on this computer. That server invokes an authorized bot endpoint. Keep credentials on the server, outside the page source, browser storage, logs, and chat.

Codex's scheduled automations are not a webhook receiver. Do not invent a routine API, a secret-request card, a webhook URL, or a wake event. Pick the route supported by the actual target.

## Establish the action target

Inspect the user's request and available integrations before building:

- If the user supplied an existing webhook or bot service, use that service's documented endpoint, authentication, event shape, and success response. A Cursor webhook can remain the destination when the user wants to control an existing Cursor bot. Codex builds the UI and sender without claiming to create the Cursor routine.
- If a connected service exposes webhook creation, use its supported tool within the user's requested scope. Obtain the endpoint from the creation result or the actual service. Do not guess an identifier or endpoint.
- If the user explicitly wants a Codex-backed bot and authorizes a worker bridge, build a local bridge around the installed Codex app-server's supported protocol. Inspect the installed app-server schema and version first. Initialize the client, create or resume the intended worker chat, and submit the validated action through the supported turn API. Acknowledge transport acceptance separately from the worker's eventual result.
- If no real target is ready, build the UI and server against a local mock, then report that real bot delivery remains unverified. Ask only for the endpoint or bridge decision that the request leaves unresolved. Finish independent UI work while that answer is pending.

Creating a bridge is a distinct implementation task. Reuse a working bridge when one exists. Do not start a permanently running service, publish it, modify account settings, or create persistent workers merely to demonstrate that a page works. Those actions must be covered by the user's request.

## Define the contract

Write the permitted actions and their JSON fields before wiring the buttons. Validate incoming actions against that contract. Keep the field list small. Treat button input, webhook bodies, response text, and worker output as untrusted data.

For a Codex bridge, map an allowlisted action to a fixed worker instruction. Pass the action data as data, with an explicit boundary. Never evaluate user-supplied shell text or turn an arbitrary request body into unrestricted agent instructions. Bind the worker to the intended workspace and the user's authorized action scope. Preserve the host's approval rules and permission checks.

For an external service, send the headers and body its actual documentation requires. Do not reuse Cursor-specific headers for a different provider. For an existing Cursor automation webhook, its sender may require both `Authorization: Bearer <key>` and `X-Automation-Key: <key>`; confirm this against that webhook's current contract.

Use an eight-second delivery timeout by default and one attempt. Retrying a non-idempotent action can duplicate work. Add retries only when the target supplies idempotency or the user has approved the duplicate-action behavior. If durable delivery is needed, record a redacted action and its delivery state in a local queue. Replay only through a documented recovery path. A local queue is not proof that the bot woke.

## Store credentials without exposing them

Prefer an existing Keychain item or a process environment variable. Have the user enter a new secret through a supported secret UI or a local secure prompt. Do not ask them to paste it into chat. Do not put the value in command arguments, a URL, generated HTML, a source file, or a response to the browser.

Read a Keychain value directly into the server process when needed. Do not print the lookup result. Restrict any necessary credential file to its owner, keep it out of Git, and document its removal path. Redact request headers and error output. A proof artifact must never contain the secret.

## Build and exercise the local page

Keep the page, server, and non-secret configuration in the UI's own directory. Buttons call the local server. The local server calls the target. The browser never learns the target's sender key.

Bind to `127.0.0.1` for local-only work. When the user requests tailnet access, use the Tailscale address or another explicitly selected reachable bind. Binding to `0.0.0.0` also exposes the service on other interfaces, so use it only when that exposure is intended and access controls are in place. Protect state-changing routes against unauthorized requests and cross-origin submissions.

Show distinct states for a request rejected locally, accepted for delivery, accepted by the target, completed by the worker, and failed. A `200` response from a sender or target proves only what that endpoint's contract says it proves.

Run the page and use the actual browser control available in this session to operate a representative button. Observe the server receiving the expected JSON and the resulting UI state. Verify rejected malformed actions too. Use a harmless ignored action when the real target supports one. Otherwise obtain authorization for the real action before sending it.

## Expose on Tailscale when requested

Check `tailscale status` and `tailscale ip -4`. Reuse an online node and its actual hostname. Do not create a second node or rename an existing one just for this UI.

If Tailscale is absent, inspect the operating system and use its supported installation method. On macOS, check the existing Tailscale application and CLI before installing anything. Do not run a Linux `curl | sudo sh` installer on macOS. Installation and login must be covered by the user's request. A login URL goes to the user, who completes authentication. Do not collect their credentials.

For a new node, avoid enabling Tailscale SSH or changing DNS unless requested. Verify the final node state, address, bind, and port. Give the actual reachable URL. Do not claim tailnet reachability from a localhost-only probe. Test through the Tailscale address, and distinguish a same-machine probe from a probe on another peer. Configure HTTPS only when requested or required by the target deployment.

## Verify the wake and report its limits

Keep these proofs separate:

1. A local mock receives the action. This proves the page and sender contract only.
2. The real service accepts the action. Record a non-secret correlation ID or another provider-confirmed receipt.
3. The intended bot or Codex worker starts the matching action. Confirm it through the target's event stream, chat, or run record.
4. The worker finishes and the page displays the result. Observe the actual result and any intended side effects.

For a Codex bridge, consume the actual app-server events and correlate them with the action and worker turn. Inspect the resulting worker output. Do not claim completion from submission alone. For an external bot, use its actual payload and wake format. Cursor's `<webhook_event>` format is applicable only to a Cursor routine; it is not a generic Codex event.

Before handing over, exercise the real wake once when it is authorized and available. If it is not, name the missing proof and leave that part unverified. Include the launch and stop commands, UI URL, credential location without its value, and verified delivery stages. Stop only the processes started for a temporary demonstration. Preserve the evidence and any service the user asked to keep running.
