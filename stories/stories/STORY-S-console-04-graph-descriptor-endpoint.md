---
document_type: story
level: ops
story_id: S-console-04
epic_id: E-console
version: "1.4"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — graph::descriptor Pure Core extraction + GET /assistants/{id}/graph endpoint, E-SERVER-009 AssistantNotFound."
  - "1.1 (D-356/DC-15/2026-09-08, story-writer): F-PDC15-01 — target_module corrected from scalar `pregolya-server` to list `[pregolya-graph, pregolya-server]`; story CREATEs descriptor.rs in pregolya-graph (primary Pure Core deliverable) and MODIFYs debug_routes.rs in pregolya-server; VP-2.24.003-A/B are pregolya-graph, VP-2.24.003-C is pregolya-server; aligns with STORY-INDEX and sprint-state."
  - "1.2 (D-356/DC-19/2026-09-08, story-writer): F-PDC19-02 — VP-2.24.003-C is pregolya-graph (graph::descriptor, start-node-present property, unit/phase-3), NOT pregolya-server; stale claim in v1.1 entry corrected. AC-007 already correctly anchors VP-2.24.003-A and VP-2.24.003-C to test_BC_2_24_003_compile_graph_descriptor_pure() in pregolya-graph."
  - "1.3 (D-356/DC-23/2026-09-08, story-writer): F-PDC23-02 — AC-006 error envelope corrected: {\"error\":} → {\"code\":}; message placeholder genericized to <id> per BC-2.24.003 v1.3. Zero {\"error\":} residue in live body."
  - "1.4 (D-356/DC-46/2026-09-09, story-writer): F-PDC46-01 — AC header citation form corrected to M4-strict bare-tag: BC-S.SS.NNN TAG (section-words removed per verify-ac-pc-trace.sh CHECK-1)."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.003.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "e59f85a"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-03]
blocks: [S-console-06]
behavioral_contracts: [BC-2.24.003]
verification_properties: [VP-2.24.003-A, VP-2.24.003-B, VP-2.24.003-C]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: [pregolya-graph, pregolya-server]
subsystems: [SS-24, SS-02]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-04: `graph::descriptor` Pure Core Module and `GET /assistants/{id}/graph` Endpoint

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

## Narrative

- **As a** developer console SPA (or a CI pipeline)
- **I want to** call `GET /assistants/{id}/graph` and receive a JSON structural descriptor of the compiled `StateGraph`
- **So that** the console SPA can render a DAG visualization for live node highlighting during run inspection

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.003 | Graph-Descriptor Structural Contract — `GET /assistants/{id}/graph` (CAP-042) | AC-001..AC-009 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.003 PC-001)
`GET /assistants/{id}/graph` returns `200 OK` with `Content-Type: application/json` and a body conforming to `GraphDescriptor` with fields `nodes` (array of `{ "name": string, "kind": "node|start|end|branch" }`), `edges` (array of `{ "source": string, "target": string, "condition": string|null }`), and `dot_src` (string or null). Verified by `test_BC_2_24_003_graph_descriptor_shape()`.

### AC-002 (traces to BC-2.24.003 PC-002)
Every node registered in the `CompiledStateGraph` appears exactly once in the `nodes` array. No node is omitted; no phantom nodes are included. Verified by `test_BC_2_24_003_nodes_completeness()` (VP-2.24.003-A).

### AC-003 (traces to BC-2.24.003 PC-003)
Every directed edge in the compiled graph appears in the `edges` array. Conditional edges carry their condition label in `"condition"`; unconditional edges carry `"condition": null`. Verified by `test_BC_2_24_003_edges_completeness()`.

### AC-004 (traces to BC-2.24.003 PC-004)
When the `dot` binary is not in `PATH`, `dot_src` is `null` in the response but `nodes` and `edges` are fully populated. The absence of `dot_src` does not cause a 500 or partial response. Verified by `test_BC_2_24_003_dot_src_null_when_absent()`.

### AC-005 (traces to BC-2.24.003 PC-005)
The descriptor is a structural snapshot — it carries no runtime state. The same assistant returns the identical descriptor on two consecutive calls (deterministic). Verified by `test_BC_2_24_003_static_snapshot_deterministic()`.

### AC-006 (traces to BC-2.24.003 PC-006)
`GET /assistants/nonexistent-id/graph` returns `404 Not Found` with `{"code": "E-SERVER-009", "message": "AssistantNotFound: assistant '<id>' does not exist"}`. Error code is `E-SERVER-009` exactly (existing code — no new code minted). Verified by `test_BC_2_24_003_assistant_not_found_404()`.

### AC-007 (traces to BC-2.24.003 INV-001)
The transformation function `fn compile_graph_descriptor(graph: &CompiledStateGraph) -> GraphDescriptor` is extracted as a free function in module `graph::descriptor` in `pregolya-graph` (Pure Core). It has no I/O, no async, no global state. A unit test calls it without an async runtime. Verified by `test_BC_2_24_003_compile_graph_descriptor_pure()` (VP-2.24.003-A, VP-2.24.003-C).

### AC-008 (traces to BC-2.24.003 INV-002)
`GraphDescriptor`, `GraphNode`, and `GraphEdge` each carry `#[non_exhaustive]`. Compile-fail tests confirm external code cannot construct these as struct literals. Verified by compile-fail tests in `tests/external/graph-descriptor-non-exhaustive/`.

### AC-009 (traces to BC-2.24.003 EC-004)
A graph with branch nodes produces a descriptor where branch nodes have `kind: "branch"` and their outgoing conditional edges carry non-null `condition` labels. A graph with no conditional edges produces all edges with `"condition": null`. Verified by `test_BC_2_24_003_branch_node_kind()` and `test_BC_2_24_003_linear_graph_null_condition()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| `fn compile_graph_descriptor` | `pregolya-graph/src/graph/descriptor.rs` | Pure Core |
| `GraphDescriptor`, `GraphNode`, `GraphEdge` types | `pregolya-graph/src/graph/descriptor.rs` | Pure Core (data types) |
| `GET /assistants/{id}/graph` HTTP handler | `pregolya-server/src/server/debug_routes.rs` [feature debug-endpoints] | Effectful Shell |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `graph::descriptor` | Pure Core | `fn compile_graph_descriptor` is deterministic, no I/O, no mutable state; required extraction for Phase 6 formal verification |
| HTTP handler in `debug_routes.rs` | Effectful Shell | Queries AssistantStore (async I/O), serializes response |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | Assistant not found | `404` with `E-SERVER-009 AssistantNotFound` |
| EC-002 | `dot` binary not in PATH | `dot_src: null`; nodes/edges still fully populated |
| EC-003 | Graph has no conditional edges | All edges have `"condition": null` |
| EC-004 | Graph has branch nodes | Branch nodes have `kind: "branch"`; outgoing edges carry condition labels |
| EC-005 | Concurrent requests to same endpoint | Pure function; no shared mutable state; no race |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.003.md (~155 lines) | ~2,500 |
| ADR-031 §Decision 2 graph-descriptor shape (~40 lines) | ~600 |
| `graph/descriptor.rs` (to create, ~100 code lines) | ~1,200 |
| `debug_routes.rs` extension (~50 code lines) | ~600 |
| Test module (~100 lines) | ~1,200 |
| Tool outputs | ~400 |
| **Total** | **~10,000** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests — `test_BC_2_24_003_*` family (test-writer)
2. [ ] Verify Red Gate — `cargo nextest run -p pregolya-graph -p pregolya-server --features debug-endpoints` shows failures
3. [ ] Create `pregolya-graph/src/graph/descriptor.rs` — `pub struct GraphDescriptor`, `GraphNode`, `GraphEdge` (all `#[non_exhaustive]`); `pub fn compile_graph_descriptor(graph: &CompiledStateGraph) -> GraphDescriptor`
4. [ ] Register `pub mod descriptor;` in `pregolya-graph/src/graph/mod.rs`
5. [ ] Add `GET /assistants/{id}/graph` handler to `pregolya-server/src/server/debug_routes.rs` behind `#[cfg(feature = "debug-endpoints")]`
6. [ ] Implement `E-SERVER-009 AssistantNotFound` response (reuse existing error code — do NOT mint a new code)
7. [ ] Implement optional `dot_src` population (run `dot` subprocess if in PATH; return null if absent)
8. [ ] Add compile-fail tests in `tests/external/graph-descriptor-non-exhaustive/`
9. [ ] Run `cargo xtask check-file-size` — `descriptor.rs` < 500 code lines
10. [ ] Final `cargo nextest run -p pregolya-graph -p pregolya-server --features debug-endpoints` — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-03 (debug-endpoints feature gate). The `debug_routes.rs` module and the `debug-endpoints` feature are now established on `pregolya-server`. This story extends `debug_routes.rs` with the graph-descriptor handler and creates the new `graph::descriptor` Pure Core module in `pregolya-graph`. The existing `CompiledStateGraph` struct is available in `pregolya-graph/src/graph/`; use its public interface only.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| `compile_graph_descriptor` is Pure Core (no I/O, no async) | BC-2.24.003 INV-001, ADR-031 Decision 5 | Unit test without async runtime; no `tokio` in `descriptor.rs` |
| `GraphDescriptor`, `GraphNode`, `GraphEdge` are `#[non_exhaustive]` | BC-2.24.003 INV-002, CLAUDE.md | Compile-fail test |
| No runtime state in descriptor (structural only) | BC-2.24.003 INV-003 | Code review; test: same graph produces identical descriptors on repeated calls |
| No `unwrap()` / `expect()` in non-test code | CLAUDE.md, BC-2.24.003 INV-004 | `cargo xtask check-no-panic` |
| Error code `E-SERVER-009` (not E-SERVER-021) | BC-2.24.003 PC-006, D-356 correction | Test asserts exact error code string |
| `dot_src` gracefully absent when `dot` not in PATH | BC-2.24.003 PC-004 | Test with mocked PATH that excludes `dot` |

**Forbidden patterns:** Minting `E-SERVER-021` — that code is incorrect. `E-SERVER-009` is the existing `AssistantNotFound` error code. Embedding runtime state (checkpoint IDs, current node position) in `GraphDescriptor` — it is a structural snapshot only.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| `serde` | workspace pin | `#[derive(Serialize)]` on descriptor types |
| `serde_json` | workspace pin | JSON serialization in test assertions |
| `std::process::Command` | std | Optionally invoke `dot` subprocess for `dot_src` |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-graph/src/graph/descriptor.rs` | CREATE | `GraphDescriptor`, `GraphNode`, `GraphEdge`, `fn compile_graph_descriptor` — Pure Core |
| `crates/pregolya-graph/src/graph/mod.rs` | MODIFY | Add `pub mod descriptor;` |
| `crates/pregolya-server/src/server/debug_routes.rs` | MODIFY | Add `GET /assistants/{id}/graph` handler behind `debug-endpoints` feature |
| `tests/external/graph-descriptor-non-exhaustive/` | CREATE | Compile-fail tests for descriptor types |
