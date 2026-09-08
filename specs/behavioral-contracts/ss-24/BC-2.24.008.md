---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.008
version: "1.7"
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
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. Guardrail/security decision review panel (Fail/Transform only; Pass not shown per F-P99-01)."
  - "1.1 (D-356-fix/DC-01/2026-09-06, product-owner): F-PDC01-01 Story Anchor corrected: was S-console-09, now S-console-10. Verified against S-console-10 frontmatter behavioral_contracts: [BC-2.24.008]."
  - "1.2 (D-356-fix/DC-02/2026-09-07, product-owner): F-PDC02-04 guardrail_decision variant ordinal corrected from 16th to 12th (per BC-2.06.001 §Postconditions PC-002 canonical ordering and ADR-006 rev-3): three sites updated — Description, Architecture Anchors section, and Traceability §Architecture Authority row."
  - "1.3 (D-356-fix/DC-03/2026-09-07, product-owner): F-PDC03-01 + F-PDC03-03: PC-002 boundary field corrected — field name boundary_type→boundary, type ProvenanceTag/BoundaryType→IngressBoundary, values RAGRetrieval→RagChunk, MemoryIngress→MemoryItem; severity type GuardrailSeverity→GuardrailSeverityWire (Transform decisions carry severity: None and reason: None per BC-2.06.001 §Postconditions PC-002); TV-001/TV-002/TV-004 updated to match corrected field names and enum values; EC-003 severity-for-Transform corrected (None, not High). Authority: BC-2.06.001 §Postconditions PC-002 StreamEvent::GuardrailDecision and ADR-006 §Decision. F-PDC03-04: DC-02 blockquote count corrected two sites→three sites (POL-46; changelog v1.2 correctly stated three)."
  - "1.4 (D-356-fix/DC-04/2026-09-07, product-owner): F-PDC04-03: Traceability Capability Anchor Justification corrected — field name boundary_type→boundary, severity type GuardrailSeverity→GuardrailSeverityWire, matching the PC-002 corrections already applied in v1.3 (DC-03). The Justification now cites the canonical field and type names as they appear in BC-2.06.001 §Postconditions PC-002 and ADR-006 §Decision."
  - "1.5 (D-356-fix/DC-29/2026-09-08, product-owner): F-PDC29-01 (HIGH): Description/PRE-002/PC-004/INV-002 all referenced non-existent stored StreamEvent list for completed-run reconstruction. Replaced throughout with D8 realizable substrate: evidence_journal? on run-read response (BC-2.12.003 {PC-013}) is the authoritative source for completed-run guardrail history (StreamEvent is transient per ADR-030 §Decision 2; ADR-031 Decision 8). INV-002 completeness obligation now correctly spans SSE stream (live) and evidence_journal? (terminal-status runs)."
  - "1.6 (D-356-fix/DC-30/F-PDC30-02/2026-09-08, product-owner): F-PDC30-02 (MED): `ADR-030 §Decision` → `ADR-030 §Decision 2` in {PC-004} body, DC-29 delta note, and DC-29 changelog entry. `§Decision 2` is the canonical ADR-030 clause establishing StreamEvent transience."
  - "1.7 (D-356/DC-33/2026-09-08, product-owner): F-PDC33-02: DC-29 used wrong field — `evidence_journal?` is the budget PolicyDecision journal (BC-2.10.002 / EvidenceJournal); completed-run guardrail history is `guardrail_journal?` (BC-2.11.007 / GuardrailJournal). All normative references to completed-run guardrail history updated: Description, PRE-002, PC-004 (architect-exact wording per DC-33), INV-002 — all `evidence_journal?` → `guardrail_journal?`. NOTE in PC-004 added clarifying that evidence_journal? records a SEPARATE governance dimension (budget). DC-33 human-authorized scope."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-047
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "85c2216"
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

> **D-356 adversary fix DC-33 (2026-09-08, product-owner).** F-PDC33-02: DC-29 used the wrong field for completed-run guardrail history. `evidence_journal?` is the budget `PolicyDecision` journal (BC-2.10.002 / `EvidenceJournal`; records Allow/Escalate/Deny outcomes); completed-run guardrail history is `guardrail_journal?` (BC-2.11.007 / `GuardrailJournal`; records `GuardrailResult` Pass/Fail/Transform per `GuardrailHook::evaluate` call). These are distinct governance dimensions. All normative references in Description, PRE-002, PC-004, and INV-002 corrected: `evidence_journal?` → `guardrail_journal?`. PC-004 rewritten with architect-exact wording per DC-33 adjudication. DC-29 blockquote preserved as historical record; this DC-33 note supersedes its field-name claim.

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

> **D-356 adversary fix DC-02 (2026-09-07, product-owner).** F-PDC02-04: `guardrail_decision` variant ordinal corrected from 16th to 12th at three sites — Description, Architecture Anchors, and Traceability §Architecture Authority row. Authority: BC-2.06.001 §Postconditions PC-002 canonical StreamEvent ordering and ADR-006 rev-3. The `guardrail_decision` variant is the 12th of the 16 canonical variants; `error` is the 16th (not `guardrail_decision`).

> **D-356 adversary fix DC-03 (2026-09-07, product-owner).** F-PDC03-01 + F-PDC03-03: PC-002 boundary field corrected — field `boundary_type` (type `ProvenanceTag`/`BoundaryType`, values `RAGRetrieval`/`MemoryIngress`) is WRONG; the authoritative `guardrail_decision` event carries field `boundary` of type `IngressBoundary` with values `ToolResult | RagChunk | MemoryItem` (BC-2.06.001 §Postconditions PC-002 `StreamEvent::GuardrailDecision`; ADR-006 §Decision). Severity type corrected `GuardrailSeverity` → `GuardrailSeverityWire`. `Transform` decisions carry `severity: None` and `reason: None` (both `Some` for `Fail` only). Affected sites: PC-002, TV-001, TV-002, TV-004, EC-003. **Story-writer S-console-10 sibling sweep required** under `bc_array_changes_propagate_to_body_and_acs`: update `boundary_type` → `boundary`, `BoundaryType`/`ProvenanceTag` → `IngressBoundary`, `RAGRetrieval` → `RagChunk`, `MemoryIngress` → `MemoryItem`, `GuardrailSeverity` → `GuardrailSeverityWire` in S-console-10 BC table and ACs. F-PDC03-04: DC-02 blockquote count corrected `two sites` → `three sites` (POL-46; changelog v1.2 correctly stated three).

> **D-356 adversary fix DC-04 (2026-09-07, product-owner).** F-PDC04-03: Traceability Capability Anchor Justification row corrected — `boundary_type` → `boundary`, `GuardrailSeverity` → `GuardrailSeverityWire` (matching the PC-002 canonical field names restored in v1.3 DC-03). The Justification now cites the authoritative field and type names as they appear in BC-2.06.001 §Postconditions PC-002 and ADR-006 §Decision.

## Description

The developer console provides a dedicated guardrail security feed that isolates all
`guardrail_decision` StreamEvents (CAP-007, 12th variant per ADR-006 rev-3 / BC-2.06.001 §Postconditions PC-002 canonical ordering) from a run. Each entry shows
the boundary type, severity, and outcome (Fail or Transform). Pass decisions are NOT shown
— they are not streamed per the existing design (ADR-006 rev-3, F-P99-01: "Pass is not
streamed"). The feed updates in real time for live runs (via the shared SSE subscription)
and sources completed-run guardrail history from the `guardrail_journal?` field on the run-read response (BC-2.12.003 {PC-013}; ADR-031 Decision 8). This panel serves both the
interactive local-debug workflow and the Domain A SOC analyst use case (guardrail
visibility during untrusted-tool-result ingestion).

## Preconditions

1. {PRE-001} A run is selected (active or completed) with at least one `guardrail_decision` event in the stream (i.e., at least one guardrail check on a non-Pass decision was triggered for a qualifying boundary).
2. {PRE-002} The run's SSE stream (BC-2.12.007) is open (live) OR the run is terminal-status and the run-read response (BC-2.12.003 {PC-013}) is accessible for post-run guardrail history via `guardrail_journal?` (ADR-031 Decision 8).
3. {PRE-003} The server is configured with at least one `GuardrailHook` that can produce Fail or Transform decisions (CAP-013, BC-2.11.001).

## Postconditions

1. {PC-001} **Security feed rendered:** The panel displays a filtered view showing ONLY `guardrail_decision` StreamEvents where the outcome is `Fail` or `Transform`. Pass decisions are NOT shown in this panel (per ADR-006 rev-3 F-P99-01 design).
2. {PC-002} **Per-entry fields:** Each entry in the feed shows:
   - `boundary`: `IngressBoundary` — one of `ToolResult | RagChunk | MemoryItem` (per BC-2.06.001 §Postconditions PC-002 `StreamEvent::GuardrailDecision`; authority: ADR-006 §Decision).
   - `GuardrailSeverityWire`: `Critical | High | Medium | Low` — `Some` for `Fail` decisions; `None` for `Transform` decisions (per BC-2.06.001 §Postconditions PC-002 and ADR-006 §Decision).
   - Decision: `Fail` or `Transform` (`decision` field on `StreamEvent::GuardrailDecision`).
   - For `Fail`: the `reason` string (`reason: Option<String>` — `Some` for `Fail`; `None` for `Transform`).
3. {PC-003} **Real-time update (live runs):** For in-progress runs, new `guardrail_decision` events are appended to the feed as they arrive via the shared SSE subscription (one `EventSource` per run, shared with BC-2.24.004 and BC-2.24.007).
4. {PC-004} **Completed run reconstruction:** For terminal-status runs, the feed reconstructs from `guardrail_journal?` on `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}), governed by BC-2.11.007. `guardrail_journal` contains durable `GuardrailEntry` records (result: `GuardrailResult` Pass/Fail/Transform per `GuardrailHook::evaluate` call); the console filters and displays Fail/Transform entries. NOTE: `evidence_journal?` records budget `PolicyDecision` outcomes (Allow/Escalate/Deny) — a separate governance dimension; do NOT conflate with guardrail results. `StreamEvent` is transient (ADR-030 §Decision 2; ADR-031 §Decision 8); `guardrail_journal?` is the correct substrate for completed-run guardrail history. (The DI-012 completeness invariant {INV-002} applies to both live-stream and completed-run reconstruction.)
5. {PC-005} **No new server machinery:** `guardrail_decision` events are already emitted by the server (ADR-006 rev-3, CAP-007). No new endpoints are added.
6. {PC-006} **DI-012 invariant:** All qualifying boundary crossings produce `guardrail_decision` events. The feed MUST NOT silently omit any Fail or Transform decision that was emitted. A complete feed is the correctness requirement (DI-012: no guardrail bypass — all qualifying events appear in the feed).

## Invariants

- {INV-001} **F-P99-01: Pass not shown.** Pass decisions are NOT streamed by the server (ADR-006 rev-3) and are therefore NOT shown in this panel. The console MUST NOT attempt to fetch or display Pass decisions from any source. This is by design — Pass decisions are the high-frequency normal case and surfacing them would obscure the actionable Fail/Transform events.
- {INV-002} **DI-012 complete feed:** Every `guardrail_decision` event with a Fail or Transform outcome that appears in the SSE stream (live runs) or `guardrail_journal?` (terminal-status runs per BC-2.12.003 {PC-013}) MUST appear in the feed. Filtering is limited to outcome type (Fail/Transform only) — no other filtering that could silently drop events is permitted.
- {INV-003} **Shared SSE subscription:** The guardrail feed reuses the same `EventSource` connection as BC-2.24.004 and BC-2.24.007. There is ONE SSE connection per run.
- {INV-004} **DI-014:** Display errors (e.g., failure to parse a `guardrail_decision` event payload) surface as a malformed-entry placeholder in the feed, not as a page crash. The remaining entries are unaffected.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Run has only Pass guardrail decisions (all Pass) | Feed renders empty state ("no Fail or Transform decisions in this run") |
| {EC-002} | Multiple `guardrail_decision` Fail events in rapid succession (burst of untrusted-content ingestion) | All events appended to feed in emission order; no deduplication; feed is a complete audit log |
| {EC-003} | `Transform` decision: `boundary: ToolResult` (severity is `None` for Transform per BC-2.06.001 §Postconditions PC-002) | Feed shows entry with boundary "ToolResult", decision "Transform", no severity (None — severity is Fail-only per BC-2.06.001 §Postconditions PC-002), no reason (None — reason is Fail-only) |
| {EC-004} | `guardrail_decision` event with malformed payload (parse error) | Malformed-entry placeholder shown in feed ("malformed guardrail event [raw JSON]"); no crash |
| {EC-005} | Domain A SOC analyst use case: high-volume run with 50 guardrail Fail events | Feed renders all 50 entries; virtual scrolling or pagination may be applied for display performance; completeness is the correctness requirement |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `guardrail_decision { boundary: ToolResult, decision: Fail, reason: "prompt-injection detected", severity: Critical }` | Feed entry shows: ToolResult / Critical / Fail / "prompt-injection detected" | happy-path Fail |
| TV-002 | `guardrail_decision { boundary: RagChunk, decision: Transform, severity: None, reason: None }` | Feed entry shows: RagChunk / — / Transform (severity and reason are None for Transform per BC-2.06.001 §Postconditions PC-002) | happy-path Transform |
| TV-003 | Run with only Pass guardrail decisions (none streamed per F-P99-01) | Feed shows empty state "no Fail or Transform decisions" | EC-001, F-P99-01 |
| TV-004 | 3 sequential Fail events for `MemoryItem` | Feed shows 3 entries in emission order; all `MemoryItem` | EC-002 |
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

> **D-356 adversary fix DC-30 (2026-09-08, product-owner).** F-PDC30-02 (MED): `ADR-030 §Decision` → `ADR-030 §Decision 2` in {PC-004} body, DC-29 delta note, and DC-29 changelog entry. `§Decision 2` is the canonical ADR-030 clause establishing that StreamEvent is transient and not persisted.

> **D-356 adversary fix DC-29 (2026-09-08, product-owner).** F-PDC29-01 (HIGH): Completed-run reconstruction substrate was non-existent stored StreamEvent list. ADR-031 Decision 8 defines the v1-realizable substrate: evidence_journal? on GET /threads/{id}/runs/{run_id} (BC-2.12.003 {PC-013}) is the authoritative source for completed-run guardrail history. StreamEvent is transient (ADR-030 §Decision 2). Description, PRE-002, PC-004, and INV-002 all updated to cite evidence_journal? mechanism; "stored event list" removed throughout.

> **D-356 adversary fix DC-01 (2026-09-06, product-owner).** Story Anchor corrected S-console-09 → S-console-10. story-writer split BC-2.24.002 across S-console-02+03 and added S-console-05 (SPA build, no BC), shifting the numbering. Verified: S-console-10 frontmatter carries `behavioral_contracts: [BC-2.24.008]`.

## VP Anchors

- VP-2.24.008-A
- VP-2.24.008-B

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-047 |
| Capability Anchor Justification | CAP-047 ("Guardrail/Security Decision Review Panel") per capabilities-p1-p2.md §CAP-047 — this BC specifies the security feed filtering (Fail/Transform only, not Pass per F-P99-01), per-entry fields (boundary: IngressBoundary, GuardrailSeverityWire, decision, reason), real-time SSE update, completed-run reconstruction, and DI-012 completeness requirement that constitute the guardrail review panel described in CAP-047 |
| L2 Domain Invariants | DI-012 (No guardrail bypass — all qualifying Fail/Transform events appear in feed; no silent omission), DI-014 (Error Propagation — malformed events render as placeholder; no crash) |
| Architecture Authority | ADR-031 §Traceability (CAP-047 — SS-24, SS-11); ADR-006 rev-3 (guardrail_decision 12th variant per canonical ordering, F-P99-01 Pass-not-streamed) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.008-A/B |
| Module | pregolya-console / SPA (web frontend, pure SSE consumer of guardrail_decision events) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + integration (E2E) |
