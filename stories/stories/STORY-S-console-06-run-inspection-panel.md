---
document_type: story
level: ops
story_id: S-console-06
epic_id: E-console
version: "1.2"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — run inspection event timeline, live SSE monitoring, live node highlighting via graph descriptor."
  - "1.1 (D-356/2026-09-06, story-writer): F-PDC01-02 adversary fix — correct AC-001 StreamEvent variant list: drop phantom run_error, remove duplicate run_stream, add step_start and tool_stream to reach exactly 16 canonical variants per BC-2.24.004 PC-001 and ADR-006."
  - "1.2 (D-356/2026-09-07, story-writer): Adversary fix DC-02 — replace phantom graph_interrupt with error as the 16th canonical StreamEvent variant in AC-001. DC-01 introduced graph_interrupt believing it canonical; DC-02 corrects to the verified 16-variant list per BC-2.24.004 PC-001."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.004.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "2b5f8be"
traces_to: .factory/stories/STORY-INDEX.md
points: 8
depends_on: [S-console-03, S-console-04, S-console-05]
blocks: [S-console-08, S-console-09, S-console-10]
behavioral_contracts: [BC-2.24.004]
verification_properties: [VP-2.24.004-A, VP-2.24.004-B]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24]
estimated_days: 3
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-06: Run Inspection Event Timeline and Live SSE Monitoring Panel

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-01 (2026-09-06, story-writer).** F-PDC01-02 sibling-sweep: corrected AC-001 StreamEvent variant list to the canonical 16 per BC-2.24.004 PC-001 and ADR-006 rev-3. Dropped phantom `run_error` (never existed in the grammar), removed duplicate `run_stream` (was listed at positions 8 and 16 yielding only 15 distinct entries), and added the two omitted variants `step_start` and `tool_stream`. The canonical ordered set is now: `run_start`, `run_stream`, `run_end`, `step_start`, `step_end`, `node_start`, `node_stream`, `node_end`, `tool_start`, `tool_stream`, `tool_end`, `guardrail_decision`, `tool_approval_request`, `tool_approval_resolved`, `graph_interrupt`, `compaction_event`.

> **D-356 adversary fix DC-02 (2026-09-07, story-writer).** AC-001 StreamEvent variant list corrected again: the 16th canonical variant is `error`, not `graph_interrupt`. `graph_interrupt` is phantom — it does not exist in the 16-variant StreamEvent grammar per BC-2.24.004 PC-001 confirmed variant registry. The DC-01 fix (v1.1) replaced `run_error` with `graph_interrupt` while incrementing the position count to 16, but `graph_interrupt` was never a real variant. DC-02 corrects: slot 15 = `compaction_event`, slot 16 = `error`. Verified canonical set: `run_start`, `run_stream`, `run_end`, `step_start`, `step_end`, `node_start`, `node_stream`, `node_end`, `tool_start`, `tool_stream`, `tool_end`, `guardrail_decision`, `tool_approval_request`, `tool_approval_resolved`, `compaction_event`, `error`.

## Narrative

- **As a** developer observing a running or completed pregolya agent
- **I want to** see a sorted event timeline for any run with expandable payload detail and live node highlighting on the graph DAG
- **So that** I can inspect exactly what happened during execution — which nodes fired, what tools were called, what tokens streamed — without digging through raw logs

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.004 | Run Inspection Event Timeline and Live Monitoring Panel (CAP-043) | AC-001..AC-009 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.004 postcondition PC-001)
All 16 `StreamEvent` variants for the selected run are displayed in the timeline, ordered by emission sequence. The 16 variants are: `run_start`, `run_stream`, `run_end`, `step_start`, `step_end`, `node_start`, `node_stream`, `node_end`, `tool_start`, `tool_stream`, `tool_end`, `guardrail_decision`, `tool_approval_request`, `tool_approval_resolved`, `compaction_event`, and `error`. Unknown variants (future extensions) render as a generic "Unknown event" row without crashing (forward-compatible). Verified by `test_BC_2_24_004_all_variants_render()` (VP-2.24.004-A).

### AC-002 (traces to BC-2.24.004 postcondition PC-002)
Each event row in the timeline is expandable. Expanded view shows payload-type-specific detail: `node_start`/`node_end` shows input/output state diff; `tool_start`/`tool_end` shows tool name and args JSON; `guardrail_decision` shows boundary type, severity, and outcome; `compaction_event` shows compacted turn range, `summary_token_count`, and `tokens_remaining_after`; `run_stream`/`node_stream` shows accumulated token text. Verified by individual expand tests per variant type.

### AC-003 (traces to BC-2.24.004 postcondition PC-003)
For in-progress runs, the SPA opens a native browser `EventSource` on `GET /threads/{id}/runs/{run_id}/stream`. Events are appended to the timeline as they arrive. No WebSocket; `EventSource` is the only streaming mechanism used. Verified by `test_BC_2_24_004_sse_subscription_eventSource()`.

### AC-004 (traces to BC-2.24.004 postcondition PC-004)
Incoming `node_start` events set the named node to "active" in the StateGraph DAG visualization (populated from the graph descriptor endpoint). Incoming `node_end` events clear the active state. The matching is performed by `node_start.node_name` and `node_end.node_name` against descriptor node names. Verified by `test_BC_2_24_004_live_node_highlight_fires_on_node_start()` and `test_BC_2_24_004_live_node_highlight_clears_on_node_end()` (VP-2.24.004-B).

### AC-005 (traces to BC-2.24.004 postcondition PC-005)
`run_stream` and `node_stream` events deliver token-level text deltas. The SPA accumulates them inline in the timeline row, updating the displayed text on each delta. No batching delay; each delta updates the displayed text immediately. Verified by `test_BC_2_24_004_token_streaming_accumulated()`.

### AC-006 (traces to BC-2.24.004 postcondition PC-006)
For completed runs, the SPA fetches the stored event list via the run-event endpoint and renders the full timeline in a non-live (static) view. No `EventSource` is opened for completed runs. Verified by `test_BC_2_24_004_completed_run_static_view()`.

### AC-007 (traces to BC-2.24.004 invariant INV-003)
Unknown `StreamEvent` variants (e.g., future variants added after this story) render as a "Unknown event [raw JSON]" row without throwing a JavaScript error. The SPA must not hard-code a variant exhaustive list that breaks on new variants. Verified by `test_BC_2_24_004_unknown_variant_no_crash()`.

### AC-008 (traces to BC-2.24.004 invariant INV-004)
SSE stream disconnection (TCP drop, server shutdown) causes the SPA to display a reconnection indicator. Reconnect is attempted with exponential back-off. The reconnection attempt is visible to the user; it does not silently fail. Timeline preserves already-received events during reconnect. Verified by `test_BC_2_24_004_sse_disconnect_reconnect_indicator()`.

### AC-009 (traces to BC-2.24.004 edge case EC-004)
When a `node_start` event references a node name not present in the graph descriptor, the node is shown as "unknown" in the DAG visualization (greyed out with its name). No JavaScript error is thrown; the graph descriptor is not re-fetched mid-run. Verified by `test_BC_2_24_004_unknown_node_in_dag()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| Run inspection panel component | `spa/src/components/RunInspectionPanel.*` | N/A (SPA component) |
| SSE subscription logic | `spa/src/lib/sse.ts` | N/A (SPA, effectful — network I/O) |
| DAG visualization component | `spa/src/components/GraphDag.*` | N/A (SPA component) |
| Event timeline component | `spa/src/components/EventTimeline.*` | N/A (SPA component) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| Run inspection panel | N/A (SPA) | TypeScript/JS frontend components |
| SSE subscription | Pure consumer | Reads SSE stream; no server mutations |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | SSE stream disconnects mid-run | Reconnection indicator shown; back-off retry; existing events preserved |
| EC-002 | Run has no events | Empty state ("no events yet") |
| EC-003 | Unknown `StreamEvent` variant | "Unknown event [raw JSON]" row; no crash |
| EC-004 | `node_start` references unknown node | Node shown as "unknown" in DAG; no re-fetch; no error |
| EC-005 | Multiple concurrent live runs | Each run has independent `EventSource`; events do not bleed |
| EC-006 | `compaction_event` arrives during live monitoring | Timeline annotates compaction boundary; budget panel updates |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~4,500 |
| BC-2.24.004.md (~146 lines) | ~2,500 |
| ADR-031 §Decision 3 (SSE transport) | ~500 |
| SPA component source files (~400 lines TypeScript) | ~5,000 |
| Test files (~200 lines) | ~2,500 |
| Tool outputs | ~500 |
| **Total** | **~15,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~8%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests (E2E / component tests) for all ACs (test-writer)
2. [ ] Create `spa/src/lib/sse.ts` — typed `EventSource` wrapper with reconnect logic and back-off
3. [ ] Create `spa/src/components/EventTimeline.*` — ordered list of timeline events with expand/collapse
4. [ ] Implement per-variant expanded payload detail views (AC-002) — at minimum `node_start/end`, `tool_start/end`, `guardrail_decision`, `compaction_event`, `run_stream/node_stream`
5. [ ] Create `spa/src/components/GraphDag.*` — DAG visualization component consuming `GraphDescriptor` from S-console-04 endpoint; live node highlighting from `node_start`/`node_end` SSE events
6. [ ] Create `spa/src/components/RunInspectionPanel.*` — composes EventTimeline + GraphDag + SSE subscription
7. [ ] Implement completed-run fetch path (no SSE; fetch stored events list)
8. [ ] Implement unknown-variant fallback ("Unknown event [raw JSON]") — AC-007
9. [ ] Add `EventSource` reconnect with exponential back-off — AC-008
10. [ ] Run SPA tests — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessors: S-console-03 (debug trace endpoints), S-console-04 (graph descriptor endpoint), S-console-05 (SPA build pipeline). The SPA framework, build tooling, and `EventSource` helper patterns are established by S-console-05. The graph descriptor JSON shape is defined by S-console-04. The SSE stream format is defined by `StreamEvent` grammar (ADR-006 rev-3, 16 variants). Reuse the `sse.ts` library across all panel stories (S-console-06 through S-console-10).

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| SSE via native `EventSource` only — no WebSocket | BC-2.24.004 INV-002, ADR-031 Decision 3 | CI grep check; bundle analysis |
| Unknown variants tolerated (forward compatibility) | BC-2.24.004 INV-003 | Test: inject unknown variant; assert no error |
| Shared SSE subscription (ONE EventSource per run) | BC-2.24.004 INV-003 / budget panel INV-003 | Code review: single `EventSource` instance per run_id |
| SPA does not write to server state during inspection | BC-2.24.004 INV-001 | Code review: no POST/PUT/PATCH in run inspection path |
| SSE disconnect surfaces reconnect indicator to user | BC-2.24.004 INV-004 (DI-014) | Integration test: disconnect mock; assert indicator visible |

**Forbidden patterns:** Opening multiple `EventSource` connections for the same run (one per panel). Silently swallowing SSE disconnects. Hard-coding the 16-variant list in an exhaustive switch with no fallback.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| Framework (from S-console-05) | Per S-console-05 selection | SPA components |
| Native browser `EventSource` | Web standard | SSE subscription — NO polyfill |
| D3.js or similar (optional) | Latest stable at Wave 3 | DAG visualization (team choice at Wave 3) |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/spa/src/lib/sse.ts` | CREATE | Typed `EventSource` wrapper with reconnect and back-off |
| `crates/pregolya-console/spa/src/components/EventTimeline.*` | CREATE | Ordered timeline with per-variant expand/collapse |
| `crates/pregolya-console/spa/src/components/GraphDag.*` | CREATE | DAG visualization with live node highlighting |
| `crates/pregolya-console/spa/src/components/RunInspectionPanel.*` | CREATE | Top-level panel composing timeline + DAG + SSE |
| `crates/pregolya-console/spa/src/pages/RunPage.*` | CREATE | Route handler for a selected run |
