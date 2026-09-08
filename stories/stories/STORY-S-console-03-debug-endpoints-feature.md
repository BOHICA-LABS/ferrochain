---
document_type: story
level: ops
story_id: S-console-03
epic_id: E-console
version: "1.2"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — debug-endpoints Cargo feature on pregolya-server, trace-read HTTP endpoints, E-SERVER-023 not-configured response."
  - "1.1 (D-356/2026-09-07, story-writer): F-PDC07-01 — renamed SecurityConfig field debug_api_key → debug_route_key throughout (BC-2.12.005 PRE-004/INV-001; ADR-021 §Decision 1); AC-005 updated to cover startup refusal E-SERVER-013 InvalidDebugRouteKey when key absent/empty (BC-2.24.002 PC-007/EC-007)."
  - "1.2 (D-356/2026-09-07, story-writer): F-PDC10-02 — dependency inversion applied per ADR-031 Decision 7: server reads via Arc<dyn DebugSpanSource> (server-owned trait); pregolya-console path dep row removed from Library requirements; server::debug_span (own module) replaces it; AC-001/AC-002 SpanData attributed as server::debug_span server-owned type; AC-008 Arc<DebugSpanExporter> -> Arc<dyn DebugSpanSource>; Task 5 and Previous Story Intelligence updated."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.002.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
  - .factory/specs/prd-supplements/error-taxonomy.md
input-hash: "2d81652"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-02]
blocks: [S-console-04, S-console-06]
behavioral_contracts: [BC-2.24.002]
verification_properties: [VP-2.24.002-C]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-server
subsystems: [SS-24, SS-12]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-03: `debug-endpoints` Cargo Feature and Trace-Read HTTP Endpoints

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-07 (2026-09-07, story-writer).** F-PDC07-01: `SecurityConfig.debug_api_key` renamed to `SecurityConfig.debug_route_key` in all live-body locations (AC-005, Task 7, Architecture Compliance Rules) per ADR-021 §Decision 1 (canonical SecurityConfig field name). AC-005 now covers both behaviours from BC-2.24.002 PC-007/EC-007: (1) empty/absent `debug_route_key` with `debug-endpoints` feature enabled → E-SERVER-013 InvalidDebugRouteKey at startup (refuse to start); (2) valid key present + unauthenticated request → E-SERVER-004 403 at runtime.

> **D-356 adversary fix DC-10 (2026-09-07, story-writer).** F-PDC10-02: dependency inversion applied (ADR-031 Decision 7). `SpanData` type + `DebugSpanSource` trait live in `pregolya-server/server::debug_span` (server-owned). `console::span_exporter` implements `DebugSpanSource` — `console→server` direction only; pregolya-server has zero compile dep on pregolya-console. All story locations updated: Architecture Mapping row, Library & Framework Requirements row (pregolya-console path dep removed; server::debug_span own-module row added), Task 5, AC-001/AC-002 SpanData ownership note, AC-008 `Arc<dyn DebugSpanSource>`, Previous Story Intelligence, Forbidden Patterns.

## Narrative

- **As a** developer running `pregolya console --dev`
- **I want to** query trace spans over HTTP at `GET /debug/trace/session/{session_id}` and `GET /debug/trace/{event_id}`
- **So that** the developer console SPA can display execution traces from the in-memory ring buffer without an external tracing backend

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.002 | `DebugSpanExporter` Retention-Capped Ring Buffer and Trace-Read Debug Endpoints (CAP-042) | AC-001..AC-008 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.002 postcondition PC-003)
`GET /debug/trace/session/{session_id}` returns `200 OK` with a JSON array of `SpanData` objects (`SpanData` is a server-owned type defined in `pregolya-server/server::debug_span`) ordered by `start_time_ms` ascending for the given `session_id`. When no spans match the `session_id`, returns `200 OK` with empty array `[]` (not 404). Verified by `test_BC_2_24_002_trace_session_found()` and `test_BC_2_24_002_trace_session_empty()`.

### AC-002 (traces to BC-2.24.002 postcondition PC-004)
`GET /debug/trace/{event_id}` returns `200 OK` with a single `SpanData` JSON object (`SpanData` is a server-owned type defined in `pregolya-server/server::debug_span`) when the `event_id` matches a span in the buffer. Returns `404 Not Found` when no span matches. Verified by `test_BC_2_24_002_trace_event_found()` and `test_BC_2_24_002_trace_event_not_found()`.

### AC-003 (traces to BC-2.24.002 postcondition PC-005)
When `DebugSpanExporter` is NOT injected into pregolya-server (standalone mode without dev_mode), both endpoints return `503 Service Unavailable` with body `{"error": "E-SERVER-023", "message": "DebugExporterNotConfigured: debug span exporter is not configured; start server via pregolya console --dev"}`. Error code is `E-SERVER-023` exactly. Verified by `test_BC_2_24_002_no_exporter_503()` (VP-2.24.002-C).

### AC-004 (traces to BC-2.24.002 postcondition PC-006)
The `debug-endpoints` Cargo feature defaults to `false` in `pregolya-server/Cargo.toml`. When the feature is disabled, neither `/debug/trace/session/{id}` nor `/debug/trace/{event_id}` routes exist — all requests to these paths return `404 Not Found`. No debug routing code is compiled in. Verified by `test_BC_2_24_002_feature_disabled_404()`.

### AC-005 (traces to BC-2.24.002 postcondition PC-007; traces to BC-2.24.002 edge case EC-007)
When the `debug-endpoints` feature is enabled and `SecurityConfig.debug_route_key` is empty or absent, the server refuses to start with E-SERVER-013 InvalidDebugRouteKey (BC-2.24.002 EC-007). When `debug_route_key` is set to a valid non-empty value, requests to `/debug/trace/*` without a matching key return `403 Forbidden` with `E-SERVER-004 DebugRouteUnauthorized` (BC-2.24.002 PC-007). Requests with a valid key proceed normally. Verified by `test_BC_2_24_002_debug_route_key_startup_gate()` (startup refusal) and `test_BC_2_24_002_debug_route_key_gate()` (runtime 403).

### AC-006 (traces to BC-2.24.002 edge case EC-004)
A production build of `pregolya-server` compiled WITHOUT the `debug-endpoints` feature has zero debug routing code. The CI gate `check-debug-endpoints-default` verifies `debug-endpoints = false` in `pregolya-server/Cargo.toml` feature defaults. Verified by `just check-debug-endpoints-default` CI task.

### AC-007 (traces to BC-2.24.002 edge case EC-005)
`GET /debug/trace/session/x` when the exporter is not configured returns `503` with the exact error body: `{"error": "E-SERVER-023", "message": "DebugExporterNotConfigured: debug span exporter is not configured; start server via pregolya console --dev"}`. No other response shape is acceptable. Verified by `test_BC_2_24_002_exporter_not_configured_body_exact()`.

### AC-008 (traces to BC-2.24.002 edge case EC-006)
Concurrent `GET /debug/trace/session/{id}` requests against the shared `Arc<dyn DebugSpanSource>` return consistent snapshots with no data race. The `RwLock` inside the concrete `DebugSpanExporter` (injected by the console layer) allows multiple concurrent readers. Verified by `test_BC_2_24_002_concurrent_read_consistent()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| `debug-endpoints` feature gate | `pregolya-server/Cargo.toml` | N/A (build config) |
| Trace-read HTTP handlers | `pregolya-server/src/server/debug_routes.rs` [feature debug-endpoints] | Effectful Shell |
| `DebugSpanSource` trait receiver | `pregolya-server/src/server/debug_routes.rs` | Boundary (reads via `Arc<dyn DebugSpanSource>`; trait + `SpanData` type owned by `server::debug_span`) |
| `E-SERVER-023` error response | `pregolya-server/src/server/debug_routes.rs` | Effectful Shell |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `server::debug_routes` | Effectful Shell | HTTP handler: reads from shared Arc state (async I/O via Axum), accesses AssistantStore, produces HTTP responses |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | `session_id` with no matching spans | Returns `200 OK` with empty array `[]` |
| EC-002 | `event_id` with no matching span | Returns `404 Not Found` |
| EC-003 | `debug-endpoints` feature disabled | Route does not exist; `404 Not Found` |
| EC-004 | No exporter injected | `503` with `E-SERVER-023` body |
| EC-005 | Concurrent reads | Thread-safe RwLock; consistent snapshots |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.002.md (~155 lines) | ~2,500 |
| ADR-031 §Decision 2 (~60 lines) | ~1,000 |
| `error-taxonomy.md` (E-SERVER-023 entry) | ~300 |
| `debug_routes.rs` (to create, ~120 code lines) | ~1,500 |
| Test module (~100 lines) | ~1,200 |
| Tool outputs | ~500 |
| **Total** | **~10,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~5%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs — `test_BC_2_24_002_*` family covering endpoints (test-writer)
2. [ ] Verify Red Gate — `cargo nextest run -p pregolya-server --features debug-endpoints` shows failures
3. [ ] Add `debug-endpoints = []` feature (default false) to `pregolya-server/Cargo.toml`
4. [ ] Create `pregolya-server/src/server/debug_routes.rs` behind `#[cfg(feature = "debug-endpoints")]`; implement `GET /debug/trace/session/{session_id}` and `GET /debug/trace/{event_id}` handlers
5. [ ] `server::debug_routes` reads via `Arc<dyn DebugSpanSource>` injected at launch by the console layer (`DebugSpanExporter` implements `DebugSpanSource`); pregolya-server has ZERO compile dependency on pregolya-console (ADR-031 Decision 7)
6. [ ] Implement `E-SERVER-023 DebugExporterNotConfigured` response when exporter is `None`
7. [ ] Add `SecurityConfig.debug_route_key` gate — refuse to start with E-SERVER-013 InvalidDebugRouteKey when key empty/absent and `debug-endpoints` feature is on (BC-2.24.002 EC-007); return E-SERVER-004 403 on unauthenticated runtime requests (BC-2.24.002 PC-007)
8. [ ] Register debug routes into the Axum router conditionally behind feature flag
9. [ ] Add CI task `check-debug-endpoints-default` verifying feature default is false
10. [ ] Run `cargo xtask check-file-size` — `debug_routes.rs` < 500 code lines
11. [ ] Run `cargo nextest run -p pregolya-server --features debug-endpoints` — all AC tests pass
12. [ ] Run `cargo nextest run -p pregolya-server` (no feature) — feature-disabled 404 test passes

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-02 (DebugSpanExporter + Arc DI). S-console-02 establishes the `DebugSpanSource` trait and `SpanData` type in `pregolya-server/server::debug_span`; `console::span_exporter::DebugSpanExporter` implements `DebugSpanSource`. At dev-mode startup the console layer injects `Arc<dyn DebugSpanSource>` into pregolya-server — pregolya-server has zero compile dep on pregolya-console (ADR-031 Decision 7). This story adds the HTTP endpoint surface. Follow the same Arc-DI injection pattern established in S-console-02.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| `debug-endpoints` feature defaults to `false` | BC-2.24.002 PC-006, ADR-031 Decision 6 (D6-3) | CI gate `check-debug-endpoints-default` |
| Error code `E-SERVER-023` (not E-SERVER-020) | BC-2.24.002 PC-005, D-356 correction | Code review; test asserts exact error code string |
| Debug routes compiled only with feature flag | ADR-031 Decision 2 | `cargo build -p pregolya-server` (no features) succeeds with no debug code |
| No `unwrap()` / `expect()` in `debug_routes.rs` | CLAUDE.md, BC-2.24.002 (DI-014) | `cargo xtask check-no-panic -p pregolya-server` |
| `SecurityConfig.debug_route_key` gate applied | BC-2.24.002 PC-007, EC-007 | Startup absent/empty key → E-SERVER-013 (refuse to start); runtime unauthenticated request → E-SERVER-004 403 |

**Forbidden patterns:** Returning 404 instead of 503 when exporter is absent. Error code E-SERVER-020 is incorrect — use E-SERVER-023 only. Adding a compile-time dependency on `pregolya-console` from `pregolya-server` — `debug_routes` must only reference `Arc<dyn DebugSpanSource>` (ADR-031 Decision 7); `DebugSpanExporter` must not appear in any `use` or `impl` statement inside `pregolya-server/`.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| `axum` | workspace pin | HTTP handlers for debug trace endpoints |
| `serde_json` | workspace pin | JSON serialization of `SpanData` array / object |
| `server::debug_span` | own module (pregolya-server) | `SpanData` type + `DebugSpanSource` trait — server-owned; zero compile dep on pregolya-console |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-server/Cargo.toml` | MODIFY | Add `debug-endpoints = []` feature (default false) |
| `crates/pregolya-server/src/server/debug_routes.rs` | CREATE | Trace-read HTTP handlers behind `#[cfg(feature = "debug-endpoints")]` |
| `crates/pregolya-server/src/server/mod.rs` | MODIFY | Conditionally register debug routes in router |
| `Justfile` | MODIFY | Add `check-debug-endpoints-default` recipe |
