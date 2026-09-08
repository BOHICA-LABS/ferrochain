---
document_type: story
level: ops
story_id: S-console-09
epic_id: E-console
version: "1.2"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — token/context budget monitoring panel driven by compaction_event StreamEvents, EvidenceJournal display."
  - "1.1 (D-356/DC-27/L-288/2026-09-08, story-writer): F-L288-006 — EvidenceJournal scope broadened to all 4 terminal states (completed, failed, cancelled, summary_halt); test renamed evidence_journal_terminal_run."
  - "1.2 (D-356/DC-29/2026-09-08, story-writer): F-PDC29-01 — AC-007 corrected: completed-run budget panel shows no gauge/timeline (compaction_event StreamEvents are transient; ADR-031 Decision 8); panel renders only EvidenceJournal area with error message on fetch failure."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.007.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "0c56f04"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-06]
blocks: []
behavioral_contracts: [BC-2.24.007]
verification_properties: [VP-2.24.007-A, VP-2.24.007-B]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24, SS-10]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-09: Token/Context Budget Monitoring Panel

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-27/L-288 (2026-09-08, story-writer).** F-L288-006 — EvidenceJournal scope broadened from `completed`-only to all 4 terminal states (`completed`, `failed`, `cancelled`, `summary_halt`) per BC-2.24.007 v1.3 (AC-003, AC-007, EC-005, Task 4, Task 7, File Structure). Test renamed `test_BC_2_24_007_evidence_journal_terminal_run()`.

> **D-356 adversary fix DC-29 (2026-09-08, story-writer).** F-PDC29-01 — AC-007 corrected for ADR-031 Decision 8. StreamEvent is transient; per-compaction-event detail is not available for terminal-status runs post-run. The budget panel for a completed run shows only the EvidenceJournal area — no gauge, no compaction timeline annotations. On EvidenceJournal fetch failure, only the inline error message is rendered; there are no other panel elements to preserve. Live (in_progress) SSE path (AC-004) is unchanged.

## Narrative

- **As a** developer running a long-horizon agent with context compaction enabled
- **I want to** see a live context-window gauge and compaction boundary markers in the console
- **So that** I can observe when the context window is filling and how much space the compaction summaries consume, without reading raw token count logs

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.007 | Token/Context Budget Monitoring Panel (CAP-046) | AC-001..AC-007 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.007 postcondition PC-001)
The panel displays a proportional context-window gauge (e.g., a progress bar) showing remaining context budget. The gauge updates on each `compaction_event` received via the shared SSE subscription. The gauge reflects `tokens_remaining_after` as a fraction of the configured token ceiling. When `tokens_remaining_after` is `null`, the gauge shows "N/A" or "budget unknown" — no crash, no invalid numeric display. Verified by `test_BC_2_24_007_gauge_renders()` and `test_BC_2_24_007_gauge_null_tokens_remaining()` (VP-2.24.007-A).

### AC-002 (traces to BC-2.24.007 postcondition PC-002)
Each `compaction_event` adds a boundary marker to the event timeline (S-console-06 EventTimeline). The marker shows: compacted turn range (`compacted_start..=compacted_end`), `summary_token_count`, `tokens_remaining_after`, and the `trigger` label (`OnWatermark`, `OnMessageCount`, or `OnTokenCount`). Verified by `test_BC_2_24_007_timeline_boundary_marker()` (VP-2.24.007-B).

### AC-003 (traces to BC-2.24.007 postcondition PC-003)
For terminal-status (finished) runs (`completed`, `failed`, `cancelled`, `summary_halt`), the panel surfaces the run's `EvidenceJournal` decision history. Each entry shows the `PolicyDecision` (`Allow`, `Escalate`, `Deny`) and the evaluation point that produced it. Verified by `test_BC_2_24_007_evidence_journal_terminal_run()`.

### AC-004 (traces to BC-2.24.007 postcondition PC-004)
For in-progress runs, the gauge updates incrementally as `compaction_event` variants arrive via the shared `EventSource`. The shared SSE subscription from S-console-06 is reused — there is ONE `EventSource` per run, not one per panel. Verified by `test_BC_2_24_007_realtime_update_shared_sse()`.

### AC-005 (traces to BC-2.24.007 invariant INV-001)
When `tokens_remaining_after` is `null` (no token ceiling configured), the gauge renders "N/A" or "budget unknown" without crashing or rendering a NaN value. When `tokens_remaining_after` is negative (Deny path: `accumulated > ceiling`), the gauge renders at 0% or shows a visual "overrun" indicator — not a negative percentage. Verified by `test_BC_2_24_007_null_tokens_handled()` and `test_BC_2_24_007_negative_tokens_overrun()`.

### AC-006 (traces to BC-2.24.007 edge case EC-001)
When `compaction_trigger = Disabled` (default) and no `compaction_event` arrives, the budget panel shows a "compaction not configured" placeholder message. No gauge is rendered. Verified by `test_BC_2_24_007_compaction_disabled_placeholder()`.

### AC-007 (traces to BC-2.24.007 edge case EC-005)
When the `EvidenceJournal` fetch fails for a terminal-status (finished) run (server error), the panel shows an inline error message "Evidence journal unavailable" within the panel area. No gauge or compaction timeline annotations are shown for terminal-status runs — per-compaction-event detail (`compaction_event` StreamEvent payloads) is not available post-run because StreamEvent is transient (ADR-031 Decision 8); only the EvidenceJournal display area is rendered, and it shows the error message. Verified by `test_BC_2_24_007_evidence_journal_fetch_error()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| Budget gauge component | `spa/src/components/BudgetGauge.*` | N/A (SPA component) |
| Compaction event handler | `spa/src/lib/sse.ts` (event filtering) | N/A (SPA) |
| EvidenceJournal display | `spa/src/components/EvidenceJournalPanel.*` | N/A (SPA component) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| Budget monitoring panel | N/A (SPA) | TypeScript/JS frontend |
| Compaction event processing | Pure consumer | Reads from shared SSE stream; no server mutations |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | `compaction_trigger = Disabled` | "compaction not configured" placeholder; no gauge |
| EC-002 | `tokens_remaining_after = null` | Gauge shows "N/A"; timeline annotation still shows turn range |
| EC-003 | `tokens_remaining_after` is negative | Gauge renders at 0% with overrun indicator |
| EC-004 | Two `compaction_event` entries in one run | Two timeline markers; gauge updates twice |
| EC-005 | EvidenceJournal fetch fails for terminal-status run | Inline error; rest of panel still rendered |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.007.md (~141 lines) | ~2,500 |
| ADR-031 traceability row (CAP-046) | ~200 |
| SPA component source (~200 lines TypeScript) | ~2,500 |
| Test files (~120 lines) | ~1,500 |
| Tool outputs | ~400 |
| **Total** | **~10,600** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs (test-writer; unit + E2E/component tests)
2. [ ] Create `spa/src/components/BudgetGauge.*` — proportional gauge component; handles null and negative `tokens_remaining_after` without crash
3. [ ] Extend `spa/src/components/EventTimeline.*` to render compaction boundary markers (AC-002) — coordinate with S-console-06 implementer
4. [ ] Create `spa/src/components/EvidenceJournalPanel.*` — terminal-status (finished) run `PolicyDecision` history table
5. [ ] Add `compaction_event` handler in `spa/src/lib/sse.ts`: filter event type, update gauge state, add timeline marker
6. [ ] Add "compaction not configured" placeholder state when no compaction events arrive
7. [ ] Implement EvidenceJournal fetch for terminal-status (finished) runs via run-read endpoint
8. [ ] Handle EvidenceJournal fetch error with inline error message (AC-007)
9. [ ] Run SPA tests — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-06 (run inspection panel). The `sse.ts` SSE subscription library and the `EventTimeline` component are established by S-console-06. The budget panel reuses the shared `EventSource` instance from S-console-06 — do NOT open a new SSE connection. The `EventTimeline` component from S-console-06 needs to be extended to accept compaction boundary markers (coordinate with S-console-06 merge state).

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| ONE SSE EventSource per run (shared with run inspection) | BC-2.24.007 INV-003 | Code review: no new EventSource created; existing instance reused |
| `null` `tokens_remaining_after` handled without crash | BC-2.24.007 INV-001 | Test: inject null; assert "N/A" rendered, no NaN |
| Negative `tokens_remaining_after` rendered as 0% + overrun indicator | BC-2.24.007 INV-001, EC-003 | Test: inject negative value; assert 0% + indicator |
| Display errors surface as inline messages, not page crashes | BC-2.24.007 INV-004 (DI-014) | Test: mock EvidenceJournal fetch error; assert inline error |
| `compaction_event` arrives after checkpoint write (post-commit) | BC-2.24.007 INV-002 | No console action needed; trust SSE ordering |

**Forbidden patterns:** Opening a new `EventSource` for the budget panel (must reuse the run inspection panel's connection). Crashing on `null` or negative `tokens_remaining_after`. Rendering a negative percentage in the gauge.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| Framework (from S-console-05) | Per S-console-05 selection | SPA components |
| Progress bar / gauge component | Framework built-in or lightweight library | Context budget visual indicator |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/spa/src/components/BudgetGauge.*` | CREATE | Context-window gauge; null/negative safe |
| `crates/pregolya-console/spa/src/components/EvidenceJournalPanel.*` | CREATE | PolicyDecision history table for terminal-status (finished) runs |
| `crates/pregolya-console/spa/src/components/EventTimeline.*` | MODIFY | Add compaction boundary marker rendering |
| `crates/pregolya-console/spa/src/lib/sse.ts` | MODIFY | Add `compaction_event` handler; update gauge state |
| `crates/pregolya-console/spa/src/lib/api.ts` | MODIFY | Add EvidenceJournal fetch for terminal-status (finished) runs |
