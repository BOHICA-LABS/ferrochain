---
document_type: behavioral-contract
level: L3
bc_id: BC-2.11.007
version: "1.5"
status: draft
producer: product-owner
timestamp: 2026-09-08T00:00:00Z
phase: 1a
inputs:
  - .factory/specs/domain-spec/capabilities-p0.md
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/domain-spec/invariants.md
  - .factory/specs/domain-spec/edge-cases.md
  - .factory/planning/holdout-domains/domain-a-soc-analyst.md
input-hash: "700cc6e"
traces_to:
  - domain-spec/capabilities-p0.md#CAP-013
  - domain-spec/capabilities-p1-p2.md#CAP-047
origin: greenfield
subsystem: SS-11
capability: CAP-013
lifecycle_status: active
introduced: v1.0.0-greenfield
changelog:
  - "1.0 (D-356/DC-33/2026-09-08, product-owner): Initial BC — durable GuardrailJournal persistence. Every GuardrailHook::evaluate() call at an ingress boundary appends exactly one GuardrailEntry to the run's append-only GuardrailJournal (Pass, Fail, and Transform all recorded); journal is persisted in the RunStore record for terminal-status runs (entities-server.md §RunStore); guardrail_journal? is projected on GET /threads/{thread_id}/runs/{run_id} for terminal-status runs (BC-2.12.003 {PC-013}). GuardrailJournal is SEPARATE from EvidenceJournal (BC-2.10.002): distinct governance dimensions. DI-012 completeness invariant. VP-2.11.007-A minting requested (parallel to VP-BUDGET-03). D-356 DC-33 human-authorized scope."
  - "1.1 (D-356/DC-34/2026-09-08, product-owner): F-PDC34-03: {PC-001} GuardrailEntry shape — boundary corrected from String to IngressBoundary (existing canonical enum per BC-2.06.001 {PC-002}; values ToolResult|RagChunk|MemoryItem). O-PDC34-A: transform_applied: Option<String> dropped from GuardrailEntry shape — result.Transform{new_content: IngressContent} is authoritative; full-BC sweep applied. TV-001 updated: boundary: IngressBoundary::ToolResult; transform_applied refs removed. F-PDC34-05: three MINT-REQUIRED claims removed — VP-2.11.007-A is minted and registered in VP-INDEX; anchors {INV-002} (completeness) and module graph::provenance. F-PDC34-06: S-TBD → S-1.29 in §Story Anchor and §Traceability Stories (STORY-S-1.29-guardrail-journal-persistence, Wave-1 P0)."
  - "1.2 (D-356/DC-36/2026-09-08, product-owner): F-PDC36-03: {EC-004} rationale corrected — discriminator is hook REGISTRATION not evaluate()-call count; {EC-004} now reads 'no GuardrailHook registered → journal never initialized → None'; {EC-006} added for hook-registered + zero-ingress → Some([]) (empty journal persisted); {INV-004} updated with all three states (no-hook→None; hook+0-ingress→Some([]); hook+N-ingress→Some([N])); TV-002 rationale updated. F-PDC36-04: VP-anchor reconciled to {PC-001}/{INV-002} at all three sites (§Verification Properties, §VP Anchors, §Traceability). F-PDC36-01: §Architecture Anchors replaced with architect-exact wording (graph::provenance accumulation; server::handlers RunStore persistence; reverse-edge note); 'checkpoint put_writes' reference removed."
  - "1.3 (D-356/DC-37/2026-09-08, product-owner): F-PDC37-02: {INV-002} panic/error carve-out — replaced unqualified 'every evaluate() call produces exactly one entry' with architect-exact wording: 'exactly one GuardrailEntry per successfully-returning evaluate() call; panicking or erroring evaluate() appends no entry per {EC-003}; accumulated journal returned as part of graph execution result and persisted to RunStore by server terminal-state write (AC-002/AC-003; F-PDC36-01)'. §Verification Properties VP-2.11.007-A property statement and §VP Anchors bullet updated to reflect successfully-returning qualifier for consistency with {INV-002}/{EC-003}. No double-count on panic path: {EC-003} (no entry on panic), {INV-002} (successful-call only), VP-2.11.007-A (successful-call count asserted) all now consistent."
  - "1.4 (D-356/DC-38/2026-09-08, product-owner): F-PDC38-04: phantom entities-server.md §RunStore anchor corrected — two sites repointed to §GuardrailJournal (the correct domain-spec heading): (1) {PC-002} parenthetical '(entities-server.md §RunStore)' → '(entities-server.md §GuardrailJournal)'; (2) §Traceability Architecture Module row — added 'entities-server.md §GuardrailJournal' as explicit domain-entity anchor alongside the runtime module references (pregolya-server RunStore persistence). Runtime RunStore references in Description, {PRE-003}, {INV-002}, §Architecture Anchors, {EC-002} are code-module references — kept intact per F-PDC38-04 carve-out."
  - "1.5 (D-356/DC-39/2026-09-09, product-owner): Architect re-adjudicated persistence model — GuardrailJournal is CHECKPOINT-BACKED (pregolya-checkpoint SQLite, same backend as BC-2.10.002 EvidenceJournal), sync-durable incremental append BEFORE execution continues at each ingress boundary; NOT a terminal-state RunStore write. §Architecture Anchors replaced with architect-exact 2-bullet model: graph::provenance DURABLE ACCUMULATION to checkpoint store; server::run_read_handler assembles None/Some projection at run-read time. Whole-file sweep corrected: Description (terminal-state RunStore ref); {PRE-003} (RunStore writable → checkpoint store accessible); {PC-002} (terminal-state write → checkpoint-backed incremental, run_read_handler projection); {INV-002} (removed terminal-write tail, added checkpoint-backed tail consistent with BC-2.10.002 {INV-003}); {INV-003} (RunStore schema → checkpoint store schema); {INV-004} (RunStore record → checkpoint store); {EC-002} (RunStore failed record → checkpoint store); {EC-006} (persisted at terminal state → checkpoint-backed); TV-005 (persisted at completion → checkpoint-backed); Related BCs BC-2.10.002 (same append-only → same checkpoint-backed append-only); §Traceability Architecture Module (RunStore persistence → checkpoint-backed append + run_read_handler projection)."
modified: []
extracted_from: null
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
priority: P0
wave: 1
d17_commitment: Q8
---

# BC-2.11.007: Guardrail Evaluation Results Are Durably Journaled

## Description

Every call to `GuardrailHook::evaluate()` at an ingress boundary appends exactly one
`GuardrailEntry` to the run's append-only `GuardrailJournal` — including Pass results, so the
journal forms a complete audit trail for all guardrail evaluations (unlike the SSE stream, which
emits only Fail/Transform events per ADR-006 rev-3, F-P99-01). The `GuardrailJournal` is checkpoint-backed (pregolya-checkpoint) and each entry is persisted
sync-durably before graph execution continues at each ingress boundary; the `guardrail_journal?`
field on the run-read response is assembled by `server::run_read_handler` from the checkpoint
store at run-read time. The `GuardrailJournal` is
SEPARATE from the `EvidenceJournal` (BC-2.10.002), which records budget `PolicyDecision` outcomes
(Allow/Escalate/Deny) — a distinct governance dimension that must not be conflated with guardrail
content evaluation results.

## Preconditions

1. {PRE-001} A `GuardrailHook` is registered on the `InvocationContext` (per BC-2.11.001) and the
   run's `GuardrailJournal` has been initialized.
2. {PRE-002} A run is executing and `GuardrailHook::evaluate()` has been called at an ingress
   boundary (ToolResult, RagChunk, or MemoryItem per BC-2.11.002/003/004).
3. {PRE-003} The checkpoint store (pregolya-checkpoint) is accessible for sync-durable
   `GuardrailEntry` writes at each ingress boundary.

## Postconditions

1. {PC-001} **Journal append on every evaluate() call:** Every `GuardrailHook::evaluate()` call at
   an ingress boundary appends exactly one `GuardrailEntry` to the run's append-only
   `GuardrailJournal`. The canonical `GuardrailEntry` shape is:
   ```
   GuardrailEntry {
     boundary:     IngressBoundary,  // ToolResult | RagChunk | MemoryItem (BC-2.06.001 §PC-002)
     result:       GuardrailResult,  // Pass | Fail{reason,severity} | Transform{new_content}
     provenance:   ProvenanceTag,
     timestamp_ms: u64,
   }
   ```
   All three `GuardrailResult` variants — `Pass`, `Fail{reason, severity}`, and
   `Transform{new_content: IngressContent}` — are recorded. This
   ensures the journal is complete for DI-012 purposes. Note: the SSE stream emits only
   Fail/Transform events (ADR-006 rev-3, F-P99-01); the journal records all three so that the
   completed-run review surface (BC-2.24.008 {PC-004}) has a complete audit trail.

2. {PC-002} **Journal durably persisted at each ingress boundary:** The `GuardrailJournal` is
   checkpoint-backed (pregolya-checkpoint, same SQLite backend as BC-2.10.002 EvidenceJournal).
   Each `GuardrailEntry` is written sync-durably to the checkpoint store BEFORE graph execution
   continues, after each successfully-returning `evaluate()`. At run-read time,
   `server::run_read_handler` assembles the `guardrail_journal?` None/Some projection by
   querying `checkpoint_store.get_guardrail_journal(run_id)`
   (entities-server.md §GuardrailJournal; S-1.29 AC-002/AC-003).

3. {PC-003} **Journal projected on run-read response:** `guardrail_journal?` is included in the
   response to `GET /threads/{thread_id}/runs/{run_id}` when `status` is a terminal state
   (`completed`, `failed`, `cancelled`, `summary_halt`). It is null or omitted for
   active/queued runs. This field is the substrate for completed-run guardrail history
   consumed by the developer console (BC-2.24.008 {PC-004}). Authority: BC-2.12.003 {PC-013}.

## Invariants

- {INV-001} **Append-only:** `GuardrailJournal` entries are never mutated or deleted once
  appended. The journal represents an immutable audit trail for the run's guardrail history.

- {INV-002} **Completeness — DI-012:** Exactly one `GuardrailEntry` is appended to the run's
  checkpoint-backed journal per **successfully-returning** `GuardrailHook::evaluate()` call; a
  panicking or erroring `evaluate()` appends no entry per {EC-003}. Each entry is written
  sync-durably to the checkpoint store (pregolya-checkpoint) before execution continues,
  consistent with BC-2.10.002 {INV-003} (EvidenceJournal checkpoint-backed durability).

- {INV-003} **Separation from EvidenceJournal:** The `GuardrailJournal` (this BC) and the
  `EvidenceJournal` (BC-2.10.002) are distinct data structures with distinct semantics:
  - `GuardrailJournal` records content guardrail evaluation results (`GuardrailResult`:
    Pass/Fail/Transform per `GuardrailHook::evaluate`).
  - `EvidenceJournal` records budget policy decisions (`PolicyDecision`:
    Allow/Escalate/Deny per BC-2.10.002).
  These MUST NOT be conflated in the checkpoint store schema, the run-read response projection,
  or any consumer (see BC-2.12.003 {PC-013}, BC-2.24.008 {PC-004}).

- {INV-004} **Journal presence governed by hook registration, not evaluate() call count:** The
  three distinct states are:
  - **No hook registered** (BC-2.11.006 default-permit path): journal is never initialized;
    `guardrail_journal?` is `None` (null/omitted) on the run-read response. This is because
    the journal lifecycle is tied to hook registration at run start, not to whether any
    evaluate() calls occurred.
  - **Hook registered, zero ingress boundaries crossed** (run completes without triggering
    any guarded boundary): journal is initialized but no entries are appended;
    `guardrail_journal?` is `Some([])` — an empty list, not `None`. The journal IS persisted
    in the checkpoint store (pregolya-checkpoint).
  - **Hook registered, N ingress boundaries crossed** (N > 0 evaluate() calls succeeded):
    `guardrail_journal?` is `Some([N entries])`.
  The discriminator between `None` and `Some([])` is hook registration, not evaluate()-call
  count. Both the no-hook and zero-ingress cases have zero evaluate() calls, but only the
  no-hook case yields `None`.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Run with all Pass decisions; guardrail_journal? inspected on terminal-status run-read response | `guardrail_journal?` present with all Pass entries; journal is non-empty even though SSE had no `guardrail_decision` events (Pass not streamed per F-P99-01) |
| {EC-002} | Run fails (transitions to `failed`) before all ingress boundaries are evaluated | Journal entries written up to the point of failure are durably persisted in the checkpoint store (pregolya-checkpoint); the partial journal is assembled by `server::run_read_handler` at run-read time and is the authoritative record for that run |
| {EC-003} | `GuardrailHook::evaluate()` throws an error or panics | The evaluate() error is propagated per BC-2.11.002/003/004 error handling; no `GuardrailEntry` is appended for a failed evaluate() call (entry written only on successful return of `GuardrailResult`) |
| {EC-004} | No `GuardrailHook` registered (BC-2.11.006 path) | `guardrail_journal?` is `None` (null/omitted) on terminal-status run-read response; the journal was never initialized because no hook was registered — NOT because no evaluate() calls occurred (zero-ingress hook-registered runs also have zero evaluate() calls but yield `Some([])`, not `None`; see {EC-006}) |
| {EC-005} | Two `GuardrailHook` instances composed in parallel (both evaluate the same content unit) | Each hook's evaluate() call appends one entry independently; the journal records both calls with their respective results. For a single content unit processed by 2 composed hooks, 2 entries appear |
| {EC-006} | `GuardrailHook` registered; run executes and completes but zero ingress boundaries are crossed (e.g., a pure computation graph with no tool calls, RAG, or memory reads) | `guardrail_journal?` is `Some([])` — an empty list (not `None`); the journal was initialized at hook registration and is checkpoint-backed (pregolya-checkpoint), but no entries were appended. Distinguishable from the no-hook case ({EC-004}) which yields `None` |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Run with 3 tool-result ingress events; registered hook returns Pass/Fail/Transform respectively; run completes | `guardrail_journal?` on terminal-status run-read response contains exactly 3 entries in evaluation order: `{result: Pass, boundary: IngressBoundary::ToolResult, ...}`, `{result: Fail{reason, severity}, boundary: IngressBoundary::ToolResult, ...}`, `{result: Transform{new_content}, boundary: IngressBoundary::ToolResult, ...}` | happy-path completeness |
| TV-002 | No `GuardrailHook` registered (BC-2.11.006 default-permit path); run completes | Terminal-status run-read response: `guardrail_journal?` is `None` (null/omitted); journal was never initialized (no hook registered — discriminator is registration, not evaluate()-call count; {INV-004}, {EC-004}) | no-hook path ({EC-004}) |
| TV-003 | Run with 1 Pass decision only; run completes | `guardrail_journal?` contains 1 entry with `result: Pass`; journal non-empty even though SSE emitted no `guardrail_decision` events | Pass-only run |
| TV-004 | Run with registered hook; run transitions to `failed` after 2 evaluate() calls | `guardrail_journal?` on `failed` run-read response contains the 2 entries written before failure; partial journal persisted | failed-run partial journal |
| TV-005 | `GuardrailHook` registered; run completes with zero ingress boundaries crossed | Terminal-status run-read response: `guardrail_journal?` is `Some([])` (empty list, NOT `None`); journal initialized at hook registration, checkpoint-backed (pregolya-checkpoint), zero entries appended ({EC-006}, {INV-004}) | hook-registered zero-ingress ({EC-006}) |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.11.007-A | `GuardrailJournal` contains exactly one entry per **successfully-returning** `GuardrailHook::evaluate()` call; entries are in evaluation order; panicking or erroring calls append no entry (per {EC-003}/{INV-002}); no missing evaluations from successful calls | Integration test — instrument evaluate() calls; assert journal entry count == successful evaluate() call count; verify ordering. Minted and registered in VP-INDEX; anchors {PC-001}/{INV-002} (write-obligation and DI-012 completeness) and module `graph::provenance`. Parallel to VP-BUDGET-03 (EvidenceJournal completeness). |

## Related BCs

- BC-2.11.001 — depends on: ProvenanceTag (included in every GuardrailEntry) is provided by the ingress tagging contract
- BC-2.11.002 — composes with: ToolResult GuardrailHook::evaluate() results are journaled by this BC
- BC-2.11.003 — composes with: RagChunk GuardrailHook::evaluate() results are journaled by this BC
- BC-2.11.004 — composes with: MemoryItem GuardrailHook::evaluate() results are journaled by this BC
- BC-2.11.005 — composes with: the Fail path enforced by BC-2.11.005 produces a GuardrailEntry governed by this BC
- BC-2.10.002 — parallel: EvidenceJournal (budget PolicyDecision outcomes); same checkpoint-backed append-only pattern (pregolya-checkpoint SQLite), distinct governance dimension; MUST NOT be conflated
- BC-2.12.003 — depends on: guardrail_journal? is projected on run-read response per {PC-013}
- BC-2.24.008 — consumer: guardrail review panel reads guardrail_journal? for completed-run reconstruction per {PC-004}

## Architecture Anchors

- `graph::provenance` (pregolya-graph): ProvenanceTag attachment at ingress boundaries, GuardrailHook dispatch, GuardrailJournal DURABLE ACCUMULATION — appends one `GuardrailEntry` to the checkpoint-backed `GuardrailJournal` (pregolya-checkpoint, same SQLite backend as BC-2.10.002 EvidenceJournal) sync-durably BEFORE execution continues at each ingress boundary, after each successfully-returning `evaluate()`; a panicking/erroring `evaluate()` appends no entry ({EC-003}). pregolya-graph imports the checkpoint abstraction (NOT RunStore; RunStore = pregolya-server; reverse-edge violation).
- `server::run_read_handler` (pregolya-server): assembles `guardrail_journal?` None/Some projection by querying `checkpoint_store.get_guardrail_journal(run_id)` at run-read time (S-1.29 AC-002/AC-003); NOT a terminal-state write.

## Story Anchor

S-1.29 (STORY-S-1.29-guardrail-journal-persistence, Wave-1 P0 — implements BC-2.11.007)

## VP Anchors

- VP-2.11.007-A — GuardrailJournal completeness: 1 entry per successfully-returning evaluate() call (panicking/erroring calls append no entry per {EC-003}/{INV-002}), evaluation order (integration test). Minted and registered in VP-INDEX; anchors {PC-001}/{INV-002} (write-obligation and DI-012 completeness) and module `graph::provenance`. Parallel to VP-BUDGET-03.

## Traceability

| Field | Value |
|-------|-------|
| L2 Capability | CAP-013 |
| Capability Anchor Justification | CAP-013 ("Content Provenance Tagging and Guardrail-on-Ingress") per capabilities-p0.md §CAP-013 — this BC specifies the durable persistence of every GuardrailHook::evaluate() result, which is the audit-trail counterpart to the guardrail-on-ingress enforcement contract described in CAP-013. Without durable journaling, the "on-ingress" evaluation has no post-run accountable record. |
| Secondary Consumer Capability | CAP-047 ("Guardrail/Security Decision Review Panel") per capabilities-p1-p2.md §CAP-047 — BC-2.24.008 (the guardrail review panel) consumes guardrail_journal? as the substrate for completed-run guardrail history reconstruction ({PC-004}); this BC is the persistence contract that makes CAP-047's completed-run view possible. |
| L2 Domain Invariants | DI-012 (Guardrail Coverage at Ingress Boundaries — {INV-002} journal completeness ensures every guardrail evaluation is accountable; the journal is the persistence-layer enforcement of DI-012) |
| Reference Evidence | Greenfield. No upstream reference implementation. Pattern mirrors EvidenceJournal (BC-2.10.002 / VP-BUDGET-03) applied to the guardrail subsystem. The GuardrailEntry shape is architect-fixed per DC-33 adjudication. |
| Binding Decisions | D17-Q8 (guardrail subsystem, Phase-1 BC); D-356 DC-33 (durable GuardrailJournal authoring, human-authorized scope) |
| Architecture Module | pregolya-graph (checkpoint-backed GuardrailEntry append on evaluate(); pregolya-checkpoint SQLite backend); pregolya-server (run-read projection via run_read_handler; entities-server.md §GuardrailJournal) |
| Stories | S-1.29 |
| VP Registration | VP-2.11.007-A (minted and registered in VP-INDEX; anchors {PC-001}/{INV-002} and module `graph::provenance`) |
