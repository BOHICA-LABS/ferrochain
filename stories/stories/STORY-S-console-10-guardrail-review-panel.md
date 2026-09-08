---
document_type: story
level: ops
story_id: S-console-10
epic_id: E-console
version: "1.2"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — guardrail/security decision review panel, Fail/Transform filtering, DI-012 completeness, F-P99-01 Pass-not-shown."
  - "1.1 (D-356/2026-09-07, story-writer): DC-03 adversary fix — corrected BC-2.24.008 wire field/enum names in AC-002, EC-003, and Forbidden Patterns: boundary_type→boundary, BoundaryType→IngressBoundary, RAGRetrieval→RagChunk, MemoryIngress→MemoryItem, GuardrailSeverity→GuardrailSeverityWire; clarified Transform carries severity=None AND reason=None."
  - "1.2 (D-356/DC-29/2026-09-08, story-writer): F-PDC29-01 — AC-004 + AC-005 + Task 4 + File Structure corrected for ADR-031 Decision 8: completed-run reconstruction uses evidence_journal from run-read, not stored event list (StreamEvent is transient)."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.008.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "ca02ba8"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-06]
blocks: []
behavioral_contracts: [BC-2.24.008]
verification_properties: [VP-2.24.008-A, VP-2.24.008-B]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24, SS-11]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-10: Guardrail/Security Decision Review Panel

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-03 (2026-09-07, story-writer).** BC-2.24.008 v1.3 boundary field/enum correction propagated to story body per bc_array_changes_propagate_to_body_and_acs. Corrected: `boundary_type`→`boundary`, `BoundaryType`/`ProvenanceTag`→`IngressBoundary`, `RAGRetrieval`→`RagChunk`, `MemoryIngress`→`MemoryItem`, `GuardrailSeverity`→`GuardrailSeverityWire`; clarified that `Transform` carries both severity=`None` and reason=`None` (not just no reason). Affected locations: AC-002, EC-003, Forbidden Patterns. Traceability: guardrail-output subsystem postcondition PC-002 GuardrailDecision bullet (source of truth for wire field names) + ADR-006 §Decision (IngressBoundary enum definition).

> **D-356 adversary fix DC-29 (2026-09-08, story-writer).** F-PDC29-01 — AC-004, AC-005, Task 4, File Structure corrected for ADR-031 Decision 8. StreamEvent is transient; there is no stored StreamEvent list for completed-run reconstruction. The guardrail security feed for terminal-status runs reconstructs from the `evidence_journal?` field on the run-read endpoint. AC-005 completeness invariant updated: "SSE stream or stored event list" → "live SSE stream (in_progress) or evidence_journal reconstruction (terminal-status)". Live (in_progress) SSE path (AC-003) is unchanged.

## Narrative

- **As a** developer-operator or SOC analyst reviewing agent behavior on untrusted inputs
- **I want to** see a dedicated security feed showing all guardrail Fail and Transform decisions for a run
- **So that** I can quickly identify which boundaries fired, why they fired, and what the severity was — without manually filtering the full event timeline

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.008 | Guardrail/Security Decision Review Panel (CAP-047) | AC-001..AC-008 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.008 postcondition PC-001)
The security feed panel displays ONLY `guardrail_decision` StreamEvents where the outcome is `Fail` or `Transform`. Pass decisions are NOT shown — they are not streamed by the server (F-P99-01 design per ADR-006 rev-3) and the console must not attempt to fetch or display them from any source. Verified by `test_BC_2_24_008_only_fail_transform_shown()` (VP-2.24.008-A).

### AC-002 (traces to BC-2.24.008 postcondition PC-002)
Each entry in the security feed shows: `boundary` (an `IngressBoundary` value — one of `ToolResult`, `RagChunk`, or `MemoryItem`), severity (`GuardrailSeverityWire`: `Critical`, `High`, `Medium`, or `Low`) when present, and outcome (`Fail { reason }` or `Transform`). For `Fail` outcomes, the `reason` string and `GuardrailSeverityWire` severity are both `Some` and shown. For `Transform` outcomes, both severity and reason are `None` — no severity and no reason field is shown. Verified by `test_BC_2_24_008_entry_fields_fail()` and `test_BC_2_24_008_entry_fields_transform()`.

### AC-003 (traces to BC-2.24.008 postcondition PC-003)
For in-progress runs, new `guardrail_decision` events are appended to the security feed as they arrive via the shared `EventSource`. The shared SSE subscription from S-console-06 is reused — there is ONE `EventSource` per run. Verified by `test_BC_2_24_008_realtime_append_shared_sse()`.

### AC-004 (traces to BC-2.24.008 postcondition PC-004)
For completed (terminal-status) runs, the security feed reconstructs from the `evidence_journal?` field returned by the run-read endpoint (`GET /threads/{thread_id}/runs/{run_id}`). The `evidence_journal` contains the durable record of all guardrail evaluation results for the run; the console filters and displays entries corresponding to `Fail` or `Transform` outcomes. No `EventSource` is opened for completed runs. There is NO stored StreamEvent list — StreamEvent is transient (ADR-030 §Decision; ADR-031 Decision 8). Verified by `test_BC_2_24_008_completed_run_reconstruction()`.

### AC-005 (traces to BC-2.24.008 invariant INV-002)
Every `guardrail_decision` event with a Fail or Transform outcome that appears in the live SSE stream (in_progress runs) or in the `evidence_journal` reconstruction (terminal-status runs) MUST appear in the security feed. No silent omission. The feed is a complete audit log of all qualifying events. Filtering is limited to outcome type (Fail/Transform only) — no other filtering that could drop events is permitted. Verified by `test_BC_2_24_008_complete_audit_no_omission()`.

### AC-006 (traces to BC-2.24.008 edge case EC-001)
When a run has only Pass guardrail decisions (none streamed per F-P99-01 design), the security feed renders empty state: "no Fail or Transform decisions in this run". No error state; no crash. Verified by `test_BC_2_24_008_empty_state_all_pass()`.

### AC-007 (traces to BC-2.24.008 invariant INV-004)
When a `guardrail_decision` event payload fails to parse (malformed JSON), a placeholder row is shown in the feed: "malformed guardrail event [raw JSON]". The remaining entries in the feed are unaffected. No JavaScript error is thrown. Verified by `test_BC_2_24_008_malformed_payload_placeholder()` (VP-2.24.008-B).

### AC-008 (traces to BC-2.24.008 edge case EC-005)
High-volume runs with many `guardrail_decision` Fail events (e.g., 50 events for the Domain A SOC analyst scenario) render all entries in the security feed. Virtual scrolling or pagination may be applied for display performance, but completeness is the correctness requirement — all 50 events appear when scrolling through the full list. Verified by `test_BC_2_24_008_high_volume_all_entries_present()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| Security feed panel component | `spa/src/components/SecurityFeedPanel.*` | N/A (SPA component) |
| Guardrail event filter | `spa/src/lib/sse.ts` (event filtering) | N/A (SPA) |
| Malformed-event placeholder | `spa/src/components/SecurityFeedPanel.*` | N/A (SPA component) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| Security feed panel | N/A (SPA) | TypeScript/JS frontend |
| Guardrail event processing | Pure consumer | Reads from shared SSE stream; no server mutations |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | Only Pass decisions (none streamed) | Empty state "no Fail or Transform decisions" |
| EC-002 | Burst of 50 Fail events | All 50 appear in feed; virtual scroll for performance |
| EC-003 | `Transform` decision — severity and reason both absent | Entry shows boundary + Transform outcome only; severity is `None` (not shown), reason is `None` (not shown) |
| EC-004 | Malformed `guardrail_decision` payload | Placeholder row; no crash; other entries intact |
| EC-005 | Pass decisions mixed with Fail/Transform | Only Fail/Transform shown; Pass silently excluded (not streamed by server) |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.008.md (~143 lines) | ~2,500 |
| ADR-031 traceability row (CAP-047) | ~200 |
| SPA component source (~180 lines TypeScript) | ~2,200 |
| Test files (~120 lines) | ~1,500 |
| Tool outputs | ~400 |
| **Total** | **~10,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs (test-writer; unit + E2E/component tests)
2. [ ] Create `spa/src/components/SecurityFeedPanel.*` — security feed with Fail/Transform filter; empty state; malformed-event placeholder; virtual scroll for high-volume
3. [ ] Add `guardrail_decision` event handler in `spa/src/lib/sse.ts`: filter to Fail/Transform outcomes only; append to security feed state
4. [ ] Implement completed-run reconstruction: fetch `evidence_journal?` from run-read (`GET /threads/{thread_id}/runs/{run_id}`); filter entries to Fail/Transform outcomes — no stored event list (StreamEvent is transient; ADR-031 Decision 8)
5. [ ] Implement malformed-event placeholder: wrap event parsing in try/catch; render raw JSON in placeholder row on parse error
6. [ ] Add empty state rendering when no qualifying events exist
7. [ ] Ensure security feed reuses the shared `EventSource` from S-console-06 (no new SSE connection)
8. [ ] Run SPA tests — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-06 (run inspection panel). The `sse.ts` SSE subscription library and the shared `EventSource` per run are established by S-console-06. The security feed is an additional consumer of the same event stream — it filters for `guardrail_decision` events only. The `EventTimeline` from S-console-06 already renders `guardrail_decision` events in the main timeline; the security feed provides a dedicated filtered view without duplicating the EventSource connection.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| ONE SSE EventSource per run (shared with run inspection) | BC-2.24.008 INV-003 | Code review: no new EventSource; reuse S-console-06 instance |
| Pass decisions not shown (F-P99-01) | BC-2.24.008 INV-001 | Test: inject Pass events via mock; assert zero entries in feed |
| All Fail/Transform events appear — no silent omission | BC-2.24.008 INV-002 (DI-012) | Test: inject N events; assert N entries rendered |
| Malformed payload renders placeholder, not crash | BC-2.24.008 INV-004 (DI-014) | Test: invalid JSON payload; assert placeholder row, no JS error |
| No filtering that could silently drop Fail/Transform events | BC-2.24.008 INV-002 | Code review: only outcome-type filter permitted |

**Forbidden patterns:** Opening a new `EventSource` for the guardrail panel (must reuse the run inspection panel's connection). Silently dropping malformed events (must show placeholder). Attempting to fetch or display Pass decisions from any source. Filtering on `boundary` (IngressBoundary value) or severity in addition to outcome type.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| Framework (from S-console-05) | Per S-console-05 selection | SPA components |
| Virtual scroll library (optional) | Latest stable at Wave 3 | Performance for high-volume (50+) event feeds |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/spa/src/components/SecurityFeedPanel.*` | CREATE | Security feed with Fail/Transform filter, empty state, malformed placeholder |
| `crates/pregolya-console/spa/src/lib/sse.ts` | MODIFY | Add `guardrail_decision` Fail/Transform event handler |
| `crates/pregolya-console/spa/src/lib/api.ts` | MODIFY | Add completed-run `evidence_journal` fetch from run-read endpoint for guardrail reconstruction |
