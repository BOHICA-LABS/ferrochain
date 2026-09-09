---
document_type: story
level: ops
story_id: S-1.29
epic_id: E-11
version: "1.9"
status: draft
producer: story-writer
timestamp: 2026-09-08T00:00:00Z
changelog:
  - "1.0 (D-356/DC-34/2026-09-08, story-writer): Initial story — GuardrailJournal persistence (BC-2.11.007); Wave-1 companion to S-1.19 per DC-34 architect ruling. PO must set BC-2.11.007 §Story Anchor to S-1.29."
  - "1.1 (D-356/DC-35/2026-09-08, story-writer): F-PDC35-01 — EC-001 corrected: no-hook ⇒ guardrail_journal? None (not Some([])) per BC-2.11.007 INV-004/EC-004/TV-002; AC-003 conditioned on hook-registered; test for no-hook case added. F-PDC35-03 — VP-2.11.007-A added to verification_properties (S-1.29 is anchor story); test file renamed guardrail_journal.rs → guardrail_journal_completeness.rs (canonical VP harness path). F-PDC35-05 — BC-2.11.007 title corrected to canonical H1 in body BC table."
  - "1.2 (D-356/DC-36/2026-09-08, story-writer): F-PDC36-01 — terminal GuardrailJournal persistence relocated from pregolya-graph to pregolya-server (architect ruling: pregolya-graph MUST NOT import RunStore — forbidden reverse edge). Architecture Mapping, Purity Classification, Forbidden Dependencies, File Structure, Task 5, and Token Budget updated. In-flight append stays pregolya-graph/src/provenance.rs; terminal write moves to server::handlers (same site as evidence_journal persistence)."
  - "1.3 (D-356/DC-37/2026-09-08, story-writer): F-PDC37-01 — §Previous Story Intelligence S-1.19 panic-gotcha corrected: caught evaluate() panic ⇒ Err(E-CORE-007) fail-closed, NO GuardrailEntry appended (per BC-2.11.007 {EC-003} / S-1.19 AC-025); tdd_mode note, AC-001, and EC-006 updated accordingly. F-PDC37-03 — §File Structure split into two test files: graph-side guardrail_journal_completeness.rs (AC-001, VP-2.11.007-A) and server-side guardrail_journal_server_integration.rs (AC-002 + AC-003); §Tasks, §Token Budget, AC test-file references updated."
  - "1.4 (D-356/DC-38/2026-09-08, story-writer): F-PDC38-03 — AC-004 reworded: 'count of GuardrailHook::evaluate() calls' qualified to 'SUCCESSFULLY-RETURNING evaluate() calls; panicking/erroring appends no entry per BC-2.11.007 {EC-003}/{INV-002}'; test renamed test_BC_2_11_007_journal_entry_count_equals_successful_evaluate_calls(); file reference added (graph-side); sweep found no other unqualified phrasings."
  - "1.5 (D-356/DC-39/2026-09-09, story-writer): F-PDC39-01 — Persistence model corrected to checkpoint-backed per architect re-adjudication: DC-36 model ('terminal RunStore write in pregolya-server, same function as evidence_journal') was FALSE — that function does not exist. Correct model: graph::provenance appends each GuardrailEntry sync-durably to pregolya-checkpoint SQLite (same backend as EvidenceJournal) BEFORE execution continues; no in-flight Vec; no terminal flush; server::run_read_handler queries checkpoint_store.get_guardrail_journal(run_id) at read time. Affected: Narrative, AC-002, AC-003, Architecture Mapping, Purity Classification, PSI S-1.26 gotcha, Forbidden Dependencies, File Structure, Task 4, Task 5, Task 6, Token Budget. DC-36 and DC-37 delta notes annotated [SUPERSEDED by DC-39 re: persistence model]."
  - "1.6 (D-356/DC-44/2026-09-09, story-writer): F-PDC44-01 — journal-init mechanism added per architect ruling: graph::provenance implements init_guardrail_journal(run_id) called at run start iff invocation_context.guardrail_hook().is_some(), writing an empty checkpoint record sync-durably before first ingress; enables 3-state discriminator (None=no hook/Some([])/Some([N])). AC-003 updated with init mechanism; Architecture Mapping (provenance.rs + checkpoint rows), File Structure (provenance.rs + graph-side test descriptions), Token Budget, and Task list updated (new Task 4 init; existing Tasks 4-9 renumbered to Tasks 5-10)."
  - "1.7 (D-356/DC-45/2026-09-09, story-writer): F-PDC45-01 — §File Structure graph-side test row corrected: removed false 'asserts None/all 3 states' claim; scoped to VP-2.11.007-A 2-function harness (Some([]) hook+zero-ingress via guardrail_journal_completeness_zero_ingress_boundaries + Some([N]) hook+N-evaluations via guardrail_journal_completeness_all_variants). None (no-hook) case confirmed server-side in pregolya-server test row via test_BC_2_11_007_run_read_projection_no_hook_none(). Task sweep: no echo of graph-side-asserts-None found. Token Budget: no change."
  - "1.8 (D-356/DC-46/2026-09-09, story-writer): F-PDC46-01 — AC header citation form corrected to M4-strict bare-tag: BC-S.SS.NNN TAG (section-words postcondition/invariant removed from all 5 AC trace headers per verify-ac-pc-trace.sh CHECK-1)."
  - "1.9 (D-356/DC-48/2026-09-09, story-writer): F-PDC48-03 — Task 5 Arc<dyn CheckpointStore> replaced with Arc<dyn CheckpointSaver> (CheckpointStore is phantom; CheckpointSaver is the canonical checkpoint trait in pregolya-checkpoint::checkpoint::saver). F-PDC48-02 — server::run_read_handler replaced with server::handlers in DC-39 delta note and AC-003 (2 live-body hits; changelog entry v1.5 is immutable historical record). F-PDC48-01 not applicable (no evidence_journal assembly in S-1.29). Corpus-sweep: 1 CheckpointStore hit fixed, 2 backtick-server::run_read_handler hits fixed, 0 get_evidence_journal hits."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-11/BC-2.11.007.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "6412b78"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-1.19, S-1.26]
blocks: [S-console-10]
behavioral_contracts: [BC-2.11.007]
verification_properties: [VP-2.11.007-A]
priority: P0
cycle: v1.0.0-greenfield
wave: 1
target_module: pregolya-graph
subsystems: [SS-11]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

> **tdd_mode:** strict — full TDD Iron Law enforced. Journal completeness is the critical invariant: every SUCCESSFUL GuardrailHook::evaluate() call must produce exactly one GuardrailEntry. A caught panic propagates Err(E-CORE-007) fail-closed — NO entry appended (BC-2.11.007 {EC-003}).

# S-1.29: GuardrailJournal Persistence

> **D-356/DC-34 (2026-09-08, story-writer).** Wave-1 companion story to S-1.19, created per architect ruling DC-34. BC-2.11.007 (GuardrailJournal persistence) previously had an `S-TBD` story anchor. This story closes that gap. S-console-10 (Wave-3 guardrail panel) depends on this story for the `guardrail_journal?` field on run-read.

> **D-356/DC-35 (2026-09-08, story-writer).** F-PDC35-01 — EC-001 corrected: no GuardrailHook registered ⇒ `guardrail_journal?` = None (null/omitted) on run-read — NOT `Some([])`. Distinct: hook registered + zero ingress = `Some([])` (EC-002); hook registered + N ingress = `Some([entries])`. "No hook" = None per BC-2.11.007 INV-004/EC-004/TV-002. AC-003 updated to condition the non-None result on hook-registered. F-PDC35-03 — VP-2.11.007-A added (S-1.29 is the anchor story; test vehicle at canonical path). Test file renamed `guardrail_journal.rs` → `guardrail_journal_completeness.rs` to match VP harness path. F-PDC35-05 — BC table title corrected to canonical H1 "Guardrail Evaluation Results Are Durably Journaled".

> **D-356/DC-36 (2026-09-08, story-writer). [SUPERSEDED by DC-39 re: persistence model — the terminal-write-to-pregolya-server model and evidence_journal analogy are FALSE; see DC-39 note below]** F-PDC36-01 architect ruling — terminal GuardrailJournal persistence relocated from `pregolya-graph` to `pregolya-server`. Rationale: `pregolya-graph` MUST NOT import `RunStore` from `pregolya-server` — forbidden reverse edge. Model at time of writing: graph accumulates in-flight, server persists atomically at terminal transition, same function as evidence_journal persistence. Affected locations: Architecture Mapping, Purity Classification, Forbidden Dependencies, File Structure, Task 5, Token Budget.

> **D-356/DC-38 (2026-09-08, story-writer).** F-PDC38-03 — AC-004 unqualified completeness count corrected: "count of evaluate() calls" → "count of SUCCESSFULLY-RETURNING evaluate() calls; panicking/erroring appends no entry per BC-2.11.007 {EC-003}/{INV-002}". Test renamed to `test_BC_2_11_007_journal_entry_count_equals_successful_evaluate_calls()` with graph-side file reference added. Sweep: no other unqualified "entries == evaluate calls" phrasing found.

> **D-356/DC-37 (2026-09-08, story-writer). [SUPERSEDED by DC-39 re: persistence model — "same function as evidence_journal persistence" and "in-flight Vec accumulation in run_executor.rs" are FALSE; see DC-39 note below; dependency-direction rationale and test-file split remain valid]** F-PDC37-01 — §Previous Story Intelligence S-1.19 panic-gotcha corrected: a caught `evaluate()` panic causes `Err(E-CORE-007)` to propagate fail-closed; NO `GuardrailEntry` is appended because no `GuardrailResult` exists. Affected: §Previous Story Intelligence S-1.19 gotcha, tdd_mode preamble, AC-001, EC-006 added. F-PDC37-03 — §File Structure split into two test files: graph-side `guardrail_journal_completeness.rs` (AC-001 / VP-2.11.007-A; NO pregolya-server dependency) and server-side `guardrail_journal_server_integration.rs` (AC-002 + AC-003). Rationale: `pregolya-graph` MUST NOT import `RunStore` from `pregolya-server` — forbidden reverse edge.

> **D-356/DC-39 (2026-09-09, story-writer).** F-PDC39-01 architect re-adjudication — the DC-36 model ("terminal RunStore write in pregolya-server, same function as evidence_journal persistence") was FALSE — that function does not exist. Correct persistence model: `graph::provenance` implements checkpoint-backed `GuardrailJournal` via `pregolya-checkpoint` (same SQLite backend as EvidenceJournal); each successfully-returning `evaluate()` appends one `GuardrailEntry` sync-durably BEFORE execution continues. No in-flight Vec accumulation; no terminal flush. `server::handlers` queries `checkpoint_store.get_guardrail_journal(run_id)` at read time to assemble `guardrail_journal?`. DC-36 and DC-37 notes annotated with supersession markers. Affected: Narrative, AC-002, AC-003, §Architecture Mapping, §Purity Classification, §Previous Story Intelligence S-1.26 gotcha, §Forbidden Dependencies, §File Structure, Task 4, Task 5, Task 6, Token Budget.

> **D-356/DC-44 (2026-09-09, story-writer).** F-PDC44-01 architect ruling — journal-init mechanism: `graph::provenance` implements `init_guardrail_journal(run_id)` — called at run start iff `invocation_context.guardrail_hook().is_some()`; writes an empty journal record to the checkpoint store (sync-durable, before the first ingress boundary). Distinct from `append_guardrail_entry` (per successfully-returning evaluate()). Enables 3-state run-read discriminator: no journal record ⇒ None (no hook registered); empty record ⇒ Some([]) (hook registered, zero ingress); N entries ⇒ Some([N]) (hook + N successful evaluations). Affected: AC-003, §Architecture Mapping, §File Structure, Token Budget, Task list (new Task 4; existing Tasks 4-9 renumbered to Tasks 5-10).

> **D-356/DC-45 (2026-09-09, story-writer).** F-PDC45-01 — §File Structure graph-side test row corrected per VP-2.11.007-A source-of-truth: the graph-side VP harness has exactly two functions — `guardrail_journal_completeness_all_variants` (asserts Some([N])) and `guardrail_journal_completeness_zero_ingress_boundaries` (asserts Some([])). The `None` (no-hook) case is scoped OUT of the graph-side VP and is asserted server-side via `test_BC_2_11_007_run_read_projection_no_hook_none()` per AC-003. "asserts all 3 states None/Some([])/Some([N])" claim removed from graph-side row; server-side row confirmed to cover None explicitly. Task sweep: no echo of graph-side-asserts-None found. Token Budget: no change.

## Narrative

- **As a** graph runtime developer building the pregolya-graph guardrail system
- **I want to** persist a durable journal of every `GuardrailHook::evaluate()` result — each successfully-returning call appends one `GuardrailEntry` sync-durably to `pregolya-checkpoint` SQLite before execution continues — and expose it as `guardrail_journal?` on the run-read endpoint
- **So that** developer-operators and SOC analysts can reconstruct the complete guardrail decision history for any completed run without relying on transient SSE stream events

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.11.007 | Guardrail Evaluation Results Are Durably Journaled | AC-001..AC-005 |

## Acceptance Criteria

### AC-001 (traces to BC-2.11.007 PC-001 — append on every evaluate())
After each `GuardrailHook::evaluate(content, provenance_tag)` call in `pregolya-graph/src/provenance.rs` that RETURNS SUCCESSFULLY, a `GuardrailEntry` is appended to the run's journal. The entry carries: `boundary` (IngressBoundary — the boundary label from `provenance_tag`), `result` (the `GuardrailResult` returned: Pass, Fail, or Transform — for Transform, new content is in `result.Transform.new_content`), `provenance` (the full `ProvenanceTag`), and `timestamp_ms` (wall-clock milliseconds at append time). The append occurs for Pass, Fail, and Transform — but NOT for a caught panic: a caught panic propagates `Err(E-CORE-007)` fail-closed and no `GuardrailEntry` is appended (BC-2.11.007 {EC-003}). Verified by `test_BC_2_11_007_append_on_every_evaluate_call()` in `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` (VP-2.11.007-A; graph-side).

### AC-002 (traces to BC-2.11.007 PC-002 — checkpoint-backed sync-durable persistence per evaluate())
Each successfully-returning `GuardrailHook::evaluate()` call in `graph::provenance` appends one `GuardrailEntry` sync-durably to `pregolya-checkpoint` SQLite (same backend as EvidenceJournal) BEFORE execution continues. There is no terminal flush and no in-flight Vec — every entry is durable the moment evaluate() returns successfully. After any number of evaluate() calls, all entries are retrievable by run ID from the checkpoint store. Verified by `test_BC_2_11_007_checkpoint_persistence_per_evaluate()` in `crates/pregolya-server/tests/guardrail_journal_server_integration.rs` (server-side; fixture queries checkpoint store).

### AC-003 (traces to BC-2.11.007 PC-003 — run-read guardrail_journal? projection)
The run-read endpoint (`GET /threads/{thread_id}/runs/{run_id}`) exposes the journal as `guardrail_journal?` in the response body. `server::handlers` assembles the field by calling `checkpoint_store.get_guardrail_journal(run_id)` at read time. The 3-state discriminator works via journal-record initialization: `init_guardrail_journal(run_id)` is called at run start iff `invocation_context.guardrail_hook().is_some()`, creating an empty checkpoint record before the first ingress; `append_guardrail_entry` adds one entry per successfully-returning evaluate(). Conditions: (a) For in-progress runs: the field is absent (`None`), regardless of hook registration. (b) For terminal-status runs where a hook was registered: the checkpoint store contains a journal record (created by init_guardrail_journal) — `Some([])` when registered but no ingress occurred (init record, zero appends); `Some([entries])` when N ingress events were evaluated (init record + N appends). (c) For terminal-status runs where NO hook was registered: no journal record exists in the checkpoint store → the field is absent (`None`) — per BC-2.11.007 INV-004. No hook registered is semantically distinct from hook registered with zero evaluations. Verified by `test_BC_2_11_007_run_read_projection_terminal()`, `test_BC_2_11_007_run_read_projection_in_progress_absent()`, and `test_BC_2_11_007_run_read_projection_no_hook_none()` in `crates/pregolya-server/tests/guardrail_journal_server_integration.rs` (server-side).

### AC-004 (traces to BC-2.11.007 INV-002 — completeness DI-012)
The count of `GuardrailEntry` records in the journal equals the count of SUCCESSFULLY-RETURNING `GuardrailHook::evaluate()` calls made during the run — no successful calls are silently omitted. A panicking/erroring evaluate() (EC-006) appends no entry and does NOT increment the count per BC-2.11.007 {EC-003}/{INV-002}. For a run with N successful evaluate calls, the journal contains exactly N entries. Verified by `test_BC_2_11_007_journal_entry_count_equals_successful_evaluate_calls()` in `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` (graph-side).

### AC-005 (traces to BC-2.11.007 INV-003 — separation from evidence_journal)
The `guardrail_journal` field contains only `GuardrailEntry` records (boundary + GuardrailResult). It does NOT contain `PolicyDecision` (Allow/Escalate/Deny) records — those belong exclusively to `evidence_journal`. No budget-policy record appears in `guardrail_journal`; no guardrail-hook record appears in `evidence_journal`. The two journals are always kept separate in storage and on the wire. Verified by `test_BC_2_11_007_separation_from_evidence_journal()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| GuardrailEntry type + GuardrailJournal alias | `pregolya-core/src/guardrail.rs` | Pure (data types) |
| Journal init at run start + sync-durable append per evaluate() | `pregolya-graph/src/provenance.rs` | Effectful (init_guardrail_journal at run start iff hook registered; append_guardrail_entry per successfully-returning evaluate()) |
| Durable storage backend | `pregolya-checkpoint` SQLite (same backend as EvidenceJournal) | Effectful (SQLite init + per-call append; no in-flight Vec; no terminal flush) |
| run-read response projection | `pregolya-server/src/routes/runs.rs` | Effectful (queries checkpoint_store.get_guardrail_journal(run_id) at read time; serializes) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `pregolya-core/src/guardrail.rs` additions | pure-core | Data type definitions only per ADR-014 Decision 6 |
| `pregolya-graph/src/provenance.rs` journal append | effectful-shell | Sync-durable checkpoint write per evaluate() call; BEFORE execution continues; no in-flight Vec |
| `pregolya-checkpoint` SQLite write | effectful-shell | Durable persistence layer; same backend as EvidenceJournal |
| `pregolya-server/src/routes/runs.rs` projection | effectful-shell | Queries checkpoint_store.get_guardrail_journal(run_id) and serializes response |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | No GuardrailHook registered — run completes | `guardrail_journal?` = None (absent/null) on run-read — NOT `Some([])`; no journal field in response. Distinct from EC-002 (hook registered, zero ingress). Per BC-2.11.007 INV-004/EC-004/TV-002 |
| EC-002 | Hook registered; run cancelled before any evaluate() call (zero ingress) | `guardrail_journal?` = `Some([])` — hook WAS registered, zero ingress events occurred; empty journal at cancellation; no omission |
| EC-003 | 50 evaluate() calls in one run (Domain A SOC scenario) | All 50 entries in journal; run-read returns all 50 |
| EC-004 | evidence_journal entries present | Separation invariant: guardrail_journal contains zero PolicyDecision records; evidence_journal contains zero GuardrailEntry records |
| EC-005 | Transform result | GuardrailEntry carries result=Transform with new_content accessible via result.Transform.new_content; no separate transform_applied field |
| EC-006 | GuardrailHook::evaluate() panics (caught by catch_unwind) | Err(E-CORE-007) propagated fail-closed per S-1.19 AC-025; NO GuardrailEntry appended (no GuardrailResult exists); journal count is NOT incremented; per BC-2.11.007 {EC-003} |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,000 |
| BC-2.11.007.md (~100 lines) | ~1,500 |
| S-1.19 context (GuardrailHook trait, GuardrailResult types, provenance.rs patterns) | ~2,000 |
| S-1.26 context (RunStore trait, run-read route, Run model) | ~2,000 |
| `pregolya-core/src/guardrail.rs` additions (~30 lines) | ~400 |
| `pregolya-graph/src/provenance.rs` journal-init + journal-append + checkpoint-write additions (~70 lines) | ~875 |
| `pregolya-checkpoint` checkpoint store interface context (~40 lines) | ~500 |
| `pregolya-server/src/routes/runs.rs` projection additions (~30 lines) | ~400 |
| Test files — graph-side guardrail_journal_completeness.rs (~60 lines) | ~800 |
| Test files — server-side guardrail_journal_server_integration.rs (~80 lines) | ~1,000 |
| Tool outputs | ~300 |
| **Total** | **~11,775** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~6%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs (test-writer): (a) graph-side tests in `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` for AC-001 (append on successful evaluate; VP-2.11.007-A vehicle; NO pregolya-server dependency); (b) server-side tests in `crates/pregolya-server/tests/guardrail_journal_server_integration.rs` for AC-002 (checkpoint persistence per evaluate()) and AC-003 (run-read None/Some projection)
2. [ ] Add `GuardrailEntry` struct and `GuardrailJournal = Vec<GuardrailEntry>` type alias to `pregolya-core/src/guardrail.rs`. Fields: `boundary: IngressBoundary`, `result: GuardrailResult`, `provenance: ProvenanceTag`, `timestamp_ms: u64`. No `transform_applied` field — Transform content is in `result.Transform.new_content`
3. [ ] Modify `pregolya-graph/src/provenance.rs` dispatch site: after each `GuardrailHook::evaluate()` call that returns successfully, construct the `GuardrailEntry` and call `checkpoint_store.append_guardrail_entry(run_id, &entry)` sync-durably BEFORE execution continues. No in-flight Vec needed — each entry is immediately durable in `pregolya-checkpoint` SQLite (AC-001 / AC-002 / BC-2.11.007 PC-001/PC-002).
4. [ ] `graph::provenance` implements `init_guardrail_journal(run_id)` — called at run start if `invocation_context.guardrail_hook().is_some()`; writes an empty journal record to the checkpoint store (sync-durable, before the first ingress boundary). Distinct from `append_guardrail_entry` (per successfully-returning evaluate()). Enables 3-state discriminator: no journal record ⇒ None; empty record ⇒ Some([]); N entries ⇒ Some([N]) (AC-003 / BC-2.11.007 PC-003).
5. [ ] Wire `Arc<dyn CheckpointSaver>` into `graph::provenance` at the evaluate() dispatch call site (same `pregolya-checkpoint` backend as EvidenceJournal). Verify: `pregolya-graph` imports `pregolya-checkpoint`, NOT `pregolya-server` — correct downward dependency.
6. [ ] `graph::provenance` implements checkpoint-backed `GuardrailJournal` via `pregolya-checkpoint` (same SQLite backend as EvidenceJournal); each successfully-returning `evaluate()` appends one `GuardrailEntry` sync-durably BEFORE execution continues.
7. [ ] Add `guardrail_journal: Option<GuardrailJournal>` to the `Run` response model; populate from `checkpoint_store.get_guardrail_journal(run_id)` for terminal-status runs; absent for in-progress runs (AC-003 / BC-2.11.007 PC-003). This modifies `pregolya-server/src/routes/runs.rs` run-read handler.
8. [ ] Implement separation assertion: add test that a run using BOTH budget policy and guardrail hook produces entries exclusively in their respective journals with no cross-contamination (AC-005 / BC-2.11.007 INV-003)
9. [ ] Export `GuardrailEntry` and `GuardrailJournal` from `pregolya-core/src/lib.rs`
10. [ ] Run `cargo nextest run -p pregolya-core -p pregolya-graph --no-fail-fast` — graph-side tests (AC-001) green; then `cargo nextest run -p pregolya-server --no-fail-fast` — server-side tests (AC-002/AC-003) green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| S-1.19 | `GuardrailHook::evaluate()` dispatch in `provenance.rs` with `FutureExt::catch_unwind(AssertUnwindSafe(...))` fail-closed pattern | `GuardrailResult` variants (Pass, Fail, Transform), `ProvenanceTag` structure, `IngressBoundary` enum | A caught `evaluate()` panic causes `catch_unwind` to catch it; `Err(E-CORE-007)` is propagated fail-closed. NO `GuardrailEntry` is appended — there is no `GuardrailResult` to journal (BC-2.11.007 {EC-003} / S-1.19 AC-025). The journal entry count equals the count of SUCCESSFUL evaluate() calls only. |
| S-1.26 | `RunStore` trait in `pregolya-server::store::run`; run lifecycle state machine; run-read route in `pregolya-server/src/routes/runs.rs` | Route handlers use `Arc<dyn RunStore>`; run response model shape | GuardrailJournal uses checkpoint-backed persistence (each evaluate() call appends sync-durably via `pregolya-checkpoint`); there is no terminal flush to RunStore — the journal is read from `checkpoint_store` at run-read time. S-1.26 RunStore infrastructure is NOT on the GuardrailJournal write path. |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| GuardrailEntry defined in `pregolya-core` — no execution logic | ADR-014 Decision 6 | Import path check: `pregolya-graph` imports from `pregolya-core::guardrail` |
| Journal append occurs AFTER evaluate() returns — not before | BC-2.11.007 PC-001 | Code review: append is the last act at the evaluate call site, after the result is captured |
| Each evaluate() append is sync-durable to pregolya-checkpoint before execution continues | BC-2.11.007 PC-002 | Integration test: crash-restart scenario; verify no missing entries |
| guardrail_journal absent for in-progress runs on run-read | BC-2.11.007 PC-003 | Test: query in-progress run; assert guardrail_journal field is absent |
| No PolicyDecision record in guardrail_journal | BC-2.11.007 INV-003 | Test: mixed run; grep journal for PolicyDecision type; assert zero |
| No transform_applied field on GuardrailEntry | BC-2.11.007 INV-003 (type safety) | Compile-gate: struct definition has no transform_applied field; Transform content via result.Transform.new_content |

**Forbidden Dependencies:** `pregolya-core/src/guardrail.rs` additions must NOT import from `pregolya-graph` or `pregolya-server`. `pregolya-graph` must NOT import `RunStore` or any type from `pregolya-server` — this is a forbidden reverse edge. GuardrailJournal uses `pregolya-checkpoint` SQLite accessed via `graph::provenance`; `pregolya-graph` imports `pregolya-checkpoint`, not `pregolya-server`. Dependency direction: `pregolya-server` → `pregolya-graph` → `pregolya-core`; `pregolya-graph` → `pregolya-checkpoint`; any `pregolya-graph → pregolya-server` import is a build-time cycle and must cause CI failure.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| All dependencies inherited from S-1.19 | As pinned in workspace | GuardrailHook, GuardrailResult, ProvenanceTag, IngressBoundary types |
| `serde` | workspace-pinned | GuardrailEntry serialization for run-read response |
| `pregolya-checkpoint` | workspace-pinned | Sync-durable SQLite checkpoint backend for GuardrailJournal entries |
| `tokio` | workspace-pinned | Async run execution context |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-core/src/guardrail.rs` | MODIFY | Add `GuardrailEntry` struct and `GuardrailJournal` type alias |
| `crates/pregolya-core/src/lib.rs` | MODIFY | Re-export `GuardrailEntry` and `GuardrailJournal` |
| `crates/pregolya-graph/src/provenance.rs` | MODIFY | Add init_guardrail_journal (run-start, iff hook registered) and sync-durable append_guardrail_entry per evaluate() dispatch site (AC-001/AC-002/AC-003 / BC-2.11.007 PC-001/PC-002/PC-003); no in-flight Vec; no RunStore import |
| `crates/pregolya-server/src/routes/runs.rs` | MODIFY | Add `guardrail_journal?` to run-read response; query via `checkpoint_store.get_guardrail_journal(run_id)` for terminal-status runs (AC-003) |
| `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` | CREATE | AC-001 completeness/append tests — VP-2.11.007-A 2-function harness (graph-side): `guardrail_journal_completeness_zero_ingress_boundaries` asserts Some([]) (hook + zero ingress via init_guardrail_journal); `guardrail_journal_completeness_all_variants` asserts Some([N]) (hook + N successfully-returning evaluate()); NO None (no-hook) assertion here — that is server-side per AC-003; NO pregolya-server dependency |
| `crates/pregolya-server/tests/guardrail_journal_server_integration.rs` | CREATE | AC-002 checkpoint persistence per evaluate() + AC-003 run-read projection tests: None (no-hook, `test_BC_2_11_007_run_read_projection_no_hook_none()`), Some([]) (in-progress absent, `test_BC_2_11_007_run_read_projection_in_progress_absent()`), Some([N]) (`test_BC_2_11_007_run_read_projection_terminal()`) (server-side; queries checkpoint_store.get_guardrail_journal(run_id) via HTTP) |
