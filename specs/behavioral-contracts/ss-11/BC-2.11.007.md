---
document_type: behavioral-contract
level: L3
bc_id: BC-2.11.007
version: "1.1"
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
  - "1.1 (D-356/DC-34/2026-09-08, product-owner): F-PDC34-03: {PC-001} GuardrailEntry shape — boundary corrected from String to IngressBoundary (existing canonical enum per BC-2.06.001 {PC-002}; values ToolResult|RagChunk|MemoryItem). O-PDC34-A: transform_applied: Option<String> dropped from GuardrailEntry shape — result.Transform{new_content: IngressContent} is authoritative; full-BC sweep applied. TV-001 updated: boundary: IngressBoundary::ToolResult; transform_applied refs removed. F-PDC34-05: three MINT-REQUIRED claims removed — VP-2.11.007-A is minted and registered in VP-INDEX; anchors {INV-002} (completeness) and module graph::provenance. F-PDC34-06: S-1.29 → S-1.29 in §Story Anchor and §Traceability Stories (STORY-S-1.29-guardrail-journal-persistence, Wave-1 P0)."
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
emits only Fail/Transform events per ADR-006 rev-3, F-P99-01). The `GuardrailJournal` is
persisted in the RunStore record when the run reaches a terminal state and is projected on the
run-read response as `guardrail_journal?` for post-run inspection. The `GuardrailJournal` is
SEPARATE from the `EvidenceJournal` (BC-2.10.002), which records budget `PolicyDecision` outcomes
(Allow/Escalate/Deny) — a distinct governance dimension that must not be conflated with guardrail
content evaluation results.

## Preconditions

1. {PRE-001} A `GuardrailHook` is registered on the `InvocationContext` (per BC-2.11.001) and the
   run's `GuardrailJournal` has been initialized.
2. {PRE-002} A run is executing and `GuardrailHook::evaluate()` has been called at an ingress
   boundary (ToolResult, RagChunk, or MemoryItem per BC-2.11.002/003/004).
3. {PRE-003} The run's associated `RunStore` record is writable and capable of persisting the
   `GuardrailJournal` on terminal state transition.

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

2. {PC-002} **Journal persisted at terminal state:** When a run reaches any terminal state
   (`completed`, `failed`, `cancelled`, `summary_halt`), the `GuardrailJournal` accumulated
   during the run is persisted as part of the RunStore record for that run
   (entities-server.md §RunStore).

3. {PC-003} **Journal projected on run-read response:** `guardrail_journal?` is included in the
   response to `GET /threads/{thread_id}/runs/{run_id}` when `status` is a terminal state
   (`completed`, `failed`, `cancelled`, `summary_halt`). It is null or omitted for
   active/queued runs. This field is the substrate for completed-run guardrail history
   consumed by the developer console (BC-2.24.008 {PC-004}). Authority: BC-2.12.003 {PC-013}.

## Invariants

- {INV-001} **Append-only:** `GuardrailJournal` entries are never mutated or deleted once
  appended. The journal represents an immutable audit trail for the run's guardrail history.

- {INV-002} **Completeness — DI-012:** Entries are appended in the order `GuardrailHook::evaluate()`
  is called within the run. Every evaluate() call produces exactly one entry; there are no
  gaps and no double-writes. This is the DI-012 completeness invariant applied to the
  persistence layer: every guardrail evaluation is accountable.

- {INV-003} **Separation from EvidenceJournal:** The `GuardrailJournal` (this BC) and the
  `EvidenceJournal` (BC-2.10.002) are distinct data structures with distinct semantics:
  - `GuardrailJournal` records content guardrail evaluation results (`GuardrailResult`:
    Pass/Fail/Transform per `GuardrailHook::evaluate`).
  - `EvidenceJournal` records budget policy decisions (`PolicyDecision`:
    Allow/Escalate/Deny per BC-2.10.002).
  These MUST NOT be conflated in the RunStore schema, the run-read response projection,
  or any consumer (see BC-2.12.003 {PC-013}, BC-2.24.008 {PC-004}).

- {INV-004} **No journal entries when no hook registered:** When no `GuardrailHook` is registered
  (BC-2.11.006 default-permit path), `GuardrailHook::evaluate()` is never called; therefore
  no `GuardrailEntry` records are written. `guardrail_journal?` is null or omitted on the
  run-read response for such runs. This is distinct from a run that has a hook registered but
  all evaluations return Pass (which produces a non-empty journal with Pass entries).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Run with all Pass decisions; guardrail_journal? inspected on terminal-status run-read response | `guardrail_journal?` present with all Pass entries; journal is non-empty even though SSE had no `guardrail_decision` events (Pass not streamed per F-P99-01) |
| {EC-002} | Run fails (transitions to `failed`) before all ingress boundaries are evaluated | Journal entries written up to the point of failure are persisted in the RunStore `failed` record; partial journal is the authoritative record for that run |
| {EC-003} | `GuardrailHook::evaluate()` throws an error or panics | The evaluate() error is propagated per BC-2.11.002/003/004 error handling; no `GuardrailEntry` is appended for a failed evaluate() call (entry written only on successful return of `GuardrailResult`) |
| {EC-004} | No `GuardrailHook` registered (BC-2.11.006 path) | `guardrail_journal?` is null or omitted on terminal-status run-read response; the journal was never initialized because no evaluate() calls occurred |
| {EC-005} | Two `GuardrailHook` instances composed in parallel (both evaluate the same content unit) | Each hook's evaluate() call appends one entry independently; the journal records both calls with their respective results. For a single content unit processed by 2 composed hooks, 2 entries appear |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Run with 3 tool-result ingress events; registered hook returns Pass/Fail/Transform respectively; run completes | `guardrail_journal?` on terminal-status run-read response contains exactly 3 entries in evaluation order: `{result: Pass, boundary: IngressBoundary::ToolResult, ...}`, `{result: Fail{reason, severity}, boundary: IngressBoundary::ToolResult, ...}`, `{result: Transform{new_content}, boundary: IngressBoundary::ToolResult, ...}` | happy-path completeness |
| TV-002 | No `GuardrailHook` registered (BC-2.11.006 default-permit path); run completes | Terminal-status run-read response: `guardrail_journal?` is null or omitted (no evaluate() calls) | no-hook path |
| TV-003 | Run with 1 Pass decision only; run completes | `guardrail_journal?` contains 1 entry with `result: Pass`; journal non-empty even though SSE emitted no `guardrail_decision` events | Pass-only run |
| TV-004 | Run with registered hook; run transitions to `failed` after 2 evaluate() calls | `guardrail_journal?` on `failed` run-read response contains the 2 entries written before failure; partial journal persisted | failed-run partial journal |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.11.007-A | `GuardrailJournal` contains exactly one entry per `GuardrailHook::evaluate()` call; entries are in evaluation order; no missing evaluations | Integration test — instrument evaluate() calls; assert journal entry count == evaluate() call count; verify ordering. Minted and registered in VP-INDEX; anchors {INV-002} (DI-012 journal completeness) and module `graph::provenance`. Parallel to VP-BUDGET-03 (EvidenceJournal completeness). |

## Related BCs

- BC-2.11.001 — depends on: ProvenanceTag (included in every GuardrailEntry) is provided by the ingress tagging contract
- BC-2.11.002 — composes with: ToolResult GuardrailHook::evaluate() results are journaled by this BC
- BC-2.11.003 — composes with: RagChunk GuardrailHook::evaluate() results are journaled by this BC
- BC-2.11.004 — composes with: MemoryItem GuardrailHook::evaluate() results are journaled by this BC
- BC-2.11.005 — composes with: the Fail path enforced by BC-2.11.005 produces a GuardrailEntry governed by this BC
- BC-2.10.002 — parallel: EvidenceJournal (budget PolicyDecision outcomes); same append-only pattern, distinct governance dimension; MUST NOT be conflated
- BC-2.12.003 — depends on: guardrail_journal? is projected on run-read response per {PC-013}
- BC-2.24.008 — consumer: guardrail review panel reads guardrail_journal? for completed-run reconstruction per {PC-004}

## Architecture Anchors

- `entities-server.md §RunStore` — RunStore schema must include `guardrail_journal` field alongside `evidence_journal`; both are persisted at terminal state transition
- `architecture/module-decomposition.md §pregolya-graph` — `graph::provenance` row: GuardrailJournal append on every evaluate() call (HIGH, SS-11); journal write uses same durability path as checkpoint put_writes
- `architecture/module-decomposition.md §pregolya-server` — run-read response shape; `guardrail_journal?` projected for terminal-status runs alongside `evidence_journal?`

## Story Anchor

S-1.29 (STORY-S-1.29-guardrail-journal-persistence, Wave-1 P0 — implements BC-2.11.007)

## VP Anchors

- VP-2.11.007-A — GuardrailJournal completeness: 1 entry per evaluate() call, evaluation order (integration test). Minted and registered in VP-INDEX; anchors {INV-002} (DI-012 journal completeness) and module `graph::provenance`. Parallel to VP-BUDGET-03.

## Traceability

| Field | Value |
|-------|-------|
| L2 Capability | CAP-013 |
| Capability Anchor Justification | CAP-013 ("Content Provenance Tagging and Guardrail-on-Ingress") per capabilities-p0.md §CAP-013 — this BC specifies the durable persistence of every GuardrailHook::evaluate() result, which is the audit-trail counterpart to the guardrail-on-ingress enforcement contract described in CAP-013. Without durable journaling, the "on-ingress" evaluation has no post-run accountable record. |
| Secondary Consumer Capability | CAP-047 ("Guardrail/Security Decision Review Panel") per capabilities-p1-p2.md §CAP-047 — BC-2.24.008 (the guardrail review panel) consumes guardrail_journal? as the substrate for completed-run guardrail history reconstruction ({PC-004}); this BC is the persistence contract that makes CAP-047's completed-run view possible. |
| L2 Domain Invariants | DI-012 (Guardrail Coverage at Ingress Boundaries — {INV-002} journal completeness ensures every guardrail evaluation is accountable; the journal is the persistence-layer enforcement of DI-012) |
| Reference Evidence | Greenfield. No upstream reference implementation. Pattern mirrors EvidenceJournal (BC-2.10.002 / VP-BUDGET-03) applied to the guardrail subsystem. The GuardrailEntry shape is architect-fixed per DC-33 adjudication. |
| Binding Decisions | D17-Q8 (guardrail subsystem, Phase-1 BC); D-356 DC-33 (durable GuardrailJournal authoring, human-authorized scope) |
| Architecture Module | pregolya-graph (journal append on evaluate()); pregolya-server (RunStore persistence; run-read response projection) |
| Stories | S-1.29 |
| VP Registration | VP-2.11.007-A (minted and registered in VP-INDEX; anchors {INV-002} and module `graph::provenance`) |
