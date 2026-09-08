---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.007
version: "1.3"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-046
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. Token/context budget monitoring panel driven by compaction_event StreamEvents."
  - "1.1 (D-356-fix/DC-01/2026-09-06, product-owner): F-PDC01-01 Story Anchor corrected: was S-console-08, now S-console-09. Verified against S-console-09 frontmatter behavioral_contracts: [BC-2.24.007]."
  - "1.2 (D-356-fix/DC-24/2026-09-08, product-owner): F-PDC24-04: {PC-003} updated — 'via the server's run-read endpoint' made precise: cites `evidence_journal?` field on `GET /threads/{thread_id}/runs/{run_id}` response (BC-2.12.003 {PC-013}), present when run status is terminal. BC-2.12.003 {PC-013} was amended in the same burst to project this field."
  - "1.3 (D-356-fix/DC-25/2026-09-08, product-owner): F-PDC25-02 (MED): EvidenceJournal scope broadened from 'completed runs' to 'terminal-status (finished) runs' throughout. Description, PC-003, EC-005, and TV-004 updated to include all four terminal states: completed, failed, cancelled, summary_halt. BC-2.12.003 {PC-013} already projects evidence_journal? for all four states; BC-2.24.007 was the outlier."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-046
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "1f87a7c"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.007: Token/Context Budget Monitoring Panel (CAP-046)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

## Description

The developer console provides a live context-window gauge panel driven by
`compaction_event` StreamEvents (BC-2.06.006, 15th variant). The gauge shows remaining
context budget as a proportional indicator using `tokens_remaining_after` and
`summary_token_count` from the `compaction_event` payload. Each compaction event annotates
the run timeline with a compaction boundary marker. For terminal-status (finished) runs (`completed`, `failed`, `cancelled`, `summary_halt`), the full
`EvidenceJournal` decision history (via the Run record) surfaces `PolicyDecision` values
per evaluation point. No new server machinery is required — `compaction_event` is already
part of the StreamEvent grammar.

## Preconditions

1. {PRE-001} A run with `BudgetConfig.compaction_trigger != CompactionTrigger::Disabled` is active or has completed (CAP-035, BC-2.10.005).
2. {PRE-002} The live SSE stream (`GET /threads/{id}/runs/{run_id}/stream`) is open (BC-2.12.007) OR the run is completed and stored events include one or more `compaction_event` variants.
3. {PRE-003} `tokens_remaining_after` is non-null in at least one `compaction_event` (requires a token ceiling configured via `BudgetConfig` — `OnMessageCount`-only configs may produce `null`, per BC-2.06.006 {INV-002}).

## Postconditions

1. {PC-001} **Context-window gauge:** The panel displays a proportional indicator (e.g., a progress bar) representing the remaining context budget. The gauge updates on each `compaction_event`. The indicator reflects `tokens_remaining_after` as a fraction of the configured token ceiling. When `tokens_remaining_after` is `null` (no token ceiling configured), the gauge shows "budget unknown" rather than a value.
2. {PC-002} **Compaction event annotation:** Each `compaction_event` adds a boundary marker to the event timeline (BC-2.24.004). The marker shows:
   - The compacted turn range (`compacted_start..=compacted_end`).
   - `summary_token_count`: the token count of the injected summary.
   - `tokens_remaining_after`: remaining capacity after compaction.
   - `trigger`: which `CompactionTrigger` variant fired (`OnWatermark`, `OnMessageCount`, `OnTokenCount`).
3. {PC-003} **EvidenceJournal for terminal-status (finished) runs:** For terminal-status (finished) runs (`completed`, `failed`, `cancelled`, `summary_halt`), the panel surfaces the run's full `EvidenceJournal` decision history. Each entry shows the `PolicyDecision` (`Allow`, `Escalate`, `Deny`) and the evaluation point that produced it. (Source: `evidence_journal?` field on the `GET /threads/{thread_id}/runs/{run_id}` response, BC-2.12.003 {PC-013}; present when run `status` is a terminal state — `completed`, `failed`, `cancelled`, or `summary_halt`.)
4. {PC-004} **Real-time for live runs:** For in-progress runs, the gauge updates incrementally as `compaction_event` variants arrive via the SSE subscription (shared with BC-2.24.004 — same `EventSource` instance).
5. {PC-005} **No new server machinery:** The panel is a pure SSE consumer of `compaction_event` events already in the grammar. No new endpoints are added.

## Invariants

- {INV-001} **Null `tokens_remaining_after` handled:** When `tokens_remaining_after` is `null` (per BC-2.06.006 {INV-002}: `None` when no token ceiling is configured; negative `i64` is possible when `accumulated > ceiling` on Deny path), the gauge MUST NOT crash or render an invalid value. Display "N/A" or "budget unknown" in the null case.
- {INV-002} **Post-commit semantics respected:** The `compaction_event` arrives AFTER the compacted checkpoint is written (BC-2.06.006 {INV-001}). The console trusts this ordering — when the event arrives, the active message window has already been replaced by the summary.
- {INV-003} **Shared SSE subscription:** The budget panel reuses the same `EventSource` connection as the run inspection panel (BC-2.24.004) — there is ONE SSE connection per run, not one per panel. Both panels observe the same event stream.
- {INV-004} **DI-014:** Display errors (e.g., failed EvidenceJournal fetch for completed run) surface as user-visible inline error messages within the panel, not as page crashes.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | `compaction_trigger = Disabled` (default); no compaction events | Budget panel shows "compaction not configured" placeholder; no gauge rendered |
| {EC-002} | `tokens_remaining_after = null` (OnMessageCount trigger, no token ceiling) | Gauge shows "budget unknown" / "N/A"; timeline annotation still shows turn range and summary_token_count |
| {EC-003} | `tokens_remaining_after` is negative (Deny path: `accumulated > ceiling`) | Gauge renders 0% or a visual "overrun" state (negative budget displayed as 0 with a warning indicator) |
| {EC-004} | Two `compaction_event` variants in one run | Two boundary markers on the timeline; gauge updates twice; latest `tokens_remaining_after` drives the gauge |
| {EC-005} | EvidenceJournal fetch fails for a terminal-status (finished) run | Inline error "Evidence journal unavailable" in panel; rest of panel (gauge, timeline annotations) still rendered from stored events |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `compaction_event { trigger: "OnWatermark", compacted_start: 0, compacted_end: 9, summary_token_count: 250, tokens_remaining_after: 45000 }` | Gauge updates to reflect 45000 remaining; timeline shows boundary marker at turns 0–9; trigger label "OnWatermark" | happy-path |
| TV-002 | `tokens_remaining_after: null` | Gauge shows "N/A"; boundary marker still shows `summary_token_count` | EC-002 |
| TV-003 | `compaction_trigger = Disabled`; no events | Budget panel shows "compaction not configured" | EC-001 |
| TV-004 | Terminal-status (finished) run with 2 compaction events and EvidenceJournal | Two timeline markers; EvidenceJournal table shows Allow/Escalate/Deny decisions per point | completed-run |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.007-A | Gauge renders without crash when `tokens_remaining_after` is null | Unit test: inject `compaction_event` with `null` tokens_remaining_after; assert "N/A" displayed |
| VP-2.24.007-B | Timeline boundary marker emitted on each `compaction_event` | Integration test: assert marker count matches `compaction_event` count in stream |

## Related BCs

- BC-2.06.006 — depends on: `compaction_event` StreamEvent payload (15th variant, trigger/compacted_start/end/summary_token_count/tokens_remaining_after fields)
- BC-2.24.004 — composes with: shared SSE EventSource; compaction events annotate the timeline (BC-2.24.004 renders them); budget panel adds the gauge
- BC-2.10.006 — depends on: `EvidenceJournal` is populated by the compaction execution path (for completed-run budget history)

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — §Traceability row "Token/context budget panel (CAP-046 — SS-24, SS-10)"
- `architecture/decisions/ADR-019-rolling-context-compaction.md` — Decision 4 (`compaction_event` payload definition, `tokens_remaining_after` semantics)

## Story Anchor

S-console-09 (Wave 3 — token/context budget monitoring panel)

> **D-356 adversary fix DC-24 (2026-09-08, product-owner).** F-PDC24-04: {PC-003} Source citation made precise — "via the server's run-read endpoint" was unresolvable because BC-2.12.003 {PC-013} (`GET /threads/{thread_id}/runs/{run_id}`) did not project `evidence_journal`. BC-2.12.003 {PC-013} was amended in the same burst to add `evidence_journal?` (present on terminal-status runs). {PC-003} now cites `evidence_journal?` on BC-2.12.003 {PC-013} explicitly.

> **D-356 adversary fix DC-25 (2026-09-08, product-owner).** F-PDC25-02 (MED): EvidenceJournal display scope was narrowed to `completed` runs only. Broadened throughout — Description, PC-003, EC-005, TV-004 — to "terminal-status (finished) runs (`completed`, `failed`, `cancelled`, `summary_halt`)". BC-2.12.003 {PC-013} already has the correct `evidence_journal?` projection for all four terminal states; BC-2.24.007 was the outlier.

> **D-356 adversary fix DC-01 (2026-09-06, product-owner).** Story Anchor corrected S-console-08 → S-console-09. story-writer split BC-2.24.002 across S-console-02+03 and added S-console-05 (SPA build, no BC), shifting the numbering. Verified: S-console-09 frontmatter carries `behavioral_contracts: [BC-2.24.007]`.

## VP Anchors

- VP-2.24.007-A
- VP-2.24.007-B

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-046 |
| Capability Anchor Justification | CAP-046 ("Token/Context Budget Monitoring Panel") per capabilities-p1-p2.md §CAP-046 — this BC specifies the context-window gauge (driven by `tokens_remaining_after`), compaction timeline annotation (`compacted_start..=compacted_end`, `summary_token_count`, trigger label), EvidenceJournal decision history, and real-time update semantics that constitute the token/context budget monitoring panel described in CAP-046 |
| L2 Domain Invariants | DI-014 (Error Propagation — null tokens_remaining_after handled without crash; EvidenceJournal fetch errors surface as inline messages) |
| Architecture Authority | ADR-031 §Traceability (CAP-046 — SS-24, SS-10); ADR-019 Decision 4 (compaction_event payload); BC-2.06.006 (compaction_event canonical spec) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.007-A/B |
| Module | pregolya-console / SPA (web frontend, pure SSE consumer of compaction_event) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + integration (E2E) |
