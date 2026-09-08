---
document_type: story
level: ops
story_id: S-1.26
epic_id: E-14
version: "1.14"
status: draft
producer: story-writer
timestamp: 2026-08-24T00:00:00Z
changelog:
  - "1.14 (D-356/DC-13/2026-09-08): F-PDC13-02 — AC-021 and AC-022 added covering D-356-amended BC-2.12.001 {PC-015} checkpoint historical-state read and BC-2.12.003 {INV-009} fork-start. EC-022 and EC-023 added (checkpoint-absent 422 E-CHKPT-011 paths). Token budget updated (~55,000). No new VPs minted (BCs' test vectors TV-010, TV-011, TV-014 suffice)."
  - "1.1 (M3/ADR-027/2026-08-24): AC traces re-cited to stable clause anchors; 10 mis-anchors corrected (AC-001 PC1→PC-005, AC-002 PC2→PC-009, AC-003 PC3→PC-011, AC-004 BC2.PC1→INV-001, AC-005 BC2.PC2→EC-006, AC-006 BC3.PC1→PC-005, AC-007 BC3.PC2→PC-007, AC-008 BC3.PC3→PC-008, AC-009 BC3.PC4→INV-006, AC-010 BC3.INV1→PC-010)"
  - "1.2 (M3c/ADR-027/2026-08-24): ADR-027 M3c: escalation-resolution AC corrections"
  - "1.3 (M3c collision-fix + EC-006 coverage restore/2026-08-24): AC-005 E-SERVER-012→E-SERVER-017 (AssistantAlreadyExists); AC-009 stale AC-005 cross-ref removed, EC-006 configurable-merge stated directly, BC-2.12.002 EC-006 trace added"
  - "1.4 (P2A-043 F-05/2026-08-24): compliance-table EC citations converted to stable tags — EC-001 source BC-2.12.001 EC-1→EC-001 (clause text match); EC-007 source BC-2.12.003 EC-1→EC-002 (clause text match: concurrent run / E-SERVER-012); 8 citations escalated (EC-002..006, EC-008..010): descriptions map to PCs not ECs — product-owner resolution required"
  - "1.5 (P2A-043 F-05/2026-08-24): escalated EC citations redirected/repointed per PO adjudication (incl. new BC-2.12.001 EC-006)"
  - "1.6 (P2A-044 F-01 (9th arc queued→cancelled) + F-07 (EC-005→PC-024) + F-08 (EC-008→EC-006/E-SERVER-018)/2026-08-24)"
  - "1.7 (SW-3/P2A-BC-scan-hardening/2026-08-26): BC-completeness hardening — 7 new ACs (AC-011..AC-017) and 8 new ECs (EC-011..EC-018). BC-2.12.001: AC-011 (EC-007 POST /state thread-not-found → 404 E-SERVER-003), AC-012 (EC-008/EC-009 POST /state invalid as_node or malformed delta → 422 E-SERVER-022 reason-discriminated). BC-2.12.003: AC-013 (EC-007 enqueue queue-full → 429 E-SERVER-019), AC-014 (PC-004 ADR-028 D1 multitask=interrupt pre-empted run → cancelled), AC-015 (PC-004 ADR-028 D2 multitask=rollback → latest_completed_checkpoint_id). BC-2.12.002: AC-016 (EC-003 delete_threads=true active constituent run → 409 E-SERVER-008 atomic-abort), AC-017 (EC-007 PATCH empty graph_id → 400 E-SERVER-020). BC-table version column removed (D-50 anti-version-pin). Token-budget revised (~52,500)."
  - "1.8 (round-42/F-P2A177-01/2026-08-29): F-P2A177-01 [HIGH, CWE-248/703, SEC-008] — Propagate BC-2.12.003 EC-003 node-body-panic recovery and {INV-007} panic-text-isolation invariant. AC-018 added: pregolya-server run-executor wraps graph execution in FutureExt::catch_unwind(AssertUnwindSafe(...)); node-body panic caught during .await polling → Err(PregolyaError { code: E-GRAPH-019, category: INTERNAL, message: 'NodePanic: graph node panicked during execution — see server error log for details', retry_hint: Never, .. }); run transitions in_progress → failed with E-GRAPH-019 STATIC message; raw panic text logged server-side at ERROR only, MUST NEVER appear in Run.error.message ({INV-007}); run MUST NOT remain in_progress ({INV-005} no orphan runs); SEC-008 obligation noted (panic = unwind required on pregolya-server release profile). EC-019 added to edge cases table (node-body-panic path). Architecture Compliance Rule 9 added (panic = unwind on pregolya-server release profile). New Task for catch_unwind implementation added. E-GRAPH-019 NodePanic referenced in new AC and error taxonomy. Test vector BC-2.12.003 TV-011 anchored to AC-018. input-hash refreshed (BC-2.12.003 updated round-42)."
  - "1.9 (round-46/F-193-01 sibling/2026-08-30): F-193-01 [HIGH, CWE-248/703, SEC-008] — Stale crate-member SEC-008 framing corrected at two sites. (1) AC-018 SEC-008 clause: 'on the pregolya-server release profile' replaced with workspace-root Cargo.toml framing — authoritative pin lives at workspace root (applied to pregolya-server binary at link time); pregolya-server/Cargo.toml member-profile override is silently ignored by Cargo and MUST NOT be relied upon; CWE-248 updated to CWE-248/703; DevOps Phase-3 workspace init obligation stated. (2) Architecture Compliance Rule 9: 'required on pregolya-server release profile' replaced with workspace-root framing (same semantics as site 1); 'Cargo.toml authoring' updated to 'workspace init'. Both sites now byte-consistent with BC-2.09.008 EC-010 v3.5 / S-2.11 AC-037 canonical form (F-P2A181-01 sibling). input-hash updated (64ea9cd — BC-2.12.003 round-43 computed hash)."
  - "1.10 (round-47/F-P2A197-01+F-P2A197-02/2026-08-30): F-P2A197-01 [HIGH, CWE-209, SEC-BOUND-001] — BC-2.12.003 {INV-007} extended: E-GRAPH-011 ConditionalEdgePanic added to HTTP-boundary panic-text-isolation scope alongside E-GRAPH-019 NodePanic. AC-019 added: run-executor static-replaces E-GRAPH-011 message before populating Run.error.message; source_node + panic text suppressed; TV-012 anchored. EC-020 added (E-GRAPH-011 edge case). F-P2A197-02 [MED, CWE-209/532, SEC-BOUND-001] — BC-2.12.003 {INV-008} new: External-Boundary Error-Sanitization mandatory 3-step pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids; order mandatory) before Run.error.message surfaced via {PC-013}/{PC-016}. AC-020 added: TV-013 anchored; ADR-029 SEC-BOUND-001 cited. EC-021 added (credential-redaction edge case). Architecture Compliance Rule 9 extended: E-GRAPH-011 named alongside E-GRAPH-019; {INV-008} 3-step pipeline added. BC table BC-2.12.003 row updated. Failing-test range extended to AC-001..AC-020. Token budget updated (~53,500). input-hash refreshed (3d8fb63 — BC-2.12.003 round-47 computed hash)."
  - "1.11 (round-48/F-P2A200-01+F-P2A200-02+F-P2A202-01/2026-08-30): F-P2A200-01 [HIGH] — AC-019 catch-boundary mislocation corrected: conditional-edge path_fn panic is caught by the Pregel executor (synchronous std::panic::catch_unwind in graph::bsp_engine per BC-2.02.005 {PC-005}; path_fn is sync per BC-2.02.005 {PRE-004}); E-GRAPH-011 arrives at the server as an already-formed Err; server applies {INV-007} STATIC message replacement before writing to Run.error.message (NOT FutureExt::catch_unwind at server boundary); AC-019 rewritten; Task and Architecture Compliance Rule 9 updated (E-GRAPH-011 removed from catch_unwind scope; Pregel-caught Err path clarified). F-P2A200-02 [MED] — AC-020 steps 2 and 3 aligned to BC-2.12.003 {INV-008} canonical form: step 2 redact_credentials now cites explicit 4-pattern set (BC-2.09.007 {INV-003}(b)); step 3 sanitize_internal_ids now specifies UUID-shaped identifiers only with token <redacted-id> and u64-CheckpointId carve-out (not node/edge IDs; not <sanitized>). F-P2A202-01 [LOW/records] — v1.10 changelog severity label corrected: F-P2A197-02 relabelled [MED] (was [HIGH] in error; canonical severity per BC-INDEX and STATE.md). Token budget updated (~54,000). input-hash refreshed (6483719 — BC-2.12.003 round-48 computed hash)."
  - "1.12 (round-49/BC-propagation/2026-08-31): BC-2.09.007 {INV-003} extended from 4 to 6 patterns (URL-userinfo + HTTP Basic). AC-020 step 2: 'canonical four-pattern set' → 'canonical six-pattern set'; patterns (e) URL-embedded userinfo `[a-zA-Z][a-zA-Z0-9+.\-]*://[^/\s:@]+:[^/\s:@]+@` (TV-012) and (f) HTTP Basic auth `Basic\\s+[A-Za-z0-9+/=]+` (base64 padding prevents pattern (c) match; TV-013) added. Architecture Compliance Rule 9 {INV-008} and sanitize_error_message Task updated to cite 6-pattern set. input-hash refreshed (033617f — BC-2.12.003 round-49 computed hash)."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-12/BC-2.12.001.md
  - .factory/specs/behavioral-contracts/ss-12/BC-2.12.002.md
  - .factory/specs/behavioral-contracts/ss-12/BC-2.12.003.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "6cac245"
traces_to:
  - behavioral-contracts/BC-2.12.001
  - behavioral-contracts/BC-2.12.002
  - behavioral-contracts/BC-2.12.003
points: 8
depends_on: [S-1.16, S-1.10, S-1.04]
blocks: [S-1.27]
behavioral_contracts: [BC-2.12.001, BC-2.12.002, BC-2.12.003]
verification_properties: []
priority: P1
cycle: v1.0.0-greenfield
wave: 1
target_module: pregolya-server
subsystems: [SS-12]
estimated_days: 3
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
# BC status: N/A — BCs authored (BC-2.12.001, BC-2.12.002, BC-2.12.003)
---

# STORY-S-1.26: Thread, Assistant, and Run CRUD REST Endpoints

## Narrative

As an API consumer, I want Thread, Assistant, and Run CRUD endpoints so that I can programmatically create and manage conversation threads, register assistant configurations with versioned snapshots, and submit graph runs with a full lifecycle state machine from `queued` through terminal states.

## Token Budget Estimate

| Context Component | Estimated Tokens |
|-------------------|-----------------|
| This story spec | ~9,000 |
| BC files (3 BCs: BC-2.12.001–003) | ~13,000 |
| Architecture module-decomposition.md | ~3,000 |
| Target source files (pregolya-server/src/routes/) | ~12,000 |
| Test files | ~15,000 |
| S-1.16 (BSP super-step determinism) route scaffolding | ~2,000 |
| **Total estimate** | **~55,000** |

Comfortable within context window. No split required.

## Behavioral Contracts

| BC ID | Title | Red Gate? |
|-------|-------|-----------|
| BC-2.12.001 | Thread Resource CRUD (Create, Read, List, Delete Durable Conversation History) | No |
| BC-2.12.002 | Assistant Resource CRUD (Named Agent Config with Graph Reference) | No |
| BC-2.12.003 | Run Creation and Execution Lifecycle (queued → in_progress → completed/failed/cancelled/summary_halt; interrupted is pausable/resumable) | No |

## Acceptance Criteria

### AC-001: Thread POST — creates thread and returns 201
`POST /threads` creates a new thread with a generated `thread_id` and returns HTTP 201 with the thread object. Duplicate `thread_id` (if caller provides one) returns `E-SERVER-007` (ThreadAlreadyExists).
(traces to BC-2.12.001 PC-005)

### AC-002: Thread GET/LIST — returns thread(s), clamped limit
`GET /threads/:id` returns the thread or `E-SERVER-003` (ThreadNotFound). `GET /threads?limit=N` returns up to min(N, 100) threads sorted by `created_at DESC`. Default limit is 10.
(traces to BC-2.12.001 PC-009)

### AC-003: Thread DELETE — cascade-deletes checkpoint
`DELETE /threads/:id` deletes the thread and cascade-deletes any associated checkpoint data. Returns `E-SERVER-003` if thread not found. Returns `E-SERVER-008` (ThreadStateConflict) if a run is currently active on the thread.
(traces to BC-2.12.001 PC-011)

### AC-004: Assistant POST — creates versioned snapshot
`POST /assistants` creates an assistant at `version = 1`. Each subsequent `PATCH /assistants/:id` creates a new immutable version snapshot. Versions list (`GET /assistants/:id/versions`) is ordered `version ASC` (exemption from canonical `created_at DESC`).
(traces to BC-2.12.002 INV-001)

### AC-005: Assistant error scenarios — GraphNotFound and AssistantAlreadyExists
`POST /assistants` with a `graph_id` referencing a non-existent graph returns `E-SERVER-011` (GraphNotFound). `POST /assistants` with `if_exists=raise` when an assistant with that identifier already exists returns `E-SERVER-017` (AssistantAlreadyExists).
(traces to BC-2.12.002 PC-005, EC-005)

### AC-006: Run POST — enqueues with queued state
`POST /threads/:id/runs` creates a run with initial state `queued`. Returns `E-SERVER-002` (RunNotFound) on GET for non-existent run. Returns `E-SERVER-012` (ConcurrentRun) if another run is already active on the same thread.
(traces to BC-2.12.003 PC-005)

### AC-007: Run state machine — 9-arc transitions
The run state machine supports these arcs: `queued → in_progress`, `queued → cancelled`, `in_progress → completed`, `in_progress → failed`, `in_progress → interrupted`, `in_progress → cancelled`, `in_progress → summary_halt`, `interrupted → in_progress` (resume), `interrupted → cancelled`. No other state transitions are valid.
(traces to BC-2.12.003 PC-007)

### AC-008: summary_halt is terminal, output populated, directly deletable
`summary_halt` is a terminal state. A run in `summary_halt` has its `output` field populated. The run can be deleted directly (no prior cancel required). `summary_halt` is distinct from `failed`.
(traces to BC-2.12.003 PC-008)

### AC-009: Run-Config Merge Precedence — run wins over assistant at leaf level
When creating a run, merge precedence for `configurable`: run-provided values win over assistant-stored values at each leaf key. A run supplying `{ "model": "gpt-4" }` does not erase assistant-stored keys absent from the run config; only keys present in the run config are overridden.
(traces to BC-2.12.003 INV-006, BC-2.12.002 EC-006)

### AC-010: interrupted → cancelled arc exists
A run in `interrupted` state (awaiting HITL approval) can be transitioned to `cancelled` without going through `in_progress`. `DELETE /threads/:id/runs/:run_id` or a cancel API call on an `interrupted` run results in `cancelled` state.
(traces to BC-2.12.003 PC-010)

### AC-011: POST /state on non-existent thread → 404 E-SERVER-003
`POST /threads/:id/state { values: { ... } }` where thread `:id` does not exist returns HTTP 404 `{ code: "E-SERVER-003", message: "ThreadNotFound: thread '<id>' does not exist" }`. No state mutation occurs.
(traces to BC-2.12.001 EC-007)

### AC-012: POST /state invalid as_node or malformed delta → 422 E-SERVER-022 (reason-discriminated)
`POST /threads/:id/state` returns HTTP 422 `E-SERVER-022 StateUpdateInvalid` in two scenarios distinguished by the `<reason>` field: (a) `as_node` is provided but does not refer to a valid node in the associated graph definition — message: `"StateUpdateInvalid: state update for thread '<thread_id>' rejected: as_node '<node>' is not registered in the graph"`; (b) the `values` delta contains a field whose type is incompatible with the graph's state schema — message: `"StateUpdateInvalid: state update for thread '<thread_id>' rejected: field '<field>' type incompatible: expected <type>, got <actual>"`. Both scenarios use the single code E-SERVER-022; the `<reason>` clause discriminates them.
(traces to BC-2.12.001 EC-008, BC-2.12.001 EC-009)

### AC-013: Run enqueue queue-full → 429 E-SERVER-019
`POST /threads/:id/runs { multitask_strategy: "enqueue" }` when the thread's `queued` Run count has already reached `max_queued_runs` (default 10, configurable per server-instance at startup) returns HTTP 429 `{ code: "E-SERVER-019", message: "RunQueueFull: thread '<thread_id>' already has <queue_depth> queued run(s); max_queued_runs=<max_queued_runs>" }`. No new Run is created. The caller should wait for the `in_progress` Run to reach a terminal state (freeing a slot) before retrying (ADR-028 Decision 3).
(traces to BC-2.12.003 PC-004, BC-2.12.003 EC-007)

### AC-014: multitask_strategy=interrupt — pre-empted run transitions to cancelled (ADR-028 D1)
`POST /threads/:id/runs { multitask_strategy: "interrupt" }` when a Run is already `queued` or `in_progress` on the thread: the pre-empted Run transitions to `cancelled` (NOT `interrupted` — `interrupted` is reserved for HITL-pause). The new Run enters `queued` immediately and the server returns HTTP 202. The executor MUST NOT start the new Run until the pre-empted Run's `cancelled` state is durably written to the RunStore. If the pre-empted Run is `queued` (not yet started), it transitions `queued → cancelled` without ever reaching `in_progress`.
(traces to BC-2.12.003 PC-004)

### AC-015: multitask_strategy=rollback — thread checkpoint reset to latest_completed_checkpoint_id (ADR-028 D2)
`POST /threads/:id/runs { multitask_strategy: "rollback" }` when a Run is active: (1) the pre-empted Run transitions to `cancelled`; (2) all checkpoint rows with `checkpoint_id > latest_completed_checkpoint_id` (captured at the moment `POST .../runs` is processed) are deleted for this thread; (3) the thread's `current_checkpoint` pointer is reset to `latest_completed_checkpoint_id`; (4) the new Run starts against the rolled-back state. If the thread has no prior completed checkpoint, the rollback target is the empty thread state. Partial rollback is not permitted — if checkpoint discard fails, returns `E-CHKPT-001 CheckpointWriteFailed` and the new Run is NOT started.
(traces to BC-2.12.003 PC-004)

### AC-016: DELETE assistant delete_threads=true with active constituent run → 409 E-SERVER-008
`DELETE /assistants/:id?delete_threads=true` when any constituent thread has a Run currently in `queued` or `in_progress` state returns HTTP 409 `{ code: "E-SERVER-008", message: "ThreadStateConflict: thread '<thread_id>' has an active run '<run_id>'; cascade delete aborted — assistant '<assistant_id>' and no thread records were modified" }`. Neither the assistant record nor any thread record is modified (atomic-abort, no partial deletion per ADR-028 Decision 4). The caller must cancel all active runs on all constituent threads before retrying.
(traces to BC-2.12.002 EC-003)

### AC-017: PATCH assistant with empty graph_id → 400 E-SERVER-020
`PATCH /assistants/:id { "graph_id": "" }` returns HTTP 400 `{ code: "E-SERVER-020", message: "Validation failed for 'graph_id': must not be empty" }`. No new version is created; the assistant record is not modified. `graph_id` is a required non-empty field (BC-2.12.002 INV-004); the empty-string update is rejected at request validation time before any store operation.
(traces to BC-2.12.002 EC-007, BC-2.12.002 INV-004)

### AC-018: Node-body panic → failed + E-GRAPH-019 + panic-text-isolation (SEC-008)
The `pregolya-server` run-executor wraps graph execution in `futures::future::FutureExt::catch_unwind(AssertUnwindSafe(...))`. When a graph node body panics during `.await` polling, the panic is caught and converted to `Err(PregolyaError { code: "E-GRAPH-019", category: INTERNAL, message: "NodePanic: graph node panicked during execution — see server error log for details", retry_hint: Never, .. })`. The run transitions `in_progress → failed`; `Run.error` is populated from the E-GRAPH-019 STATIC message. Raw panic text is logged server-side at ERROR severity only — it MUST NEVER appear in `Run.error.message` ({INV-007} panic-text-isolation). The run MUST NOT remain in `in_progress` state after the panic is caught ({INV-005}, no orphan runs). **SEC-008:** This panic recovery requires `panic = "unwind"` in the **workspace-root** `Cargo.toml` release profile (applied to the `pregolya-server` binary at link time); a `[profile.release] panic` line inside `pregolya-server/Cargo.toml` itself is silently ignored by the Cargo linker and MUST NOT be relied upon as the SEC-008 gate. `panic = "abort"` at the workspace root voids `FutureExt::catch_unwind` and causes process termination (CWE-248/703). DevOps asserts this pin at Phase-3 workspace init. Test vector BC-2.12.003 TV-011: Run `r1` on thread `t1` is `in_progress`; a graph node body calls `panic!("unexpected node failure")`; poll `GET /threads/t1/runs/r1`; result: `status == "failed"`, `error.code == "E-GRAPH-019"`, `error.message == "NodePanic: graph node panicked during execution — see server error log for details"` (STATIC — literal string equality), `error.message` does NOT contain `"unexpected node failure"` or any other panic text, no run remains orphaned in `in_progress` state.
(traces to BC-2.12.003 EC-003 — node-body-panic path; BC-2.12.003 {INV-007} panic-text-isolation; BC-2.12.003 {INV-005} no-orphan-runs)

### AC-019: ConditionalEdgePanic → failed + E-GRAPH-011 STATIC message at HTTP boundary ({INV-007} — Pregel-caught Err path, CWE-209)
Per BC-2.12.003 {INV-007}, a conditional-edge `path_fn` is synchronous; its panic is caught by the **Pregel executor** via synchronous `std::panic::catch_unwind` in `graph::bsp_engine` — NOT by the server's `FutureExt::catch_unwind` wrapper. The Pregel executor converts the caught panic to `Err(PregolyaError { code: "E-GRAPH-011", message: <captured panic text and source_node topology>, .. })` and propagates this already-formed `Err` up to the `pregolya-server` run-executor. The `pregolya-server` run-executor MUST apply {INV-007} STATIC message replacement BEFORE writing to `Run.error.message`: the `error.message` is replaced with `"ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details"` (STATIC — literal string equality). The original message (captured panic text and `source_node` topology) is logged at ERROR severity server-side only and MUST NEVER appear in `Run.error.message` (CWE-209). The run transitions `in_progress → failed` with the STATIC message. The run MUST NOT remain in `in_progress` state ({INV-005}, no orphan runs). Test vector BC-2.12.003 TV-012: Run `r1` on thread `t1` is `in_progress`; a conditional-edge `path_fn` panics with message `"unexpected routing failure"` and `source_node: "node_A"`; the Pregel executor catches it as E-GRAPH-011 ConditionalEdgePanic; poll `GET /threads/t1/runs/r1`; result: `status == "failed"`, `error.code == "E-GRAPH-011"`, `error.message == "ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details"` (STATIC — literal string equality), `error.message` does NOT contain `"unexpected routing failure"` or `"node_A"` or any other panic text or source_node topology, no run remains orphaned in `in_progress` state.
(traces to BC-2.12.003 {INV-007} panic-text-isolation — E-GRAPH-011 ConditionalEdgePanic path; BC-2.12.003 TV-012; BC-2.12.003 {INV-005} no-orphan-runs)

### AC-020: External-Boundary Error-Sanitization — mandatory 3-step pipeline before surfacing Run.error.message ({INV-008})
Before `Run.error.message` is surfaced via `{PC-013}` (GET run response) or `{PC-016}` (failed terminal state), the `pregolya-server` run-executor MUST apply the mandatory 3-step External-Boundary Error-Sanitization pipeline in exact order: (1) internal-panic static-replace per {INV-007} — E-GRAPH-019 NodePanic and E-GRAPH-011 ConditionalEdgePanic messages replaced with their respective STATIC variants before any other processing; (2) `redact_credentials` — scan `error.message` for credential-shaped substrings matching the canonical six-pattern set (per BC-2.12.003 {INV-008} step 2) and replace each match with `"<redacted>"`: (a) OpenAI key `sk-[A-Za-z0-9_\-]{20,}`, (b) Anthropic key `sk-ant-[A-Za-z0-9_\-]{32,}`, (c) generic long alphanumeric token `[A-Za-z0-9]{64,}`, (d) Bearer token `Bearer\s+[A-Za-z0-9._~+/=\-]+` (entire `Bearer <token>` span), (e) URL-embedded userinfo `[a-zA-Z][a-zA-Z0-9+.\-]*://[^/\s:@]+:[^/\s:@]+@` (strips scheme+userinfo prefix from URL; TV-012), (f) HTTP Basic auth `Basic\s+[A-Za-z0-9+/=]+` (base64 padding `+`/`=` prevents pattern (c) from matching; TV-013); (3) `sanitize_internal_ids` — replace UUID-shaped internal identifiers (internal trace IDs, node instance IDs, run IDs not already disclosed to the caller via the HTTP path or request body) with `"<redacted-id>"`; `u64` CheckpointId carve-out: `CheckpointId` is a `u64` newtype (ADR-005) — NOT UUID-shaped; the UUID regex cannot match it; `u64` checkpoint IDs are NOT covered by this pass — authoring-site discipline (node implementations MUST NOT embed checkpoint IDs in externally surfaced error messages) is their sole framework guarantee. No step may be skipped or reordered (ADR-029 §External-Boundary Error-Sanitization Parity, SEC-BOUND-001). Test vector BC-2.12.003 TV-013: a graph node error message contains a credential string (e.g., `"Bearer sk-..."`) in its message; poll `GET /threads/t1/runs/r1`; result: `error.message` does NOT contain the credential string; credential replaced with `<redacted>`; if the error is also an internal-panic, step (1) applies before `redact_credentials` in step (2).
(traces to BC-2.12.003 {INV-008} External-Boundary Error-Sanitization; BC-2.12.003 TV-013; ADR-029 SEC-BOUND-001)

### AC-021: Checkpoint historical-state read — GET /threads/{id}/state?checkpoint_id=<N>

> **D-356 adversary fix DC-13 (2026-09-08, story-writer).** BC-2.12.001 {PC-015} historical-state read: D-356 added this endpoint variant; no Red Gate AC existed before this fix.

**Happy path (TV-010):** `GET /threads/{id}/state?checkpoint_id=<N>` (where `N` is a u64 checkpoint identifier) returns HTTP 200 with the thread's `ChannelValues` snapshot as stored at checkpoint `N`. The response body is the checkpoint's state, NOT the current (latest) thread state. The current thread state is unaffected.

**Error path (TV-011):** If checkpoint `N` does not exist for the given thread, the server responds with HTTP 422 `E-CHKPT-011` `CheckpointNotFound`. The response MUST NOT be a 404 (thread found; the checkpoint is what's absent).

checkpoint_id is a u64 newtype (ADR-005); it is passed as a numeric query parameter, not as a string label.
(traces to BC-2.12.001 postcondition {PC-015} — `?checkpoint_id` variant, TV-010; BC-2.12.001 edge case {EC-010} CheckpointNotFound → HTTP 422 E-CHKPT-011, TV-011)

### AC-022: Fork-start — POST /threads/{id}/runs with checkpoint_id

> **D-356 adversary fix DC-13 (2026-09-08, story-writer).** BC-2.12.003 {INV-009} fork-start: D-356 added this invariant; no Red Gate AC existed before this fix.

**Happy path (TV-014):** `POST /threads/{id}/runs` with `config.configurable.checkpoint_id: <N>` (u64) in the request body initializes the new run's starting state from the `ChannelValues` stored at checkpoint `N` for that thread. The run is enqueued in `queued` state and eventually executes from that checkpoint's state. Existing checkpoints for the thread are NOT deleted — fork is additive (contrast: `multitask_strategy: rollback`, which deletes checkpoints above `latest_completed_checkpoint_id`). The thread's `latest_completed_checkpoint_id` pointer is unchanged by the fork-start request itself.

**Error path (EC-008):** If checkpoint `N` does not exist for the given thread, the server responds with HTTP 422 `E-CHKPT-011` `CheckpointNotFound` before enqueuing any run. No run is created.

checkpoint_id is a u64 newtype (ADR-005); it is passed as a JSON integer field in `config.configurable`, not as a string.
(traces to BC-2.12.003 invariant {INV-009} fork-start initialize from checkpoint ChannelValues, TV-014; BC-2.12.003 edge case {EC-008} fork-start checkpoint absent → HTTP 422 E-CHKPT-011)

## Architecture Mapping

| Component | Module | Crate | Pure/Effectful |
|-----------|--------|-------|---------------|
| `ThreadRoutes` | `pregolya_server::routes::threads` | pregolya-server | Effectful (HTTP + store) |
| `AssistantRoutes` | `pregolya_server::routes::assistants` | pregolya-server | Effectful (HTTP + store) |
| `RunRoutes` | `pregolya_server::routes::runs` | pregolya-server | Effectful (HTTP + store) |
| `RunState` enum | `pregolya_server::models::run` | pregolya-server | Pure (state machine enum) |
| `ThreadStore` trait | `pregolya_server::store::thread` | pregolya-server | Pure (trait) |
| `AssistantStore` trait | `pregolya_server::store::assistant` | pregolya-server | Pure (trait) |
| `RunStore` trait | `pregolya_server::store::run` | pregolya-server | Pure (trait) |

**Subsystem anchor:** SS-12 owns this story's scope because SS-12 is the Server subsystem per ARCH-INDEX Subsystem Registry. Thread/Assistant/Run CRUD endpoints form the REST API surface managed by SS-12. The store trait seams (ThreadStore, AssistantStore, RunStore) are SS-12 abstractions that decouple route handlers from concrete persistence.

**Dependency anchors:**
- Depends on S-1.16: BSP super-step machinery (S-1.16) provides the run execution engine. S-1.26 adds the HTTP route layer on top.
- Depends on S-1.10: `CheckpointSaver` trait used for cascade-delete of thread checkpoint data.
- Depends on S-1.04: `DynTool` / `Runnable` trait is invoked by run execution, surfaced via run routes.

## Purity Classification

| Function / Type | Pure or Effectful | Reason |
|----------------|-------------------|--------|
| `RunState` | Pure | Enum; transition logic is pure |
| `validate_state_transition(from, to)` | Pure | Returns Ok/Err based on valid arc set |
| Thread/Assistant/Run route handlers | Effectful | HTTP I/O + store operations |
| `configurable_merge(run, assistant)` | Pure | Leaf-level map merge |

## Edge Cases

| ID | Source | Description | Expected Behavior |
|----|--------|-------------|-------------------|
| EC-001 | BC-2.12.001 EC-001 | Duplicate thread_id on POST | `E-SERVER-007` |
| EC-002 | BC-2.12.001 EC-006 | DELETE thread with active run | `E-SERVER-008` |
| EC-003 | BC-2.12.001 PC-008 | GET /threads?limit=150 | Clamped to 100 |
| EC-004 | BC-2.12.001 PC-008, PC-009 | GET /threads (default) | Limit 10, created_at DESC |
| EC-005 | BC-2.12.002 PC-024 | PATCH non-existent assistant | `E-SERVER-009` |
| EC-006 | BC-2.12.002 PC-020 | Versions list ordering | `version ASC` (not created_at DESC) |
| EC-007 | BC-2.12.003 EC-002 | POST run on thread with active run | `E-SERVER-012` |
| EC-008 | BC-2.12.003 EC-006 | Transition to invalid state | `E-SERVER-018` RunStateConflict (HTTP 409) |
| EC-009 | BC-2.12.003 PC-019 | summary_halt run DELETE | Allowed directly (no cancel required) |
| EC-010 | BC-2.12.003 PC-007, PC-010 | interrupted → cancelled | Valid arc; run moves to cancelled |
| EC-011 | BC-2.12.001 EC-007 | POST /state on non-existent thread | HTTP 404 E-SERVER-003 ThreadNotFound |
| EC-012 | BC-2.12.001 EC-008 | POST /state with invalid as_node (node not in graph) | HTTP 422 E-SERVER-022 StateUpdateInvalid |
| EC-013 | BC-2.12.001 EC-009 | POST /state with malformed delta (type-incompatible field) | HTTP 422 E-SERVER-022 StateUpdateInvalid (reason-discriminated) |
| EC-014 | BC-2.12.003 EC-007 | multitask=enqueue — max_queued_runs reached | HTTP 429 E-SERVER-019 RunQueueFull |
| EC-015 | BC-2.12.003 PC-004 | multitask=interrupt — pre-empted run sibling-preempted | Transitions to `cancelled` (not `interrupted`); new run enters `queued` |
| EC-016 | BC-2.12.003 PC-004 | multitask=rollback — pre-empted run + checkpoint state | Pre-empted → `cancelled`; checkpoint rows above `latest_completed_checkpoint_id` deleted; pointer reset |
| EC-017 | BC-2.12.002 EC-003 | DELETE assistant delete_threads=true with active constituent run | HTTP 409 E-SERVER-008; no partial deletion (ADR-028 D4) |
| EC-018 | BC-2.12.002 EC-007 | PATCH assistant with empty graph_id | HTTP 400 E-SERVER-020 AssistantFieldInvalid |
| EC-019 | BC-2.12.003 EC-003 — node-body-panic path | Graph node body panics during execution | `in_progress → failed`; `error.code == "E-GRAPH-019"`; `error.message` is the STATIC E-GRAPH-019 message (no raw panic text); panic text logged at ERROR server-side; {INV-007} panic-text-isolation; {INV-005} no orphan runs upheld |
| EC-020 | BC-2.12.003 {INV-007} — E-GRAPH-011 ConditionalEdgePanic path | Conditional edge function panics during graph execution | `in_progress → failed`; `error.code == "E-GRAPH-011"`; `error.message` is the STATIC E-GRAPH-011 message (no source_node, no raw panic text); panic text logged at ERROR server-side; {INV-007} panic-text-isolation (extended); {INV-005} no orphan runs upheld |
| EC-021 | BC-2.12.003 {INV-008} — credential-redaction path (TV-013) | Run error message contains credential material before surfacing | `redact_credentials` applied in step (2) of {INV-008} mandatory pipeline; credential pattern absent from `Run.error.message` in any HTTP response; step (1) internal-panic static-replace precedes step (2) when applicable |
| EC-022 | BC-2.12.001 EC-010 | `GET /threads/{id}/state?checkpoint_id=<N>` where checkpoint N not found | HTTP 422 E-CHKPT-011 CheckpointNotFound (not 404; thread exists, checkpoint absent) — AC-021 TV-011 |
| EC-023 | BC-2.12.003 EC-008 | `POST /threads/{id}/runs` fork-start with `config.configurable.checkpoint_id=<N>` where checkpoint N not found | HTTP 422 E-CHKPT-011 CheckpointNotFound; no run created — AC-022 error path |

## Tasks

- [ ] Create `crates/pregolya-server/src/routes/threads.rs` — Thread CRUD routes
- [ ] Create `crates/pregolya-server/src/routes/assistants.rs` — Assistant CRUD + versions routes
- [ ] Create `crates/pregolya-server/src/routes/runs.rs` — Run CRUD + state machine routes
- [ ] Create `crates/pregolya-server/src/models/run.rs` — `RunState` enum, `Run` struct
- [ ] Create `crates/pregolya-server/src/models/thread.rs` — `Thread` struct
- [ ] Create `crates/pregolya-server/src/models/assistant.rs` — `Assistant`, `AssistantVersion` structs
- [ ] Create `crates/pregolya-server/src/store/thread.rs` — `ThreadStore` trait
- [ ] Create `crates/pregolya-server/src/store/assistant.rs` — `AssistantStore` trait
- [ ] Write failing tests for AC-001..AC-020 before any implementation
- [ ] Implement `validate_state_transition` — 9-arc validation (including `queued → cancelled` and `interrupted → cancelled`)
- [ ] Implement `configurable_merge` — leaf-level map merge, run wins
- [ ] Implement Thread routes: POST, GET, LIST (limit clamp), DELETE (cascade)
- [ ] Implement POST /threads/:id/state — three error paths: thread-not-found (404 E-SERVER-003, AC-011), invalid as_node (422 E-SERVER-022, AC-012), malformed delta type-check (422 E-SERVER-022 reason-discriminated, AC-012)
- [ ] Implement Assistant routes: POST, GET, PATCH (new version; validate graph_id non-empty → 400 E-SERVER-020, AC-017), versions list (ASC)
- [ ] Implement DELETE /assistants?delete_threads=true active-run guard (409 E-SERVER-008, AC-016)
- [ ] Implement Run routes: POST (queued), GET, state transition, DELETE
- [ ] Implement multitask_strategy dispatch: interrupt (pre-empted → cancelled, new → queued, ADR-028 D1, AC-014)
- [ ] Implement multitask_strategy dispatch: rollback (pre-empted → cancelled, delete checkpoint rows above latest_completed_checkpoint_id, reset pointer, ADR-028 D2, AC-015)
- [ ] Implement multitask_strategy dispatch: enqueue (FIFO queue, max_queued_runs=10 configurable, 429 E-SERVER-019 on full, ADR-028 D3, AC-013)
- [ ] Implement `FutureExt::catch_unwind(AssertUnwindSafe(...))` in the run-executor around graph execution dispatch; on panic catch → construct `PregolyaError { code: "E-GRAPH-019", category: INTERNAL, message: "NodePanic: graph node panicked during execution — see server error log for details", retry_hint: Never, .. }`; transition run `in_progress → failed` with E-GRAPH-019 STATIC message (never embed raw panic text in Run.error.message per {INV-007}); log raw panic text at ERROR severity (`tracing::error!`) server-side only; verify {INV-005} no orphan `in_progress` runs and {INV-007} panic-text-isolation via BC-2.12.003 TV-011 (AC-018)
- [ ] Handle E-GRAPH-011 ConditionalEdgePanic errors arriving from the Pregel executor (synchronous `std::panic::catch_unwind` in `graph::bsp_engine` catches the `path_fn` panic; surfaces at the server run-executor as an already-formed `Err(PregolyaError { code: "E-GRAPH-011", message: <captured panic text + source_node topology>, .. })`): apply {INV-007} STATIC message replacement — replace `error.message` with `"ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details"` BEFORE writing to `Run.error.message`; log the original message (panic text + source_node) at ERROR severity server-side only; verify {INV-005} no orphan `in_progress` and {INV-007} static-replace (source_node absent from Run.error.message) via BC-2.12.003 TV-012 (AC-019)
- [ ] Implement `run_executor::sanitize_error_message` applying the mandatory 3-step {INV-008} External-Boundary Error-Sanitization pipeline before populating `Run.error.message` in any HTTP response: (1) internal-panic static-replace (E-GRAPH-019/E-GRAPH-011 STATIC messages); (2) `redact_credentials` (scan + replace 6 credential pattern types with `<redacted>`: OpenAI key `sk-*`, Anthropic key `sk-ant-*`, generic long alphanumeric, Bearer token, URL-embedded userinfo, HTTP Basic auth `Basic\s+...`); (3) `sanitize_internal_ids`; pipeline must be applied in this exact order; verify credential absent from response via BC-2.12.003 TV-013 (AC-020)
- [ ] Run `just iter pregolya-server` — all tests green

## Previous Story Intelligence

**From S-1.16 (BSP Super-Step Determinism):**
- The run execution engine is built in S-1.16. S-1.26 adds the HTTP API layer that triggers and monitors runs. The run state machine in S-1.26 must align with the BSP execution states.

**From S-1.10 (Checkpoint Core):**
- Thread cascade-delete calls `CheckpointSaver::delete` or equivalent to remove checkpoint data when a thread is deleted.

**N/A for prior server story.** S-1.26 is the first server CRUD story.

## Architecture Compliance Rules

1. **Route handlers must not depend on concrete store implementations.** Thread/Assistant/Run route handlers use `Arc<dyn ThreadStore>`, `Arc<dyn AssistantStore>`, `Arc<dyn RunStore>` — never concrete types. This is VP-STORE-01 (no concrete store in route handlers).
2. **`queued → cancelled` and `interrupted → cancelled` arcs are load-bearing.** The 9-arc state machine includes both (BC-2.12.003 §StateTransitions). The transition validator must include both.
3. **Versions list is `version ASC` (not `created_at DESC`).** The assistant versions endpoint is the documented exemption from the canonical created_at DESC ordering.
4. **Leaf-level merge, not whole-map replacement.** `configurable_merge` performs per-key override at leaf level. A run providing `{ "model": "gpt-4" }` must not erase other assistant keys not present in the run config.
5. **`summary_halt` is terminal and directly deletable.** Do not require a cancel step before deleting a `summary_halt` run.
6. **No `unwrap()` / `expect()` in production code.**
7. **`#[non_exhaustive]`** on `RunState` enum (public API surface).
8. **`mod.rs` re-export only** in all route and store modules.
9. **`panic = "unwind"` required in the workspace-root `Cargo.toml` release profile (SEC-008, CWE-248/703).** The authoritative pin lives at the workspace root, applied to the `pregolya-server` binary at link time; a `[profile.release] panic` line inside `pregolya-server/Cargo.toml` itself (or any member manifest) is silently ignored by the Cargo linker and MUST NOT be relied upon as the SEC-008 gate. `FutureExt::catch_unwind(AssertUnwindSafe(...))` in the run-executor catches **node-body panics** (E-GRAPH-019) ONLY when the workspace-root release profile pins `panic = "unwind"`; `panic = "abort"` at the workspace root voids `FutureExt::catch_unwind` and causes process termination on panic (remote DoS, CWE-248/703). DevOps asserts this pin at Phase-3 workspace init; implementer must add an inline comment at the `catch_unwind` call site citing SEC-008 and BC-2.12.003 EC-003. **E-GRAPH-011 ConditionalEdgePanic** is caught by the Pregel executor (synchronous `std::panic::catch_unwind` in `graph::bsp_engine` per BC-2.12.003 {INV-007}) — NOT by the server's `FutureExt::catch_unwind`. E-GRAPH-011 surfaces at the server run-executor as an already-formed `Err(PregolyaError { code: "E-GRAPH-011", .. })`; the server applies {INV-007} STATIC message replacement before writing to `Run.error.message`. Covered by static-replace pipeline: E-GRAPH-019 NodePanic (INTERNAL, Never) and E-GRAPH-011 ConditionalEdgePanic (INTERNAL, Never). **{INV-008} External-Boundary Error-Sanitization (ADR-029 SEC-BOUND-001, CWE-209/532):** Before `Run.error.message` is surfaced via any HTTP response, the mandatory 3-step pipeline MUST be applied in order: (1) internal-panic static-replace (E-GRAPH-019/E-GRAPH-011 STATIC messages applied first); (2) `redact_credentials` (6-pattern set — OpenAI key `sk-*`, Anthropic key `sk-ant-*`, generic long alphanumeric `[A-Za-z0-9]{64,}`, Bearer token `Bearer\s+...`, URL-embedded userinfo `scheme://user:pass@`, HTTP Basic auth `Basic\s+...` — each replaced with `<redacted>`); (3) `sanitize_internal_ids`. Skipping or reordering any step is a CWE-209/532 violation.

## Library & Framework Requirements

| Library | Version | Feature Flags | License | Usage |
|---------|---------|--------------|---------|-------|
| `axum` | (workspace pin) | — | MIT | HTTP routing and handlers |
| `serde` | (workspace pin) | `derive` | MIT/Apache | Request/response serialization |
| `serde_json` | (workspace pin) | — | MIT/Apache | JSON body handling |
| `uuid` | (workspace pin) | `v4, serde` | MIT/Apache | `thread_id`, `run_id`, `assistant_id` |
| `tokio` | (workspace pin) | `full` | MIT | Async handlers |
| `tracing` | (workspace pin) | default | MIT | Structured logging |
| `pregolya-core` | (workspace) | — | — | `PregolyaError`, error codes |

## File Structure Requirements

```
crates/pregolya-server/
  src/
    routes/
      mod.rs                         # re-export only
      threads.rs                     # Thread CRUD route handlers
      assistants.rs                  # Assistant CRUD + versions route handlers
      runs.rs                        # Run CRUD + lifecycle route handlers
    models/
      mod.rs                         # re-export only
      thread.rs                      # Thread struct
      assistant.rs                   # Assistant, AssistantVersion structs
      run.rs                         # Run struct, RunState enum (#[non_exhaustive])
    store/
      mod.rs                         # re-export only
      thread.rs                      # ThreadStore trait (Arc<dyn ThreadStore>)
      assistant.rs                   # AssistantStore trait
      run.rs                         # RunStore trait
  tests/
    thread_routes_tests.rs           # CRUD tests, cascade-delete, limit clamp
    assistant_routes_tests.rs        # versions list ASC, configurable merge
    run_lifecycle_tests.rs           # 9-arc state machine, queued→cancelled, interrupted→cancelled
```

**Files to create (new):** all routes/, models/, store/ files.
**Files to modify (existing):** `pregolya-server/src/lib.rs` (register routes), `Cargo.toml` (add axum if not present).

## Changelog

| Version | Date | Change | Source |
|---------|------|--------|--------|
| 1.14 | 2026-09-08 | DC-13/F-PDC13-02: AC-021 (BC-2.12.001 {PC-015}/{EC-010} checkpoint historical-state read, happy TV-010 + 422 E-CHKPT-011 TV-011) and AC-022 (BC-2.12.003 {INV-009}/{EC-008} fork-start, happy TV-014 + 422 E-CHKPT-011) added. EC-022 and EC-023 added. Token budget ~55,000. No new VPs. | DC-13 F-PDC13-02 |
| 1.13 | 2026-09-02 | round-79/F-P2A251-02: BC table title cells corrected to verbatim canonical H1 per POL-7/F-P2A251-02. | round-79 F-P2A251-02 |
