---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.002
version: "1.12"
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
  - "1.1 (D-356-fix/DC-02/2026-09-07, product-owner): F-PDC02-05 security finding — SpanData external-boundary sanitization added (PC-008 new postcondition, INV-006 new invariant): llm_request, llm_response, and attributes must pass SEC-BOUND-001 pipeline before crossing /debug/trace/* boundary, parity with ADR-029 §External-Boundary Error-Sanitization Parity. PC-007 strengthened: debug_route_key is REQUIRED when debug-endpoints feature is enabled, not merely when configured; server must refuse to start without it (E-SERVER-013 InvalidDebugRouteKey at startup). EC-007 and TV-006 added. VP-2.24.002-D added."
  - "1.2 (D-356-fix/DC-02/2026-09-07, product-owner): Architect adjudication — sanitization location tightened from 'before serving' to before ring-buffer insertion in console::span_exporter (S-console-02 AC-011). PC-008, INV-006, VP-2.24.002-D updated to canonical location wording. Delta note added."
  - "1.3 (D-356-fix/DC-04/2026-09-07, product-owner): F-PDC04-04: INV-002 tightened — explicit module attribution added: RingBuffer<T> lives in `console::ring_buffer` (Pure Core); DebugSpanExporter lives in `console::span_exporter` (Boundary) and holds Arc<Mutex<RingBuffer<SpanData>>>. Module field in Traceability updated to include `console::ring_buffer (Pure Core)` alongside `console::span_exporter (Boundary)`. Prior wording cited the purity split without naming the module boundary."
  - "1.4 (D-356-fix/DC-07/2026-09-07, product-owner): F-PDC07-01: debug_api_key→debug_route_key throughout PC-007, EC-007, changelogs, and DC-02 blockquote (canonical field: SecurityConfig.debug_route_key per BC-2.12.005 PRE-004/INV-001; ADR-021 §Decision 1). F-PDC07-02: PC-007 and EC-007 now explicitly cite E-SERVER-013 InvalidDebugRouteKey as the boot-refusal code (startup path; distinct from E-SERVER-004 runtime 403). F-PDC07-05: stale '(update in progress by architect)' annotations removed from PC-007 body and DC-02 blockquote (ADR-031 D6-2 landed)."
  - "1.5 (D-356-fix/DC-08/2026-09-07, product-owner): F-PDC08-02: §Story Anchor updated — S-console-03 appended as Wave 3 secondary anchor (debug-endpoints feature / server::debug_routes; builds VP-2.24.002-C). S-console-02 remains primary."
  - "1.6 (D-356-fix/DC-10/2026-09-07, product-owner): F-PDC10-02: §Module updated to canonical 4-entry ADR-031 Decision 7 split — server::debug_span (Boundary) added as pregolya-server module owning SpanData data type and DebugSpanSource read-trait (consumer-owns-interface). Body sweep: Description clarified that server reads via Arc<dyn DebugSpanSource> with zero server→console compile dependency; PRE-002 injection language updated to Arc<dyn DebugSpanSource>; PC-005 and TV-004 updated from DebugSpanExporter to DebugSpanSource abstraction; INV-003 SpanData attributed to server::debug_span; INV-005 corrected from Arc<DebugSpanExporter> to Arc<dyn DebugSpanSource> (ADR-031 Decision 7 dependency inversion); Architecture Anchors updated to cite Decision 7; Traceability Module and Architecture Authority rows updated."
  - "1.7 (D-356-fix/DC-11/2026-09-07, product-owner): F-PDC11-03: §Module server::debug_span clause had duplicate [VP-2.24.002-C target] annotation — VP-2.24.002-C targets server::debug_routes ONLY (VP-INDEX §VP Catalog). Removed [VP-2.24.002-C target] from server::debug_span clause; replaced with [no dedicated VP; exercised via VP-2.24.002-C/D] to document the indirect coverage. server::debug_routes [VP-2.24.002-C target] annotation unchanged."
  - "1.8 (D-356-fix/DC-14/2026-09-08, product-owner): F-PDC14-03: TV-006 Expected Output corrected — previous form 'Bearer [REDACTED]' (retaining Bearer prefix, bracketed-caps token) is non-canonical. Canonical form per S-1.26 AC-020 step 2(d) and BC-2.12.003 {INV-008} step 2: the entire 'Bearer <token>' span (Bearer\\s+[A-Za-z0-9._~+/=\\-]+) is replaced with '<redacted>' (lowercase, angle-bracketed). Corrected: 'Bearer sk-abc123' → '<redacted>'; served content reads '<redacted> is the key'."
  - "1.9 (D-356-fix/DC-23/2026-09-08, product-owner): F-PDC23-03: INV-002 Mutex→RwLock per architect ruling (purity-map v1.48 + ADR-031 v1.5): DebugSpanExporter owns Arc<RwLock<RingBuffer<SpanData>>> (write lock at insertion; read locks for concurrent readers); Module row updated. F-PDC23-02: PC-005 and TV-004 error body key corrected 'error' → 'code' to match canonical pregolya-server envelope {code, message} (BC-2.12.001 EC-010 / BC-2.12.003 EC-008). O-PDC23-A: PC-005 and TV-004 E-SERVER-023 message string sync — single-quotes added around 'pregolya console --dev' to match error-taxonomy §E-SERVER-023 registry (byte-identical for test_BC_2_24_002_exporter_not_configured_body_exact)."
  - "1.10 (D-356-fix/DC-27/L-288/2026-09-08, product-owner): F-L288-008 (OBS): DC-04 historical blockquote asserted Arc<Mutex<RingBuffer<SpanData>>> with no superseded annotation; DC-23 (v1.9) corrected INV-002 to Arc<RwLock<...>>. Added inline SUPERSEDED-BY-DC-23 annotation immediately after the Arc<Mutex<...>> occurrence. Historical record preserved intact."
  - "1.11 (D-356-fix/DC-30/F-PDC30-01/2026-09-08, product-owner): F-PDC30-01 (HIGH): {INV-007} added after {INV-006} — session_id=run_id invariant per ADR-031 §Decision 8 architect ruling. DebugSpanExporter sets session_id=run_id at insertion; all spans addressable via GET /debug/trace/session/{run_id} ({PC-003}); empty [] response means: feature disabled, ring-buffer FIFO eviction ({INV-001}), or run produced no OTel ops — NOT a session key mismatch. Invariant enforced at insertion; no default or override path may produce a mismatched session_id for a run-scoped export."
  - "1.12 (D-356-fix/DC-32/F-PDC32-02/2026-09-08, product-owner): F-PDC32-02 (HIGH): {PC-002} SpanData shape updated — session_id: String added as field 5 (8 fields total) per architect DC-32 Option A ruling. {PC-002} prose cite updated (DC-32). {INV-007} and {PC-003} wording unchanged — they already correctly state session_id=run_id; only {PC-002} was missing the field declaration. No other behavioral anchor required change."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-042
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "08861c1"
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

> **D-356 adversary fix DC-02 (2026-09-07, product-owner).** F-PDC02-05 security finding: (a) SpanData external-boundary sanitization obligation added — `llm_request`, `llm_response`, and `attributes` must pass the SEC-BOUND-001 pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) before crossing the `/debug/trace/*` HTTP boundary, achieving parity with the run-stream error path (BC-2.06.001 §Postconditions PC-002 / BC-2.12.007 §Invariants INV-004 / ADR-029 §External-Boundary Error-Sanitization Parity). (b) PC-007 strengthened: `debug_route_key` is REQUIRED whenever `debug-endpoints` feature is enabled — absence triggers E-SERVER-013 InvalidDebugRouteKey at startup, not a runtime bypass. Per ADR-031 Decision 6-2.

> **D-356 adversary fix DC-02 location adjudication (2026-09-07, product-owner).** Architect adjudication (S-console-02 AC-011): sanitization location tightened to **before ring-buffer insertion in `console::span_exporter`** — the in-memory buffer must never hold unsanitized fields; this subsumes "before serving." PC-008, INV-006, and VP-2.24.002-D updated to canonical location wording.

> **D-356 adversary fix DC-04 (2026-09-07, product-owner).** F-PDC04-04: INV-002 and §Module updated — explicit module attribution added for the Pure Core / Boundary split: `RingBuffer<T>` lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` lives in `console::span_exporter` (Boundary) and owns `Arc<Mutex<RingBuffer<SpanData>>>` *(SUPERSEDED by DC-23: `Arc<Mutex<…>>` corrected to `Arc<RwLock<…>>`; see DC-23 changelog / INV-002.)*. Prior wording cited the purity split correctly but did not name the module boundary by canonical module path.

> **D-356 adversary fix DC-08 (2026-09-07, product-owner).** F-PDC08-02: §Story Anchor updated — S-console-03 appended as Wave 3 secondary anchor (debug-endpoints feature / `server::debug_routes`; builds VP-2.24.002-C). S-console-02 remains primary.

> **D-356 adversary fix DC-07 (2026-09-07, product-owner).** F-PDC07-01: `debug_api_key` → `debug_route_key` throughout (PC-007, EC-007, changelog v1.1, DC-02 blockquote). Canonical field is `SecurityConfig.debug_route_key: Option<String>` (BC-2.12.005 PRE-004/PC-006/PC-007/INV-001; ADR-021 §Decision 1). F-PDC07-02: PC-007 and EC-007 now explicitly cite E-SERVER-013 InvalidDebugRouteKey for the startup boot-refusal path (distinct from E-SERVER-004 runtime 403). F-PDC07-05: stale `(update in progress by architect)` removed from PC-007 and DC-02 blockquote (ADR-031 D6-2 landed).

> **D-356 adversary fix DC-30 (2026-09-08, product-owner).** F-PDC30-01 (HIGH): {INV-007} added after {INV-006} — session_id=run_id invariant per ADR-031 §Decision 8 architect ruling. `DebugSpanExporter` sets `session_id = run_id` at insertion time; all spans for a run are addressable via `GET /debug/trace/session/{run_id}` ({PC-003}). Empty `[]` response means: debug-endpoints feature disabled or no exporter injected, ring-buffer FIFO eviction ({INV-001}), or run produced no traced OTel operations — NOT a session key mismatch. The invariant MUST be enforced at insertion; no default or override path may produce a span with a different `session_id` for a run-scoped export.

> **D-356 adversary fix DC-23 (2026-09-08, product-owner).** F-PDC23-03: INV-002 corrected to RwLock per architect ruling (purity-map v1.48 + ADR-031 v1.5) — `DebugSpanExporter` owns `Arc<RwLock<RingBuffer<SpanData>>>` (write lock at insertion; concurrent readers acquire read locks at query time). F-PDC23-02: PC-005 and TV-004 error body key `"error"` → `"code"` (canonical `{code, message}` envelope per BC-2.12.001 {EC-010} / BC-2.12.003 {EC-008}). O-PDC23-A: E-SERVER-023 message string sync — single-quotes added around `'pregolya console --dev'` to match error-taxonomy §E-SERVER-023 registry (byte-exact for `test_BC_2_24_002_exporter_not_configured_body_exact`).

> **D-356 adversary fix DC-27/L-288 (2026-09-08, product-owner).** F-L288-008 (OBS): DC-04 historical blockquote asserted `Arc<Mutex<RingBuffer<SpanData>>>` with no indication that DC-23 superseded it. Added inline *(SUPERSEDED by DC-23: `Arc<Mutex<…>>` corrected to `Arc<RwLock<…>>`; see DC-23 changelog / INV-002.)* annotation immediately after the `Arc<Mutex<...>>` occurrence. Historical record preserved intact — annotation only.

> **D-356 adversary fix DC-14 (2026-09-08, product-owner).** F-PDC14-03: TV-006 Expected Output corrected — the previous form `Bearer [REDACTED]` (retaining `Bearer` prefix, uppercase bracketed token) is non-canonical. Per S-1.26 AC-020 step 2(d) and BC-2.12.003 {INV-008} step 2, the `redact_credentials` function replaces the entire `Bearer <token>` span (`Bearer\s+[A-Za-z0-9._~+/=\-]+`) with `"<redacted>"` (lowercase, angle-bracketed, no retained prefix). Corrected TV-006 expected output: served `llm_request.messages[0].content` reads `"<redacted> is the key"`.

> **D-356 adversary fix DC-11 (2026-09-07, product-owner).** F-PDC11-03: §Module `server::debug_span` clause had an erroneous `[VP-2.24.002-C target]` annotation. VP-2.24.002-C targets `server::debug_routes` ONLY (VP-INDEX §VP Catalog: `VP-2.24.002-C | server::debug_routes | integration | pregolya-server`). Annotation corrected to `[no dedicated VP; exercised via VP-2.24.002-C/D]`; `server::debug_routes` retains `[VP-2.24.002-C target]` unchanged.

> **D-356 adversary fix DC-10 (2026-09-07, product-owner).** F-PDC10-02: §Module updated to canonical 4-entry ADR-031 Decision 7 split — `server::debug_span` (Boundary) added as the pregolya-server module owning `SpanData` and the `DebugSpanSource` read-trait (consumer-owns-interface: server owns the contract type; pregolya-console implements it). Body sweep: Description, PRE-002, PC-005, TV-004, INV-003, INV-005, Architecture Anchors, Traceability corrected to reflect that `server::debug_routes` holds `Arc<dyn DebugSpanSource>` (dyn-dispatch) with ZERO server→console compile dependency per ADR-031 Decision 7.

> **D-356 adversary fix DC-32 (2026-09-08, product-owner).** F-PDC32-02 (HIGH): {PC-002} `SpanData` shape updated — `session_id: String` added as field 5 (8 fields total) per architect DC-32 Option A ruling. The `session_id` field carries `run_id` for session-keyed ring-buffer filtering, consistent with {INV-007} (ADR-031 §Decision 8) and {PC-003}. {INV-007} and {PC-003} required no wording change — they already correctly state `session_id = run_id`; only {PC-002} was missing the field declaration in the `SpanData` shape block.

## Description

`DebugSpanExporter` (`pregolya-console` / `console::span_exporter`) is an in-memory span exporter that implements the OTel `SpanExporter` async trait and the `DebugSpanSource` read-trait (defined in `pregolya-server` / `server::debug_span` — consumer-owns-interface per ADR-031 Decision 7). It stores completed spans in a bounded FIFO ring buffer (`console::ring_buffer`, Pure Core). The `debug-endpoints` feature on `pregolya-server` adds two read-only HTTP endpoints that read spans via `Arc<dyn DebugSpanSource>` (dyn-dispatch, injected at co-launch — ZERO server→console compile dependency): `GET /debug/trace/session/{session_id}` (ordered span list for a session) and `GET /debug/trace/{event_id}` (single-event spans). `SpanData` is a public type defined in `server::debug_span`. When no `DebugSpanSource` implementation is injected, both endpoints return HTTP 503 with `E-SERVER-023 DebugExporterNotConfigured`.

## Preconditions

1. {PRE-001} `span_retention_cap: usize > 0` is set in `ConsoleConfig` (BC-2.24.001 {PRE-001}).
2. {PRE-002} An implementation of `DebugSpanSource` (specifically `DebugSpanExporter` from `console::span_exporter`) has been injected into `pregolya-server` as `Arc<dyn DebugSpanSource>` (dependency inversion per ADR-031 Decision 7; only possible when the server is co-launched in `dev_mode = true`, BC-2.24.001 {PC-005}).
3. {PRE-003} The `debug-endpoints` Cargo feature is enabled on `pregolya-server` at build time. Default is `false` (OFF); must be explicitly enabled for these endpoints to exist.
4. {PRE-004} For trace-read: one or more spans have been exported by the running server (spans are produced by `tracing` events aligned with the Canonical Structured Event Catalog).

## Postconditions

1. {PC-001} **Ring buffer FIFO eviction:** The `DebugSpanExporter` stores up to `span_retention_cap` `SpanData` entries. When the buffer is full and a new span arrives, the oldest span is evicted (FIFO). No unbounded growth. The cap is configurable at `ConsoleConfig` construction time (default: 10,000 — matching adk-rust `trace_capacity`).
2. {PC-002} **`SpanData` shape:** Each stored span has the following shape (source: adk-rust `convert_to_span_data()` / `Trace.ts`, extended with `session_id` for session-keyed ring-buffer filtering — DC-32):
   ```json
   {
     "span_id":       "<hex-string>",
     "trace_id":      "<hex-string>",
     "start_time_ms": <u64>,
     "end_time_ms":   <u64>,
     "session_id":    "<run_id>",
     "attributes":    { "<key>": "<value>" },
     "llm_request":   <json_or_null>,
     "llm_response":  <json_or_null>
   }
   ```
3. {PC-003} **`GET /debug/trace/session/{session_id}` response:** Returns HTTP 200 with a JSON array of `SpanData` ordered by `start_time_ms` ascending for the given `session_id`. Returns an empty array `[]` when no spans match (not 404).
4. {PC-004} **`GET /debug/trace/{event_id}` response:** Returns HTTP 200 with a JSON object containing the `SpanData` for the identified event. Returns HTTP 404 when no span matches `event_id`.
5. {PC-005} **No exporter configured:** When no `DebugSpanSource` implementation is injected (standalone pregolya-server without co-launch, or feature disabled), both endpoints return HTTP 503 with body `{"code": "E-SERVER-023", "message": "DebugExporterNotConfigured: debug span exporter is not configured; start server via 'pregolya console --dev'"}`.
6. {PC-006} **Debug-endpoints default OFF:** The `debug-endpoints` feature defaults to `false` in `pregolya-server/Cargo.toml`. Production builds without this feature compile out all debug routing (zero overhead). CI gate `check-debug-endpoints-default` verifies this (ADR-031 Decision 6).
7. {PC-007} **`debug_route_key` mandatory gate:** When the `debug-endpoints` Cargo feature is enabled, `SecurityConfig.debug_route_key` is REQUIRED — a missing or empty key triggers E-SERVER-013 InvalidDebugRouteKey at startup (the server MUST refuse to start before binding the HTTP listener; error-taxonomy §E-SERVER-013; BC-2.12.005 EC-005 startup-only). Per ADR-031 Decision 6-2. Two distinct failure modes: (a) empty/absent `debug_route_key` + feature on → E-SERVER-013 at startup (refuse to start before accepting any requests); (b) valid key configured + unauthenticated request → E-SERVER-004 DebugRouteUnauthorized HTTP 403 at runtime.
8. {PC-008} **SpanData sanitization before ring-buffer insertion:** In `console::span_exporter`, `SpanData.llm_request`, `SpanData.llm_response`, and `SpanData.attributes` MUST be passed through the SEC-BOUND-001 sanitization pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) **before the span is inserted into the ring buffer** — the same pipeline applied to `StreamEvent::Error.error_message` at the run-stream boundary (BC-2.06.001 §Postconditions PC-002 and BC-2.12.007 §Invariants INV-004, authority ADR-029 §External-Boundary Error-Sanitization Parity). Sanitization at insertion-time is the canonical location (S-console-02 AC-011); this subsumes and guarantees the "before serving" property. Unsanitized values MUST NOT enter the ring buffer; SEC-BOUND-001 is the only path to storage and therefore to the wire.

## Invariants

- {INV-001} **Bounded memory:** The ring buffer NEVER exceeds `span_retention_cap` entries. FIFO eviction is the only growth-control mechanism — no dynamic resizing, no memory limit override.
- {INV-002} **Pure-core ring buffer:** `RingBuffer<SpanData>` storage lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` in `console::span_exporter` (Boundary) is the sole writer via `Arc<RwLock<RingBuffer<SpanData>>>` (acquires write lock at insertion; multiple concurrent readers acquire read locks at query time); reads served by `server::debug_routes` via the same Arc handle (ADR-031 Decision 5).
- {INV-003} **`SpanData` is `#[non_exhaustive]`:** `SpanData` is a public API-surface type defined in `server::debug_span` (pregolya-server; consumer-owns-interface per ADR-031 Decision 7) and MUST carry `#[non_exhaustive]` per workspace conventions.
- {INV-004} **DI-014:** Span-export errors (OTel export callback failure) are logged via `tracing::warn!` and do not propagate to the engine; engine execution continues uninterrupted.
- {INV-005} **Shared via `Arc<dyn DebugSpanSource>`:** `server::debug_routes` holds `Arc<dyn DebugSpanSource>` (injected at launch) to read spans — dyn-dispatch dependency inversion (ADR-031 Decision 7): pregolya-server has ZERO compile dependency on pregolya-console. `DebugSpanExporter` (in `console::span_exporter`, pregolya-console) implements `DebugSpanSource` and is injected as `Arc<dyn DebugSpanSource>` when the console co-launches the server. This satisfies Arc-DI wiring per workspace convention while eliminating the server→console crate coupling.
- {INV-006} **SEC-BOUND-001 mandatory at ring-buffer insertion:** `llm_request`, `llm_response`, and `attributes` in `SpanData` may contain LLM prompts, credential fragments, or PII that originated in user input or tool results. The SEC-BOUND-001 pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) MUST be applied in `console::span_exporter` **before the span is written into the ring buffer** — not deferred to serving time. This is the production-grade choice: the in-memory buffer must never hold unsanitized sensitive fields; sanitization at the boundary of storage also satisfies "before serving" transitively. This enforces external-boundary sanitization parity with the run-stream error path (ADR-029 §External-Boundary Error-Sanitization Parity, BC-2.06.001 §Postconditions PC-002). The sanitization is non-optional; there is no flag or dev_mode exception that bypasses SEC-BOUND-001 at insertion time.
- {INV-007} **Session key = run_id:** The `DebugSpanExporter` sets `session_id = run_id` on every exported span at insertion time. All spans for a given run are addressable via `GET /debug/trace/session/{run_id}` (BC-2.24.002 {PC-003}). An empty `[]` response means only: (a) the `debug-endpoints` feature is disabled or no exporter was injected, (b) the run's spans have been evicted from the ring buffer by newer spans (FIFO eviction per {INV-001}), or (c) the run produced no traced OTel operations — NOT a silent run/session key mismatch. The `session_id = run_id` invariant MUST be enforced at insertion; no default or override path may produce a span with a different `session_id` for a run-scoped export.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Ring buffer at capacity; new span arrives | Oldest span evicted; new span inserted; buffer length stays at `span_retention_cap` |
| {EC-002} | `GET /debug/trace/session/{id}` with no matching spans | Returns `200 OK` with empty array `[]` |
| {EC-003} | `GET /debug/trace/{event_id}` with no matching event | Returns `404 Not Found` |
| {EC-004} | `debug-endpoints` feature disabled (production build) | Endpoints do not exist; any path under `/debug/trace/` returns `404`; no code compiled in |
| {EC-005} | No `DebugSpanSource` implementation injected (standalone server without dev_mode) | Both endpoints return `503` with `E-SERVER-023 DebugExporterNotConfigured` |
| {EC-006} | Concurrent span export and ring-buffer read | Thread-safe access via `Arc` + internal synchronization (RwLock or similar); no data race; read returns consistent snapshot |
| {EC-007} | `debug-endpoints` feature enabled; server starts with no `debug_route_key` in `SecurityConfig` (absent or empty string) | Server refuses to start; E-SERVER-013 InvalidDebugRouteKey logged at startup before HTTP listener binds; no requests accepted (BC-2.12.005 EC-005; error-taxonomy §E-SERVER-013) |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | Ring buffer cap=3; 4 spans exported in order A, B, C, D | Buffer contains [B, C, D]; A evicted | ring-buffer FIFO |
| TV-002 | `GET /debug/trace/session/sess-123` when buffer has 2 spans for sess-123 | `200 OK`, JSON array of 2 `SpanData` ordered by `start_time_ms` | happy-path trace read |
| TV-003 | `GET /debug/trace/evt-456` when event_id not in buffer | `404 Not Found` | EC-003 |
| TV-004 | Server started without a `DebugSpanSource` implementation (no co-launch); `GET /debug/trace/session/x` | `503` with `{"code": "E-SERVER-023", "message": "DebugExporterNotConfigured: debug span exporter is not configured; start server via 'pregolya console --dev'"}` | EC-005 |
| TV-005 | `debug-endpoints` feature disabled; request to `/debug/trace/session/x` | `404 Not Found` (route does not exist) | EC-004 |
| TV-006 | `SpanData.llm_request` contains `{"messages": [{"role": "user", "content": "Bearer sk-abc123 is the key"}]}` | Served `llm_request` field has credential span replaced per `redact_credentials` canonical form (S-1.26 AC-020 step 2(d); BC-2.12.003 {INV-008} step 2): entire `Bearer sk-abc123` span → `<redacted>`; stored/served field reads `"<redacted> is the key"`; original credential not transmitted in HTTP response | PC-008, SEC-BOUND-001 |

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

- `architecture/decisions/ADR-031-developer-console-architecture.md` — Decision 2 (debug endpoints, SpanData shape, E-SERVER-023), Decision 5 (`console::span_exporter` Boundary module, `server::debug_routes` Effectful Shell), Decision 6 (debug-endpoints OFF by default, Arc sharing), Decision 7 (consumer-owns-interface: `SpanData` + `DebugSpanSource` trait owned by `server::debug_span`; `server::debug_routes` uses `Arc<dyn DebugSpanSource>`; ZERO server→console compile dependency)
- `architecture/ARCH-INDEX.md` — SS-24 entry

## Story Anchor

S-console-02 (primary — Wave 3, DebugSpanExporter implementation + debug-endpoints feature)

S-console-03 (Wave 3 — debug-endpoints feature / server::debug_routes; builds VP-2.24.002-C)

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
| Architecture Authority | ADR-031 Decision 2 (debug endpoint paths, SpanData shape, E-SERVER-023, debug-endpoints feature gate, default OFF), Decision 5 (purity boundary: ring buffer Pure Core, OTel registration Boundary), Decision 7 (consumer-owns-interface: SpanData + DebugSpanSource trait in server::debug_span; server holds Arc<dyn DebugSpanSource>; zero server→console compile dependency) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.002-A/B/C/D |
| Module | pregolya-server / server::debug_span (Boundary): SpanData data type + DebugSpanSource read-trait [consumer-owns-interface; no dedicated VP; exercised via VP-2.24.002-C/D] + pregolya-console / console::ring_buffer (Pure Core): RingBuffer<T> [VP-2.24.002-A/B targets] + pregolya-console / console::span_exporter (Boundary): DebugSpanExporter implements DebugSpanSource; SEC-BOUND-001 at insertion; owns Arc<RwLock<RingBuffer<SpanData>>> [VP-2.24.002-D target] + pregolya-server / server::debug_routes [feature debug-endpoints] (Effectful Shell): holds Arc<dyn DebugSpanSource>; dyn-dispatch per ADR-031 Decision 7 [VP-2.24.002-C target] |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + proptest + integration |
