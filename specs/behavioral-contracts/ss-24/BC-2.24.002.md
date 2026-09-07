---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.002
version: "1.0"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-042
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. DebugSpanExporter FIFO ring-buffer retention cap and trace-read debug endpoints."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-042
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

# BC-2.24.002: `DebugSpanExporter` Retention-Capped Ring Buffer and Trace-Read Debug Endpoints (CAP-042)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

## Description

`DebugSpanExporter` is an in-memory span exporter (hosted in `pregolya-console`,
`console::span_exporter` module) that implements the OTel `SpanExporter` async trait. It
stores completed spans in a bounded FIFO ring buffer. The `debug-endpoints` feature on
`pregolya-server` adds two read-only HTTP endpoints that read from this exporter:
`GET /debug/trace/session/{session_id}` (ordered span list for a session) and
`GET /debug/trace/{event_id}` (single-event spans). When no `DebugSpanExporter` is
configured, both endpoints return HTTP 503 with `E-SERVER-023 DebugExporterNotConfigured`.

## Preconditions

1. {PRE-001} `span_retention_cap: usize > 0` is set in `ConsoleConfig` (BC-2.24.001 {PRE-001}).
2. {PRE-002} `DebugSpanExporter` has been injected into pregolya-server as a configured OTel span exporter (only possible when the server is co-launched in `dev_mode = true`, BC-2.24.001 {PC-005}).
3. {PRE-003} The `debug-endpoints` Cargo feature is enabled on `pregolya-server` at build time. Default is `false` (OFF); must be explicitly enabled for these endpoints to exist.
4. {PRE-004} For trace-read: one or more spans have been exported by the running server (spans are produced by `tracing` events aligned with the Canonical Structured Event Catalog).

## Postconditions

1. {PC-001} **Ring buffer FIFO eviction:** The `DebugSpanExporter` stores up to `span_retention_cap` `SpanData` entries. When the buffer is full and a new span arrives, the oldest span is evicted (FIFO). No unbounded growth. The cap is configurable at `ConsoleConfig` construction time (default: 10,000 — matching adk-rust `trace_capacity`).
2. {PC-002} **`SpanData` shape:** Each stored span has the following shape (source: adk-rust `convert_to_span_data()` / `Trace.ts`):
   ```json
   {
     "span_id":       "<hex-string>",
     "trace_id":      "<hex-string>",
     "start_time_ms": <u64>,
     "end_time_ms":   <u64>,
     "attributes":    { "<key>": "<value>" },
     "llm_request":   <json_or_null>,
     "llm_response":  <json_or_null>
   }
   ```
3. {PC-003} **`GET /debug/trace/session/{session_id}` response:** Returns HTTP 200 with a JSON array of `SpanData` ordered by `start_time_ms` ascending for the given `session_id`. Returns an empty array `[]` when no spans match (not 404).
4. {PC-004} **`GET /debug/trace/{event_id}` response:** Returns HTTP 200 with a JSON object containing the `SpanData` for the identified event. Returns HTTP 404 when no span matches `event_id`.
5. {PC-005} **No exporter configured:** When `DebugSpanExporter` is not injected (standalone pregolya-server without co-launch, or feature disabled), both endpoints return HTTP 503 with body `{"error": "E-SERVER-023", "message": "DebugExporterNotConfigured: debug span exporter is not configured; start server via pregolya console --dev"}`.
6. {PC-006} **Debug-endpoints default OFF:** The `debug-endpoints` feature defaults to `false` in `pregolya-server/Cargo.toml`. Production builds without this feature compile out all debug routing (zero overhead). CI gate `check-debug-endpoints-default` verifies this (ADR-031 Decision 6).
7. {PC-007} **`debug_api_key` gate:** When `SecurityConfig.debug_api_key` is configured (BC-2.12.005), `/debug/*` requests without a valid key receive HTTP 403 with `E-SERVER-004 DebugRouteUnauthorized`.

## Invariants

- {INV-001} **Bounded memory:** The ring buffer NEVER exceeds `span_retention_cap` entries. FIFO eviction is the only growth-control mechanism — no dynamic resizing, no memory limit override.
- {INV-002} **Pure-core ring buffer:** The `RingBuffer<SpanData>` data structure (deterministic read/write, index arithmetic) is extractable as Pure Core for Kani/proptest verification. The effectful OTel exporter registration is the Boundary layer (ADR-031 Decision 5).
- {INV-003} **`SpanData` is `#[non_exhaustive]`:** `SpanData` is a public API-surface type and MUST carry `#[non_exhaustive]` per workspace conventions.
- {INV-004} **DI-014:** Span-export errors (OTel export callback failure) are logged via `tracing::warn!` and do not propagate to the engine; engine execution continues uninterrupted.
- {INV-005} **Shared via `Arc`:** `DebugSpanExporter` is shared between the console server and the pregolya-server debug routes via `Arc<DebugSpanExporter>` — required for Arc-DI wiring per workspace convention.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Ring buffer at capacity; new span arrives | Oldest span evicted; new span inserted; buffer length stays at `span_retention_cap` |
| {EC-002} | `GET /debug/trace/session/{id}` with no matching spans | Returns `200 OK` with empty array `[]` |
| {EC-003} | `GET /debug/trace/{event_id}` with no matching event | Returns `404 Not Found` |
| {EC-004} | `debug-endpoints` feature disabled (production build) | Endpoints do not exist; any path under `/debug/trace/` returns `404`; no code compiled in |
| {EC-005} | `DebugSpanExporter` not injected (standalone server without dev_mode) | Both endpoints return `503` with `E-SERVER-023 DebugExporterNotConfigured` |
| {EC-006} | Concurrent span export and ring-buffer read | Thread-safe access via `Arc` + internal synchronization (RwLock or similar); no data race; read returns consistent snapshot |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Ring buffer cap=3; 4 spans exported in order A, B, C, D | Buffer contains [B, C, D]; A evicted | ring-buffer FIFO |
| TV-002 | `GET /debug/trace/session/sess-123` when buffer has 2 spans for sess-123 | `200 OK`, JSON array of 2 `SpanData` ordered by `start_time_ms` | happy-path trace read |
| TV-003 | `GET /debug/trace/evt-456` when event_id not in buffer | `404 Not Found` | EC-003 |
| TV-004 | Server started without `DebugSpanExporter`; `GET /debug/trace/session/x` | `503` with `{"error": "E-SERVER-023", "message": "DebugExporterNotConfigured: ..."}` | EC-005 |
| TV-005 | `debug-endpoints` feature disabled; request to `/debug/trace/session/x` | `404 Not Found` (route does not exist) | EC-004 |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.002-A | Ring buffer never exceeds `span_retention_cap` under any number of insertions | Proptest / Kani (Pure Core RingBuffer) — target: `ring_buffer_bounded_invariant` |
| VP-2.24.002-B | FIFO eviction: oldest span is always the one removed | Proptest: sequences of insertions; assert evicted == first-inserted |
| VP-2.24.002-C | `DebugExporterNotConfigured` returned when exporter absent | Integration test: server without exporter; assert 503 + E-SERVER-023 |

## Related BCs

- BC-2.24.001 — depends on: `ConsoleConfig.span_retention_cap` configures this exporter; dev_mode=true triggers instantiation
- BC-2.24.003 — sibling: BC-2.24.003 covers the graph-descriptor endpoint; this BC covers trace-read endpoints (same `debug-endpoints` feature gate)
- BC-2.24.004 — composes with: run inspection panel (BC-2.24.004) surfaces per-event span detail via these endpoints

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — Decision 2 (debug endpoints, SpanData shape, E-SERVER-023), Decision 5 (`console::span_exporter` Boundary module, `server::debug_routes` Effectful Shell), Decision 6 (debug-endpoints OFF by default, Arc sharing)
- `architecture/ARCH-INDEX.md` — SS-24 entry

## Story Anchor

S-console-02 (Wave 3 — DebugSpanExporter implementation + debug-endpoints feature)

## VP Anchors

- VP-2.24.002-A
- VP-2.24.002-B
- VP-2.24.002-C

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-042 |
| Capability Anchor Justification | CAP-042 ("Debug Infrastructure Endpoints (Feature-Gated)") per capabilities-p1-p2.md §CAP-042 — this BC specifies the `DebugSpanExporter` ring-buffer retention contract and the two trace-read endpoints (`GET /debug/trace/session/{id}` and `GET /debug/trace/{event_id}`) that constitute the trace/span debug infrastructure of CAP-042 |
| L2 Domain Invariants | DI-014 (Error Propagation — span-export errors logged, not propagated; debug endpoint errors returned as structured Err) |
| Architecture Authority | ADR-031 Decision 2 (debug endpoint paths, SpanData shape, E-SERVER-023, debug-endpoints feature gate, default OFF), Decision 5 (purity boundary: ring buffer Pure Core, OTel registration Boundary) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.002-A/B/C |
| Module | pregolya-console / console::span_exporter (Boundary) + pregolya-server / server::debug_routes [feature debug-endpoints] (Effectful Shell) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + proptest + integration |
