---
document_type: adr
level: L3
adr_id: "031"
slug: developer-console-architecture
title: "Developer Console Architecture: pregolya-console Crate, Debug Endpoints, SSE Transport Reconciliation (D-356)"
status: accepted
date: "2026-09-06"
producer: architect
timestamp: 2026-09-08T00:00:00Z
version: "1.8"
phase: 1b
traces_to: ARCH-INDEX.md
decisions: [D356]
supersedes: null
superseded_by: null
subsystems_affected: ["SS-24", "SS-12"]
inputs:
  - .factory/planning/devconsole-adk-research.md
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/api-surface.md
  - .factory/specs/architecture/decisions/ADR-006-streaming-event-taxonomy.md
  - .factory/specs/architecture/decisions/ADR-021-server-config-surface-runnable-config-configurable.md
  - .factory/specs/architecture/decisions/ADR-028-server-run-lifecycle-semantics.md
  - .factory/specs/architecture/ARCH-INDEX.md
input-hash: "98b6e48"
changelog:
  - "1.0 (D-356/2026-09-06, architect): Initial ADR — developer console scope expansion. Six decisions: (1) pregolya-console new binary crate (Wave 3, roadmap); (2) debug-endpoints feature-gated on pregolya-server; (3) SSE transport confirmed, WebSocket-vs-SSE discrepancy closed; (4) SPA framework deferred to Wave 3; (5) purity boundary: console::server Effectful Shell, console::span_exporter Boundary, server::debug_routes Effectful Shell; (6) NFR/security deltas: localhost-bind, no external auth in dev mode, debug-endpoints OFF by default."
  - "1.1 (D-356/DC-02/2026-09-07, architect): F-PDC02-05 — D6-2 security strengthened: debug_route_key is now MANDATORY (not opt-in) when debug-endpoints feature is enabled; unauthenticated /debug/* requests → 403 E-SERVER-004 DebugRouteUnauthorized. §Security interaction updated from 'opt-in debug-key gate' to mandatory gate with explicit error code and DNS-rebinding rationale. SpanData sanitization (SEC-BOUND-001 parity; llm_request/llm_response strips from SpanData) cross-referenced to BC-2.24.002. Companion api-surface.md §Security note updated. input-hash unchanged (inputs did not change)."
  - "1.2 (D-356/DC-04/2026-09-07, architect): F-PDC04-04 — Decision 5 split: `console::ring_buffer` added as canonical Pure Core module (RingBuffer<T> deterministic bounded FIFO; no I/O deps; Kani/proptest-provable; VP-2.24.002-A/B targets). `console::span_exporter` updated to Boundary (owns Arc<Mutex<RingBuffer<SpanData>>>, depends on console::ring_buffer; performs SEC-BOUND-001 sanitization AT insertion). This split is the canonical arbiter; prevents future flip-flop. VP-2.24.002-A/B repointed to console::ring_buffer in all four VP mirrors. input-hash unchanged (inputs did not change)."
  - "1.3 (D-356/DC-07/2026-09-07, architect): F-PDC07-01 — sweep debug_api_key → debug_route_key (5 sites: changelog 1.1, §Decision 2 Security interaction, D6-2, DC-02 blockquote, §Source). F-PDC07-02 — D6-2 and §Decision 2 Security interaction updated to state both auth behaviors explicitly: (a) empty/absent debug_route_key → E-SERVER-013 InvalidDebugRouteKey startup-refusal before HTTP listener binds; (b) valid key + unauthenticated request → E-SERVER-004 403 at runtime. input-hash unchanged (inputs did not change)."
  - "1.4 (D-356/DC-10/2026-09-07, architect): F-PDC10-02 — dependency-cycle break via inversion. Added server::debug_span (Boundary) to pregolya-server: SpanData data type + DebugSpanSource read-trait. server::debug_routes now reads via Arc<dyn DebugSpanSource> (not Arc<DebugSpanExporter>). console::span_exporter implements DebugSpanSource and DEPENDS ON server::debug_span for SpanData+trait — console→server direction (already asserted; no cycle). Decision 5 table: added server::debug_span row, updated server::debug_routes + console::span_exporter rows. Decision 7 added. input-hash unchanged (inputs did not change; current dfd9a77)."
  - "1.5 (D-356/DC-23/2026-09-08, architect): F-PDC23-03 — Mutex→RwLock for span ring buffer (concurrent-reader adjudication). Decision 5 table `console::span_exporter` row updated: `Arc<Mutex<RingBuffer<SpanData>>>` → `Arc<RwLock<RingBuffer<SpanData>>>`. Rationale: S-console-03 AC-008 explicitly requires RwLock for multiple concurrent debug-route readers; BC-2.24.002 EC-006 specifies 'RwLock or similar'; Mutex serializes all reads and fails the concurrent-reader requirement. PO routing: BC-2.24.002 INV-002 must be updated (exact replacement wording in DC-23 delta note). input-hash updated to c9607b2 (input drift resolved — inputs changed prior to this burst)."
  - "1.6 (D-356/DC-29/2026-09-08, architect): F-PDC29-01 — Decision 8 added: completed-run inspection substrate. Resolves realizability gap in BC-2.24.004 {PRE-004}/{PC-006}/{TV-002}, BC-2.24.007 {PRE-002}, BC-2.24.008 {PC-004}: all three incorrectly assumed a stored StreamEvent list + run-event endpoint that do not exist. Decision: use run-read endpoint (BC-2.12.003 {PC-013}) + debug-trace endpoint (BC-2.24.002) for completed-run inspection. StreamEvent is transient (ADR-030 §Decision 2); no StreamEvent persistence substrate is introduced. PO routing: exact replacement wording for all three BCs in DC-29 delta note."
  - "1.7 (D-356/DC-30/2026-09-08, architect): F-PDC30-01 — session_id = run_id binding added to Decision 2; Decision 8 table clarified. F-PDC30-02 — swept 6 bare §Decision citations → §Decision 2 (changelog 1.6, Decision 8 authority chain, 4 PO-routing wording blocks). PO routing: BC-2.24.002 INV-007 exact wording in DC-30 delta note."
  - "1.8 (D-356/DC-32/F-PDC32-02/2026-09-08, architect): F-PDC32-02 — session_id realizability gap resolved. SpanData gains field 5: `session_id: String` (the run_id of the producing run; set by DebugSpanExporter at insertion per BC-2.24.002 {INV-007}). Decision 2 SpanData shape prose and Decision 7 Rust struct definition both updated to 8 fields (byte-consistent). PO routing: BC-2.24.002 {PC-002} SpanData shape and JSON example must add `session_id: '<run_id>'` as field 5 (between end_time_ms and attributes). Story-writer routing: S-console-02 AC-004 field list must add `session_id: String` as field 5."
---

# ADR-031: Developer Console Architecture

> **D-356 dev-console scope expansion (2026-09-06, architect).** Roadmap-only delta.
> `pregolya-console` and `debug-endpoints` are **not built in the current cycle** —
> spec and storyboard now; build in Wave 3.

**Status:** Accepted — D-356 human-authorized scope expansion

---

## Context

D-356 (2026-09-06) authorized an ADK-style local developer console for pregolya. The
business-analyst authored CAP-041 through CAP-047 (plus deferred CAP-048) in
`capabilities-p1-p2.md`. The research memo (`devconsole-adk-research.md`) established
five load-bearing findings:

1. The reference is `adk web` (Google ADK run-debug console), not ADK Studio (visual
   builder — out of scope, extracted to a separate repo not in the corpus).
2. Both reference implementations (`adk-rust`, LangGraph Studio) and the upstream
   `adk web` all stream over **REST + SSE**, never WebSocket. ADR-006 and api-surface.md
   already specify SSE. The task brief's "over WebSocket" premise was incorrect.
3. The pregolya server surface (SS-12) is already a superset of the adk-rust console
   backend for runs, threads, state, history, and HITL. The existing 16-variant
   `StreamEvent` grammar is richer than the reference (includes `GuardrailDecision` and
   `CompactionEvent` variants). HS-C-001 holdout already proves an external host can
   consume the stream.
4. Net-new backend additions are modest: `/debug/trace/*` span-read endpoints (plus an
   in-memory OTel span exporter) and a graph-descriptor endpoint. Everything else the
   console needs already exists in the public wire contract.
5. Three-component split is recommended: headless `pregolya-server` (transport authority,
   no change), `pregolya-console` (new binary crate: embeds SPA, dev-server launch, span
   exporter host), and web SPA (separate build artifact, own wave).

This ADR makes six binding decisions and formally closes the WebSocket-vs-SSE discrepancy.

---

## Decision

Six binding decisions are made in this ADR, grouped as numbered subsections.

### Decision 1 — `pregolya-console` Crate

Add `pregolya-console` as a **new binary crate** (crate #22 in the Canonical Crate Roster,
Wave 3, roadmap — not built in the current Phase 3 implementation cycle).

**Responsibilities:**
- Embeds the compiled web SPA via `rust_embed` (`#[folder = "assets/webui"]`). Serves
  the SPA at `/ui/` with fallback to `index.html` for SPA routing (pattern: adk-rust
  `web_ui.rs`).
- Injects `runtime-config.json` at `/ui/assets/config/runtime-config.json` with
  `{ "apiBaseUrl": "/api" }` so the SPA resolves the backend relative to the same host.
- Exposes a `pregolya console` CLI subcommand (added to the `pregolya` facade crate).
  Flags: `--host` (default `127.0.0.1`), `--port` (default `7437`), `--dev`
  (co-launch in-process server).
- In `--dev` mode: co-launches an in-process `pregolya-server` on the same address/port.
  The combined Axum router serves `/api/*` (server routes) and `/ui/*` (SPA assets)
  from a single listener on `127.0.0.1:7437`.
- Hosts the `DebugSpanExporter` — an in-memory span exporter (bounded ring buffer)
  injected into the co-launched pregolya-server as a configured OTel span exporter. The
  `/debug/trace/*` endpoints (Decision 2) read from this exporter.

**Dependency boundary:** `pregolya-console` MUST NOT import from `pregolya-graph`
internals, executor internals, or any crate-private module. It drives the engine
exclusively through the public pregolya-server REST+SSE contract — the same contract
used by the HS-C-001 embedding-host holdout. This is a structural crate-level invariant,
enforced by the `Cargo.toml` dependency graph.

**Public surface (limited):**
- `ConsoleConfig` struct (host, port, dev_mode, span_retention_cap)
- `run_console(config: ConsoleConfig) -> Result<(), PregolyaError>` async entry point

CAP anchor: CAP-041.

### Decision 2 — Debug Endpoints on `pregolya-server` (Feature-Gated)

Add three endpoints to `pregolya-server` compiled in ONLY when the `debug-endpoints`
Cargo feature is enabled. Default: **OFF**. Production deployments that do not enable
this feature compile out all debug routing with zero overhead.

**Endpoint paths (exact):**

| Method | Path | Description | CAP |
|--------|------|-------------|-----|
| GET | `/debug/trace/session/{session_id}` | Ordered `SpanData` list for a session | CAP-042 |
| GET | `/debug/trace/{event_id}` | `SpanData` for a single event | CAP-042 |
| GET | `/assistants/{id}/graph` | StateGraph JSON node/edge descriptor + optional `dot_src` | CAP-042 |

**Trace/span shape (`SpanData`):** `span_id`, `trace_id`, `start_time_ms`, `end_time_ms`,
`session_id` (String — the `run_id` of the run that produced this span; set by `DebugSpanExporter` at insertion per BC-2.24.002 {INV-007}; enables `get_session_spans` to perform a direct typed-field equality filter over the flat ring buffer — no attributes map lookup, no stringly-typed key), `attributes` (JSON object), `llm_request` (nullable JSON), `llm_response` (nullable JSON).
Matches the shape produced by adk-rust `convert_to_span_data()` for the `adk-web`
frontend `Trace.ts` SpanData type (research memo §2.2 table row 5), extended with `session_id` as field 5 (DC-32). Spans sourced from
`DebugSpanExporter`; when no exporter is configured, endpoints return
`503 Service Unavailable` with `E-SERVER-023 DebugExporterNotConfigured`.

**Graph descriptor shape:**
```json
{
  "nodes": [{ "name": "<node_name>", "kind": "node|start|end|branch" }],
  "edges": [{ "source": "<node_name>", "target": "<node_name>", "condition": "<label_or_null>" }],
  "dot_src": "<graphviz_dot_source_or_null>"
}
```
`dot_src` is populated when the `dot` binary is in PATH (optional); `null` when absent.
The descriptor is a static structural snapshot of the compiled graph — it carries no
runtime state. Returns `404` with existing `E-SERVER-009 AssistantNotFound` when the assistant
does not exist.

**Session-key binding (`session_id = run_id`):** For console dev runs, `DebugSpanExporter` MUST tag every exported span with `session_id = run_id` at insertion time. This binding makes the trace-session endpoint unambiguous: `GET /debug/trace/session/{run_id}` returns all spans for the named run — no join, no filter, no secondary lookup. The endpoint path parameter is named `{session_id}` in the URL template above; the VALUE passed is always a `run_id` when fetching a run's spans. An empty `[]` response means only: (a) the feature was disabled or the exporter not injected, (b) the ring buffer evicted the run's spans due to volume, or (c) the run produced zero OTel spans — NOT a silent run/session key mismatch. This eliminates the "no silent empty" risk identified in DC-30 (F-PDC30-01). See also BC-2.24.002 {INV-007} (PO routing below).

**Security interaction:** When `debug-endpoints` is enabled:
(a) if `SecurityConfig.debug_route_key` (BC-2.12.005) is empty or absent, the server
**refuses to start** — `E-SERVER-013 InvalidDebugRouteKey` is raised during config
validation, before the HTTP listener binds (startup-refusal, not a runtime error);
(b) with a valid key configured, unauthenticated requests to `/debug/*` return `403`
with `E-SERVER-004 DebugRouteUnauthorized` at runtime. CORS policy follows
`SecurityConfig`. `SpanData` exposes `llm_request`/`llm_response` payloads; loopback bind
alone is insufficient against DNS-rebinding/CSRF-to-127.0.0.1 (SEC-BOUND-001 parity;
sanitization specified in BC-2.24.002).

**Pure-core extraction required:** The `CompiledStateGraph → GraphDescriptor`
serialization is a pure, deterministic transformation. It MUST be extracted as a free
function `fn compile_graph_descriptor(graph: &CompiledStateGraph) -> GraphDescriptor`
in module `graph::descriptor` (pregolya-graph, Pure Core) before Phase 6. This is
required by Purity Enforcement Rule 3; a VP may be authored for graph descriptor
structural invariants (e.g., no self-loops, connected start node).

**Error codes:**
- `E-SERVER-023 DebugExporterNotConfigured` (SERVER, VAL — minted in error-taxonomy.md v1.72 per product-owner; no further action)
- `E-SERVER-009 AssistantNotFound` (existing code — already covers this case; no new mint needed per product-owner reconciliation 2026-09-06)

> **D-356 error-code reconciliation (2026-09-06, architect).** Original Decision 2 specified E-SERVER-020 for DebugExporterNotConfigured and E-SERVER-021 for AssistantNotFound. Product-owner reconciled against error-taxonomy.md: E-SERVER-020 was already assigned; correct code is E-SERVER-023 (minted in error-taxonomy.md v1.72). E-SERVER-021 is unnecessary — existing E-SERVER-009 AssistantNotFound covers this case. BCs BC-2.24.002 (cites E-SERVER-023) and BC-2.24.003 (cites E-SERVER-009) are already consistent. Source-of-truth precedence: error-taxonomy.md (PRD supplement) supersedes ADR prose per CLAUDE.md §Source-of-Truth Precedence rule 3.

CAP anchor: CAP-042.

### Decision 3 — Transport: SSE Confirmed, WebSocket Closed

**SSE is the sole streaming transport for the developer console.** No WebSocket endpoint
will be added to `pregolya-server` or `pregolya-console` in this scope or as a follow-on
from D-356.

ADR-006 is authoritative: the `StreamEvent` grammar is framed over SSE
(`data: <json>\n\n` framing on `GET /threads/{id}/runs/{run_id}/stream`). The research
memo §4.0 confirmed this is consistent with both reference implementations. The `ag_ui`
protocol-native transport in adk-rust changes the SSE event *envelope*, not the transport
(still SSE).

**BC audit required (product-owner action):** Audit all BC files for the string
"WebSocket" (`grep -ri "websocket" .factory/specs/behavioral-contracts/`). Any
occurrence describing the run-streaming transport must be corrected to "SSE." This is a
product-owner action; the architect does NOT edit BCs.

### Decision 4 — Web SPA Framework: Explicitly Deferred to Wave 3

The SPA framework choice (SolidJS, Svelte, React, or other) is **deferred** to the Wave
3 story decomposition phase. The framework choice has zero impact on `pregolya-server` or
`pregolya-console` crate design; all three frameworks produce a static bundle compatible
with `rust_embed`.

**Non-negotiable constraints that apply regardless of framework (Wave 3 binding):**
1. Must support native browser `EventSource` for SSE without a WebSocket polyfill.
2. Must produce a static embeddable bundle (`HTML + JS + CSS`) for `rust_embed`
   `#[folder = "assets/webui"]`.
3. Bundle size target: < 500 KB gzip (to be confirmed in Wave 3 NFR definition).
4. No SSR — pure client-side SPA.
5. Pure REST+SSE client of the existing wire contract; no new server-side component.

### Decision 5 — Purity Boundary

New modules introduced by this ADR. All are **[PLANNED]** (Wave 3). Module-decomposition.md
and verification-coverage-matrix.md will be updated at Wave 3 planning.

| Module | Crate | Classification | Rationale |
|--------|-------|----------------|-----------|
| `console::server` | pregolya-console | **Effectful Shell** | Axum HTTP server: binds network port, serves assets over I/O, manages in-process server lifecycle, async tokio runtime |
| `console::ring_buffer` | pregolya-console | **Pure Core** | `RingBuffer<T>` deterministic bounded FIFO data structure: capacity-enforcement arithmetic, index-wrap computation, head-pointer advance on enqueue overflow — no I/O, no `tokio`, no `opentelemetry` deps; Kani/proptest-provable; VP-2.24.002-A (`ring_buffer_bounded_invariant`) and VP-2.24.002-B (`ring_buffer_fifo_invariant`) targets; canonical pure vehicle for `RingBuffer<SpanData>` storage |
| `console::span_exporter` | pregolya-console | **Boundary** | Effectful OTel exporter: `DebugSpanExporter` owns `Arc<RwLock<RingBuffer<SpanData>>>` — **depends on `console::ring_buffer` (Pure Core)**; **depends on `server::debug_span` (pregolya-server)** for `SpanData` type + `DebugSpanSource` trait (console→server dep direction; no cycle); implements `DebugSpanSource` (server-owned trait — consumer-owns-interface pattern, Decision 7); performs SEC-BOUND-001 sanitization AT insertion; Arc-DI injected at pregolya-server launch |
| `server::debug_routes` [feature `debug-endpoints`] | pregolya-server | **Effectful Shell** | HTTP handlers: reads spans via `Arc<dyn DebugSpanSource>` (injected at launch by the console layer — dependency inversion per Decision 7; server does NOT depend on pregolya-console); queries AssistantStore (async I/O); feature-gated, excluded from production builds by default |
| `server::debug_span` [feature `debug-endpoints`] | pregolya-server | **Boundary** | `SpanData` data type (span_id, trace_id, start_time_ms, end_time_ms, attributes, llm_request, llm_response) + `DebugSpanSource` read-trait (`fn get_session_spans(&self, session_id: &str) -> Vec<SpanData>`, `fn get_span(&self, event_id: &str) -> Option<SpanData>`); server-owned interface — consumer-owns-interface (DIP); pregolya-server depends on NOTHING in pregolya-console; `DebugSpanExporter` (console) implements this trait and is injected at launch |
| `graph::descriptor` [Pure Core, extracted] | pregolya-graph | **Pure Core** | `fn compile_graph_descriptor(graph: &CompiledStateGraph) -> GraphDescriptor` — deterministic, no I/O, no global state; required extraction before Phase 6 (Purity Enforcement Rule 3) |

### Decision 6 — NFR and Security Deltas

These are **additive exceptions** to the workspace-wide NFR catalog for the console surface:

- **D6-1 TLS:** `pregolya-console` binds to `127.0.0.1` (loopback) by default. TLS NOT
  required for loopback-bound dev-tool operation (same posture as adk-web, LangGraph Dev
  Server). Operator's responsibility if exposed beyond localhost (unsupported in v1).
- **D6-2 Auth:** No auth layer on `/ui/` asset routes. Loopback bind is the security
  boundary for UI assets only. When the `debug-endpoints` Cargo feature is enabled:
  (a) if `debug_route_key` (BC-2.12.005) is empty or absent, the server **refuses to
  start** — `E-SERVER-013 InvalidDebugRouteKey` is raised during config validation,
  before the HTTP listener binds (startup-refusal, not a runtime error);
  (b) with a valid key configured, unauthenticated requests to `/debug/*` return `403`
  with `E-SERVER-004 DebugRouteUnauthorized` at runtime. Rationale: debug/trace endpoints
  expose `llm_request`/`llm_response` payloads in `SpanData`; loopback bind alone is
  insufficient against the DNS-rebinding/CSRF-to-127.0.0.1 attack vector.
  `SpanData` sanitization (SEC-BOUND-001 parity — strip `llm_request`/`llm_response`
  from exported spans) is specified in BC-2.24.002.
- **D6-3 debug-endpoints default OFF:** `debug-endpoints` feature MUST default to `false`
  in `pregolya-server/Cargo.toml`. CI gate `check-debug-endpoints-default` verifies this
  (authored at Wave 3 workspace setup).
- **D6-4 Retention cap:** `DebugSpanExporter` ring buffer cap MUST be configurable
  (`span_retention_cap: usize` in `ConsoleConfig`). Default: 10,000 spans (matching
  adk-rust `trace_capacity`). FIFO eviction on overflow; unbounded growth prohibited.
- **D6-5 reqwest:** `pregolya-console` is a server, not an HTTP client. The 30s timeout
  and `rustls-tls` NFRs apply to any future reqwest usage in the console crate; the Axum
  server listener is exempt from the outbound-client timeout rule.
- **D6-6 No println! in console library modules:** `console::server` and
  `console::span_exporter` use `tracing::*!` per workspace convention. The `main.rs`
  CLI entrypoint may use `println!` for UX output (port announcement).

### Decision 7 — DebugSpanSource Dependency Inversion (DC-10)

**`SpanData` and `DebugSpanSource` are owned by `pregolya-server`** (module `server::debug_span`),
not by `pregolya-console`. This breaks the `console→server→console` compile-dependency cycle
(Cargo rejects cycles; a dev-dep cannot satisfy non-test library code).

**Dependency graph after this decision:**
- `pregolya-server` → (nothing in `pregolya-console`) — server does NOT depend on console
- `pregolya-console` → `pregolya-server` (for `SpanData` type + `DebugSpanSource` trait)
- This is the already-asserted `console→server` direction in dependency-graph.md

**Consumer-owns-interface principle (DIP):** The consumer (`server::debug_routes`) owns the
`DebugSpanSource` trait in its crate (`server::debug_span`). The provider (`console::span_exporter`)
implements the trait. The trait is injected at launch via `Arc<dyn DebugSpanSource>`.

**`server::debug_span` module contracts:**
- `SpanData { span_id: String, trace_id: String, start_time_ms: u64, end_time_ms: u64,
  session_id: String, attributes: serde_json::Value, llm_request: Option<serde_json::Value>,
  llm_response: Option<serde_json::Value> }` — plain data struct, `Clone + Serialize`
- `DebugSpanSource` trait: `fn get_session_spans(&self, session_id: &str) -> Vec<SpanData>` and
  `fn get_span(&self, event_id: &str) -> Option<SpanData>`

**SEC-BOUND-001 still applies:** `console::span_exporter` sanitizes `SpanData` fields
(`llm_request`/`llm_response`/`attributes`) AT insertion into `RingBuffer<SpanData>` before
the data reaches `DebugSpanSource` reads. The sanitization obligation is unchanged — the type
merely moved crates.

**VP module anchors are UNCHANGED:**
- VP-2.24.002-A/B (`ring_buffer_bounded_invariant` / `ring_buffer_fifo_invariant`) → `console::ring_buffer` (pure RingBuffer<T>; unaffected)
- VP-2.24.002-C (server integration) → `server::debug_routes` (unaffected)
- VP-2.24.002-D (sanitization) → `console::span_exporter` (sanitization is still exporter's job; unaffected)

> **D-356 adversary fix DC-02 (2026-09-07, architect).** F-PDC02-05: D6-2 security posture strengthened per adversary finding. `debug_route_key` is now MANDATORY (not opt-in) when the `debug-endpoints` Cargo feature is enabled; unauthenticated requests to `/debug/*` return `403` with `E-SERVER-004 DebugRouteUnauthorized`. Rationale: `SpanData` exposes `llm_request`/`llm_response` payloads; loopback bind alone is insufficient against the DNS-rebinding/CSRF-to-127.0.0.1 vector. `SpanData` sanitization (SEC-BOUND-001 parity — strip LLM payload fields before export) is cross-referenced to BC-2.24.002. Companion: api-surface.md §Security note updated to reflect mandatory auth.

> **D-356 adversary fix DC-07 (2026-09-07, architect).** F-PDC07-01: swept `debug_api_key` → `debug_route_key` at all 5 ADR-031 sites (changelog 1.1, §Decision 2 Security interaction, D6-2, DC-02 blockquote, §Source). Canonical field is `debug_route_key: Option<String>` per BC-2.12.005 PRE-004/PC-006/PC-007/INV-001 and ADR-021 §Decision 1 — the non-canonical `debug_api_key` was introduced in DC-02. F-PDC07-02: D6-2 and §Decision 2 Security interaction now state both auth behaviors explicitly: (a) empty/absent `debug_route_key` → `E-SERVER-013 InvalidDebugRouteKey` startup-refusal before HTTP listener binds; (b) valid key + unauthenticated request → `E-SERVER-004 DebugRouteUnauthorized` 403 at runtime. Companion: api-surface.md updated in same burst (F-PDC07-01 rename + F-PDC07-02 both-behaviors). F-PDC07-03: 10 panel-VP Module cells repointed to `spa/components/<panel>` convention in all 4 VP mirrors (VP-INDEX, verification-architecture, verification-coverage-matrix, ARCH-INDEX); VP-INDEX preamble SPA convention note added; v1.44 false changelog claim corrected via new v1.48 entry.

> **D-356 adversary fix DC-10 (2026-09-07, architect).** F-PDC10-02: Cargo crate-dependency cycle broken via dependency inversion (DIP). Root cause: the prior specification placed `SpanData` and `DebugSpanExporter` in pregolya-console, but `server::debug_routes` (pregolya-server) needed to hold `Arc<DebugSpanExporter>` and serialize `SpanData` — requiring server to compile-depend on console, creating the `console→server→console` cycle. Resolution: (1) New module `server::debug_span` added to pregolya-server (Decision 7) — owns `SpanData` data type + `DebugSpanSource` read-trait (consumer-owns-interface). (2) `server::debug_routes` now reads via `Arc<dyn DebugSpanSource>` injected at launch — zero compile dep on pregolya-console. (3) `console::span_exporter` implements `DebugSpanSource` and depends on pregolya-server for the type + trait — `console→server` dep direction (already the asserted direction in dependency-graph.md). No cycle. VP-2.24.002-A/B/C/D module anchors UNCHANGED (console::ring_buffer / console::ring_buffer / server::debug_routes / console::span_exporter). Companion: purity-boundary-map.md v1.47 updated same burst; dependency-graph.md + BC-2.24.002 §Module + S-console-03 corrections routed to story-writer/PO.

> **D-356 adversary fix DC-04 (2026-09-07, architect).** F-PDC04-04: Decision 5 purity table split into two canonical modules. `console::ring_buffer` is now the **canonical Pure Core** module hosting `RingBuffer<T>` (deterministic bounded FIFO, no I/O deps, Kani/proptest-provable; VP-2.24.002-A/B targets). `console::span_exporter` remains **Boundary** but is now explicitly defined as the OTel exporter that **DEPENDS ON** `console::ring_buffer` — it owns `Arc<Mutex<RingBuffer<SpanData>>>` and performs SEC-BOUND-001 sanitization AT insertion before delegating to the ring buffer. This ADR text is the canonical arbiter for the module split; it prevents future reversion (DC-01 introduced `console::ring_buffer` non-canonically; DC-02 collapsed both into `console::span_exporter`; DC-04 resolves by canonicalizing the split with explicit dependency direction). VP-2.24.002-A/B repointed to `console::ring_buffer` in all four VP mirrors. VP-2.24.002-D (sanitization) stays at `console::span_exporter`. BC-2.24.002 §Module wording for PO: "`pregolya-console` — two modules: `console::ring_buffer` (Pure Core, `RingBuffer<T>` data structure) and `console::span_exporter` (Boundary, `DebugSpanExporter` OTel exporter owning `Arc<Mutex<RingBuffer<SpanData>>>`).". INV-002 wording for PO: "`RingBuffer<SpanData>` storage lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` in `console::span_exporter` (Boundary) is the sole writer via `Arc<Mutex<RingBuffer<SpanData>>>`; reads served by `server::debug_routes` via the same Arc handle."

> **D-356 adversary fix DC-23 (2026-09-08, architect).** F-PDC23-03: `Arc<Mutex<RingBuffer<SpanData>>>` corrected to `Arc<RwLock<RingBuffer<SpanData>>>` in Decision 5 table `console::span_exporter` row (live content only; DC-04 historical delta note above is not revised — it records what DC-04 decided at the time). Ruling: S-console-03 AC-008 explicitly states "The `RwLock` inside the concrete `DebugSpanExporter`... allows multiple concurrent readers." `Mutex` serializes ALL access and cannot satisfy this load-bearing requirement. `RwLock` permits concurrent read-guard holders (multiple simultaneous HTTP debug-route requests) plus exclusive write access during OTel span insertion. BC-2.24.002 EC-006 independently corroborates ("RwLock or similar"). The DC-04 `Mutex` pin was incorrect and is superseded by this ruling. **PO routing — BC-2.24.002 INV-002 replacement wording:** "`RingBuffer<SpanData>` storage lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` in `console::span_exporter` (Boundary) is the sole writer via `Arc<RwLock<RingBuffer<SpanData>>>` (acquires write lock at insertion; multiple concurrent readers acquire read locks at query time); reads served by `server::debug_routes` via the same Arc handle (ADR-031 Decision 5)." Companion: purity-boundary-map.md v1.48 updated same burst. Stories S-console-02 and S-console-03 already cite RwLock in AC-008/EC-005 — no story edits required for F-PDC23-03.

> **D-356 adversary fix DC-32 (2026-09-08, architect).** F-PDC32-02 (MED): `session_id` realizability gap. `{INV-007}` required `DebugSpanExporter` to tag every exported span with `session_id = run_id` at insertion time, and `DebugSpanSource::get_session_spans` (Decision 7) required filtering by `session_id`; however `SpanData` carried only 7 fields (`span_id`, `trace_id`, `start_time_ms`, `end_time_ms`, `attributes`, `llm_request`, `llm_response`) with no `session_id` field, and the ring buffer is a flat `RingBuffer<SpanData>` with no session-keyed index. Both the insertion invariant and the filter method were unrealizable as written. **Ruling: Option A — add typed `session_id: String` as field 5** (between `end_time_ms` and `attributes`). Option B (store as `attributes["session_id"]`) was considered and rejected: any code path that merges or overwrites the `attributes` JSON object can silently corrupt the session key, making the "no default or override path" obligation in `{INV-007}` structurally unenforceable on a mutable JSON map; a dedicated typed field eliminates the ambiguity and the fragility. The `session_id` field is set by `DebugSpanExporter` at insertion (same code site as SEC-BOUND-001 sanitization); it is a routing key (`run_id`), not user-originated sensitive data, and is NOT passed through the SEC-BOUND-001 pipeline. With field 5 present, `get_session_spans` becomes a direct typed-field equality filter (`span.session_id == session_id`) over the flat ring buffer — O(n) linear scan, no attributes map lookup, no key-collision risk. `#[non_exhaustive]` on `SpanData` (`{INV-003}`) makes this a non-breaking API extension. Decision 2 SpanData shape prose and Decision 7 Rust struct definition updated in this burst to be byte-consistent (both now list 8 fields: `span_id`, `trace_id`, `start_time_ms`, `end_time_ms`, `session_id`, `attributes`, `llm_request`, `llm_response`). **PO routing — BC-2.24.002 {PC-002} exact replacement wording:** Replace the 7-field JSON shape block and its surrounding prose with: `Each stored span has the following shape (source: adk-rust \`convert_to_span_data()\` / \`Trace.ts\`, extended with \`session_id\` for session-keyed ring-buffer filtering — DC-32):` followed by the 8-field JSON block with `"session_id": "<run_id>"` inserted as field 5 between `"end_time_ms"` and `"attributes"`. {INV-007} and {PC-003} require no wording change — they already correctly state `session_id = run_id`; only the shape definition {PC-002} was missing the field. **Story-writer routing — S-console-02 AC-004 exact replacement wording:** Replace the field list with: `span_id: String`, `trace_id: String`, `start_time_ms: u64`, `end_time_ms: u64`, `session_id: String` (the `run_id` of the run that produced this span; set by `DebugSpanExporter` at insertion per BC-2.24.002 {INV-007}), `attributes: serde_json::Map<String, Value>`, `llm_request: Option<Value>`, `llm_response: Option<Value>`. All 8 fields are present; no field is missing.

### Decision 8 — Completed-Run Inspection Substrate (DC-29)

**`StreamEvent` is transient. There is no stored-event-list endpoint and no `RunEvent` persistence substrate in v1.** The incorrect assumption in BC-2.24.004 {PRE-004}/{PC-006}, BC-2.24.007 {PRE-002}, and BC-2.24.008 {PC-004} that the server persists `StreamEvent`s per BC-2.12.006 is architecturally false. This decision defines the v1-realizable completed-run inspection substrate.

**Authority chain:**
- ADR-030 §Decision 2: "`StreamEvent` is transient (emitted over a channel, consumed in real time, not persisted)."
- BC-2.12.007 {EC-002}: "The partial stream is lost (not buffered for reconnect in v1)."
- BC-2.06.001 {EC-003}: "No partial event sequences are delivered to a dropped consumer."
- BC-2.12.006: `RunStore` persists Run lifecycle state transitions (status, output, error, evidence_journal, completed_at), NOT `StreamEvent` payloads. No event-list endpoint is defined.

**v1-realizable substrate for completed-run inspection:**

| Information need | Source | Endpoint / mechanism |
|------------------|--------|----------------------|
| Run final status, output, error | BC-2.12.003 {PC-013} | `GET /threads/{id}/runs/{run_id}` |
| All guardrail decisions (Fail/Transform/Allow) | BC-2.12.003 {PC-013} `evidence_journal?` field | `GET /threads/{id}/runs/{run_id}` (terminal-status runs only) |
| Per-span latency, LLM request/response, attributes | BC-2.24.002 `DebugSpanSource` | `GET /debug/trace/session/{run_id}` (when `debug-endpoints` enabled + within 10k ring buffer) |
| Step-level checkpoint history | BC-2.12.001 / checkpoint read | Checkpoint read endpoint (out of scope for console v1) |

**The console's completed-run view is a composite of run-read + trace-span** — this mirrors ADK's dev console, which shows persisted traces for completed runs (not a replayed event stream).

**Explicit non-decisions (out of v1 scope):**
- A `/runs/{id}/events` endpoint that returns all `StreamEvent`s for a completed run is NOT built. Adding it later would require a new `RunEventStore` persistence layer (a significant v2 decision that would need a new ADR).
- `TrajectoryRecord` (ADR-030) is a specialized primitive for research-orchestrator reproducibility; it is not a general-purpose event replay substrate for the console.

**Implication for `{INV-001}` ("No new server endpoints are required"):** This decision CONFIRMS `{INV-001}`. The run-read endpoint (`GET /threads/{id}/runs/{run_id}`) and debug-trace endpoint (`GET /debug/trace/session/{run_id}`) already exist. No new endpoints are introduced.

> **D-356 adversary fix DC-29 (2026-09-08, architect).** F-PDC29-01 (HIGH): Completed-run inspection realizability gap. Decision 8 added: StreamEvent is transient (ADR-030); no run-event endpoint; no stored-event-list. BC-2.12.006 persists Run state transitions only. The v1-realizable substrate is: `GET /threads/{id}/runs/{run_id}` (run final state + evidence_journal? + output?) PLUS `GET /debug/trace/session/{run_id}` (trace spans when debug-endpoints enabled). This CONFIRMS BC-2.24.004 {INV-001} ("no new server endpoints required") — the two endpoints already exist. BC corrections routed to PO (exact wording in this delta note). **PO routing — exact replacement wording for BC-2.24.004:**

> **BC-2.24.004 {PRE-004}** replacement: "For completed run inspection: the run has a terminal status (`completed`, `failed`, `cancelled`, or `summary_halt`); the run's final state is accessible via `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}); trace spans may be available via `GET /debug/trace/session/{run_id}` (BC-2.24.002) when `debug-endpoints` is enabled and the run's spans are within the ring buffer retention window. There is NO stored StreamEvent list and NO run-event endpoint — StreamEvent is transient (ADR-030 §Decision 2)."

> **BC-2.24.004 {PC-006}** replacement: "**Completed run inspection:** For a terminal-status run (`completed`, `failed`, `cancelled`, `summary_halt`), the SPA fetches the run's final state via `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}) — status, `output?`, `error?`, `evidence_journal?`, and `completed_at?`. When `debug-endpoints` is enabled and the run's spans are within the ring buffer, the SPA additionally fetches span detail via `GET /debug/trace/session/{run_id}` (BC-2.24.002). The completed-run view is static (no SSE subscription). There is NO stored StreamEvent list and NO run-event endpoint; StreamEvent is transient (ADR-030 §Decision 2; ADR-031 Decision 8)."

> **BC-2.24.004 {TV-002}** replacement: "Terminal-status run (`completed`); `GET /threads/{id}/runs/{run_id}` returns `{ status: 'completed', output: '...', evidence_journal: [2 entries], completed_at: '...' }`; `debug-endpoints` enabled with 3 spans in buffer | Static view shows run summary (final output, evidence journal entries, span detail links); no SSE opened | completed-run inspection"

> **PO routing — exact replacement wording for BC-2.24.007:**

> **BC-2.24.007 {PRE-002}** replacement: "The live SSE stream (`GET /threads/{id}/runs/{run_id}/stream`) is open for active runs (BC-2.12.007), OR the run is terminal-status and the run-read response (`GET /threads/{id}/runs/{run_id}`, BC-2.12.003 {PC-013}) is accessible for post-run evidence display. NOTE: per-compaction-event detail (individual `compaction_event` StreamEvent payloads) is NOT available for completed runs — StreamEvent is transient (ADR-030 §Decision 2; ADR-031 Decision 8). The completed-run panel shows the terminal state summary via `evidence_journal?` and the final output context."

> **PO routing — exact replacement wording for BC-2.24.008:**

> **BC-2.24.008 {PC-004}** replacement: "**Completed run reconstruction:** For terminal-status runs, the feed reconstructs from the `evidence_journal?` field on `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}). The `evidence_journal` contains the durable record of all guardrail evaluation results for the run; the console filters and displays entries corresponding to Fail or Transform outcomes. There is NO stored StreamEvent list — `StreamEvent` is transient (ADR-030 §Decision 2; ADR-031 Decision 8); the `evidence_journal` is the correct and authoritative substrate for completed-run guardrail history. (The DI-012 completeness invariant {INV-002} applies to both live-stream and completed-run reconstruction.)"

> **Story-writer routing:** S-console-06 (BC-2.24.004), S-console-09 (BC-2.24.007), S-console-10 (BC-2.24.008) must sweep their completed-run ACs, tasks, and EC rows to align with the corrected BCs. Any AC that references "fetch stored event list," "run-event endpoint," or "replay StreamEvents" must be replaced with run-read + trace-span fetch (as per BC-2.24.004 {PC-006} corrected wording above). **BA routing:** CAP-043 "inspect completed run" capability description should be updated by business-analyst to say "inspect completed run via run-state summary (status, output, evidence_journal) and trace spans (when debug-endpoints enabled)" rather than any wording implying StreamEvent replay.

> **D-356 adversary fix DC-30 (2026-09-08, architect).** F-PDC30-01 (HIGH): session_id vs run_id trace-key gap — silent-empty risk. **Ruling: `session_id = run_id` for all console dev runs.** `DebugSpanExporter` MUST tag every exported span with `session_id = run_id` at insertion time (INV obligation added to BC-2.24.002 — see INV-007 wording below). This makes `GET /debug/trace/session/{run_id}` unambiguous: the path param named `{session_id}` receives the run_id value; the endpoint returns that run's spans. Decision 2 updated with explicit session-key binding note. The Decision 8 table already uses `{run_id}` as the value — this is CORRECT and CONFIRMED; the intra-ADR inconsistency (Decision 2 `{session_id}` vs Decision 8 `{run_id}`) was a naming-vs-value confusion, not a semantic conflict. F-PDC30-02 (MED): swept 6 bare `ADR-030 §Decision` citations → `ADR-030 §Decision 2` (authority is §Decision 2 / §Motivation section of ADR-030). No downstream endpoint cite changes needed for BC-2.24.004/CAP-043/S-console-06 — `GET /debug/trace/session/{run_id}` remains the correct call (pass run_id as session_id); endpoint path template in Decision 2 remains `{session_id}` (general-purpose parameter name). **PO routing — BC-2.24.002 INV-007 (new invariant to add after INV-006):** "{INV-007} **Session key = run_id:** The `DebugSpanExporter` sets `session_id = run_id` on every exported span at insertion time. All spans for a given run are addressable via `GET /debug/trace/session/{run_id}` (BC-2.24.002 {PC-003}). An empty `[]` response means only: (a) the `debug-endpoints` feature is disabled or no exporter was injected, (b) the run's spans have been evicted from the ring buffer by newer spans (FIFO eviction per {INV-001}), or (c) the run produced no traced OTel operations — NOT a silent run/session key mismatch. The `session_id = run_id` invariant MUST be enforced at insertion; no default or override path may produce a span with a different session_id for a run-scoped export."

---

## Rationale

### Why a separate `pregolya-console` crate

Bolting UI concerns onto `pregolya-server` would couple unrelated responsibilities,
violate file-size/cohesion rules (CLAUDE.md), and pollute the headless server's
dependency graph with `rust_embed` and SPA build artifacts. The production-grade default
(CLAUDE.md Rule 1) requires correct separation. The adk-rust reference implements
exactly this split (`adk-server` + separate binary that embeds the SPA). The purity
boundary (Decision 5) requires the effectful Axum server layer and the span-exporter to
live in the console crate, not in pregolya-server's pure-core domain.

### Why `debug-endpoints` on pregolya-server rather than pregolya-console

Trace/span and graph-descriptor endpoints are **library-consumer-useful beyond the
browser UI** — CI pipelines, tooling integrations, and integration tests benefit from
reading graph structure and execution traces programmatically. Research memo §4.3
explicitly argues: "those belong in the server, gated behind a console/debug-endpoints
cargo feature so production deployments can compile them out." Placing them in
`pregolya-console` would make them inaccessible to tooling consumers running headless.

### Why SSE over WebSocket

1. ADR-006 already decided SSE for the `StreamEvent` grammar; reopening that decision
   requires a superseding ADR with a concrete forcing function. No forcing function exists.
2. Both reference implementations (adk-rust, LangGraph SDK) converge on SSE. WebSocket
   was adk-rust `adk-realtime` (voice/live transport — out of scope for a run-debug console).
3. SSE is unidirectional (server → client) and exactly matches the use case: the console
   reads a stream of engine events; it does not need bidirectional protocol negotiation.
4. The browser `EventSource` API is natively available without polyfills. WebSocket would
   require custom reconnection logic and add complexity for no benefit.

### Why SPA framework is deferred

Per the production-grade default, decisions should not be made before they are needed
(CLAUDE.md Rule 1 prohibits "ship fast and iterate" but does NOT require deciding Wave 3
implementation details during Phase 1 architecture). The framework choice does not affect
any current-cycle artifact. When the Wave 3 SPA story is scoped, the team will have
current ecosystem data (bundle sizes, DX, contributor familiarity) to make a
better-informed choice. The binding constraints (Decision 4) are sufficient to gate the
choice without pre-deciding it.

### Why purity boundary classification matters for the console

The console's pure core — the `RingBuffer<SpanData>` data structure and the
`compile_graph_descriptor` transformation — can be subjected to Kani or proptest
verification. The effectful shell (Axum server, OTel exporter registration) cannot.
Drawing the boundary correctly now means VP-XXX (if authored at Phase 6 for the console)
target the right functions and have viable proof strategies.

---

## Consequences

### Positive

- `pregolya console --dev` becomes a single-command local development entry point
  (analogue to `adk web`, `langgraph dev`) — no separate terminal for server + UI.
- Graph-descriptor endpoint (`GET /assistants/{id}/graph`) fills the gap adk-rust left
  as `501 NOT_IMPLEMENTED` — pregolya implements it fully.
- SSE transport confirmation eliminates ambiguity from the brief's "over WebSocket"
  framing and protects downstream artifacts from introducing a WebSocket path.
- `debug-endpoints` feature gate ensures production builds are never inadvertently
  instrumented — correctness by construction, not by operator discipline.
- Purity boundary classification of `graph::descriptor` Pure Core opens a path for
  formal verification of graph structural invariants (no self-loops, connected start
  node) before Phase 6.
- The console is architecturally a client — it consumes the same public wire contract
  as the HS-C-001 holdout, validating the contract's external-host usability.

### Negative / Trade-offs

- Wave 3 adds a new binary crate (`pregolya-console`) to the workspace, increasing the
  build graph. It is blocked behind a `pregolya-server` dependency and will not affect
  earlier-wave build times.
- The SPA build pipeline (webpack/vite/rollup step + `rust_embed`) is a non-Rust build
  step that must be integrated into the `just`/CI recipes at Wave 3.
- `DebugSpanExporter` ring-buffer retention cap introduces a state management concern in
  `pregolya-console`: the exporter must be shared between the console server and the
  pregolya-server debug routes via `Arc`. This is Arc-DI wiring (required by CLAUDE.md
  Arc-DI convention) but adds constructor complexity at `--dev` launch time.
- The graph descriptor `dot_src` field depends on the Graphviz `dot` binary being in
  PATH. This is an optional runtime dependency with no compile-time detection. The `null`
  return when absent must be documented clearly to avoid consumer confusion.

### Status as of v1.0

Roadmap-only. No implementation in the current cycle (Phase 3, Wave 1–2). ADR is
accepted; all six decisions are binding for Wave 3 planning. ARCH-INDEX.md, api-surface.md,
and purity-boundary-map.md updated in the same D-356 burst.

---

## Alternatives Considered

- **Alt A — Embed console functionality directly in `pregolya-server` (rejected).** Would
  couple the headless server with UI concerns (asset serving, `rust_embed` dep, SPA build
  pipeline), violating file-size/cohesion rules and the pure-core/effectful-shell boundary.
  Production deployments wanting a headless server would still compile in UI code.
  Rejected in favor of a separate binary crate.

- **Alt B — WebSocket transport for the console (rejected).** No BC or forcing function
  requires WebSocket; ADR-006 already decided SSE. WebSocket is bidirectional; run-event
  streaming is unidirectional. Adding WebSocket would introduce a second transport to
  maintain alongside SSE. Rejected — SSE confirmed.

- **Alt C — Serve debug endpoints from `pregolya-console` rather than `pregolya-server`
  (rejected).** Would make trace/span and graph data inaccessible to non-browser tooling
  (CI pipelines, integration tests, programmatic consumers). These endpoints are
  library-consumer-useful beyond the console UI. Rejected; they belong in pregolya-server
  behind a feature gate.

- **Alt D — Commit to a SPA framework now (rejected).** Choosing React, Svelte, or SolidJS
  now provides no benefit to the current implementation cycle and forecloses an informed
  decision. The constraints that matter (Decision 4) are specified. Decision deferred to
  Wave 3.

- **Alt E — Inline `graph::descriptor` logic in `server::debug_routes` (partially
  accepted, extracted required at Phase 6).** The transformation function is currently
  co-located with the HTTP handler. This is acceptable for Wave 3 scaffolding. However,
  Purity Enforcement Rule 3 requires extraction to a Pure Core module before Phase 6 so
  the function can be targeted by formal verification. Inline-for-now with required
  extraction is the chosen approach.

---

## Source / Origin

- **D-356 human authorization** (2026-09-06) — developer console scope expansion.
- **Research memo** `devconsole-adk-research.md` — feature inventory, adk-rust source
  analysis, LangGraph Studio comparison, reuse analysis (§4.1), component boundary
  recommendation (§4.3), transport reconciliation (§4.0).
- **CAP-041 through CAP-047** (`capabilities-p1-p2.md`) — business-analyst authored
  behavioral requirements for the console surface.
- **ADR-006** `decisions/ADR-006-streaming-event-taxonomy.md` — SSE transport authority
  (Decision 3 grounds).
- **BC-2.12.005** — `SecurityConfig.debug_route_key` gate (Decision 2 security interaction).
- **HS-C-001** (`holdout-scenarios/HS-C-001-flowloom-embedding-host-end-to-end.md`) —
  proves an external host consuming the public wire contract works; validates the
  console-as-client architecture posture.
- **adk-rust corpus** (`.reference/adk-rust/adk-server/`, pinned v1.0.0 SHA a6c79b6) —
  `web_ui.rs`, `debug.rs`, `rest/mod.rs` examined directly for reference architecture
  alignment.

---

## Traceability

| Architecture Element | CAP Anchors | SS |
|----------------------|-------------|----|
| `pregolya-console` crate | CAP-041 | SS-24 |
| `DebugSpanExporter` + `/debug/trace/*` | CAP-042 | SS-24 |
| `GET /assistants/{id}/graph` | CAP-042, CAP-003 | SS-24, SS-02 |
| Run inspection + live monitoring panel | CAP-043 | SS-24 |
| Checkpoint history browser + trajectory replay | CAP-044 | SS-24, SS-04 |
| HITL console resume dialog | CAP-045 | SS-24, SS-05 |
| Token/context budget panel | CAP-046 | SS-24, SS-10 |
| Guardrail review panel | CAP-047 | SS-24, SS-11 |
| SSE transport confirmation | (ADR-006) | SS-06, SS-12 |

---

## What Product-Owner and Story-Writer Must Anchor To

### Product-owner actions (before Wave 3 story decomposition)

1. Author BC-2.24.001 through BC-2.24.NNN for SS-24 using CAP-041..047 as specification
   source. Initial BC map:
   - BC-2.24.001 — `pregolya-console` startup and asset-serving contract (console::server)
   - BC-2.24.002 — `DebugSpanExporter` retention + trace-read (console::span_exporter + server::debug_routes)
   - BC-2.24.003 — Graph-descriptor structural contract (server::debug_routes)
   - BC-2.24.004 — Run inspection event timeline (CAP-043)
   - BC-2.24.005 — Checkpoint history browser + fork-from-checkpoint (CAP-044)
   - BC-2.24.006 — HITL approval dialog + resume dispatch (CAP-045)
   - BC-2.24.007 — Budget panel compaction event rendering (CAP-046)
   - BC-2.24.008 — Guardrail security feed (CAP-047)
2. **RESOLVED (2026-09-06):** Error codes reconciled — `E-SERVER-023 DebugExporterNotConfigured`
   already minted in error-taxonomy.md v1.72; `E-SERVER-009 AssistantNotFound` is an existing
   code that covers this case. No new mints needed. BCs already consistent.
3. **Audit all BC files for "WebSocket"** (Decision 3). Command:
   `grep -ri "websocket" .factory/specs/behavioral-contracts/`. Correct any occurrence
   describing the run-streaming transport to "SSE."

### Story-writer actions (Wave 3, after BC authoring)

Wave 3 stories (not exhaustive; derive final list from BCs):
- `pregolya-console` crate init (Cargo workspace member, `rust_embed` dep, ConsoleConfig)
- `DebugSpanExporter` implementation + `debug-endpoints` feature on pregolya-server
- `graph::descriptor` Pure Core module + `GET /assistants/{id}/graph` endpoint
- Web SPA project setup (framework selection, build pipeline, runtime-config.json)
- Run inspection panel + live node highlighting
- HITL console resume dialog
- Checkpoint history browser + fork-from-checkpoint
- Token/context budget monitoring panel
- Guardrail security review panel
- CI gate for `debug-endpoints` default-off invariant

**Suggested story ordering:** console crate init → DebugSpanExporter → graph descriptor →
SPA setup → panel stories (parallelizable after SPA setup is scaffolded).
