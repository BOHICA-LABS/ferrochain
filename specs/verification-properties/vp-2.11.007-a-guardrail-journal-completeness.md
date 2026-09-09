---
document_type: verification-property
level: L4
id: VP-2.11.007-A
title: "GuardrailJournal Completeness — Every evaluate() Call Produces an Entry"
version: "1.3"
status: draft
producer: architect
timestamp: 2026-09-08T00:00:00Z
phase: 3
inputs:
  - .factory/specs/behavioral-contracts/ss-11/BC-2.11.007.md
input-hash: "384a5d1"
traces_to: VP-INDEX.md
source_bc: BC-2.11.007
module: graph::provenance
proof_method: integration
feasibility: feasible
verification_lock: false
proof_completed_date: null
proof_file_hash: null
# Lifecycle fields (DF-030)
lifecycle_status: active
introduced: DC-33
modified: [DC-34]
deprecated: null
deprecated_by: null
replacement: null
retired: null
withdrawn: null
withdrawal_reason: null
removed: null
removal_reason: null
# VP catalog fields
bc_anchor: "BC-2.11.007 {PC-001}/{INV-002}"
di_anchor: DI-012
crate: pregolya-graph
tool: integration
priority: P0
harness_fn: "n/a (integration test)"
file: vp-2.11.007-a-guardrail-journal-completeness.md
changelog:
  - "1.3 (D-356/DC-36/F-PDC36-05/2026-09-08, architect): F-PDC36-05 — write-ordering prose corrected in §Source Contract {PC-001} and §Formal Invariant {PC-001}: 'before the hook call returns' → 'after evaluate() returns' (the entry carries the returned GuardrailResult; BC-2.11.007 {EC-003} governs this ordering). Accumulate/persist split ruling (F-PDC36-01) documented in DC-36 delta note; routing to story-writer (S-1.29) and PO (BC-2.11.007 §Architecture Anchors) also in delta note."
  - "1.2 (D-356/DC-35/F-PDC35-01/F-PDC35-03/F-PDC35-04/2026-09-08, architect): F-PDC35-01 — no-hooks harness case rewritten: guardrail_journal is None (not Some([])) when no GuardrailHook is registered (BC-2.11.007 {INV-004}/{EC-004}/TV-002); separate case added for hooks-registered-zero-ingress → Some([]). F-PDC35-03 — test vehicle repointed from crates/pregolya-server/tests to crates/pregolya-graph/tests (VP module = graph::provenance / pregolya-graph); ServerTestFixture → GraphTestFixture. F-PDC35-04 — transform_applied residue removed from §Source Contract field list (canonical 4-field shape: boundary/result/provenance/timestamp_ms) and from §Proof Method Coverage cell."
  - "1.1 (D-356/DC-34/F-PDC34-01/F-PDC34-02/F-PDC34-03/O-PDC34-A/2026-09-08, architect): F-PDC34-01 — bc_anchor corrected {INV-003}→{INV-002} ({INV-002} is Completeness/DI-012; {INV-003} is Separation from EvidenceJournal — not what this VP tests). F-PDC34-02 — module repointed server::guardrail_journal→graph::provenance (crate: pregolya-graph); graph::provenance is the canonical GuardrailHook dispatch and journal-append site per BC-2.11.007 §Architecture Anchors. server::guardrail_journal was a phantom module not in module-decomposition.md. F-PDC34-03 — boundary semantic corrected throughout: IngressBoundary (existing canonical type; BC-2.06.001 §Postconditions PC-002; values ToolResult | RagChunk | MemoryItem) replaces String hook-identity label. O-PDC34-A — transform_applied field dropped from GuardrailEntry shape; result.Transform.new_content is authoritative."
  - "1.0 (D-356/DC-33/2026-09-08, architect): Minted. GuardrailJournal completeness integration P0. BC-2.11.007 {PC-001}/{INV-003}; DI-012; server::guardrail_journal; pregolya-server. Every GuardrailHook::evaluate() call for a run produces exactly one GuardrailEntry in the run's guardrail_journal, preserving call order. Human-authorized DC-33 core-domain extension; BC-2.11.007 authored by PO; entities-server.md §GuardrailJournal entity defined by BA."
---

# VP-2.11.007-A: GuardrailJournal Completeness — Every evaluate() Call Produces an Entry

## Property Statement

For any run that reaches terminal status, the `guardrail_journal` field in the run-read
response contains exactly one `GuardrailEntry` per `GuardrailHook::evaluate()` call made
during the run, in call order. No entry is suppressed — Pass, Fail, and Transform results
are all recorded. Entry fields match the evaluate call: `boundary` (ingress-boundary label;
canonical type `IngressBoundary` per BC-2.06.001 §Postconditions PC-002; values
ToolResult | RagChunk | MemoryItem), `result` (GuardrailResult variant), `provenance`
(ProvenanceTag), `timestamp_ms` (u64, monotone across entries). NOTE: `transform_applied`
is absent — `result.Transform.new_content` is the authoritative content payload (O-PDC34-A).

## Source Contract

- BC-2.11.007 §PC-001: Every `GuardrailHook::evaluate()` call appends a `GuardrailEntry`
  to the run's accumulated journal **after** `evaluate()` returns (the entry carries the
  returned `GuardrailResult`; append-before-return would be wrong — BC-2.11.007 {EC-003}).
- BC-2.11.007 §INV-002: For any terminal-status run, entries are appended in evaluate()
  call order with no gaps and no double-writes; every evaluate() call produces exactly one
  entry — this is the DI-012 completeness invariant applied to the persistence layer.
- BC-2.12.003 {PC-013}: The run-read endpoint returns `guardrail_journal?` as part of
  the completed run response.
- entities-server.md §GuardrailJournal: `GuardrailEntry` type definition — exactly 4 fields:
  `boundary: IngressBoundary`, `result: GuardrailResult`, `provenance: ProvenanceTag`,
  `timestamp_ms: u64`. NOTE: `transform_applied` is not a field (O-PDC34-A ruling).
- DI-012: "Guardrail Coverage at Ingress Boundaries" — all evaluate() calls must produce
  observable, durable records for security audit (CAP-047).

## Proof Method

| Method | Tool | Bounded? | Coverage |
|--------|------|----------|----------|
| Integration test | integration (pregolya-graph test harness) | Yes — N=3 hooks, deterministic fixture | Full Pass/Fail/Transform result variants; ordering; zero-hook None case; hooks-registered zero-ingress Some([]) case |

## Formal Invariant

```
∀ run_id: RunId,
  let calls = evaluate_calls_during_run(run_id),
  let journal = guardrail_journal_for_run(run_id):

  INV-002 (completeness):
    journal.len() == calls.len()
    ∧ ∀ i: 0 ≤ i < calls.len():
        journal[i].boundary       == calls[i].ingress_boundary  // IngressBoundary variant
        ∧ journal[i].result       == calls[i].result
        ∧ journal[i].timestamp_ms is monotone
    // NOTE: transform_applied field absent (O-PDC34-A); Transform payload is
    // result.Transform.new_content: IngressContent

  PC-001 (write obligation):
    every evaluate() call appends a GuardrailEntry AFTER evaluate() returns
```

(BC-2.11.007 {PC-001}/{INV-002}; DI-012 Guardrail Coverage at Ingress Boundaries)

## Proof Harness Skeleton

```rust
// File: crates/pregolya-graph/tests/guardrail_journal_completeness.rs
// Phase 3 integration test — requires live RunStore (SQLite in-process)
// VP module: graph::provenance (pregolya-graph)

#[tokio::test]
async fn guardrail_journal_completeness_all_variants() {
    // 1. Stand up pregolya-graph test fixture with in-process SQLite RunStore
    let fixture = GraphTestFixture::new().await;

    // 2. Register 3 GuardrailHooks with deterministic evaluate() results
    fixture.register_guardrail_hook("hook_a", GuardrailResult::Pass);
    fixture.register_guardrail_hook("hook_b", GuardrailResult::Fail);
    fixture.register_guardrail_hook("hook_c", GuardrailResult::Transform);

    // 3. Execute a run (triggers evaluate() at each ingress boundary)
    let thread_id = fixture.create_thread().await;
    let run_id = fixture.run_to_completion(thread_id, "test input").await;

    // 4. Fetch completed run
    let run = fixture.get_run(thread_id, run_id).await;

    // 5. Assert completeness invariant (BC-2.11.007 {INV-002})
    // Hooks registered → guardrail_journal is Some(non-empty)
    let journal = run.guardrail_journal.expect("guardrail_journal must be Some when hooks registered");
    assert_eq!(journal.len(), 3, "one entry per evaluate() call");

    // 6. Assert ordering and field correctness (BC-2.11.007 {PC-001})
    // boundary is IngressBoundary (ToolResult | RagChunk | MemoryItem per BC-2.06.001 §PC-002)
    assert_eq!(journal[0].result, GuardrailResult::Pass);
    assert_eq!(journal[1].result, GuardrailResult::Fail);
    assert!(matches!(journal[2].result, GuardrailResult::Transform { .. }));
    // Transform payload is result.Transform.new_content: IngressContent (O-PDC34-A)
    if let GuardrailResult::Transform { ref new_content } = journal[2].result {
        let _ = new_content; // exact assertion per Phase 3 fixture
    }

    // 7. Assert monotone timestamp_ms
    assert!(journal[1].timestamp_ms >= journal[0].timestamp_ms);
    assert!(journal[2].timestamp_ms >= journal[1].timestamp_ms);
}

#[tokio::test]
async fn guardrail_journal_none_when_no_hooks_registered() {
    // BC-2.11.007 {INV-004}/{EC-004}/TV-002:
    // NO GuardrailHook registered → journal never initialized →
    // guardrail_journal is None (null/omitted) on the run-read response.
    // This is DISTINCT from Some([]) — None means the journal was never opened.
    let fixture = GraphTestFixture::new().await;
    // Do NOT register any hooks
    let thread_id = fixture.create_thread().await;
    let run_id = fixture.run_to_completion(thread_id, "test input").await;
    let run = fixture.get_run(thread_id, run_id).await;
    assert!(
        run.guardrail_journal.is_none(),
        "no hooks registered → guardrail_journal must be None, not Some([])"
    );
}

#[tokio::test]
async fn guardrail_journal_some_empty_when_hooks_registered_zero_ingress() {
    // BC-2.11.007 {INV-002}: hooks registered but run reaches no ingress boundary →
    // journal initialized but empty → guardrail_journal is Some([]).
    // DISTINCT from the no-hook case (None).
    let fixture = GraphTestFixture::new().await;
    fixture.register_guardrail_hook("hook_a", GuardrailResult::Pass);
    // Use a fixture path that triggers zero ingress boundaries
    let thread_id = fixture.create_thread().await;
    let run_id = fixture.run_no_ingress_boundaries(thread_id).await;
    let run = fixture.get_run(thread_id, run_id).await;
    let journal = run.guardrail_journal.expect("hooks registered → guardrail_journal must be Some");
    assert!(journal.is_empty(), "hooks registered + zero ingress → Some([])");
}
```

Note: `GraphTestFixture` is the pregolya-graph integration-test harness. It wires
`Arc<dyn GuardrailHook>` instances directly into the graph::provenance constructor
per the Arc-DI wiring rule (CLAUDE.md). The fixture is the graph-layer analogue of
the VP-004/VP-005 MCP integration harness pattern.

## BC Traceability

| Source | BC / Invariant |
|--------|---------------|
| Primary BC | BC-2.11.007 {PC-001} — write obligation per evaluate() call |
| Invariant | BC-2.11.007 {INV-002} — completeness: every evaluate() call produces one entry, no gaps, no double-writes (DI-012) |
| Projection BC | BC-2.12.003 {PC-013} — run-read response includes guardrail_journal? |
| DI Anchor | DI-012 — Guardrail Coverage at Ingress Boundaries |
| Architecture Module | graph::provenance (pregolya-graph) — canonical GuardrailHook dispatch and journal-append site per BC-2.11.007 §Architecture Anchors |
| Subsystem | SS-11 (Guardrails) |

## BC Contradictions Flagged

None. BC-2.11.007 is a new BC (DC-33 core-domain amendment) with no prior conflicting
contract. The separation of `GuardrailResult` (Pass/Fail/Transform) from `PolicyDecision`
(Allow/Escalate/Deny) is established in ADR-031 §Decision 8. `EvidenceJournal` records
budget PolicyDecision outcomes only and does not conflict.

## Feasibility Assessment

| Factor | Assessment | Notes |
|--------|-----------|-------|
| Side effects | Yes — RunStore SQLite write/read cycle | Integration test required (proptest insufficient) |
| Hook count | Bounded (N=3 in fixture; deterministic evaluate() results) | Deterministic — no symbolic exploration needed |
| Runtime availability | pregolya-graph + SQLite backend at Phase 3 | Ships with SS-11 wave |
| Reference pattern | VP-004/VP-005 MCP integration tests (BC-2.09.004/005) | Same GraphTestFixture structural pattern |
| Estimated CI time | ~2 min per run | SQLite in-process; no external service |
| Confidence | HIGH | Property is purely count equality over a deterministic fixture |

## Proof Obligations

| Obligation | Status | Notes |
|------------|--------|-------|
| BC-2.11.007 active | SATISFIED (DC-33) | BC authored by PO |
| entities-server.md §GuardrailJournal defined | SATISFIED (DC-33) | BA added entity |
| BC-2.12.003 {PC-013} includes guardrail_journal? | SATISFIED (DC-33) | PO updated BC |
| GraphTestFixture wires GuardrailHook via Arc-DI | Phase 3 obligation | Implementer |
| Test compiles against live BC-2.11.007 API | Phase 3 Red Gate | Pre-delivery |

## Lifecycle

| Phase | Action |
|-------|--------|
| Phase 1b | VP minted (draft); BC-2.11.007 authored; body file delivered |
| Phase 3 (SS-11 wave) | Failing test written (Red Gate); implementation drives green |
| Phase 3 (SS-11 delivery) | VP status → active; merge gates VP-2.11.007-A green |
| Phase 6 | VP status reviewed; Kani supplement considered if pure-core extract is feasible |

> **D-356 adversary fix DC-34 (2026-09-08, architect).** F-PDC34-01: bc_anchor corrected `{INV-003}` → `{INV-002}` throughout (frontmatter, §Source Contract, §Formal Invariant footer, §BC Traceability) — {INV-002} is BC-2.11.007 Completeness/DI-012; {INV-003} is Separation from EvidenceJournal. F-PDC34-02: module repointed `server::guardrail_journal` → `graph::provenance`, crate `pregolya-server` → `pregolya-graph` — graph::provenance is the canonical GuardrailHook dispatch and journal-append site per BC-2.11.007 §Architecture Anchors; server::guardrail_journal was a phantom module not in module-decomposition.md. F-PDC34-03: §Property Statement and §Proof Harness updated — `boundary` corrected to `IngressBoundary` (existing canonical enum per BC-2.06.001 §Postconditions PC-002). O-PDC34-A: `transform_applied` removed from §Property Statement, §Formal Invariant, and §Proof Harness — `result.Transform.new_content: IngressContent` is authoritative; routing for PO/BA/story-writer in ADR-031 §Decision 8 DC-34 delta note.

> **D-356 adversary fix DC-36 (2026-09-08, architect).** F-PDC36-05 (MED): write-ordering prose corrected — §Source Contract {PC-001} and §Formal Invariant {PC-001} changed from "before the hook call returns" to "after evaluate() returns" (the GuardrailEntry carries the returned GuardrailResult; append-before-return would require time travel; BC-2.11.007 {EC-003} governs). **F-PDC36-01 (HIGH) ARCHITECTURAL RULING — graph→server GuardrailJournal persistence split** (mirroring EvidenceJournal pattern): `graph::provenance` (pregolya-graph) ACCUMULATES the journal — appends one `GuardrailEntry` to a run-scoped `Vec<GuardrailEntry>` after each `evaluate()` returns; the accumulated `Vec<GuardrailEntry>` is returned as part of the graph execution result (same channel the server already reads for `evidence_journal`); `server::handlers` (pregolya-server) PERSISTS the accumulated journal to RunStore atomically with the terminal state-machine write — same site and pattern as `evidence_journal` persistence (BC-2.10.002 / SS-12). pregolya-graph MUST NOT import RunStore (that would create a forbidden reverse edge: direction = pregolya-server→pregolya-graph→pregolya-core). **Story-writer routing (S-1.29):** §Architecture Mapping "Terminal journal persistence" row — change crate/module from pregolya-graph/graph::provenance to pregolya-server (server::handlers / run-state-machine terminal-state write site); Task 5 — move "write completed GuardrailJournal to RunStore" to pregolya-server run-state-machine terminal transition (same function as evidence_journal persistence, atomic with terminal state write); §File Structure — any new file for RunStore GuardrailJournal write belongs in pregolya-server, not pregolya-graph. In-flight append site stays pregolya-graph/graph::provenance. **PO routing (BC-2.11.007 §Architecture Anchors):** Replace the current §Architecture Anchors text for persistence with: "`graph::provenance` (pregolya-graph): ProvenanceTag attachment at ingress boundaries, GuardrailHook dispatch, GuardrailJournal ACCUMULATION — appends one `GuardrailEntry` to a run-scoped `Vec<GuardrailEntry>` after each `evaluate()` returns; returns accumulated `Vec<GuardrailEntry>` as part of graph execution result. `server::handlers` (pregolya-server): DURABLE RunStore persistence — writes accumulated `Vec<GuardrailEntry>` to RunStore atomically with terminal state-machine transition, same site and pattern as `evidence_journal` (BC-2.10.002). pregolya-graph DOES NOT import RunStore (reverse-edge violation). The 'same durability path as checkpoint put_writes' text is incorrect and must be removed."

> **D-356 adversary fix DC-35 (2026-09-08, architect).** F-PDC35-01 (HIGH): no-hooks harness case rewritten — `guardrail_journal_no_hooks_yields_empty_journal` (DC-33/DC-34) replaced with two distinct cases: (1) `guardrail_journal_none_when_no_hooks_registered` asserts `guardrail_journal.is_none()` (BC-2.11.007 {INV-004}/{EC-004}/TV-002 — no hook registered means journal never initialized; `None` is not `Some([])`); (2) `guardrail_journal_some_empty_when_hooks_registered_zero_ingress` asserts `Some([])` (hooks registered but zero ingress boundaries reached). F-PDC35-03 (MED): test vehicle repointed — file path `crates/pregolya-server/tests/...` → `crates/pregolya-graph/tests/guardrail_journal_completeness.rs`; `ServerTestFixture` → `GraphTestFixture`; §Proof Method Coverage and §Feasibility Assessment updated to pregolya-graph harness. F-PDC35-04 (MED): `transform_applied` residue removed — §Source Contract field list corrected to canonical 4-field shape (boundary/result/provenance/timestamp_ms; NOTE no transform_applied per O-PDC34-A); §Proof Method Coverage cell `transform_applied semantics` removed.
