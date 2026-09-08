---
document_type: behavioral-contract
level: L3
bc_id: BC-2.12.001
version: "1.12"
status: active
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-12
capability: CAP-014
wave: 1
phase: 1a
red_gate: false
producer: product-owner
timestamp: 2026-08-24T00:00:00Z
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-014
inputs:
  - .factory/specs/prd.md
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/semport/platform/behavioral-intent.md
input-hash: "25528ef"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
changelog:
  - "1.12 (D-356-fix/DC-04/2026-09-07, product-owner): §Story Anchor: S-console-07 appended as roadmap consumer of the PC-015 ?checkpoint_id variant (Wave 3); S-1.26 remains primary implementation anchor. Reverse-anchor completeness fix."
  - "1.11 (D-356-fix/DC-04/2026-09-07, product-owner): F-PDC04-02: PC-015 amended — GET /threads/{thread_id}/state gains optional ?checkpoint_id=<CheckpointId> (u64) selector returning historical checkpoint state at the specified ID; checkpoint not found raises E-CHKPT-011 CheckpointNotFound HTTP 404 (EC-010). TV-010 and TV-011 added covering the happy-path read and not-found path respectively."
  - "1.1 (ADV-P1D-PASS-31): F-P31-01 PC17 history endpoint — declare limit default 10, max 100, values > 100 clamped to 100, offset default 0 (pagination coherence canon; clamp out-of-range semantics)."
  - "1.2 (ADV-P1D-PASS-34): F-P34-01 PC8 — add clamp semantics (values > 100 silently clamped to 100) and offset default 0 (partial-fix propagation gap from pass-31). PC9 — declare created_at DESC ordering (canonical; F-P31-01). interface-definitions.md §Canonical Pagination Convention cites BC-2.12.001 PC8 as threads-list clamp+ordering anchor; PC8 now matches."
  - "1.3 (2026-07-15, F-P78-SWEEP/D18-P78-A): E-SERVER-007 message-prefix correction at two BC sites. (1) PC3 (Create Thread): added 'ThreadAlreadyExists:' prefix and lowercased 'Thread' to 'thread' in message string (was 'Thread'; now 'thread'). (2) EC-001: same corrections applied. Taxonomy already carried the prefix and lowercase; BC was the lagging artifact. Both sites now produce the canonical form 'ThreadAlreadyExists: thread <id> already exists'."
  - "1.4 (F-P96-01, 2026-07-17): Module field resolved from placeholder to pregolya-server per module-decomposition.md v1.10."
  - "1.5 (story-anchor-backfill/2026-08-22): §Story Anchor backfilled to S-1.26 from STORY-INDEX forward map (CANONICAL PRINCIPLE Rule 6; no behavioral change)."
  - "1.6 (M1/ADR-027/2026-08-23): stable clause anchors {PC/INV/PRE-NNN} added; purely additive, no content change."
  - "1.7 (M3b-escalation-EC006/2026-08-24): EC-006 added — DELETE /threads/{id} while an active (queued or in_progress) run exists returns HTTP 409 E-SERVER-008; PC-011 is unconditional and did not cover this restriction; gap surfaced during S-1.26 EC adjudication P2A-043 F-05."
  - "1.8 (P2A-052 F-052-01/2026-08-25): ## VP Anchors section corrected from duplicated Story-Anchor story-ID to 'None' (BC has no Kani VP seed; see §Verification Properties)."
  - "1.9 (P2A-BC-scan-B/2026-08-26): POST /state failure paths added — EC-007 (thread-not-found → E-SERVER-003), EC-008 (invalid as_node → NEEDS-NEW-CODE flagged in manifest), EC-009 (malformed delta → NEEDS-NEW-CODE flagged in manifest). PC-016 amended to reference failure paths. TV-008 and TV-009 added."
  - "1.10 (burst-A2-error-coord/P2A-BC-scan-hardening-addendum/2026-08-26): EC-008, EC-009, PC-016(b)/(c), and TV-009 repointed from NEEDS-NEW-CODE → E-SERVER-022 StateUpdateInvalid (see error-taxonomy.md §Component: SERVER (pregolya-server)); single reason-discriminated code for both invalid-as_node and malformed-delta POST /state failures. NEEDS-NEW-CODE annotations removed."
---

# BC-2.12.001: Thread Resource CRUD (Create, Read, List, Delete Durable Conversation History)

> **D-356 adversary fix DC-04 (2026-09-07, product-owner).** F-PDC04-02: PC-015 amended — `GET /threads/{thread_id}/state` gains optional `?checkpoint_id=<CheckpointId>` (u64 newtype per BC-2.04.003 §Architecture Anchors) selector returning historical checkpoint state at the specified ID (same response shape as the no-selector form). Checkpoint not found → E-CHKPT-011 CheckpointNotFound HTTP 422 (EC-010; HTTP 422 per taxonomy definition — POLICY, CheckpointId semantically unprocessable). E-CHKPT-011 is semantically correct for both the fork-start path (BC-2.12.003 {INV-009}) and this state-read path — the semantic is identical: a requested CheckpointId does not exist. TV-010 (happy-path historical read) and TV-011 (not-found) added. This variant is the substrate cited by BC-2.24.005 PC-002.

> **D-356 adversary fix DC-04 (2026-09-07, product-owner).** BC-2.12.001 §Story Anchor: S-console-07 appended as roadmap consumer of the PC-015 `?checkpoint_id` variant. S-1.26 remains the primary implementation anchor.

## Description

A Thread is pregolya-server's durable conversation history container: it is the
persistent identity that binds a sequence of Runs to a shared checkpoint lineage.
This BC specifies the CRUD operations on Thread resources (no wire-compatibility with
LangGraph Platform per D13 — the pregolya-server API is first-party). Threads are
the lowest-level persistence unit; their checkpoint state is managed by the
pregolya-checkpoint subsystem. Thread-not-found returns `E-SERVER-003`.

## Preconditions

1. {PRE-001} `pregolya-server` is running with a configured `RunStore` and `CheckpointSaver` backend.
2. {PRE-002} The caller holds a valid authentication credential (or the server is in unauthenticated
   dev mode).

## Postconditions

### Create Thread (`POST /threads`)

1. {PC-001} Accepts body `{ thread_id?: Uuid, metadata?: Map<String, Value> }`.
2. {PC-002} `thread_id` is caller-supplied or server-generated (UUID v4 if absent).
3. {PC-003} If `thread_id` already exists and `if_exists = "raise"` (default): returns HTTP 409
   with `{ code: "E-SERVER-007", message: "ThreadAlreadyExists: thread '<id>' already exists" }`.
4. {PC-004} If `thread_id` already exists and `if_exists = "do_nothing"`: returns the existing
   Thread record (HTTP 200), no modification.
5. {PC-005} Returns HTTP 201 with the created `Thread { thread_id, metadata, created_at, updated_at, status }`.

### Read Thread (`GET /threads/{thread_id}`)

6. {PC-006} Returns HTTP 200 with the Thread record if found.
7. {PC-007} Returns HTTP 404 with `{ code: "E-SERVER-003", message: "ThreadNotFound: thread '<id>' does not exist" }` if not found.

### List/Search Threads (`GET /threads`)

8. {PC-008} Accepts query params `metadata` (filter), `limit` (default 10, max 100; values > 100 silently clamped to 100), `offset` (default 0).
9. {PC-009} Returns `{ threads: [Thread], total_count: u64 }`; results ordered `created_at` descending (canonical; F-P31-01, ADV-P1D-PASS-34).
10. {PC-010} Metadata filter uses exact-match on top-level keys; partial matches are not supported.

### Delete Thread (`DELETE /threads/{thread_id}`)

11. {PC-011} Deletes the Thread record and all associated checkpoint state for that thread.
12. {PC-012} Returns HTTP 204 on success.
13. {PC-013} Returns HTTP 404 with `E-SERVER-003` if the thread does not exist.
14. {PC-014} A delete is idempotent at the HTTP layer: a second DELETE on the same ID returns 404, not 500.

### Thread State Operations

15. {PC-015} `GET /threads/{thread_id}/state` — returns the latest checkpoint state for the thread:
    `{ values: GraphState, checkpoint: CheckpointId, next: [NodeId] }`.
    Accepts optional query parameter `?checkpoint_id=<CheckpointId>` (u64 newtype; BC-2.04.003 §Architecture Anchors); when supplied, returns the state at the specified historical checkpoint (same response shape). If the checkpoint does not exist → HTTP 422 `E-CHKPT-011 CheckpointNotFound` (EC-010; error-taxonomy.md §CHKPT component, HTTP 422 per taxonomy definition). E-CHKPT-011 covers both the fork-start path (BC-2.12.003 {INV-009} / EC-008) and this state-read path — the semantic is identical: a requested CheckpointId does not exist. RetryHint: Never (POLICY default).
16. {PC-016} `POST /threads/{thread_id}/state` — updates checkpoint state by applying a delta:
    `{ values: Map<String, Value>, as_node?: NodeId }`. Returns `{ checkpoint: CheckpointId }` on success.
    Failure paths: (a) if the thread does not exist → HTTP 404 `E-SERVER-003 ThreadNotFound` (EC-007);
    (b) if `as_node` is provided and does not refer to a valid node in the associated graph definition → HTTP 422 `E-SERVER-022 StateUpdateInvalid` (EC-008);
    (c) if the `values` delta contains fields with types incompatible with the graph's state schema → HTTP 422 `E-SERVER-022 StateUpdateInvalid` (EC-009).
    Active-run guard: if a Run is currently `in_progress` or `queued` on the thread, HTTP 409 `E-SERVER-008` (EC-005).
17. {PC-017} `GET /threads/{thread_id}/history?limit=N` — returns the checkpoint history list
    for the thread, ordered newest-first; `limit` default 10, max 100; values > 100
    clamped to 100; `offset` default 0 (F-P31-01, ADV-P1D-PASS-31).

## Invariants

- {INV-001} Thread IDs are globally unique within the server instance.
- {INV-002} Deleting a thread MUST cascade-delete all checkpoint data for that thread (no orphan
  checkpoint rows).
- {INV-003} Thread state operations (`/state`) are mediated by the checkpoint subsystem; they do
  not bypass `put_writes` / `get_tuple` (DI-002).
- {INV-004} All thread CRUD operations are atomic: a create either fully succeeds or fully fails;
  no partially created thread is observable.

## Edge Cases

### EC-001: Caller-supplied thread_id conflicts with existing (if_exists=raise)
**Scenario:** `POST /threads` with `{ thread_id: "abc", if_exists: "raise" }`;
thread "abc" already exists.
**Expected behavior:** HTTP 409 `{ code: "E-SERVER-007", message: "ThreadAlreadyExists: thread 'abc' already exists" }`.
No data modified.

### EC-002: Metadata filter with no matches
**Scenario:** `GET /threads?metadata={"env":"prod"}` where no threads have that metadata key.
**Expected behavior:** HTTP 200 `{ threads: [], total_count: 0 }`. Not an error.

### EC-003: Delete non-existent thread
**Scenario:** `DELETE /threads/does-not-exist`.
**Expected behavior:** HTTP 404 `{ code: "E-SERVER-003", ... }`. Not 204. Second call to
the same ID also returns 404 — idempotent in error semantics.

### EC-004: GET /state for thread with no runs
**Scenario:** Thread created but no Run has been executed against it.
**Expected behavior:** HTTP 200 with `{ values: {}, checkpoint: null, next: [] }`.
The thread exists but has no checkpoint state. This is valid.

### EC-005: POST /state concurrent with running Run
**Scenario:** A Run is active on the thread (state: `in_progress`); caller simultaneously
calls `POST /threads/{thread_id}/state`.
**Expected behavior:** HTTP 409 `{ code: "E-SERVER-008", message: "ThreadStateConflict: thread '<id>' has an active run '<run_id>'; state updates during active runs are disallowed" }`.

### EC-006: DELETE thread with active (queued or in_progress) Run
**Scenario:** `DELETE /threads/{thread_id}` where the thread has a Run currently in `queued` or `in_progress` state.
**Expected behavior:** HTTP 409 `{ code: "E-SERVER-008", message: "ThreadStateConflict: thread '<id>' has an active run '<run_id>'; thread deletion while an active run is in progress is disallowed" }`.
The thread and its runs are NOT deleted. Caller must first cancel the active run
(`POST /threads/{thread_id}/runs/{run_id}/cancel`), await a terminal state, then retry the thread deletion.
**Rationale:** PC-011 is unconditional; this EC makes the active-run guard explicit. Re-uses the E-SERVER-008
ThreadStateConflict code established by EC-005 (state writes during active run), extending the guard to deletion.

### EC-007: POST /state on non-existent thread {EC-007}
**Scenario:** `POST /threads/ghost/state { values: { "x": 1 } }` where thread "ghost" does not exist.
**Expected behavior:** HTTP 404 `{ code: "E-SERVER-003", message: "ThreadNotFound: thread 'ghost' does not exist" }`. No state mutation occurs.

### EC-008: POST /state with invalid as_node {EC-008}
**Scenario:** `POST /threads/t1/state { values: { "x": 1 }, as_node: "nonexistent_node" }` where `"nonexistent_node"` is not a valid node ID in the thread's associated graph definition.
**Expected behavior:** HTTP 422 `{ code: "E-SERVER-022", message: "StateUpdateInvalid: state update for thread '<thread_id>' rejected: as_node 'nonexistent_node' is not registered in the graph" }`. (`<thread_id>` = the thread ID; `<reason>` = the specific rejection cause, here the unrecognised `as_node` node name.) E-SERVER-022 StateUpdateInvalid (VAL, broken, HTTP 422, Never; see error-taxonomy.md §Component: SERVER (pregolya-server)).

### EC-010: GET /state with non-existent checkpoint_id {EC-010}
**Scenario:** `GET /threads/t1/state?checkpoint_id=999` where checkpoint 999 does not exist on thread t1.
**Expected behavior:** HTTP 422 `{ code: "E-CHKPT-011", message: "CheckpointNotFound: checkpoint '999' does not exist on thread 't1'" }`. E-CHKPT-011 is defined as HTTP 422 in the taxonomy (POLICY — the CheckpointId is semantically unprocessable because it references a non-existent checkpoint). E-CHKPT-011 covers both the fork-start path (BC-2.12.003 {INV-009} / EC-008) and this state-read path — a requested CheckpointId does not exist in the `CheckpointSaver`.

### EC-009: POST /state with malformed delta {EC-009}
**Scenario:** `POST /threads/t1/state { values: { "messages": 42 } }` where the thread's graph state schema expects `messages` to be an array; the integer value is type-incompatible.
**Expected behavior:** HTTP 422 `{ code: "E-SERVER-022", message: "StateUpdateInvalid: state update for thread '<thread_id>' rejected: field 'messages' type incompatible: expected array, got integer" }`. (`<reason>` = the schema validation failure detail.) E-SERVER-022 StateUpdateInvalid is the single reason-discriminated code for both EC-008 and EC-009 — the `<reason>` field distinguishes invalid-as_node from malformed-delta failures (VAL, broken, HTTP 422, Never; see error-taxonomy.md §Component: SERVER (pregolya-server)).

## Canonical Test Vectors

| # | Input | Expected Output | Notes |
|---|-------|-----------------|-------|
| TV-001 | `POST /threads` with no body | HTTP 201, server-generated UUID `thread_id`, `metadata: {}` | Happy-path create |
| TV-002 | `POST /threads { thread_id: "t1" }` × 2 with default `if_exists` | First: 201; Second: 409 E-SERVER-007 | Conflict detection |
| TV-003 | `GET /threads/t1` after creation | HTTP 200, Thread record | Happy-path read |
| TV-004 | `GET /threads/nonexistent` | HTTP 404 E-SERVER-003 | Thread not found |
| TV-005 | `DELETE /threads/t1`, then `DELETE /threads/t1` | First: 204; Second: 404 E-SERVER-003 | Idempotent delete |
| TV-006 | `GET /threads?metadata={"env":"prod"}&limit=5` | Filtered list, max 5 results | List with filter |
| TV-007 | `GET /threads/t1/state` (no runs) | HTTP 200 `{ values: {}, checkpoint: null, next: [] }` | Empty state |
| TV-008 | `POST /threads/ghost/state { values: { "x": 1 } }` (thread does not exist) | HTTP 404 E-SERVER-003 | POST /state thread-not-found |
| TV-009 | `POST /threads/t1/state { values: { "x": 1 }, as_node: "fake_node" }` (node not in graph) | HTTP 422 `{ code: "E-SERVER-022", message: "StateUpdateInvalid: state update for thread 't1' rejected: as_node 'fake_node' is not registered in the graph" }` | POST /state invalid as_node (EC-008) |
| TV-010 | `GET /threads/t1/state?checkpoint_id=5` where checkpoint 5 exists on thread t1 | HTTP 200 `{ values: <state at checkpoint 5>, checkpoint: 5, next: [...] }` | PC-015 ?checkpoint_id variant — historical state read |
| TV-011 | `GET /threads/t1/state?checkpoint_id=999` where checkpoint 999 does not exist on thread t1 | HTTP 422 `{ code: "E-CHKPT-011", message: "CheckpointNotFound: checkpoint '999' does not exist on thread 't1'" }` | EC-010: checkpoint-not-found |

## Verification Properties

_No Kani VP seed required. Integration tests against in-process pregolya-server are sufficient._

## Related BCs

- BC-2.12.002 — sibling: Assistants reference graph configs; threads reference no assistant directly (they are untyped containers)
- BC-2.12.003 — depends on: Runs are executed against Threads; Run lifecycle ties to thread state

## Architecture Anchors

- `pregolya-server/src/api/threads.rs` — Thread CRUD handlers
- `pregolya-server/src/store/run_store.rs` — Thread persistence (durable backend seam)
- `pregolya-checkpoint/src/store.rs` — Checkpoint cascade-delete on thread delete

## Story Anchor

S-1.26 (primary — Thread CRUD implementation)

S-console-07 (roadmap, Wave 3 — consumes the `?checkpoint_id` PC-015 historical-state read variant)

## VP Anchors

None

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-014 |
| Capability Anchor Justification | CAP-014 ("Durable-Run HTTP Server (Threads, Assistants, Runs, Crons)") per capabilities-p1-p2.md §CAP-014 — this BC implements the Thread resource CRUD, which is explicitly listed as the first of the four managed resources in CAP-014: "Thread (durable conversation history)" |
| L2 Domain Invariants | — |
| DEC Reference | — |
| Risk Source | — |
| Priority | P1 |
| Wave | Wave 1 |
| Test Types | I (integration), E2E (end-to-end) |
| Module | pregolya-server |
