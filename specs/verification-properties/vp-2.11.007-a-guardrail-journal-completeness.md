---
document_type: verification-property
level: L4
id: VP-2.11.007-A
title: "GuardrailJournal Completeness — One Entry Per Successfully-Returning evaluate() Call"
version: "1.17"
status: draft
producer: architect
timestamp: 2026-09-10T00:00:00Z
phase: 3
inputs:
  - .factory/specs/behavioral-contracts/ss-11/BC-2.11.007.md
input-hash: "abc1b6a"
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
modified: [DC-34, DC-35, DC-36, DC-37, DC-38, DC-39, DC-40, DC-44, DC-46, DC-48, DC-52, DC-55, DC-56, DC-57, DC-66]
# DF-030 scope: modified[] tracks DC-burst body edits only. Records-only micro-bursts and
# non-DC bursts (e.g., v1.13 records-straggler) are recorded via the changelog and are
# exempt from this array per PGAP-DF030-MODIFIED-ARRAY.
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
  - "1.17 (DC-66/F-PDC66-03/2026-09-10, architect): F-PDC66-03 [LOW] — §BC Traceability Primary BC row: added 'successfully-returning' qualifier for parity with Invariant row and all other live-body {PC-001} paraphrases. 'write obligation per evaluate() call' → 'write obligation per successfully-returning evaluate() call'. input-hash refreshed abc1b6a (BC-2.11.007 input drift from parallel PO burst)."
  - "1.16 (DC-57/F-PDC57-01/F-PDC57-03/2026-09-09, architect): F-PDC57-01 (HIGH) — §Proof Harness full compile audit: three E0533 struct-variant-as-bare-value defects fixed. (1) register_guardrail_hook('hook_b', GuardrailResult::Fail) → Fail { reason: 'test-fail-reason'.to_string(), severity: GuardrailSeverity::High }; (2) register_guardrail_hook('hook_c', GuardrailResult::Transform) → Transform { new_content: IngressContent::ToolResult(ContentBlock::Text(TextContentBlock { text: ..., annotations: vec![] })) } (same-boundary rule per BC-2.11.002 {EC-003}); (3) assert_eq!(journal[1].result, GuardrailResult::Fail) — bare struct-variant path in assert_eq! arg is also E0533 — replaced with matches!()+if-let field-check mirroring the existing journal[2] Transform arm pattern. All other harness sites confirmed correct: GuardrailResult::Pass unit variant (OK), double-unwrap chain (DC-55 fix, OK), GuardrailEntry.timestamp_ms u64 monotone assertions (OK), journal.len() count assertions (OK), zero-ingress function (OK). F-PDC57-03 (LOW, process-gap) — DF-030 modified[] scope note added as frontmatter comment: modified[] tracks DC-burst body edits only; records-only micro-bursts and non-DC bursts recorded via changelog are exempt. Aligns with PGAP-DF030-MODIFIED-ARRAY. input-hash refreshed (BC-2.11.007 input drift from parallel PO burst)."
  - "1.15 (DC-56/F-PDC56-01/F-PDC56-02/2026-09-09, architect): F-PDC56-01 (LOW) — frontmatter modified: array incomplete: DC-46, DC-48, DC-52 each edited the VP body but were omitted from the modified: array. Added DC-46 (v1.10 body edit: §Source Contract item anchor form fix — §INV-002 → {INV-002}), DC-48 (v1.11 body edit: phantom server::run_read_handler → server::handlers at §Property Statement NOTE + §Proof Harness SCOPE NOTE), DC-52 (v1.12 body edit: §PC-002 → {PC-002} at §Property Statement boundary field + §Proof Harness SCOPE NOTE), and DC-56. F-PDC56-02 (LOW) — §Source Contract {PC-001} bullet missing 'successfully-returning' qualifier: 'Every GuardrailHook::evaluate() call appends' → 'Every successfully-returning GuardrailHook::evaluate() call appends'. The {EC-003} carve-out citation already present — the parity fix aligns §Source Contract {PC-001} with §Formal Invariant PC-001, §Source Contract {INV-002}, and §BC Traceability Invariant row (all carry 'successfully-returning'). Exhaustive corpus sweep: all other live-body {PC-001} paraphrases in .factory/specs/ + .factory/stories/ confirmed qualified or changelog-context; one straggler in BC-2.11.007 {EC-005} ('each hook's evaluate() call appends one entry independently' — missing qualifier) is product-owner-owned, outside architect scope — reported to orchestrator per companion principle. input-hash unchanged (BC-2.11.007 input did not change)."
  - "1.14 (DC-55/F-PDC55-01/F-PDC55-02/2026-09-09, architect): F-PDC55-01 (HIGH) — §Proof Harness double-unwrap fix: get_guardrail_journal returns Result<Option<Vec<GuardrailEntry>>, PregolyaError>; single .expect() yields Option<Vec<GuardrailEntry>>, not Vec<GuardrailEntry> — .len() and index access on Option do not compile. Both harness functions (guardrail_journal_completeness_all_variants and guardrail_journal_completeness_zero_ingress_boundaries) now chain .expect(\"hook registered so journal record exists\") on the Option layer, after the Result-level .expect(). The Option-unwrap is safe because the init-op (init_guardrail_journal at run start, iff hook is registered) guarantees Some(...) is returned when a hook is registered; the .expect() message is self-documenting. Also corrects false DC-44 harness-compatibility closure (TD-VSDD-059): DC-44 delta note §Harness compatibility claim 'harness unchanged' / 'No harness changes needed' was provably wrong (single .expect() left the harness uncompilable); that section now carries a correction note. v1.9 changelog entry similarly annotated. F-PDC55-02 (LOW) — §BC Traceability Invariant row: 'every evaluate() call produces one entry' → 'every successfully-returning evaluate() call produces one entry' ({EC-003} qualifier; matches all other live-body sites swept in DC-37..DC-39 cascade). Sibling sweep: zero other VP files use the Result<Option<Vec<...>>> single-unwrap pattern; zero other live-body occurrences of the unqualified phrase found corpus-wide. input-hash updated 48d5a26→ca31e6b (BC-2.11.007 input drift)."
  - "1.13 (records-straggler/A-02/A-03/2026-09-09, architect): A-02 (LOW) — §Source Contract first bullet: BC-2.11.007 §PC-001 → BC-2.11.007 {PC-001} (ADR-027 stable clause anchor form). A-03 sibling: BC-2.06.001 §PC-002 already fixed in DC-52 (v1.12). input-hash unchanged (BC-2.11.007 input did not change)."
  - "1.12 (DC-52/F-PDC52-01/2026-09-09, architect): F-PDC52-01 (LOW) — §PC-002→{PC-002} at two live-body sites: (1) §Property Statement boundary field description; (2) §Proof Harness SCOPE-NOTE boundary comment. Canonical clause anchor form is {PC-002} (ADR-027 stable clause anchors); DC-46 swept §INV-002→{INV-002} but missed these two §PC-002 siblings. input-hash unchanged (BC-2.11.007 input did not change)."
  - "1.11 (D-356/DC-48/F-PDC48-02/2026-09-09, architect): F-PDC48-02 (MED) — phantom `server::run_read_handler` replaced with canonical `server::handlers` at two live-body sites: (1) §Property Statement NOTE block ('assembled from the checkpoint store by server::run_read_handler' → 'assembled from the checkpoint store by the run-read handler in server::handlers'); (2) §Proof Harness SCOPE NOTE comment ('assembled by server::run_read_handler from checkpoint store' → 'assembled by the run-read handler in server::handlers from checkpoint store'). server::run_read_handler is not a separate module (F-PDC48-02/DC-48). input-hash updated 122e08a→9293d4e (input drift from prior burst)."
  - "1.10 (D-356/DC-46/2026-09-09, architect): DC-46 gate-backlog fix — phantom anchor `ADR-031 §DC-44 delta note` → `ADR-031 §Decision 8` (frontmatter changelog + body DC-44 note; verify-adr-anchor-citations.sh); item anchor `BC-2.11.007 §INV-002` → `BC-2.11.007 {INV-002}` in §Source Contract (BC item anchor form, not heading form). input-hash refreshed 122e08a (computed by hook during this burst)."
  - "1.9 (D-356/DC-44/F-PDC44-01/2026-09-09, architect): F-PDC44-01 (MED) — DC-44 delta note added: journal-existence/initialization mechanism ruling (init_guardrail_journal at run start). modified: array updated to add DC-44. NOTE(DC-55/F-PDC55-01): the harness-compatibility claim originally recorded here ('harness .expect() calls are already compatible ... harness unchanged') was incorrect — single .expect() on Result<Option<Vec<GuardrailEntry>>> yields Option<Vec<GuardrailEntry>>, not Vec<GuardrailEntry>; .len() and index access on Option do not compile; the double-unwrap form is required and was applied in v1.14 (DC-55). Downstream wording for PO/BA/story-writer in ADR-031 §Decision 8. input-hash unchanged (BC-2.11.007 unchanged)."
  - "1.8 (D-356/DC-43/F-PDC43-02/2026-09-09, architect): F-PDC43-02 (LOW) — frontmatter modified: array corrected: DC-40 appended (DC-40 bumped VP body from v1.6→v1.7 and annotated DC-37 note — it was a version-bumping burst). DC-41 NOT added (VP body was not touched at DC-41; only ADR-031 and module-decomposition.md were edited then). input-hash refreshed (BC-2.11.007 input drift from prior burst)."
  - "1.7 (D-356/DC-40/F-PDC40-01/2026-09-09, architect): F-PDC40-01 (MED) — DC-37 delta note annotated with inline supersession marker: persistence is checkpoint-backed, NOT a RunStore terminal-state write; no accumulated-Vec graph-result channel. DC-37 note was a sibling of DC-36 (now superseded) and carried the same false model in its PO-routing clause. Annotation follows F-PDC34-04 pattern applied to DC-29 note. Body-only change; no property, harness, or catalog row changes."
  - "1.6 (D-356/DC-39/F-PDC39-01/F-PDC39-02/F-PDC39-03/2026-09-08, architect): F-PDC39-02 (HIGH) — Persistence model corrected: EvidenceJournal analogy (DC-36 F-PDC36-01) was FALSE. GuardrailJournal is checkpoint-backed (pregolya-checkpoint), same model as BC-2.10.002 EvidenceJournal; graph::provenance appends sync-durable per successful evaluate() BEFORE execution continues; journal queried from checkpoint store (not returned via graph result Vec); §Proof Harness rewritten to query fixture.checkpoint_store.get_guardrail_journal(run_id); DC-36 delta note annotated PARTIALLY SUPERSEDED. §Property Statement NOTE updated: 'durable RunStore write' replaced with 'run-read projection from checkpoint store'. §Formal Invariant checkpoint NOTEs updated. §Proof Method Coverage updated. F-PDC39-03 (MED) — §Source Contract {INV-002} bullet rewritten: removed 'terminal-status run'/'persistence layer'; added 'successfully-returning'/{EC-003}/checkpoint-backed graph-side language. F-PDC39-01 (HIGH) — §P0 catalog in verification-architecture.md rewritten in same burst."
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
appended to the checkpoint-backed `GuardrailJournal` (pregolya-checkpoint, same durability
model as `EvidenceJournal` — BC-2.10.002 {INV-003}) sync-durable **after** `evaluate()`
returns and before execution continues at that ingress boundary. No entry is produced for a
panicking or erroring `evaluate()` call ({EC-003}). Pass, Fail, and Transform results are all
recorded in call order. Entry fields: `boundary` (`IngressBoundary` per
BC-2.06.001 {PC-002}; values `ToolResult | RagChunk | MemoryItem`), `result` (`GuardrailResult`),
`provenance` (`ProvenanceTag`), `timestamp_ms` (`u64`, monotone across entries). NOTE:
`transform_applied` is absent — `result.Transform.new_content` is authoritative (O-PDC34-A).
NOTE: the run-read `guardrail_journal?` None/Some projection is assembled from the
checkpoint store by the run-read handler in `server::handlers` — a server-side concern
(S-1.29 AC-002/AC-003; `server::run_read_handler` is not a separate module —
F-PDC48-02/DC-48) outside this VP's scope. The journal write IS graph-side (checkpoint-backed, sync-durable in
`graph::provenance`) — NOT a RunStore terminal write (F-PDC39-02 corrects DC-36 F-PDC36-01).

## Source Contract

- BC-2.11.007 {PC-001}: Every successfully-returning `GuardrailHook::evaluate()` call appends a `GuardrailEntry`
  to the run's accumulated journal **after** `evaluate()` returns (the entry carries the
  returned `GuardrailResult`; append-before-return would be wrong — BC-2.11.007 {EC-003}).
- BC-2.11.007 {INV-002}: Exactly one `GuardrailEntry` is appended to the checkpoint-backed
  journal per **successfully-returning** `GuardrailHook::evaluate()` call, sync-durable
  before execution continues at that ingress boundary; a panicking or erroring `evaluate()`
  appends no entry ({EC-003}); entries are in call order with no gaps and no double-writes
  — this is the DI-012 completeness invariant for graph-side journal accumulation.
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
| Integration test | integration (pregolya-graph test harness) | Yes — N=3 hooks, deterministic fixture | Graph-side checkpoint accumulation: Pass/Fail/Transform result variants; ordering; zero-ingress empty-journal case. Journal queried from `fixture.checkpoint_store.get_guardrail_journal(run_id)` (parallel to VP-BUDGET-03/EvidenceJournal pattern). NOTE: None/Some run-read projection is server-side (S-1.29 AC-002/AC-003, pregolya-server tests) — not in scope here |

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
    // NOTE: journal is checkpoint-backed (pregolya-checkpoint; F-PDC39-02 ruling);
    // append is sync-durable in graph::provenance before execution continues;
    // run-read guardrail_journal? projection is assembled from checkpoint store server-side

  PC-001 (write obligation):
    every successfully-returning evaluate() call appends a GuardrailEntry AFTER
    evaluate() returns; {EC-003} governs non-successful returns
```

(BC-2.11.007 {PC-001}/{INV-002}; DI-012 Guardrail Coverage at Ingress Boundaries)

## Proof Harness Skeleton

```rust
// File: crates/pregolya-graph/tests/guardrail_journal_completeness.rs
// Phase 3 integration test — graph-side ACCUMULATION into checkpoint store
// VP module: graph::provenance (pregolya-graph)
// VP anchor: BC-2.11.007 {PC-001}/{INV-002} — completeness of checkpoint-backed GuardrailJournal
//
// SCOPE NOTE (F-PDC39-02 / DC-39):
//   GuardrailJournal is checkpoint-backed (pregolya-checkpoint), same durability model as
//   EvidenceJournal (BC-2.10.002 {INV-003}). graph::provenance appends each GuardrailEntry
//   sync-durable BEFORE execution continues at that ingress boundary. The journal is NOT
//   returned via the graph execution result; it is queried from the checkpoint store.
//   The run-read guardrail_journal? None/Some projection is assembled by the
//   run-read handler in server::handlers from checkpoint store — a separate server-side
//   concern tested in crates/pregolya-server/tests/ (S-1.29 AC-002/AC-003;
//   `server::run_read_handler` is not a separate module — F-PDC48-02/DC-48).
//   pregolya-graph MUST NOT depend on pregolya-server (forbidden reverse edge).

#[tokio::test]
async fn guardrail_journal_completeness_all_variants() {
    // BC-2.11.007 {INV-002}: 3 successful evaluate() calls → checkpoint journal.len() == 3
    // {EC-003}: panicking/erroring evaluate() appends no entry
    let fixture = GraphTestFixture::new().await;
    fixture.register_guardrail_hook("hook_a", GuardrailResult::Pass);
    fixture.register_guardrail_hook("hook_b", GuardrailResult::Fail {
        reason: "test-fail-reason".to_string(),
        severity: GuardrailSeverity::High,
    });
    fixture.register_guardrail_hook("hook_c", GuardrailResult::Transform {
        // new_content must be same IngressContent variant as evaluated content (BC-2.11.002 {EC-003})
        new_content: IngressContent::ToolResult(ContentBlock::Text(TextContentBlock {
            text: "transformed content".to_string(),
            annotations: vec![],
        })),
    });

    let run_id = fixture.run_graph("test input").await;

    // Query checkpoint store for accumulated journal entries (parallel to VP-BUDGET-03 pattern)
    // get_guardrail_journal returns Result<Option<Vec<GuardrailEntry>>, PregolyaError>:
    //   first .expect() unwraps Result → Option<Vec<GuardrailEntry>>
    //   second .expect() unwraps Option → Vec<GuardrailEntry>
    //   Option-unwrap is safe: hook registered → init_guardrail_journal guarantees Some(...)
    let journal = fixture.checkpoint_store
        .get_guardrail_journal(run_id).await
        .expect("journal query should succeed")
        .expect("hook registered so journal record exists");

    // Assert completeness (BC-2.11.007 {INV-002})
    assert_eq!(journal.len(), 3, "one entry per successful evaluate() call");

    // Assert ordering and field correctness (BC-2.11.007 {PC-001})
    // boundary is IngressBoundary (ToolResult | RagChunk | MemoryItem per BC-2.06.001 {PC-002})
    assert_eq!(journal[0].result, GuardrailResult::Pass);
    assert!(matches!(journal[1].result, GuardrailResult::Fail { .. }));
    if let GuardrailResult::Fail { ref reason, ref severity } = journal[1].result {
        let _ = (reason, severity); // exact assertion per Phase 3 fixture
    }
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
    // checkpoint journal is empty (graph-side; server-side None/Some projection not tested here)
    let fixture = GraphTestFixture::new().await;
    fixture.register_guardrail_hook("hook_a", GuardrailResult::Pass);

    let run_id = fixture.run_graph_no_ingress_boundaries().await;

    // get_guardrail_journal returns Result<Option<Vec<GuardrailEntry>>, PregolyaError>:
    //   first .expect() unwraps Result → Option<Vec<GuardrailEntry>>
    //   second .expect() unwraps Option → Vec<GuardrailEntry>
    //   Option-unwrap is safe: hook registered → init_guardrail_journal guarantees Some([])
    let journal = fixture.checkpoint_store
        .get_guardrail_journal(run_id).await
        .expect("journal query should succeed")
        .expect("hook registered so journal record exists");
    assert_eq!(
        journal.len(),
        0,
        "hooks registered + zero ingress boundaries → empty checkpoint journal"
    );
}
```

Note: `GraphTestFixture` wires `Arc<dyn GuardrailHook>` instances directly into
`graph::provenance` via Arc-DI (CLAUDE.md) and provides an in-process checkpoint store
(`fixture.checkpoint_store`). After `run_graph()` completes, the test queries
`checkpoint_store.get_guardrail_journal(run_id)` to retrieve the entries appended
sync-durably during execution — same pattern as VP-BUDGET-03/BC-2.10.002 EvidenceJournal.
The journal is NOT in the execution result; it is in the checkpoint store.
Run-read `guardrail_journal?` None/Some projection is tested in
`crates/pregolya-server/tests/` (S-1.29 AC-002/AC-003; separate server-side concern).

## BC Traceability

| Source | BC / Invariant |
|--------|---------------|
| Primary BC | BC-2.11.007 {PC-001} — write obligation per successfully-returning evaluate() call |
| Invariant | BC-2.11.007 {INV-002} — completeness: every successfully-returning evaluate() call produces one entry, no gaps, no double-writes (DI-012) |
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

> *(SUPERSEDED by DC-39/F-PDC39-02 — persistence is checkpoint-backed, NOT a RunStore terminal-state write; no accumulated-Vec graph-result channel; see DC-39 note below)*
>
> **D-356 adversary fix DC-37 (2026-09-08, architect).** F-PDC37-03 (HIGH): §Proof Harness rewritten graph-side only — pregolya-graph CANNOT depend on pregolya-server (forbidden reverse edge); `get_run()`/RunStore/None/Some projection removed; harness now calls `fixture.run_graph()` and asserts on `result.guardrail_journal: Vec<GuardrailEntry>` directly; `guardrail_journal_none_when_no_hooks_registered` removed (server-side concern; belongs in S-1.29 AC-003 server-side tests); zero-ingress case rewritten to assert `Vec.len() == 0`. F-PDC37-02 (MED): §Formal Invariant `calls` scoped to `successfully_returning_evaluate_calls_during_run` (per {EC-003}: a panicking/erroring evaluate() appends no entry); §Formal Invariant and §Proof Method Coverage updated. **Story-writer routing (S-1.29 §File Structure split):** (a) `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` = AC-001 completeness/append (this VP's vehicle; graph-side; asserts on accumulated Vec); (b) `crates/pregolya-server/tests/<guardrail_journal_server_integration>.rs` = AC-002 RunStore terminal persistence + AC-003 run-read None/Some([])/Some([N]) projection (server-side; reaches RunStore). **PO routing (BC-2.11.007 {INV-002} wording):** Replace {INV-002} with: "Exactly one GuardrailEntry is appended to the run's accumulated journal per successfully-returning GuardrailHook::evaluate() call; a panicking or erroring evaluate() appends no entry per {EC-003}. The accumulated journal is returned as part of the graph execution result and persisted to RunStore by the server's terminal-state write (AC-002/AC-003; F-PDC36-01)."

> *(F-PDC36-01 SUPERSEDED by DC-39/F-PDC39-02: the evidence_journal analogy was FALSE — EvidenceJournal is checkpoint-backed, NOT RunStore terminal-state. GuardrailJournal aligns to the ACTUAL EvidenceJournal model: checkpoint-backed, graph::provenance appends sync-durable. DO NOT use this delta note for S-1.29 Task 5 or BC-2.11.007 §Architecture Anchors routing — see DC-39 delta note below.)*
>
> **D-356 adversary fix DC-36 (2026-09-08, architect).** F-PDC36-05 (MED): write-ordering prose corrected — §Source Contract {PC-001} and §Formal Invariant {PC-001} changed from "before the hook call returns" to "after evaluate() returns" (the GuardrailEntry carries the returned GuardrailResult; append-before-return would require time travel; BC-2.11.007 {EC-003} governs). **F-PDC36-01 (HIGH) ARCHITECTURAL RULING — graph→server GuardrailJournal persistence split** (mirroring EvidenceJournal pattern): `graph::provenance` (pregolya-graph) ACCUMULATES the journal — appends one `GuardrailEntry` to a run-scoped `Vec<GuardrailEntry>` after each `evaluate()` returns; the accumulated `Vec<GuardrailEntry>` is returned as part of the graph execution result (same channel the server already reads for `evidence_journal`); `server::handlers` (pregolya-server) PERSISTS the accumulated journal to RunStore atomically with the terminal state-machine write — same site and pattern as `evidence_journal` persistence (BC-2.10.002 / SS-12). pregolya-graph MUST NOT import RunStore (that would create a forbidden reverse edge: direction = pregolya-server→pregolya-graph→pregolya-core). **Story-writer routing (S-1.29):** §Architecture Mapping "Terminal journal persistence" row — change crate/module from pregolya-graph/graph::provenance to pregolya-server (server::handlers / run-state-machine terminal-state write site); Task 5 — move "write completed GuardrailJournal to RunStore" to pregolya-server run-state-machine terminal transition (same function as evidence_journal persistence, atomic with terminal state write); §File Structure — any new file for RunStore GuardrailJournal write belongs in pregolya-server, not pregolya-graph. In-flight append site stays pregolya-graph/graph::provenance. **PO routing (BC-2.11.007 §Architecture Anchors):** Replace the current §Architecture Anchors text for persistence with: "`graph::provenance` (pregolya-graph): ProvenanceTag attachment at ingress boundaries, GuardrailHook dispatch, GuardrailJournal ACCUMULATION — appends one `GuardrailEntry` to a run-scoped `Vec<GuardrailEntry>` after each `evaluate()` returns; returns accumulated `Vec<GuardrailEntry>` as part of graph execution result. `server::handlers` (pregolya-server): DURABLE RunStore persistence — writes accumulated `Vec<GuardrailEntry>` to RunStore atomically with terminal state-machine transition, same site and pattern as `evidence_journal` (BC-2.10.002). pregolya-graph DOES NOT import RunStore (reverse-edge violation). The 'same durability path as checkpoint put_writes' text is incorrect and must be removed."

> **D-356 adversary fix DC-38 (2026-09-08, architect).** F-PDC38-01 (HIGH): §Property Statement rewritten — removed server-side framing ('terminal status', 'run-read response', unqualified count); now scopes to graph::provenance accumulation, successfully-returning evaluate() calls, and {EC-003} carve-out for panicking/erroring calls; explicit note that RunStore write and run-read None/Some projection are server-side concerns (F-PDC36-01, S-1.29 AC-002/AC-003) outside this VP's scope. F-PDC38-02 (MED): §Feasibility Assessment stripped of all RunStore/SQLite references — Side effects row corrected to 'No — deterministic in-process GraphTestFixture; no RunStore, no SQLite'; Runtime availability corrected to 'pregolya-graph in-process graph execution'; CI time corrected to 'in-process only; no external service'. F-PDC38-07 (LOW): VP retitled throughout — subtitle 'Every evaluate() Call Produces an Entry' → 'One Entry Per Successfully-Returning evaluate() Call' in frontmatter title + H1; propagated to all 4 mirrors (verification-coverage-matrix.md title cell, ARCH-INDEX.md description cell, verification-architecture.md §P0 catalog header, VP-INDEX.md correction note). input-hash updated 7e6b00f→0c89d05 (BC-2.11.007 input drift from background burst).

> **D-356 adversary fix DC-35 (2026-09-08, architect).** F-PDC35-01 (HIGH): no-hooks harness case rewritten — `guardrail_journal_no_hooks_yields_empty_journal` (DC-33/DC-34) replaced with two distinct cases: (1) `guardrail_journal_none_when_no_hooks_registered` asserts `guardrail_journal.is_none()` (BC-2.11.007 {INV-004}/{EC-004}/TV-002 — no hook registered means journal never initialized; `None` is not `Some([])`); (2) `guardrail_journal_some_empty_when_hooks_registered_zero_ingress` asserts `Some([])` (hooks registered but zero ingress boundaries reached). F-PDC35-03 (MED): test vehicle repointed — file path `crates/pregolya-server/tests/...` → `crates/pregolya-graph/tests/guardrail_journal_completeness.rs`; `ServerTestFixture` → `GraphTestFixture`; §Proof Method Coverage and §Feasibility Assessment updated to pregolya-graph harness. F-PDC35-04 (MED): `transform_applied` residue removed — §Source Contract field list corrected to canonical 4-field shape (boundary/result/provenance/timestamp_ms; NOTE no transform_applied per O-PDC34-A); §Proof Method Coverage cell `transform_applied semantics` removed.

> **D-356 adversary fix DC-39 (2026-09-09, architect).** Three findings on this VP:
>
> **F-PDC39-01 (HIGH)** — verification-architecture.md §P0 VP-2.11.007-A prose block was pre-DC-34 stale (had `transform_applied`, `hook_identity`, unqualified `evaluate_calls_during_run`, ServerTestFixture/SQLite RunStore/terminal-status framing). Fixed in same burst: verification-architecture.md §P0 VP-2.11.007-A block fully rewritten to graph::provenance checkpoint-backed model.
>
> **F-PDC39-02 (HIGH) — ARCHITECTURAL RULING (supersedes DC-36 F-PDC36-01):** The DC-36 ruling that GuardrailJournal "persistence is same site/pattern/channel as evidence_journal, server persists at terminal" was FALSE. Reading BC-2.10.002 {PC-001}/{INV-003}/{PC-005} and §Architecture Anchors in full: EvidenceJournal is checkpoint-backed (pregolya-checkpoint, SQLite), appended in `graph::scheduler` sync-durable BEFORE execution resumes — NO `server::handlers` terminal-state write, NO graph execution result Vec channel. **RULING: GuardrailJournal aligns to the ACTUAL EvidenceJournal model:** (a) Append site: `graph::provenance` (pregolya-graph) — each successful `evaluate()` appends one `GuardrailEntry` to the checkpoint-backed `GuardrailJournal` (pregolya-checkpoint) sync-durable BEFORE execution continues; (b) Storage: pregolya-checkpoint (same SQLite backend as EvidenceJournal); (c) Run-read bridge: `server::run_read_handler` queries `checkpoint_store.get_guardrail_journal(run_id)` at read time for the `guardrail_journal?` None/Some projection (S-1.29 AC-002/AC-003) — this is a server-side read-time assembly, NOT a terminal-state write; (d) BC-2.10.002 DOES NOT need editing (already correct); (e) BC-2.11.007 DOES need PO editing (§Architecture Anchors + {INV-002} + {PC-002} — see exact replacement text in coordinator report). VP body updated: §Property Statement body (Vec language → checkpoint-backed GuardrailJournal), §Proof Harness (result.guardrail_journal Vec → fixture.checkpoint_store.get_guardrail_journal(run_id)), trailing Note paragraph updated.
>
> **F-PDC39-03 (MED)** — §Source Contract {INV-002} bullet had "terminal-status run"/"persistence layer" server framing. Rewritten: "Exactly one GuardrailEntry is appended to the checkpoint-backed journal per successfully-returning evaluate() call, sync-durable before execution continues at that ingress boundary; {EC-003} carve-out; entries in call order — DI-012 completeness invariant for graph-side journal accumulation."
>
> **Downstream corrections required (PO scope — BC-2.11.007):** §Architecture Anchors: remove "server::handlers (pregolya-server): DURABLE RunStore persistence — writes accumulated Vec<GuardrailEntry> to RunStore atomically with terminal state-machine transition, same site and pattern as evidence_journal (BC-2.10.002)"; replace with: "`graph::provenance` (pregolya-graph): GuardrailHook dispatch, GuardrailJournal DURABLE ACCUMULATION — appends one `GuardrailEntry` to the checkpoint-backed `GuardrailJournal` (pregolya-checkpoint, same SQLite backend as BC-2.10.002 EvidenceJournal) sync-durably BEFORE execution continues at each ingress boundary, after each successfully-returning `evaluate()`; pregolya-graph imports the checkpoint abstraction (NOT RunStore; RunStore = pregolya-server; reverse-edge violation)." Remove/correct {PC-002} RunStore terminal-state framing. Fix {INV-002} to remove "persisted to RunStore by the server's terminal-state write (AC-002/AC-003; F-PDC36-01)". **Story-writer scope (S-1.29):** Remove Task 5 "move 'write completed GuardrailJournal to RunStore'..." (that function does not exist); replace with "graph::provenance implements checkpoint-backed GuardrailJournal"; AC-002/AC-003 (run-read projection) should specify server::run_read_handler queries checkpoint_store at read time. **BA scope (entities-server.md):** Add GuardrailJournal persistence path (pregolya-checkpoint) and run-read projection bridge (server::run_read_handler queries by run_id). OBS-2 (IngressBoundary↔BoundaryType mapping): IngressBoundary::RagChunk ↔ BoundaryType::RAGRetrieval; IngressBoundary::MemoryItem ↔ BoundaryType::MemoryIngress; IngressBoundary::ToolResult ↔ BoundaryType::ToolResult.

> **D-356 adversary fix DC-44 (2026-09-09, architect). F-PDC44-01 (MED) — GuardrailJournal 3-state initialization mechanism RULING:** The DC-39 checkpoint-backed model uses `append_guardrail_entry` for each successful `evaluate()` call. Gap: with only `append_guardrail_entry`, both the "no hook registered" case and the "hook registered + zero ingress boundaries reached" case produce zero checkpoint rows — `get_guardrail_journal(run_id)` cannot distinguish them, making `Some([])` unreachable (both return `None`). This makes {INV-004} TV-002/TV-005 unsatisfiable and leaves the `guardrail_journal_completeness_zero_ingress_boundaries` harness test in this VP relying on `.expect()` against a possible `None` return. **RULING: guardrail-specific init op at run start.** `graph::provenance` calls `checkpoint_store.init_guardrail_journal(run_id)` **if and only if** `invocation_context.guardrail_hook().is_some()`, sync-durable, before the first ingress boundary evaluation. This creates an empty journal record and makes `get_guardrail_journal` return `None` (no record = no hook) vs `Some([])` (record exists but empty = hook registered + zero ingress) vs `Some([N])` (record exists with N entries). **Harness compatibility (CORRECTED by DC-55/F-PDC55-01):** The DC-44 claim that "harness tests are already compatible" and "No harness changes needed" was incorrect — a paper-closure (TD-VSDD-059). `get_guardrail_journal` returns `Result<Option<Vec<GuardrailEntry>>, PregolyaError>`; after a single `.expect()` on the `Result` layer, the value is `Option<Vec<GuardrailEntry>>`, not `Vec<GuardrailEntry>`. Calling `.len()` or indexing on `Option<Vec<_>>` does not compile. **The double-unwrap form is required:** both harness functions chain `.expect("hook registered so journal record exists")` on the `Option` layer after the `Result`-level `.expect()`. This Option-unwrap is safe because the init-op guarantees `Some(...)` when a hook is registered. Applied in v1.14 (DC-55). The `None` case ({INV-004}/{EC-004}) is a server-side concern tested in `crates/pregolya-server/tests/` (S-1.29 AC-003) — correctly outside this VP's scope. **Downstream wording for PO/BA/story-writer:** See ADR-031 §Decision 8 for exact replacement wording. Summary: PO — add `init_guardrail_journal(run_id)` call site to BC-2.11.007 §Architecture Anchors, {PC-002}, {INV-004}, {PRE-001}; BA — add journal record creation mechanism to entities-server.md §GuardrailJournal; story-writer — add initialization task to S-1.29 before journal-accumulation task. **BC-2.10.002 DOES NOT need editing.** No human authorization required (resolves realizability gap within already-authorized {INV-004}).
