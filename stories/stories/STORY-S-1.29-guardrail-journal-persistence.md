---
document_type: story
level: ops
story_id: S-1.29
epic_id: E-11
version: "1.2"
status: draft
producer: story-writer
timestamp: 2026-09-08T00:00:00Z
changelog:
  - "1.0 (D-356/DC-34/2026-09-08, story-writer): Initial story — GuardrailJournal persistence (BC-2.11.007); Wave-1 companion to S-1.19 per DC-34 architect ruling. PO must set BC-2.11.007 §Story Anchor to S-1.29."
  - "1.1 (D-356/DC-35/2026-09-08, story-writer): F-PDC35-01 — EC-001 corrected: no-hook ⇒ guardrail_journal? None (not Some([])) per BC-2.11.007 INV-004/EC-004/TV-002; AC-003 conditioned on hook-registered; test for no-hook case added. F-PDC35-03 — VP-2.11.007-A added to verification_properties (S-1.29 is anchor story); test file renamed guardrail_journal.rs → guardrail_journal_completeness.rs (canonical VP harness path). F-PDC35-05 — BC-2.11.007 title corrected to canonical H1 in body BC table."
  - "1.2 (D-356/DC-36/2026-09-08, story-writer): F-PDC36-01 — terminal GuardrailJournal persistence relocated from pregolya-graph to pregolya-server (architect ruling: pregolya-graph MUST NOT import RunStore — forbidden reverse edge). Architecture Mapping, Purity Classification, Forbidden Dependencies, File Structure, Task 5, and Token Budget updated. In-flight append stays pregolya-graph/src/provenance.rs; terminal write moves to server::handlers (same site as evidence_journal persistence)."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-11/BC-2.11.007.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "78a15a6"
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

> **tdd_mode:** strict — full TDD Iron Law enforced. Journal completeness is the critical invariant: every GuardrailHook::evaluate() call must produce exactly one GuardrailEntry.

# S-1.29: GuardrailJournal Persistence

> **D-356/DC-34 (2026-09-08, story-writer).** Wave-1 companion story to S-1.19, created per architect ruling DC-34. BC-2.11.007 (GuardrailJournal persistence) previously had an `S-TBD` story anchor. This story closes that gap. S-console-10 (Wave-3 guardrail panel) depends on this story for the `guardrail_journal?` field on run-read.

> **D-356/DC-35 (2026-09-08, story-writer).** F-PDC35-01 — EC-001 corrected: no GuardrailHook registered ⇒ `guardrail_journal?` = None (null/omitted) on run-read — NOT `Some([])`. Distinct: hook registered + zero ingress = `Some([])` (EC-002); hook registered + N ingress = `Some([entries])`. "No hook" = None per BC-2.11.007 INV-004/EC-004/TV-002. AC-003 updated to condition the non-None result on hook-registered. F-PDC35-03 — VP-2.11.007-A added (S-1.29 is the anchor story; test vehicle at canonical path). Test file renamed `guardrail_journal.rs` → `guardrail_journal_completeness.rs` to match VP harness path. F-PDC35-05 — BC table title corrected to canonical H1 "Guardrail Evaluation Results Are Durably Journaled".

> **D-356/DC-36 (2026-09-08, story-writer).** F-PDC36-01 architect ruling — terminal GuardrailJournal persistence relocated from `pregolya-graph` to `pregolya-server`. Rationale: `pregolya-graph` MUST NOT import `RunStore` from `pregolya-server` — that is a forbidden reverse edge (`pregolya-server → pregolya-graph` is the correct direction; a `pregolya-graph → pregolya-server` import would create a cycle). Model: identical to how `evidence_journal` is split — graph accumulates in-flight, server persists atomically at terminal transition. In-flight append stays `pregolya-graph/src/provenance.rs` (unchanged). Terminal write moves to `pregolya-server/src/handlers/` (run-state-machine terminal-state write site, same function as evidence_journal persistence). Affected locations: Architecture Mapping §Terminal row, Purity Classification, Forbidden Dependencies, File Structure, Task 5, Token Budget.

## Narrative

- **As a** graph runtime developer building the pregolya-graph guardrail system
- **I want to** persist a durable journal of every `GuardrailHook::evaluate()` result — appended in-flight per call and stored in the RunStore at terminal state — and expose it as `guardrail_journal?` on the run-read endpoint
- **So that** developer-operators and SOC analysts can reconstruct the complete guardrail decision history for any completed run without relying on transient SSE stream events

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.11.007 | Guardrail Evaluation Results Are Durably Journaled | AC-001..AC-005 |

## Acceptance Criteria

### AC-001 (traces to BC-2.11.007 postcondition PC-001 — append on every evaluate())
After each `GuardrailHook::evaluate(content, provenance_tag)` call in `pregolya-graph/src/provenance.rs`, a `GuardrailEntry` is appended to the run's in-flight journal. The entry carries: `boundary` (IngressBoundary — the boundary label from `provenance_tag`), `result` (the `GuardrailResult` returned: Pass, Fail, or Transform — for Transform, new content is in `result.Transform.new_content`), `provenance` (the full `ProvenanceTag`), and `timestamp_ms` (wall-clock milliseconds at append time). The append occurs regardless of whether the result is Pass, Fail, or Transform. Verified by `test_BC_2_11_007_append_on_every_evaluate_call()`.

### AC-002 (traces to BC-2.11.007 postcondition PC-002 — RunStore terminal persistence)
When a run transitions to any terminal state (`completed`, `failed`, `cancelled`, `summary_halt`), the in-flight journal is persisted atomically to the `RunStore` as the run's `guardrail_journal` field. After the transition, the journal is retrievable by run ID from the RunStore. Verified by `test_BC_2_11_007_runstore_terminal_persistence()`.

### AC-003 (traces to BC-2.11.007 postcondition PC-003 — run-read guardrail_journal? projection)
The run-read endpoint (`GET /threads/{thread_id}/runs/{run_id}`) exposes the journal as `guardrail_journal?` in the response body under these conditions: (a) For in-progress runs: the field is absent (`None`), regardless of hook registration. (b) For terminal-status runs where a hook was registered: the field contains the complete `Vec<GuardrailEntry>` written at terminal transition — `Some([])` when registered but no ingress occurred; `Some([entries])` when N ingress events were evaluated. (c) For terminal-status runs where NO hook was registered: the field is absent (`None`) — per BC-2.11.007 INV-004. No hook registered is semantically distinct from hook registered with zero evaluations. Verified by `test_BC_2_11_007_run_read_projection_terminal()`, `test_BC_2_11_007_run_read_projection_in_progress_absent()`, and `test_BC_2_11_007_run_read_projection_no_hook_none()`.

### AC-004 (traces to BC-2.11.007 invariant INV-002 — completeness DI-012)
The count of `GuardrailEntry` records in the persisted journal equals the count of `GuardrailHook::evaluate()` calls made during the run — no calls are silently omitted. For a run with N evaluate calls, the terminal journal contains exactly N entries. Verified by `test_BC_2_11_007_journal_entry_count_equals_evaluate_calls()`.

### AC-005 (traces to BC-2.11.007 invariant INV-003 — separation from evidence_journal)
The `guardrail_journal` field contains only `GuardrailEntry` records (boundary + GuardrailResult). It does NOT contain `PolicyDecision` (Allow/Escalate/Deny) records — those belong exclusively to `evidence_journal`. No budget-policy record appears in `guardrail_journal`; no guardrail-hook record appears in `evidence_journal`. The two journals are always kept separate in storage and on the wire. Verified by `test_BC_2_11_007_separation_from_evidence_journal()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| GuardrailEntry type + GuardrailJournal alias | `pregolya-core/src/guardrail.rs` | Pure (data types) |
| Journal append at evaluate() dispatch | `pregolya-graph/src/provenance.rs` | Effectful (appends to in-flight journal) |
| Terminal journal persistence | `pregolya-server/src/handlers/` (run-state-machine terminal-state write site) | Effectful (RunStore write; atomic with terminal state write, same function site as evidence_journal persistence) |
| run-read response projection | `pregolya-server/src/routes/runs.rs` | Effectful (reads from RunStore, serializes) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `pregolya-core/src/guardrail.rs` additions | pure-core | Data type definitions only per ADR-014 Decision 6 |
| `pregolya-graph/src/provenance.rs` journal append | effectful-shell | Writes to mutable in-flight journal state |
| `pregolya-graph/src/run_executor.rs` accumulation | effectful-shell | Holds and passes in-flight journal; NO RunStore write |
| `pregolya-server/src/handlers/` terminal write | effectful-shell | Atomic RunStore write at terminal-state transition; same site as evidence_journal |
| `pregolya-server/src/routes/runs.rs` projection | effectful-shell | Reads RunStore and serializes response |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | No GuardrailHook registered — run completes | `guardrail_journal?` = None (absent/null) on run-read — NOT `Some([])`; no journal field in response. Distinct from EC-002 (hook registered, zero ingress). Per BC-2.11.007 INV-004/EC-004/TV-002 |
| EC-002 | Hook registered; run cancelled before any evaluate() call (zero ingress) | `guardrail_journal?` = `Some([])` — hook WAS registered, zero ingress events occurred; empty journal persisted at cancellation; no omission |
| EC-003 | 50 evaluate() calls in one run (Domain A SOC scenario) | All 50 entries in terminal journal; run-read returns all 50 |
| EC-004 | evidence_journal entries present | Separation invariant: guardrail_journal contains zero PolicyDecision records; evidence_journal contains zero GuardrailEntry records |
| EC-005 | Transform result | GuardrailEntry carries result=Transform with new_content accessible via result.Transform.new_content; no separate transform_applied field |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,000 |
| BC-2.11.007.md (~100 lines) | ~1,500 |
| S-1.19 context (GuardrailHook trait, GuardrailResult types, provenance.rs patterns) | ~2,000 |
| S-1.26 context (RunStore trait, run-read route, Run model) | ~2,000 |
| `pregolya-core/src/guardrail.rs` additions (~30 lines) | ~400 |
| `pregolya-graph/src/provenance.rs` journal-append additions (~50 lines) | ~600 |
| `pregolya-graph/src/run_executor.rs` in-flight accumulation additions (~30 lines) | ~400 |
| `pregolya-server/src/handlers/` terminal-persistence additions (~40 lines) | ~500 |
| `pregolya-server/src/routes/runs.rs` projection additions (~30 lines) | ~400 |
| Test files (~120 lines) | ~1,500 |
| Tool outputs | ~300 |
| **Total** | **~12,200** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~6%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs (test-writer; unit + integration tests)
2. [ ] Add `GuardrailEntry` struct and `GuardrailJournal = Vec<GuardrailEntry>` type alias to `pregolya-core/src/guardrail.rs`. Fields: `boundary: IngressBoundary`, `result: GuardrailResult`, `provenance: ProvenanceTag`, `timestamp_ms: u64`. No `transform_applied` field — Transform content is in `result.Transform.new_content`
3. [ ] Modify `pregolya-graph/src/provenance.rs` dispatch site: after each `GuardrailHook::evaluate()` call, append a `GuardrailEntry` to the run's in-flight `GuardrailJournal` (AC-001 / BC-2.11.007 PC-001)
4. [ ] Add `guardrail_journal: GuardrailJournal` in-flight field to the run execution context; initialize empty at run start
5. [ ] At terminal-state transition in `pregolya-server/src/handlers/` (the same function that persists `evidence_journal`): receive the completed `guardrail_journal` from the graph execution context and write it atomically to `RunStore` (AC-002 / BC-2.11.007 PC-002). This is in pregolya-server — NOT in pregolya-graph. pregolya-graph MUST NOT import RunStore.
6. [ ] Add `guardrail_journal: Option<GuardrailJournal>` to the `Run` response model; populate from RunStore for terminal-status runs; absent for in-progress runs (AC-003 / BC-2.11.007 PC-003). This modifies `pregolya-server/src/routes/runs.rs` run-read handler — dependent on S-1.26 RunStore infrastructure
7. [ ] Implement separation assertion: add test that a run using BOTH budget policy and guardrail hook produces entries exclusively in their respective journals with no cross-contamination (AC-005 / BC-2.11.007 INV-003)
8. [ ] Export `GuardrailEntry` and `GuardrailJournal` from `pregolya-core/src/lib.rs`
9. [ ] Run `cargo nextest run -p pregolya-core -p pregolya-graph -p pregolya-server --no-fail-fast` — all tests green

## Previous Story Intelligence (MANDATORY)

| Story | Key Decisions | Patterns Established | Gotchas Discovered |
|-------|--------------|---------------------|-------------------|
| S-1.19 | `GuardrailHook::evaluate()` dispatch in `provenance.rs` with `FutureExt::catch_unwind(AssertUnwindSafe(...))` fail-closed pattern | `GuardrailResult` variants (Pass, Fail, Transform), `ProvenanceTag` structure, `IngressBoundary` enum | Async panic during evaluate() is caught and treated as Fail — the journal append still fires (fail-closed means an entry IS recorded, with result from the catch, not silently dropped) |
| S-1.26 | `RunStore` trait in `pregolya-server::store::run`; run lifecycle state machine; run-read route in `pregolya-server/src/routes/runs.rs` | Route handlers use `Arc<dyn RunStore>`; run response model shape | RunStore write must be atomic with state-machine transition — do NOT persist journal in a separate write after the terminal-state write, as a crash between would leave an inconsistent state |

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| GuardrailEntry defined in `pregolya-core` — no execution logic | ADR-014 Decision 6 | Import path check: `pregolya-graph` imports from `pregolya-core::guardrail` |
| Journal append occurs AFTER evaluate() returns — not before | BC-2.11.007 PC-001 | Code review: append is the last act at the evaluate call site, after the result is captured |
| Terminal persistence is atomic with state-machine transition | BC-2.11.007 PC-002 | Integration test: kill-and-restart scenario; verify no partial journal |
| guardrail_journal absent for in-progress runs on run-read | BC-2.11.007 PC-003 | Test: query in-progress run; assert guardrail_journal field is absent |
| No PolicyDecision record in guardrail_journal | BC-2.11.007 INV-003 | Test: mixed run; grep journal for PolicyDecision type; assert zero |
| No transform_applied field on GuardrailEntry | BC-2.11.007 INV-003 (type safety) | Compile-gate: struct definition has no transform_applied field; Transform content via result.Transform.new_content |

**Forbidden Dependencies:** `pregolya-core/src/guardrail.rs` additions must NOT import from `pregolya-graph` or `pregolya-server`. `pregolya-graph` must NOT import `RunStore` or any type from `pregolya-server` — this is a forbidden reverse edge. Terminal journal persistence is in `pregolya-server` precisely to preserve the correct dependency direction. Dependency direction: `pregolya-server` → `pregolya-graph` → `pregolya-core`; any `pregolya-graph → pregolya-server` import is a build-time cycle and must cause CI failure.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| All dependencies inherited from S-1.19 | As pinned in workspace | GuardrailHook, GuardrailResult, ProvenanceTag, IngressBoundary types |
| `serde` | workspace-pinned | GuardrailEntry serialization for run-read response and RunStore persistence |
| `tokio` | workspace-pinned | Async run execution context |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-core/src/guardrail.rs` | MODIFY | Add `GuardrailEntry` struct and `GuardrailJournal` type alias |
| `crates/pregolya-core/src/lib.rs` | MODIFY | Re-export `GuardrailEntry` and `GuardrailJournal` |
| `crates/pregolya-graph/src/provenance.rs` | MODIFY | Add journal append at each evaluate() dispatch site (AC-001) |
| `crates/pregolya-graph/src/run_executor.rs` | MODIFY | Add in-flight journal accumulation field; pass completed journal to caller at run completion (no RunStore write here — pregolya-graph MUST NOT import RunStore) |
| `crates/pregolya-server/src/handlers/` | MODIFY | Add atomic GuardrailJournal write to RunStore at terminal-state transition (AC-002 / BC-2.11.007 PC-002) — same site as evidence_journal persistence |
| `crates/pregolya-server/src/routes/runs.rs` | MODIFY | Add `guardrail_journal?` to run-read response for terminal-status runs (AC-003) |
| `crates/pregolya-graph/tests/guardrail_journal_completeness.rs` | CREATE | AC-001..AC-005 tests — VP-2.11.007-A test vehicle (canonical harness path) |
