---
document_type: story
level: ops
story_id: S-console-08
epic_id: E-console
version: "1.5"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — HITL approval dialog, Approve/Deny/Edit decisions, FIFO multi-interrupt ordering, resume dispatch, post-resume live monitoring."
  - "1.1 (D-356/2026-09-07, story-writer): Adversary fix DC-02 — remove phantom graph_interrupt as an SSE stream event. Re-scope interrupt detection to BC-2.24.006's two-mechanism model: (a) node/graph-boundary interrupts detected via run STATUS transitioning to interrupted (interrupt halts SSE stream; no dedicated event); (b) tool-approval interrupts via tool_approval_request SSE event. All references treating graph_interrupt as an observable SSE event removed."
  - "1.2 (D-356/DC-23/2026-09-08, story-writer): F-PDC23-01 — resume is SAME run_id (architect ruling per BC-2.24.006 v1.3). AC-006 rewritten: run transitions in_progress on the SAME run_id; console continues monitoring same SSE stream (GET .../runs/{run_id}/stream); re-navigates to run inspection panel for same run_id. EC-006 corrected: same run_id unchanged. Task 8 corrected: post-resume continuation uses existing run_id. Zero new_run_id / {new_run_id} residue confirmed."
  - "1.3 (D-356/DC-25/2026-09-08, story-writer): F-PDC25-01 — node-boundary interrupt detection corrected to terminal __interrupt__ frame model (BC-2.24.006 v1.4). AC-001: detection now via terminal {\"__interrupt__\": [InterruptPayload]} SSE frame (not onclose/status-poll). AC-002: dialog sources value (scratchpad) + interrupt_id (hash) from frame; node_name claim removed (no node_name field in InterruptPayload). Task 3(b): populate dialog from terminal frame, not onclose handler. EC-004: node name removed; shows interrupt_id + null value. PSI: terminal frame reference. DC-02 body note: terminal frame correction noted. Zero node_name residue and zero no-dedicated-event over-correction residue confirmed."
  - "1.4 (D-356/DC-46/2026-09-09, story-writer): F-PDC46-01 — AC header citation form corrected to M4-strict bare-tag: BC-S.SS.NNN TAG (section-words removed per verify-ac-pc-trace.sh CHECK-1)."
  - "1.5 (D-356/DC-50/2026-09-09, story-writer): F-PDC50-06 — subsystems corrected to [SS-24] only: SS-05 removed — this story CONSUMEs the HITL/interrupt API surface only; no SS-05 code is modified here."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.006.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "d527269"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-06]
blocks: []
behavioral_contracts: [BC-2.24.006]
verification_properties: [VP-2.24.006-A, VP-2.24.006-B]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-08: HITL Approval Dialog and Resume Dispatch

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-02 (2026-09-07, story-writer).** Removed `graph_interrupt` as an SSE stream event throughout this story. `graph_interrupt` is phantom — it does not exist in the confirmed 16-variant StreamEvent grammar (see S-console-06 AC-001 for the canonical variant list). BC-2.24.006's corrected two-mechanism interrupt model: (a) node/graph-boundary interrupts terminate the SSE stream with a terminal `{"__interrupt__": [InterruptPayload]}` envelope frame carrying the payload (DC-25 correction: the terminal frame IS the detection mechanism — `onclose`/status-poll was an over-correction; `graph_interrupt` as a named StreamEvent variant remains phantom); run STATUS also transitions to `interrupted` (corroboration); (b) tool-approval interrupts arrive as `tool_approval_request` SSE events on the active stream. All AC, task, and intelligence references treating `graph_interrupt` as an observable SSE event have been re-scoped accordingly.

## Narrative

- **As a** developer-operator overseeing an agent with human-in-the-loop interrupts
- **I want to** see a dialog when a run is interrupted awaiting approval, review the pending tool call or node interrupt, and choose to Approve, Deny, or Edit
- **So that** I can make informed decisions about risky tool executions without writing raw API calls

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.006 | HITL Approval Dialog and Resume Dispatch (CAP-045) | AC-001..AC-008 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.006 PC-001)
The console identifies runs in `interrupted` status via two mechanisms: (a) from the run list — when a run's STATUS field shows `interrupted`; (b) from the live SSE stream — by observing a `tool_approval_request` event (tool-approval interrupt path) or by receiving the terminal `{"__interrupt__": [InterruptPayload]}` SSE envelope frame (node/graph-boundary interrupt path — the stream terminates with this frame carrying the interrupt payload; run STATUS also transitions to `interrupted`). Interrupted runs are visually flagged (e.g., a badge or status indicator distinct from `in_progress` or `completed`). Verified by `test_BC_2_24_006_interrupt_detection_flagged()`.

### AC-002 (traces to BC-2.24.006 PC-002)
For node-boundary interrupts (detected via the terminal `{"__interrupt__": [InterruptPayload]}` SSE frame), the dialog sources its data directly from that frame. `InterruptPayload` has two fields: `value` (arbitrary JSON passed to `interrupt()` — the scratchpad) and `interrupt_id` (hash). There is NO `node_name` field in `InterruptPayload` — the dialog does NOT display a node name for node-boundary interrupts. For per-tool-call interrupts (detected via `tool_approval_request` SSE event on the active stream), the dialog shows the `ToolCallPreview`: tool name, args as JSON, and `ActionRisk` level. Both variants surface Approve and Deny buttons. Verified by `test_BC_2_24_006_dialog_node_interrupt()` and `test_BC_2_24_006_dialog_tool_interrupt()`.

### AC-003 (traces to BC-2.24.006 PC-003)
Clicking Approve sends `POST /threads/{id}/runs/{run_id}/resume` with `Command { resume: PreToolDecision::Allow }` for tool-call interrupts (or the appropriate node-boundary resume variant). Clicking Deny requires a reason text input and sends `Command { resume: PreToolDecision::Deny(reason) }`. The exact `Command` shape is derived from the server contract — no new resume semantics introduced. Verified by `test_BC_2_24_006_approve_sends_allow()` and `test_BC_2_24_006_deny_sends_deny_reason()` (VP-2.24.006-A).

### AC-004 (traces to BC-2.24.006 PC-003)
Clicking Edit allows the operator to modify the tool call args JSON inline in the dialog. The console sends `POST .../resume` with the modified args. Invalid JSON in the edit field disables the submit button and shows an inline validation error — no resume is dispatched until the JSON is valid. Verified by `test_BC_2_24_006_edit_valid_json()` and `test_BC_2_24_006_edit_invalid_json_blocked()`.

### AC-005 (traces to BC-2.24.006 PC-004)
When multiple pending approvals exist (multiple `tool_approval_request` events), the console surfaces them in FIFO arrival order — first-received first. Only one interrupt is shown at a time. After dispatching resume for the first, if the run remains interrupted, the next interrupt is surfaced automatically. Verified by `test_BC_2_24_006_multi_interrupt_fifo_order()` (VP-2.24.006-B).

### AC-006 (traces to BC-2.24.006 PC-005)
After a successful `POST .../resume`, the run transitions to `in_progress` on the SAME run_id — no new run_id is issued. The console continues monitoring the same run's SSE stream (`GET /threads/{id}/runs/{run_id}/stream`) and re-navigates to the run inspection panel (S-console-06) for the same run_id. Verified by `test_BC_2_24_006_post_resume_live_monitoring()`.

### AC-007 (traces to BC-2.24.006 INV-003)
Client-side JSON validation blocks submission when the edited tool call args field contains invalid JSON. The submit button is disabled until the field is valid JSON. An inline error message shows below the edit field. Verified by `test_BC_2_24_006_json_validation_client_side()`.

### AC-008 (traces to BC-2.24.006 INV-004)
When `POST .../resume` returns a server error, the error message is displayed inside the dialog. The dialog remains open so the operator can retry. The error does not navigate away from the dialog or clear the approval context. Verified by `test_BC_2_24_006_resume_server_error_dialog_stays_open()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| HITL approval dialog component | `spa/src/components/HitlApprovalDialog.*` | N/A (SPA component) |
| Interrupt detection logic | `spa/src/lib/sse.ts` (event filtering) | N/A (SPA) |
| Resume dispatch | `spa/src/lib/api.ts` | N/A (SPA, REST client) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| HITL dialog | N/A (SPA) | TypeScript/JS frontend |
| Resume API call | Effectful | Sends POST to server; side effect is running agent execution |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | Run transitions to `cancelled` while dialog is open | Server error on resume; dialog shows "run no longer active" |
| EC-002 | Edit produces invalid JSON | Submit button disabled; inline error shown |
| EC-003 | Two pending `tool_approval_request` events | First shown; second surfaced after first is resolved in FIFO order |
| EC-004 | Node-boundary interrupt with null `value` in InterruptPayload | Dialog shows `interrupt_id` (hash) + null scratchpad (`value: null`); Approve/Deny available (no node name shown — `node_name` is not a field of InterruptPayload) |
| EC-005 | `POST .../resume` returns server error | Error shown in dialog; dialog stays open; operator can retry |
| EC-006 | Resume succeeds (same run_id; `interrupted` → `in_progress`) | Console continues live monitoring for same run (run_id unchanged) |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.006.md (~144 lines) | ~2,500 |
| ADR-031 traceability row (CAP-045) | ~200 |
| SPA component source (~200 lines TypeScript) | ~2,500 |
| Test files (~120 lines) | ~1,500 |
| Tool outputs | ~400 |
| **Total** | **~10,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs (test-writer; E2E/component tests)
2. [ ] Create `spa/src/components/HitlApprovalDialog.*` — modal dialog for approval; Approve/Deny/Edit buttons; FIFO queue management
3. [ ] Implement interrupt detection: (a) SSE event handler filters `tool_approval_request` events for the tool-approval interrupt path; (b) on the terminal `{"__interrupt__": [InterruptPayload]}` SSE frame, populate the HITL dialog from `value` (scratchpad JSON) + `interrupt_id` (hash); corroborate via `interrupted` run status. No `onclose`/stream-end status poll required — the payload arrives in the terminal frame itself.
4. [ ] Implement Approve action: POST `Command { resume: PreToolDecision::Allow }` to `/threads/{id}/runs/{run_id}/resume`
5. [ ] Implement Deny action: require reason text input; POST `Command { resume: PreToolDecision::Deny(reason) }`
6. [ ] Implement Edit action: inline JSON editor; client-side JSON validation; submit disabled on invalid JSON
7. [ ] Implement FIFO queue: multiple pending interrupts surfaced one at a time in arrival order
8. [ ] Implement post-resume continuation: run_id is UNCHANGED after resume; re-navigate to run inspection panel (S-console-06) using the existing run_id
9. [ ] Handle resume server errors: show error in dialog; keep dialog open
10. [ ] Run SPA tests — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-06 (run inspection panel). The `sse.ts` SSE subscription library and `api.ts` REST client are established by S-console-06. The HITL dialog reuses the SSE event stream already open for run inspection — it listens for `tool_approval_request` SSE events and monitors the terminal `{"__interrupt__": [InterruptPayload]}` SSE envelope frame (for node/graph-boundary interrupts, which terminate the stream with this frame carrying `value` + `interrupt_id`) on the same `EventSource` instance. Post-resume, the console transitions to the run inspection panel using the same navigation pattern established in S-console-06.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| FIFO interrupt ordering respected | BC-2.24.006 INV-001 (DI-003) | Test: 2 `tool_approval_request` events; assert first-in shown first |
| No new resume semantics introduced | BC-2.24.006 INV-002 | Code review: only maps to `PreToolDecision::Allow` and `PreToolDecision::Deny(reason)` |
| Edit field blocks submit on invalid JSON | BC-2.24.006 INV-003 | Test: invalid JSON in field; assert button disabled |
| Server error keeps dialog open | BC-2.24.006 INV-004 (DI-014) | Test: mock server error; assert dialog stays open |
| Resume uses shared SSE EventSource from run inspection | BC-2.24.006 INV-002 (shared EventSource contract) | Code review: HITL dialog does not open a new EventSource |

**Forbidden patterns:** Sending resume before JSON validation passes. Silently closing the dialog on server error. Opening a second `EventSource` for interrupt detection (reuse the one from S-console-06).

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| Framework (from S-console-05) | Per S-console-05 selection | SPA components and modal dialog |
| JSON validator | Native `JSON.parse` | Client-side JSON validation for edit field |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/spa/src/components/HitlApprovalDialog.*` | CREATE | Modal approval dialog with Approve/Deny/Edit |
| `crates/pregolya-console/spa/src/lib/api.ts` | MODIFY | Add `POST /threads/{id}/runs/{run_id}/resume` API call |
| `crates/pregolya-console/spa/src/lib/sse.ts` | MODIFY | Add interrupt event detection and FIFO queue management |
