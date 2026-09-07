---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.006
version: "1.0"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-045
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-003, DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. HITL approval dialog and resume dispatch."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-045
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "fea55e3"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.006: HITL Approval Dialog and Resume Dispatch (CAP-045)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

## Description

The console detects runs in `interrupted` status and surfaces pending approval requests
to the developer-operator via an interactive approval dialog. The dialog exposes the
approval context (interrupt scratchpad, tool call preview with action risk) and collects
an Approve, Deny, or Edit decision. The console maps the selection to the `Command` struct
and dispatches `POST /threads/{id}/runs/{run_id}/resume` (BC-2.05.004). Multiple pending
interrupts are surfaced in FIFO arrival order (DI-003). After resume, the console
subscribes to the new run stream (BC-2.24.004 live monitoring).

## Preconditions

1. {PRE-001} A run in `interrupted` status exists on the selected thread (either a node-boundary interrupt via `interrupt()` machinery, CAP-006, or a per-tool-call approval request, CAP-034).
2. {PRE-002} The run's SSE stream contains one or more `tool_approval_request` StreamEvents (CAP-007, for per-tool-call interrupts) or a `graph_interrupt` event (for node-boundary interrupts).
3. {PRE-003} `POST /threads/{id}/runs/{run_id}/resume` is available on pregolya-server (BC-2.05.004).

## Postconditions

1. {PC-001} **Interrupt detection:** The console identifies runs in `interrupted` status from the run list or from observing a `graph_interrupt` / `tool_approval_request` event in the SSE stream. Interrupted runs are visually flagged (e.g., with a badge).
2. {PC-002} **Approval dialog contents:**
   - For **node-boundary interrupts** (CAP-006 `interrupt()` machinery): the dialog shows the interrupt's `scratchpad` value (arbitrary JSON) and the node name where the interrupt fired.
   - For **per-tool-call interrupts** (CAP-034 `tool_approval_request` StreamEvent): the dialog shows the `ToolCallPreview` — tool name, args as JSON, and `ActionRisk` level — from the `tool_approval_request` event payload.
3. {PC-003} **Operator decisions:**
   - **Approve:** the console maps to `Command { resume: PreToolDecision::Allow }` (for tool-call interrupts) or the appropriate resume variant for node-boundary interrupts. Sends `POST .../resume`.
   - **Deny (with reason text):** maps to `Command { resume: PreToolDecision::Deny(reason) }`. Sends `POST .../resume`.
   - **Edit (modify args inline):** operator edits the tool call args JSON in the dialog. Console maps the modified args to the resume payload. Sends `POST .../resume` with edited args.
4. {PC-004} **FIFO multi-interrupt ordering (DI-003):** When multiple pending approvals exist in the queue, the console surfaces them in FIFO arrival order (first-received first). Only one interrupt is shown at a time; after dispatching resume for the first, the next is surfaced if the run remains interrupted.
5. {PC-005} **Post-resume live monitoring:** After a successful `POST .../resume`, the server returns a new `run_id`. The console subscribes to the new run's SSE stream (`GET /threads/{id}/runs/{new_run_id}/stream`, BC-2.24.004) to continue live monitoring.
6. {PC-006} **All operations via existing endpoints:** No new server endpoints are introduced. The console is a pure consumer of BC-2.05.004 (resume) and BC-2.12.007 (stream).

## Invariants

- {INV-001} **DI-003 FIFO interrupt delivery:** The console MUST NOT reorder pending interrupts. The arrival order of `tool_approval_request` events determines the presentation order. The operator sees interrupts in the sequence the engine queued them.
- {INV-002} **Pure consumer:** The console maps UI decisions to `Command` struct fields per the documented API contract (BC-2.05.004). It does NOT introduce new resume semantics.
- {INV-003} **Edit validation:** When the operator edits tool call args, the console validates that the edited value is valid JSON before enabling the submit button. Invalid JSON is rejected client-side with an error message.
- {INV-004} **DI-014:** Resume dispatch errors (server error on `POST .../resume`) propagate as user-visible error messages in the dialog. The dialog remains open so the operator can retry.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Run transitions from `interrupted` to `cancelled` while dialog is open | Server returns error on `POST .../resume`; dialog shows "run no longer active" message; operator dismisses |
| {EC-002} | Edit produces invalid JSON args | Submit button disabled; inline validation error shown; no resume dispatched |
| {EC-003} | Multiple pending tool-call approvals (2 `tool_approval_request` events) | First interrupt shown; after dispatching resume, if run remains `interrupted`, second interrupt surfaced in FIFO order |
| {EC-004} | Node-boundary interrupt with null scratchpad | Dialog shows node name with "no scratchpad data"; Approve/Deny still available |
| {EC-005} | `POST .../resume` returns server error | Error displayed in dialog; dialog remains open; operator can retry |
| {EC-006} | Run resumes with new `run_id` | Console navigates to live monitoring panel for the new `run_id` (BC-2.24.004) |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `tool_approval_request` event with `tool_name: "WriteFile"`, `ActionRisk::High`, args `{path: "/tmp/out"}` | Dialog shows tool name, High risk, args JSON; Approve/Deny/Edit buttons enabled | happy-path, tool interrupt |
| TV-002 | Operator clicks Approve | `POST .../resume` with `Command { resume: PreToolDecision::Allow }` dispatched; dialog closes; live monitoring opens for new run | approve decision |
| TV-003 | Operator clicks Deny with reason "too risky" | `POST .../resume` with `Command { resume: PreToolDecision::Deny("too risky") }` dispatched | deny decision |
| TV-004 | Operator edits args to `{invalid json}` and clicks submit | Submit rejected client-side; JSON parse error shown; no POST dispatched | EC-002 |
| TV-005 | Node-boundary interrupt at node `"agent"`; scratchpad `{"question": "proceed?"}` | Dialog shows node name "agent" and scratchpad JSON; Approve/Deny available | node-boundary interrupt |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.006-A | Approve sends `PreToolDecision::Allow` resume payload; Deny sends `PreToolDecision::Deny(reason)` | Integration test: mock server; assert POST body matches decision |
| VP-2.24.006-B | Multiple interrupts surfaced in FIFO order | Integration test: enqueue 2 `tool_approval_request` events; assert first-in is first shown |

## Related BCs

- BC-2.05.004 — depends on: `POST /threads/{id}/runs/{run_id}/resume` endpoint (exact contract consumed)
- BC-2.12.007 — depends on: SSE stream for detecting `tool_approval_request` and `graph_interrupt` events
- BC-2.24.004 — composes with: after resume, console transitions to live monitoring (BC-2.24.004) for new run

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — §Traceability row "HITL console resume dialog (CAP-045 — SS-24, SS-05)"
- `architecture/decisions/ADR-018-pre-tool-call-hook.md` — `PreToolDecision`, `ToolCallPreview`, `ActionRisk` types

## Story Anchor

S-console-06 (Wave 3 — HITL console resume dialog)

## VP Anchors

- VP-2.24.006-A
- VP-2.24.006-B

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-045 |
| Capability Anchor Justification | CAP-045 ("HITL Console Resume (Operator Approval Dialog)") per capabilities-p1-p2.md §CAP-045 — this BC specifies the interrupt detection, approval dialog contents (scratchpad, ToolCallPreview, ActionRisk), operator decision mapping (Approve/Deny/Edit), FIFO multi-interrupt ordering, and post-resume live monitoring that constitute the HITL console resume dialog described in CAP-045 |
| L2 Domain Invariants | DI-003 (FIFO resume delivery — multi-interrupt queue presented in arrival order), DI-014 (Error Propagation — resume errors surface as user-visible dialog messages) |
| Architecture Authority | ADR-031 §Traceability (CAP-045 — SS-24, SS-05); BC-2.05.004 (POST resume endpoint) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.006-A/B |
| Module | pregolya-console / SPA (web frontend, pure REST+SSE consumer of resume endpoint) |
| Priority | P1 |
| Wave | 3 |
| Test Types | integration (E2E) |
