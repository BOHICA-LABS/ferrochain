---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.003
version: "1.2"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-042
crate: pregolya-server
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. Graph-descriptor structural contract for GET /assistants/{id}/graph endpoint."
  - "1.1 (D-356-fix/DC-01/2026-09-06, product-owner): F-PDC01-01 Story Anchor corrected: was S-console-03, now S-console-04. Verified against S-console-04 frontmatter behavioral_contracts: [BC-2.24.003]."
  - "1.2 (D-356-fix/DC-07/2026-09-07, product-owner): F-PDC07-01: PC-007 corrected — debug_api_key→debug_route_key (canonical field: SecurityConfig.debug_route_key per BC-2.12.005 PRE-004/INV-001; ADR-021 §Decision 1)."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-042
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "5ff81d4"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.003: Graph-Descriptor Structural Contract — `GET /assistants/{id}/graph` (CAP-042)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

> **D-356 adversary fix DC-07 (2026-09-07, product-owner).** F-PDC07-01: PC-007 corrected — `debug_api_key` → `debug_route_key`. `SecurityConfig.debug_route_key: Option<String>` is the canonical gate field (BC-2.12.005 PRE-004/PC-006/PC-007/INV-001; ADR-021 §Decision 1).

## Description

`GET /assistants/{id}/graph` (feature-gated on `debug-endpoints`) returns a structural
JSON descriptor of the compiled `StateGraph` for the named assistant. The descriptor is a
static structural snapshot: nodes with their names and kinds, edges with source, target,
and optional condition labels, and an optional Graphviz DOT source string. The
transformation from `CompiledStateGraph` to `GraphDescriptor` is a pure, deterministic
function extracted to `graph::descriptor` (pregolya-graph Pure Core) before Phase 6.
When the assistant does not exist, the endpoint returns HTTP 404 with `E-SERVER-009
AssistantNotFound`.

## Preconditions

1. {PRE-001} The `debug-endpoints` Cargo feature is enabled on `pregolya-server` at build time. Default: OFF.
2. {PRE-002} A `pregolya-server` instance is running with at least one registered assistant (a named agent config pointing to a compiled `StateGraph`).
3. {PRE-003} The named assistant `{id}` exists in the server's `AssistantStore`.
4. {PRE-004} The `CompiledStateGraph` referenced by the assistant is introspectable (its node registry and edge list are accessible at runtime).

## Postconditions

1. {PC-001} **Success response:** `GET /assistants/{id}/graph` returns HTTP 200 with `Content-Type: application/json` and a body conforming to `GraphDescriptor`:
   ```json
   {
     "nodes": [
       { "name": "<node_name>", "kind": "node|start|end|branch" }
     ],
     "edges": [
       { "source": "<node_name>", "target": "<node_name>", "condition": "<label_or_null>" }
     ],
     "dot_src": "<graphviz_dot_source_or_null>"
   }
   ```
2. {PC-002} **`nodes` completeness:** Every node registered in the `CompiledStateGraph` appears exactly once in the `nodes` array. No node is omitted; no phantom nodes are included.
3. {PC-003} **`edges` completeness:** Every directed edge in the compiled graph (including conditional edges) appears in the `edges` array. Conditional edges carry their condition label; unconditional edges carry `"condition": null`.
4. {PC-004} **`dot_src` optional:** `dot_src` is populated when the `dot` binary (Graphviz) is available in PATH at runtime. When absent, `dot_src` is `null`. The absence of `dot_src` does not affect `nodes`/`edges` completeness.
5. {PC-005} **Static snapshot semantics:** The descriptor is a structural snapshot of the compiled graph — it carries no runtime state (no current node position, no message content, no checkpoint IDs). Repeated calls return the same descriptor for the same graph version.
6. {PC-006} **Assistant not found:** When `{id}` does not match any registered assistant, returns HTTP 404 with `E-SERVER-009 AssistantNotFound` (existing code — no new code minted for this case).
7. {PC-007} **`debug_route_key` gate:** Subject to `SecurityConfig.debug_route_key` (BC-2.12.005) — same gate as all `/debug/*` endpoints (BC-2.12.005 PC-006/PC-007).

## Invariants

- {INV-001} **Pure-core extraction (ADR-031 Decision 2):** The transformation `fn compile_graph_descriptor(graph: &CompiledStateGraph) -> GraphDescriptor` MUST be extracted as a free function in `graph::descriptor` (pregolya-graph, Pure Core) before Phase 6. This enables formal verification of graph structural invariants (no self-loops, connected start node).
- {INV-002} **`GraphDescriptor` is `#[non_exhaustive]`:** `GraphDescriptor`, `GraphNode`, and `GraphEdge` are public API-surface types and MUST carry `#[non_exhaustive]` per workspace conventions.
- {INV-003} **No runtime state in descriptor:** The `GraphDescriptor` contains structural information only. It MUST NOT include checkpoint state, run state, message content, or any runtime mutable data.
- {INV-004} **DI-014:** Errors (assistant not found, graph introspection failure) propagate via structured `PregolyaError` — no panic, no `unwrap()`.
- {INV-005} **Library-consumer usefulness:** This endpoint is available to headless programmatic consumers (CI pipelines, tooling integrations) not just the browser UI — it belongs in `pregolya-server` not `pregolya-console` (ADR-031 Decision 2 rationale).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | `{id}` does not match any registered assistant | `404 Not Found` with `E-SERVER-009 AssistantNotFound: assistant '<id>' does not exist` |
| {EC-002} | `dot` binary not in PATH | `dot_src: null` in response; `nodes`/`edges` still fully populated; `200 OK` |
| {EC-003} | Graph has no conditional edges (linear pipeline) | All edges have `"condition": null`; response valid |
| {EC-004} | Graph has branch nodes (conditional routing) | Branch node has kind `"branch"`; outgoing conditional edges carry condition labels |
| {EC-005} | `debug-endpoints` feature disabled | Route does not exist; `404 Not Found`; no code compiled in |
| {EC-006} | Concurrent `GET /assistants/{id}/graph` requests | No race condition; each request returns a consistent structural snapshot (pure function, no shared mutable state) |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `GET /assistants/my-assistant/graph`; assistant has 3 nodes (start, agent, end) and 2 edges | `200 OK`; `nodes` has 3 entries; `edges` has 2 entries with `condition: null`; `dot_src: null` (no dot binary in test env) | happy-path |
| TV-002 | `GET /assistants/nonexistent/graph` | `404 Not Found`; `E-SERVER-009 AssistantNotFound` | EC-001 |
| TV-003 | Graph with a branch node and 2 outgoing conditional edges | `200 OK`; branch node has `kind: "branch"`; 2 edges have non-null `condition` labels | EC-004 |
| TV-004 | `debug-endpoints` feature disabled; request to endpoint | `404 Not Found` | EC-005 |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.003-A | `compile_graph_descriptor` emits exactly the nodes registered in the graph (no omissions, no phantoms) | Unit test: construct graphs of varying sizes; assert nodes array matches registered node set |
| VP-2.24.003-B | Graph-descriptor has no self-loops (a node does not edge to itself) | Proptest / Kani candidate on `graph::descriptor` Pure Core — target: `no_self_loop_invariant` |
| VP-2.24.003-C | Start node is always present in the descriptor | Unit test: assert `nodes` contains at least one entry with `kind: "start"` |

## Related BCs

- BC-2.24.001 — depends on: debug-endpoints feature compiled into co-launched server (dev-mode BC-2.24.001)
- BC-2.24.002 — sibling: trace-read endpoints (BC-2.24.002) share the same `debug-endpoints` feature gate
- BC-2.24.004 — composes with: run inspection panel (BC-2.24.004) uses graph descriptor for live node highlighting

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — Decision 2 (graph-descriptor shape, `dot_src` optional, E-SERVER-009 reuse, pure-core extraction requirement), Decision 5 (`graph::descriptor` Pure Core classification)
- `architecture/ARCH-INDEX.md` — SS-24 entry; SS-02 (pregolya-graph, source of `CompiledStateGraph`)

## Story Anchor

S-console-04 (Wave 3 — graph::descriptor Pure Core module + GET /assistants/{id}/graph endpoint)

> **D-356 adversary fix DC-01 (2026-09-06, product-owner).** Story Anchor corrected S-console-03 → S-console-04. story-writer split BC-2.24.002 across S-console-02+03 and added S-console-05 (SPA build, no BC), shifting the numbering. Verified: S-console-04 frontmatter carries `behavioral_contracts: [BC-2.24.003]`.

## VP Anchors

- VP-2.24.003-A
- VP-2.24.003-B
- VP-2.24.003-C

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-042 |
| Capability Anchor Justification | CAP-042 ("Debug Infrastructure Endpoints (Feature-Gated)") per capabilities-p1-p2.md §CAP-042 — this BC specifies the graph-descriptor endpoint contract (node/edge JSON + optional DOT), which is the second half of the debug infrastructure described in CAP-042 alongside the trace-read endpoints (BC-2.24.002) |
| L2 Domain Invariants | DI-014 (Error Propagation — AssistantNotFound propagates as structured Err; graph introspection failures do not panic) |
| Architecture Authority | ADR-031 Decision 2 (graph-descriptor JSON shape, pure-core extraction requirement, E-SERVER-009 reuse for AssistantNotFound) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.003-A/B/C |
| Module | pregolya-server / server::debug_routes [feature debug-endpoints] (Effectful Shell) + pregolya-graph / graph::descriptor (Pure Core, extracted before Phase 6) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + proptest |
