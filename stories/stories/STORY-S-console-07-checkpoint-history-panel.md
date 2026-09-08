---
document_type: story
level: ops
story_id: S-console-07
epic_id: E-console
version: "1.1"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — checkpoint history browser, per-checkpoint state inspection, fork-from-checkpoint trajectory replay, pagination."
  - "1.1 (D-356/2026-09-07, story-writer): F-PDC04-01 — all checkpoint_id values converted to u64 numeric form; string-form IDs removed. F-PDC04-02 — GET /threads/{id}/state?checkpoint_id=<N> cited as BC-2.12.001 {PC-015} variant (v1.11); not-found response updated to HTTP 422 E-CHKPT-011 per BC-2.12.001 EC-010."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.005.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "ce520c8"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-05]
blocks: []
behavioral_contracts: [BC-2.24.005, BC-2.12.001]
verification_properties: [VP-2.24.005-A, VP-2.24.005-B]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24, SS-04]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-07: Checkpoint History Browser and Fork-from-Checkpoint Trajectory Replay

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-04 (2026-09-07, story-writer).** F-PDC04-01: all `checkpoint_id` values converted to u64 numeric form (e.g., `?checkpoint_id=5`, payload `checkpoint_id: 5`); string-form IDs removed throughout. F-PDC04-02: `GET /threads/{id}/state?checkpoint_id=<N>` now cited as BC-2.12.001 {PC-015} `?checkpoint_id` variant (v1.11); not-found response updated to HTTP 422 E-CHKPT-011 CheckpointNotFound per BC-2.12.001 EC-010 (was: 404).

## Narrative

- **As a** developer debugging a failed or incorrect agent run
- **I want to** browse the checkpoint history for a thread and fork a new run from any past checkpoint
- **So that** I can replay an execution trajectory from a specific state without restarting from scratch — the same time-travel capability that LangGraph Studio provides

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.005 | Checkpoint History Browser and Fork-from-Checkpoint Trajectory Replay (CAP-044) | AC-001..AC-007 |
| BC-2.12.001 | Thread State Read — `?checkpoint_id` Variant (v1.11, PC-015) | AC-002, AC-007 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.005 postcondition PC-001)
The console renders a time-ordered list of checkpoints for the selected thread, newest-first (matching the server's `GET /threads/{id}/history` ordering). Each entry shows: `step_idx` (monotone logical clock position), the node that executed at that step, and a summary of the state delta applied. Verified by `test_BC_2_24_005_history_timeline_rendered()` (VP-2.24.005-A).

### AC-002 (traces to BC-2.24.005 postcondition PC-002; traces to BC-2.12.001 postcondition PC-015)
Selecting a history entry issues `GET /threads/{id}/state?checkpoint_id=<N>` (BC-2.12.001 {PC-015} `?checkpoint_id` variant, v1.11) and renders the full state snapshot (`values`, `checkpoint`, `next`) as structured JSON with collapsible fields. The JSON is fully rendered — no truncation of the structure (truncation of individual long string values for display is acceptable). Verified by `test_BC_2_24_005_checkpoint_state_inspection()`.

### AC-003 (traces to BC-2.24.005 postcondition PC-003)
From any history entry, initiating a fork sends `POST /threads/{id}/runs` with payload `config.configurable.checkpoint_id: <N>` (u64 integer) as the starting state. A new `run_id` is returned and the console transitions to the run inspection panel (S-console-06) for the new run. Verified by `test_BC_2_24_005_fork_from_checkpoint()` (VP-2.24.005-B).

### AC-004 (traces to BC-2.24.005 postcondition PC-004)
The history loads in pages using `?limit=N`. When more checkpoints are available (server returns a next-page token or indicates truncation), a "load more" control is shown. Clicking "load more" fetches the next page and appends the results to the list. The `step_idx` ordering is preserved across pages. Verified by `test_BC_2_24_005_pagination_load_more()`.

### AC-005 (traces to BC-2.24.005 invariant INV-001)
The console renders checkpoints in the `step_idx` order returned by the server — monotonically non-decreasing. The UI does NOT re-sort by any other field. Any re-ordering by the console is a correctness violation. Verified by `test_BC_2_24_005_step_idx_monotone_order()`.

### AC-006 (traces to BC-2.24.005 edge case EC-001)
When a thread has no checkpoints (new thread, no completed run), the history panel shows an empty state: "no checkpoints yet". No error state; no crash. Verified by `test_BC_2_24_005_empty_history_state()`.

### AC-007 (traces to BC-2.24.005 edge case EC-002; traces to BC-2.12.001 edge case EC-010)
When `GET /threads/{id}/state?checkpoint_id=<N>` (BC-2.12.001 {PC-015} v1.11) returns HTTP 422 E-CHKPT-011 CheckpointNotFound (BC-2.12.001 EC-010; checkpoint evicted or compacted), the history panel shows "checkpoint no longer available" for that entry instead of the state detail. Other entries are unaffected. Verified by `test_BC_2_24_005_checkpoint_evicted_422()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| Checkpoint history panel component | `spa/src/components/CheckpointHistory.*` | N/A (SPA component) |
| Checkpoint state inspector | `spa/src/components/CheckpointStateView.*` | N/A (SPA component) |
| Fork-from-checkpoint action | `spa/src/lib/api.ts` | N/A (SPA, REST client) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| Checkpoint history panel | N/A (SPA) | TypeScript/JS frontend |
| REST calls to checkpoint endpoints | Pure consumer | Read-only browsing; fork uses existing POST endpoint |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | No checkpoints | Empty state "no checkpoints yet" |
| EC-002 | Checkpoint 422 E-CHKPT-011 (evicted / not found) | "checkpoint no longer available" for that entry |
| EC-003 | Fork fails (server error) | Error message; fork not started; operator can retry |
| EC-004 | Very large history | "load more" pagination; `step_idx` order preserved |
| EC-005 | Deeply nested JSON state | Collapsible JSON tree; no structural truncation |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.005.md (~143 lines) | ~2,500 |
| ADR-031 traceability row (CAP-044) | ~200 |
| SPA component source (~200 lines TypeScript) | ~2,500 |
| Test files (~120 lines) | ~1,500 |
| Tool outputs | ~400 |
| **Total** | **~10,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs (test-writer; E2E/component tests)
2. [ ] Create `spa/src/components/CheckpointHistory.*` — paginated list; `step_idx` monotone render; "load more" control
3. [ ] Create `spa/src/components/CheckpointStateView.*` — collapsible JSON tree for state snapshot
4. [ ] Implement `GET /threads/{id}/history` fetch with `?limit=N` pagination in `spa/src/lib/api.ts`
5. [ ] Implement `GET /threads/{id}/state?checkpoint_id=<N>` fetch (BC-2.12.001 {PC-015} v1.11); render HTTP 422 E-CHKPT-011 as "checkpoint no longer available"
6. [ ] Implement fork action: POST to `/threads/{id}/runs` with checkpoint; navigate to run inspection panel on success
7. [ ] Handle fork error response: display error message; keep panel open for retry
8. [ ] Add empty state rendering for zero checkpoints
9. [ ] Run SPA tests — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-05 (SPA build pipeline). The SPA framework, build tooling, and `api.ts` REST client patterns are established. The checkpoint history browser is a read-only panel using the existing `GET /threads/{id}/history` and `GET /threads/{id}/state` endpoints — no new backend work needed. The fork action reuses the existing `POST /threads/{id}/runs` endpoint; navigate to the run inspection panel (S-console-06) on success.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| Checkpoints rendered in `step_idx` monotone order | BC-2.24.005 INV-001 (DI-004) | Test: server returns checkpoints in order; assert UI preserves that order |
| No new server endpoints introduced | BC-2.24.005 postcondition PC-005 | Code review: only calls existing endpoints |
| Partial failure (one 422 E-CHKPT-011 checkpoint) surfaces per-entry | BC-2.24.005 INV-004 (DI-014); BC-2.12.001 EC-010 | Test: mock 422 E-CHKPT-011 for one checkpoint; other entries unaffected |
| Browse is read-only | BC-2.24.005 INV-003 | Code review: no mutations to checkpoint state from history panel |

**Forbidden patterns:** Re-sorting checkpoints by timestamp or node name (must preserve server `step_idx` order). Fetching checkpoint state eagerly for all history entries (must fetch only when user selects an entry).

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| Framework (from S-console-05) | Per S-console-05 selection | SPA components |
| JSON tree viewer component | Latest stable at Wave 3 | Collapsible JSON rendering for checkpoint state |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/spa/src/components/CheckpointHistory.*` | CREATE | Checkpoint list with pagination and fork action |
| `crates/pregolya-console/spa/src/components/CheckpointStateView.*` | CREATE | Collapsible JSON tree for checkpoint state |
| `crates/pregolya-console/spa/src/lib/api.ts` | MODIFY | Add checkpoint history + state + fork API calls |
| `crates/pregolya-console/spa/src/pages/ThreadPage.*` | CREATE | Route handler showing thread detail with checkpoint history |
