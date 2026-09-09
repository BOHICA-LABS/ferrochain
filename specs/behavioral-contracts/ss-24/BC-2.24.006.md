---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.006
version: "1.7"
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
  - "1.1 (D-356-fix/DC-01/2026-09-06, product-owner): F-PDC01-01 Story Anchor corrected: was S-console-06, now S-console-08. Verified against S-console-08 frontmatter behavioral_contracts: [BC-2.24.006]."
  - "1.2 (D-356-fix/DC-02/2026-09-07, product-owner): F-PDC02-01 PRE-002 and PC-001 graph_interrupt SSE-event references removed. Node-boundary interrupt detection re-scoped: detected via interrupted run-status (CAP-006 interrupt() machinery), NOT via any SSE event — there is no graph_interrupt StreamEvent. Tool-approval interrupt detection remains via tool_approval_request StreamEvent (CAP-034). Related BCs section updated to remove graph_interrupt reference."
  - "1.3 (D-356-fix/DC-23/2026-09-08, product-owner): F-PDC23-01: Architect ruling — resume is SAME run_id (BC-2.12.003 SS-12 lifecycle is authoritative). PC-005 corrected: 'server returns a new run_id' → 'run transitions to in_progress on the SAME run_id — no new run_id is issued; console continues monitoring existing run SSE stream'. EC-006 corrected: 'Run resumes with new run_id' → 'Run resumes (same run_id; interrupted → in_progress)'. TV-002: 'live monitoring opens for new run' → 'live monitoring continues for same run (run_id unchanged)'. §Related BCs §Composes: 'for new run' → 'for same run (run_id unchanged)'."
  - "1.4 (D-356-fix/DC-25/2026-09-08, product-owner): F-PDC25-01 (HIGH): PRE-002 and PC-001(a) over-corrected 'NO SSE event' — replaced with correct terminal-frame wording per BC-2.12.007 §EC-003. Node-boundary interrupts emit no StreamEvent variant but DO terminate the SSE stream with {\"__interrupt__\": [InterruptPayload]} envelope frame; detection is via this terminal frame (primary) and/or interrupted STATUS, not STATUS-only. PC-001(a) re-labeled from 'run-status polling' to 'terminal SSE frame'. PC-002 node-boundary dialog source fixed: sources value field (arbitrary JSON scratchpad, per BC-2.05.001 TV-001) + interrupt_id hash from terminal frame — not from run-status/run-read path; field name corrected from 'scratchpad' to canonical 'value'."
  - "1.5 (D-356-fix/DC-26/2026-09-08, product-owner): F-PDC26-01 (HIGH) + F-PDC26-02 (MED): Comprehensive whole-file sweep. node_name/node-name residue removed from PRE-002 ('and node name' dropped — frame carries value+interrupt_id only), EC-004 (rewritten: shows interrupt_id+null value, explicitly NO node name), TV-005 (rewritten: canonical {\"__interrupt__\":[{value,interrupt_id}]} wire format, node-name/scratchpad field removed). §Related BCs BC-2.12.007: 'run-status polling, not SSE' replaced with terminal-frame wording (BC-2.12.007 §EC-003 + interrupted status corroboration); no-graph_interrupt clause retained. DC-02 blockquote: two SUPERSEDED-BY-DC-25 inline annotations at STATUS-only and STATUS-polling claims; historical record preserved intact."
  - "1.6 (D-356-fix/DC-27/L-288/2026-09-08, product-owner): F-L288-001 (HIGH): §Description final sentence 'subscribes to the new run stream' → 'continues monitoring the same run's SSE stream (run_id unchanged; BC-2.24.004 live monitoring)'. DC-23 corrected PC-005/EC-006/TV-002/§Related-BCs to same-run semantics but had missed the Description."
  - "1.7 (D-356/DC-46/2026-09-09, product-owner): A-PDC46: §Architecture Anchors phantom ADR path corrected — 'ADR-018-pre-tool-call-hook.md' does not exist; corrected to 'ADR-018-per-tool-call-approval-hook.md' (the actual file). verify-arch-anchor-resolution.sh blocker cleared."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-045
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "2d65ac5"
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
continues monitoring the **same** run's SSE stream (run_id unchanged; BC-2.24.004 live monitoring).

> **D-356 adversary fix DC-27/L-288 (2026-09-08, product-owner).** F-L288-001 (HIGH): §Description final sentence was stale — said "subscribes to the **new** run stream". DC-23 corrected PC-005/EC-006/TV-002/§Related-BCs to same-run semantics but missed the Description. Corrected to "continues monitoring the **same** run's SSE stream (run_id unchanged)" for full consistency with PC-005.

## Preconditions

1. {PRE-001} A run in `interrupted` status exists on the selected thread (either a node-boundary interrupt via `interrupt()` machinery, CAP-006, or a per-tool-call approval request, CAP-034).
2. {PRE-002} Either: (a) the run's SSE stream contains one or more `tool_approval_request` StreamEvents (CAP-034, for per-tool-call approval interrupts); or (b) the run's status is `interrupted` as returned by run-status polling (for node-boundary interrupts via `interrupt()` machinery, CAP-006). node-boundary interrupts emit no StreamEvent *variant*, but the SSE stream TERMINATES with a `{"__interrupt__": [InterruptPayload]}` envelope frame (BC-2.12.007 §EC-003) carrying the scratchpad (`value`) and `interrupt_id`; the run status also transitions to `interrupted`. The console detects the interrupt from this terminal frame (primary; carries the payload) and/or the `interrupted` status.
3. {PRE-003} `POST /threads/{id}/runs/{run_id}/resume` is available on pregolya-server (BC-2.05.004).

## Postconditions

1. {PC-001} **Interrupt detection:** The console identifies runs in `interrupted` status via two mechanisms: (a) **terminal SSE frame** — node-boundary interrupts (CAP-006 `interrupt()` machinery) terminate the SSE stream with a `{"__interrupt__": [InterruptPayload]}` envelope frame (BC-2.12.007 §EC-003); the run status also transitions to `interrupted`. The console detects the interrupt from this terminal frame (primary; carries the payload) and/or the `interrupted` status; (b) **`tool_approval_request` StreamEvent** — per-tool-call approval interrupts (CAP-034) emit a `tool_approval_request` event in the SSE stream before halting. Interrupted runs are visually flagged (e.g., with a badge).

   > **D-356 adversary fix DC-02 (2026-09-07, product-owner).** F-PDC02-01 graph_interrupt references removed from PRE-002 and PC-001. `graph_interrupt` is phantom — there is no such StreamEvent in the verified 16-variant canonical enum (BC-2.06.001 §Postconditions PC-002). Node-boundary interrupts (CAP-006) halt the stream without emitting any SSE event; detection is exclusively via run STATUS transitioning to `interrupted`. *(SUPERSEDED by DC-25: detection is via the terminal `{"__interrupt__": [InterruptPayload]}` SSE frame; the "STATUS-only" claim was an over-correction.)* The sole interrupt-adjacent SSE event is `tool_approval_request` (emitted BEFORE a tool-call interrupt halts the run). PC-001 re-scoped accordingly; PRE-002 re-scoped to STATUS-polling for node-boundary *(superseded by DC-25)*, `tool_approval_request` event for tool-approval. Related BCs section updated to remove graph_interrupt reference.
2. {PC-002} **Approval dialog contents:**
   - For **node-boundary interrupts** (CAP-006 `interrupt()` machinery): the dialog sources the interrupt payload from the terminal `{"__interrupt__": [InterruptPayload]}` frame (BC-2.12.007 §EC-003, BC-2.05.001 TV-001). The dialog shows the `value` field (arbitrary JSON passed to `interrupt()` — the scratchpad) and the `interrupt_id` hash.
   - For **per-tool-call interrupts** (CAP-034 `tool_approval_request` StreamEvent): the dialog shows the `ToolCallPreview` — tool name, args as JSON, and `ActionRisk` level — from the `tool_approval_request` event payload.

   > **D-356 adversary fix DC-25 (2026-09-08, product-owner).** F-PDC25-01 (HIGH): PRE-002 and PC-001(a) over-corrected "no SSE event" claim (DC-02 went too far). BC-2.12.007 §EC-003 confirms node-boundary interrupts DO terminate the SSE stream with a `{"__interrupt__": [InterruptPayload]}` envelope frame — they emit no StreamEvent *variant*, but the terminal frame IS the interrupt signal. PRE-002 and PC-001(a) updated accordingly: detection via terminal frame (primary) and/or `interrupted` STATUS; "run-status polling" label replaced with "terminal SSE frame". PC-002 node-boundary dialog source fixed: `value` field (arbitrary JSON scratchpad, per BC-2.05.001 TV-001) + `interrupt_id` hash sourced from terminal frame — NOT from run-status/run-read path; field name `scratchpad` replaced with canonical `value`.

   > **D-356 adversary fix DC-26 (2026-09-08, product-owner).** F-PDC26-01 (HIGH) + F-PDC26-02 (MED): Comprehensive whole-file `node_name`/`node name` + `STATUS-polling`/`not SSE` residue sweep. PRE-002: "and node name" dropped — terminal frame carries `value` + `interrupt_id` (BC-2.05.001 TV-001), no node name. EC-004: rewritten to match S-console-08 EC-004 — shows `interrupt_id` (hash) + null `value`; explicitly states NO node name (not an InterruptPayload field). TV-005: rewritten with canonical wire format `{"__interrupt__": [{"value": ..., "interrupt_id": ...}]}` per BC-2.05.001 TV-001; "node name" and `scratchpad` field name removed. §Related BCs BC-2.12.007: "run-status polling, not SSE" replaced with terminal-frame wording (BC-2.12.007 §EC-003) + "`interrupted` status corroboration"; "no `graph_interrupt` StreamEvent variant" clause retained. DC-02 blockquote: two inline SUPERSEDED-BY-DC-25 annotations added at the "STATUS-only" and "STATUS-polling" claims; historical record preserved.

3. {PC-003} **Operator decisions:**
   - **Approve:** the console maps to `Command { resume: PreToolDecision::Allow }` (for tool-call interrupts) or the appropriate resume variant for node-boundary interrupts. Sends `POST .../resume`.
   - **Deny (with reason text):** maps to `Command { resume: PreToolDecision::Deny(reason) }`. Sends `POST .../resume`.
   - **Edit (modify args inline):** operator edits the tool call args JSON in the dialog. Console maps the modified args to the resume payload. Sends `POST .../resume` with edited args.
4. {PC-004} **FIFO multi-interrupt ordering (DI-003):** When multiple pending approvals exist in the queue, the console surfaces them in FIFO arrival order (first-received first). Only one interrupt is shown at a time; after dispatching resume for the first, the next is surfaced if the run remains interrupted.
5. {PC-005} **Post-resume live monitoring:** After a successful `POST .../resume`, the run transitions to `in_progress` on the SAME run_id — no new run_id is issued. The console continues monitoring the existing run's SSE stream (`GET /threads/{id}/runs/{run_id}/stream`, BC-2.24.004); the run_id is unchanged.
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
| {EC-004} | Node-boundary interrupt with null scratchpad (`value: null`) | Dialog shows `interrupt_id` (hash) + null `value`; NO node name displayed (not an InterruptPayload field); Approve/Deny still available |
| {EC-005} | `POST .../resume` returns server error | Error displayed in dialog; dialog remains open; operator can retry |
| {EC-006} | Run resumes (same run_id; `interrupted` → `in_progress`) | Console continues live monitoring for the same run (run_id unchanged) |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `tool_approval_request` event with `tool_name: "WriteFile"`, `ActionRisk::High`, args `{path: "/tmp/out"}` | Dialog shows tool name, High risk, args JSON; Approve/Deny/Edit buttons enabled | happy-path, tool interrupt |
| TV-002 | Operator clicks Approve | `POST .../resume` with `Command { resume: PreToolDecision::Allow }` dispatched; dialog closes; live monitoring continues for same run (run_id unchanged) | approve decision |
| TV-003 | Operator clicks Deny with reason "too risky" | `POST .../resume` with `Command { resume: PreToolDecision::Deny("too risky") }` dispatched | deny decision |
| TV-004 | Operator edits args to `{invalid json}` and clicks submit | Submit rejected client-side; JSON parse error shown; no POST dispatched | EC-002 |
| TV-005 | Terminal SSE frame `{"__interrupt__": [{"value": {"question": "proceed?"}, "interrupt_id": "abc123"}]}` (BC-2.12.007 §EC-003, BC-2.05.001 TV-001) | Dialog shows `value: {"question": "proceed?"}` + `interrupt_id: abc123`; NO node name displayed (not an InterruptPayload field); Approve/Deny available | node-boundary interrupt |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.006-A | Approve sends `PreToolDecision::Allow` resume payload; Deny sends `PreToolDecision::Deny(reason)` | Integration test: mock server; assert POST body matches decision |
| VP-2.24.006-B | Multiple interrupts surfaced in FIFO order | Integration test: enqueue 2 `tool_approval_request` events; assert first-in is first shown |

## Related BCs

- BC-2.05.004 — depends on: `POST /threads/{id}/runs/{run_id}/resume` endpoint (exact contract consumed)
- BC-2.12.007 — depends on: SSE stream for detecting `tool_approval_request` events (tool-approval interrupts) and the terminal `{"__interrupt__": [InterruptPayload]}` frame for node-boundary interrupts (primary; BC-2.12.007 §EC-003) and/or `interrupted` status corroboration — there is no `graph_interrupt` StreamEvent variant
- BC-2.24.004 — composes with: after resume, console continues live monitoring (BC-2.24.004) for same run (run_id unchanged)

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — §Traceability row "HITL console resume dialog (CAP-045 — SS-24, SS-05)"
- `architecture/decisions/ADR-018-per-tool-call-approval-hook.md` — `PreToolDecision`, `ToolCallPreview`, `ActionRisk` types

## Story Anchor

S-console-08 (Wave 3 — HITL console resume dialog)

> **D-356 adversary fix DC-23 (2026-09-08, product-owner).** F-PDC23-01: PC-005, EC-006, TV-002, and §Related-BCs §Composes corrected — per architect ruling (BC-2.12.003 §lifecycle is authoritative), resume is the SAME run: `interrupted` → `in_progress` on the same run_id; no new run_id issued. Prior wording ("server returns a new `run_id`"; "Console navigates to live monitoring panel for the new `run_id`") was architecturally incorrect.

> **D-356 adversary fix DC-01 (2026-09-06, product-owner).** Story Anchor corrected S-console-06 → S-console-08. story-writer split BC-2.24.002 across S-console-02+03 and added S-console-05 (SPA build, no BC), shifting the numbering. Verified: S-console-08 frontmatter carries `behavioral_contracts: [BC-2.24.006]`.

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
