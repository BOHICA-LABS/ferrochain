---
document_type: story
level: ops
story_id: S-console-02
epic_id: E-console
version: "1.0"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — DebugSpanExporter FIFO ring buffer, OTel SpanExporter trait, dev-mode co-launch wiring, Arc DI."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.001.md
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.002.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "6b81e95"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: [S-console-01]
blocks: [S-console-03]
behavioral_contracts: [BC-2.24.001, BC-2.24.002]
verification_properties: [VP-2.24.002-A, VP-2.24.002-B, VP-2.24.002-C]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-02: `DebugSpanExporter` FIFO Ring Buffer

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

## Narrative

- **As a** developer using `pregolya console --dev`
- **I want to** have execution spans collected in an in-memory ring buffer as the engine runs
- **So that** the developer console can read and display trace data without requiring an external observability backend

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.001 | `pregolya-console` Startup, Asset Serving, and `ConsoleConfig` (CAP-041) | AC-001, AC-002 (dev-mode clauses PC-004, PC-005) |
| BC-2.24.002 | `DebugSpanExporter` Retention-Capped Ring Buffer and Trace-Read Debug Endpoints (CAP-042) | AC-003..AC-010 |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.001 postcondition PC-004)
When `run_console` is called with `dev_mode: true`, the pregolya-server `/api/*` routes are merged into the same Axum router as `/ui/*`. Both SPA assets and server API are served from the single `<host>:<port>` listener. `POST /api/shutdown` is available. Verified by `test_BC_2_24_001_dev_mode_routes_merged()`.

### AC-002 (traces to BC-2.24.001 postcondition PC-005)
When `dev_mode: true`, a `DebugSpanExporter` (ring buffer with `span_retention_cap` entries) is instantiated and injected into the co-launched pregolya-server as its configured OTel span exporter via `Arc<DebugSpanExporter>`. In standalone mode (`dev_mode: false`), `DebugSpanExporter` is not instantiated by the console crate. Verified by `test_BC_2_24_001_dev_mode_exporter_injected()`.

### AC-003 (traces to BC-2.24.002 postcondition PC-001)
The `DebugSpanExporter` stores up to `span_retention_cap` `SpanData` entries. When the buffer is at capacity and a new span arrives, the oldest span is evicted (FIFO). After eviction, buffer length remains exactly `span_retention_cap`. No unbounded growth. Verified by `test_BC_2_24_002_ring_buffer_fifo_eviction()` (VP-2.24.002-A, VP-2.24.002-B).

### AC-004 (traces to BC-2.24.002 postcondition PC-002)
Each stored span has `SpanData` with fields: `span_id: String`, `trace_id: String`, `start_time_ms: u64`, `end_time_ms: u64`, `attributes: serde_json::Map<String, Value>`, `llm_request: Option<Value>`, `llm_response: Option<Value>`. All fields are present; no field is missing. Verified by `test_BC_2_24_002_span_data_shape()`.

### AC-005 (traces to BC-2.24.002 invariant INV-002)
The `RingBuffer<SpanData>` data structure is extractable as Pure Core — it has no I/O, no async, no global state. A unit test exercises `RingBuffer` insert, eviction, and read operations without an async runtime. Verified by `test_BC_2_24_002_ring_buffer_pure_core_sync()`.

### AC-006 (traces to BC-2.24.002 invariant INV-003)
`SpanData` carries `#[non_exhaustive]`. A compile-fail test confirms external code cannot construct `SpanData { .. }` as a struct literal. Verified by compile-fail test in `tests/external/span-data-non-exhaustive/`.

### AC-007 (traces to BC-2.24.002 invariant INV-005)
`DebugSpanExporter` is shared between the console server and the pregolya-server debug routes via `Arc<DebugSpanExporter>`. The `Arc` wraps the exporter; both the console server and the debug-routes handler hold a clone of the same `Arc`. Verified by `test_BC_2_24_002_arc_shared_exporter()`.

### AC-008 (traces to BC-2.24.002 invariant INV-001)
The ring buffer never exceeds `span_retention_cap` entries under any number of concurrent insertions. Concurrent insert + read does not produce data races — internal synchronization (RwLock or similar) ensures thread-safety. Verified by `test_BC_2_24_002_concurrent_insert_read_no_race()` (VP-2.24.002-A).

### AC-009 (traces to BC-2.24.002 edge case EC-001)
When the ring buffer is at capacity and a batch of 5 new spans arrives, exactly `span_retention_cap` spans remain, the 5 oldest have been evicted in FIFO order, and the 5 newest have been inserted. Verified by `test_BC_2_24_002_batch_eviction_fifo_order()` (VP-2.24.002-B).

### AC-010 (traces to BC-2.24.002 invariant INV-004)
Span export errors (OTel export callback failure) are logged via `tracing::warn!` and do not propagate to the engine — engine execution continues uninterrupted. The `SpanExporter::export()` implementation on `DebugSpanExporter` never returns an error that would abort the exporter pipeline. Verified by `test_BC_2_24_002_export_error_logged_not_propagated()`.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| `RingBuffer<T>` data structure | `pregolya-console/src/console/ring_buffer.rs` | Pure Core |
| `DebugSpanExporter` (OTel trait) | `pregolya-console/src/console/span_exporter.rs` | Boundary |
| Dev-mode co-launch wiring | `pregolya-console/src/console/server.rs` | Effectful Shell |
| `SpanData` struct | `pregolya-console/src/console/span_exporter.rs` | Pure Core (data type) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `RingBuffer<T>` | Pure Core | Deterministic insert/evict/read; index arithmetic; no I/O; extractable for Kani/proptest |
| `DebugSpanExporter` (OTel impl) | Boundary | Pure part: RingBuffer ops. Effectful part: `SpanExporter::export()` async trait impl, OTel SDK global registration |
| Dev-mode co-launch code | Effectful Shell | Spawns in-process server, performs async I/O |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | Ring buffer at capacity; new span arrives | FIFO eviction; buffer length stays at `span_retention_cap` |
| EC-002 | Concurrent span export and ring-buffer read | Thread-safe via internal RwLock; no data race; read returns consistent snapshot |
| EC-003 | `dev_mode = false`; exporter not instantiated | `DebugSpanExporter` not created; no memory allocation; `Arc` not shared |
| EC-004 | OTel export callback fails | Error logged via `tracing::warn!`; engine execution continues |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~4,000 |
| BC-2.24.001.md (dev-mode clauses) | ~1,500 |
| BC-2.24.002.md (~155 lines) | ~2,500 |
| ADR-031 §Decision 5 (purity boundary) | ~800 |
| `ring_buffer.rs` (to create, ~150 code lines) | ~1,800 |
| `span_exporter.rs` (to create, ~100 code lines) | ~1,200 |
| Test module (~150 lines) | ~1,800 |
| OTel SDK trait reference | ~400 |
| Tool outputs | ~500 |
| **Total** | **~14,500** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~7%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs — `test_BC_2_24_002_*` family (test-writer)
2. [ ] Verify Red Gate — `cargo nextest run -p pregolya-console` shows new tests as failures
3. [ ] Create `pregolya-console/src/console/ring_buffer.rs` — `pub struct RingBuffer<T>` with fixed-capacity FIFO eviction; no I/O; Pure Core
4. [ ] Create `pregolya-console/src/console/span_exporter.rs` — `pub struct SpanData` (`#[non_exhaustive]`), `pub struct DebugSpanExporter` (`Arc<RwLock<RingBuffer<SpanData>>>`), `impl SpanExporter for DebugSpanExporter`
5. [ ] Add `opentelemetry` (workspace pin) dep to `pregolya-console/Cargo.toml` for `SpanExporter` trait
6. [ ] Modify `console::server` dev-mode path to instantiate `DebugSpanExporter`, wrap in `Arc`, inject into co-launched pregolya-server constructor
7. [ ] Add `SpanData` non-exhaustive compile-fail test in `tests/external/span-data-non-exhaustive/`
8. [ ] Run `cargo xtask check-file-size` — `ring_buffer.rs` < 500 code lines, `span_exporter.rs` < 500 code lines
9. [ ] Run `cargo clippy -p pregolya-console -D warnings` — zero warnings
10. [ ] Final `cargo nextest run -p pregolya-console` — all AC tests pass

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-01 (pregolya-console crate scaffolding). The `ConsoleConfig` type, Axum server structure, and `run_console` entry point are already established. `console::server.rs` contains the standalone server; this story adds the dev-mode branch with `DebugSpanExporter` instantiation. Follow the module layout (`console/mod.rs` is re-export only; logic in named submodules).

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| `RingBuffer<T>` is Pure Core (no I/O) | ADR-031 Decision 5, BC-2.24.002 INV-002 | Unit test without async runtime; proptest candidate |
| `SpanData` is `#[non_exhaustive]` | BC-2.24.002 INV-003, CLAUDE.md | Compile-fail test |
| `DebugSpanExporter` shared via `Arc` | BC-2.24.002 INV-005, CLAUDE.md Arc-DI convention | Code review; `Arc::clone` usage in dev-mode wiring |
| Export errors logged, not propagated | BC-2.24.002 INV-004 (DI-014) | Test: mock export failure; assert engine continues |
| No `println!` in `span_exporter.rs` | BC-2.24.001 INV-005, CLAUDE.md | `cargo clippy -D clippy::print_stdout` |
| No `unwrap()` / `expect()` in non-test | CLAUDE.md | `cargo xtask check-no-panic -p pregolya-console` |
| `ring_buffer.rs` is NOT async | ADR-031 Decision 5 Pure Core rule | Absence of `async fn`; no tokio dep in `ring_buffer.rs` |

**Forbidden dependencies for `console::ring_buffer`:** `tokio`, `axum`, `opentelemetry`, any I/O crate. Ring buffer is pure data structure.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| `opentelemetry` | workspace pin | `SpanExporter` async trait and `SpanData`-adjacent types |
| `opentelemetry-sdk` | workspace pin | OTel SDK exporter registration |
| `serde_json` | workspace pin | `SpanData.attributes` and `llm_request`/`llm_response` JSON values |
| `parking_lot` | workspace pin (or `std::sync::RwLock`) | Internal RingBuffer synchronization in `DebugSpanExporter` |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/src/console/ring_buffer.rs` | CREATE | `pub struct RingBuffer<T>` — Pure Core FIFO ring buffer |
| `crates/pregolya-console/src/console/span_exporter.rs` | CREATE | `SpanData`, `DebugSpanExporter`, `impl SpanExporter` |
| `crates/pregolya-console/src/console/mod.rs` | MODIFY | Add `pub mod ring_buffer; pub mod span_exporter;` re-exports |
| `crates/pregolya-console/src/console/server.rs` | MODIFY | Add dev-mode co-launch branch: instantiate `DebugSpanExporter`, inject via Arc |
| `crates/pregolya-console/Cargo.toml` | MODIFY | Add `opentelemetry`, `opentelemetry-sdk` deps |
| `tests/external/span-data-non-exhaustive/` | CREATE | Compile-fail test for `SpanData` non-exhaustive |
