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
version: "1.17"
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
input-hash: "fbfcc99"
changelog:
  - "1.17 (D-356/DC-48/F-PDC48-02/2026-09-09, architect): F-PDC48-02 (MED) — phantom `server::run_read_handler` replaced with canonical `server::handlers` in Decision 8 substrate table (two rows — evidence_journal? and guardrail_journal? both updated): 'assembled at run-read time by `server::run_read_handler`' → 'assembled at run-read time by the run-read handler in `server::handlers`'. evidence_journal? row additionally clarified: retrieval via `graph::budget::get_evidence_journal(checkpoint_store, run_id)` (typed wrapper; server→graph edge; F-PDC48-01/DC-48). `server::run_read_handler` is not a separate module (F-PDC48-02/DC-48). input-hash updated 78e89d3→fbfcc99 (input drift from prior burst)."
  - "1.16 (D-356/DC-47/F-PDC47-02/OBS/2026-09-09, architect): F-PDC47-02 (HIGH) — CLASS-SWEEP: ADR-031 already has 8-field SpanData at Decision 2/5/7 (session_id present; confirmed ✓). OBS (LOW) — D6-2 live text: strip → redact-in-place (fields retained, values → <redacted>; BC-2.24.002 {PC-008}). OBS (LOW) — DC-02 historical delta note: strip LLM payload fields → redact credential values within LLM payload fields in place (same correction). input-hash updated 78e89d3 (content change)."
  - "1.15 (D-356/DC-46/2026-09-09, architect): DC-46 gate-backlog: (A) promoted 8 Decision headings from ### to ## Decision N (validator requires ^## Decision N); renamed ## Decision umbrella to ## Decisions; (B) purged 4 HS-C-001 holdout references from normative body (lines ~70/111/430/499); (D) removed 5 version pins from error-taxonomy.md (×3) and purity-boundary-map.md (×2); (E) fixed chained §Decision 2 citation in DC-07 delta note → bare Decision 2. input-hash unchanged (inputs did not change)."
  - "1.14 (D-356/DC-44/F-PDC44-01/2026-09-09, architect): F-PDC44-01 (MED) — Decision 8 GuardrailJournal substrate row: added init mechanism — graph::provenance calls checkpoint_store.init_guardrail_journal(run_id) at run start if invocation_context.guardrail_hook().is_some(); this creates the empty journal record enabling None-vs-Some([]) discrimination per {INV-004} (no hook = no record = None; hook registered + zero ingress = empty record = Some([]); hook + N entries = Some([N])). Added DC-44 delta note with exact downstream wording for PO/BA/story-writer. input-hash unchanged (inputs did not change)."
  - "1.13 (D-356/DC-41/F-PDC41-01/2026-09-09, architect): F-PDC41-01 (MED) — Decision 8 substrate table corrected per POL-21 (v1.11 changelog claimed checkpoint-backed wording was applied but body was not updated). Guardrail row rewritten: checkpoint-backed GuardrailJournal (pregolya-checkpoint, same store as BC-2.10.002 EvidenceJournal); appended sync-durable per successfully-returning evaluate() by graph::provenance; assembled at run-read time by server::run_read_handler via get_guardrail_journal(run_id). evidence_journal row updated in parallel: checkpoint-backed EvidenceJournal (pregolya-checkpoint, BC-2.10.002 {INV-003}); appended per BudgetPolicy evaluation by graph::scheduler; assembled at run-read time by server::run_read_handler. Whole-table sweep: no residual 'RunStore record' journal-storage language found. input-hash unchanged (inputs did not change)."
  - "1.12 (D-356/DC-40/F-PDC40-02/2026-09-09, architect): F-PDC40-02 (MED) — DC-33 delta note annotated with inline supersession marker: GuardrailJournal is checkpoint-backed (pregolya-checkpoint), NOT stored on the RunStore record; run-read projection assembled by server::run_read_handler at read time. DC-33 note stated 'Stored as guardrail_journal: Vec<GuardrailEntry> on the per-run RunStore record' which is the false model corrected by DC-39. Annotation follows F-PDC34-04/DC-29 sibling pattern. input-hash updated 74304de→4eae509 (input drift from DC-39 burst)."
  - "1.11 (D-356/DC-39/F-PDC39-02/2026-09-09, architect): F-PDC39-02 architectural ruling recorded — DC-36 F-PDC36-01 GuardrailJournal persistence model SUPERSEDED. EvidenceJournal (BC-2.10.002) was wrongly characterized as RunStore terminal-state; it is checkpoint-backed (pregolya-checkpoint, SQLite), appended sync-durable in graph::scheduler BEFORE execution resumes. GuardrailJournal RULING: same model as actual EvidenceJournal — checkpoint-backed (pregolya-checkpoint), appended in graph::provenance sync-durable BEFORE execution continues at each ingress boundary; NO server::handlers terminal-state write; NO graph execution result Vec channel; run-read guardrail_journal? assembled from checkpoint store by server::run_read_handler at read time. Decision 8 substrate table GuardrailJournal description updated accordingly: 'Stored as guardrail_journal: Vec<GuardrailEntry> on the per-run RunStore record' → checkpoint-backed; run-read projection bridge noted. input-hash updated ab2a44b→74304de (input drift from prior burst)."
  - "1.10 (D-356/DC-34/F-PDC34-07/F-PDC34-03/O-PDC34-A/F-PDC34-04/2026-09-08, architect): F-PDC34-07 — changelog reordered DESCENDING (newest-first; ADR sibling convention; frontmatter version now matches first entry). F-PDC34-03 (HIGH) — GuardrailEntry.boundary adjudication: `IngressBoundary` is an existing canonical type (BC-2.06.001 §Postconditions PC-002 StreamEvent::GuardrailDecision; values ToolResult | RagChunk | MemoryItem); `GuardrailEntry.boundary` MUST be `IngressBoundary` (not `String`); DC-33 note '(hook identity)' mislabel corrected to '(ingress-boundary label; canonical type per BC-2.06.001 §Postconditions PC-002)' in §Decision 8 GuardrailEntry shape; routing: PO update BC-2.11.007 {PC-001} String→IngressBoundary; BA update entities-server §GuardrailJournal String→IngressBoundary; story-writer confirm S-console-10 AC-004 boundary type. O-PDC34-A — GuardrailEntry.transform_applied ruling: DROP `transform_applied: Option<String>` from GuardrailEntry — `result.Transform.new_content: IngressContent` is the authoritative payload; `transform_applied` is a redundant String representation that creates ambiguity between new_content and a human-readable description; routing: PO update BC-2.11.007 {PC-001} shape (remove transform_applied field); BA update entities-server §GuardrailJournal (remove transform_applied); story-writer sweep S-console-10 ACs. F-PDC34-04 (MED) — DC-29 block in §Decision 8 annotated inline with supersession note (DC-33 corrected the substrate to guardrail_journal?; evidence_journal? is budget-only; top-down readers no longer hit wrong routing without warning)."
  - "1.9 (D-356/DC-33/F-PDC33-01/F-PDC33-02/F-PDC33-03/2026-09-08, architect): F-PDC33-01 (HIGH) — Decision 5 `server::debug_span` row: `session_id` added as field 5 of SpanData enumeration (between `end_time_ms` and `attributes`); canonical 8-field shape now consistent across Decision 2, Decision 5, and Decision 7 (DC-32 established the shape; this burst completes the TD-VSDD-060 sibling sweep). F-PDC33-03 (MED) — three stale 'six'/'Six' live-spec sites corrected to 'eight'/'Eight' (§Context binding-decisions count, §Decision preamble count, §Binding Status count); section title '§Status as of v1.0' generalized to '§Binding Status' (version pin in heading is anti-pattern per TD-VSDD-091; changelog 1.0 'Six decisions' line is a historical record and is not revised). F-PDC33-02 (HIGH) — Decision 8 substrate table row 'All guardrail decisions (Fail/Transform/Allow)' corrected: (1) enum mislabel fixed — 'Fail/Transform/Allow' conflated GuardrailResult variants (Pass/Fail/Transform, produced by GuardrailHook::evaluate at ingress boundaries) with PolicyDecision variants (Allow/Escalate/Deny, produced by BudgetPolicy and recorded in evidence_journal?); (2) split into two rows: 'Budget policy decisions (Allow/Escalate/Deny)' with correct evidence_journal? source, and 'Guardrail evaluation results (Pass/Fail/Transform)' marked pending Option (a) core-domain change; (3) ruling: Option (a) — durable GuardrailJournal required; human authorization required before core-entity/BC implementation; downstream routing in DC-33 delta note. DC-29 PO routing for BC-2.24.008 {PC-004} superseded by DC-33 (evidence_journal? is budget-scoped only; guardrail_journal? is the correct substrate for guardrail history). input-hash updated to a9c4419 (api-surface.md changed in same burst; input drift resolved)."
  - "1.8 (D-356/DC-32/F-PDC32-02/2026-09-08, architect): F-PDC32-02 — session_id realizability gap resolved. SpanData gains field 5: `session_id: String` (the run_id of the producing run; set by DebugSpanExporter at insertion per BC-2.24.002 {INV-007}). Decision 2 SpanData shape prose and Decision 7 Rust struct definition both updated to 8 fields (byte-consistent). PO routing: BC-2.24.002 {PC-002} SpanData shape and JSON example must add `session_id: '<run_id>'` as field 5 (between end_time_ms and attributes). Story-writer routing: S-console-02 AC-004 field list must add `session_id: String` as field 5."
  - "1.7 (D-356/DC-30/2026-09-08, architect): F-PDC30-01 — session_id = run_id binding added to Decision 2; Decision 8 table clarified. F-PDC30-02 — swept 6 bare §Decision citations → §Decision 2 (changelog 1.6, Decision 8 authority chain, 4 PO-routing wording blocks). PO routing: BC-2.24.002 INV-007 exact wording in DC-30 delta note."
  - "1.6 (D-356/DC-29/2026-09-08, architect): F-PDC29-01 — Decision 8 added: completed-run inspection substrate. Resolves realizability gap in BC-2.24.004 {PRE-004}/{PC-006}/{TV-002}, BC-2.24.007 {PRE-002}, BC-2.24.008 {PC-004}: all three incorrectly assumed a stored StreamEvent list + run-event endpoint that do not exist. Decision: use run-read endpoint (BC-2.12.003 {PC-013}) + debug-trace endpoint (BC-2.24.002) for completed-run inspection. StreamEvent is transient (ADR-030 §Decision 2); no StreamEvent persistence substrate is introduced. PO routing: exact replacement wording for all three BCs in DC-29 delta note."
  - "1.5 (D-356/DC-23/2026-09-08, architect): F-PDC23-03 — Mutex→RwLock for span ring buffer (concurrent-reader adjudication). Decision 5 table `console::span_exporter` row updated: `Arc<Mutex<RingBuffer<SpanData>>>` → `Arc<RwLock<RingBuffer<SpanData>>>`. Rationale: S-console-03 AC-008 explicitly requires RwLock for multiple concurrent debug-route readers; BC-2.24.002 EC-006 specifies 'RwLock or similar'; Mutex serializes all reads and fails the concurrent-reader requirement. PO routing: BC-2.24.002 INV-002 must be updated (exact replacement wording in DC-23 delta note). input-hash updated to c9607b2 (input drift resolved — inputs changed prior to this burst)."
  - "1.4 (D-356/DC-10/2026-09-07, architect): F-PDC10-02 — dependency-cycle break via inversion. Added server::debug_span (Boundary) to pregolya-server: SpanData data type + DebugSpanSource read-trait. server::debug_routes now reads via Arc<dyn DebugSpanSource> (not Arc<DebugSpanExporter>). console::span_exporter implements DebugSpanSource and DEPENDS ON server::debug_span for SpanData+trait — console→server direction (already asserted; no cycle). Decision 5 table: added server::debug_span row, updated server::debug_routes + console::span_exporter rows. Decision 7 added. input-hash unchanged (inputs did not change; current dfd9a77)."
  - "1.3 (D-356/DC-07/2026-09-07, architect): F-PDC07-01 — sweep debug_api_key → debug_route_key (5 sites: changelog 1.1, §Decision 2 Security interaction, D6-2, DC-02 blockquote, §Source). F-PDC07-02 — D6-2 and §Decision 2 Security interaction updated to state both auth behaviors explicitly: (a) empty/absent debug_route_key → E-SERVER-013 InvalidDebugRouteKey startup-refusal before HTTP listener binds; (b) valid key + unauthenticated request → E-SERVER-004 403 at runtime. input-hash unchanged (inputs did not change)."
  - "1.2 (D-356/DC-04/2026-09-07, architect): F-PDC04-04 — Decision 5 split: `console::ring_buffer` added as canonical Pure Core module (RingBuffer<T> deterministic bounded FIFO; no I/O deps; Kani/proptest-provable; VP-2.24.002-A/B targets). `console::span_exporter` updated to Boundary (owns Arc<Mutex<RingBuffer<SpanData>>>, depends on console::ring_buffer; performs SEC-BOUND-001 sanitization AT insertion). This split is the canonical arbiter; prevents future flip-flop. VP-2.24.002-A/B repointed to console::ring_buffer in all four VP mirrors. input-hash unchanged (inputs did not change)."
  - "1.1 (D-356/DC-02/2026-09-07, architect): F-PDC02-05 — D6-2 security strengthened: debug_route_key is now MANDATORY (not opt-in) when debug-endpoints feature is enabled; unauthenticated /debug/* requests → 403 E-SERVER-004 DebugRouteUnauthorized. §Security interaction updated from 'opt-in debug-key gate' to mandatory gate with explicit error code and DNS-rebinding rationale. SpanData sanitization (SEC-BOUND-001 parity; llm_request/llm_response strips from SpanData) cross-referenced to BC-2.24.002. Companion api-surface.md §Security note updated. input-hash unchanged (inputs did not change)."
  - "1.0 (D-356/2026-09-06, architect): Initial ADR — developer console scope expansion. Six decisions: (1) pregolya-console new binary crate (Wave 3, roadmap); (2) debug-endpoints feature-gated on pregolya-server; (3) SSE transport confirmed, WebSocket-vs-SSE discrepancy closed; (4) SPA framework deferred to Wave 3; (5) purity boundary: console::server Effectful Shell, console::span_exporter Boundary, server::debug_routes Effectful Shell; (6) NFR/security deltas: localhost-bind, no external auth in dev mode, debug-endpoints OFF by default."
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
   `CompactionEvent` variants). External host integration testing confirms an external
   host can consume the stream.
4. Net-new backend additions are modest: `/debug/trace/*` span-read endpoints (plus an
   in-memory OTel span exporter) and a graph-descriptor endpoint. Everything else the
   console needs already exists in the public wire contract.
5. Three-component split is recommended: headless `pregolya-server` (transport authority,
   no change), `pregolya-console` (new binary crate: embeds SPA, dev-server launch, span
   exporter host), and web SPA (separate build artifact, own wave).

This ADR makes eight binding decisions and formally closes the WebSocket-vs-SSE discrepancy.

---

## Decisions

Eight binding decisions are made in this ADR, each as a numbered section.

## Decision 1 — `pregolya-console` Crate

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
used by external host integrations that consume the public wire contract. This is a structural crate-level invariant,
enforced by the `Cargo.toml` dependency graph.

**Public surface (limited):**
- `ConsoleConfig` struct (host, port, dev_mode, span_retention_cap)
- `run_console(config: ConsoleConfig) -> Result<(), PregolyaError>` async entry point

CAP anchor: CAP-041.

## Decision 2 — Debug Endpoints on `pregolya-server` (Feature-Gated)

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
- `E-SERVER-023 DebugExporterNotConfigured` (SERVER, VAL — minted in error-taxonomy.md per product-owner; no further action)
- `E-SERVER-009 AssistantNotFound` (existing code — already covers this case; no new mint needed per product-owner reconciliation 2026-09-06)

> **D-356 error-code reconciliation (2026-09-06, architect).** Original Decision 2 specified E-SERVER-020 for DebugExporterNotConfigured and E-SERVER-021 for AssistantNotFound. Product-owner reconciled against error-taxonomy.md: E-SERVER-020 was already assigned; correct code is E-SERVER-023 (minted in error-taxonomy.md). E-SERVER-021 is unnecessary — existing E-SERVER-009 AssistantNotFound covers this case. BCs BC-2.24.002 (cites E-SERVER-023) and BC-2.24.003 (cites E-SERVER-009) are already consistent. Source-of-truth precedence: error-taxonomy.md (PRD supplement) supersedes ADR prose per CLAUDE.md §Source-of-Truth Precedence rule 3.

CAP anchor: CAP-042.

## Decision 3 — Transport: SSE Confirmed, WebSocket Closed

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

## Decision 4 — Web SPA Framework: Explicitly Deferred to Wave 3

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

## Decision 5 — Purity Boundary

New modules introduced by this ADR. All are **[PLANNED]** (Wave 3). Module-decomposition.md
and verification-coverage-matrix.md will be updated at Wave 3 planning.

| Module | Crate | Classification | Rationale |
|--------|-------|----------------|-----------|
| `console::server` | pregolya-console | **Effectful Shell** | Axum HTTP server: binds network port, serves assets over I/O, manages in-process server lifecycle, async tokio runtime |
| `console::ring_buffer` | pregolya-console | **Pure Core** | `RingBuffer<T>` deterministic bounded FIFO data structure: capacity-enforcement arithmetic, index-wrap computation, head-pointer advance on enqueue overflow — no I/O, no `tokio`, no `opentelemetry` deps; Kani/proptest-provable; VP-2.24.002-A (`ring_buffer_bounded_invariant`) and VP-2.24.002-B (`ring_buffer_fifo_invariant`) targets; canonical pure vehicle for `RingBuffer<SpanData>` storage |
| `console::span_exporter` | pregolya-console | **Boundary** | Effectful OTel exporter: `DebugSpanExporter` owns `Arc<RwLock<RingBuffer<SpanData>>>` — **depends on `console::ring_buffer` (Pure Core)**; **depends on `server::debug_span` (pregolya-server)** for `SpanData` type + `DebugSpanSource` trait (console→server dep direction; no cycle); implements `DebugSpanSource` (server-owned trait — consumer-owns-interface pattern, Decision 7); performs SEC-BOUND-001 sanitization AT insertion; Arc-DI injected at pregolya-server launch |
| `server::debug_routes` [feature `debug-endpoints`] | pregolya-server | **Effectful Shell** | HTTP handlers: reads spans via `Arc<dyn DebugSpanSource>` (injected at launch by the console layer — dependency inversion per Decision 7; server does NOT depend on pregolya-console); queries AssistantStore (async I/O); feature-gated, excluded from production builds by default |
| `server::debug_span` [feature `debug-endpoints`] | pregolya-server | **Boundary** | `SpanData` data type (span_id, trace_id, start_time_ms, end_time_ms, session_id, attributes, llm_request, llm_response) + `DebugSpanSource` read-trait (`fn get_session_spans(&self, session_id: &str) -> Vec<SpanData>`, `fn get_span(&self, event_id: &str) -> Option<SpanData>`); server-owned interface — consumer-owns-interface (DIP); pregolya-server depends on NOTHING in pregolya-console; `DebugSpanExporter` (console) implements this trait and is injected at launch |
| `graph::descriptor` [Pure Core, extracted] | pregolya-graph | **Pure Core** | `fn compile_graph_descriptor(graph: &CompiledStateGraph) -> GraphDescriptor` — deterministic, no I/O, no global state; required extraction before Phase 6 (Purity Enforcement Rule 3) |

## Decision 6 — NFR and Security Deltas

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
  `SpanData` sanitization (SEC-BOUND-001 parity — redact credential values within `llm_request`/`llm_response`/`attributes` in place per BC-2.24.002 {PC-008}) is specified in BC-2.24.002.
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

## Decision 7 — DebugSpanSource Dependency Inversion (DC-10)

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

> **D-356 adversary fix DC-02 (2026-09-07, architect).** F-PDC02-05: D6-2 security posture strengthened per adversary finding. `debug_route_key` is now MANDATORY (not opt-in) when the `debug-endpoints` Cargo feature is enabled; unauthenticated requests to `/debug/*` return `403` with `E-SERVER-004 DebugRouteUnauthorized`. Rationale: `SpanData` exposes `llm_request`/`llm_response` payloads; loopback bind alone is insufficient against the DNS-rebinding/CSRF-to-127.0.0.1 vector. `SpanData` sanitization (SEC-BOUND-001 parity — redact credential values within LLM payload fields in place per BC-2.24.002 {PC-008}) is cross-referenced to BC-2.24.002. Companion: api-surface.md §Security note updated to reflect mandatory auth.

> **D-356 adversary fix DC-07 (2026-09-07, architect).** F-PDC07-01: swept `debug_api_key` → `debug_route_key` at all 5 ADR-031 sites (changelog 1.1, §Decision 2 Security interaction, D6-2, DC-02 blockquote, §Source). Canonical field is `debug_route_key: Option<String>` per BC-2.12.005 PRE-004/PC-006/PC-007/INV-001 and ADR-021 §Decision 1 — the non-canonical `debug_api_key` was introduced in DC-02. F-PDC07-02: D6-2 and Decision 2 Security interaction now state both auth behaviors explicitly: (a) empty/absent `debug_route_key` → `E-SERVER-013 InvalidDebugRouteKey` startup-refusal before HTTP listener binds; (b) valid key + unauthenticated request → `E-SERVER-004 DebugRouteUnauthorized` 403 at runtime. Companion: api-surface.md updated in same burst (F-PDC07-01 rename + F-PDC07-02 both-behaviors). F-PDC07-03: 10 panel-VP Module cells repointed to `spa/components/<panel>` convention in all 4 VP mirrors (VP-INDEX, verification-architecture, verification-coverage-matrix, ARCH-INDEX); VP-INDEX preamble SPA convention note added; v1.44 false changelog claim corrected via new v1.48 entry.

> **D-356 adversary fix DC-10 (2026-09-07, architect).** F-PDC10-02: Cargo crate-dependency cycle broken via dependency inversion (DIP). Root cause: the prior specification placed `SpanData` and `DebugSpanExporter` in pregolya-console, but `server::debug_routes` (pregolya-server) needed to hold `Arc<DebugSpanExporter>` and serialize `SpanData` — requiring server to compile-depend on console, creating the `console→server→console` cycle. Resolution: (1) New module `server::debug_span` added to pregolya-server (Decision 7) — owns `SpanData` data type + `DebugSpanSource` read-trait (consumer-owns-interface). (2) `server::debug_routes` now reads via `Arc<dyn DebugSpanSource>` injected at launch — zero compile dep on pregolya-console. (3) `console::span_exporter` implements `DebugSpanSource` and depends on pregolya-server for the type + trait — `console→server` dep direction (already the asserted direction in dependency-graph.md). No cycle. VP-2.24.002-A/B/C/D module anchors UNCHANGED (console::ring_buffer / console::ring_buffer / server::debug_routes / console::span_exporter). Companion: purity-boundary-map.md updated same burst; dependency-graph.md + BC-2.24.002 §Module + S-console-03 corrections routed to story-writer/PO.

> **D-356 adversary fix DC-04 (2026-09-07, architect).** F-PDC04-04: Decision 5 purity table split into two canonical modules. `console::ring_buffer` is now the **canonical Pure Core** module hosting `RingBuffer<T>` (deterministic bounded FIFO, no I/O deps, Kani/proptest-provable; VP-2.24.002-A/B targets). `console::span_exporter` remains **Boundary** but is now explicitly defined as the OTel exporter that **DEPENDS ON** `console::ring_buffer` — it owns `Arc<Mutex<RingBuffer<SpanData>>>` and performs SEC-BOUND-001 sanitization AT insertion before delegating to the ring buffer. This ADR text is the canonical arbiter for the module split; it prevents future reversion (DC-01 introduced `console::ring_buffer` non-canonically; DC-02 collapsed both into `console::span_exporter`; DC-04 resolves by canonicalizing the split with explicit dependency direction). VP-2.24.002-A/B repointed to `console::ring_buffer` in all four VP mirrors. VP-2.24.002-D (sanitization) stays at `console::span_exporter`. BC-2.24.002 §Module wording for PO: "`pregolya-console` — two modules: `console::ring_buffer` (Pure Core, `RingBuffer<T>` data structure) and `console::span_exporter` (Boundary, `DebugSpanExporter` OTel exporter owning `Arc<Mutex<RingBuffer<SpanData>>>`).". INV-002 wording for PO: "`RingBuffer<SpanData>` storage lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` in `console::span_exporter` (Boundary) is the sole writer via `Arc<Mutex<RingBuffer<SpanData>>>`; reads served by `server::debug_routes` via the same Arc handle."

> **D-356 adversary fix DC-23 (2026-09-08, architect).** F-PDC23-03: `Arc<Mutex<RingBuffer<SpanData>>>` corrected to `Arc<RwLock<RingBuffer<SpanData>>>` in Decision 5 table `console::span_exporter` row (live content only; DC-04 historical delta note above is not revised — it records what DC-04 decided at the time). Ruling: S-console-03 AC-008 explicitly states "The `RwLock` inside the concrete `DebugSpanExporter`... allows multiple concurrent readers." `Mutex` serializes ALL access and cannot satisfy this load-bearing requirement. `RwLock` permits concurrent read-guard holders (multiple simultaneous HTTP debug-route requests) plus exclusive write access during OTel span insertion. BC-2.24.002 EC-006 independently corroborates ("RwLock or similar"). The DC-04 `Mutex` pin was incorrect and is superseded by this ruling. **PO routing — BC-2.24.002 INV-002 replacement wording:** "`RingBuffer<SpanData>` storage lives in `console::ring_buffer` (Pure Core); `DebugSpanExporter` in `console::span_exporter` (Boundary) is the sole writer via `Arc<RwLock<RingBuffer<SpanData>>>` (acquires write lock at insertion; multiple concurrent readers acquire read locks at query time); reads served by `server::debug_routes` via the same Arc handle (ADR-031 Decision 5)." Companion: purity-boundary-map.md updated same burst. Stories S-console-02 and S-console-03 already cite RwLock in AC-008/EC-005 — no story edits required for F-PDC23-03.

> **D-356 adversary fix DC-32 (2026-09-08, architect).** F-PDC32-02 (MED): `session_id` realizability gap. `{INV-007}` required `DebugSpanExporter` to tag every exported span with `session_id = run_id` at insertion time, and `DebugSpanSource::get_session_spans` (Decision 7) required filtering by `session_id`; however `SpanData` carried only 7 fields (`span_id`, `trace_id`, `start_time_ms`, `end_time_ms`, `attributes`, `llm_request`, `llm_response`) with no `session_id` field, and the ring buffer is a flat `RingBuffer<SpanData>` with no session-keyed index. Both the insertion invariant and the filter method were unrealizable as written. **Ruling: Option A — add typed `session_id: String` as field 5** (between `end_time_ms` and `attributes`). Option B (store as `attributes["session_id"]`) was considered and rejected: any code path that merges or overwrites the `attributes` JSON object can silently corrupt the session key, making the "no default or override path" obligation in `{INV-007}` structurally unenforceable on a mutable JSON map; a dedicated typed field eliminates the ambiguity and the fragility. The `session_id` field is set by `DebugSpanExporter` at insertion (same code site as SEC-BOUND-001 sanitization); it is a routing key (`run_id`), not user-originated sensitive data, and is NOT passed through the SEC-BOUND-001 pipeline. With field 5 present, `get_session_spans` becomes a direct typed-field equality filter (`span.session_id == session_id`) over the flat ring buffer — O(n) linear scan, no attributes map lookup, no key-collision risk. `#[non_exhaustive]` on `SpanData` (`{INV-003}`) makes this a non-breaking API extension. Decision 2 SpanData shape prose and Decision 7 Rust struct definition updated in this burst to be byte-consistent (both now list 8 fields: `span_id`, `trace_id`, `start_time_ms`, `end_time_ms`, `session_id`, `attributes`, `llm_request`, `llm_response`). **PO routing — BC-2.24.002 {PC-002} exact replacement wording:** Replace the 7-field JSON shape block and its surrounding prose with: `Each stored span has the following shape (source: adk-rust \`convert_to_span_data()\` / \`Trace.ts\`, extended with \`session_id\` for session-keyed ring-buffer filtering — DC-32):` followed by the 8-field JSON block with `"session_id": "<run_id>"` inserted as field 5 between `"end_time_ms"` and `"attributes"`. {INV-007} and {PC-003} require no wording change — they already correctly state `session_id = run_id`; only the shape definition {PC-002} was missing the field. **Story-writer routing — S-console-02 AC-004 exact replacement wording:** Replace the field list with: `span_id: String`, `trace_id: String`, `start_time_ms: u64`, `end_time_ms: u64`, `session_id: String` (the `run_id` of the run that produced this span; set by `DebugSpanExporter` at insertion per BC-2.24.002 {INV-007}), `attributes: serde_json::Map<String, Value>`, `llm_request: Option<Value>`, `llm_response: Option<Value>`. All 8 fields are present; no field is missing.

## Decision 8 — Completed-Run Inspection Substrate (DC-29)

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
| Budget policy decisions (Allow/Escalate/Deny) | `evidence_journal?` (BC-2.12.003 {PC-013}) — checkpoint-backed `EvidenceJournal` (pregolya-checkpoint, BC-2.10.002 {INV-003}); appended sync-durable per `BudgetPolicy` evaluation by `graph::scheduler`; assembled at run-read time by the run-read handler in `server::handlers` via `graph::budget::get_evidence_journal(checkpoint_store, run_id)` (typed wrapper; server→graph edge; F-PDC48-01/F-PDC48-02/DC-48); owned by BC-2.10.002 | `GET /threads/{id}/runs/{run_id}` (terminal-status runs only) |
| Guardrail evaluation results (Pass/Fail/Transform) | `guardrail_journal?` (BC-2.12.003 {PC-013}) — checkpoint-backed `GuardrailJournal` (pregolya-checkpoint, same store as BC-2.10.002 EvidenceJournal); at run start `graph::provenance` calls `checkpoint_store.init_guardrail_journal(run_id)` if `invocation_context.guardrail_hook().is_some()` (creates empty journal record enabling `None`-vs-`Some([])` discrimination per {INV-004}: `None` = no hook registered, `Some([])` = hook registered + zero ingress, `Some([N])` = N entries; DC-44 ruling); appended sync-durable per successfully-returning `evaluate()` by `graph::provenance`; assembled at run-read time by the run-read handler in `server::handlers` via `checkpoint_store.get_guardrail_journal(run_id)` (`server::run_read_handler` is not a separate module — F-PDC48-02/DC-48); governed by BC-2.11.007; entity in entities-server.md §GuardrailJournal; DC-33 human-authorized core amendment | `GET /threads/{id}/runs/{run_id}` (terminal-status runs only) |
| Per-span latency, LLM request/response, attributes | BC-2.24.002 `DebugSpanSource` | `GET /debug/trace/session/{run_id}` (when `debug-endpoints` enabled + within 10k ring buffer) |
| Step-level checkpoint history | BC-2.12.001 / checkpoint read | Checkpoint read endpoint (out of scope for console v1) |

**The console's completed-run view is a composite of run-read + trace-span** — this mirrors ADK's dev console, which shows persisted traces for completed runs (not a replayed event stream).

**Explicit non-decisions (out of v1 scope):**
- A `/runs/{id}/events` endpoint that returns all `StreamEvent`s for a completed run is NOT built. Adding it later would require a new `RunEventStore` persistence layer (a significant v2 decision that would need a new ADR).
- `TrajectoryRecord` (ADR-030) is a specialized primitive for research-orchestrator reproducibility; it is not a general-purpose event replay substrate for the console.

**Implication for `{INV-001}` ("No new server endpoints are required"):** This decision CONFIRMS `{INV-001}`. The run-read endpoint (`GET /threads/{id}/runs/{run_id}`) and debug-trace endpoint (`GET /debug/trace/session/{run_id}`) already exist. No new endpoints are introduced.

> **D-356 adversary fix DC-29 (2026-09-08, architect). *(SUPERSEDED by DC-33 — `guardrail_journal?` is the correct substrate for completed-run guardrail history; `evidence_journal?` is budget-only — see DC-33 delta note below)*:** F-PDC29-01 (HIGH): Completed-run inspection realizability gap. Decision 8 added: StreamEvent is transient (ADR-030); no run-event endpoint; no stored-event-list. BC-2.12.006 persists Run state transitions only. The v1-realizable substrate is: `GET /threads/{id}/runs/{run_id}` (run final state + evidence_journal? + output?) PLUS `GET /debug/trace/session/{run_id}` (trace spans when debug-endpoints enabled). This CONFIRMS BC-2.24.004 {INV-001} ("no new server endpoints required") — the two endpoints already exist. BC corrections routed to PO (exact wording in this delta note). **PO routing — exact replacement wording for BC-2.24.004:**

> **BC-2.24.004 {PRE-004}** replacement: "For completed run inspection: the run has a terminal status (`completed`, `failed`, `cancelled`, or `summary_halt`); the run's final state is accessible via `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}); trace spans may be available via `GET /debug/trace/session/{run_id}` (BC-2.24.002) when `debug-endpoints` is enabled and the run's spans are within the ring buffer retention window. There is NO stored StreamEvent list and NO run-event endpoint — StreamEvent is transient (ADR-030 §Decision 2)."

> **BC-2.24.004 {PC-006}** replacement: "**Completed run inspection:** For a terminal-status run (`completed`, `failed`, `cancelled`, `summary_halt`), the SPA fetches the run's final state via `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}) — status, `output?`, `error?`, `evidence_journal?`, and `completed_at?`. When `debug-endpoints` is enabled and the run's spans are within the ring buffer, the SPA additionally fetches span detail via `GET /debug/trace/session/{run_id}` (BC-2.24.002). The completed-run view is static (no SSE subscription). There is NO stored StreamEvent list and NO run-event endpoint; StreamEvent is transient (ADR-030 §Decision 2; ADR-031 Decision 8)."

> **BC-2.24.004 {TV-002}** replacement: "Terminal-status run (`completed`); `GET /threads/{id}/runs/{run_id}` returns `{ status: 'completed', output: '...', evidence_journal: [2 entries], completed_at: '...' }`; `debug-endpoints` enabled with 3 spans in buffer | Static view shows run summary (final output, evidence journal entries, span detail links); no SSE opened | completed-run inspection"

> **PO routing — exact replacement wording for BC-2.24.007:**

> **BC-2.24.007 {PRE-002}** replacement: "The live SSE stream (`GET /threads/{id}/runs/{run_id}/stream`) is open for active runs (BC-2.12.007), OR the run is terminal-status and the run-read response (`GET /threads/{id}/runs/{run_id}`, BC-2.12.003 {PC-013}) is accessible for post-run evidence display. NOTE: per-compaction-event detail (individual `compaction_event` StreamEvent payloads) is NOT available for completed runs — StreamEvent is transient (ADR-030 §Decision 2; ADR-031 Decision 8). The completed-run panel shows the terminal state summary via `evidence_journal?` and the final output context."

> **PO routing — exact replacement wording for BC-2.24.008:**

> **BC-2.24.008 {PC-004}** replacement: "**Completed run reconstruction:** For terminal-status runs, the feed reconstructs from the `evidence_journal?` field on `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}). The `evidence_journal` contains the durable record of all guardrail evaluation results for the run; the console filters and displays entries corresponding to Fail or Transform outcomes. There is NO stored StreamEvent list — `StreamEvent` is transient (ADR-030 §Decision 2; ADR-031 Decision 8); the `evidence_journal` is the correct and authoritative substrate for completed-run guardrail history. (The DI-012 completeness invariant {INV-002} applies to both live-stream and completed-run reconstruction.)"

> **Story-writer routing:** S-console-06 (BC-2.24.004), S-console-09 (BC-2.24.007), S-console-10 (BC-2.24.008) must sweep their completed-run ACs, tasks, and EC rows to align with the corrected BCs. Any AC that references "fetch stored event list," "run-event endpoint," or "replay StreamEvents" must be replaced with run-read + trace-span fetch (as per BC-2.24.004 {PC-006} corrected wording above). **BA routing:** CAP-043 "inspect completed run" capability description should be updated by business-analyst to say "inspect completed run via run-state summary (status, output, evidence_journal) and trace spans (when debug-endpoints enabled)" rather than any wording implying StreamEvent replay.

> *(SUPERSEDED by DC-39/F-PDC39-02 — GuardrailJournal is checkpoint-backed (pregolya-checkpoint), NOT stored on the RunStore record; run-read projection assembled by server::run_read_handler at read time; see DC-39 note below)*
>
> **D-356 adversary fix DC-33 (2026-09-08, architect).** F-PDC33-02 (HIGH): Decision 8 substrate table row "All guardrail decisions (Fail/Transform/Allow)" has two defects. (1) **Enum mislabel:** "Fail/Transform/Allow" conflates `GuardrailResult` variants (Pass/Fail/Transform — produced by `GuardrailHook::evaluate` at ingress boundaries; BC-2.11.002) with `PolicyDecision` variants (Allow/Escalate/Deny — produced by `BudgetPolicy` evaluations and durably recorded in `evidence_journal?`; BC-2.10.002). These are entirely separate governance outputs from separate subsystems. (2) **Substrate mismatch:** `evidence_journal?` (BC-2.10.002) records `PolicyDecision` evaluations only — `GuardrailResult` outcomes are NEVER written to the journal in v1. **Ruling: Option (a) — durable `GuardrailJournal` required.** Production-grade rationale: CAP-047 is a guardrail *security review panel* — its purpose is retrospective review after runs complete; a live-only guardrail feed cannot fulfill this function (runs complete in seconds; the reviewer is typically not watching in real time). The `GuardrailJournal` must record one `GuardrailEntry` per `GuardrailHook::evaluate` call with fields: `boundary: IngressBoundary` (ingress-boundary label; canonical type per BC-2.06.001 §Postconditions PC-002; values ToolResult | RagChunk | MemoryItem), `result: GuardrailResult` (Pass/Fail/Transform), `provenance: ProvenanceTag`, `timestamp_ms: u64`. NOTE (O-PDC34-A): `transform_applied: Option<String>` is DROPPED — `result.Transform.new_content: IngressContent` is the authoritative payload; routing: PO update BC-2.11.007 {PC-001} shape; BA update entities-server §GuardrailJournal. Stored as `guardrail_journal: Vec<GuardrailEntry>` on the per-run RunStore record; returned as `guardrail_journal?` in `GET /threads/{id}/runs/{run_id}`. **HUMAN AUTHORIZATION REQUIRED** before core-domain implementation: changes to `entities-server.md` §RunStore (BA-owned) and a new SS-11 BC (PO-owned) are Phase-1 core-domain amendments outside unilateral architect adjudication. **DC-29 PO routing for BC-2.24.008 {PC-004} is superseded by this ruling:** the DC-29 wording instructed use of `evidence_journal?` for guardrail history, which is incorrect (evidence_journal? is budget-scoped only). **Downstream routing (all pending human authorization):** BA: add `GuardrailEntry` type and `guardrail_journal: Vec<GuardrailEntry>` field to entities-server.md §RunStore; author new SS-11 BC (e.g., BC-2.11.005) governing: (a) every GuardrailHook::evaluate call writes a GuardrailEntry; (b) GuardrailJournal is included in RunStore for terminal-status runs; (c) `guardrail_journal?` returned in GET response. BA: update CAP-047 to describe both live-stream (GuardrailDecision StreamEvent variants) and completed-run reconstruction (`guardrail_journal?` — GuardrailEntry records). PO: author BC-2.11.005 guardrail-journal persistence contract; replace BC-2.24.008 {PC-004} DC-29 routing wording with: "**Completed run reconstruction:** For terminal-status runs, the feed reconstructs from `guardrail_journal?` on `GET /threads/{thread_id}/runs/{run_id}` (BC-2.12.003 {PC-013}). `guardrail_journal` contains durable GuardrailEntry records (GuardrailResult: Pass/Fail/Transform per evaluate call); the console filters and displays Fail/Transform entries. NOTE: `evidence_journal?` records budget PolicyDecision outcomes (Allow/Escalate/Deny) — a separate governance dimension; do NOT conflate with guardrail results. StreamEvent is transient (ADR-030 §Decision 2; ADR-031 Decision 8); `guardrail_journal?` is the correct substrate for completed-run guardrail history." Story-writer: update S-console-10 AC-004/AC-005/Task 4 to reference `guardrail_journal?` (not `evidence_journal?`) as the source for completed-run guardrail history; mark those tasks as blocked until human auth + BA/PO spec delivery. **[DC-33 addendum, 2026-09-08, architect]: Authorization received. BC-2.11.007 authored by PO; entities-server.md §GuardrailJournal entity defined by BA; BC-2.12.003 {PC-013} updated with `guardrail_journal?` projection. Decision 8 substrate row finalized above (pending marker removed). VP-2.11.007-A (GuardrailJournal completeness — integration P0, DI-012) minted.**

> **D-356 adversary fix DC-34 (2026-09-08, architect).** F-PDC34-07: ADR changelog reordered DESCENDING (newest-first; frontmatter version 1.9→1.10). F-PDC34-03 (HIGH): `GuardrailEntry.boundary` adjudication — `IngressBoundary` is an existing canonical enum (BC-2.06.001 §Postconditions PC-002 `StreamEvent::GuardrailDecision`; values `ToolResult | RagChunk | MemoryItem`); DC-33 note `boundary: String (hook identity)` corrected to `boundary: IngressBoundary` (ingress-boundary label); PO routing: update BC-2.11.007 {PC-001} String→IngressBoundary; BA routing: update entities-server §GuardrailJournal String→IngressBoundary; story-writer: confirm S-console-10 AC-004 boundary type. O-PDC34-A: `transform_applied: Option<String>` DROPPED from `GuardrailEntry` — `result.Transform.new_content: IngressContent` is authoritative; PO routing: remove transform_applied from BC-2.11.007 {PC-001} shape; BA routing: remove from entities-server §GuardrailJournal; story-writer: sweep S-console-10 ACs. F-PDC34-04 (MED): DC-29 block annotated with inline supersession note.

> **D-356 adversary fix DC-30 (2026-09-08, architect).** F-PDC30-01 (HIGH): session_id vs run_id trace-key gap — silent-empty risk. **Ruling: `session_id = run_id` for all console dev runs.** `DebugSpanExporter` MUST tag every exported span with `session_id = run_id` at insertion time (INV obligation added to BC-2.24.002 — see INV-007 wording below). This makes `GET /debug/trace/session/{run_id}` unambiguous: the path param named `{session_id}` receives the run_id value; the endpoint returns that run's spans. Decision 2 updated with explicit session-key binding note. The Decision 8 table already uses `{run_id}` as the value — this is CORRECT and CONFIRMED; the intra-ADR inconsistency (Decision 2 `{session_id}` vs Decision 8 `{run_id}`) was a naming-vs-value confusion, not a semantic conflict. F-PDC30-02 (MED): swept 6 bare `ADR-030 §Decision` citations → `ADR-030 §Decision 2` (authority is §Decision 2 / §Motivation section of ADR-030). No downstream endpoint cite changes needed for BC-2.24.004/CAP-043/S-console-06 — `GET /debug/trace/session/{run_id}` remains the correct call (pass run_id as session_id); endpoint path template in Decision 2 remains `{session_id}` (general-purpose parameter name). **PO routing — BC-2.24.002 INV-007 (new invariant to add after INV-006):** "{INV-007} **Session key = run_id:** The `DebugSpanExporter` sets `session_id = run_id` on every exported span at insertion time. All spans for a given run are addressable via `GET /debug/trace/session/{run_id}` (BC-2.24.002 {PC-003}). An empty `[]` response means only: (a) the `debug-endpoints` feature is disabled or no exporter was injected, (b) the run's spans have been evicted from the ring buffer by newer spans (FIFO eviction per {INV-001}), or (c) the run produced no traced OTel operations — NOT a silent run/session key mismatch. The `session_id = run_id` invariant MUST be enforced at insertion; no default or override path may produce a span with a different session_id for a run-scoped export."

> **D-356 adversary fix DC-39 (2026-09-09, architect). F-PDC39-02 (HIGH) — GuardrailJournal persistence model RULING (supersedes DC-36 F-PDC36-01):** The DC-33 delta note in this ADR and DC-33 decision-routing described guardrail_journal as "Stored as `guardrail_journal: Vec<GuardrailEntry>` on the per-run RunStore record" — this was a FALSE characterization derived from a false analogy to EvidenceJournal. **Root cause:** EvidenceJournal (BC-2.10.002) was wrongly believed to be persisted via RunStore terminal-state write; in fact BC-2.10.002 {PC-001}/{INV-003}/{PC-005} and §Architecture Anchors unambiguously establish it is checkpoint-backed (pregolya-checkpoint SQLite), appended in `graph::scheduler` sync-durable BEFORE execution resumes — with NO `server::handlers` terminal-state write. **RULING: GuardrailJournal aligns to ACTUAL EvidenceJournal model:** (a) Append site: `graph::provenance` (pregolya-graph) — appends one `GuardrailEntry` sync-durable to the checkpoint-backed `GuardrailJournal` (pregolya-checkpoint, same SQLite backend as EvidenceJournal) BEFORE execution continues at each ingress boundary, after each successfully-returning `evaluate()`; pregolya-graph imports the checkpoint abstraction, NOT RunStore (RunStore = pregolya-server; reverse-edge violation); (b) Storage: pregolya-checkpoint; (c) Run-read bridge: `server::run_read_handler` queries `checkpoint_store.get_guardrail_journal(run_id)` at read time to assemble `guardrail_journal?` None/Some projection — this is the server-side assembly point, NOT a terminal-state write. **BC-2.10.002 DOES NOT need editing.** **BC-2.11.007 DOES need PO editing:** §Architecture Anchors (remove RunStore terminal-state write; replace with checkpoint-backed graph::provenance description and server::run_read_handler bridge), {PC-002} (remove RunStore terminal-state framing), {INV-002} (remove "persisted to RunStore by the server's terminal-state write"). Decision 8 substrate row for GuardrailJournal ("Stored as Vec<GuardrailEntry> on per-run RunStore record; returned as guardrail_journal?") updated: the journal is checkpoint-backed; `guardrail_journal?` is assembled from checkpoint store by `server::run_read_handler` at run-read time. **Downstream corrections also required:** module-decomposition.md graph::provenance row (updated in same burst); vp-2.11.007-a §Proof Harness, §Property Statement, §Source Contract, §Proof Method Coverage (updated in same burst); verification-architecture.md §P0 VP-2.11.007-A prose block (updated in same burst). **Story-writer scope (S-1.29):** Remove Task 5 "move GuardrailJournal write to RunStore terminal transition"; replace with "graph::provenance implements checkpoint-backed GuardrailJournal accumulation (pregolya-checkpoint); AC-002/AC-003 server::run_read_handler queries checkpoint_store at read time." **BA scope (entities-server.md):** Add GuardrailJournal persistence path (checkpoint-backed) and run-read projection bridge.

> **D-356 adversary fix DC-44 (2026-09-09, architect). F-PDC44-01 (MED) — GuardrailJournal 3-state initialization mechanism RULING:** {INV-004} (BC-2.11.007) requires that `guardrail_journal?` returns `None` when no `GuardrailHook` is registered. The DC-39 checkpoint-backed model uses `append_guardrail_entry` for each `evaluate()` call. Gap: with only `append_guardrail_entry`, both the "no hook registered" case and the "hook registered + zero ingress boundaries reached" case produce zero checkpoint rows — `get_guardrail_journal(run_id)` cannot distinguish them and must return `None` for both, making `Some([])` unreachable. This violates the {INV-004} 3-state contract and makes TV-002/TV-005 unsatisfiable. **RULING: guardrail-specific init op at run start.** At run start, `graph::provenance` calls `checkpoint_store.init_guardrail_journal(run_id)` **if and only if** `invocation_context.guardrail_hook().is_some()` — creating an empty journal record sync-durable before the first ingress boundary is evaluated. This is a guardrail-specific operation; `EvidenceJournal` (BC-2.10.002) does NOT need an equivalent init — it always accumulates entries (default-allow produces one PolicyDecision entry per evaluation). `get_guardrail_journal(run_id)` then returns: `None` when no record exists (no hook → no init called); `Some([])` when a record exists but has no entries (hook registered, init called, zero ingress boundaries); `Some([N])` when a record exists with N entries (hook registered, N successful `evaluate()` calls). **BC-2.10.002 DOES NOT need editing.** No human authorization required (resolves a realizability gap within already-authorized {INV-004}). Decision 8 substrate row updated (see above). **Downstream wording for PO — BC-2.11.007:** (1) §Architecture Anchors: add "`graph::provenance` calls `checkpoint_store.init_guardrail_journal(run_id)` at run start if `invocation_context.guardrail_hook().is_some()` (sync-durable; creates the empty journal record; this is the EXISTENCE write that distinguishes `None` (no hook registered, no init) from `Some([])` (hook registered, init called, zero ingress) from `Some([N])` (N entries))." (2) {PC-002}: add "At run start, if a `GuardrailHook` is registered, `graph::provenance` calls `init_guardrail_journal(run_id)` before any ingress boundary evaluation." (3) {INV-004}: add "`guardrail_journal?` returns `None` when no `GuardrailHook` was registered (no init op was called; no journal record exists in checkpoint store). This is tested by TV-002." (4) {PRE-001}: update to bind initialization — "A `GuardrailHook` is registered via `InvocationContext`; at run start `graph::provenance` calls `init_guardrail_journal(run_id)` to initialize the checkpoint record (making `guardrail_journal? = Some([])` before any ingress); subsequent `evaluate()` calls append entries." **Downstream wording for BA — entities-server.md §GuardrailJournal:** Add: "Journal record created (empty) in checkpoint store at run start by `graph::provenance::init_guardrail_journal(run_id)` when `invocation_context.guardrail_hook().is_some()`; `get_guardrail_journal(run_id)` returns `None` if no record exists (no hook registered) or `Some(entries)` if record exists (empty or populated)." **Downstream wording for story-writer — S-1.29:** Add initialization task before current journal-accumulation Task: "`graph::provenance` implements `init_guardrail_journal(run_id)` on the checkpoint store — called at run start if `invocation_context.guardrail_hook().is_some()`; writes empty journal record; AC-003: run-read returns `None` (no hook), `Some([])` (hook + zero ingress), or `Some([N])` (hook + N `evaluate()` calls) per {INV-004}."

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
  as any external host integration, validating the contract's external-host usability.

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

### Binding Status

Roadmap-only. No implementation in the current cycle (Phase 3, Wave 1–2). ADR is
accepted; all eight decisions are binding for Wave 3 planning. ARCH-INDEX.md, api-surface.md,
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
- **External host integration posture** — the console-as-client architecture (Decision 1)
  is validated by any external host that consumes the public REST+SSE wire contract; validates
  the console-as-client architecture posture.
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
   already minted in error-taxonomy.md; `E-SERVER-009 AssistantNotFound` is an existing
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
