---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.005
version: "1.2"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-044
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-002, DI-004, DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.2 (D-356-fix/DC-04/2026-09-07, product-owner): F-PDC04-01: all checkpoint_id occurrences corrected from JSON string form to canonical u64 numeric form (CheckpointId newtype over u64 per BC-2.04.003 §Architecture Anchors; BC-2.12.003 TV-014 precedent). TV-002 ?checkpoint_id=ckpt-2 → ?checkpoint_id=2; TV-003 checkpoint_id: \"ckpt-1\" → checkpoint_id: 1; PC-003 placeholder quotes removed. F-PDC04-02: PC-002 citation updated to reference BC-2.12.001 {PC-015} ?checkpoint_id variant (added in BC-2.12.001 v1.11 DC-04 burst)."
  - "1.1 (D-356-fix/DC-03/2026-09-07, product-owner): F-PDC03-02: PC-003 fork mechanism made concrete — specifies config.configurable.checkpoint_id as the fork-start key (idiomatic LangGraph fork-start pattern; executor semantic defined in BC-2.12.003 {INV-009} added in this same fix burst). PC-005 wording corrected: 'no new server machinery' → 'no new server endpoints'; config.configurable.checkpoint_id is new documented server BEHAVIOR on the existing POST /threads/{id}/runs endpoint, not a new endpoint. TV-003 updated to show correct fork request shape."
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. Checkpoint history browser and fork-from-checkpoint trajectory replay."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-044
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "805b7eb"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.005: Checkpoint History Browser and Fork-from-Checkpoint Trajectory Replay (CAP-044)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

> **D-356 adversary fix DC-04 (2026-09-07, product-owner).** F-PDC04-01: all `checkpoint_id` values corrected from JSON string form (`"ckpt-1"`, `"ckpt-2"`) to canonical u64 numeric form (`1`, `2`) — `CheckpointId` is a newtype over `u64` (BC-2.04.003 §Architecture Anchors; BC-2.12.003 TV-014 uses `checkpoint_id: 5`). F-PDC04-02: PC-002 state-inspection citation updated to reference BC-2.12.001 {PC-015} `?checkpoint_id` variant (added in BC-2.12.001 v1.11 this burst). S-console-07 sibling-sweep: implementer must use numeric `CheckpointId` in all `GET /threads/{id}/state?checkpoint_id=<N>` calls and all `POST /threads/{id}/runs` fork payloads.

> **D-356 adversary fix DC-03 (2026-09-07, product-owner).** F-PDC03-02: PC-003 fork mechanism made concrete. Original text cited "the existing run-creation request shape, BC-2.12.003" but BC-2.12.003 PC-001 has no checkpoint-selection field. Resolution: `config.configurable.checkpoint_id` is the fork-start key — idiomatic LangGraph pattern; the executor semantic is now defined in BC-2.12.003 {INV-009} (added in this same D-356-fix/DC-03 burst). PC-005 wording corrected from "no new server machinery" to "no new server endpoints" — the `checkpoint_id` configurable key is new DOCUMENTED server BEHAVIOR on the existing Create-Run endpoint, not a new endpoint. This is within the D-356 human-authorized reopening scope.

## Description

The checkpoint history panel presents a thread's ordered checkpoint sequence, enabling
the developer-operator to browse historical execution state and fork a new run from any
past checkpoint. The panel reads checkpoint history via `GET /threads/{id}/history`
(BC-2.12.001) and per-checkpoint state via `GET /threads/{id}/state?checkpoint_id=<id>`.
Fork-from-checkpoint creates a new run via `POST /threads/{id}/runs` with `config.configurable.checkpoint_id` set to the selected checkpoint (BC-2.12.003 {INV-009}). No new server endpoints are required — this capability uses the existing checkpoint substrate and Create-Run endpoint with the fork-start configurable key (idiomatic LangGraph time-travel pattern).

## Preconditions

1. {PRE-001} A thread `{id}` is selected in the console.
2. {PRE-002} The thread has at least one committed checkpoint (DI-002: per-task durability — checkpoints survive process restart).
3. {PRE-003} `GET /threads/{id}/history` is available on the pregolya-server (BC-2.12.001).
4. {PRE-004} For fork-from-checkpoint: `POST /threads/{id}/runs` is available (BC-2.12.003).

## Postconditions

1. {PC-001} **History timeline displayed:** The console renders a time-ordered list of checkpoints for the thread, newest-first (matching the `GET /threads/{id}/history` ordering, BC-2.12.001). Each entry shows:
   - `step_idx`: the monotone logical clock position (DI-004 — monotonically non-decreasing).
   - The node that executed at that step (extracted from checkpoint metadata).
   - A summary of state delta applied at that step.
2. {PC-002} **Checkpoint state inspection:** Selecting a history entry issues `GET /threads/{id}/state?checkpoint_id=<CheckpointId>` (CheckpointId is a u64 newtype; BC-2.04.003 §Architecture Anchors) and renders the full state snapshot (`values`, `checkpoint`, `next`) at that point (BC-2.12.001 {PC-015} `?checkpoint_id` variant, added v1.11 DC-04 burst). The state is rendered as structured JSON with collapsible fields.
3. {PC-003} **Fork-from-checkpoint:** From any history entry, the operator may initiate a fork: the console sends `POST /threads/{id}/runs` with `{ assistant_id: <id>, config: { configurable: { checkpoint_id: <selected_checkpoint_id> } } }` (where `<selected_checkpoint_id>` is a u64 `CheckpointId` numeric value, not a string). The `config.configurable.checkpoint_id` key instructs the executor to initialize the run's starting state from the specified checkpoint's stored `ChannelValues` rather than the thread's `current_checkpoint` — this is the idiomatic LangGraph fork-start pattern; the executor semantic is defined in BC-2.12.003 {INV-009}. A new `run_id` is returned; the console transitions to the live monitoring panel (BC-2.24.004) for the new run. Existing checkpoints beyond the fork point are NOT deleted (the fork is additive; contrast with `multitask_strategy: "rollback"` which resets the checkpoint chain).
4. {PC-004} **Pagination:** `GET /threads/{id}/history` accepts `?limit=N`. The console loads history in pages, showing a "load more" control when more checkpoints are available.
5. {PC-005} **No new server endpoints:** All operations use existing endpoints (`GET /threads/{id}/history`, `GET /threads/{id}/state?checkpoint_id=<CheckpointId>` (u64; BC-2.12.001 {PC-015} variant), `POST /threads/{id}/runs`). The console adds only the presentation layer. The `config.configurable.checkpoint_id` key in the fork request is new documented server BEHAVIOR on the existing Create-Run endpoint (executor semantic defined in BC-2.12.003 {INV-009}); it does not introduce a new endpoint.

## Invariants

- {INV-001} **DI-004 monotone step_idx:** The console MUST render checkpoints in the order returned by the server (`step_idx` is monotonically non-decreasing per DI-004). Rendering in reverse or sorted order by other fields is incorrect.
- {INV-002} **DI-002 durability:** Checkpoints displayed in the history survive process restart. The console reads them as durable server state — it does not need to handle "checkpoint disappeared" gracefully beyond a standard 404 error path.
- {INV-003} **Pure consumer:** The checkpoint history browser does not write to any checkpoint. Browse and fork are the only operations. Browsing is purely read-only.
- {INV-004} **DI-014:** Server errors on history fetch or state fetch propagate as user-visible error messages. Partial failures (some checkpoints unreachable) surface individually per entry.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Thread has no checkpoints (new thread, no run completed) | History panel shows empty state ("no checkpoints yet") |
| {EC-002} | `GET /threads/{id}/state?checkpoint_id=<CheckpointId>` returns 404 E-CHKPT-011 (checkpoint evicted or compacted — BC-2.12.001 EC-010) | Panel shows "checkpoint no longer available" message for that entry; does not crash |
| {EC-003} | Fork-from-checkpoint: `POST /threads/{id}/runs` returns an error (e.g., E-SERVER-012 ConcurrentRun) | Error message displayed in the console; fork not started; operator can retry |
| {EC-004} | Very large history (`?limit` pagination) | Console loads first page and shows "load more" control; `step_idx` ordering preserved across pages |
| {EC-005} | Checkpoint state contains deeply nested JSON | State rendered with collapsible JSON tree; no truncation of the structure (truncation of individual string values is acceptable for display) |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Thread with 3 checkpoints; `GET /threads/t1/history` returns 3 entries | History panel shows 3 entries newest-first; each entry shows `step_idx`, node name, state delta summary | happy-path |
| TV-002 | Select checkpoint `step_idx=2`; `GET /threads/t1/state?checkpoint_id=2` (u64) returns state snapshot (BC-2.12.001 {PC-015} variant) | Checkpoint state panel renders JSON with `values`, `checkpoint`, `next` fields | state inspection |
| TV-003 | Fork from checkpoint at `step_idx=1` (`checkpoint_id=1`): console sends `POST /threads/t1/runs { assistant_id: "a1", config: { configurable: { checkpoint_id: 1 } } }` (u64 numeric; BC-2.04.003 §Architecture Anchors); server returns `run_id: run-99` | Console transitions to live monitoring panel for `run-99`; new run starts from checkpoint 1 state; existing checkpoints after step 1 are NOT deleted | fork-from-checkpoint; BC-2.12.003 {INV-009} |
| TV-004 | Thread with 0 checkpoints | History panel shows "no checkpoints yet" empty state | EC-001 |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.005-A | Checkpoint history rendered in `step_idx` monotone order | Integration test: verify rendered order matches server-returned order |
| VP-2.24.005-B | Fork-from-checkpoint produces a new `run_id` and navigates to live monitoring | Integration test: fork action; assert new run panel opens |

## Related BCs

- BC-2.12.001 — depends on: `/threads/{id}/history` endpoint (checkpoint history substrate)
- BC-2.12.003 — depends on: `POST /threads/{id}/runs` (fork-from-checkpoint uses standard run creation)
- BC-2.24.004 — composes with: after fork, console transitions to live monitoring panel (BC-2.24.004) for the new run
- BC-2.24.006 — composes with: if forked run results in a HITL interrupt, HITL dialog (BC-2.24.006) handles it

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — §Traceability row "Checkpoint history browser + trajectory replay (CAP-044 — SS-24, SS-04)"
- `architecture/decisions/ADR-002-checkpointing-strategy.md` — checkpoint substrate (three-tier durability)

## Story Anchor

S-console-07 (Wave 3 — checkpoint history browser + fork-from-checkpoint)

## VP Anchors

- VP-2.24.005-A
- VP-2.24.005-B

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-044 |
| Capability Anchor Justification | CAP-044 ("Checkpoint History Browser and Trajectory Replay") per capabilities-p1-p2.md §CAP-044 — this BC specifies the checkpoint history timeline, per-checkpoint state inspection, fork-from-checkpoint trajectory replay, and pagination that constitute the checkpoint browser described in CAP-044 |
| L2 Domain Invariants | DI-002 (Per-Task Durability — checkpoints are durable; history reflects committed state), DI-004 (Monotone step_idx ordering — history rendered in declared logical-clock order), DI-014 (Error Propagation — server errors surface as user-visible messages) |
| Architecture Authority | ADR-031 §Traceability (CAP-044 — SS-24, SS-04); BC-2.12.001 (checkpoint history endpoint) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.005-A/B |
| Module | pregolya-console / SPA (web frontend, pure REST client of /threads history API) |
| Priority | P1 |
| Wave | 3 |
| Test Types | integration (E2E) |
