---
document_type: research-memo
title: "ADK Developer Console / Dev UI — Feature Inventory, Architecture, and Pregolya Reuse Analysis"
slug: devconsole-adk-research
producer: research-agent
timestamp: 2026-09-06T00:00:00Z
status: draft
purpose: >
  Inform an architecture decision for adding an ADK-style local developer console to pregolya.
  Enumerates Google ADK `adk web` features, adk-rust's port of it, LangGraph Studio for
  comparison, and analyzes what a pregolya dev console reuses vs. needs net-new given the
  existing StreamEvent grammar and pregolya-server SSE transport.
inputs:
  - .reference/adk-rust/docs/official_docs/studio/studio.md
  - .factory/specs/architecture/decisions/ADR-006-streaming-event-taxonomy.md
  - .factory/specs/architecture/decisions/ADR-028-server-run-lifecycle-semantics.md
  - .factory/specs/architecture/api-surface.md
  - .factory/specs/behavioral-contracts/ss-06/BC-2.06.006.md
  - .factory/holdout-scenarios/HS-C-001-flowloom-embedding-host-end-to-end.md
  - .factory/semport/reference-manifest.md
input-hash: "788c5d0"
# F-PDC01-05 delta (DC-01 fix-burst, 2026-09-06): Removed `.reference/adk-rust/adk-server/` from inputs.
# That path is gitignored (Corpus 5 read-only reference tree) and unhashable by compute-input-hash.
# Corpus provenance is fully captured by the already-listed `.factory/semport/reference-manifest.md`
# which pins adk-rust v1.0.0 SHA a6c79b6 — the same version read during research.
# Input-hash is now recomputable from tracked files only.
traces_to: .factory/specs/architecture/api-surface.md
confidence: medium-high
---

# ADK Developer Console Research Memo

> **Scope note.** "ADK dev console" is ambiguous in the corpus. It refers to TWO distinct
> products that must not be conflated:
>
> 1. **`adk web` dev UI** — Google's development/debugging console: the open-source
>    `google/adk-web` Angular app served by the ADK server (adk-python FastAPI, or in the
>    Rust port `adk-server` serving an embedded Angular build). This is the run-inspection /
>    trace / eval console. **This is the pregolya-relevant reference.**
> 2. **ADK Studio** — a separate low-code *visual builder* (ReactFlow drag-and-drop canvas,
>    codegen to Rust). In adk-rust v1.0.0 this was **extracted to a separate repo**
>    (`zavora-ai/adk-studio`) and is **NOT in the pinned corpus** (reference-manifest.md
>    §adk-rust "Excluded from workspace"). Studio is an authoring tool (n8n/Flowise-class),
>    not a run-debugging console. It is out of scope for a pregolya dev console v1 and is
>    documented here only to prevent scope confusion.
>
> The remainder of this memo is about product (1) unless it says "Studio".

---

## 1. What `adk web` Provides — Feature Inventory

Sources: official ADK docs (google.github.io/adk-docs), adk-python / adk-web GitHub, and the
adk-rust `adk-server` source read directly from the corpus. Each row flags whether the feature
is **verified in upstream ADK docs**, **present in adk-rust source**, or **Python-only / stubbed**.

| # | Feature | Upstream ADK (`adk web`) | adk-rust `adk-server` v1.0.0 (source-verified) |
|---|---------|--------------------------|-----------------------------------------------|
| 1 | **Interactive chat / run against a local agent, streaming** | Yes — chat panel; `/run` (unary) and `/run_sse` (streamed events, `streaming:true` for token-level). | **Yes.** `POST /api/run/{app}/{user}/{session}` and `POST /api/run_sse` (`runtime.rs`), returns Axum SSE stream (`Sse<…>` + keep-alive). Streaming token deltas via `partial` events. |
| 2 | **App / agent discovery** | Yes — `/list-apps`. | **Yes.** `GET /api/apps` and `GET /api/list-apps` (`apps.rs`, adk-go compatible). |
| 3 | **Session management (create/list/get/delete)** | Yes — `/apps/{app}/users/{user}/sessions[/{id}]`. | **Yes.** Full CRUD in `session.rs` (both flat `/api/sessions` and adk-go path form). Session response includes events + state (capped at 10k events). |
| 4 | **Event inspection (Events tab; per-event request/response, function calls)** | Yes — ordered `Event` history; expandable per-event view (model request/response, tool/function calls). | **Partial.** `GET /api/apps/{app}/users/{user}/sessions/{id}/events/{event_id}` (`debug.rs`) returns an event-like struct with `invocationId`, `llm_request`, `llm_response` reconstructed from trace attributes. Session GET returns full serialized event list. No dedicated per-event UI contract beyond JSON. |
| 5 | **Trace / span viewer (OpenTelemetry)** | Yes — execution-trace viewer; `trace_capacity` retention setting; OTel-based spans with latency. | **Yes (backend).** `GET /api/debug/trace/session/{session_id}` returns span list; `GET /api/debug/trace/{event_id}` returns span attributes. `convert_to_span_data()` explicitly maps to adk-web's `Trace.ts` SpanData shape (`span_id`, `trace_id`, `start_time`, `end_time`, `attributes`, `llm_request`/`llm_response`). Requires a configured `span_exporter`. |
| 6 | **Agent graph / tree visualization** | Documented as an agent-structure graph view. Whether it renders a true DAG via Graphviz DOT is **NOT established** by official docs (frontend may use a JS layout lib). | **Stubbed — NOT implemented.** `get_graph()` returns `501 NOT_IMPLEMENTED` ("graph generation is not yet implemented"). Response type is `GraphResponse { dotSrc: String }`, so the *intended* contract is Graphviz DOT source, matching Python ADK's `dotSrc` field — but adk-rust never populates it. |
| 7 | **Eval tab / eval-set runner + results viewer** | Yes at product level — create eval sets, run evals, view detailed results (ADK has an eval framework, `adk-eval`). | **Stubbed — NOT implemented in server.** `GET /api/apps/{app}/eval_sets` returns `501 NOT_IMPLEMENTED`. (A separate `adk-eval` crate exists for programmatic evaluation, but the *console* eval endpoints are not wired.) |
| 8 | **Artifact inspection** | Yes — artifact service; events carry artifact-update info. | **Yes (list/get).** `GET /api/sessions/{app}/{user}/{session}/artifacts` and `.../artifacts/{name}` (`artifacts.rs`, `ArtifactsController`). Gated on a configured artifact service. |
| 9 | **State inspection (`session.state`)** | Yes — inspect and edit `session.state` during development. | **Yes (inspect).** Session response includes `state: HashMap<String,Value>`. State *editing* is via `state_delta` on run requests / session create; no dedicated PATCH-state UI endpoint in the Rust server. |
| 10 | **Token usage / cost display** | Version-dependent; usage metadata present in runtime events but a dedicated token panel is **not universally documented**. | **Not a first-class server feature.** Usage would ride inside event payloads; no dedicated token/cost endpoint. |
| 11 | **Audio / voice / bidi streaming** | `/run_live` (WebSocket/live transport) exists in ADK versions that expose it; whether the stock Angular UI ships a full mic/audio experience is **unverified**. | **Not in `adk-server` REST surface.** Realtime/voice lives in separate `adk-realtime` crate (LiveKit); no `/run_live` route found in the `adk-server` route table. |
| 12 | **Multi-UI-protocol negotiation** | N/A (ADK-web specific). | **Yes — adk-rust-specific.** `ui_protocol.rs` advertises four profiles: `adk_ui` (legacy, deprecation-dated 2026-12-31), `a2ui` (draft), `ag_ui` (stable AG-UI subset with protocol-native SSE transport), `mcp_apps` (MCP Apps bridge). Selected via `x-adk-ui-protocol` header or request body. `run_sse` translates internal ADK events into AG-UI's `TEXT_MESSAGE_*`, `TOOL_CALL_*`, `REASONING_*`, `STATE_DELTA`, `RUN_STARTED/FINISHED/ERROR` event families. |

**Net read on adk-rust's port:** the *interactive run + session + trace + artifact + state
inspection* backbone is implemented and wired to the embedded Angular `adk-web` build. The
**two headline "debugging" features — graph visualization and the eval runner — are
explicitly stubbed as `501 NOT_IMPLEMENTED`.** This is a material finding: adk-rust ships the
console shell and the run/trace plumbing, but not the graph-viz or eval-viewer that most
differentiate a "dev console" from a plain chat client.

---

## 2. Architecture — How `adk web` Is Built

### 2.1 Upstream ADK (Python)
```
Angular SPA (google/adk-web)
   │  REST/JSON  → app discovery, session CRUD, state, evals, non-streaming /run
   │  SSE        → /run_sse event stream (+ token-level when streaming:true)
   │  WS/live    → /run_live (bidi/audio), where enabled
   ▼
FastAPI app (adk-python, get_fast_api_app(web=True))
   ▼
ADK Runner → Agent → models / tools / callbacks
   ▼
Sessions (state + ordered Event history), artifacts, evals, OTel traces
```
Default Python server port **8000**, Swagger at `/docs`. (Go server differs: port 8080, `/api`
prefix.) The frontend is a **development-only** client — it is an event-log + inspection UI, not
an independent execution engine.

### 2.2 adk-rust port (source-verified, `adk-server`)
- **Server:** Axum. `create_app(config)` builds a router: `/api/*` (REST + SSE) nested under a
  UI router that serves the embedded Angular build.
- **Frontend delivery:** the `adk-web` Angular app is compiled and **embedded into the binary
  via `rust_embed`** (`web_ui.rs`, `#[folder = "assets/webui"]`). Served at `/ui/`, with SPA
  fallback to `index.html`. A `/ui/assets/config/runtime-config.json` endpoint injects the
  backend URL at runtime (defaults to relative `/api`).
- **Transport:** **REST for discovery/sessions/inspection; SSE for run streaming.** No
  WebSocket in the `adk-server` route table. The `ag_ui` "protocol-native" transport is still
  SSE — it just changes the event *envelope*, not the transport.
- **Route table** (from `rest/mod.rs`, `/api` prefix):
  - `GET /apps`, `GET /list-apps`
  - `POST /sessions`, `POST|GET|DELETE /apps/{app}/users/{user}/sessions[/{session}]`
  - `POST /run/{app}/{user}/{session}`, `POST /run_sse`
  - `GET /sessions/{app}/{user}/{session}/artifacts[/{name}]`
  - `GET /debug/trace/session/{session_id}`, `GET /debug/trace/{event_id}`
  - `GET /debug/graph/{app}/{user}/{session}/{event_id}` → **501**
  - `GET /apps/{app}/eval_sets` → **501**
  - `GET /apps/{app}/users/{user}/sessions/{session}/events/{event_id}`
  - `GET /ui/…` (embedded SPA), `POST /shutdown` (dev)
  - UI-protocol bridge endpoints under `/ui/*` (capabilities, initialize, message, resources)
- **Data flow:** the console does not talk to the engine directly — it drives the same
  `adk_runner::Runner` the CLI uses, and reads sessions/traces through the service traits
  (`SessionService`, `ArtifactService`, `span_exporter`). It attaches to a running agent by
  *loading* it via `agent_loader.load_agent(app_name)` per request, not by connecting to a
  long-lived process.

---

## 3. LangGraph Studio — Comparison Reference

(For the graph-viz + time-travel features adk-rust stubs, LangGraph Studio is the better
model.) Sources: docs.langchain.com/langsmith/studio, langgraph docs/GitHub.

| Capability | LangGraph Studio |
|-----------|------------------|
| **Graph visualization** | Renders the `StateGraph` (nodes/edges); "Graph mode" highlights traversed nodes and shows intermediate state during a run. This is the model for the DAG view adk-rust left as a `501`. |
| **Interactive run / stream** | Run and interact from Studio; streams via SSE (LangGraph SDK `stream` connects to an SSE endpoint; the SDK explicitly does **not** plan WebSockets). |
| **Threads / assistants** | Management UI for threads and assistants (named agent configs). |
| **Checkpoint / state inspection** | Backed by the checkpointer; state readable via the graph-state API keyed by `thread_id`. |
| **Time-travel / replay** | **Checkpoint-backed**, not UI-replay. Replaying/resuming an earlier execution requires persisted checkpoints. Locally you must configure a checkpointer; deployed platform does it automatically. |
| **Interrupts / HITL** | Configure interrupts on selected nodes or all nodes; checkpointing resumes after interrupt. |
| **Trace / tokens / cost / latency** | Via LangSmith trace integration (latency, token, cost breakdowns by input/output/total). |
| **Eval / datasets** | Runs experiments over datasets; experiment view shows feedback, latency, tokens, cost, status, and the trace. |
| **Architecture** | `langgraph dev` runs a **local Agent Server**; the Studio **frontend is web-hosted** (LangSmith) and attaches to the local server; a **desktop app** also exists. Transport: REST + SSE. |

**Two takeaways for pregolya:**
1. Both ADK web and LangGraph Studio converge on **REST + SSE**, not WebSocket. Pregolya's
   existing SSE transport (below) is already the industry-standard choice.
2. **Time-travel/replay is a checkpointer feature, not a UI feature.** The console is a thin
   read/resume client over a durable checkpoint + event history. Pregolya's checkpoint stack
   makes this a natural fit.

---

## 4. Pregolya Reuse Analysis — Reuse vs. Net-New

### 4.0 Premise correction (load-bearing)
The task brief states pregolya "emits a structured streaming event grammar **over WebSocket**."
**The specs say SSE, not WebSocket.** ADR-006 §Decision/§Consequences: *"pregolya-server SSE
endpoint serializes `StreamEvent` values to `data: <json>\n\n`"*; api-surface.md lists
`GET /threads/{thread_id}/runs/{run_id}/stream` as **"SSE streaming run output" (BC-2.12.007)**.
This is a *favorable* correction: SSE is exactly what both reference consoles use, so no
transport rework is needed. If a WebSocket transport is genuinely also present/planned, that
is not reflected in ADR-006 or api-surface.md and should be reconciled by the architect.

### 4.1 What pregolya ALREADY has (reuse directly)

| Console need | Pregolya asset (source-of-truth) | Status |
|--------------|----------------------------------|--------|
| Streamed run events | 16-variant typed `StreamEvent` enum (`core::events`), `run_id` + `parent_ids` on every variant (ADR-006, BC-2.06.001/002) | Spec-complete; Phase 3 impl |
| SSE transport | `GET /threads/{id}/runs/{run_id}/stream` (BC-2.12.007), pregolya-native `{"event": …, "data": …}` wire format | In api-surface |
| Session/thread model | `/threads` CRUD, `/threads/{id}/state` (latest checkpoint `{values, checkpoint, next}`), `/threads/{id}/history` (checkpoint history, newest-first, `?limit=N`) (BC-2.12.001) | In api-surface |
| Run lifecycle | `POST /threads/{id}/runs` (async 202), list/read/cancel/delete runs, status state machine (BC-2.12.003, ADR-028) | In api-surface |
| Assistants (named agent configs) + versioning | `/assistants` CRUD + immutable version snapshots + `set_latest` (BC-2.12.002) | In api-surface |
| HITL resume | `POST /threads/{id}/runs/{run_id}/resume` (BC-2.05.004) | In api-surface |
| **Time-travel / replay substrate** | `/threads/{id}/history` + `/threads/{id}/state` + checkpoint backend (ADR-002) — the exact substrate LangGraph Studio uses for replay | In api-surface |
| Guardrail observability | `GuardrailDecision` StreamEvent variant (ADR-006 rev-3) — richer than ADK's trace-only model | Spec-complete |
| Compaction observability | `CompactionEvent` variant with token-impact payload (BC-2.06.006) — enables live context-window viz | Spec-complete |
| Embedding-host consumption proof | HS-C-001 already validates an external host consuming typed streaming events with stable correlation IDs | Sealed holdout |

**Conclusion:** pregolya's server surface is a *superset* of the adk-rust console backend for
runs/sessions/state/history/HITL, and it already has the checkpoint-history substrate that
adk-rust lacks for time-travel. The event grammar is richer (guardrail + compaction variants).

### 4.2 What is NET-NEW (must build)

| Gap | Notes | Effort class |
|-----|-------|--------------|
| **Web frontend** | No SPA exists. adk-rust embeds a compiled Angular `adk-web`; pregolya has nothing. This is the single largest net-new item. | Large |
| **Trace / span endpoints + OTel exporter wiring** | Pregolya has structured `tracing` events (Canonical Structured Event Catalog) but no `/debug/trace/*` read endpoints and no in-memory span exporter feeding a UI. adk-rust's `convert_to_span_data` → `Trace.ts` shape is the model. Needs a span-exporter service trait + retention cap. | Medium |
| **Graph / DAG visualization** | adk-rust stubbed this (`501`). Pregolya's advantage: it has a real `StateGraph` with explicit nodes/edges, so it can emit a graph descriptor (DOT or JSON node/edge list) from the compiled graph — no reconstruction from traces needed. LangGraph Studio is the UX model (live node highlighting via `node_start`/`node_end` events). | Medium |
| **Eval runner + results viewer** | adk-rust stubbed the console eval endpoints. Depends on whether pregolya has/plans an eval framework surface. Likely defer to a later wave unless an eval crate exists. | Medium–Large |
| **App/assistant discovery for the console** | Exists as `/assistants` but may need a console-oriented "list runnable graphs" view. | Small |
| **Token/cost panel** | Requires usage metadata to be surfaced in events + a UI panel. Compaction event already carries `tokens_remaining_after`; a usage rollup is net-new. | Small–Medium |
| **Static-asset embedding + `pregolya console`/`serve --ui` CLI** | An `rust_embed` bundling step + a CLI subcommand to launch server-with-UI on default port 7437. | Small |

### 4.3 Recommended component boundaries

The production-grade default (CLAUDE.md) argues against bolting UI concerns onto
`pregolya-server`. Recommended split:

1. **`pregolya-server` (existing) — unchanged transport authority.**
   Keep it headless. Add only the *data* endpoints the console needs that are genuinely
   server-tier: `/debug/trace/*` (span read) and a graph-descriptor endpoint
   (`GET /assistants/{id}/graph` or `/threads/{id}/graph`) emitting the compiled `StateGraph`
   as node/edge JSON (+ optional DOT). These are library-consumer-useful beyond the console,
   so they belong in the server, gated behind a `console`/`debug-endpoints` cargo feature so
   production deployments can compile them out.

2. **`pregolya-console` (new crate) — the console composition layer.**
   A binary crate (or a feature of `pregolya`'s CLI) that:
   - embeds the compiled web frontend via `rust_embed` (mirrors adk-rust `web_ui.rs`);
   - serves the SPA + a `runtime-config.json` pointing at the pregolya-server `/api`;
   - optionally spins up an in-process pregolya-server (dev mode) so `pregolya console`
     launches server + UI in one command on `127.0.0.1:7437`;
   - hosts the in-memory span exporter that the `/debug/trace/*` endpoints read from.
   Keeping this a separate crate honors the file-size/cohesion rules and the reqwest/TLS and
   no-unwrap conventions without polluting the core server crate.

3. **Web frontend (new, separate build artifact).**
   A SPA (framework TBD — SolidJS/Svelte/React; adk-web uses Angular, LangGraph Studio is
   React/hosted). It is a **pure SSE + REST client** of the existing pregolya-server contract.
   No new transport. It subscribes to `.../runs/{run_id}/stream`, drives runs via
   `POST /threads/{id}/runs`, reads history via `/threads/{id}/history`, and renders the graph
   from the new graph-descriptor endpoint with live node highlighting driven by
   `node_start`/`node_end`/`tool_start`/`tool_end`/`guardrail_decision`/`compaction_event`
   events. This is the largest net-new effort and the natural candidate for its own wave.

**Boundary principle:** the console *consumes* the public wire contract exactly as the HS-C-001
embedding host does — it must not reach into engine internals. The event grammar + SSE + REST
already constitute the console's entire data plane. The console is a client, not a peer of the
engine (same posture as ADK web and LangGraph Studio).

---

## 5. Developer Personas & Workflows (feeds persona-storyboard)

### Personas

- **P1 — Graph Author (pregolya library consumer).** Building a `StateGraph`. Wants to *see*
  the graph they wired, run it interactively, and watch which node fires when. Primary value:
  graph-viz + live node highlighting + interactive run.
- **P2 — Run Debugger.** A run misbehaved. Wants to open a specific `run_id`, step through the
  event sequence, expand a node/tool event to see its request/response, and read the span
  timeline for latency. Primary value: event inspector + trace/span viewer.
- **P3 — Trajectory Replayer / HITL operator.** Wants to inspect checkpoint history for a
  thread, resume an interrupted (pending-approval) run, and re-run from an earlier checkpoint
  ("what if this node had produced X"). Primary value: `/threads/{id}/history` + resume +
  state view. (Directly exercises the HS-C-001 durable-resume path.)
- **P4 — Budget / Context Watcher.** Long-running agent; wants to watch token budget and see
  when compaction fires and how much it reclaimed. Primary value: `compaction_event` +
  `tokens_remaining_after` live panel.
- **P5 — Security Reviewer.** Wants to watch `guardrail_decision` events in real time as
  untrusted tool output is screened (Domain A SOC use case, ADR-006 rev-3 forcing function).
- **P6 — Eval Analyst (later wave).** Runs an eval set against a graph and compares results.
  Deferred pending an eval surface (adk-rust stubbed this).

### Core workflows

| Workflow | Steps (all over existing REST+SSE) | Persona |
|----------|-------------------------------------|---------|
| **Inspect a run** | list runs → open `run_id` → render event timeline from stored events → expand node/tool event → open span view (`/debug/trace/session/{id}`) | P2 |
| **Watch a live run** | pick assistant → `POST /threads/{id}/runs` → subscribe `.../runs/{run_id}/stream` → highlight nodes on `node_start/end`, stream tokens on `run_stream/node_stream` | P1, P2 |
| **Debug a graph** | render DAG from graph-descriptor endpoint → run → live-highlight traversed nodes/edges → inspect state at each `step_end` | P1 |
| **Replay a trajectory** | open thread → `/threads/{id}/history` → pick a checkpoint → view `/state` at that point → resume/fork a new run from it | P3 |
| **Resume HITL** | open interrupted run (pending-approval, `tool_approval_request` event) → operator approves → `POST .../resume` → new `run_id`, continued ancestry | P3 |
| **Watch budget/compaction** | live run → context-window gauge fed by `compaction_event.tokens_remaining_after` + `summary_token_count` | P4 |
| **Watch guardrails** | live run → security feed of `guardrail_decision` events (Fail/Transform, severity, boundary) | P5 |
| **Compare eval results** *(later)* | run eval set → results table (latency/tokens/pass) → diff runs | P6 |

---

## 6. Key Findings Summary

1. **Two products, don't conflate.** `adk web` (run-debug console) is the reference; ADK Studio
   (visual builder) is out of scope and not even in the corpus (extracted to a separate repo).
2. **adk-rust ships the console *shell* but stubs the two headline debug features.**
   Graph-viz (`GraphResponse{dotSrc}`) and the eval runner both return `501 NOT_IMPLEMENTED`.
   Interactive run, sessions, trace/span read, artifacts, and state inspection are real.
3. **Transport is SSE + REST everywhere** — adk-rust, upstream ADK, and LangGraph Studio all
   use SSE for streaming (no WebSocket). **This contradicts the task's "over WebSocket"
   premise; pregolya's specs (ADR-006, api-surface) say SSE.** Favorable: no transport work.
4. **Pregolya's backend is already a superset** for runs/sessions/state/history/HITL, with a
   *richer* event grammar (16 typed variants incl. `GuardrailDecision`, `CompactionEvent`) and
   the checkpoint-history substrate LangGraph Studio needs for time-travel — which adk-rust
   lacks. HS-C-001 already proves an external host can consume the stream.
5. **Net-new is dominated by the web frontend.** Backend additions are modest: `/debug/trace/*`
   span-read endpoints (+ an in-memory OTel exporter) and a graph-descriptor endpoint. Everything
   else the console needs already exists as public contract.

### Recommended component boundaries (headline)
- **`pregolya-server`**: add feature-gated `/debug/trace/*` + graph-descriptor endpoints only; keep headless.
- **`pregolya-console`** (new binary crate): embeds SPA via `rust_embed`, serves UI + runtime-config, optional in-process dev server, hosts span exporter.
- **Web SPA** (new build artifact): pure SSE+REST client of the existing wire contract; own wave.

### Confidence & open items
- **High confidence:** adk-rust source facts (read directly); pregolya spec facts (read directly).
- **Medium confidence:** upstream `adk web` exact route names for trace/eval/graph and whether
  the stock Angular UI renders DOT vs a JS graph lib — unverified in official docs; frontend
  commit-level check recommended if the UX is to be copied precisely.
- **Inconclusive / flag to architect:** (a) the WebSocket-vs-SSE premise discrepancy needs
  reconciliation; (b) whether pregolya has/plans an eval surface to back an eval-viewer, else
  defer P6; (c) SPA framework choice (adk-web=Angular, LangGraph Studio=React) is an open ADR.

---

## Research Methods

| Tool | Queries | Purpose |
|------|---------|---------|
| **Perplexity perplexity_research (PRIMARY)** | 2 (both **timed out** at 300s) | Attempted deep multi-source synthesis on `adk web` and LangGraph Studio; the deep-research backend did not return within the client timeout. Fell back to `perplexity_ask` high-context. |
| Perplexity perplexity_ask | 2 | ADK `adk web` feature/architecture inventory (cited google.github.io/adk-docs, adk-python/adk-web GitHub); LangGraph Studio feature/architecture comparison (cited docs.langchain.com, langgraph GitHub). Ran with `search_context_size: high`. |
| Context7 | 0 | Not needed — library-API depth not required; source read directly. |
| Tavily | 0 | Not needed — Perplexity + direct source read sufficient. |
| Read (local corpus) | 12 | adk-rust `adk-server` source: `web_ui.rs`, `ui_protocol.rs`, `lib.rs`, `rest/controllers/{debug,runtime,session,apps}.rs`; docs `studio/studio.md`; pregolya specs `ADR-006`, `ADR-028`, `api-surface.md`, `BC-2.06.006`, `HS-C-001`, `reference-manifest.md`. |
| Grep/Glob (local corpus) | ~9 | Route-table extraction (`rest/mod.rs`), transport/endpoint discovery across pregolya architecture specs, ADR-006 location. |

**Total MCP tool calls:** 4 (2 `perplexity_research` timed out; 2 `perplexity_ask` succeeded). MCP gate satisfied (≥1 successful Perplexity call).
**Deviation note (per agent mandate):** `perplexity_research` is the required default for non-trivial topics; both attempts hit the 300s client timeout (Perplexity API non-response), so this report relies on `perplexity_ask` (sonar-pro, high context) plus extensive **direct source reading** of the pinned adk-rust corpus and pregolya specs — which for the pregolya-reuse and adk-rust-implementation questions is *higher* fidelity than web synthesis.
**Training data reliance:** low — adk-rust and pregolya claims are source-verified from the corpus; upstream ADK/LangGraph claims are web-cited via Perplexity with explicit verified/unverified flags.
