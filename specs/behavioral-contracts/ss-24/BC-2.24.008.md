---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.008
version: "1.2"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-047
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-012, DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.2 (D-356-fix/DC-02/2026-09-07, product-owner): F-PDC02-04 guardrail_decision variant ordinal corrected from 16th to 12th (per BC-2.06.001 §Postconditions PC-002 canonical ordering and ADR-006 rev-3): three sites updated — Description, Architecture Anchors section, and Traceability §Architecture Authority row."
  - "1.1 (D-356-fix/DC-01/2026-09-06, product-owner): F-PDC01-01 Story Anchor corrected: was S-console-09, now S-console-10. Verified against S-console-10 frontmatter behavioral_contracts: [BC-2.24.008]."
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. Guardrail/security decision review panel (Fail/Transform only; Pass not shown per F-P99-01)."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-047
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "81edd7e"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.008: Guardrail/Security Decision Review Panel (CAP-047)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

> **D-356 adversary fix DC-02 (2026-09-07, product-owner).** F-PDC02-04: `guardrail_decision` variant ordinal corrected from 16th to 12th at two sites — Description and Architecture Anchors. Authority: BC-2.06.001 §Postconditions PC-002 canonical StreamEvent ordering and ADR-006 rev-3. The `guardrail_decision` variant is the 12th of the 16 canonical variants; `error` is the 16th (not `guardrail_decision`).

## Description

The developer console provides a dedicated guardrail security feed that isolates all
`guardrail_decision` StreamEvents (CAP-007, 12th variant per ADR-006 rev-3 / BC-2.06.001 §Postconditions PC-002 canonical ordering) from a run. Each entry shows
the boundary type, severity, and outcome (Fail or Transform). Pass decisions are NOT shown
— they are not streamed per the existing design (ADR-006 rev-3, F-P99-01: "Pass is not
streamed"). The feed updates in real time for live runs (via the shared SSE subscription)
and reconstructs from stored events for completed runs. This panel serves both the
interactive local-debug workflow and the Domain A SOC analyst use case (guardrail
visibility during untrusted-tool-result ingestion).

## Preconditions

1. {PRE-001} A run is selected (active or completed) with at least one `guardrail_decision` event in the stream (i.e., at least one guardrail check on a non-Pass decision was triggered for a qualifying boundary).
2. {PRE-002} The run's SSE stream (BC-2.12.007) is open (live) OR stored events include `guardrail_decision` variants (completed run).
3. {PRE-003} The server is configured with at least one `GuardrailHook` that can produce Fail or Transform decisions (CAP-013, BC-2.11.001).

## Postconditions

1. {PC-001} **Security feed rendered:** The panel displays a filtered view showing ONLY `guardrail_decision` StreamEvents where the outcome is `Fail` or `Transform`. Pass decisions are NOT shown in this panel (per ADR-006 rev-3 F-P99-01 design).
2. {PC-002} **Per-entry fields:** Each entry in the feed shows:
   - `boundary_type`: one of `ToolResult | RAGRetrieval | MemoryIngress` (from the event's `ProvenanceTag` field).
   - `GuardrailSeverity`: `Critical | High | Medium | Low`.
   - Outcome: `Fail { reason }` or `Transform`.
   - For `Fail`: the `reason` string from the `GuardrailHook` result.
3. {PC-003} **Real-time update (live runs):** For in-progress runs, new `guardrail_decision` events are appended to the feed as they arrive via the shared SSE subscription (one `EventSource` per run, shared with BC-2.24.004 and BC-2.24.007).
4. {PC-004} **Completed run reconstruction:** For completed runs, the feed reconstructs from the stored event list — all `guardrail_decision` events with Fail or Transform outcomes are shown.
5. {PC-005} **No new server machinery:** `guardrail_decision` events are already emitted by the server (ADR-006 rev-3, CAP-007). No new endpoints are added.
6. {PC-006} **DI-012 invariant:** All qualifying boundary crossings produce `guardrail_decision` events. The feed MUST NOT silently omit any Fail or Transform decision that was emitted. A complete feed is the correctness requirement (DI-012: no guardrail bypass — all qualifying events appear in the feed).

## Invariants

- {INV-001} **F-P99-01: Pass not shown.** Pass decisions are NOT streamed by the server (ADR-006 rev-3) and are therefore NOT shown in this panel. The console MUST NOT attempt to fetch or display Pass decisions from any source. This is by design — Pass decisions are the high-frequency normal case and surfacing them would obscure the actionable Fail/Transform events.
- {INV-002} **DI-012 complete feed:** Every `guardrail_decision` event with a Fail or Transform outcome that appears in the SSE stream or stored event list MUST appear in the feed. Filtering is limited to outcome type (Fail/Transform only) — no other filtering that could silently drop events is permitted.
- {INV-003} **Shared SSE subscription:** The guardrail feed reuses the same `EventSource` connection as BC-2.24.004 and BC-2.24.007. There is ONE SSE connection per run.
- {INV-004} **DI-014:** Display errors (e.g., failure to parse a `guardrail_decision` event payload) surface as a malformed-entry placeholder in the feed, not as a page crash. The remaining entries are unaffected.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Run has only Pass guardrail decisions (all Pass) | Feed renders empty state ("no Fail or Transform decisions in this run") |
| {EC-002} | Multiple `guardrail_decision` Fail events in rapid succession (burst of untrusted-content ingestion) | All events appended to feed in emission order; no deduplication; feed is a complete audit log |
| {EC-003} | `Transform` decision: boundary `ToolResult`, severity `High` | Feed shows entry with boundary "ToolResult", severity "High", outcome "Transform" (no reason string for Transform — reason is Fail-only) |
| {EC-004} | `guardrail_decision` event with malformed payload (parse error) | Malformed-entry placeholder shown in feed ("malformed guardrail event [raw JSON]"); no crash |
| {EC-005} | Domain A SOC analyst use case: high-volume run with 50 guardrail Fail events | Feed renders all 50 entries; virtual scrolling or pagination may be applied for display performance; completeness is the correctness requirement |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `guardrail_decision { boundary_type: "ToolResult", severity: "Critical", outcome: Fail { reason: "prompt-injection detected" } }` | Feed entry shows: ToolResult / Critical / Fail / "prompt-injection detected" | happy-path Fail |
| TV-002 | `guardrail_decision { boundary_type: "RAGRetrieval", severity: "High", outcome: Transform }` | Feed entry shows: RAGRetrieval / High / Transform | happy-path Transform |
| TV-003 | Run with only Pass guardrail decisions (none streamed per F-P99-01) | Feed shows empty state "no Fail or Transform decisions" | EC-001, F-P99-01 |
| TV-004 | 3 sequential Fail events for `MemoryIngress` | Feed shows 3 entries in emission order; all `MemoryIngress` | EC-002 |
| TV-005 | `guardrail_decision` event with unparseable payload | Placeholder row in feed; no crash; other events unaffected | EC-004 |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.008-A | Feed contains exactly the Fail and Transform events (not Pass) from the stream | Integration test: inject mixed Pass/Fail/Transform events; assert only Fail/Transform appear in feed |
| VP-2.24.008-B | Malformed `guardrail_decision` payload does not crash the feed | Unit test: inject invalid JSON payload; assert placeholder rendered, other entries intact |

## Related BCs

- BC-2.12.007 — depends on: SSE streaming endpoint (shared EventSource for guardrail events)
- BC-2.11.001 — depends on: guardrail-on-ingress (source of the `guardrail_decision` events this panel surfaces)
- BC-2.24.004 — composes with: shared SSE EventSource; guardrail events appear in both the timeline (BC-2.24.004) and this dedicated security feed

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — §Traceability row "Guardrail review panel (CAP-047 — SS-24, SS-11)"
- `architecture/decisions/ADR-006-streaming-event-taxonomy.md` — rev-3 `guardrail_decision` variant (12th per canonical ordering, per BC-2.06.001 §Postconditions PC-002), Fail/Transform only streamed, F-P99-01

## Story Anchor

S-console-10 (Wave 3 — guardrail/security decision review panel)

> **D-356 adversary fix DC-01 (2026-09-06, product-owner).** Story Anchor corrected S-console-09 → S-console-10. story-writer split BC-2.24.002 across S-console-02+03 and added S-console-05 (SPA build, no BC), shifting the numbering. Verified: S-console-10 frontmatter carries `behavioral_contracts: [BC-2.24.008]`.

## VP Anchors

- VP-2.24.008-A
- VP-2.24.008-B

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-047 |
| Capability Anchor Justification | CAP-047 ("Guardrail/Security Decision Review Panel") per capabilities-p1-p2.md §CAP-047 — this BC specifies the security feed filtering (Fail/Transform only, not Pass per F-P99-01), per-entry fields (boundary_type, GuardrailSeverity, outcome, reason), real-time SSE update, completed-run reconstruction, and DI-012 completeness requirement that constitute the guardrail review panel described in CAP-047 |
| L2 Domain Invariants | DI-012 (No guardrail bypass — all qualifying Fail/Transform events appear in feed; no silent omission), DI-014 (Error Propagation — malformed events render as placeholder; no crash) |
| Architecture Authority | ADR-031 §Traceability (CAP-047 — SS-24, SS-11); ADR-006 rev-3 (guardrail_decision 12th variant per canonical ordering, F-P99-01 Pass-not-streamed) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.008-A/B |
| Module | pregolya-console / SPA (web frontend, pure SSE consumer of guardrail_decision events) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + integration (E2E) |
