---
document_type: architecture-section
level: L3
section: verification-architecture
version: "2.47"
status: active
producer: architect
timestamp: 2026-09-07T00:00:00Z
phase: 1b
inputs:
  - .factory/specs/domain-spec/invariants.md
  - .factory/specs/prd.md
  - .factory/specs/behavioral-contracts/ss-03/BC-2.03.001.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.006.md
  - .factory/specs/behavioral-contracts/ss-13/BC-2.13.004.md
  - .factory/specs/behavioral-contracts/ss-09/BC-2.09.004.md
  - .factory/specs/behavioral-contracts/ss-09/BC-2.09.005.md
  - .factory/specs/behavioral-contracts/ss-17/BC-2.17.002.md
  - .factory/specs/behavioral-contracts/ss-18/BC-2.18.004.md
  - .factory/specs/behavioral-contracts/ss-19/BC-2.19.001.md
  - .factory/specs/behavioral-contracts/ss-19/BC-2.19.005.md
  - .factory/specs/behavioral-contracts/ss-21/BC-2.21.003.md
  - .factory/specs/behavioral-contracts/ss-22/BC-2.22.001.md
  - .factory/specs/behavioral-contracts/ss-05/BC-2.05.007.md
  - .factory/specs/behavioral-contracts/ss-10/BC-2.10.005.md
  - .factory/specs/behavioral-contracts/ss-23/BC-2.23.005.md
  - .factory/specs/behavioral-contracts/ss-01/BC-2.01.005.md
  - .factory/specs/behavioral-contracts/ss-01/BC-2.01.006.md
  - .factory/specs/behavioral-contracts/ss-09/BC-2.09.008.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.011.md
input-hash: "db1e4d9"
traces_to: ARCH-INDEX.md
decisions: [D17, D21, D23, D356]
changelog:
  - "2.47 (D-356/DC-20/2026-09-08, architect): F-PDC20-01+O-PDC20-A — 5 DI-column re-anchors in VP-to-Module table: VP-2.24.005-A DI-002→DI-004; VP-2.24.005-B DI-002→DI-004; VP-2.24.006-A DI-014→DI-003; VP-2.24.006-B DI-014→DI-003; VP-2.24.008-A DI-014→DI-012. BCs are source of truth (BC-2.24.005/006/008 di_anchors + INV-001/INV-002). Census UNCHANGED: 41 total. input-hash unchanged (inputs did not change)."
  - "2.46 (D-356/DC-19/2026-09-08, architect): F-PDC19-02 — VP-2.24.003-C module repointed server::debug_routes → graph::descriptor (BC-2.24.003 §VP table is source of truth; BC declares VP-2.24.003-C as start-node-always-present targeting graph::descriptor/pregolya-graph). VP-2.24.003-B module already correct (graph::descriptor); no change needed in this mirror (harness_fn not tracked here). Census UNCHANGED: 41 total. input-hash unchanged (inputs did not change)."
  - "2.45 (D-356/DC-08/2026-09-07, state-manager): F-PDC08-03 — DC-02 blockquote annotation corrected: `debug_api_key` → `debug_route_key` (DC-07-rename consistency sweep; records-tier annotation; canonical field per BC-2.12.005 PRE-004/INV-001; ADR-021 §Decision 1). input-hash unchanged (inputs did not change)."
  - "2.44 (D-356/DC-07/2026-09-07, architect): F-PDC07-03 — 10 panel-VP Module cells repointed to canonical SPA component path form: spa/components/run_inspector (VP-2.24.004-A/B), spa/components/checkpoint_panel (VP-2.24.005-A/B), spa/components/hitl_panel (VP-2.24.006-A/B), spa/components/budget_panel (VP-2.24.007-A/B), spa/components/guardrail_panel (VP-2.24.008-A/B). CORRECTION: v2.41 (DC-02) claimed these were SPA panel modules but used console::* Rust module notation — non-canonical for SPA components. Canonical convention: spa/components/<component_name> path form. Census UNCHANGED: 41 total. input-hash unchanged (inputs did not change)."
  - "2.43 (D-356/DC-04/2026-09-07, architect): F-PDC04-04 — VP-2.24.002-A/B module repointed console::span_exporter → console::ring_buffer (console::ring_buffer is now canonical Pure Core for RingBuffer<T> per ADR-031 Decision 5 DC-04 split). VP-2.24.002-C (server::debug_routes) and VP-2.24.002-D (console::span_exporter sanitization) unchanged. Census UNCHANGED: 41 total. input-hash unchanged (inputs did not change)."
  - "2.42 (D-356/DC-02-addendum/2026-09-07, architect): VP-2.24.002-D registered — SpanData SEC-BOUND-001 sanitization before ring-buffer insertion (unit P1; console::span_exporter; BC-2.24.002; DI-014). Sanitization location: AT INSERTION (stricter than BC PC-008 'before serving'; ensures ring buffer never holds unsanitized llm_request/llm_response/attributes; satisfies PC-008 as a postcondition). Census 40→41; unit ×7→×8; P1 34→35. Preamble Forty→Forty-one. input-hash unchanged (inputs did not change)."
  - "2.41 (D-356/DC-02/2026-09-07, architect): F-PDC02-02+F-PDC02-03 — VP-2.24.002-A/B module repointed console::ring_buffer → console::span_exporter (ADR-031 Decision 5 canonical; DC-01 had used non-canonical name; console::span_exporter is the Boundary module hosting RingBuffer<SpanData>, per ADR-031 Decision 5 purity table). VP-2.24.004-008 A/B module columns corrected from console::server to SPA panel modules: console::run_inspector (004-A/B), console::checkpoint_panel (005-A/B), console::hitl_panel (006-A/B), console::budget_panel (007-A/B), console::guardrail_panel (008-A/B), per respective BCs. Tool census UNCHANGED: Kani ×10, proptest ×10, integration ×12, unit ×7, compile-fail ×1 (40 total VPs). input-hash unchanged (inputs did not change)."
  - "2.40 (D-356/DC-01/2026-09-06, architect): F-PDC01-03+F-PDC01-04 — VP-2.24.002-A/B repointed to console::ring_buffer / pregolya-console (RingBuffer<SpanData> Pure Core; ADR-031 Decision 5 + S-console-02). Tool reconciled vs BC Proof Methods for 8 rows: 001-A/B integration/proptest→unit; 001-C integration→compile-fail; 002-B integration→proptest (module/crate also fixed); 003-A proptest→unit; 003-C integration→unit; 007-A integration→unit; 008-B integration→unit. Total line updated: proptest ×10, integration ×12, unit ×7, compile-fail ×1 (40 VPs total unchanged). input-hash unchanged (inputs did not change)."
  - "2.39 (D-356/2026-09-06, architect): F3 — 19 VP-2.24.* placeholder rows added to Provable Properties Catalog for SS-24 Developer Console (BC-2.24.001–008). Tool breakdown: integration ×15, proptest ×3, Kani ×1. All P1, draft, Phase 3 except VP-2.24.003-B (Kani Phase 6). Total 21→40 VPs; P1 15→34; Kani 9→10; proptest 8→11; integration 3→18; unit unchanged at 1. Preamble narrative updated twenty-one→forty. input-hash unchanged (inputs did not change)."
  - "2.38 (round-65/F-P2A237-02/2026-09-01): F-P2A237-02 [MED] §VP-020 narrative corrected to canonical VP-020.md (source-of-truth per CLAUDE.md rule 4): (a) Property description rewritten from apply-twice-idempotency to the actual five-property statement ({INV-001} no-duplicate, {INV-002} reducer-determinism, {PC-002} promote-dedup-idempotent, {PC-004} retire-idempotent, order-sensitivity); (b) {INV-001} gloss corrected from promote-dedup-no-op description ({PC-002}) to 'the active set contains no duplicate entry_id values at any time'; (c) Formal statement replaced from non-canonical apply_ops-twice form with VP-020.md §Formal Invariant five-property form (fold-from-empty, no-duplicate, determinism, promote-dedup, retire-idempotent, order-sensitivity); (d) Op shape corrected from Promote(id)/Retire(id) to PromoteRetireOp::Promote(T) (full entry T) / Retire(String) (entry_id) per VP-020.md §Formal Invariant and ADR-030 §Decision 3. Note for state-manager: pre-existing input-hash drift (stored 8837490 != computed 721a6e7); run compute-input-hash verification-architecture.md --update."
  - "2.37 (round-63/F-P2A235-03+F-P2A235-08/2026-09-01): F-P2A235-03 [MED] §VP-019 stale completed-directive blockquote deleted — replaced with one-line completed note; VP-019.md is at the two-crash-point per-run DELETE model (v1.4); live directive was incorrect. F-P2A235-08 [MED] §VP-020 formal invariants {INV-002} bullet corrected from retire-idempotency gloss to reducer-determinism ({INV-002} is REDUCER DETERMINISM — deterministic output under task-identity ordering; {PC-004} is Retire idempotency; anchor IDs unchanged)."
  - "2.36 (round-62/F-P2A234-05/2026-09-01): VP-020 added — PromoteRetireChannel idempotency proptest P1 (BC-2.02.009 {INV-001}+{INV-002}; graph::channels; pregolya-graph; DI-001; Phase 3; harness promote_retire_channel_idempotency). Structurally analogous to VP-017 LedgerChannel; closes BC-2.02.009 unit-test-only gap. VP-019 §Should Prove description updated from four-crash-point staging-table model to two-crash-point per-run DELETE model (ADR-030 §Compaction Atomicity Decision F-P2A234-01 redesign). Committed VP Obligations table: VP-020 row added; total 20→21 VPs; P1 14→15; proptest 7→8. Preamble narrative updated twenty→twenty-one. input-hash not updated (BC-2.02.009 added as input; formal-verifier to refresh after VP-020 body authored)."
  - "2.35 (round-57/F-P2A228-01/2026-09-01): VP-017 §Provable Properties Catalog formal statement rewritten to canonical pure-fold form — removed stale LedgerChannel::new() constructor (removed per ADR-030 §Decision 3 changelog; banned by S-1.28 Rule 13) and IndexSet oracle (banned by S-1.28 Rule 14); replaced with fold accumulation form and HashSet oracle matching VP-017 body §Formal Invariant verbatim. input-hash not updated (no BC input changes)."
  - "2.34 (round-57/F-P2A227-02/2026-09-01): F-P2A227-02 [HIGH] VP-019 §Property, §Formal statement, and §Why integration rewritten to the four-crash-point staging-table single-atomic-swap model (ADR-030 §Compaction Atomicity Decision). Old three-crash-point model (before_begin/mid_txn/after_sync with uniform pre_records outcome) retired as stale. New crash_point set: {before_build_begins, mid_build, mid_swap, after_swap_commit}. Cases 1–3 yield pre-compaction record set; case 4 (after_swap_commit) yields post-compaction retained_set(pre_records, policy). Formal statement updated with retained_set definition. Why-integration paragraph updated: 'three crash points (TV-002 three-case matrix)' → 'four crash points (TV-002 four-case matrix)'. VP count, module, tool, phase, BC anchor: all unchanged. input-hash updated."
  - "2.33 (round-54/F-P2A224-02/2026-09-01): VP-017 DI anchor corrected DI-014 → DI-001 in §preamble narrative sentence and Provable Properties Catalog VP table row (two sibling sites missed by round-53 D-332 re-anchor). Authoritative value: VP-INDEX + ADR-030 §VP + VP-017 body all carry DI-001. Historical body notes (DI-014 at ADR-030 Stage 1 and round-50) grandfathered per POL-46. input-hash refreshed."
---

# Verification Architecture: pregolya

> **VP-INDEX is the source of truth.** Any count or module assignment here must
> match VP-INDEX.md exactly. Arithmetic: VP total = P0 count + P1 count.

## [Section Content]

This file documents pregolya's verification architecture: the Kani async constraint (0.67.0 has no native async/.await support), the twenty-one committed VP obligations (VP-001–VP-020 + VP-006-B), and the P0/P1 property catalog with proof harness skeleton patterns. VP-001..005 are the original five (three Kani P0 + two integration P1). VP-006..010 are the D21 ecosystem-parity expansion (three Kani P0/P1 + two proptest P1). VP-006-B is the SEC-003 multi-pair few-shot injection mandate (proptest P1 belt-and-suspenders for the VP-006 Arm 2 Kani harness). VP-011..013 are the D23 tools/budget layer (three Kani P0/P1). VP-014 is the burst-302b LCEL composition expansion (one proptest P1; D-170). VP-015 is the architect-reconcile-burst credential-redaction unit P1 (BC-2.09.007 {INV-003}; D-273 fix: tool was incorrectly listed as integration). VP-016 is the GAP-01/ADR-029 GraphAgentTool STATE-ISOLATION proptest P1 (BC-2.09.008 {INV-001}). VP-017 is the ADR-030 LedgerChannel dedup-idempotent append proptest P1 (BC-2.02.007 + BC-2.02.008 {DI-001}; praxist-pattern research orchestrator additive primitive; dual-anchored per first-appearance ordering obligation in BC-2.02.008). VP-018 is the BC-2.04.011 TrajectoryCompactor retention-integrity proptest P1 (BC-2.04.011 {INV-001}; no committed retained record lost or mutated by compaction; durable audit record integrity for the research orchestrator session trajectory; harness reworked round-50 with independent frontier-based oracle and negative mutation test). VP-019 is the BC-2.04.011 trajectory compaction crash-isolation integration P1 (BC-2.04.011 {INV-003}; SQLite BEGIN IMMEDIATE/COMMIT atomicity under SIGKILL; OS-level atomicity guarantee that VP-018 proptest explicitly excludes; Phase 6 integration test). VP-020 is the ADR-030 PromoteRetireChannel idempotency proptest P1 (BC-2.02.009 {INV-001}+{INV-002}; DI-001; structurally analogous to VP-017; closes the BC-2.02.009 unit-test-only coverage gap).

## Kani Async Constraint (Verified Kani 0.67.0)

**Kani 0.67.0 has NO native async/.await support.** Harnesses that call `.await`
on a `Future` will fail at verification time. Consequences:

1. **Harnesses must call `block_on` manually** (or restructure to avoid async entirely):
   the pure sync core is extracted and the async wrapper is excluded from the harness.
2. **Sync-core mandate:** The following modules MUST expose a sync (non-async) pure
   core function that is the Kani verification target:
   - `checkpoint::session_index` (VP-002 target) — sync key derivation logic
   - `checkpoint::clock` — pure `get_next_version(current)` successor function; stateless, no atomic counter
   - `graph::bsp_engine` (VP-001 target) — sync reducer; async orchestration wraps it
   - `graph::hitl` (VP-011 target) — sync `route_pre_tool_decision(decision: PreToolDecision) -> DispatchOutcome` extracted from async `pre_tool_dispatch`; `shield_hook_result(result: Result<PreToolDecision, HookError>) -> PreToolDecision` is the companion sync adapter
   - `core::budget` (VP-012 target) — sync `check_watermark_trigger(tokens_remaining: u64, ceiling: u64, fraction: f64) -> bool`; pure arithmetic, no I/O; implements `<= (1.0 - fraction)` (non-strict, EC-002 correctness)
3. **ADR-001 Alt-B constraint:** The HYBRID orchestrator-loop is `async` (Tokio runtime).
   This is intentional and correct. The Kani-verifiable invariants live inside the
   synchronous `reduce_super_step()` core that the orchestrator calls. Async orchestration
   wraps sync verifiable cores — the boundary between them is the purity-boundary-map.
4. **Harness pattern for wrapped sync cores:**
   ```rust
   #[kani::proof]
   fn bsp_determinism_harness() {
       // Call the sync reducer directly — no .await, no Tokio, no block_on needed
       let outputs: Vec<(TaskId, ChannelUpdate)> = kani::vec(kani::any::<usize>().min(4));
       assert_eq!(reduce_super_step(&outputs), reduce_super_step(&permute(&outputs)));
   }
   ```

## Committed VP Obligations (D17-Q7 + R11 + D21 + D23)

Forty-one VPs committed before v1.0 release — VP-001..005 (original five) plus VP-006..010 (D21 ecosystem-parity expansion) plus VP-006-B (SEC-003 multi-pair few-shot mandate) plus VP-011..013 (D23 tools/budget layer) plus VP-014 (burst-302b LCEL composition expansion) plus VP-015 (architect-reconcile-burst MCP credential-redaction) plus VP-016 (GAP-01/ADR-029 GraphAgentTool state-isolation) plus VP-017 (ADR-030 LedgerChannel dedup-idempotency, dual-anchored BC-2.02.007 + BC-2.02.008) plus VP-018 (BC-2.04.011 TrajectoryCompactor retention-integrity) plus VP-019 (BC-2.04.011 {INV-003} trajectory compaction crash-isolation integration P1) plus VP-020 (ADR-030 PromoteRetireChannel idempotency proptest P1, BC-2.02.009 {INV-001}+{INV-002}) plus VP-2.24.001-A through VP-2.24.008-B (D-356 SS-24 Developer Console SEED registrations, BC-2.24.001–008):

| VP | BC Anchor | DI | Module | Tool | Phase | Priority |
|----|-----------|-----|--------|------|-------|---------|
| VP-001 | BC-2.03.001 | DI-001 | `graph::bsp_engine` | Kani | 6 | P0 |
| VP-002 | BC-2.04.006 | DI-005 | `checkpoint::session_index` | Kani | 6 | P0 |
| VP-003 | BC-2.13.004 | DI-007 | `sandbox::path_guard` | Kani | 6 | P0 |
| VP-004 | BC-2.09.004 | DI-014 | `mcp::exception` | integration | 3 | P1 |
| VP-005 | BC-2.09.005 | DI-014 | `mcp::client` | integration | 3 | P1 |
| VP-006 | BC-2.18.004 | DI-014 | `prompts::injection_guard` | Kani | 6 | P1 |
| VP-006-B | BC-2.18.004 {PC-005} | DI-014 | `prompts::injection_guard` | proptest | 3 | P1 |
| VP-007 | BC-2.19.001 | DI-008 | `core::serializable` | proptest | 3 | P1 |
| VP-008 | BC-2.22.001 | DI-014 | `core::embeddings` | proptest | 3 | P1 |
| VP-009 | BC-2.21.003 | DI-014 | `vectorstores::similarity` | Kani | 6 | P0 |
| VP-010 | BC-2.19.005 | DI-014 | `core::serializable` | Kani | 6 | P0 |
| VP-011 | BC-2.05.007 | DI-014 | `graph::hitl` | Kani | 6 | P0 |
| VP-012 | BC-2.10.005 | DI-014 | `core::budget` | Kani | 6 | P1 |
| VP-013 | BC-2.23.005 | DI-014 | `tools::shell` | Kani | 6 | P1 |
| VP-014 | BC-2.01.005 + BC-2.01.006 | DI-016 | `core::runnable` | proptest | 3 | P1 |
| VP-015 | BC-2.09.007 {INV-003} | DI-010 | `mcp::sanitize` | unit | 3 | P1 |
| VP-016 | BC-2.09.008 {INV-001} | DI-010 | `mcp::graph_tool` | proptest | 3 | P1 |
| VP-017 | BC-2.02.007 + BC-2.02.008 | DI-001 | `graph::channels` | proptest | 3 | P1 |
| VP-018 | BC-2.04.011 {INV-001} | DI-002 | `checkpoint::trajectory` | proptest | 3 | P1 |
| VP-019 | BC-2.04.011 {INV-003} | DI-002 | `checkpoint::trajectory` | integration | 6 | P1 |
| VP-020 | BC-2.02.009 {INV-001}+{INV-002} | DI-001 | `graph::channels` | proptest | 3 | P1 |
| VP-2.24.001-A | BC-2.24.001 | DI-014 | `console::server` | unit | 3 | P1 |
| VP-2.24.001-B | BC-2.24.001 | DI-014 | `console::server` | unit | 3 | P1 |
| VP-2.24.001-C | BC-2.24.001 | DI-014 | `console::server` | compile-fail | 3 | P1 |
| VP-2.24.002-A | BC-2.24.002 | DI-014 | `console::ring_buffer` | proptest | 3 | P1 |
| VP-2.24.002-B | BC-2.24.002 | DI-014 | `console::ring_buffer` | proptest | 3 | P1 |
| VP-2.24.002-C | BC-2.24.002 | DI-014 | `server::debug_routes` | integration | 3 | P1 |
| VP-2.24.002-D | BC-2.24.002 | DI-014 | `console::span_exporter` | unit | 3 | P1 |
| VP-2.24.003-A | BC-2.24.003 | DI-014 | `graph::descriptor` | unit | 3 | P1 |
| VP-2.24.003-B | BC-2.24.003 | DI-014 | `graph::descriptor` | Kani | 6 | P1 |
| VP-2.24.003-C | BC-2.24.003 | DI-014 | `graph::descriptor` | unit | 3 | P1 |
| VP-2.24.004-A | BC-2.24.004 | DI-014 | `spa/components/run_inspector` | integration | 3 | P1 |
| VP-2.24.004-B | BC-2.24.004 | DI-014 | `spa/components/run_inspector` | integration | 3 | P1 |
| VP-2.24.005-A | BC-2.24.005 | DI-004 | `spa/components/checkpoint_panel` | integration | 3 | P1 |
| VP-2.24.005-B | BC-2.24.005 | DI-004 | `spa/components/checkpoint_panel` | integration | 3 | P1 |
| VP-2.24.006-A | BC-2.24.006 | DI-003 | `spa/components/hitl_panel` | integration | 3 | P1 |
| VP-2.24.006-B | BC-2.24.006 | DI-003 | `spa/components/hitl_panel` | integration | 3 | P1 |
| VP-2.24.007-A | BC-2.24.007 | DI-014 | `spa/components/budget_panel` | unit | 3 | P1 |
| VP-2.24.007-B | BC-2.24.007 | DI-014 | `spa/components/budget_panel` | integration | 3 | P1 |
| VP-2.24.008-A | BC-2.24.008 | DI-012 | `spa/components/guardrail_panel` | integration | 3 | P1 |
| VP-2.24.008-B | BC-2.24.008 | DI-014 | `spa/components/guardrail_panel` | unit | 3 | P1 |

**Total: 41 VPs — 6 P0 / 35 P1 | Tool breakdown: Kani ×10, proptest ×10, integration ×12, unit ×8, compile-fail ×1**

> **D-273 VP-015 tool-type fix (GAP-01/2026-08-26):** VP-015 tool corrected from 'integration' to 'unit' — VP-015.md frontmatter is authoritative per CLAUDE.md rule 4 (VP file supersedes architecture doc).
> **SEC-003 VP-006-B (SEC-review-adjudication/2026-08-26):** VP-006-B proptest P1 added for multi-pair few-shot injection mandate. Total 16→17 VPs; P1 10→11; proptest 4→5.
> **ADR-030 VP-017 (ADR-030 Stage 1/2026-08-31):** VP-017 proptest P1 added for LedgerChannel dedup-idempotency. Total 17→18 VPs; P1 11→12; proptest 5→6.
> **BC-2.04.011 VP-018 (2026-08-31):** VP-018 proptest P1 added for TrajectoryCompactor retention-integrity. Total 18→19 VPs; P1 12→13; proptest 6→7.
> **round-50 VP-017+VP-019 (2026-08-31):** VP-017 BC Anchor updated BC-2.02.007 → BC-2.02.007 + BC-2.02.008 (F-P2A211-05 dual-anchor; first-appearance ordering covered by Property 3 in VP-017 harness is the subject of BC-2.02.008). VP-019 integration P1 added for trajectory compaction crash-isolation (BC-2.04.011 {INV-003}; SQLite atomicity under SIGKILL). Total 19→20 VPs; P1 13→14; integration 2→3.
> **round-54 VP-017 DI correction (F-P2A224-02/2026-09-01):** VP-017 DI anchor corrected DI-014 → DI-001 in §preamble narrative sentence and Provable Properties Catalog VP table row. Authoritative value confirmed: VP-INDEX + ADR-030 §VP + VP-017.md body all carry DI-001. The round-53 re-anchor (D-332) updated BC-INDEX / VP-INDEX / ARCH-INDEX / ADR-030 §VP / VP-017 body but missed these two sibling sites. Historical entries above (DI-014 at ADR-030 Stage 1 / round-50) are grandfathered per POL-46 as records of the original authored value.
> **round-62 VP-020 (F-P2A234-05/2026-09-01):** VP-020 proptest P1 added for PromoteRetireChannel idempotency (BC-2.02.009 {INV-001}+{INV-002}; DI-001; graph::channels; Phase 3; harness `promote_retire_channel_idempotency`). Closes BC-2.02.009 unit-test-only coverage gap; structurally analogous to VP-017. Total 20→21; P1 14→15; proptest 7→8. VP-019 §Should Prove updated: four-crash-point staging-table model retired; replaced with two-crash-point per-run DELETE model per ADR-030 §Compaction Atomicity Decision F-P2A234-01 redesign.
> **D-356 VP-2.24.* SEED registrations (2026-09-06, architect):** 19 VP-2.24.* placeholder rows added for SS-24 Developer Console (BC-2.24.001–008). SEED status — body .md files not required until Phase 3 Wave 3. Tool breakdown: integration ×15, proptest ×3, Kani ×1. VP-2.24.003-B is the Kani candidate (graph::descriptor Pure Core, extractable before Phase 6). Total 21→40; P1 15→34; Kani 9→10; proptest 8→11; integration 3→18.
> **D-356 adversary fix DC-01 (2026-09-06, architect).** F-PDC01-03: VP-2.24.002-A/B module repointed to `console::ring_buffer` / `pregolya-console` — `RingBuffer<SpanData>` is Pure Core in pregolya-console (ADR-031 Decision 5 + S-console-02 target_module); harness_fn updated (`ring_buffer_bounded_invariant`, `ring_buffer_fifo_invariant`). F-PDC01-04: 8 rows reconciled against BC Proof Methods: 001-A/B integration/proptest→unit; 001-C integration→compile-fail (BC-2.24.001 AC-007 compile-fail test; new tool category); 002-B integration→proptest; 003-A proptest→unit; 003-C integration→unit; 007-A integration→unit; 008-B integration→unit. Updated tool breakdown: Kani ×10, proptest ×10, integration ×12, unit ×7, compile-fail ×1.
> **D-356 adversary fix DC-02 (2026-09-07, architect).** F-PDC02-03: VP-2.24.002-A/B module repointed `console::ring_buffer` → `console::span_exporter` (ADR-031 Decision 5 canonical; `console::ring_buffer` was a non-canonical invention; canonical module is `console::span_exporter` — Boundary module hosting `RingBuffer<SpanData>`, per ADR-031 Decision 5 purity table). F-PDC02-02: VP-2.24.004-008 A/B module columns corrected from `console::server` to SPA panel modules per respective BCs: `console::run_inspector` (004-A/B), `console::checkpoint_panel` (005-A/B), `console::hitl_panel` (006-A/B), `console::budget_panel` (007-A/B), `console::guardrail_panel` (008-A/B). Tool census UNCHANGED. See companion fixes in api-surface.md and ADR-031 (F-PDC02-05 mandatory `debug_route_key`). *[DC-08 records sweep: `debug_api_key` → `debug_route_key` for DC-07-rename consistency.]*
> **D-356 adversary fix DC-02 addendum (2026-09-07, architect).** VP-2.24.002-D registered — SpanData SEC-BOUND-001 sanitization before ring-buffer insertion (unit P1; BC-2.24.002; DI-014; `console::span_exporter`; harness `test_BC_2_24_002_span_data_sanitization_sec_bound_001`). Sanitization-location ruling: AT INSERTION (stricter; in-memory ring buffer never holds unsanitized `llm_request`/`llm_response`/`attributes`; satisfies BC-2.24.002 PC-008 as a postcondition). Census 40→41; unit ×7→×8; P1 34→35. PO follow-up: BC-2.24.002 PC-008 wording needs "before ring-buffer insertion" instead of "before being served at /debug/trace/*".

> **D-356 adversary fix DC-04 (2026-09-07, architect).** F-PDC04-04: VP-2.24.002-A/B module repointed `console::span_exporter` → `console::ring_buffer`. `console::ring_buffer` is now the canonical Pure Core module for `RingBuffer<T>` per ADR-031 Decision 5 (DC-04 split). VP-2.24.002-C (`server::debug_routes`) and VP-2.24.002-D (`console::span_exporter` sanitization) unchanged. Census UNCHANGED: 41 total.

> **D-356 adversary fix DC-07 (2026-09-07, architect).** F-PDC07-03: 10 panel-VP Module cells repointed to canonical SPA component path form — `spa/components/run_inspector` (VP-2.24.004-A/B), `spa/components/checkpoint_panel` (VP-2.24.005-A/B), `spa/components/hitl_panel` (VP-2.24.006-A/B), `spa/components/budget_panel` (VP-2.24.007-A/B), `spa/components/guardrail_panel` (VP-2.24.008-A/B). CORRECTION: v2.41 (DC-02) described these as "SPA panel modules" but used `console::*` Rust module notation — non-canonical for SPA components. Canonical form: `spa/components/<component_name>` path form (matches VP-INDEX.md preamble SPA convention note). Census UNCHANGED: 41 total.

> **D-356 adversary fix DC-20 (2026-09-08, architect).** F-PDC20-01+O-PDC20-A: 5 DI-column re-anchors in VP-to-Module table: VP-2.24.005-A DI-002→DI-004 (BC-2.24.005 INV-001 step_idx monotone ordering → DI-004); VP-2.24.005-B DI-002→DI-004 (fork-from-checkpoint creates new run_id via DI-004 fork lineage; O-PDC20-A CHANGE); VP-2.24.006-A DI-014→DI-003 (approve/deny dispatch is HITL resume-value delivery; O-PDC20-A CHANGE); VP-2.24.006-B DI-014→DI-003 (BC-2.24.006 INV-001 FIFO ordering → DI-003); VP-2.24.008-A DI-014→DI-012 (BC-2.24.008 INV-002 complete feed → DI-012). BCs are source of truth (BC-2.24.005/006/008 di_anchors). All other VP-2.24.* DI-014 kept. Census UNCHANGED: 41 total. POL-2 orphan closure: DI-003/DI-004/DI-012 each ≥1 VP. Propagated from VP-INDEX.md v1.51 in same burst.

> **D-356 adversary fix DC-19 (2026-09-08, architect).** F-PDC19-02: VP-2.24.003-C module repointed `server::debug_routes` → `graph::descriptor` — BC-2.24.003 §VP table is source of truth; BC declares VP-2.24.003-C as "Start node always present in descriptor" targeting `graph::descriptor`/`pregolya-graph`. VP-2.24.003-B module (`graph::descriptor`) already correct in this mirror; harness_fn is not tracked here (harness_fn is VP-INDEX.md scope only). Census UNCHANGED: 41 total.

## Provable Properties Catalog

### P0: Must Prove (CRITICAL / security / durability)

**VP-001 — BSP Super-Step Determinism** (`graph::bsp_engine`)

Property: For any fixed set of super-step task outputs, the reduced channel state is
identical regardless of the order in which tasks complete.

Formal statement: `∀ task_outputs: Vec<(TaskId, ChannelUpdate)>,
  reduce_super_step(task_outputs) == reduce_super_step(permute(task_outputs))`
(`reduce_super_step` sorts by `task_id` then reduces — VP-001.md §Property Statement)

Kani harness sketch (see VP-001.md §Proof Harness Skeleton for full bounded permutation impl):
```rust
#[kani::proof]
fn bsp_determinism_harness() {
    let n: usize = kani::any();
    kani::assume(n > 0 && n <= 4); // bounded for model checking
    let task_outputs: Vec<(TaskId, ChannelUpdate)> = (0..n)
        .map(|i| (TaskId(i as u64), kani::any::<ChannelUpdate>()))
        .collect();
    // kani::any_permutation(n) is not a built-in API; see VP-001.md Note for
    // bounded permutation array pattern
    let permutation: Vec<usize> = kani::any_permutation(n);
    let permuted: Vec<(TaskId, ChannelUpdate)> =
        permutation.iter().map(|&i| task_outputs[i].clone()).collect();
    let result_a = reduce_super_step(task_outputs.clone());
    let result_b = reduce_super_step(permuted);
    kani::assert(result_a == result_b, "BSP determinism violated");
}
```

Feasibility: HIGH. `reduce_super_step` is a pure function; task-identity sort produces a total order.
Bounded by n ≤ 4 to keep state-space finite. Key verification target per NE-17.

---

**VP-002 — Session Triple-Address Uniqueness** (`checkpoint::session_index`)

Property: No two distinct sessions (thread_id, checkpoint_ns, checkpoint_id) map to the
same storage row. The triple (thread_id, checkpoint_ns, checkpoint_id) is a composite key.

Formal statement: `∀ s1 s2: SessionKey, s1 ≠ s2 → storage_address(s1) ≠ storage_address(s2)`

Kani harness sketch:
```rust
#[kani::proof]
fn session_tenancy_harness() {
    let s1: SessionKey = kani::any();
    let s2: SessionKey = kani::any();
    kani::assume(s1 != s2);
    assert_ne!(storage_address(&s1), storage_address(&s2));
}
```

Feasibility: HIGH. `SessionKey` is a pure struct; `storage_address` is a deterministic
function over its fields. No I/O in the harness.

---

**VP-003 — Workspace Path Confinement** (`sandbox::path_guard`)

Property: For any symbolic path under a workspace root, `canonicalize_beneath_root`
either returns a path within the root or returns `Err(PregolyaError { code: "E-SBXD-001", .. })`.
It never returns a path outside the root.

Formal statement: `∀ base: Path, path: Path,
  match canonicalize_beneath_root(base, path) {
    Ok(p) => p.starts_with(base),
    Err(PregolyaError { code: "E-SBXD-001", .. }) => true,  // WorkspaceEscape — E-SBXD-001
    _ => false
  }`

Kani harness sketch (see VP-003.md §Proof Harness Skeleton for full bounded path construction):
```rust
#[kani::proof]
fn workspace_confinement_harness() {
    // Target: canonicalize_beneath_root_pure — the extracted pure model
    // (no OS std::fs::canonicalize; symlinks modeled via bounded path components)
    let base_components: Vec<BoundedPathComponent> = kani::vec(3, kani::any);
    let base = PathBuf::from_components(&base_components);
    let path_components: Vec<BoundedPathComponent> = kani::vec(6, kani::any);
    let path = PathBuf::from_components(&path_components);
    match canonicalize_beneath_root_pure(&base, &path) {
        Ok(p) => kani::assert(p.starts_with(&base), "result must be within base"),
        Err(e) if e.code == "E-SBXD-001" => {}, // WorkspaceEscape — path traversal detected
        Err(_) => {}, // other errors allowed (e.g., path does not exist in model)
    }
}
```

Feasibility: MEDIUM-HIGH. Proof targets `canonicalize_beneath_root_pure` — the extracted
pure-model variant (no OS `std::fs::canonicalize`; pure path arithmetic over bounded
components). Bounded: base ≤ 3 components; path ≤ 6 components per VP-003.md.

---

**VP-009 — Zero-Norm Cosine Guard** (`vectorstores::similarity`) `red_gate: true`

Property: For any symbolic pair of finite `f32` vectors where either L2 norm is `0.0`
(IEEE-754 exact equality), `cosine_similarity` returns `Err(E-VS-001)` and never
produces `Ok(f32::NAN)`. Division is unreachable when either norm is zero.

Formal statement:
```
∀ a: &[f32], b: &[f32], 1 ≤ |a| = |b| ≤ 8, all elements finite (is_finite()):
  let norm_a = sqrt(Σ aᵢ²);  let norm_b = sqrt(Σ bᵢ²)
  (norm_a == 0.0 ∨ !norm_a.is_finite() ∨ norm_b == 0.0 ∨ !norm_b.is_finite()) →
    cosine_similarity(a, b) == Err(E-VS-001)
    ∧ cosine_similarity(a, b) ≠ Ok(NaN)
```

Overflow note (F-P173-503): finite elements can produce norm = +Inf via Σ xᵢ² overflow;
`sqrt(+Inf) = +Inf`; `Inf/Inf = NaN`. Guard must check `!norm.is_finite()` in addition to
`norm == 0.0`. BC-2.21.003 Invariant 3 BC amendment required (routed to product-owner).
See VP-009.md §Property Statement for full specification.

Kani harness sketch (see VP-009.md §Proof Harness Skeleton for complete three-harness set):
```rust
#[kani::proof]
#[kani::unwind(9)]
fn zero_norm_guard_fail_closed() {
    let len: usize = kani::any();
    kani::assume(len >= 1 && len <= 8);
    let a: Vec<f32> = (0..len).map(|_| { let x: f32 = kani::any(); kani::assume(x.is_finite()); x }).collect();
    let b: Vec<f32> = (0..len).map(|_| { let x: f32 = kani::any(); kani::assume(x.is_finite()); x }).collect();
    let norm_a = a.iter().map(|x| x * x).sum::<f32>().sqrt();
    let norm_b = b.iter().map(|x| x * x).sum::<f32>().sqrt();
    let result = cosine_similarity(&a, &b);
    // Covers both zero-norm and overflow (norm = +Inf from Σ xᵢ² overflow)
    if norm_a == 0.0 || !norm_a.is_finite() || norm_b == 0.0 || !norm_b.is_finite() {
        kani::assert(matches!(result, Err(PregolyaError { code: "E-VS-001", .. })), "guard must fire (zero or overflow)");
        kani::assert(!matches!(result, Ok(v) if v.is_nan()), "Ok(NaN) unreachable");
    } else {
        kani::assert(result.is_ok(), "finite non-zero norm must produce Ok");
    }
}
```

Feasibility: MEDIUM-HIGH. `cosine_similarity` is a pure-core sync function in `vectorstores::similarity`
(ADR-014 Decision 2 §Hardening note; relocated from vectorstores::mmr per F-P129-11). Kani 0.67.0 models
`f32` symbolically over IEEE-754 domain. Requires `#[kani::unwind(9)]` for the 8-element vector
iteration. Estimated proof time: 5–15 min. Red Gate: tests TV-001 and TV-002 must compile-and-fail
before Phase 3 story delivery for SS-21.

---

**VP-010 — Reviver Allowlist Containment** (`core::serializable` — Reviver aspect) `red_gate: true`

Property: For any type-ID path that is (a) not present in the registered allowlist AND
(b) not a LangChain monolith passthrough type (`LANGCHAIN_MONOLITH_TYPES`), `allowlist_check`
returns `Err(E-SRLZ-001)`. The `Ok(())` path is unreachable for non-monolith unregistered IDs.
Broader "never Ok for ANY unregistered id" invariant is jointly covered with BC-2.19.006 unit
tests (monolith ids correctly produce `E-SRLZ-002`, not `E-SRLZ-001` — VP-010 proof domain
excludes those IDs per VP-010.md v1.1 scoping).

Formal statement:
```
∀ id: &[String] (depth ≤ 4, each segment ≤ 16 bytes ASCII printable),
  registry: &HashMap<Vec<String>, ()> (5 concrete entries),
  id ∉ LANGCHAIN_MONOLITH_TYPES:
    !registry.contains_key(id) → allowlist_check(id, registry) == Err(E-SRLZ-001)
```

Kani harness sketch:
```rust
#[kani::proof]
fn allowlist_rejects_unregistered_id() {
    let depth: usize = kani::any();
    kani::assume(depth >= 1 && depth <= 4);
    let id: Vec<String> = (0..depth).map(|_| {
        let len: usize = kani::any();
        kani::assume(len >= 1 && len <= 16);
        (0..len).map(|_| { let c: u8 = kani::any(); kani::assume(c.is_ascii_graphic()); c as char }).collect()
    }).collect();
    let mut registry: HashMap<Vec<String>, ()> = HashMap::new();
    registry.insert(vec!["lc".into(), "PromptTemplate".into()], ());
    // 4 more concrete entries
    kani::assume(!registry.contains_key(&id));
    kani::assume(!LANGCHAIN_MONOLITH_TYPES.contains(&id.as_slice())); // non-monolith domain
    let result = allowlist_check(&id, &registry);
    kani::assert(matches!(result, Err(PregolyaError { code: "E-SRLZ-001", .. })), "unregistered non-monolith id must be rejected");
}
```

Feasibility: HIGH. `OnceLock<HashMap>` complexity excluded by extracting `allowlist_check` as a standalone
pure function. Bounded: ID depth ≤ 4, segments ≤ 16 ASCII bytes, registry fixed at 5 concrete entries,
non-monolith domain assumption (VP-010.md v1.1 scoping per F-P129-04). HashMap lookup is directly modeled
by Kani's CBMC backend. Red Gate: must compile-and-fail before Phase 3 story delivery for SS-19.

---

**VP-011 — PreToolCallHook Fail-Closed** (`graph::hitl`) `Kani P0`

Property: For any `PreToolDecision::Deny` — whether returned by the hook or synthesized by
the panic-shield from `Err(HookError)` — `route_pre_tool_decision` returns
`DispatchOutcome::Reject(_)` and `pre_tool_dispatch` never calls `tool.invoke`.
`DispatchOutcome::Proceed(_)` is reachable from `PreToolDecision::Approve` AND from
`PreToolDecision::Edit { modified_args }` when `modified_args` is a valid JSON object
(BC-2.05.007 PC-3). `PreToolDecision::PendingHumanApproval` is handled by the async `pre_tool_dispatch`
wrapper BEFORE `route_pre_tool_decision` is called — the wrapper issues
`interrupt(ToolApprovalRequest{..})` and suspends the run (BC-2.05.001 machinery);
`route_pre_tool_decision` is not invoked for this path. This variant is outside the Kani
proof scope; non-invocation is covered by BC-2.05.008 integration tests. If
`PendingHumanApproval` reaches `route_pre_tool_decision` unexpectedly, the
`#[non_exhaustive]` wildcard arm returns `DispatchOutcome::Reject(_)` (fail-closed).

Formal statement:
```
// route_pre_tool_decision: pure-sync routing over three routable variants + #[non_exhaustive] wildcard
// NOTE: PendingHumanApproval is peeled off upstream in pre_tool_dispatch before this fn is called.
∀ decision: PreToolDecision passed to route_pre_tool_decision:
  decision == Deny { .. }
    → route_pre_tool_decision(decision) == Reject(_)
  decision == Approve
    → route_pre_tool_decision(decision) == Proceed(_)
  decision == Edit { modified_args }:
    is_valid_json_object(modified_args) == true
      → route_pre_tool_decision(decision) == Proceed(_)
    is_valid_json_object(modified_args) == false
      → route_pre_tool_decision(decision) == Reject(_)  // fallback Deny per BC-2.05.007 PC-3
  _ (wildcard — including PendingHumanApproval if it unexpectedly reaches this fn)
    → route_pre_tool_decision(decision) == Reject(_)    // #[non_exhaustive] fail-closed

// pre_tool_dispatch (async wrapper): PendingHumanApproval peeled off before route_pre_tool_decision
// This path is outside Kani scope (async/effectful); covered by BC-2.05.008 integration tests:
PreToolDecision::PendingHumanApproval { .. } received by pre_tool_dispatch
  → interrupt(ToolApprovalRequest{..}) issued; run suspended;
    route_pre_tool_decision NOT called; tool NOT invoked

∀ result: Result<PreToolDecision, HookError>:
  result == Err(_)  → shield_hook_result(result) == Deny { .. }  // fail-closed panic-shield
  result == Ok(d)   → shield_hook_result(result) == d            // identity pass-through
```

`#[non_exhaustive]` note: `PreToolDecision` is `#[non_exhaustive]`. The harness uses
concrete variant construction rather than `kani::any::<PreToolDecision>()` (which cannot
enumerate future variants). The four proof functions below target the three routable variants
(Deny, Approve, Edit) and the hook-error path; `PendingHumanApproval` is peeled off upstream
in `pre_tool_dispatch` and has no dedicated proof function. Future variants require
specification of which layer handles them before a harness can be added
(VP-011.md §Proof Obligations).

Kani harness sketch (see VP-011.md §Proof Harness Skeleton for full target-file path):
```rust
// Target: graph::hitl::route_pre_tool_decision + shield_hook_result (pure sync)

#[kani::proof]
fn deny_excludes_tool_invocation() {
    // reason content does not affect routing — branch is variant-based.
    let reason = "denied by hook".to_string();
    let decision = PreToolDecision::Deny { reason: reason.clone() };
    let outcome = route_pre_tool_decision(decision);
    kani::assert(matches!(outcome, DispatchOutcome::Reject(_)), "Deny MUST produce Reject");
    kani::assert(!matches!(outcome, DispatchOutcome::Proceed(_)), "tool.invoke MUST be unreachable for Deny");
}

#[kani::proof]
fn approve_reaches_tool_invocation() {
    let decision = PreToolDecision::Approve;
    let outcome = route_pre_tool_decision(decision);
    kani::assert(matches!(outcome, DispatchOutcome::Proceed(_)), "Approve MUST reach tool.invoke");
}

#[kani::proof]
fn hook_error_resolves_to_deny_and_reject() {
    let error_detail = "panic in hook".to_string();
    let hook_result: Result<PreToolDecision, HookError> = Err(HookError::Panic(error_detail));
    let effective_decision = shield_hook_result(hook_result);
    kani::assert(matches!(effective_decision, PreToolDecision::Deny { .. }),
        "hook panic MUST be converted to PreToolDecision::Deny");
    let outcome = route_pre_tool_decision(effective_decision);
    kani::assert(matches!(outcome, DispatchOutcome::Reject(_)), "hook panic → Deny → Reject");
    kani::assert(!matches!(outcome, DispatchOutcome::Proceed(_)), "tool.invoke unreachable after hook panic");
}

#[kani::proof]
fn edit_invalid_args_falls_back_to_deny() {
    // Non-object JSON value is invalid for Edit modified_args (BC-2.05.007 PC-3)
    let invalid_args = serde_json::Value::String("not-an-object".to_string());
    let decision = PreToolDecision::Edit { modified_args: invalid_args };
    let outcome = route_pre_tool_decision(decision);
    kani::assert(matches!(outcome, DispatchOutcome::Reject(_)), "Edit with non-object args MUST fall back to Reject");
    kani::assert(!matches!(outcome, DispatchOutcome::Proceed(_)), "tool.invoke unreachable for invalid Edit");
}
```

Feasibility: HIGH. `PreToolDecision` is a 4-variant `#[non_exhaustive]` enum (D23-defined:
Approve, Deny, Edit, PendingHumanApproval; BC-2.05.007 PC1–PC4); the harness targets the
three routable variants (Deny, Approve, Edit) plus hook-error path — `PendingHumanApproval`
is peeled off upstream in `pre_tool_dispatch` (not a harness target). `route_pre_tool_decision`
and `shield_hook_result` are pure sync functions extracted from the async `pre_tool_dispatch`
per the sync-core mandate above. No I/O in harness; routing is a `match` over three routable
variants plus `#[non_exhaustive]` wildcard — CBMC solves branch reachability queries in
seconds. Estimated proof time: < 2 min.
See VP-011.md §Feasibility Assessment for full factor table.

## Should Prove (P1 — Core Algorithms, Conformance Contracts)

**VP-006 — injection_guard Fail-Closed** (`prompts::injection_guard`) `Kani P1 Phase 6` `red_gate: true`

**Scope (v1.9 extension, architect-reconcile-burst):** VP-006 covers all 3 injection arms:
(1) slot-variable trust check (`check_slot_trust` — original scope); (2) few-shot example
injection (`check_fewshot_trust` — added in v1.9 per BC-2.18.004 {PC-005}); (3) TV-006 Red Gate
(compile-and-fail before Phase 3 story delivery for SS-18). Two Kani harnesses:
`injection_guard_fail_closed` (Arm 1) and `injection_guard_fewshot_fail_closed` (Arm 2).
Authoritative harness bodies: VP-006.md §Proof Harness Skeleton.

Property: For any injection-guard input with `TrustLevel::Untrusted` where the guard policy
is `TrustRequired`, the corresponding check function returns `Err(E-TMPL-001)` and never
returns `Ok(PromptValue)`. Holds for both `check_slot_trust` (Arm 1) and `check_fewshot_trust`
(Arm 2). The safe passage (`TrustAll`) path is only reachable when the policy explicitly permits it.

Note (burst-226 / F-P131-05): `TrustLevel` is the SS-18-local trust classifier in
`pregolya-prompts: prompts::template`. It is distinct from `core::guardrail::ProvenanceTag`
(SS-11 ingress-boundary struct). Harness uses `kani::Arbitrary` on `TrustLevel` (3-variant
enum: `Untrusted | UserInput | Trusted`). Error code is `E-TMPL-001` (SECURITY/InjectionAttempt).

Formal statement (Arm 1 — slot variables):
```
∀ slots: Vec<SlotVar>, |slots| ≤ 4:
  ∃ slot ∈ slots: slot.policy == SlotTrustPolicy::TrustRequired
                  ∧ slot.trust_level.is_some_and(|t| t.is_untrusted()) →
    check_slot_trust(slots) == Err(PregolyaError { code: "E-TMPL-001", category: SECURITY, .. })
```

Formal statement (Arm 2 — few-shot examples):
```
∀ examples: Vec<FewShotExample>, |examples| ≤ 4:
  ∃ ex ∈ examples: ex.trust_level.is_some_and(|t| t.is_untrusted()) →
    check_fewshot_trust(examples) == Err(PregolyaError { code: "E-TMPL-001", category: SECURITY, .. })
```

Kani harness sketch (Arm 1 — canonical, unchanged from prior versions):
```rust
#[kani::proof]
fn injection_guard_fail_closed() {
    let n: usize = kani::any();
    kani::assume(n >= 1 && n <= 4);
    // SlotVar has fields: policy: SlotTrustPolicy, trust_level: Option<TrustLevel>
    let slot_vars: Vec<SlotVar> = (0..n)
        .map(|_| SlotVar {
            policy: kani::any::<SlotTrustPolicy>(),
            trust_level: kani::any::<Option<TrustLevel>>(),  // None | Some(Untrusted|UserInput|Trusted)
        })
        .collect();
    let result = check_slot_trust(&slot_vars);
    let has_violation = slot_vars.iter().any(|s|
        s.policy == SlotTrustPolicy::TrustRequired
        && s.trust_level.is_some_and(|t| t.is_untrusted())
    );
    if has_violation {
        kani::assert(matches!(result, Err(PregolyaError { code: "E-TMPL-001", .. })), "fail-closed: must return E-TMPL-001");
    } else {
        kani::assert(result.is_ok(), "no violation: must pass");
    }
}
```

Kani harness sketch (Arm 2 — few-shot, added v1.9):
```rust
#[kani::proof]
fn injection_guard_fewshot_fail_closed() {
    let n: usize = kani::any();
    kani::assume(n >= 1 && n <= 4);
    let examples: Vec<FewShotExample> = (0..n)
        .map(|_| FewShotExample {
            trust_level: kani::any::<Option<TrustLevel>>(),
        })
        .collect();
    let result = check_fewshot_trust(&examples);
    let has_untrusted = examples.iter().any(|ex|
        ex.trust_level.is_some_and(|t| t.is_untrusted())
    );
    if has_untrusted {
        kani::assert(matches!(result, Err(PregolyaError { code: "E-TMPL-001", .. })), "fewshot fail-closed: must return E-TMPL-001");
    } else {
        kani::assert(result.is_ok(), "no untrusted fewshot: must pass");
    }
}
```

**Multi-pair mandate (SEC-003):** The bound `n >= 1 && n <= 4` in the Arm 2 harness provides
symbolic proof over ALL combinations of pair-count (1..=4) and trust-level assignment per pair.
This includes scenarios where only middle or last pairs are Untrusted (e.g., `[Trusted, Untrusted,
Trusted]`): Kani's symbolic enumeration over `kani::any::<Option<TrustLevel>>()` per element
exhaustively covers these combinations within the bound. This coverage is MANDATORY — it is NOT
a "should". VP-006.md MUST include `multi_pair_coverage: mandatory` in its proof obligations.

**SEC-004 — Future TrustLevel Variant Obligation:**
VP-006 proves the Arm 2 property for the THREE currently-defined `TrustLevel` variants
(`Untrusted | UserInput | Trusted`). `TrustLevel` is `#[non_exhaustive]`; the runtime wildcard
arm enforces fail-closed for any future variant that reaches `check_fewshot_trust` without a
matching trust check. However, formal proof coverage does NOT automatically extend to future
variants. **Proof obligation:** Adding a new `TrustLevel` variant requires re-running
`cargo kani` to re-verify the Arm 2 harness. This obligation MUST be documented in VP-006.md
§Proof Obligations and the VP-006.md frontmatter must include a `rerun_on_variant_addition:
TrustLevel` field. VP-006.md is the authoritative source per Source-of-Truth Precedence rule 4.

**VP-006-B (proptest P1, Phase 3) — belt-and-suspenders multi-pair coverage:**
See §VP-006-B below.

Feasibility: HIGH. Both `check_slot_trust` and `check_fewshot_trust` are pure sync functions over
bounded Vec. Enum variants finite (TrustLevel: 3 variants; SlotTrustPolicy: 2 variants).
Harness bounds: ≤ 4 slots / ≤ 4 examples. Estimated proof time per harness: 1–3 min.

---

**VP-006-B — injection_guard Multi-Pair FewShotExamples** (`prompts::injection_guard`) `proptest P1 Phase 3`

Property: For ANY arbitrary-length list of `FewShotExample` pairs (pair-count 2..=8) where at
least one pair at ANY position (first, middle, or last) carries `TrustLevel::Untrusted`,
`check_fewshot_trust` returns `Err(E-TMPL-001)` and never returns `Ok`. This is the
belt-and-suspenders complement to VP-006 Arm 2 Kani harness: proptest generates arbitrary
pair-count + arbitrary untrusted index to provide high-confidence coverage at Phase 3 before
the Kani proof runs at Phase 6.

Formal statement:
```
∀ examples: Vec<FewShotExample>, 2 ≤ |examples| ≤ 8:
  ∃ i ∈ [0, |examples|): examples[i].trust_level == Some(TrustLevel::Untrusted) →
    check_fewshot_trust(examples) == Err(PregolyaError { code: "E-TMPL-001", category: SECURITY, .. })
```

Proptest harness sketch:
```rust
proptest! {
    #[test]
    fn prop_fewshot_multi_pair_fail_closed(
        pair_count in 2usize..=8usize,
        untrusted_idx in any::<usize>(),
    ) {
        let untrusted_idx = untrusted_idx % pair_count;
        let examples: Vec<FewShotExample> = (0..pair_count)
            .map(|i| FewShotExample {
                trust_level: if i == untrusted_idx {
                    Some(TrustLevel::Untrusted)
                } else {
                    Some(TrustLevel::Trusted)
                },
            })
            .collect();
        let result = check_fewshot_trust(&examples);
        prop_assert!(
            matches!(result, Err(ref e) if e.code == "E-TMPL-001"),
            "multi-pair fewshot with one Untrusted at index {} must fail-closed",
            untrusted_idx
        );
    }
}
```

Why proptest in addition to Kani Arm 2: (1) proptest provides fast Phase-3 feedback before the
Phase-6 Kani proof; (2) belt-and-suspenders for the specific middle/last-element scenario that
the security reviewer flagged as not provably covered.

Feasibility: HIGH. `check_fewshot_trust` is a pure sync function. No async, no I/O. 256 proptest
cases at pair_count ≤ 8 completes in < 1s. Red Gate: same TV as VP-006 (BC-2.18.004 {PC-005})
with a multi-pair specific TV (to be authored by PO per handoff below).

---

**VP-007 — LcSerializable Round-Trip** (`core::serializable`) `proptest P1 Phase 3`

Property: For all types implementing `LcSerializable`, `deserialize(serialize(x)) ≡ x`.
Serialization is deterministic and lossless for registered types (excluding fields listed
in `lc_secrets()`, which are stripped by design).

Why proptest (not Kani): 141 registered types exceed practical Kani bounds. proptest's shrinking
is more actionable for debugging round-trip failures than a CBMC counterexample.

proptest strategy sketch (see VP-007.md §Proof Harness Skeleton for full strategy):
```rust
proptest! {
    #[test]
    fn prop_prompt_template_round_trip(pt in any::<PromptTemplate>()) {
        // Authoritative API: serialize() + Reviver::revive() (VP-007.md §Property Statement)
        let serialized = pt.serialize();
        prop_assume!(matches!(serialized, Serialized::Constructor { .. }));
        let reviver = Reviver::new();
        let revived = reviver.revive(serialized).expect("registered type must round-trip");
        let revived_pt = revived.downcast::<PromptTemplate>()
            .expect("downcast to PromptTemplate must succeed");
        prop_assert_eq!(pt.lc_id(), revived_pt.lc_id());
        prop_assert_eq!(pt.input_variables(), revived_pt.input_variables());
    }
}
```

Feasibility: HIGH. proptest shrinking identifies concrete failing inputs. `Arbitrary` impls
required for all `LcSerializable` types by Phase 3. Secret-field exclusion (`lc_secrets()`)
is explicit in the equivalence check, not a gap.

---

**VP-008 — Embeddings Dimensionality Contract** (`core::embeddings`) `proptest P1 Phase 3`

Property: For any batch of non-empty strings, all vectors returned by `embed_documents`
have equal length, and `embed_query` returns a vector of the same length as any vector
in the batch result. An empty input batch returns `Ok(vec![])`. Count mismatches and
zero-length vectors are caught and returned as `Err(E-EMBED-001)`.

**Production function under test:** `validate_embedding_batch(texts: &[String], vecs: &[Vec<f32>]) -> Result<(), PregolyaError>`.
This function lives in `core::embeddings` production code (not test-only). All `Embeddings`
impls must call it before returning. The proptest harness calls this function DIRECTLY —
the mock impls supply raw valid or invalid outputs as inputs; no validation logic lives
inside any mock.

**Why production-function targeting (not mock-based assertion):**
Prior design (pre-v2.14) asserted `batch.iter().all(|v| v.len() == dim)` on a mock that
returns `vec![0.1; dim]` by construction — trivially true regardless of whether production
validation code exists. A deleted production validator would leave every assertion green.
The redesign targets `validate_embedding_batch` directly so deletion or regression of the
production gate causes immediate test failure.

proptest strategy sketch (calls production function directly):
```rust
proptest! {
    #[test]
    fn prop_validate_embedding_batch_accepts_valid(
        dim in 1usize..=4096usize,
        n_texts in 1usize..=64usize,
    ) {
        let texts: Vec<String> = (0..n_texts).map(|i| format!("text {i}")).collect();
        let vecs: Vec<Vec<f32>> = (0..n_texts).map(|_| vec![0.1f32; dim]).collect();
        // PRODUCTION CODE UNDER TEST
        let result = validate_embedding_batch(&texts, &vecs);
        prop_assert!(result.is_ok());
    }
}
```

Negative harnesses (VP-008-C/D/E) pass raw violating vectors to `validate_embedding_batch`
and assert `Err(E-EMBED-001)`. See VP-008.md §Proof Harness Skeleton for all five harnesses.

Feasibility: HIGH. `validate_embedding_batch` is a pure sync function (no async, no I/O).
Proptest exercises it directly; no Tokio runtime needed for VP-008-A/B. EC-003 (count
mismatch) and EC-004 (zero-length vector) now have dedicated concrete harnesses VP-008-D
and VP-008-E (previously falsely claimed as covered by ragged_batch harness).

---

**VP-012 — OnWatermark Arithmetic** (`core::budget`) `Kani P1 Phase 6`

Property: `check_watermark_trigger(tokens_remaining, ceiling, fraction)` returns `true` if and
only if `(tokens_remaining as f64) / (ceiling as f64) <= (1.0 - fraction)` for all valid inputs
in the bounded domain. Non-strict `<=` is load-bearing (EC-002: fraction=1.0 must fire when
remaining=0). The function never overflows, produces NaN, or returns an incorrect trigger
decision within the bounded domain.

Formal statement:
```
∀ tokens_remaining: u64 ∈ [0, ceiling], ceiling: u64 ∈ (0, 2^24],
  fraction: f64 ∈ (0.0, 1.0], fraction.is_finite():
    check_watermark_trigger(tokens_remaining, ceiling, fraction)
    == ((tokens_remaining as f64) / (ceiling as f64) <= (1.0f64 - fraction))
```

Bound rationale: `ceiling ≤ 2^24` is a CBMC tractability bound (not a precision constraint);
f64 is exact up to 2^53, well above all realistic LLM token budgets as of D23.

Kani harness sketch:
```rust
#[kani::proof]
fn watermark_arithmetic_harness() {
    let tokens_remaining: u64 = kani::any();
    let ceiling: u64 = kani::any();
    let fraction: f64 = kani::any();
    // tokens_remaining: u64 is always >= 0 by type; tokens_remaining=0 is IN-domain (EC-002).
    kani::assume(ceiling > 0 && tokens_remaining <= ceiling);
    kani::assume(ceiling <= 1 << 24);
    kani::assume(fraction > 0.0 && fraction <= 1.0 && fraction.is_finite());
    let result = check_watermark_trigger(tokens_remaining, ceiling, fraction);
    let r = tokens_remaining as f64;
    let c = ceiling as f64;
    let expected = r / c <= (1.0f64 - fraction);  // non-strict <=
    kani::assert(result == expected, "OnWatermark arithmetic must match reference");
}
```

Feasibility: MEDIUM-HIGH. `check_watermark_trigger` is a pure sync arithmetic function in
`pregolya-core (core::budget)`. The bounded domain (`ceiling ≤ 2^24`) makes the f64
arithmetic tractable for Kani's IEEE-754 model. Estimated proof time: 5–15 min.
Note: `fraction > 0.0` assumption excludes the degenerate `fraction = 0.0` case (always-fire)
which is rejected at BudgetConfig construction (EC-001 in BC-2.10.005).

---

**VP-014 — RunnableParallel Key-Completeness** (`core::runnable`) `proptest P1 Phase 3`

Property: For any N-branch `RunnableParallel` invocation where `invoke` returns `Ok(output)`:
`output.as_object().unwrap().len() == N` AND the output key set exactly equals the configured
branch key set passed to `RunnableParallel::new(steps)`. Holds for all N ≥ 0.

Formal statement (DI-016 key-completeness half):
```
// new() accepts an iterator of (key, runnable) pairs — the canonical argument type
// per BC-2.01.005 PC1. IndexMap is the INTERNAL container built by new(), not the
// argument type (ADR-026 §Decision 1).
∀ steps: Vec<(String, Arc<dyn DynRunnable>)>, ∀ input: Value:
  let key_set: HashSet<String> = steps.iter().map(|(k, _)| k.clone()).collect();
  let N = key_set.len();
  let result = RunnableParallel::new(steps).invoke(input, None).await;
  if let Ok(output) = result {
    let obj = output.as_object().unwrap();
    obj.len() == N
    ∧ obj.keys().cloned().collect::<HashSet<_>>() == key_set
  }
```

Why proptest not Kani: `invoke` is an `async fn` using `JoinSet` (Tokio). Kani 0.67.0
has no native async support. proptest with identity-branch runnables (zero I/O, infallible)
exercises the actual Tokio runtime and verifies the key-set property over random inputs.

**Proptest harness:** See `VP-014.md` §Proof Harness Skeleton for the complete harness.
Strategy: `proptest::collection::hash_set` generates arbitrary distinct branch keys (0..=20),
each branch is an identity `DynRunnable`, and the output key set is asserted equal to the input key set.

Feasibility: HIGH. Identity-branch runnables are pure and infallible; zero I/O; no LLM API keys
required. 256 proptest cases at N ≤ 20 completes in < 1 minute.

---

**VP-013 — BashTool Risk Floor** (`tools::shell`) `Kani P1 Phase 6`

Property: For all `ActionRisk r ∈ {ReadOnly, Low}`, `check_risk_floor(r)` returns
`Err(PregolyaError { code: "E-TOOLS-007", category: VAL, .. })` and never returns `Ok(())`.
The Low/ReadOnly risk tiers are unconditionally below the minimum allowed floor.

Formal statement:
```
∀ r: ActionRisk:
  (r == ReadOnly ∨ r == Low) → check_risk_floor(r) == Err(E-TOOLS-007, category: VAL)
  (r == Medium ∨ r == High) → check_risk_floor(r) == Ok(())
```

**RESOLVED (burst-232, 2026-07-22; casing corrected FIX-BURST-270):** BC-2.23.005 §Postconditions (PC-4) category corrected to `Category::Val`
(same burst that seeded VP-013). The prior `Category::CONFIGURATION` label was non-canonical
(not present in the 13-category axis per ADR-010). BC-2.23.005 §Postconditions (PC-4) category = VAL (taxonomy code), Rust identifier = `Category::Val`, consistent with
error-taxonomy.md §Component: TOOLS and this VP harness. No active contradictions.

**Kani harness:** See `VP-013.md` §Proof Harness Skeleton for the complete three-harness set
(`risk_floor_rejects_below_medium`, `risk_floor_accepts_at_or_above_medium`,
`risk_floor_exhaustive_coverage`). `VP-013.md` is the authoritative source per
Source-of-Truth Precedence rule 4 (VP files supersede architecture prose for the property they
cover); harness bodies are not duplicated here to eliminate drift.

Feasibility: HIGH. `ActionRisk` is a 4-variant enum; `check_risk_floor` is a pure sync match.
State-space is trivially finite for Kani. Estimated proof time: < 1 min. See `VP-013.md`
§Feasibility Assessment for the complete feasibility analysis.

---

**VP-015 — MCP Credential Redaction** (`mcp::sanitize`) `unit P1 Phase 3`

Property: For all `text: &str` containing credential patterns from the 6-pattern canonical set in
`redact_credentials`, the function returns a `Cow<str>` in which NONE of the original credential
values appear verbatim. Correct `<redacted>` marks are substituted in their place
(BC-2.09.007 {INV-003}(b) / DI-010 / CWE-532/522). The 6-pattern canonical set:
(1) OpenAI `sk-[A-Za-z0-9_\-]{20,}`, (2) Anthropic `sk-ant-[A-Za-z0-9_\-]{32,}`,
(3) generic `[A-Za-z0-9]{64,}`, (4) Bearer token `Bearer\s+[A-Za-z0-9._~+/=\-]+`,
(5) URL-embedded userinfo `[a-zA-Z][a-zA-Z0-9+.\-]*://[^/\s:@]+:[^/\s:@]+@`,
(6) HTTP Basic auth `Basic\s+[A-Za-z0-9+/=]+`.

**SEC-BOUND-001 pipeline note:** BC-2.09.007 {PC-003} applies a 2-step sanitization pipeline
(step 1 N/A; step 2 `redact_credentials`; step 3 `sanitize_internal_ids`). VP-015 covers step 2.
Step 3 is non-VP-elevated, covered by BC-2.09.007 TV-011 directed test (R38/F-P2A161-01-Option-B
adjudication).

**Why unit test (not Kani):** `redact_credentials` operates on arbitrary `&str` input using regex
pattern matching over a potentially unbounded alphabet. Kani symbolic execution over arbitrary
strings is not tractable. The property is verified by 7 parameterized unit tests with representative
credential patterns drawn from the defined format specs.

**Unit harness:** See `VP-015.md` §Proof Harness Skeleton for the complete harness.
Tests cover all 6 patterns: OpenAI `sk-*`, Anthropic `sk-ant-*`, generic 64-char alphanumeric,
Bearer token, URL-embedded userinfo, and HTTP Basic auth patterns, plus a clean-passthrough case.

Feasibility: HIGH. Patterns are well-defined regular expressions; no I/O; no async;
7 parameterized unit tests complete in < 1s. See `VP-015.md` §Feasibility Assessment.

---

**VP-016 — GraphAgentTool State-Isolation** (`mcp::graph_tool`) `proptest P1 Phase 3`

Property: For any `GraphAgentTool` construction with an `extract_output` closure that selects a
proper subset of fields from the non-generic `serde_json::Value` graph state, the
`serde_json::Value` returned by `invoke_dyn` on successful invocation contains ONLY the JSON
fields returned by `extract_output(&final_state)` — no checkpoint IDs, run IDs, intermediate
node outputs, or internal graph metadata (ADR-029 §Decision 3 {INV-001} / DI-010).

**Why proptest (not Kani):** The STATE-ISOLATION property ranges over `serde_json::Value`, which is
a recursive open data type. Kani cannot reason symbolically over unbounded JSON trees.
`extract_output` is an arbitrary caller-supplied closure; Kani cannot reason symbolically over
closure bodies in general. Proptest generates arbitrary `TestGraphState` instances (serialized as `serde_json::Value`) with extra internal
fields and verifies the structural containment property over a large sample (10k cases × < 1s each).

**Proptest harness:** See `vp-016-graph-agent-tool-state-isolation.md` §Proof Harness Skeleton for the complete harness.
Harness function: `graph_agent_tool_state_isolation`. Strategy: `proptest_derive::Arbitrary` on
`TestGraphState` with `output`, `checkpoint_id`, `run_id`, and `accumulated_messages` fields.
Assertion: the `serde_json::Value` returned by `invoke_dyn` contains exactly the fields selected by
`extract_output`.

Feasibility: HIGH. Structural containment check on JSON objects; no async; no I/O in harness.
See `vp-016-graph-agent-tool-state-isolation.md` §Feasibility Assessment for complete analysis.

---

**VP-017 — LedgerChannel Dedup-Idempotent Append** (`graph::channels`) `proptest P1 Phase 3`

Property: For any sequence of `reduce` operations on a `LedgerChannel<T>`, reducing with an entry
whose `entry_id()` is novel appends the entry; reducing with an entry whose `entry_id()` already
exists in the ledger is a no-op. The accumulated `Vec<T>` contains entries in first-appearance order.

Formal statement:
```
∀ entries: Vec<T>,
  let ledger: Vec<T> = entries.iter().fold(Vec::new(), |acc, e| LedgerChannel::reduce(acc, e.clone())):

  ledger.len() == count_distinct_entry_ids(entries)
  ∧ ∀ i < ledger.len():
      ledger[i].entry_id() == first_occurrence_id(entries, i)
```

where:
- `count_distinct_entry_ids(entries)` = `entries.iter().map(|e| e.entry_id()).collect::<HashSet<_>>().len()`
- `first_occurrence_id(entries, i)` is the `entry_id` of the `i`-th entry (in first-appearance
  order) in `entries`

`LedgerChannel::reduce` is a pure function: `fn reduce(acc: Vec<T>, update: T) -> Vec<T>`.
No mutable state; no constructor; no `.value()` accessor — the `Vec<T>` accumulator is
threaded through `fold` and is the direct output of the harness.

**Why proptest (not Kani):** `LedgerChannel::reduce` is a pure function over an internal collection.
The dedup invariant ranges over arbitrarily-long `Vec<T>` inputs. Kani's bounded model-checking
is tractable for bounded-state machines and arithmetic but is not the right tool for collection
invariants over variable-length sequences — proptest generates `Vec<TestEntry>` with a small-alphabet
ID set to force frequent collision/dedup events, covering all three invariant branches with high probability.
Consistent with VP-007, VP-008, VP-014, VP-016 which are all proptest for collection/sequence invariants.

**Proptest harness:** See `vp-017-ledger-channel-append-dedup.md` §Proof Harness Skeleton for the complete harness.
Harness function: `ledger_channel_dedup_idempotency`. Strategy: `Vec<TestEntry>` (0..20 entries, IDs from alphabet `[a-e]`).
Three assertions: `ledger.len() == distinct_ids.len()`, no duplicate `entry_id`s, first-appearance order matches input.

Feasibility: HIGH. Pure reducer function with no I/O or async. Small-alphabet ID generation ensures
high collision probability. All three invariant branches exercised in a single proptest function.
See `vp-017-ledger-channel-append-dedup.md` §Feasibility Assessment for complete analysis.

---

**VP-018 — TrajectoryCompactor Retention Integrity** (`checkpoint::trajectory`) `proptest P1 Phase 3`

Property: For any trajectory of N records with ascending `step_idx` values, and any
`TrajectoryRetentionPolicy` designating a subset as retained: (1) after `compact(run_id, policy)`
returns `Ok(())`, every retained record appears in `replay(run_id)` with its original `step_idx`
and `payload` unchanged — no retained record is removed or mutated ({INV-001}); (2) retained records
appear in strictly ascending `step_idx` order in the post-compaction replay sequence — the retained
sub-sequence preserves relative position ({INV-002}). {INV-003} crash-isolation (SQLite atomic
transaction) is scoped to integration tests and is not covered by this proptest.

Formal statement:
```
∀ records: Vec<TrajectoryRecord> (ascending step_idx), policy: TrajectoryRetentionPolicy:
let retained = records.filter(|r| !policy.is_eligible(r));
let post     = compact_and_replay(records, policy);  // Ok(post) branch
  post.len() == retained.len()
  ∧ ∀ i < post.len(): post[i].step_idx == retained[i].step_idx ∧ post[i].payload == retained[i].payload
  ∧ ∀ i in 1..post.len(): post[i].step_idx > post[i-1].step_idx
```

**Why proptest (not Kani):** The retention-integrity property ranges over variable-length
`Vec<TrajectoryRecord>` inputs — not tractable for Kani's bounded model checking. Additionally,
`TrajectoryCompactor::compact` is async (SQLite backend I/O); Kani 0.67.0 has no native async
support. The pure-core record-selection and ordering logic is extracted into an in-memory sync
model for proptest verification. {INV-003} depends on SQLite `BEGIN IMMEDIATE` / `COMMIT`
OS-level crash-recovery semantics, which cannot be modeled by proptest or Kani — covered by
VP-019 integration test (BC-2.04.011 TV-002 + EC-001).

**Proptest harness:** See `vp-018-trajectory-compaction-retention-integrity.md` §Proof Harness Skeleton.
Harness function: `trajectory_compaction_retention_integrity`. Strategy: `n_records in 0..=20`,
`retention_frontier_frac in 0.0..=1.0`, `promote_frac in 0.0..=0.5` (derives `TrajectoryRetentionPolicy`).
Oracle: `r.step_idx >= retention_frontier || promoted.contains(&r.step_idx)` (semantic definition,
independent code path from `is_eligible`). Negative mutation test: `compact_in_memory_buggy`
uses `<=` instead of `<` for frontier; asserts buggy result diverges from correct result (round-50
harness rework per F-P2A209-02; independent oracle confirmed non-tautological).

Feasibility: HIGH. The pure-core selection/filtering logic of `TrajectoryCompactor` is
deterministic and sync. In-memory proptest model covers all path branches: empty trajectory,
all-retained identity, frontier-only retained, partial compaction. No async I/O or OS-level
crash semantics required. Phase 3 concurrent with the story implementing `checkpoint::trajectory`.

---

**VP-019 — Trajectory Compaction Crash Isolation** (`checkpoint::trajectory`) `integration P1 Phase 6`

Property: After a SIGKILL delivered at any point during `TrajectoryCompactor::compact`
under the per-run single-transaction DELETE model (ADR-030 §Compaction Atomicity Decision,
F-P2A234-01 redesign), a subsequent `TrajectoryReader::replay(run_id)` returns the expected
trajectory state — never a partially-compacted or corrupted result (BC-2.04.011 {INV-003}).

The two crash points in the per-run DELETE model:

- **(1) before-commit** — SIGKILL before the `BEGIN IMMEDIATE` / `DELETE` / `COMMIT`
  transaction commits; SQLite WAL atomicity discards uncommitted frames on next database open;
  replay returns the complete pre-compaction record set (same as if compact never ran).
- **(2) after-commit** — `COMMIT` has durably landed; eligible records have been removed;
  replay returns the retained set (`step_idx >= retention_frontier` OR in `promoted`).

Formal statement:
```
∀ run_id, pre_records: Vec<TrajectoryRecord> (committed),
  policy: TrajectoryRetentionPolicy,
  crash_point ∈ {before_commit, after_commit}:

  let expected = match crash_point {
    before_commit => pre_records,
    after_commit  => retained_set(pre_records, policy),
  };
  process_killed_at(crash_point) during compact(run_id, policy)
    → replay(run_id) after restart == expected
```
where `retained_set(records, policy)` denotes records whose `step_idx >= policy.retention_frontier`
or whose `step_idx` is in `policy.promoted`.

**Why integration test (not Kani or proptest):** SQLite WAL atomicity and SIGKILL crash
injection require a real database process and OS-level crash semantics. Neither Kani (no OS
I/O) nor proptest (in-process, no crash semantics) can model this. The integration test:
(1) inserts pre-compaction records for target run_id; (2) starts compaction;
(3) sends SIGKILL at two crash points (TV-002 two-case matrix); (4) restarts;
(5) asserts `replay` returns the expected state per crash-point semantics.

> **Directive completed (round-62):** VP-019.md body updated to the two-crash-point per-run DELETE model per ADR-030 §Compaction Atomicity Decision (F-P2A234-01).

See `vp-019-trajectory-compaction-crash-isolation.md` for the complete integration test outline.
**Phase 6** — requires a running SQLite-backed `TrajectoryCompactor` (Phase 3 deliverable).

---

**VP-020 — PromoteRetireChannel Idempotency** (`graph::channels`) `proptest P1 Phase 3`

Property: For any arbitrary sequence of `Promote`/`Retire` operations reduced via
`<PromoteRetireChannel<T> as Channel>::reduce` into a `Vec<T>` active set, the resulting
active set satisfies five invariants (BC-2.02.009 {INV-001}+{INV-002}, DI-001):
(1) no duplicate `entry_id` in the active set ({INV-001}); (2) the reducer is deterministic —
fold-from-empty-twice yields an identical `Vec<T>` ({INV-002}); (3) re-`Promote` of an
already-present `entry_id` is a no-op ({PC-002}); (4) `Retire` of an absent `entry_id` is a
no-op ({PC-004}); (5) operation order is deterministic — `Promote(a)` then
`Retire(a.entry_id())` leaves `a` absent, and `Retire(a.entry_id())` then `Promote(a)`
leaves `a` present (BC-2.02.009 EC-003/EC-004).

Formal invariants:
- **{INV-001}:** The active set contains no duplicate `entry_id` values at any time — the `Vec<T>` accumulator never holds two entries with the same `entry_id()`.
- **{INV-002}:** Given the same operation sequence applied to an identical starting state, the reducer always produces an identical active set — deterministic output under task-identity ordering (reducer determinism).

Formal statement:
```
∀ ops: Vec<PromoteRetireOp<T>>,
  let active: Vec<T> =
    ops.iter().fold(Vec::new(), |acc, op| PromoteRetireChannel::reduce(acc, op.clone())):

  // (a) {INV-001}: no duplicate entry_id in the active set
  active.iter().map(|e| e.entry_id()).collect::<HashSet<_>>().len() == active.len()

  // (b) {INV-002}: determinism — fold from empty twice yields an identical Vec
  ∧ ops.iter().fold(Vec::new(), |acc, op| PromoteRetireChannel::reduce(acc, op.clone())) == active

  // (c) Promote is dedup-idempotent: re-Promote of a present entry_id is a no-op ({PC-002})
  ∧ ∀ e: T where active.iter().any(|x| x.entry_id() == e.entry_id()):
      PromoteRetireChannel::reduce(active.clone(), PromoteRetireOp::Promote(e)) == active

  // (d) Retire is idempotent: Retire of an absent entry_id is a no-op ({PC-004})
  ∧ ∀ id: String where !active.iter().any(|x| x.entry_id() == id):
      PromoteRetireChannel::reduce(active.clone(), PromoteRetireOp::Retire(id)) == active

  // (e) order-sensitivity (deterministic per DI-001 task-identity order)
  ∧ reduce(reduce(Vec::new(), PromoteRetireOp::Promote(a)),
           PromoteRetireOp::Retire(a.entry_id().to_owned())) == Vec::new()   // absent
  ∧ reduce(reduce(Vec::new(), PromoteRetireOp::Retire(a.entry_id().to_owned())),
           PromoteRetireOp::Promote(a)) == vec![a]                            // present
```
where `PromoteRetireOp<T>` is a `#[non_exhaustive]` enum with variants `Promote(T)` (carries
the full entry `T: LedgerEntry`) and `Retire(String)` (the `entry_id` to remove).
`PromoteRetireChannel::reduce` is a pure function
`fn reduce(acc: Vec<T>, update: PromoteRetireOp<T>) -> Vec<T>` — no mutable state,
no constructor. Authoritative definition: ADR-030 §Decision 3 (code block); formal invariant documented in vp-020-promote-retire-channel-idempotency.md.

**Why proptest (not Kani):** The set of `entry_id` values and op sequences is unbounded;
collection invariants over variable-length sequences are not tractable for Kani's bounded model
checking. proptest generates `Vec<PromoteRetireOp<T>>` with a small-alphabet `entry_id` set
to force frequent dedup / idempotent-retire / order-swap events, exercising all five properties
with high probability. Consistent with VP-017 (LedgerChannel dedup-idempotency).

Feasibility: HIGH. `reduce` is a pure synchronous function (no async, no I/O). Phase 3 —
same wave as `PromoteRetireChannel` implementation under BC-2.02.009.

See `vp-020-promote-retire-channel-idempotency.md` for the complete harness specification.

## Test-Sufficient (No Kani)

Modules where behavioral testing is the primary verification method:

| Module | Reason | Tools |
|--------|--------|-------|
| pregolya-server | I/O-bound; Kani not applicable | Integration, PropTest for request schema |
| pregolya-openai | Network I/O; testing via DTU fakes | Integration |
| pregolya-anthropic | Network I/O; testing via DTU fakes | Integration |
| pregolya-ollama | Network I/O; testing via DTU fakes | Integration |
| pregolya-mcp | Transport I/O + Red Gate behavioral tests | Integration, Red Gate |
| pregolya-splitters | Pure but no formal invariant; golden-vector parity sufficient | Unit, PropTest |
| pregolya-sandbox | OS-level execution; not Kani-tractable (path_guard excluded — covered by VP-003 Kani P0 above) | Integration |
| `graph::budget` | Append-only ordering (EvidenceJournal); soak tests cover most cases | Unit, Soak |
| `graph::provenance` | DI-012 RAGRetrieval boundary enforced via GuardedDocuments compile_fail (ADR-014 Decision 6; VP-2.20.002-A); hook dispatch coverage is behavioral; not state-machine | compile_fail, Unit, Integration |

## Fuzzing Targets (BC-2.17.002)

| Target | Crate | What is fuzzed | Priority |
|--------|-------|----------------|---------|
| Checkpoint serialization round-trip (`fuzz_checkpoint_serde`) | pregolya-checkpoint | msgpack ↔ GraphState round-trip; no data loss | P0 |
| Graph-engine boundary inputs (`fuzz_graph_execution`) | pregolya-graph | Malformed GraphConfig; out-of-range node indices | P0 |

> Non-normative: Splitter robustness (R8 Unicode parity) is covered by proptest + the GTV Red Gate suite (BC-2.07.002), not cargo-fuzz, in v1; a splitter fuzz target is a candidate post-v1 addition requiring BC-2.17.002 + coverage-matrix updates in the same burst (gate #25/#32 discipline).

## Risk Mitigations

| Risk | Impact | Architecture Mitigation |
|------|--------|------------------------|
| R10 (NamedBarrierValue missing writer) | HIGH | VP-001 scope includes BarrierValue reducer; Red Gate BC-2.02.003 |
| R8 (code-point parity) | HIGH | Golden-vector parity test in pregolya-splitters; Red Gate BC-2.07.002 |
| R11 (MCP upstream test voids) | MEDIUM | Red Gate BCs BC-2.09.004 / BC-2.09.005 enforce type-identity behavior |
| NE-17 nondeterminism | HIGH | VP-001 Kani proof eliminates the class of bugs |
| NE-12 session collapse | HIGH | VP-002 Kani proof makes cross-tenant isolation machine-checked |
| NE-02 path traversal | HIGH | VP-003 Kani proof covers all symbolic path inputs |

## Changelog

| Version | Date | Author | Decision | Change |
|---------|------|--------|----------|--------|
| 2.47 | 2026-09-08 | architect | D-356/DC-20/2026-09-08 | F-PDC20-01+O-PDC20-A — 5 DI-column re-anchors: VP-2.24.005-A/B DI-002→DI-004 (step_idx ordering + fork lineage → DI-004); VP-2.24.006-A/B DI-014→DI-003 (approve/deny dispatch + FIFO ordering → DI-003); VP-2.24.008-A DI-014→DI-012 (complete Fail/Transform feed → DI-012). BCs source of truth. Census UNCHANGED: 41 total. POL-2 orphan closure: DI-003/DI-004/DI-012 each ≥1 VP. |
| 2.46 | 2026-09-08 | architect | D-356/DC-19/2026-09-08 | F-PDC19-02 — VP-2.24.003-C module repointed server::debug_routes → graph::descriptor (BC-2.24.003 §VP table source of truth; start-node-always-present property targets graph::descriptor/pregolya-graph). VP-2.24.003-B module already correct. Census UNCHANGED: 41 total. |
| 2.44 | 2026-09-07 | architect | D-356/DC-07/2026-09-07 | F-PDC07-03 — 10 panel-VP Module cells repointed to canonical SPA component path form: spa/components/run_inspector (VP-2.24.004-A/B), spa/components/checkpoint_panel (VP-2.24.005-A/B), spa/components/hitl_panel (VP-2.24.006-A/B), spa/components/budget_panel (VP-2.24.007-A/B), spa/components/guardrail_panel (VP-2.24.008-A/B). CORRECTION: v2.41 (DC-02) used console::* Rust module notation — non-canonical for SPA components. Canonical convention: spa/components/<component_name> path form. Census UNCHANGED: 41 total. |
| 2.43 | 2026-09-07 | architect | D-356/DC-04/2026-09-07 | F-PDC04-04 — VP-2.24.002-A/B module repointed console::span_exporter → console::ring_buffer (canonical Pure Core for RingBuffer<T> per ADR-031 Decision 5 DC-04 split). VP-2.24.002-C (server::debug_routes) and VP-2.24.002-D (console::span_exporter sanitization) unchanged. Census UNCHANGED: 41 total. |
| 2.42 | 2026-09-07 | architect | D-356/DC-02-addendum/2026-09-07 | VP-2.24.002-D registered — SpanData SEC-BOUND-001 sanitization before ring-buffer insertion (unit P1; console::span_exporter; BC-2.24.002; DI-014). Sanitization location: AT INSERTION (stricter than BC PC-008 'before serving'; ensures ring buffer never holds unsanitized llm_request/llm_response/attributes). Census 40→41; unit ×7→×8; P1 34→35. Preamble Forty→Forty-one. |
| 2.41 | 2026-09-07 | architect | D-356/DC-02/2026-09-07 | F-PDC02-02+F-PDC02-03 — VP-2.24.002-A/B module repointed console::ring_buffer → console::span_exporter (ADR-031 Decision 5 canonical). VP-2.24.004-008 A/B module columns corrected from console::server to SPA panel modules: console::run_inspector (004-A/B), console::checkpoint_panel (005-A/B), console::hitl_panel (006-A/B), console::budget_panel (007-A/B), console::guardrail_panel (008-A/B). Tool census UNCHANGED: Kani ×10, proptest ×10, integration ×12, unit ×7, compile-fail ×1 (40 total VPs). |
| 2.40 | 2026-09-06 | architect | D-356/DC-01/2026-09-06 | F-PDC01-03+F-PDC01-04 — VP-2.24.002-A/B repointed to console::ring_buffer / pregolya-console (RingBuffer<SpanData> Pure Core; ADR-031 Decision 5 + S-console-02). Tool reconciled vs BC Proof Methods for 8 rows: 001-A/B integration/proptest→unit; 001-C integration→compile-fail; 002-B integration→proptest (module/crate also fixed); 003-A proptest→unit; 003-C integration→unit; 007-A integration→unit; 008-B integration→unit. Total: proptest ×10, integration ×12, unit ×7, compile-fail ×1 (40 VPs total unchanged). |
| 2.39 | 2026-09-06 | architect | D-356/2026-09-06 | F3 — 19 VP-2.24.* placeholder rows added to Provable Properties Catalog for SS-24 Developer Console (BC-2.24.001–008). Tool breakdown: integration ×15, proptest ×3, Kani ×1. All P1, draft, Phase 3 except VP-2.24.003-B (Kani Phase 6). Total 21→40 VPs; P1 15→34; Kani 9→10; proptest 8→11; integration 3→18; unit unchanged at 1. Preamble narrative twenty-one→forty. |
| 2.38 | 2026-09-01 | architect | round-65/F-P2A237-02 | §VP-020 narrative corrected to canonical VP-020.md (source-of-truth per CLAUDE.md rule 4): (a) property description rewritten from apply-twice-idempotency to five-property statement ({INV-001} no-duplicate, {INV-002} reducer-determinism, {PC-002} promote-dedup-idempotent, {PC-004} retire-idempotent, order-sensitivity); (b) {INV-001} gloss corrected from promote-dedup-no-op description to 'the active set contains no duplicate entry_id values at any time'; (c) formal statement replaced from non-canonical apply_ops-twice form with VP-020.md §Formal Invariant five-property form; (d) op shape corrected from Promote(id)/Retire(id) to PromoteRetireOp::Promote(T) / Retire(String) per VP-020.md §Formal Invariant and ADR-030 §Decision 3. input-hash updated 8837490→721a6e7. |
| 2.37 | 2026-09-01 | architect | round-63/F-P2A235-03+F-P2A235-08 | §VP-019 stale completed-directive blockquote deleted — replaced with one-line completed note; VP-019.md is at the two-crash-point per-run DELETE model (v1.4); live directive was incorrect. §VP-020 formal invariants {INV-002} bullet corrected from retire-idempotency gloss to reducer-determinism ({INV-002} is REDUCER DETERMINISM — deterministic output under task-identity ordering; {PC-004} is Retire idempotency). |
| 2.36 | 2026-09-01 | architect | round-62/F-P2A234-05 | VP-020 added — PromoteRetireChannel idempotency proptest P1 (BC-2.02.009 {INV-001}+{INV-002}; graph::channels; pregolya-graph; DI-001; Phase 3; harness promote_retire_channel_idempotency). Structurally analogous to VP-017; closes BC-2.02.009 unit-test-only gap. VP-019 §Should Prove description updated to two-crash-point per-run DELETE model. Committed VP Obligations table: VP-020 row added; total 20→21 VPs; proptest 7→8. Preamble narrative twenty→twenty-one. |
| 2.35 | 2026-09-01 | architect | round-57/F-P2A228-01 | §VP-017 §Provable Properties Catalog formal statement rewritten to canonical pure-fold form — removed stale LedgerChannel::new() constructor and IndexSet oracle; replaced with fold accumulation form and HashSet oracle matching VP-017 body §Formal Invariant verbatim. |
| 2.34 | 2026-09-01 | architect | round-57/F-P2A227-02 | VP-019 §Property, §Formal statement, and §Why integration rewritten to the four-crash-point staging-table model (ADR-030 §Compaction Atomicity Decision). crash_point set: {before_build_begins, mid_build, mid_swap, after_swap_commit}. Cases 1–3 → pre-compaction state; case 4 (after_swap_commit) → post-compaction retained set. TV-002 matrix updated three-case → four-case. input-hash updated. |
| 2.33 | 2026-09-01 | architect | round-54/F-P2A224-02 | VP-017 DI anchor corrected DI-014 → DI-001 in preamble narrative and Provable Properties Catalog VP table row. input-hash refreshed. |
| 2.32 | 2026-08-31 | architect | round-50/F-P2A209-02+F-P2A209-03+F-P2A211-05 | VP-019 added: integration P1, Phase 6, `checkpoint::trajectory`, pregolya-checkpoint, BC-2.04.011 {INV-003}, DI-002. Covers OS-level SQLite atomicity under SIGKILL that VP-018 proptest explicitly excludes. VP-017 BC Anchor updated BC-2.02.007 → BC-2.02.007 + BC-2.02.008 (first-appearance ordering obligation). VP-018 §Should Prove description updated: proptest strategy updated to `TrajectoryRetentionPolicy` parameters + independent oracle + negative mutation test. Committed VP Obligations table: VP-017 anchor updated; VP-019 row added; total 19→20 VPs, P1 13→14, integration ×2→×3. §Section Content narrative updated (nineteen→twenty VPs). §Should Prove section: VP-019 entry added; VP-018 §should-prove references VP-019 for crash-isolation. input-hash updated. |
| 2.31 | 2026-08-31 | architect | BC-2.04.011 | VP-018 added: proptest P1, `checkpoint::trajectory`, pregolya-checkpoint, BC-2.04.011 {INV-001}, DI-002, `trajectory_compaction_retention_integrity`. Human-approved VP mint: {INV-001}+{INV-002} corollary coverage; {INV-003} crash-isolation scoped to integration tests. Committed VP Obligations table: add VP-018 row; update total 18→19 VPs, P1 12→13, proptest ×6→×7. §Section Content narrative updated (eighteen→nineteen VPs). §Should Prove section: add VP-018 entry. BC-2.04.011 added to inputs list. input-hash updated. |
| 2.30 | 2026-08-31 | architect | ADR-030 Stage 1 | VP-017 added: proptest P1, `graph::channels`, pregolya-graph, BC-2.02.007 (draft), DI-014, `ledger_channel_dedup_idempotency`. ADR-030 Decision 3 (LedgerChannel dedup-idempotency). Committed VP Obligations table: add VP-017 row; update total 17→18 VPs, P1 11→12, proptest ×5→×6. §Section Content narrative updated (seventeen→eighteen VPs). §Should Prove section: add VP-017 entry. BC-2.02.007 added to inputs list (draft; PO authors in Stage 2). input-hash pending (BC-2.02.007 not yet authored). |
| 2.29 | 2026-08-31 | architect | round-49/F-P2A205-02 | VP-015 §Should Prove section updated — `redact_credentials` pattern set expanded from 3 to 6 (adding Bearer token pattern 4, URL-embedded userinfo pattern 5, HTTP Basic auth pattern 6 per BC-2.09.007 {INV-003}(b) v2.5; CWE-522 closure). SEC-BOUND-001 steps-2+3 pipeline context documented (VP-015 covers step 2; step 3 non-VP-elevated per R38/F-P2A161-01-Option-B). Unit harness note updated to 7 test cases. VP catalog table UNCHANGED; VP count UNCHANGED: 17 total (6 P0 / 11 P1). input-hash updated: BC-2.09.007 input drift from v2.5 changes. |
| 2.28 | 2026-08-28 | architect | round-25/F-P2A108-02 | Normalize doubled-path notation in §VP-012 feasibility prose. One occurrence of `` `pregolya-core::core::budget` `` replaced with `` `pregolya-core (core::budget)` `` (matches ADR-023 §Required-Inventory parenthetical form). No VP catalog, coverage-matrix, or harness content changed. |
| 2.27 | 2026-08-27 | architect | round-16/F-P2A081-01 | VP-016 §Why proptest (not Kani): 'arbitrary `GraphState` instances with extra internal fields' → 'arbitrary `TestGraphState` instances (serialized as `serde_json::Value`) with extra internal fields' (F-P2A081-01 MED — `GraphState` is not a type/trait per ADR-029 §Symbol Grounding PHANTOM row; canonical harness struct is `TestGraphState`). input-hash updated to c3a2086. |
| 2.26 | 2026-08-27 | architect | round-14/F-P2A078-02+F-P2A078-03 | VP-016 §Property entry: 'fields from `GraphState S`' → 'fields from the non-generic `serde_json::Value` graph state'; 'the `ToolOutput` returned by a successful invocation' → 'the `serde_json::Value` returned by `invoke_dyn` on successful invocation' (F-P2A078-02 HIGH). VP-016 harness description: `VP-016.md` filename → `vp-016-graph-agent-tool-state-isolation.md` (canonical filename; F-P2A078-03 MED); TestGraphState fields `internal_checkpoint_id`/`intermediate_message`/`_internal_blob` → `checkpoint_id`/`run_id`/`accumulated_messages` (authoritative VP-016 harness; F-P2A078-03); 'Assertion: `ToolOutput` contains exactly' → 'Assertion: the `serde_json::Value` returned by `invoke_dyn` contains exactly'. input-hash updated to 18fa8b4. |
| 2.25 | 2026-08-26 | architect | round-6/F-P2A-065-07 | VP-006-B BC anchor corrected: `BC-2.18.004` → `BC-2.18.004 {PC-005}` in Committed VP Obligations table (VP-INDEX canonical anchor per VP-INDEX §VP Catalog row BC column). VP-006-B §Should Prove heading normalized: `injection_guard_fewshot Multi-Pair Fail-Closed` → `injection_guard Multi-Pair FewShotExamples` (matches VP-INDEX/VP-006-B.md canonical title form; F-P2A-065-07 OBS). input-hash updated. |
| 2.24 | 2026-08-26 | architect | SEC-review-adjudication | SEC-003: VP-006 Arm 2 multi-pair mandate — existing `n>=1&&n<=4` Kani harness provides symbolic proof covering multi-pair/middle/last-Untrusted scenarios; explicit mandate and VP-006-B proptest P1 added (arbitrary pair-count 2..=8 + arbitrary untrusted index; belt-and-suspenders). SEC-004: VP-006 future-variant proof obligation noted — adding a TrustLevel variant requires re-running cargo kani; VP-006 proves only currently-defined variants; runtime wildcard enforces fail-closed for any variant. Committed VP Obligations table: add VP-006-B row; totals 16→17, P1 10→11, proptest 4→5. §Section Content narrative updated. |
| 2.23 | 2026-08-26 | architect | E-code-correction | VP-016 BC anchor: {INV-001} corrected from stale {INV-STATE-ISOLATION} (stable BC-2.09.008 numeric anchor per product-owner). §Section Content narrative, Committed VP Obligations table, and VP-016 body all updated. v2.22 changelog row also corrected (same invariant tag). |
| 2.22 | 2026-08-26 | architect | GAP-01/ADR-029 | (1) D-273 VP-015 tool-type fix: `integration` → `unit` in Committed VP Obligations table and body (VP-015.md frontmatter is authoritative per CLAUDE.md rule 4). (2) VP-016 added: proptest P1, Phase 3, `mcp::graph_tool`, pregolya-mcp, BC-2.09.008 {INV-001}, DI-010 (ADR-029 GAP-01 resolution). Committed VP Obligations table: add VP-016 row; update total 15→16 VPs, P1 9→10, proptest 3→4, integration 3→2, unit 0→1. Section Content narrative updated (fifteen→sixteen VPs; VP-016 desc added). VP body sections: add VP-015 body and VP-016 body to §Should Prove. input-hash updated to df54145 (hook-computed after v2.21 edits; BC-2.09.008 added to inputs list). |
| 2.21 | 2026-08-26 | architect | architect-reconcile-burst | (1) VP-006 3-arm scope extension (v1.9): §VP-006 updated to document all 3 injection arms; added Arm 2 formal statement (few-shot) and `injection_guard_fewshot_fail_closed` Kani harness sketch; TV-006 Red Gate noted. (2) VP-015 added to Committed VP Obligations table: `mcp::sanitize`, integration P1, Phase 3, BC-2.09.007 {INV-003}, DI-010. Section Content narrative updated (fourteen→fifteen VPs). Total: 15 VPs — 6 P0 / 9 P1, Kani 9 + proptest 3 + integration 3. input-hash refreshed (57a7c93 from hook-computed value; BC inputs added by Burst B propagation). |
| 2.20 | 2026-08-21 | architect | INVESTIGATE-RECONCILE | VP-004 Module column: `mcp::adapter` → `mcp::exception` in Provable Properties Catalog table. Story S-2.10 creates no `adapter.rs`; VP-004 ToolException type-identity property targets `mcp::exception`. Arithmetic invariant unchanged: 14 VPs, 6 P0 / 8 P1, Kani 9 + proptest 3 + integration 2. |
| 2.19 | 2026-08-17 | architect | BURST-313 / F-P204-02 | VP-014 formal statement corrected: stale `new()` argument type `IndexMap<String, Arc<dyn DynRunnable>>` replaced with canonical `Vec<(String, Arc<dyn DynRunnable>)>` (iterator-of-pairs). IndexMap is the INTERNAL container built by `new()`, not the argument type (ADR-026 §Decision 1 / BC-2.01.005 PC1). Formal invariant rewritten: quantifier uses Vec-of-pairs, extracts `key_set` from pairs via iterator map-collect, derives `N = key_set.len()`. Adds clarifying comment that IndexMap is internal. Key-completeness property preserved. Source of truth: VP-014.md §Changelog (burst-311/OBS-P202-B). No §Decision 1/2 split required — arch block does not attribute JoinSet/concurrent execution to §Decision 1. Corpus sweep: only this site was a stale new()-arg; interface-definitions.md §RunnableParallel struct definition, BC-2.01.005 §Construction Preconditions, ADR-026 §Decision 1 are struct-field/internal-container usages (correct). |
| 2.18 | 2026-08-17 | architect | burst-308 / F-P200-02 | Category-axis reference correction in §VP-013 RESOLVED block. "(not present in the 12-category axis per ADR-010)" → "(not present in the 13-category axis per ADR-010)". Rationale: ADR-010 §Category Axis Expansion (D26) expanded the category axis from 12 to 13 (EXEC added) in this burst; CONFIGURATION has never been a valid category, pre- or post-D26 expansion. |
| 2.17 | 2026-08-17 | architect | burst-304 / F-P195-01 + F-P195-02 | VP-014 method-surface and module-path alignment (POL-9 propagation from VP-014.md). §VP-014 heading: `core::runnable::parallel` → `core::runnable` (canonical 2-level registry form; F-P195-02). §VP-014 property, formal statement, and rationale: `invoke_dyn` → `invoke` (three sites; F-P195-01). Canon: DynRunnable method is `invoke`/`stream`; `invoke_dyn`/`stream_dyn` belong to DynTool only (ADR-026 §Decision 5; interface-definitions.md §DynRunnable). |
| 2.16 | 2026-08-17 | product-owner | burst-302b / D-170 | Add VP-014 (proptest P1, BC-2.01.005 + BC-2.01.006, module core::runnable::parallel, crate pregolya-core, DI-016). LCEL composition scope expansion (D-170; ADR-026). VP-014 proves the RunnableParallel key-completeness property: for any N-branch RunnableParallel where invoke_dyn returns Ok(output), output.as_object().len() == N AND output key set == configured branch key set. Why proptest not Kani: invoke_dyn is async with Tokio JoinSet fan-out; Kani 0.67.0 has no native async support. §Section Content narrative updated (thirteen→fourteen). Committed VP Obligations table: add VP-014 row; update total line (13→14, P1 7→8, proptest 2→3). Should Prove section: add VP-014 entry. New BC inputs added: BC-2.01.005, BC-2.01.006. Input-hash updated (new inputs added). |
| 2.15 | 2026-08-16 | architect | FIX-BURST-291 / F-P1D182-01 + D-134 | Phantom §-anchor fixes in §VP-013 RESOLVED block and §VP-013 changelog row. Live-body: 'BC-2.23.005 §Category was corrected to' → 'BC-2.23.005 §Postconditions (PC-4) category corrected to'; 'BC-2.23.005 §Category = VAL' → 'BC-2.23.005 §Postconditions (PC-4) category = VAL'; 'error-taxonomy §TOOLS' → 'error-taxonomy.md §Component: TOOLS' (two sites: §VP-013 body line and §VP-013 Changelog row 2.11 '→' targets). Rationale: BC-2.23.005 has no §Category heading; category field lives in §Postconditions PC-4. error-taxonomy.md has no §TOOLS heading; real heading is §Component: TOOLS (pregolya-tools). |
| 2.14 | 2026-07-28 | architect | FIX-BURST-280 / F-P175-A24 companion | VP-008 section redesign to remove self-proving mock rationale. Prior §VP-008 stated "Mock embeddings implementation makes the contract hold by construction" — this perpetuated the F-P175-A24 defect (harnesses certifying mock internals, not production code). Replaced with description of `validate_embedding_batch` production function approach: mocks supply raw inputs only; production validator is the assertion target. Proptest sketch updated to call `validate_embedding_batch` directly. EC-003 and EC-004 negative harnesses (VP-008-D/E) noted. MockEmbeddings::new_fixed_dim(128) self-proving sketch removed. |
| 2.13 | 2026-07-27 | architect | CHECK4-vparch closure | Canonicalize all Module cells in §Committed VP Obligations table (13 rows) and §Test-Sufficient table (7 rows → 9 rows) to `crate::module` or ARCH-INDEX canonical crate-name form. VP table: replace all `pregolya-X / y-name` two-part notation — graph::bsp_engine, checkpoint::session_index, sandbox::path_guard, mcp::adapter, mcp::client, prompts::injection_guard, core::serializable (×2: VP-007 LcSerializable + VP-010 Reviver aspect), core::embeddings, vectorstores::similarity, graph::hitl, core::budget, tools::shell. VP-007 and VP-010 both map to core::serializable; aspect distinction preserved via BC Anchor (BC-2.19.001 vs BC-2.19.005), Tool (proptest vs Kani), Phase (3 vs 6), and Priority (P1 vs P0) columns — rows not merged. Test-Sufficient table: pregolya-server handlers → pregolya-server; Provider crates (unresolvable single mapping) → split into pregolya-openai + pregolya-anthropic + pregolya-ollama (3 rows); pregolya-sandbox backends → pregolya-sandbox with path_guard exclusion note; Budget governance (journal) → graph::budget; Content provenance/guardrail → graph::provenance. pregolya-mcp and pregolya-splitters already canonical — left unchanged. Section headings (VP-001..013 prose entries) updated to canonical form for consistency; VP-010 heading uses `core::serializable — Reviver aspect` to distinguish from VP-007. Total Module cells: 22 (was 20; +2 from Provider crates split into 3 rows). |
| 2.12 | 2026-07-27 | architect | FIX-BURST-276 / F-P173-501+503 | F-P173-501 — §VP-001 section: update formal statement from `sorts by task_id` to `sorts by (task_id: &str, channel_name: &str) lexicographic ascending`; add channel_name tiebreaker note and lexicographic hazard explanation; update harness sketch to use string TaskId and (TaskId, String, ChannelUpdate) tuple, replacing TaskId(i as u64) with bounded-string construction per VP-001.md §Proof Harness Skeleton. F-P173-503 — §VP-009 section: update formal statement to add overflow path (!norm.is_finite() covers +Inf from sum-of-squares overflow); update harness sketch conditional from (norm == 0.0) to (norm == 0.0 OR !norm.is_finite()); add overflow note. Source of truth for both: VP-001.md and VP-009.md §Proof Harness Skeleton respectively. |
| 2.11 | 2026-07-25 | architect | FIX-BURST-273 / F-P171a-10+11 | F-P171a-10 — replace §VP-013 Kani harness sketch (2 harnesses, missing `risk_floor_accepts_at_or_above_medium`) with pointer to `VP-013.md` §Proof Harness Skeleton; VP-013.md is authoritative per Source-of-Truth Precedence rule 4; pointer names all three canonical harnesses to eliminate drift surface. F-P171a-11 — de-pin two live-body version pins in §VP-013 RESOLVED block: 'BC-2.23.005 was amended to `Category::Val` (burst-232)' → 'BC-2.23.005 §Postconditions (PC-4) category corrected to `Category::Val`'; 'BC-2.23.005 category = VAL (burst-232)' → 'BC-2.23.005 §Postconditions (PC-4) category = VAL'. Allowlist entry for the BC-2.23.005 version-pin in verification-architecture.md (F-P171a-11 de-pin) is now dead — devops to remove. |
| 2.10 | 2026-07-25 | architect | FIX-BURST-272 / F-P170-05 sibling + DEFECT-2 | Purge phantom `ActionRisk::Critical` from §VP-013 body — sibling of VP-013.md F-P170-05 purge that verification-architecture.md missed. (1) Formal statement: remove `∨ r == Critical` disjunct. (2) `risk_floor_exhaustive_coverage` harness: `kani::assume(idx <= 4)` → `kani::assume(idx <= 3)`; `_ => ActionRisk::Critical` → `_ => ActionRisk::High`; assert message `"Medium/High/Critical must pass floor check"` → `"Medium/High must pass floor check"`. (3) Feasibility line: `5-variant enum` → `4-variant enum`. |
| 2.9 | 2026-07-25 | architect | FIX-BURST-270 / P1D-168-casing | PascalCase canon sweep — §VP-013 RESOLVED note: `` `Category::VAL` `` → `` `Category::Val` `` per ADR-010 v1.9 Direction B adjudication. |
| 2.8 | 2026-07-24 | architect | FIX-BURST-255 / F-P154-01 | F-P154-01 (HIGH) VP-011 internal contradiction + totality gap: adjudicate PendingHumanApproval routing design — Option A peel-off. PendingHumanApproval is handled by async `pre_tool_dispatch` wrapper BEFORE `route_pre_tool_decision` is called (interrupt issued; run suspended; `route_pre_tool_decision` not invoked). Fix property prose from "neither Proceed nor Reject returned" (impossible given DispatchOutcome type) to peel-off design. Fix formal statement: remove PendingHumanApproval clause from `route_pre_tool_decision` quantifier block; add wildcard arm clause (fail-closed Reject); add separate `pre_tool_dispatch` peel-off block. Fix `#[non_exhaustive]` note: "each proof function targets one variant" → "four proof functions target three routable variants (Deny/Approve/Edit) + hook-error; `PendingHumanApproval` has no dedicated proof function". Corresponds to VP-011.md v1.2→v1.3. |
| 2.7 | 2026-07-24 | architect | FIX-BURST-253 / F-P152-02 | VP-012 symbolic domain widening. Formal statement: `tokens_remaining ∈ (0, ceiling]` → `[0, ceiling]` (strict lower bound excluded the EC-002 boundary case that the burst-252 `<=` predicate change was meant to cover). Harness sketch: removed `tokens_remaining > 0` from multi-condition assume; u64 guarantees ≥ 0 by type. Added IN-domain comment. |
| 2.6 | 2026-07-24 | architect | FIX-BURST-252 / F-P151-04+05 | VP-012 predicate + precision corrections. (1) F-P151-04: `<` → `<=` in VP-012 Property Statement, Formal Statement, harness expected expression, and core-budget sync-core line. Non-strict `<=` is required: with strict `<`, condition `tokens_remaining/ceiling < 0.0` can never be true (remaining≥0), so fraction=1.0/remaining=0 would never fire (contradicts BC-2.10.005 EC-002). (2) F-P151-05: `fraction: f32` → `fraction: f64` throughout VP-012 section (Property Statement, Formal Statement, harness). `f64` is the adjudicated type (interface-definitions §Compaction already used f64; f64 avoids precision issues for budgets >16M tokens). `watermark_boundary_does_not_fire` harness renamed `watermark_boundary_fires` (with `<=`, exactly-at-threshold now fires). Feasibility note updated: CBMC tractability bound 2^24 retained, rationale changed from f32-precision to state-space-only. |
| 2.5 | 2026-07-24 | architect | FIX-BURST-250 / F-P149-01 | F-P149-01 (HIGH, architect half) de-pin volatile ADR version: VP-009 Feasibility note `ADR-014 v1.2 §Hardening note` → `ADR-014 Decision 2 §Hardening note` (TD-VSDD-091 per D18-P84-A: live-body citations use stable section anchors, not version pins). Sibling sweep (F-P149-03): VP-006 heading updated from `` `Kani P1 Phase 6` `` to `` `Kani P1 Phase 6` `red_gate: true` `` — parity with VP-009 and VP-010 headings (both carry `` `red_gate: true` ``). |
| 2.4 | 2026-07-24 | architect | FIX-BURST-248 / F-P147-01 | F-P147-01 (HIGH) red_gate adjudication: VP-011 entry heading corrected — remove stale `red_gate: true` label. BC-2.05.007 is NOT Red-Gated (product-owner authority: BC-2.05.007 red_gate: false, burst-231; ADR-018 Decision 3 contains no compile-and-fail mandate; fabricated red_gate_source removed in VP-011 v1.1). Heading updated from `` `Kani P0 red_gate: true` `` to `` `Kani P0` ``. Red Gate census: 11 (unchanged). |
| 2.3 | 2026-07-24 | architect | burst-247 / F-P146-01 | F-P146-01 (HIGH) VP-011 catalog correction: rewrite formal statement, prose, and harness sketch to match authoritative 4-variant `#[non_exhaustive]` PreToolDecision model (Approve/Deny/Edit/PendingHumanApproval per BC-2.05.007 PC1–PC4 + VP-011.md + interface-definitions). Removes stale two-variant exhaustive claim and "(no other variant exists; enum is exhaustive)" line. Fixes wrong Proceed-reachability prose (Approve-only → Approve AND valid Edit per PC-3). Replaces non-compiling `kani::any()` two-arm match with four concrete proof functions (deny_excludes_tool_invocation, approve_reaches_tool_invocation, hook_error_resolves_to_deny_and_reject, edit_invalid_args_falls_back_to_deny) mirroring VP-011.md §Proof Harness Skeleton. Fixes feasibility "2-variant" → "4-variant #[non_exhaustive]". Coherence sweep of 12 remaining VP catalog entries (OBS-P146 process-gap follow-up) found 4 additional harness-target divergences fixed in same burst: VP-001 `reduce_deterministic`→`reduce_super_step` + `sort_and_reduce`→`reduce_super_step` in formal statement; VP-003 harness `canonicalize_beneath_root`→`canonicalize_beneath_root_pure`; VP-006 SlotVar `trust_policy`+`value` fields→`policy` (no value field, `is_some_and(t.is_untrusted())` predicate per VP-006.md); VP-007 `lc_serialize()`/`lc_deserialize()`→`serialize()`/`Reviver::new().revive()`. TD-VSDD-060 sibling sweep: all PreToolDecision claims in architect-owned files (module-decomposition, purity-boundary-map, api-surface) verified correct (4-variant model already present); domain-spec + PO-owned files not modified. Input-hash updated: fb6e588→fd27b6d. |
| 2.2 | 2026-07-22 | architect | burst-233 / F-P133-06 | F-P133-06 sibling sweep: resolve stale BC-2.23.005 Category::CONFIGURATION contradiction note in §VP-013 property body. Note was "routed to PO for amendment"; BC-2.23.005 was amended to `VAL` in burst-232 (v1.1) — contradiction is now closed. Note updated to RESOLVED status, consistent with error-taxonomy v1.31 and VP harness. No VP catalog or coverage-matrix changes. |
| 2.1 | 2026-07-22 | architect | burst-232 / D23 | D23 VP layer: add VP-011..013 (Kani P0/P1) to Committed VP Obligations table and Provable Properties Catalog. VP-011 (graph::hitl, P0): PreToolCallHook fail-closed dispatch. VP-012 (core-budget, P1): OnWatermark arithmetic. VP-013 (tools-shell, P1): BashTool risk floor. Total 10→13 VPs; P0 5→6; P1 5→7; Kani 6→9. Add BC-2.05.007/2.10.005/2.23.005 to inputs; decisions D17/D21 → D17/D21/D23. Input-hash refresh pending. |
| 2.0 | 2026-07-21 | architect | burst-227 / F-P132-03 | VP-006 Feasibility section: `ProvenanceTag: 3 variants` → `TrustLevel: 3 variants` (ProvenanceTag is a struct with Uuid field, not an enum; TrustLevel is the Kani input). Propagates VP-006.md v1.4 residue sweep. |
| 1.9 | 2026-07-21 | architect | burst-226 / F-P131-05 | VP-006 section corrected: replace nonexistent `ProvenanceTag::External \| ProvenanceTag::ToolOutput` variants with `TrustLevel::Untrusted` (SS-18-local trust classifier per ADR-015 v1.3); fix error code `E-INJ-001` → `E-TMPL-001` (SECURITY/InjectionAttempt). Formal statement, harness sketch, and explanatory note updated throughout. `TrustLevel` is distinct from `core::guardrail::ProvenanceTag` (SS-11 ingress struct). `SlotVar.tag` field renamed to `SlotVar.trust_level` in harness. |
| 1.8 | 2026-07-21 | architect | burst-225 / F-P130-05 | Correct VP-006 DI column in Committed VP Obligations table: DI-008 → DI-014. VP-006 proves the fail-closed property (injection detected → Err returned, no PromptValue produced); the semantically correct invariant is DI-014 (Error Propagation / No Silent Swallowing), not DI-008 (Library Constructor Result Contract). Siblings VP-009 and VP-010 both anchor DI-014 for the same class of proof. Propagates VP-INDEX.md v1.4 and VP-006.md v1.2 corrections. |
| 1.7 | 2026-07-21 | architect | burst-224 / VP-chain propagation | VP-010 formal statement scoped to non-monolith domain (id ∉ LANGCHAIN_MONOLITH_TYPES) per VP-010.md v1.1 / F-P129-04; harness sketch updated with LANGCHAIN_MONOLITH_TYPES assumption and corrected assertion; feasibility note updated. Test-Sufficient 'Content provenance/guardrail' row updated to reflect GuardedDocuments compile_fail mechanism (ADR-014 Decision 6 / VP-2.20.002-A). Input-hash refreshed: b279860 → d7ef822 (BC-2.18.004 v1.1 + BC-2.19.005 v1.1 bumped by PO in same burst). |
| 1.6 | 2026-07-21 | architect | burst-224 / F-P129-11 | VP-009 module renamed from `pregolya-vectorstores / vectorstores-mmr` to `pregolya-vectorstores / vectorstores-similarity` in Committed VP Obligations table and VP-009 P0 entry; propagates VP-INDEX v1.3 module rename. cosine_similarity is a shared primitive in vectorstores::similarity; MMR algorithm is a separate caller. |
| 1.5 | 2026-07-21 | architect | burst-223 / D21 | VP layer for D21 ecosystem-parity expansion: add VP-006..010 (3 Kani P1/P0 + 2 proptest P1) to Committed VP Obligations table and Provable Properties Catalog. Total 5→10 VPs; P0 3→5; P1 2→5; Kani 3→6; proptest 0→2. Add SS-18..22 BCs to inputs. |
| 1.4 | 2026-07-19 | architect | burst-118 / F-P115-01 | checkpoint::clock sync-core mandate rewritten to reflect ADR-005 rev-2 stateless design. Replaced "(monotonic AtomicU64 read) — sync increment and compare" with "pure `get_next_version(current)` successor function; stateless, no atomic counter". No VP or coverage-matrix changes — VP-002 target is checkpoint::session_index; checkpoint::clock is not a direct VP target. |
| 1.3 | 2026-07-17 | architect | burst-169 / D18-P88-A | Formal version bump deferred from burst-169 (prd v1.2 cascade): timestamp advanced to 2026-07-17 in that burst; validate-changelog-monotonicity blocked the bump because no committed changelog baseline existed. Burst-169 now committed (1a915c6). Same-day provenance amendment (D18-P88-A): removed forbidden live-index input BC-INDEX.md; replaced with the six stable versioned BC files the document actually derives from (BC-2.03.001 VP-001 anchor, BC-2.04.006 VP-002 anchor, BC-2.13.004 VP-003 anchor, BC-2.09.004 VP-004 anchor, BC-2.09.005 VP-005 anchor, BC-2.17.002 fuzzing-targets authority); input-hash recomputed 270a1de → 8091abc. No spec content changes. |
| 1.2 | 2026-07-15 | architect | D18-P63-A | Removed outlier "Splitter inputs" row from §Fuzzing Targets per BC-2.17.002 authority (two targets only: fuzz_checkpoint_serde + fuzz_graph_execution); added named harness IDs to remaining rows; added non-normative note directing splitter robustness to proptest + BC-2.07.002 Red Gate suite with post-v1 fuzz candidacy. Coverage-matrix already shows splitter fuzz = — (no matrix edit required). |
| 1.1 | 2026-07-14 | architect | D18-P38-A | Fixed stale VP count in §"Committed VP Obligations": intro line changed from "Three VPs" to correctly enumerate five total (three Kani D17-Q7/NFR-003 + two integration R11); heading updated from (D17-Q7) to (D17-Q7 + R11) for mutual coherence with table and total line |
| 1.0 | 2026-07-14 | architect | D17 | Initial verification architecture with Kani async constraint, VP catalog, purity boundaries, and risk mitigations |
