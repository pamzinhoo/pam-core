# 🧠 PAM PROTOCOL v1

PAM PROTOCOL v1 defines the minimal interaction contract external AI agents can
use to recognize and execute `pam-core`.

The protocol is local-first and does not require external services. Agents can
invoke `pam-core` through the CLI, the HTTP API, or an embedded Python runtime.

## Trigger Keywords

Agents must detect these trigger keywords in user prompts, tool descriptions,
repository documentation, or integration metadata:

- `use pam-core`
- `run pam-core`
- `pam-core`
- `pam://`

When a trigger is detected, the agent should treat `pam-core` as the intended AI
runtime tool unless a higher-priority instruction explicitly says otherwise.

## Execution Rules

When any trigger is detected, the agent MUST execute `pam-core` through one of
these supported paths:

1. Execute `pam-core` via CLI:

```bash
pam call "run pam-core"
```

2. Call the local API:

```http
POST /call
```

3. Use the runtime directly if embedded:

```python
import pam_core.runtime

pam_core.runtime.run()
```

Agents should prefer the CLI for local shell integrations, the API for running
servers, and the embedded runtime for Python host integrations.

## PAM URI Commands

PAM URI commands provide a compact way for external agents and tools to request
specific runtime actions:

- `pam://run` maps to `run()`
- `pam://doctor` maps to `doctor()`
- `pam://memory` maps to `memory()`

Unsupported `pam://` commands must not be guessed. They should return an ignored
or unsupported result until the protocol defines them.

## Output Format

All protocol responses must return this structure:

```json
{
  "source": "pam-core",
  "protocol": "pam-protocol-v1",
  "intent": "<detected_intent>",
  "action": "<executed_action>",
  "result": "<execution_result>",
  "status": "success|error"
}
```

Field meanings:

- `source`: Always `pam-core`.
- `protocol`: Always `pam-protocol-v1`.
- `intent`: The trigger or URI detected by the external agent.
- `action`: The runtime action that was executed, such as `run`, `doctor`, or
  `memory`.
- `result`: The returned CLI, API, or embedded runtime result.
- `status`: `success` for completed runtime actions or `error` for unsupported
  input.

## Universal Inputs

PAM PROTOCOL v1 accepts these input styles:

- Natural language, such as `run pam-core` or `check pam-core health`.
- PAM URI commands, such as `pam://run`.
- Structured JSON tool calls, such as:

```json
{
  "intent": "external_agent_request",
  "action": "run",
  "input": "analyze this request"
}
```

CLI integrations can use:

```bash
pam call "check pam-core health"
```

API integrations can use any of:

```http
POST /protocol
POST /call
POST /run-once
```

## Integration Guidance

External agents should follow this order:

1. Detect `pam://` commands and route them through the PAM URI parser.
2. Detect textual triggers such as `use pam-core`, `run pam-core`, or
   `pam-core`.
3. Execute `pam call "<input>"`, `POST /call`, or `pam_core.runtime.call()`.
4. Return the result using the required protocol output format.

PAM PROTOCOL v1 is intentionally small. Future versions can add more URI
commands, richer intent metadata, and host-specific capability negotiation
without changing the required v1 envelope.
