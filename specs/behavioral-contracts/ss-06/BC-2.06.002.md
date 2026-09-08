---
document_type: behavioral-contract
level: L3
bc_id: BC-2.06.002
version: "1.8"
status: active
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P0
subsystem: SS-06
capability: CAP-007
wave: 1
phase: 1a
producer: product-owner
timestamp: 2026-08-23T00:00:00Z
changelog:
  - "1.1 (F-P93-04 class-sweep, 2026-07-17): VP ID collision resolved. BC-2.06.001 and BC-2.06.002 both defined VP-STREAM-02 with semantically identical (run_id + parent_ids) descriptions. Resolution per append-only-numbering policy: BC-2.06.001's VP-STREAM-02 (lower ID, canonical) kept; BC-2.06.002's VP-STREAM-02 renumbered → VP-STREAM-04 (next free after VP-STREAM-03 in BC-2.06.003). VP Anchors updated accordingly. Detected by OBS-P93-01 VP uniqueness census."
  - "1.2 (F-P96-01, 2026-07-17): Module field resolved from placeholder to pregolya-graph / pregolya-server per module-decomposition.md v1.10."
  - "1.3 (F-P140-01, 2026-07-23): Fix burst 240 Wave 2 — sweep stale pregel/*.rs Architecture Anchor file-path references to canonical flat graph:: layout per ADR-001 / module-decomposition v1.21."
  - "1.4 (story-anchor-backfill/2026-08-22): §Story Anchor backfilled to S-1.17 from STORY-INDEX forward map (CANONICAL PRINCIPLE Rule 6; no behavioral change)."
  - "1.5 (M1/ADR-027/2026-08-23): stable clause anchors {PC/INV/PRE-NNN} added; purely additive, no content change."
  - "1.6 (P2-BC-SS04-06-hardening/2026-08-26): EC-001 concrete rule added — resume-run parent_ids is no longer 'impl-choice, must document in ADR'. Decision: the resumed run's `parent_ids` is copied from the interrupted run's `parent_ids` at interrupt time; the interrupted run's `run_id` is NOT added to the resume run's `parent_ids`. Rationale: a resume run is a continuation of the interrupted run at the same nesting level, not a child of it; {INV-001} (new run_id) + {INV-002} (parent_ids assigned once at creation) anchor the decision; correlation between interrupted and resumed runs is provided by `parent_checkpoint_id` in checkpoint metadata (BC-2.04.004), not by run_id inheritance. Stale 'server implementation choice, must be documented in ADR' language removed. BC-completeness-scan Phase-2 BURST-B gap BC-2.06.002."
  - "1.7 (D-356-fix/DC-23/2026-09-08, product-owner): F-PDC23-01: Architect ruling (BC-2.12.003 SS-12 lifecycle is authoritative) — resume is SAME run_id. {INV-001} second/third sentences corrected: 'A resumed run transitions the existing Run record from interrupted → in_progress; no new Run record is created and no new run_id is issued. The interrupted run's run_id is preserved and continues to identify the run through completion.' EC-001 heading + expected behavior corrected to match: same run, same run_id, existing Run record transitions interrupted → in_progress. Prior wording (new run_id issued on resume) is architecturally incorrect per BC-2.12.003."
  - "1.8 (D-356-fix/DC-24/2026-09-08, product-owner): F-PDC24-02: §Related BCs BC-2.04.004 entry — removed 'where run_id changes' (contradicts DC-23-corrected {INV-001}; run_id is preserved on resume); replaced with 'run_id unchanged; checkpoint lineage links checkpoints across the interrupt boundary within one run'. F-PDC24-03: EC-001 Rationale reframed — removed presupposition of a distinct resume-run record; rewritten around same-Run-record model: parent_ids is unchanged because resume is a state transition on the SAME Run (not a new run creation); parent_checkpoint_id links interrupted and resumed phases of the SAME Run through checkpoint lineage (not 'two Run records')."
traces_to:
  - domain-spec/capabilities-p0.md#CAP-007
inputs:
  - .factory/specs/prd.md
  - .factory/specs/domain-spec/capabilities-p0.md
  - .factory/specs/domain-spec/events.md
  - .factory/semport/core/behavioral-intent.md
  - .factory/comparative/assessment-parts/part-3-conflicts-negative-evidence.md
input-hash: "168c3aa"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.06.002: run_id + parent_ids Correlation Across All Streaming Events

> **D-356 adversary fix DC-24 (2026-09-08, product-owner).** F-PDC24-02: §Related BCs BC-2.04.004 entry corrected — "where `run_id` changes" removed (contradicts DC-23 {INV-001}: run_id is PRESERVED on resume). F-PDC24-03: EC-001 Rationale reframed — "two `Run` records" removed; rewritten around same-Run-record model per DC-23 {INV-001}. parent_ids remains unchanged because resume is a state transition on the SAME Run record, not a new-run creation.

> **D-356 adversary fix DC-23 (2026-09-08, product-owner).** F-PDC23-01: {INV-001} and EC-001 corrected — per architect ruling (BC-2.12.003 §lifecycle is authoritative), a resumed run is the SAME run: the existing Run record transitions `interrupted` → `in_progress`; no new Run record is created and no new run_id is issued. Prior wording ("A resumed run that creates a new `Run` record issues a new `run_id`") was architecturally incorrect.

## Description

Every `StreamEvent` carries two mandatory correlation fields: `run_id` (a stable UUID
assigned at `RunStart` and held constant for the run's lifetime) and `parent_ids` (an ordered
list of ancestor `run_id`s from the outermost run to the immediate parent). Together these
fields form a directed correlation tree that allows observers to attribute events to their
originating run, reconstruct nested call graphs, and route per-step costs to the initiating
run. The contract follows the astream_events v2 7-key shape (semport/core/behavioral-intent.md
§D-2) adapted to pregolya's native types; D13 exempts pregolya from exact wire compatibility.

## Preconditions

1. {PRE-001} A `Run` is executing; a `run_id` UUID has been assigned at `RunStart`.
2. {PRE-002} For nested executions (subgraphs, tool-spawned sub-runs), a new `run_id` is assigned to
   the nested unit at its creation; the parent run's `run_id` is captured in the execution
   context before the nested unit starts.
3. {PRE-003} The execution context propagates `run_id` and `parent_ids` through all nested call boundaries.

## Postconditions

1. {PC-001} Every `StreamEvent` variant carries the same `run_id` UUID assigned at `RunStart` for
   the run that emitted it. The field is present and non-null on every event variant.
2. {PC-002} For a top-level run, `parent_ids` is an empty list `[]`.
3. {PC-003} For a nested sub-run (subgraph invocation or tool-spawned run), `parent_ids` is the
   ordered list of ancestor `run_id`s from outermost to immediate parent:
   - Top-level run A: `run_id = A`, `parent_ids = []`
   - Subgraph run B nested inside A: `run_id = B`, `parent_ids = [A]`
   - Tool sub-run C invoked inside B: `run_id = C`, `parent_ids = [A, B]`
4. {PC-004} `parent_ids` is the same on every event emitted within a single sub-run (it does not
   change mid-run unless a deeper nesting is entered, which would create yet another sub-run).
5. {PC-005} `run_id` values are non-repeating UUIDs (v4 or v7). Two distinct runs, even on the same
   `thread_id`, carry distinct `run_id`s.

## Invariants

- {INV-001} `run_id` is immutable for the lifetime of a run — it is never regenerated at super-step
  boundaries, interrupts, or resumes. A resumed run transitions the existing Run record from
  `interrupted` → `in_progress`; no new Run record is created and no new run_id is issued.
  The interrupted run's run_id is preserved and continues to identify the run through completion.
- {INV-002} `parent_ids` is assigned once at run creation and is read-only thereafter. It is not
  mutated by sub-events within the run.
- {INV-003} The transitivity rule must hold: if run A is an ancestor of run B, then `run_id(A)` appears
  in the `parent_ids` of every event emitted by run B (directly or transitively).
- {INV-004} No two concurrent runs share a `run_id`, regardless of thread, namespace, or fork.
- {INV-005} Fan-out PUSH tasks (Send API) within a super-step share the parent run's `run_id` and
  `parent_ids` — they are tasks within a run, not independent sub-runs.

## Edge Cases

### EC-001: Interrupted run resumed {EC-001}
**Scenario:** A run is interrupted (via `interrupt()`), checkpointed, then resumed.
**Expected behavior:** The resumed run is the SAME run — the existing Run record transitions
`interrupted` → `in_progress` per {INV-001}. The run_id does not change. All streaming events
for the resumed execution reference the same run_id.

**Rationale (parent_ids unchanged on resume):** Since resume is a state transition on the
SAME Run record — not a new-run creation (per {INV-001}) — `run_id` and `parent_ids` are
unchanged by definition. Per {INV-002}, `parent_ids` is assigned once at run creation and
is read-only thereafter; it represents the static nesting context of the run. There is no
"resume run" to assign a `parent_ids` to.

Streaming consumers that need to correlate execution events before and after the interrupt
MUST use `parent_checkpoint_id` in the checkpoint metadata (BC-2.04.004), which links the
interrupted and resumed phases of the SAME Run through the checkpoint lineage — not through
`run_id`/`parent_ids` (which are identical throughout).

### EC-002: Fan-out via Send API
**Scenario:** A Send API fan-out in a super-step creates N parallel PUSH tasks. Each PUSH
task may emit `NodeStart`/`NodeEnd` events.
**Expected behavior:** All PUSH task events carry the same `run_id` as the enclosing run;
`parent_ids` is unchanged. Fan-out tasks are not independent sub-runs and do not create
new `run_id`s.

### EC-003: run_id serialization round-trip
**Scenario:** A `StreamEvent` is serialized to msgpack (checkpoint wire format) and
deserialized by a remote consumer.
**Expected behavior:** `run_id` and `parent_ids` are byte-identical across the
serialization/deserialization round-trip. UUIDs are stored as 16-byte binary or UUID string
consistently (pregolya-native format; consistency is the requirement, not the specific
encoding).

### EC-004: Very deep nesting (≥ 10 levels of subgraph)
**Scenario:** A graph invokes a subgraph that invokes a subgraph, recursively, 10 levels deep.
**Expected behavior:** `parent_ids` grows to hold 10 entries. No truncation occurs. The
full ancestry chain is preserved. Performance is O(depth) for `parent_ids` allocation.

## Canonical Test Vectors

| # | Input | Expected Output | Notes |
|---|-------|-----------------|-------|
| TV-001 | Top-level run, no subgraphs; collect all events | All events: same `run_id`; `parent_ids = []` | Happy path — flat run |
| TV-002 | Run A → subgraph B; collect B's events | B events: `run_id = <B_uuid>`, `parent_ids = [<A_uuid>]` | Single nesting level |
| TV-003 | Run A → subgraph B → subgraph C; collect C's events | C events: `run_id = <C_uuid>`, `parent_ids = [<A_uuid>, <B_uuid>]` | Two nesting levels |
| TV-004 | Two concurrent runs R1 and R2 on different threads | R1 events: `run_id = <R1_uuid>`; R2 events: `run_id = <R2_uuid>`; no UUID collision | Concurrency uniqueness |
| TV-005 | Send API fan-out: 3 PUSH tasks in one super-step | All 3 PUSH-task events carry same `run_id` as enclosing run; `parent_ids` unchanged | Fan-out is within-run, not sub-run |

## Verification Properties

| VP ID | Description | Method | Phase |
|-------|-------------|--------|-------|
| VP-STREAM-04 | All events for a run share the same `run_id`; subgraph events carry correct `parent_ids` ancestry | Integration test — collect all events for nested run scenario; assert UUID uniqueness + parent chain correctness | Phase 1 |

## Related BCs

- BC-2.06.001 — depends on: `run_id` + `parent_ids` fields must exist on every `StreamEvent` variant defined there
- BC-2.06.003 — composes with: correlation fields must be correct on both streaming and unary event paths
- BC-2.04.004 — related to: `parent_checkpoint_id` provides lineage across the interrupted/resumed phases of a run (run_id unchanged; checkpoint lineage links checkpoints across the interrupt boundary within one run)
- BC-2.10.002 — related to: `EvidenceJournal` entries record `run_id` to correlate budget evaluations with runs

## Architecture Anchors

- `pregolya-graph/src/event_emitter.rs` (`graph::event_emitter`) — `StreamEvent` base fields: `run_id: Uuid`, `parent_ids: Vec<Uuid>`
- `pregolya-graph/src/scheduler.rs` (`graph::scheduler`) — `ExecutionContext` that propagates `run_id` and `parent_ids` into nested invocations
- `pregolya-server/src/run_lifecycle.rs` — `run_id` UUID generation at `Run` creation

## Story Anchor

S-1.17

## VP Anchors

- VP-STREAM-04

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-007 |
| Capability Anchor Justification | CAP-007 ("Structured Streaming Event Taxonomy") per capabilities-p0.md §CAP-007 — this BC specifies the `run_id` and `parent_ids` correlation tree that is explicitly named in the "each carrying a run_id, parent_ids chain" clause of CAP-007 |
| L2 Domain Invariants | — |
| D17 Commitment | CONFLICT-5 (astream_events v2 fixed 7-key shape including `run_id` and `parent_ids` per semport/core/behavioral-intent.md §D-2 is the reference model; pregolya adopts this correlation design) |
| CONFLICT Reference | CONFLICT-5 |
| Priority | P0 |
| Wave | Wave 1 |
| Test Types | I (integration) |
| Module | pregolya-graph / pregolya-server |
