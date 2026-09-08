---
document_type: epics
version: "1.9"
status: active
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
phase: 2
traces_to: .factory/specs/architecture/ARCH-INDEX.md
---

# Epics — pregolya Phase 2

> **23 epics spanning 52 stories across Wave 1 (28), Wave 2 (12), Wave 3 roadmap (10), Wave 6 (1). One maintenance story (S-MAINT-001) is outside the wave schedule.**
> Epic IDs are stable references. Stories within each epic share a primary subsystem.

## Epic Catalog

| Epic ID | Title | Wave | Stories | Points | Primary Subsystem | Primary Crate(s) |
|---------|-------|------|---------|--------|-------------------|-----------------|
| E-01 | Core Primitives — Error Taxonomy, Message Types, Runnable, LCEL | 1 | S-1.01, S-1.02, S-1.03, S-1.04, S-1.05, S-1.06 | 33 | SS-01, SS-14, SS-16 | pregolya-core |
| E-02 | Proc-Macro Attributes | 1 | S-1.07 | 5 | SS-08 | pregolya-macros |
| E-03 | Text Splitting — Recursive Unicode Splitter | 1 | S-1.08 | 8 | SS-07 | pregolya-splitters |
| E-04 | Sandboxed Tool Execution | 1 | S-1.09 | 13 | SS-13 | pregolya-sandbox |
| E-05 | Durable Checkpointing | 1+2 | S-1.10, S-1.11, S-2.12 | 24 | SS-04 | pregolya-checkpoint |
| E-06 | Long-Horizon Memory | 1 | S-1.12, S-1.13 | 16 | SS-15 | pregolya-memory |
| E-07 | StateGraph Definition + CAP-040 Channel Primitives | 1 | S-1.14, S-1.15, S-1.28 | 18 | SS-02 | pregolya-graph |
| E-08 | BSP Execution Engine | 1 | S-1.16 | 13 | SS-03 | pregolya-graph |
| E-09 | Streaming Event Taxonomy | 1 | S-1.17, S-1.24 | 10 | SS-06 | pregolya-graph |
| E-10 | Budget Governance and Compaction | 1 | S-1.18, S-1.25 | 13 | SS-10 | pregolya-graph |
| E-11 | Content Provenance and Guardrail Hooks | 1 | S-1.19 | 13 | SS-11 | pregolya-graph |
| E-12 | HITL Interrupt / Resume | 1 | S-1.20, S-1.23 | 18 | SS-05 | pregolya-graph |
| E-13 | First-Party Tool Library | 1 | S-1.21, S-1.22 | 16 | SS-23 | pregolya-tools |
| E-14 | Durable-Run HTTP Server | 1 | S-1.26, S-1.27 | 16 | SS-12 | pregolya-server |
| E-15 | LC Serialization / Round-Trip Registry | 2 | S-2.01 | 13 | SS-19 | pregolya-core |
| E-16 | Document Retrieval | 2 | S-2.02 | 5 | SS-20 | pregolya-core, pregolya-vectorstores |
| E-17 | VectorStore Abstraction | 2 | S-2.03 | 10 | SS-21 | pregolya-vectorstores |
| E-18 | Prompt Templates and Injection Safety | 2 | S-2.04, S-2.05 | 16 | SS-18 | pregolya-prompts |
| E-19 | Provider SDK Conformance | 2 | S-2.06, S-2.07, S-2.08 | 24 | SS-08 | pregolya-openai, pregolya-anthropic, pregolya-ollama |
| E-20 | Embeddings Trait and Providers | 2 | S-2.09 | 8 | SS-22 | pregolya-core, pregolya-openai, pregolya-ollama |
| E-21 | MCP Tool Adapter | 2 | S-2.10, S-2.11 | 16 | SS-09 | pregolya-mcp |
| E-22 | Formal Verification Pipeline | 6 | S-6.01 | 8 | SS-17 | xtask, pregolya-graph, pregolya-checkpoint, pregolya-sandbox |
| E-console | Developer Console | 3 (roadmap) | S-console-01, S-console-02, S-console-03, S-console-04, S-console-05, S-console-06, S-console-07, S-console-08, S-console-09, S-console-10 | 56 | SS-24 | pregolya-console, pregolya-server, pregolya-graph |
| EPIC-MAINT | Maintenance and Self-Improvement | out-of-wave | S-MAINT-001 | 5 | N/A | all crates |

## Epic Summaries

### E-01 — Core Primitives (Wave 1, 33 pts)

The foundation of the entire workspace. Establishes `PregolyaError` (2D component × category struct,
RFC-7807 emission), the `Message`/`ContentBlock` type system, the `Runnable` trait invocation model,
LCEL composition (`RunnableParallel`, `RunnablePassthrough`, `RunnableAssign`), and the tool
retry/circuit-breaker policy. Every other crate depends on this epic. All production-grade constraints
(no `unwrap`, redacted `Debug` for credentials, reqwest rustls-tls, 30s timeout) are first exercised here.

**VP Anchor:** VP-014 (RunnableParallel key-completeness proptest, P1) anchors to S-1.05.

### E-02 — Proc-Macro Attributes (Wave 1, 5 pts)

Provides `#[tool]`, `#[entrypoint]`, and `#[task]` attribute macros that generate boilerplate
for tool registration, graph entrypoint wiring, and async task wrapping. These macros are consumed
by E-13 (tools), E-19 (providers), and the Wave 2 ecosystem. Built in `pregolya-macros`.

### E-03 — Text Splitting (Wave 1, 8 pts)

Recursive character-based text splitter with strict Unicode code-point boundary semantics
and byte-perfect parity with the Python reference implementation for non-ASCII content.
Red Gate: BC-2.07.002 non-ASCII parity test must be written and failing before implementation.

### E-04 — Sandboxed Tool Execution (Wave 1, 13 pts)

Security-critical sandbox for all tool file and process operations. Enforces workspace
confinement via `canonicalize_beneath_root`, symlink escape prevention, macOS Seatbelt deny-by-default,
and env var sanitization. VP-003 (Kani P0) anchors BC-2.13.004 workspace confinement — Kani harness
must be produced in Phase 6.

### E-05 — Durable Checkpointing (Wave 1+2, 24 pts)

Full checkpoint lifecycle: `put_writes` durability contract, monotonic logical-clock IDs, fork
lineage, crash recovery (no re-execution), triple-address session uniqueness (VP-002), at-rest
encryption, and FTS conversation search over checkpoint history. SQLite and in-memory backends.
The graph execution engine (E-08) depends on this epic.

**CAP-040 addition (S-2.12, Wave 2, 8 pts):** Durable audit trajectory (`TrajectoryWriter`,
`TrajectoryReader`, `TrajectoryCompactor`) — write-once append (BC-2.04.009), ascending-step-index
replay (BC-2.04.010), and crash-isolated compaction via per-run single-transaction DELETE
(`BEGIN IMMEDIATE; DELETE FROM trajectory_records WHERE run_id = :run_id AND step_idx < :retention_frontier AND step_idx NOT IN (:promoted_step_idxs); COMMIT`)
under WAL mode (BC-2.04.011 {INV-003}). VP-018 (proptest P1) anchors `TrajectoryCompactor`
retention-integrity invariants (BC-2.04.011 {INV-001}/{INV-002}). VP-019 (crash-isolation
integration, Phase 6) covers the two-crash-point matrix per BC-2.04.011 {INV-003}: before-COMMIT
(uncommitted WAL frames discarded on next open → pre-compaction state intact) and after-COMMIT
(DELETE durably committed → post-compaction state). The `trajectory_records` table is isolated
from CheckpointSaver tables per ADR-009 definitions-in-core separation; no staging table exists.
Error codes in scope: E-TRAJ-001 (DURABILITY, write failure), E-TRAJ-002 (VAL, conflict),
E-TRAJ-003 (DURABILITY, replay failure), E-TRAJ-005 (DURABILITY, compaction failure),
E-TRAJ-006 (DURABILITY, AES-GCM integrity check failed); E-TRAJ-004 is RETIRED.

### E-06 — Long-Horizon Memory (Wave 1, 16 pts)

KV and vector memory persistence across threads, user/app/session tenant tier isolation,
GDPR erasure (all tiers), SkillStore load-on-demand registry, guarded memory writes
(`MemoryWriteGuard`), and frozen-snapshot context mutation. Security-sensitive: guards must
be fail-closed.

### E-07 — StateGraph Definition + CAP-040 Channel Primitives (Wave 1, 18 pts)

`StateGraph` node/edge API, `LastValue`/`Append`/`BarrierValue`/`EphemeralValue` channel reducers,
conditional edge routing functions, and `Send` API dynamic fan-out. Red Gate BCs:
`NamedBarrierValue` missing-writer boundary (BC-2.02.003) and `EphemeralValue` cleared-after-super-step
(BC-2.02.004).

**CAP-040 addition (S-1.28, 5 pts):** `LedgerChannel<T>` dedup-idempotent append and first-appearance
ordering (BC-2.02.007/008) and `PromoteRetireChannel<T>` active-set lifecycle with idempotent
`Promote`/`Retire` operations (BC-2.02.009). All three types are pure channel reducers in the
`pregolya-graph/src/channels/` directory module (`channels/ledger.rs` and
`channels/promote_retire.rs`). Both `LedgerChannel<T>` and `PromoteRetireChannel<T>` implement
`graph::channels::Channel` (`Accumulator = Vec<T>`), enabling BSP engine reduce-dispatch without
additional bounds beyond `T: LedgerEntry` at call sites (BC-2.02.007 {INV-004}). VP-017
(proptest P1) is a dual-anchor covering `LedgerChannel` dedup-idempotency and first-appearance
ordering stability per BC-2.02.007 `{INV-001}/{INV-002}` and BC-2.02.008 `{INV-001}/{INV-003}`.
VP-020 (proptest P1) anchors `PromoteRetireChannel<T>` idempotency invariants
(BC-2.02.009 {INV-001}/{INV-002}): no-duplicate `entry_id` in the active set, reducer
determinism, `Promote` dedup-idempotency, `Retire` absent-entry no-op, and order-sensitivity
(harness `promote_retire_channel_idempotency`; anchored to S-1.28).

### E-08 — BSP Execution Engine (Wave 1, 13 pts)

The Bulk-Synchronous Parallel super-step execution engine. Deterministic execution order,
concurrent `LastValue` write rejection, and deterministic reducer application order.
VP-001 (Kani P0) anchors BC-2.03.001 BSP determinism — the highest-criticality formal proof in the workspace.
Depends on E-05 (checkpoint) and E-07 (StateGraph).

### E-09 — Streaming Event Taxonomy (Wave 1, 10 pts)

Typed per-phase streaming event taxonomy (16 variants including `on_chain_start`, `on_tool_start`,
`on_llm_stream`, etc.), `run_id` + `parent_ids` correlation, streaming/unary output parity, and
tool-approval / compaction event types (S-1.24 extends the base taxonomy established in S-1.17).

### E-10 — Budget Governance and Compaction (Wave 1, 13 pts)

`BudgetPolicy` allow/escalate/deny evaluation, append-only `EvidenceJournal`, graceful halt at
ceiling, budget escalation to HITL interrupt, `CompactionTrigger` watermark arithmetic (VP-012),
and mid-run compaction window replacement.

### E-11 — Content Provenance and Guardrail Hooks (Wave 1, 13 pts)

`ProvenanceTag` at every ingress boundary, `GuardrailHook` at tool-result / RAG / memory ingress
boundaries, rejected-content never enters model context, and no-hook default pass-through with
WARNING log. P0 security-critical — all 6 BCs are P0.

### E-12 — HITL Interrupt / Resume (Wave 1, 18 pts)

Human-in-the-loop interrupt suspension, FIFO resume-value delivery, interrupted-node re-execution
from start, `Command(resume=value)` API, resume-on-empty-queue error, risk-tiered interrupt
classification, `PreToolCallHook` dispatch (VP-011, Kani P0), and skip-hook-on-resume invariant.

### E-13 — First-Party Tool Library (Wave 1, 16 pts)

`ReadFileTool`, `WriteFileTool`, `EditFileTool`, `ListDirTool` (all PathGuard-confined),
`BashTool` (non-lowerable medium risk floor, VP-013 Kani P1), and `GrepTool` (in-process
linear-time DFA regex). All tools depend on E-04 (sandbox) and E-01 (core types).

### E-14 — Durable-Run HTTP Server (Wave 1, 16 pts)

Axum-based HTTP server: Thread/Assistant/Run CRUD, `CronSchedule` proactive run, `SecurityConfig::default()` CORS-deny, idempotency/rate-limit/run store seams, and streaming/unary same graph engine. Depends on E-08 (BSP) and E-05 (checkpoint).

### E-15 — LC Serialization / Round-Trip Registry (Wave 2, 13 pts)

`LcSerializable` round-trip (VP-007 proptest P1), `lc_secrets()` credential stripping, OnceLock allowlist-based type registry, legacy namespace remap (`OLD_CORE_NAMESPACES_MAPPING`, P2), reviver allowlist containment fail-closed (VP-010 Kani P0, Red Gate), and langchain-monolith type ID rejection. Security-critical serialization path.

### E-16 — Document Retrieval (Wave 2, 5 pts)

`Retriever` trait as `Arc<dyn Retriever>` graph seam, RAGRetrieval guardrail coverage obligation
(BC-2.20.002 Red Gate), and `VectorStoreRetriever` search-type configuration.

### E-17 — VectorStore Abstraction (Wave 2, 10 pts)

`VectorStore` trait (instance-method surface), `InMemoryVectorStore` with `Arc` DI, `RwLock`,
Vec<f32> cosine similarity, zero-norm vector guard (VP-009 Kani P0, Red Gate), and
`MetadataFilter` with Eq/Ne/In clauses.

### E-18 — Prompt Templates and Injection Safety (Wave 2, 16 pts)

`PromptTemplate` f-string rendering, `ChatPromptTemplate` multi-message rendering,
`MessagesPlaceholder` and `FewShotPromptTemplate`, and injection safety guard with
`TrustLevel` enforcement (VP-006 Kani P1, Red Gate). S-2.05 covers three BCs: BC-2.18.004 and BC-2.18.005 are Red Gate; BC-2.18.002 is not.

### E-19 — Provider SDK Conformance (Wave 2, 24 pts)

Standalone SDK crate split architecture (BC-2.08.006), chat model streaming/tool-call/structured-output/error-fidelity/token-usage conformance across OpenAI + Anthropic + Ollama, eval score aggregation, tool schema naming stability, pluggable tool-call dialect seam, and provider failover chain. Largest Wave 2 epic.

### E-20 — Embeddings Trait and Providers (Wave 2, 8 pts)

`Embeddings` trait with dimensionality contract (VP-008 proptest P1),
`EmbeddingsOpenAI` with credential opacity (BC-2.22.002 Red Gate) and batch failure handling, and
`EmbeddingsOllama` POST /api/embed with legacy endpoint toggle.

### E-21 — MCP Tool Adapter (Wave 2, 16 pts)

MCP client: tool discovery, invocation routing, untrusted-ingress guardrail coverage, bare
`ToolException` re-raise (Red Gate, VP-004 integration P1), and `MultiServerMcpClient` holds-no-live-connections invariant (VP-005 integration P1). MCP server: tool advertisement (tools/list) and invocation (tools/call).

### E-22 — Formal Verification Pipeline (Wave 6, 8 pts)

Single story that establishes the Kani harness obligations for all 9 VP Kani proofs
(6 P0 + 3 P1), cargo-fuzz targets for serialization and graph-execution paths, and cargo-mutants
mutation gate. This story formally executes the 9 Kani harness proofs only; proptest, integration,
and unit VPs (including VP-006-B, VP-015, VP-016) are validated in their Phase-3 anchor stories,
not in S-6.01's pipeline. Gated until all Wave 1 + Wave 2 implementation stories are merged.

### E-console — Developer Console (Wave 3 roadmap, 56 pts)

> **D-356 dev-console scope expansion (2026-09-06, story-writer).**

Browser-based developer console for `pregolya-server` that exposes run inspection,
checkpoint history, HITL approval, budget governance, and guardrail review through a
lightweight SPA embedded in a new `pregolya-console` binary crate. All console functionality
is feature-gated (`debug-endpoints` Cargo feature defaults `false`) and scoped to
`127.0.0.1:7437` for local developer use — no production data path is affected.

**Architecture** (ADR-031):
- `pregolya-console` binary: Axum HTTP server + `rust_embed` SPA; `ConsoleConfig` with `#[non_exhaustive]`
- `server::debug_span` (pregolya-server): `SpanData` `#[non_exhaustive]` + `DebugSpanSource` read-trait — server-owned (ADR-031 Decision 7); created by S-console-03
- `DebugSpanExporter` (pregolya-console): OTel `SpanExporter` impl; bounded FIFO ring buffer (`default 10 000 spans`); implements `DebugSpanSource`; injected as `Arc<dyn DebugSpanSource>` at dev-mode co-launch — `console→server` direction only; Pure Core ring buffer, Effectful Shell OTel adapter
- `debug-endpoints` feature on `pregolya-server`: trace-read routes `/debug/sessions`, `/debug/events/{id}`, `/debug/graph/{assistant_id}` — zero overhead in production
- `compile_graph_descriptor` Pure Core function in `pregolya-graph` (candidate for Kani verification)
- SSE (`text/event-stream`) is the sole streaming transport (ADR-031 Decision 3; WebSocket closed)
- SPA: native browser `EventSource`, no WebSocket polyfill, <500 KB gzip budget; framework deferred to Wave 3

**Subsystems:** SS-24 (Developer Console)

**Behavioral Contracts:** BC-2.24.001 (ConsoleConfig), BC-2.24.002 (DebugSpanExporter ring buffer + trace-read endpoints), BC-2.24.003 (GraphDescriptor), BC-2.24.004 (run inspection panel), BC-2.24.005 (checkpoint history panel), BC-2.24.006 (HITL resume panel), BC-2.24.007 (token budget panel), BC-2.24.008 (guardrail review panel)

**CAP coverage:** CAP-041 (console scaffold), CAP-042 (span exporter), CAP-043 (graph descriptor), CAP-044 (run inspection), CAP-045 (checkpoint history), CAP-046 (HITL resume), CAP-047 (budget + guardrail panels)

**ADR traceability:** ADR-031 (Developer Console Architecture) — 6 decisions; purity boundary table; story ordering S-console-01..10

**Key error codes:** `E-SERVER-023` (DebugExporterNotConfigured), `E-SERVER-009` (AssistantNotFound)

**Wave 3 topological sub-waves:**

| Sub-Wave | Stories | Notes |
|----------|---------|-------|
| 3A | S-console-01 | pregolya-console scaffold (ConsoleConfig, Axum bind, SPA embed skeleton) |
| 3B | S-console-03, S-console-05 | S-console-03: server::debug_span + debug-endpoints (dep-inversion; ADR-031 Decision 7); S-console-05: SPA build pipeline (parallel) |
| 3C | S-console-02, S-console-04, S-console-07 | S-console-02: DebugSpanExporter (imports SpanData, implements DebugSpanSource — depends on S-console-03); S-console-04: graph-descriptor; S-console-07: checkpoint history (parallel) |
| 3D | S-console-06 | Run inspection panel (all 16 StreamEvent variants, SSE EventSource) |
| 3E | S-console-08, S-console-09, S-console-10 | HITL, budget, guardrail panels (parallel) |

**Verification properties:** VP-2.24.001-A/B/C through VP-2.24.008-A/B (20 VPs, all P1, Phase 3 target)

**Story points breakdown:**

| Story | Title | Points |
|-------|-------|--------|
| S-console-01 | pregolya-console scaffold | 5 |
| S-console-02 | DebugSpanExporter ring buffer | 5 |
| S-console-03 | debug-endpoints Cargo feature | 5 |
| S-console-04 | graph-descriptor endpoint | 5 |
| S-console-05 | SPA build pipeline | 8 |
| S-console-06 | Run inspection panel | 8 |
| S-console-07 | Checkpoint history panel | 5 |
| S-console-08 | HITL resume panel | 5 |
| S-console-09 | Token budget panel | 5 |
| S-console-10 | Guardrail review panel | 5 |
| **Total** | | **56** |

## Changelog

- **1.8 (D-356/2026-09-06):** E-console epic added (Wave 3 roadmap, SS-24, 10 stories, 56 pts, ADR-031). Epic Catalog row added. Epic summary section added with architecture narrative, BC/CAP/VP traceability, topological sub-wave table, and story-point breakdown. State-manager to sync census header: 22→23 product epics, 42→52 stories, 316→372 product points.
- 1.7 (Round-66/F-P2A238-01/F-P2A238-03/2026-09-02): E-05 §S-2.12 — retired staging-table model (trajectory_records_staging, four-crash-point matrix) replaced with per-run single-transaction DELETE and two-crash-point matrix (before-COMMIT, after-COMMIT) per BC-2.04.011 {INV-003}/VP-019 (round-62 redesign, F-P2A234-01). E-TRAJ-006 (DURABILITY, AES-GCM integrity check failed) added to error code set per BC-2.04.009 {INV-001}/EC-006 (round-62/63). E-07 §S-1.28 — VP-020 (proptest P1, BC-2.02.009 {INV-001}/{INV-002}, harness promote_retire_channel_idempotency) added to verification narrative (round-62 mint, F-P2A234-05).
- 1.6 (Round-53-Phase-2-fix-burst/2026-08-31): E-05 §S-2.12 updated — staging-table swap model (trajectory_records_staging → trajectory_records) for compaction; VP-018 anchor corrected to retention-integrity invariants (BC-2.04.011 {INV-001}/{INV-002}); VP-019 four-crash-point matrix cited; error code set corrected to E-TRAJ-001..003+005 (E-TRAJ-004 RETIRED). E-07 §S-1.28 updated — module path corrected to channels/ directory; Channel trait impl added (Accumulator=Vec<T>, BSP dispatch, BC-2.02.007 {INV-004}); VP-017 dual-anchor corrected to BC-2.02.007 {INV-001}/{INV-002} + BC-2.02.008 {INV-001}/{INV-003}.
- 1.5 (Stage-3/CAP-040/2026-08-31): E-07 extended with S-1.28 — LedgerChannel (BC-2.02.007/008) and PromoteRetireChannel (BC-2.02.009) pure channel reducers; VP-017 proptest P1 anchored to S-1.28. E-05 extended with S-2.12 — TrajectoryWriter/Reader/Compactor (BC-2.04.009/010/011); VP-018 proptest P1 anchored to S-2.12. E-07 points 13→18; E-05 points 16→24; product-epic point total 303→316. Story count 39→41 product stories; wave counts W1 27→28, W2 11→12.
- 1.4 (round-8/O-P2A071-A+B/2026-08-26): E-22 VP description reworded — stale closed range "VP-001 through VP-014" replaced with accurate Kani-only scope statement; proptest/integration/unit VPs noted as Phase-3 anchor-story responsibility. Changelog backfilled with 1.0 initial row; 1.2 content unrecoverable from static analysis (git log is authoritative for 1.2 changes).
- 1.3 (round-7/F-P2A068-01/2026-08-26): E-21 rollup 13→16 reconciled to constituent story points S-2.10(8)+S-2.11(8)=16; product-epic point total 300→303 (S-2.11 5→8 GAP-01 growth, D-275); F-P2A068-01 round-7.
- 1.1 (P2A-044 F-09/2026-08-24): EPIC-MAINT points TBD→5 to match STORY-INDEX S-MAINT-001.
- 1.0 (Phase-2 decomposition/2026-08-24 approx): initial epic catalog — 22 product epics + EPIC-MAINT, Wave 1 (27 stories) + Wave 2 (11 stories) + Wave 6 (1 story), 303-point total.

### EPIC-MAINT — Maintenance and Self-Improvement (out-of-wave)

Maintenance and self-improvement stories that do not belong to a product delivery wave.
S-MAINT-001 is the seed story in this epic. Stories in EPIC-MAINT are dispatched outside
the wave scheduling gate and may reference any crate or subsystem. This epic does not
contribute to the 22-epic product story census.
