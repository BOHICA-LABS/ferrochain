---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.002
version: "1.3"
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
  - "1.3 (D-356-fix/DC-04/2026-09-07, product-owner): F-PDC04-04: INV-002 tightened — explicit module attribution added: RingBuffer<T> lives in `console::ring_buffer` (Pure Core); DebugSpanExporter lives in `console::span_exporter` (Boundary) and holds Arc<Mutex<RingBuffer<SpanData>>>. Module field in Traceability updated to include `console::ring_buffer (Pure Core)` alongside `console::span_exporter (Boundary)`. Prior wording cited the purity split without naming the module boundary."
  - "1.2 (D-356-fix/DC-02/2026-09-07, product-owner): Architect adjudication — sanitization location tightened from 'before serving' to before ring-buffer insertion in console::span_exporter (S-console-02 AC-011). PC-008, INV-006, VP-2.24.002-D updated to canonical location wording. Delta note added."
  - "1.1 (D-356-fix/DC-02/2026-09-07, product-owner): F-PDC02-05 security finding — SpanData external-boundary sanitization added (PC-008 new postcondition, INV-006 new invariant): llm_request, llm_response, and attributes must pass SEC-BOUND-001 pipeline before crossing /debug/trace/* boundary, parity with ADR-029 §External-Boundary Error-Sanitization Parity. PC-007 strengthened: debug_api_key is REQUIRED when debug-endpoints feature is enabled, not merely when configured; server must refuse to start without it. EC-007 and TV-006 added. VP-2.24.002-D added."
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. DebugSpanExporter FIFO ring-buffer retention cap and trace-read debug endpoints."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-042
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "805b7eb"
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

> **D-356 adversary fix DC-02 (2026-09-07, product-owner).** F-PDC02-05 security finding: (a) SpanData external-boundary sanitization obligation added — `llm_request`, `llm_response`, and `attributes` must pass the SEC-BOUND-001 pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) before crossing the `/debug/trace/*` HTTP boundary, achieving parity with the run-stream error path (BC-2.06.001 §Postconditions PC-002 / BC-2.12.007 §Invariants INV-004 / ADR-029 §External-Boundary Error-Sanitization Parity). (b) PC-007 strengthened: `debug_api_key` is REQUIRED whenever `debug-endpoints` feature is enabled — absence is a server startup error, not a runtime bypass. Consistent with ADR-031 Decision 6 update in progress by architect.

> **D-356 adversary fix DC-02 location adjudication (2026-09-07, product-owner).** Architect adjudication (S-console-02 AC-011): sanitization location tightened to **before ring-buffer insertion in `console::span_exporter`** — the in-memory buffer must never hold unsanitized fields; this subsumes "before serving." PC-008, INV-006, and VP-2.24.002-D updated to canonical location wording.

> **D-356 adversary fix DC-04 (2026-09-07, product-owner).** F-PDC04-04: INV-002 and §Module updated — explicit module attribution added for the Pure Core / Boundary split: `RingBuffer<T>` lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` lives in `console::span_exporter` (Boundary) and owns `Arc<Mutex<RingBuffer<SpanData>>>`. Prior wording cited the purity split correctly but did not name the module boundary by canonical module path.

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
7. {PC-007} **`debug_api_key` mandatory gate:** When the `debug-endpoints` Cargo feature is enabled, `SecurityConfig.debug_api_key` is REQUIRED — a missing or empty key is a server startup error (the server MUST refuse to start with a structured boot error; not a runtime 403). This is mandatory-auth-when-debug-on per ADR-031 Decision 6 (update in progress by architect). All `/debug/*` requests that arrive without a valid `debug_api_key` receive HTTP 403 with `E-SERVER-004 DebugRouteUnauthorized`. The prior "when configured" wording is superseded: the key is not optional when debug-endpoints is on.
8. {PC-008} **SpanData sanitization before ring-buffer insertion:** In `console::span_exporter`, `SpanData.llm_request`, `SpanData.llm_response`, and `SpanData.attributes` MUST be passed through the SEC-BOUND-001 sanitization pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) **before the span is inserted into the ring buffer** — the same pipeline applied to `StreamEvent::Error.error_message` at the run-stream boundary (BC-2.06.001 §Postconditions PC-002 and BC-2.12.007 §Invariants INV-004, authority ADR-029 §External-Boundary Error-Sanitization Parity). Sanitization at insertion-time is the canonical location (S-console-02 AC-011); this subsumes and guarantees the "before serving" property. Unsanitized values MUST NOT enter the ring buffer; SEC-BOUND-001 is the only path to storage and therefore to the wire.

## Invariants

- {INV-001} **Bounded memory:** The ring buffer NEVER exceeds `span_retention_cap` entries. FIFO eviction is the only growth-control mechanism — no dynamic resizing, no memory limit override.
- {INV-002} **Pure-core ring buffer:** `RingBuffer<T>` — pure data structure in `console::ring_buffer` (Pure Core); deterministic read/write, index arithmetic, extractable for Kani/proptest verification. `DebugSpanExporter` in `console::span_exporter` (Boundary) owns an `Arc<Mutex<RingBuffer<SpanData>>>` and applies SEC-BOUND-001 sanitization at insertion. The effectful OTel exporter registration lives in the Boundary layer (ADR-031 Decision 5).
- {INV-003} **`SpanData` is `#[non_exhaustive]`:** `SpanData` is a public API-surface type and MUST carry `#[non_exhaustive]` per workspace conventions.
- {INV-004} **DI-014:** Span-export errors (OTel export callback failure) are logged via `tracing::warn!` and do not propagate to the engine; engine execution continues uninterrupted.
- {INV-005} **Shared via `Arc`:** `DebugSpanExporter` is shared between the console server and the pregolya-server debug routes via `Arc<DebugSpanExporter>` — required for Arc-DI wiring per workspace convention.
- {INV-006} **SEC-BOUND-001 mandatory at ring-buffer insertion:** `llm_request`, `llm_response`, and `attributes` in `SpanData` may contain LLM prompts, credential fragments, or PII that originated in user input or tool results. The SEC-BOUND-001 pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) MUST be applied in `console::span_exporter` **before the span is written into the ring buffer** — not deferred to serving time. This is the production-grade choice: the in-memory buffer must never hold unsanitized sensitive fields; sanitization at the boundary of storage also satisfies "before serving" transitively. This enforces external-boundary sanitization parity with the run-stream error path (ADR-029 §External-Boundary Error-Sanitization Parity, BC-2.06.001 §Postconditions PC-002). The sanitization is non-optional; there is no flag or dev_mode exception that bypasses SEC-BOUND-001 at insertion time.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Ring buffer at capacity; new span arrives | Oldest span evicted; new span inserted; buffer length stays at `span_retention_cap` |
| {EC-002} | `GET /debug/trace/session/{id}` with no matching spans | Returns `200 OK` with empty array `[]` |
| {EC-003} | `GET /debug/trace/{event_id}` with no matching event | Returns `404 Not Found` |
| {EC-004} | `debug-endpoints` feature disabled (production build) | Endpoints do not exist; any path under `/debug/trace/` returns `404`; no code compiled in |
| {EC-005} | `DebugSpanExporter` not injected (standalone server without dev_mode) | Both endpoints return `503` with `E-SERVER-023 DebugExporterNotConfigured` |
| {EC-006} | Concurrent span export and ring-buffer read | Thread-safe access via `Arc` + internal synchronization (RwLock or similar); no data race; read returns consistent snapshot |
| {EC-007} | `debug-endpoints` feature enabled; server starts with no `debug_api_key` in `SecurityConfig` | Server refuses to start; structured boot error logged (key absence is a startup error, not a runtime 403); no requests accepted |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Ring buffer cap=3; 4 spans exported in order A, B, C, D | Buffer contains [B, C, D]; A evicted | ring-buffer FIFO |
| TV-002 | `GET /debug/trace/session/sess-123` when buffer has 2 spans for sess-123 | `200 OK`, JSON array of 2 `SpanData` ordered by `start_time_ms` | happy-path trace read |
| TV-003 | `GET /debug/trace/evt-456` when event_id not in buffer | `404 Not Found` | EC-003 |
| TV-004 | Server started without `DebugSpanExporter`; `GET /debug/trace/session/x` | `503` with `{"error": "E-SERVER-023", "message": "DebugExporterNotConfigured: ..."}` | EC-005 |
| TV-005 | `debug-endpoints` feature disabled; request to `/debug/trace/session/x` | `404 Not Found` (route does not exist) | EC-004 |
| TV-006 | `SpanData.llm_request` contains `{"messages": [{"role": "user", "content": "Bearer sk-abc123 is the key"}]}` | Served `llm_request` field has credential fragment replaced: `Bearer [REDACTED]`; original credential not transmitted in HTTP response | PC-008, SEC-BOUND-001 |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.002-A | Ring buffer never exceeds `span_retention_cap` under any number of insertions | Proptest / Kani (Pure Core RingBuffer) — target: `ring_buffer_bounded_invariant` |
| VP-2.24.002-B | FIFO eviction: oldest span is always the one removed | Proptest: sequences of insertions; assert evicted == first-inserted |
| VP-2.24.002-C | `DebugExporterNotConfigured` returned when exporter absent | Integration test: server without exporter; assert 503 + E-SERVER-023 |
| VP-2.24.002-D | SEC-BOUND-001 sanitization applied to SpanData fields at ring-buffer insertion (in `console::span_exporter`) | Unit test: raw SpanData with credential fragment in `llm_request` passed to exporter; assert the stored ring-buffer entry has credential replaced per redact_credentials — not after read, at insert; test name: `test_BC_2_24_002_span_data_sanitization_sec_bound_001` |

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
- VP-2.24.002-D

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-042 |
| Capability Anchor Justification | CAP-042 ("Debug Infrastructure Endpoints (Feature-Gated)") per capabilities-p1-p2.md §CAP-042 — this BC specifies the `DebugSpanExporter` ring-buffer retention contract and the two trace-read endpoints (`GET /debug/trace/session/{id}` and `GET /debug/trace/{event_id}`) that constitute the trace/span debug infrastructure of CAP-042 |
| L2 Domain Invariants | DI-014 (Error Propagation — span-export errors logged, not propagated; debug endpoint errors returned as structured Err) |
| Architecture Authority | ADR-031 Decision 2 (debug endpoint paths, SpanData shape, E-SERVER-023, debug-endpoints feature gate, default OFF), Decision 5 (purity boundary: ring buffer Pure Core, OTel registration Boundary) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.002-A/B/C/D |
| Module | pregolya-console / console::ring_buffer (Pure Core) + pregolya-console / console::span_exporter (Boundary) + pregolya-server / server::debug_routes [feature debug-endpoints] (Effectful Shell) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + proptest + integration |
