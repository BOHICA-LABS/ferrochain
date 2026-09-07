---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.004
version: "1.1"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-043
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.1 (D-356-fix/DC-01/2026-09-06, product-owner): F-PDC01-01 Story Anchor corrected: was S-console-05, now S-console-06. Verified against S-console-06 frontmatter behavioral_contracts: [BC-2.24.004]. F-PDC01-02 PC-001 StreamEvent variant list corrected: removed phantom run_error, added missing step_start and tool_stream, reordered to canonical 16 per ADR-006 — count is now exactly 16 distinct variants."
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. Run inspection event timeline and live monitoring panel."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-043
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "fea55e3"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.004: Run Inspection Event Timeline and Live Monitoring Panel (CAP-043)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

## Description

The developer console's run inspection panel renders a sorted event timeline for any
`run_id`: a list of all `StreamEvent`s for the run, ordered by emission sequence, each
expandable to show phase-specific payload detail. For live runs, the panel subscribes to
`GET /threads/{id}/runs/{run_id}/stream` (BC-2.12.007, SSE transport) and renders events
in real time, highlighting active nodes on the StateGraph DAG visualization. The console
is a pure SSE+REST client — no new server additions are required for this capability.

## Preconditions

1. {PRE-001} A `run_id` is selected (either from a list of runs, or from a new run initiated by the operator).
2. {PRE-002} The pregolya-server REST+SSE API is reachable at `apiBaseUrl` (injected via `runtime-config.json`, BC-2.24.001 {PC-003}).
3. {PRE-003} For live monitoring: the run is in `in_progress` or `pending` status; the SSE stream at `GET /threads/{id}/runs/{run_id}/stream` is open and delivering events.
4. {PRE-004} For completed run inspection: stored events are available via the thread's run record (the server persists StreamEvents for completed runs per BC-2.12.006).

## Postconditions

1. {PC-001} **Event timeline rendered:** All `StreamEvent` variants for the run are displayed in the timeline, ordered by emission sequence. Minimum supported variants (all 16 per ADR-006): `run_start`, `run_stream`, `run_end`, `step_start`, `step_end`, `node_start`, `node_stream`, `node_end`, `tool_start`, `tool_stream`, `tool_end`, `guardrail_decision`, `tool_approval_request`, `tool_approval_resolved`, `graph_interrupt`, `compaction_event`, and any future variants (consumer must not hard-fail on unknown variants per `#[non_exhaustive]`).

   > **D-356 adversary fix DC-01 (2026-09-06, product-owner).** PC-001 StreamEvent variant enumeration corrected (F-PDC01-02): removed phantom `run_error` (errors ride in `run_end`/RunEndData — no RunError variant in ss-06); added missing `step_start` and `tool_stream`; reordered to match the canonical 16 per ADR-006 causal ordering. Count is now exactly 16 distinct variants with no duplicates.
2. {PC-002} **Expandable payloads:** Each event row is expandable. Expanded view shows:
   - `node_start` / `node_end`: input/output state diff at that node boundary.
   - `tool_start` / `tool_end`: tool name, input args (JSON), output result (JSON).
   - `guardrail_decision`: boundary type, severity, outcome (Fail/Transform), reason string (for Fail).
   - `compaction_event`: compacted turn range (`compacted_start..=compacted_end`), `summary_token_count`, `tokens_remaining_after`.
   - `run_stream` / `node_stream`: accumulated token text (streaming token deltas).
   - Span latency detail link: opens span detail from BC-2.24.002 debug endpoints when available.
3. {PC-003} **Live SSE subscription:** For in-progress runs, the SPA opens a native browser `EventSource` on `GET /threads/{id}/runs/{run_id}/stream`. Events are appended to the timeline as they arrive. No WebSocket; SSE is the sole transport (ADR-031 Decision 3).
4. {PC-004} **Live node highlighting:** Incoming `node_start` events set the named node to "active" in the StateGraph DAG visualization (BC-2.24.003 graph descriptor). Incoming `node_end` events clear the active state. The highlighting is driven exclusively by matching `node_start.node_name` / `node_end.node_name` to descriptor node names.
5. {PC-005} **Token streaming:** `run_stream` and `node_stream` events deliver token-level text deltas. The console accumulates and displays them inline in the timeline row, updating on each delta.
6. {PC-006} **Completed run inspection:** For a completed run, the SPA fetches the stored event list via the server's run-event endpoint and renders the full timeline in a non-live (static) view.

## Invariants

- {INV-001} **Pure consumer:** The console does NOT modify server state during run inspection. It reads via SSE and REST only. No new server endpoints are required.
- {INV-002} **SSE transport only (ADR-031 Decision 3):** The live monitoring subscription uses the browser native `EventSource` API over `GET /threads/{id}/runs/{run_id}/stream`. WebSocket is NOT used. The SPA MUST NOT include a WebSocket polyfill or client for this path.
- {INV-003} **Unknown event variants tolerated:** The SPA renders a generic "raw JSON" expanded view for any `StreamEvent` variant it does not recognize, rather than erroring. This supports forward compatibility when new variants are added to the enum (per `#[non_exhaustive]` on `StreamEvent`).
- {INV-004} **DI-014:** SSE stream disconnection (TCP drop, server shutdown) causes the SPA to display a reconnection indicator. Reconnect is attempted with exponential back-off. The reconnection attempt is observable to the user; it does not silently fail.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | SSE stream disconnects mid-run | SPA shows reconnection indicator; reconnect attempted with back-off; timeline preserves already-received events |
| {EC-002} | Run has no events (brand-new run, no super-steps completed) | Timeline renders empty state ("no events yet") |
| {EC-003} | Run contains an unknown `StreamEvent` variant (future extension) | Unknown variant rendered as "Unknown event [raw JSON]" — no hard failure |
| {EC-004} | `node_start` event references a node not in the graph descriptor | Node highlighted as "unknown" in DAG (e.g., greyed out with name); no JS error; graph descriptor not re-fetched mid-run |
| {EC-005} | Multiple concurrent live runs being monitored | Each run has its own independent `EventSource` subscription; events do not bleed between timelines |
| {EC-006} | `compaction_event` arrives during live monitoring | Timeline annotates the compaction boundary; context-window gauge (BC-2.24.007) updates; existing event rows unaffected |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Live run; 3 `node_start`/`node_end` pairs received via SSE | Timeline shows 6 event rows in order; active node highlighted on each `node_start`; cleared on `node_end` | happy-path, live monitoring |
| TV-002 | Completed run with 5 stored events fetched | Timeline renders all 5 events in emission order; no SSE connection opened | completed-run inspection |
| TV-003 | `tool_start` event with `tool_name: "ReadFile"` and args `{path: "/tmp/test.txt"}` | Expandable row shows tool name and args JSON | tool event expansion |
| TV-004 | SSE stream disconnects after 3 events | 3 events shown; reconnection indicator displayed; no data lost for already-received events | EC-001 |
| TV-005 | Unknown `StreamEvent` variant `{"type": "future_variant", ...}` | Row rendered as "Unknown event" with raw JSON; no error thrown | EC-003 |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.004-A | All 16 existing StreamEvent variants render without error | Integration test: inject one of each variant into SSE stream; assert all timeline rows appear |
| VP-2.24.004-B | Live node highlight fires on `node_start`, clears on `node_end` | Integration test: ordered node_start/node_end pairs; assert highlight state transitions |

## Related BCs

- BC-2.12.007 — depends on: SSE streaming run output endpoint (public contract consumed)
- BC-2.24.003 — depends on: graph descriptor for live node highlighting
- BC-2.24.007 — composes with: compaction events processed by budget panel (BC-2.24.007) in addition to timeline rendering
- BC-2.24.008 — composes with: guardrail events displayed in both this timeline and the security feed (BC-2.24.008)

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — Decision 3 (SSE transport confirmed; no WebSocket)
- `architecture/decisions/ADR-006-streaming-event-taxonomy.md` — 16-variant StreamEvent grammar consumed by this panel

## Story Anchor

S-console-06 (Wave 3 — run inspection panel + live node highlighting)

> **D-356 adversary fix DC-01 (2026-09-06, product-owner).** Story Anchor corrected S-console-05 → S-console-06. story-writer split BC-2.24.002 across S-console-02+03 and added S-console-05 (SPA build, no BC), shifting the numbering. Verified: S-console-06 frontmatter carries `behavioral_contracts: [BC-2.24.004]`.

## VP Anchors

- VP-2.24.004-A
- VP-2.24.004-B

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-043 |
| Capability Anchor Justification | CAP-043 ("Run Inspection and Live Monitoring Panel") per capabilities-p1-p2.md §CAP-043 — this BC specifies the event timeline, expandable payload detail, live SSE subscription, live node highlighting, and token streaming that constitute the run inspection and live monitoring panel described in CAP-043 |
| L2 Domain Invariants | DI-014 (Error Propagation — SSE disconnection surfaces as reconnection indicator; no silent failure) |
| Architecture Authority | ADR-031 Decision 3 (SSE transport, no WebSocket); ADR-006 (StreamEvent taxonomy — all 16 variants consumed) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.004-A/B |
| Module | pregolya-console / SPA (web frontend, pure REST+SSE client) |
| Priority | P1 |
| Wave | 3 |
| Test Types | integration (E2E) |
