---
document_type: story
level: ops
story_id: S-console-08
epic_id: E-console
version: "1.1"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — HITL approval dialog, Approve/Deny/Edit decisions, FIFO multi-interrupt ordering, resume dispatch, post-resume live monitoring."
  - "1.1 (D-356/2026-09-07, story-writer): Adversary fix DC-02 — remove phantom graph_interrupt as an SSE stream event. Re-scope interrupt detection to BC-2.24.006's two-mechanism model: (a) node/graph-boundary interrupts detected via run STATUS transitioning to interrupted (interrupt halts SSE stream; no dedicated event); (b) tool-approval interrupts via tool_approval_request SSE event. All references treating graph_interrupt as an observable SSE event removed."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.006.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "55bd187"
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
subsystems: [SS-24, SS-05]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-08: HITL Approval Dialog and Resume Dispatch

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-02 (2026-09-07, story-writer).** Removed `graph_interrupt` as an SSE stream event throughout this story. `graph_interrupt` is phantom — it does not exist in the confirmed 16-variant StreamEvent grammar (see S-console-06 AC-001 for the canonical variant list). BC-2.24.006's corrected two-mechanism interrupt model: (a) node/graph-boundary interrupts cause the SSE stream to halt and run STATUS transitions to `interrupted` — detected via run list status field or run-status endpoint, NOT via a dedicated stream event; (b) tool-approval interrupts arrive as `tool_approval_request` SSE events on the active stream. All AC, task, and intelligence references treating `graph_interrupt` as an observable SSE event have been re-scoped accordingly.

## Narrative

- **As a** developer-operator overseeing an agent with human-in-the-loop interrupts
- **I want to** see a dialog when a run is interrupted awaiting approval, review the pending tool call or node interrupt, and choose to Approve, Deny, or Edit
- **So that** I can make informed decisions about risky tool executions without writing raw API calls

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.006 | HITL Approval Dialog and Resume Dispatch (CAP-045) | AC-001..AC-008 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.006 postcondition PC-001)
The console identifies runs in `interrupted` status via two mechanisms: (a) from the run list — when a run's STATUS field shows `interrupted`; (b) from the live SSE stream — by observing a `tool_approval_request` event (tool-approval interrupt path) or by detecting that the active SSE stream has ended and the run STATUS has transitioned to `interrupted` (node/graph-boundary interrupt path — the interrupt halts the stream; there is no dedicated `graph_interrupt` stream event). Interrupted runs are visually flagged (e.g., a badge or status indicator distinct from `in_progress` or `completed`). Verified by `test_BC_2_24_006_interrupt_detection_flagged()`.

### AC-002 (traces to BC-2.24.006 postcondition PC-002)
For node-boundary interrupts (detected via run STATUS = `interrupted` after the SSE stream ends — no dedicated stream event exists), the dialog shows the interrupt's `scratchpad` value (arbitrary JSON) and the node name where the interrupt fired, obtained from the run or thread state endpoint. For per-tool-call interrupts (detected via `tool_approval_request` SSE event on the active stream), the dialog shows the `ToolCallPreview`: tool name, args as JSON, and `ActionRisk` level. Both variants surface Approve and Deny buttons. Verified by `test_BC_2_24_006_dialog_node_interrupt()` and `test_BC_2_24_006_dialog_tool_interrupt()`.

### AC-003 (traces to BC-2.24.006 postcondition PC-003)
Clicking Approve sends `POST /threads/{id}/runs/{run_id}/resume` with `Command { resume: PreToolDecision::Allow }` for tool-call interrupts (or the appropriate node-boundary resume variant). Clicking Deny requires a reason text input and sends `Command { resume: PreToolDecision::Deny(reason) }`. The exact `Command` shape is derived from the server contract — no new resume semantics introduced. Verified by `test_BC_2_24_006_approve_sends_allow()` and `test_BC_2_24_006_deny_sends_deny_reason()` (VP-2.24.006-A).

### AC-004 (traces to BC-2.24.006 postcondition PC-003)
Clicking Edit allows the operator to modify the tool call args JSON inline in the dialog. The console sends `POST .../resume` with the modified args. Invalid JSON in the edit field disables the submit button and shows an inline validation error — no resume is dispatched until the JSON is valid. Verified by `test_BC_2_24_006_edit_valid_json()` and `test_BC_2_24_006_edit_invalid_json_blocked()`.

### AC-005 (traces to BC-2.24.006 postcondition PC-004)
When multiple pending approvals exist (multiple `tool_approval_request` events), the console surfaces them in FIFO arrival order — first-received first. Only one interrupt is shown at a time. After dispatching resume for the first, if the run remains interrupted, the next interrupt is surfaced automatically. Verified by `test_BC_2_24_006_multi_interrupt_fifo_order()` (VP-2.24.006-B).

### AC-006 (traces to BC-2.24.006 postcondition PC-005)
After a successful `POST .../resume`, the server returns a new `run_id`. The console subscribes to the new run's SSE stream (`GET /threads/{id}/runs/{new_run_id}/stream`) and transitions to the run inspection panel (S-console-06). Verified by `test_BC_2_24_006_post_resume_live_monitoring()`.

### AC-007 (traces to BC-2.24.006 invariant INV-003)
Client-side JSON validation blocks submission when the edited tool call args field contains invalid JSON. The submit button is disabled until the field is valid JSON. An inline error message shows below the edit field. Verified by `test_BC_2_24_006_json_validation_client_side()`.

### AC-008 (traces to BC-2.24.006 invariant INV-004)
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
| EC-004 | Node-boundary interrupt with null scratchpad | Dialog shows node name + "no scratchpad data"; Approve/Deny available |
| EC-005 | `POST .../resume` returns server error | Error shown in dialog; dialog stays open; operator can retry |
| EC-006 | New `run_id` returned after resume | Console navigates to live monitoring for new run |

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
3. [ ] Implement interrupt detection: (a) SSE event handler filters `tool_approval_request` events for the tool-approval interrupt path; (b) SSE `onclose`/stream-end handler checks run STATUS via run-status endpoint — if `interrupted`, trigger the node/graph-boundary interrupt dialog path. No `graph_interrupt` stream event exists.
4. [ ] Implement Approve action: POST `Command { resume: PreToolDecision::Allow }` to `/threads/{id}/runs/{run_id}/resume`
5. [ ] Implement Deny action: require reason text input; POST `Command { resume: PreToolDecision::Deny(reason) }`
6. [ ] Implement Edit action: inline JSON editor; client-side JSON validation; submit disabled on invalid JSON
7. [ ] Implement FIFO queue: multiple pending interrupts surfaced one at a time in arrival order
8. [ ] Implement post-resume navigation: fetch new `run_id`; transition to run inspection panel
9. [ ] Handle resume server errors: show error in dialog; keep dialog open
10. [ ] Run SPA tests — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-06 (run inspection panel). The `sse.ts` SSE subscription library and `api.ts` REST client are established by S-console-06. The HITL dialog reuses the SSE event stream already open for run inspection — it listens for `tool_approval_request` SSE events and monitors SSE stream-end events (for node/graph-boundary interrupts, which halt the stream rather than emitting a dedicated event) on the same `EventSource` instance. Post-resume, the console transitions to the run inspection panel using the same navigation pattern established in S-console-06.

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
