---
document_type: verification-property
level: L4
id: VP-2.11.007-A
title: "GuardrailJournal Completeness — One Entry Per Successfully-Returning evaluate() Call"
version: "1.5"
status: draft
producer: architect
timestamp: 2026-09-08T00:00:00Z
phase: 3
inputs:
  - .factory/specs/behavioral-contracts/ss-11/BC-2.11.007.md
input-hash: "0c89d05"
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
modified: [DC-34, DC-35, DC-36, DC-37, DC-38]
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
  - "1.5 (D-356/DC-38/F-PDC38-01/F-PDC38-02/F-PDC38-07/2026-09-08, architect): F-PDC38-07 — VP retitled: subtitle changed from 'Every evaluate() Call Produces an Entry' to 'One Entry Per Successfully-Returning evaluate() Call' (frontmatter title + H1); propagated to all 4 mirrors. F-PDC38-01 — §Property Statement rewritten graph-side + successfully-returning wording: removed 'terminal status'/'run-read response' server-side framing; scoped to graph::provenance accumulation; {EC-003} carve-out explicit; matches §Formal Invariant already correct since DC-37. F-PDC38-02 — §Feasibility Assessment: all RunStore/SQLite references struck; Side effects row corrected to 'No — deterministic in-process GraphTestFixture; no RunStore, no SQLite'; Runtime availability corrected to 'pregolya-graph in-process graph execution'; CI time corrected to 'in-process only; no external service'. input-hash updated 7e6b00f→0c89d05 (BC-2.11.007 input drift)."
  - "1.4 (D-356/DC-37/F-PDC37-02/F-PDC37-03/2026-09-08, architect): F-PDC37-03 — §Proof Harness rewritten graph-side only: no RunStore, no run-read, no None/Some projection; assert on result.guardrail_journal (Vec<GuardrailEntry>) returned by in-process graph execution; removed guardrail_journal_none_when_no_hooks_registered (server-side concern); renamed zero-ingress case to guardrail_journal_completeness_zero_ingress_boundaries asserting Vec.len()==0; §Proof Method Coverage updated; S-1.29 file-split guidance documented in DC-37 delta note (story-writer). F-PDC37-02 — §Formal Invariant calls scoped to successfully_returning_evaluate_calls_during_run (per {EC-003}: errors/panics produce no entry); PC-001 comment updated to match. input-hash updated 7e6b00f (BC-2.11.007 input drift from this burst)."
  - "1.3 (D-356/DC-36/F-PDC36-05/2026-09-08, architect): F-PDC36-05 — write-ordering prose corrected in §Source Contract {PC-001} and §Formal Invariant {PC-001}: 'before the hook call returns' → 'after evaluate() returns' (the entry carries the returned GuardrailResult; BC-2.11.007 {EC-003} governs this ordering). Accumulate/persist split ruling (F-PDC36-01) documented in DC-36 delta note; routing to story-writer (S-1.29) and PO (BC-2.11.007 §Architecture Anchors) also in delta note."
  - "1.2 (D-356/DC-35/F-PDC35-01/F-PDC35-03/F-PDC35-04/2026-09-08, architect): F-PDC35-01 — no-hooks harness case rewritten: guardrail_journal is None (not Some([])) when no GuardrailHook is registered (BC-2.11.007 {INV-004}/{EC-004}/TV-002); separate case added for hooks-registered-zero-ingress → Some([]). F-PDC35-03 — test vehicle repointed from crates/pregolya-server/tests to crates/pregolya-graph/tests (VP module = graph::provenance / pregolya-graph); ServerTestFixture → GraphTestFixture. F-PDC35-04 — transform_applied residue removed from §Source Contract field list (canonical 4-field shape: boundary/result/provenance/timestamp_ms) and from §Proof Method Coverage cell."
  - "1.1 (D-356/DC-34/F-PDC34-01/F-PDC34-02/F-PDC34-03/O-PDC34-A/2026-09-08, architect): F-PDC34-01 — bc_anchor corrected {INV-003}→{INV-002} ({INV-002} is Completeness/DI-012; {INV-003} is Separation from EvidenceJournal — not what this VP tests). F-PDC34-02 — module repointed server::guardrail_journal→graph::provenance (crate: pregolya-graph); graph::provenance is the canonical GuardrailHook dispatch and journal-append site per BC-2.11.007 §Architecture Anchors. server::guardrail_journal was a phantom module not in module-decomposition.md. F-PDC34-03 — boundary semantic corrected throughout: IngressBoundary (existing canonical type; BC-2.06.001 §Postconditions PC-002; values ToolResult | RagChunk | MemoryItem) replaces String hook-identity label. O-PDC34-A — transform_applied field dropped from GuardrailEntry shape; result.Transform.new_content is authoritative."
  - "1.0 (D-356/DC-33/2026-09-08, architect): Minted. GuardrailJournal completeness integration P0. BC-2.11.007 {PC-001}/{INV-003}; DI-012; server::guardrail_journal; pregolya-server. Every GuardrailHook::evaluate() call for a run produces exactly one GuardrailEntry in the run's guardrail_journal, preserving call order. Human-authorized DC-33 core-domain extension; BC-2.11.007 authored by PO; entities-server.md §GuardrailJournal entity defined by BA."
---

# VP-2.11.007-A: GuardrailJournal Completeness — One Entry Per Successfully-Returning evaluate() Call

## Property Statement

For any graph execution with `GuardrailHook`s registered, `graph::provenance` accumulates
exactly one `GuardrailEntry` per **successfully-returning** `GuardrailHook::evaluate()` call,
appended to the run-scoped `Vec<GuardrailEntry>` after `evaluate()` returns. No entry is
produced for a panicking or erroring `evaluate()` call ({EC-003}). Pass, Fail, and Transform
results are all recorded in call order. Entry fields: `boundary` (`IngressBoundary` per
BC-2.06.001 §PC-002; values `ToolResult | RagChunk | MemoryItem`), `result` (`GuardrailResult`),
`provenance` (`ProvenanceTag`), `timestamp_ms` (`u64`, monotone across entries). NOTE:
`transform_applied` is absent — `result.Transform.new_content` is authoritative (O-PDC34-A).
NOTE: the durable RunStore write and run-read None/Some projection are server-side concerns
(F-PDC36-01, S-1.29 AC-002/AC-003) outside this VP's scope.

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
| Integration test | integration (pregolya-graph test harness) | Yes — N=3 hooks, deterministic fixture | Graph-side accumulation: Pass/Fail/Transform result variants; ordering; zero-ingress empty-Vec case. NOTE: None/Some run-read projection is server-side (S-1.29 AC-002/AC-003, pregolya-server tests) — not in scope here |

## Formal Invariant

```
∀ run_id: RunId,
  // {EC-003}: only SUCCESSFULLY-RETURNING evaluate() calls produce entries;
  // a panicking/erroring evaluate() appends no entry (F-PDC37-02)
  let calls = successfully_returning_evaluate_calls_during_run(run_id),
  let journal = accumulated_guardrail_journal_for_run(run_id):

  INV-002 (completeness — graph-side accumulation):
    journal.len() == calls.len()
    ∧ ∀ i: 0 ≤ i < calls.len():
        journal[i].boundary       == calls[i].ingress_boundary  // IngressBoundary variant
        ∧ journal[i].result       == calls[i].result
        ∧ journal[i].timestamp_ms is monotone
    // NOTE: transform_applied field absent (O-PDC34-A); Transform payload is
    // result.Transform.new_content: IngressContent
    // NOTE: RunStore persistence is server-side (F-PDC36-01); this invariant
    // covers accumulation in graph::provenance, not durable write

  PC-001 (write obligation):
    every successfully-returning evaluate() call appends a GuardrailEntry AFTER
    evaluate() returns; {EC-003} governs non-successful returns
```

(BC-2.11.007 {PC-001}/{INV-002}; DI-012 Guardrail Coverage at Ingress Boundaries)

## Proof Harness Skeleton

```rust
// File: crates/pregolya-graph/tests/guardrail_journal_completeness.rs
// Phase 3 integration test — graph-side ACCUMULATION only; no RunStore, no run-read projection
// VP module: graph::provenance (pregolya-graph)
// VP anchor: BC-2.11.007 {PC-001}/{INV-002} — completeness of accumulated Vec<GuardrailEntry>
//
// SCOPE NOTE (F-PDC37-03 / DC-37):
//   This VP tests that graph::provenance accumulates exactly one GuardrailEntry
//   per successful evaluate() call, returned in the graph execution result.
//   The None/Some([])/Some([N]) run-read projection is a SEPARATE server-side concern
//   tested in crates/pregolya-server/tests/ (S-1.29 AC-002/AC-003).
//   pregolya-graph MUST NOT depend on pregolya-server (forbidden reverse edge).

#[tokio::test]
async fn guardrail_journal_completeness_all_variants() {
    // BC-2.11.007 {INV-002}: 3 successful evaluate() calls → accumulated Vec.len() == 3
    // (only successfully-returning calls; {EC-003}: errors/panics produce no entry)
    let fixture = GraphTestFixture::new().await;
    fixture.register_guardrail_hook("hook_a", GuardrailResult::Pass);
    fixture.register_guardrail_hook("hook_b", GuardrailResult::Fail);
    fixture.register_guardrail_hook("hook_c", GuardrailResult::Transform);

    // Execute graph in-process; accumulated journal is in the execution result
    let result = fixture.run_graph("test input").await;
    let journal = &result.guardrail_journal; // Vec<GuardrailEntry>; no RunStore involved

    // Assert completeness (BC-2.11.007 {INV-002})
    assert_eq!(journal.len(), 3, "one entry per successful evaluate() call");

    // Assert ordering and field correctness (BC-2.11.007 {PC-001})
    // boundary is IngressBoundary (ToolResult | RagChunk | MemoryItem per BC-2.06.001 §PC-002)
    assert_eq!(journal[0].result, GuardrailResult::Pass);
    assert_eq!(journal[1].result, GuardrailResult::Fail);
    assert!(matches!(journal[2].result, GuardrailResult::Transform { .. }));
    // Transform payload is result.Transform.new_content: IngressContent (O-PDC34-A)
    if let GuardrailResult::Transform { ref new_content } = journal[2].result {
        let _ = new_content; // exact assertion per Phase 3 fixture
    }

    // Assert monotone timestamp_ms
    assert!(journal[1].timestamp_ms >= journal[0].timestamp_ms);
    assert!(journal[2].timestamp_ms >= journal[1].timestamp_ms);
}

#[tokio::test]
async fn guardrail_journal_completeness_zero_ingress_boundaries() {
    // BC-2.11.007 {INV-002}: hooks registered but run reaches no ingress boundary →
    // accumulated Vec is empty (graph-side; server-side None/Some projection not tested here)
    let fixture = GraphTestFixture::new().await;
    fixture.register_guardrail_hook("hook_a", GuardrailResult::Pass);

    let result = fixture.run_graph_no_ingress_boundaries().await;

    assert_eq!(
        result.guardrail_journal.len(),
        0,
        "hooks registered + zero ingress boundaries → empty accumulated Vec"
    );
}
```

Note: `GraphTestFixture` wires `Arc<dyn GuardrailHook>` instances directly into the
graph::provenance executor via Arc-DI (CLAUDE.md). `run_graph()` returns an in-process
execution result containing `guardrail_journal: Vec<GuardrailEntry>` — the accumulated
journal from graph::provenance. No RunStore, no server layer involved. Durable RunStore
persistence is tested in `crates/pregolya-server/tests/` (F-PDC36-01 split).

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
| Side effects | No — deterministic in-process GraphTestFixture; no RunStore, no SQLite | Integration test required (proptest insufficient) |
| Hook count | Bounded (N=3 in fixture; deterministic evaluate() results) | Deterministic — no symbolic exploration needed |
| Runtime availability | pregolya-graph in-process graph execution | Ships with SS-11 wave |
| Reference pattern | VP-004/VP-005 MCP integration tests (BC-2.09.004/005) | Same GraphTestFixture structural pattern |
| Estimated CI time | ~2 min per run | in-process only; no external service |
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

> **D-356 adversary fix DC-37 (2026-09-08, architect).** F-PDC37-03 (HIGH): §Proof Harness rewritten graph-side only — pregolya-graph CANNOT depend on pregolya-server (forbidden reverse edge); `get_run()`/RunStore/None/Some projection removed; harness now calls `fixture.run_graph()` and asserts on `result.guardrail_journal: Vec<GuardrailEntry>` directly; `guardrail_journal_none_when_no_hooks_registered` removed (server-side concern; belongs in S-1.29 AC-003 server-side tests); zero-ingress case rewritten to assert `Vec.len() == 0`. F-PDC37-02 (MED): §Formal Invariant `calls` scoped to `successfully_returning_evaluate_calls_during_run` (per {EC-003}: a panicking/erroring evaluate() appends no entry); §Formal Invariant and §Proof Method Coverage updated. **Story-writer routing (S-1.29 §File Structure split):** (a) `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` = AC-001 completeness/append (this VP's vehicle; graph-side; asserts on accumulated Vec); (b) `crates/pregolya-server/tests/<guardrail_journal_server_integration>.rs` = AC-002 RunStore terminal persistence + AC-003 run-read None/Some([])/Some([N]) projection (server-side; reaches RunStore). **PO routing (BC-2.11.007 {INV-002} wording):** Replace {INV-002} with: "Exactly one GuardrailEntry is appended to the run's accumulated journal per successfully-returning GuardrailHook::evaluate() call; a panicking or erroring evaluate() appends no entry per {EC-003}. The accumulated journal is returned as part of the graph execution result and persisted to RunStore by the server's terminal-state write (AC-002/AC-003; F-PDC36-01)."

> **D-356 adversary fix DC-36 (2026-09-08, architect).** F-PDC36-05 (MED): write-ordering prose corrected — §Source Contract {PC-001} and §Formal Invariant {PC-001} changed from "before the hook call returns" to "after evaluate() returns" (the GuardrailEntry carries the returned GuardrailResult; append-before-return would require time travel; BC-2.11.007 {EC-003} governs). **F-PDC36-01 (HIGH) ARCHITECTURAL RULING — graph→server GuardrailJournal persistence split** (mirroring EvidenceJournal pattern): `graph::provenance` (pregolya-graph) ACCUMULATES the journal — appends one `GuardrailEntry` to a run-scoped `Vec<GuardrailEntry>` after each `evaluate()` returns; the accumulated `Vec<GuardrailEntry>` is returned as part of the graph execution result (same channel the server already reads for `evidence_journal`); `server::handlers` (pregolya-server) PERSISTS the accumulated journal to RunStore atomically with the terminal state-machine write — same site and pattern as `evidence_journal` persistence (BC-2.10.002 / SS-12). pregolya-graph MUST NOT import RunStore (that would create a forbidden reverse edge: direction = pregolya-server→pregolya-graph→pregolya-core). **Story-writer routing (S-1.29):** §Architecture Mapping "Terminal journal persistence" row — change crate/module from pregolya-graph/graph::provenance to pregolya-server (server::handlers / run-state-machine terminal-state write site); Task 5 — move "write completed GuardrailJournal to RunStore" to pregolya-server run-state-machine terminal transition (same function as evidence_journal persistence, atomic with terminal state write); §File Structure — any new file for RunStore GuardrailJournal write belongs in pregolya-server, not pregolya-graph. In-flight append site stays pregolya-graph/graph::provenance. **PO routing (BC-2.11.007 §Architecture Anchors):** Replace the current §Architecture Anchors text for persistence with: "`graph::provenance` (pregolya-graph): ProvenanceTag attachment at ingress boundaries, GuardrailHook dispatch, GuardrailJournal ACCUMULATION — appends one `GuardrailEntry` to a run-scoped `Vec<GuardrailEntry>` after each `evaluate()` returns; returns accumulated `Vec<GuardrailEntry>` as part of graph execution result. `server::handlers` (pregolya-server): DURABLE RunStore persistence — writes accumulated `Vec<GuardrailEntry>` to RunStore atomically with terminal state-machine transition, same site and pattern as `evidence_journal` (BC-2.10.002). pregolya-graph DOES NOT import RunStore (reverse-edge violation). The 'same durability path as checkpoint put_writes' text is incorrect and must be removed."

> **D-356 adversary fix DC-38 (2026-09-08, architect).** F-PDC38-01 (HIGH): §Property Statement rewritten — removed server-side framing ('terminal status', 'run-read response', unqualified count); now scopes to graph::provenance accumulation, successfully-returning evaluate() calls, and {EC-003} carve-out for panicking/erroring calls; explicit note that RunStore write and run-read None/Some projection are server-side concerns (F-PDC36-01, S-1.29 AC-002/AC-003) outside this VP's scope. F-PDC38-02 (MED): §Feasibility Assessment stripped of all RunStore/SQLite references — Side effects row corrected to 'No — deterministic in-process GraphTestFixture; no RunStore, no SQLite'; Runtime availability corrected to 'pregolya-graph in-process graph execution'; CI time corrected to 'in-process only; no external service'. F-PDC38-07 (LOW): VP retitled throughout — subtitle 'Every evaluate() Call Produces an Entry' → 'One Entry Per Successfully-Returning evaluate() Call' in frontmatter title + H1; propagated to all 4 mirrors (verification-coverage-matrix.md title cell, ARCH-INDEX.md description cell, verification-architecture.md §P0 catalog header, VP-INDEX.md correction note). input-hash updated 7e6b00f→0c89d05 (BC-2.11.007 input drift from background burst).

> **D-356 adversary fix DC-35 (2026-09-08, architect).** F-PDC35-01 (HIGH): no-hooks harness case rewritten — `guardrail_journal_no_hooks_yields_empty_journal` (DC-33/DC-34) replaced with two distinct cases: (1) `guardrail_journal_none_when_no_hooks_registered` asserts `guardrail_journal.is_none()` (BC-2.11.007 {INV-004}/{EC-004}/TV-002 — no hook registered means journal never initialized; `None` is not `Some([])`); (2) `guardrail_journal_some_empty_when_hooks_registered_zero_ingress` asserts `Some([])` (hooks registered but zero ingress boundaries reached). F-PDC35-03 (MED): test vehicle repointed — file path `crates/pregolya-server/tests/...` → `crates/pregolya-graph/tests/guardrail_journal_completeness.rs`; `ServerTestFixture` → `GraphTestFixture`; §Proof Method Coverage and §Feasibility Assessment updated to pregolya-graph harness. F-PDC35-04 (MED): `transform_applied` residue removed — §Source Contract field list corrected to canonical 4-field shape (boundary/result/provenance/timestamp_ms; NOTE no transform_applied per O-PDC34-A); §Proof Method Coverage cell `transform_applied semantics` removed.
