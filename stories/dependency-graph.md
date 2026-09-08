---
document_type: dependency-graph
version: "2.0"
status: active
producer: story-writer
timestamp: 2026-09-07T00:00:00Z
phase: 2
traces_to: .factory/stories/STORY-INDEX.md
---

# Dependency Graph — pregolya Phase 2

> **Acyclicity validation:** Topological sort completed. Graph is a DAG.
> No story has a circular dependency.
>
> **D-356 delta (2026-09-06):** 10 Wave-3 roadmap stories (S-console-01..10) added.
> Zero-cycle finding confirmed for the augmented graph: S-console stories have no
> edges into Wave-1/2 nodes, and Wave-1/2 nodes have no `depends_on` edges into
> S-console nodes. The S-console sub-graph is itself a DAG (topological sub-waves A–F
> below). The full augmented graph remains a DAG.

## Inter-Story Dependency DAG

> Format: `STORY-ID: depends_on [IDs] -> blocks [downstream IDs]`
> Dependencies are implementation-order requirements (the depended-on story's
> artifacts must exist before the dependent story can be implemented).

### Wave 1 — pregolya-core (E-01)

```
S-1.01 (PregolyaError)
  depends_on: []
  blocks: S-1.02, S-1.03, S-1.08, S-1.09, S-1.14

S-1.02 (Error Policy)
  depends_on: [S-1.01]
  blocks: S-1.04, S-1.06, S-1.09, S-1.10, S-1.12, S-2.01, S-2.04, S-2.09

S-1.03 (Message Types)
  depends_on: [S-1.01]
  blocks: S-1.04

S-1.04 (Runnable Trait)
  depends_on: [S-1.03, S-1.02]
  blocks: S-1.05, S-1.06, S-1.07, S-1.10, S-1.12, S-1.13, S-1.14,
          S-1.17, S-1.18, S-1.19, S-1.21, S-1.26, S-2.01, S-2.02,
          S-2.03, S-2.04, S-2.06, S-2.10

S-1.05 (LCEL)
  depends_on: [S-1.04]
  blocks: S-6.01

S-1.06 (Retry/Circuit Breaker)
  depends_on: [S-1.04, S-1.02]
  blocks: S-1.22, S-2.07
```

### Wave 1 — pregolya-macros (E-02)

```
S-1.07 (#[tool], #[entrypoint], #[task] macros)
  depends_on: [S-1.04]
  blocks: S-1.21, S-2.07
```

### Wave 1 — Independent crates (E-03, E-04, E-05, E-06)

```
S-1.08 (Recursive Splitter)
  depends_on: [S-1.01]
  blocks: [none in v1 stories]

S-1.09 (Sandbox)
  depends_on: [S-1.01, S-1.02]
  blocks: S-1.21, S-1.22, S-6.01

S-1.10 (Checkpoint Core)
  depends_on: [S-1.04, S-1.02]
  blocks: S-1.11, S-1.16, S-1.18, S-1.20, S-1.25, S-1.26, S-2.12, S-6.01

S-1.11 (FTS Search)
  depends_on: [S-1.10]
  blocks: [none in v1 stories]

S-1.12 (Memory Persistence)
  depends_on: [S-1.04, S-1.02]
  blocks: S-1.13

S-1.13 (SkillStore/WriteGuard)
  depends_on: [S-1.12, S-1.04, S-1.14, S-1.17]
  blocks: S-1.16
```

### Wave 1 — pregolya-graph (E-07 through E-12)

```
S-1.14 (StateGraph Nodes + Channels)
  depends_on: [S-1.04, S-1.01]
  blocks: S-1.13, S-1.15, S-1.16, S-1.17, S-1.18, S-1.19, S-1.28, S-2.11

S-1.15 (Conditional Edges + Send)
  depends_on: [S-1.14]
  blocks: S-1.16, S-1.17

S-1.16 (BSP Engine)
  depends_on: [S-1.14, S-1.15, S-1.10, S-1.13, S-1.17, S-1.18]
  blocks: S-1.20, S-1.26, S-6.01

S-1.17 (Streaming Events)
  depends_on: [S-1.14, S-1.04, S-1.15]
  blocks: S-1.13, S-1.16, S-1.18, S-1.20, S-1.23, S-1.24

S-1.18 (Budget/EvidenceJournal)
  depends_on: [S-1.14, S-1.04, S-1.10, S-1.17]
  blocks: S-1.16, S-1.24, S-1.25

S-1.19 (GuardrailHook)
  depends_on: [S-1.14, S-1.04]
  blocks: S-2.02, S-2.10

S-1.20 (HITL Core)
  depends_on: [S-1.16, S-1.17, S-1.10]
  blocks: S-1.23

S-1.23 (PreToolCallHook)
  depends_on: [S-1.20, S-1.17]
  blocks: S-1.24, S-6.01

S-1.24 (Approval + Compaction Events)
  depends_on: [S-1.23, S-1.17, S-1.18]
  blocks: S-1.25

S-1.25 (Compaction Execution)
  depends_on: [S-1.10, S-1.18, S-1.24]
  blocks: S-6.01
```

### Wave 1 — pregolya-tools (E-13)

```
S-1.21 (File System Tools)
  depends_on: [S-1.09, S-1.04, S-1.07]
  blocks: S-1.22

S-1.22 (Bash + Grep Tools)
  depends_on: [S-1.09, S-1.21, S-1.06]
  blocks: S-2.10, S-6.01
```

### Wave 1 — pregolya-server (E-14)

```
S-1.26 (Thread/Assistant/Run CRUD)
  depends_on: [S-1.16, S-1.10, S-1.04]
  blocks: S-1.27

S-1.27 (CronSchedule + SecurityConfig)
  depends_on: [S-1.26]
  blocks: [none in v1 stories]
```

### Wave 1 — pregolya-graph CAP-040 additions (LedgerChannel + PromoteRetireChannel)

```
S-1.28 (LedgerChannel + PromoteRetireChannel)
  depends_on: [S-1.14]
  blocks: [none in v1 stories]
```

### Wave 2 — pregolya-core D21 additions (E-15, E-16)

```
S-2.01 (LC Serialization)
  depends_on: [S-1.04, S-1.02]
  blocks: S-6.01

S-2.02 (Retriever Trait)
  depends_on: [S-1.19, S-1.04]
  blocks: S-2.03
```

### Wave 2 — pregolya-vectorstores (E-17)

```
S-2.03 (VectorStore Trait + InMemoryVectorStore)
  depends_on: [S-2.02, S-1.04, S-2.09]
  blocks: S-6.01
```

### Wave 2 — pregolya-prompts (E-18)

```
S-2.04 (Prompt Templates Core)
  depends_on: [S-1.04, S-1.02]
  blocks: S-2.05

S-2.05 (Injection Safety Guard)
  depends_on: [S-2.04]
  blocks: S-6.01
```

### Wave 2 — Provider crates (E-19, E-20)

```
S-2.06 (Provider SDK Split Architecture)
  depends_on: [S-1.04]
  blocks: S-2.07, S-2.09

S-2.07 (Chat Model Core Conformance)
  depends_on: [S-2.06, S-1.07, S-1.06]
  blocks: S-2.08

S-2.08 (Advanced Provider Features)
  depends_on: [S-2.07]
  blocks: [none in v1 stories]

S-2.09 (Embeddings Trait + Providers)
  depends_on: [S-2.06, S-1.02]
  blocks: S-2.03, S-6.01
```

### Wave 2 — pregolya-mcp (E-21)

```
S-2.10 (MCP Client)
  depends_on: [S-1.19, S-1.04, S-1.22]
  blocks: S-2.11

S-2.11 (MCP Server)
  depends_on: [S-2.10, S-1.14]
  blocks: [none in v1 stories]
```

### Wave 2 — pregolya-checkpoint CAP-040 additions (Trajectory Writer/Reader/Compaction)

```
S-2.12 (Durable Audit Trajectory)
  depends_on: [S-1.10]
  blocks: [none in v1 stories]
```

### Wave 3 — Developer Console (E-console, Roadmap — not built this cycle)

> **D-356 dev-console scope expansion (2026-09-06, story-writer).**
> These stories are specced now (Wave 3 roadmap) but built in a later cycle.
> No Wave-1/2 story has a `depends_on` edge into any S-console story;
> no S-console story blocks any Wave-1/2 story. The S-console sub-graph is a DAG.

```
S-console-01 (pregolya-console scaffold — ConsoleConfig, Axum bind, SPA embed)
  depends_on: []
  blocks: S-console-02, S-console-05

S-console-02 (DebugSpanExporter ring buffer + dev-mode wiring)
  depends_on: [S-console-01]
  blocks: S-console-03

S-console-03 (debug-endpoints Cargo feature — trace-read HTTP endpoints)
  depends_on: [S-console-02]
  blocks: S-console-04, S-console-06

S-console-04 (graph-descriptor endpoint — compile_graph_descriptor Pure Core)
  depends_on: [S-console-03]
  blocks: S-console-06

S-console-05 (SPA build pipeline — rust_embed, native EventSource, <500KB gzip)
  depends_on: [S-console-01]
  blocks: S-console-06, S-console-07

S-console-06 (run inspection panel — 16 StreamEvent variants, SSE EventSource)
  depends_on: [S-console-03, S-console-04, S-console-05]
  blocks: S-console-08, S-console-09, S-console-10

S-console-07 (checkpoint history panel — timeline, fork-from-checkpoint)
  depends_on: [S-console-05]
  blocks: []

S-console-08 (HITL resume panel — PreToolDecision, FIFO DI-003)
  depends_on: [S-console-06]
  blocks: []

S-console-09 (token budget panel — compaction markers, EvidenceJournal)
  depends_on: [S-console-06]
  blocks: []

S-console-10 (guardrail review panel — Fail/Transform, F-P99-01 DI-012)
  depends_on: [S-console-06]
  blocks: []
```

### Crate-Level Dependency Edges

> Runtime crate dependencies introduced by story decisions that add cross-crate build edges.
> Source-of-truth is the workspace `Cargo.toml` members list; this section tracks edge rationale.

| From Crate | To Crate | Rationale | ADR / BC Source |
|-----------|----------|-----------|----------------|
| `pregolya-mcp` | `pregolya-graph` | `GraphAgentTool` wraps `Arc<CompiledStateGraph>` (non-generic; `from_graph` is a non-generic constructor) — introduced by BC-2.09.008 and formalized in ADR-029 §Consequences. The `mcp::graph_tool` module depends on `CompiledStateGraph` and `GraphRunner` types from `pregolya-graph`. | ADR-029 §Consequences, BC-2.02.001 {PC-001}, BC-2.09.008 {PC-001} |
| `pregolya-console` | `pregolya-server` | Console binary co-launches `pregolya-server` in dev mode (ADR-031 Decision 1); `ConsoleConfig.server_config` passes `ServerConfig` across the crate boundary. The `debug-endpoints` Cargo feature on `pregolya-server` is activated by the console's dev-mode launch. | ADR-031 §Decision 1, BC-2.24.001 {PC-004}, BC-2.24.002 {PC-003} |

> **DAG-acyclicity confirmation:** Adding `pregolya-mcp → pregolya-graph` does not create a
> cycle. `pregolya-graph` has no dependency on `pregolya-mcp` (one-directional). At the story
> level, S-1.14 (Wave 1 batch 1d) is upstream of S-2.11 (Wave 2 batch 2d) — no cycle.
> Adding `pregolya-console → pregolya-server` does not create a cycle: `pregolya-server` has
> no build dependency on `pregolya-console` (console is the binary consumer, server is the
> library). S-console-01 is the root of the E-console sub-graph with no Wave-1/2 edges.
> Topological sort assertion continues to hold: Graph is a DAG.

### Wave 6 — Formal Verification (E-22)

```
S-6.01 (Kani + cargo-fuzz)
  depends_on: [S-1.16, S-1.10, S-1.09, S-2.01, S-2.03, S-1.23, S-1.25, S-1.05, S-2.09, S-2.05, S-1.22]
  blocks: [none — terminal node]
```

## Topological Sort (Wave Execution Order)

> Stories in the same batch have no inter-story dependencies and can be
> dispatched in parallel to separate implementer agents.

### Wave 1 — Topological Batches

| Batch | Stories | Rationale |
|-------|---------|-----------|
| 1a | S-1.01 | Root: no dependencies |
| 1b | S-1.02, S-1.03, S-1.08 | All depend only on S-1.01 |
| 1c | S-1.04, S-1.09 | S-1.04 dep S-1.02+S-1.03 (1b); S-1.09 dep S-1.01+S-1.02 (1a+1b) |
| 1d | S-1.05, S-1.06, S-1.07, S-1.10, S-1.12, S-1.14 | All deps satisfied by 1a–1c; none depend on each other |
| 1e | S-1.11, S-1.15, S-1.19, S-1.21, S-1.28 | All deps in 1a–1d; none depend on each other; S-1.28 dep S-1.14 (1d); S-1.13/S-1.17/S-1.18 removed — see 1f/1g |
| 1f | S-1.17, S-1.22 | S-1.17 dep S-1.15 (1e)+S-1.14+S-1.04 (1d); S-1.22 dep S-1.21 (1e)+S-1.06 (1d); no intra-batch edges |
| 1g | S-1.13, S-1.18 | S-1.13 dep S-1.17 (1f)+S-1.12+S-1.14 (1d); S-1.18 dep S-1.17 (1f)+S-1.14+S-1.10 (1d); concurrent — disjoint scheduler.rs regions per coordination note |
| 1h | S-1.16 | Dep S-1.13+S-1.18 (1g)+S-1.17 (1f)+S-1.15 (1e)+S-1.14+S-1.10 (1d) |
| 1i | S-1.20, S-1.26 | S-1.20 dep S-1.16 (1h)+S-1.17 (1f)+S-1.10 (1d); S-1.26 dep S-1.16 (1h)+S-1.10 (1d) |
| 1j | S-1.23, S-1.27 | S-1.23 dep S-1.20 (1i)+S-1.17 (1f); S-1.27 dep S-1.26 (1i) |
| 1k | S-1.24 | Dep S-1.23 (1j)+S-1.17 (1f)+S-1.18 (1g) |
| 1l | S-1.25 | Dep S-1.10 (1d)+S-1.18 (1g)+S-1.24 (1k) |

### Wave 2 — Topological Batches

| Batch | Stories | Rationale |
|-------|---------|-----------|
| 2a | S-2.01, S-2.04, S-2.06, S-2.12 | S-2.01 dep S-1.04+S-1.02; S-2.04 dep S-1.04+S-1.02; S-2.06 dep S-1.04; S-2.12 dep S-1.10 (Wave-1 dep; satisfied before Wave 2 begins) |
| 2b | S-2.02, S-2.05, S-2.07, S-2.09 | S-2.02 dep S-1.19+S-1.04; S-2.05 dep S-2.04; S-2.07 dep S-2.06+S-1.07+S-1.06; S-2.09 dep S-2.06+S-1.02 |
| 2c | S-2.03, S-2.08, S-2.10 | S-2.03 dep S-2.02+S-1.04+S-2.09; S-2.08 dep S-2.07; S-2.10 dep S-1.19+S-1.04+S-1.22 |
| 2d | S-2.11 | Dep S-2.10 (binding, 2c) + S-1.14 (Wave-1 dep; satisfied before Wave 2 begins) |

### Wave 6

| Batch | Stories | Rationale |
|-------|---------|-----------|
| 6a | S-6.01 | Terminal node; all Wave 1+2 merged |

### Wave 3 — Developer Console Topological Batches (Roadmap — not built this cycle)

> **D-356 dev-console scope expansion (2026-09-06, story-writer).**
> Topological sub-waves A–F derived from the S-console DAG above.
> Stories in the same sub-wave have no inter-story dependencies and can be
> dispatched in parallel when Wave 3 is activated.

| Sub-Wave | Stories | Rationale |
|----------|---------|-----------|
| 3A | S-console-01 | Root: no dependencies |
| 3B | S-console-02, S-console-05 | Both depend only on S-console-01 (3A); no intra-batch edges |
| 3C | S-console-03, S-console-07 | S-console-03 dep S-console-02 (3B); S-console-07 dep S-console-05 (3B); no intra-batch edges |
| 3D | S-console-04 | Dep S-console-03 (3C) |
| 3E | S-console-06 | Dep S-console-03 (3C) + S-console-04 (3D) + S-console-05 (3B); all satisfied by 3B–3D |
| 3F | S-console-08, S-console-09, S-console-10 | All dep S-console-06 (3E); no intra-batch edges |

---

## Traceability Matrices

### BC to Stories Matrix (abbreviated — full map in STORY-INDEX.md)

> Full coverage: 140 BCs, 41 stories, 0 gaps. (Preamble census update to 140 / 42 total stories pending state-manager STATE.md sync.)

| Subsystem | BC Range | Stories | Coverage |
|-----------|----------|---------|---------|
| SS-01 Core Primitives | BC-2.01.001–008 | S-1.03, S-1.04, S-1.05 | Full |
| SS-02 StateGraph | BC-2.02.001–009 | S-1.14, S-1.15, S-1.28 | Full |
| SS-03 BSP Engine | BC-2.03.001–003 | S-1.16 | Full |
| SS-04 Checkpoint | BC-2.04.001–011 | S-1.10, S-1.11, S-2.12 | Full |
| SS-05 HITL | BC-2.05.001–008 | S-1.20, S-1.23 | Full |
| SS-06 Streaming | BC-2.06.001–006 | S-1.17, S-1.24 | Full |
| SS-07 Splitters | BC-2.07.001–003 | S-1.08 | Full |
| SS-08 Providers | BC-2.08.001–014 | S-1.07, S-2.06, S-2.07, S-2.08 | Full |
| SS-09 MCP | BC-2.09.001–008 | S-2.10, S-2.11 | Full |
| SS-10 Budget | BC-2.10.001–006 | S-1.18, S-1.25 | Full |
| SS-11 Guardrail | BC-2.11.001–006 | S-1.19 | Full |
| SS-12 Server | BC-2.12.001–007 | S-1.26, S-1.27 | Full |
| SS-13 Sandbox | BC-2.13.001–007 | S-1.09 | Full |
| SS-14 Error Taxonomy | BC-2.14.001–006 | S-1.01, S-1.02 | Full |
| SS-15 Memory | BC-2.15.001–006 | S-1.12, S-1.13 | Full |
| SS-16 Retry | BC-2.16.001–003 | S-1.06 | Full |
| SS-17 Formal Verification | BC-2.17.001–002 | S-6.01 | Full |
| SS-18 Prompts | BC-2.18.001–005 | S-2.04, S-2.05 | Full |
| SS-19 LC Serialization | BC-2.19.001–006 | S-2.01 | Full |
| SS-20 Retrieval | BC-2.20.001–003 | S-2.02 (BC-2.20.001–002), S-2.03 (BC-2.20.003) | Full |
| SS-21 VectorStore | BC-2.21.001–004 | S-2.03 | Full |
| SS-22 Embeddings | BC-2.22.001–003 | S-2.09 | Full |
| SS-23 Tools | BC-2.23.001–006 | S-1.21, S-1.22 | Full |
| SS-24 Developer Console | BC-2.24.001–008 | S-console-01 (BC-2.24.001), S-console-02 (BC-2.24.001+002), S-console-03 (BC-2.24.002), S-console-04 (BC-2.24.003), S-console-05 (BC-2.24.001), S-console-06 (BC-2.24.004), S-console-07 (BC-2.24.005), S-console-08 (BC-2.24.006), S-console-09 (BC-2.24.007), S-console-10 (BC-2.24.008) | Full (Wave 3 roadmap) |

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** SS-24 row added.
> Wave-3 roadmap stories; coverage is full at the spec level (all 8 BCs anchored).
> Count delta: +8 BCs (BC-2.24.001–008), +10 stories (S-console-01..10);
> census header update (140 BCs / 41 stories → 148 BCs / 52 stories) is pending
> state-manager STATE.md sync.

### VP to Stories Matrix

| VP | BC Anchor | Type | Phase | Priority | Anchor Story | Additional Stories |
|----|-----------|------|-------|---------|-------------|-------------------|
| VP-001 | BC-2.03.001 | Kani | 6 | P0 | S-1.16 | S-6.01 |
| VP-002 | BC-2.04.006 | Kani | 6 | P0 | S-1.10 | S-6.01 |
| VP-003 | BC-2.13.004 | Kani | 6 | P0 | S-1.09 | S-6.01 |
| VP-004 | BC-2.09.004 | integration | 3 | P1 | S-2.10 | — |
| VP-005 | BC-2.09.005 | integration | 3 | P1 | S-2.10 | — |
| VP-006 | BC-2.18.004 | Kani | 6 | P1 | S-2.05 | S-6.01 |
| VP-007 | BC-2.19.001 | proptest | 3 | P1 | S-2.01 | S-6.01 |
| VP-008 | BC-2.22.001 | proptest | 3 | P1 | S-2.09 | S-6.01 |
| VP-009 | BC-2.21.003 | Kani | 6 | P0 | S-2.03 | S-6.01 |
| VP-010 | BC-2.19.005 | Kani | 6 | P0 | S-2.01 | S-6.01 |
| VP-011 | BC-2.05.007 | Kani | 6 | P0 | S-1.23 | S-6.01 |
| VP-012 | BC-2.10.005 | Kani | 6 | P1 | S-1.25 | S-6.01 |
| VP-013 | BC-2.23.005 | Kani | 6 | P1 | S-1.22 | S-6.01 |
| VP-014 | BC-2.01.005 + BC-2.01.006 | proptest | 3 | P1 | S-1.05 | S-6.01 |
| VP-015 | BC-2.09.007 {INV-003} | unit | 3 | P1 | S-2.11 | — |
| VP-016 | BC-2.09.008 {INV-001} | proptest | 3 | P1 | S-2.11 | — |
| VP-017 | BC-2.02.007 + BC-2.02.008 | proptest | 3 | P1 | S-1.28 | — |
| VP-018 | BC-2.04.011 {INV-001} | proptest | 3 | P1 | S-2.12 | — |
| VP-019 | BC-2.04.011 {INV-003} | integration | 6 | P1 | S-2.12 | — |
| VP-020 | BC-2.02.009 {INV-001}+{INV-002} | proptest | 3 | P1 | S-1.28 | — |
| VP-006-B | BC-2.18.004 {PC-005} | proptest | 3 | P1 | S-2.05 | — |
| VP-2.24.001-A | BC-2.24.001 | unit | 3 | P1 | S-console-01 | — |
| VP-2.24.001-B | BC-2.24.001 | unit | 3 | P1 | S-console-01 | — |
| VP-2.24.001-C | BC-2.24.001 | compile-fail | 3 | P1 | S-console-01 | — |
| VP-2.24.002-A | BC-2.24.002 | proptest | 3 | P1 | S-console-02 | — |
| VP-2.24.002-B | BC-2.24.002 | proptest | 3 | P1 | S-console-02 | — |
| VP-2.24.002-C | BC-2.24.002 | integration | 3 | P1 | S-console-03 | — |
| VP-2.24.002-D | BC-2.24.002 | unit | 3 | P1 | S-console-02 | — |
| VP-2.24.003-A | BC-2.24.003 | unit | 3 | P1 | S-console-04 | — |
| VP-2.24.003-B | BC-2.24.003 | Kani | 6 | P1 | S-console-04 | — |
| VP-2.24.003-C | BC-2.24.003 | unit | 3 | P1 | S-console-04 | — |
| VP-2.24.004-A | BC-2.24.004 | integration | 3 | P1 | S-console-06 | — |
| VP-2.24.004-B | BC-2.24.004 | integration | 3 | P1 | S-console-06 | — |
| VP-2.24.005-A | BC-2.24.005 | integration | 3 | P1 | S-console-07 | — |
| VP-2.24.005-B | BC-2.24.005 | integration | 3 | P1 | S-console-07 | — |
| VP-2.24.006-A | BC-2.24.006 | integration | 3 | P1 | S-console-08 | — |
| VP-2.24.006-B | BC-2.24.006 | integration | 3 | P1 | S-console-08 | — |
| VP-2.24.007-A | BC-2.24.007 | unit | 3 | P1 | S-console-09 | — |
| VP-2.24.007-B | BC-2.24.007 | integration | 3 | P1 | S-console-09 | — |
| VP-2.24.008-A | BC-2.24.008 | integration | 3 | P1 | S-console-10 | — |
| VP-2.24.008-B | BC-2.24.008 | unit | 3 | P1 | S-console-10 | — |

> **D-356 adversary fix DC-06 (2026-09-07, story-writer).** SS-24 VP rows now byte-match
> VP-INDEX §VP Catalog (v1.47, source of truth). Corrections applied: VP-2.24.001-B unit/S-console-01
> (was integration/S-console-02); VP-2.24.001-C compile-fail (was unit); VP-2.24.002-A proptest
> (was unit); VP-2.24.002-B proptest/S-console-02 (was integration/S-console-03);
> VP-2.24.002-C integration/S-console-03 (was unit/S-console-02); VP-2.24.002-D row added
> (unit/S-console-02 — console::span_exporter SEC-BOUND-001 sanitization per DC-02 addendum);
> VP-2.24.003-B Kani/phase-6 (was integration/phase-3); VP-2.24.004-B integration (was unit);
> VP-2.24.005-B integration (was unit); VP-2.24.006-B integration (was unit);
> VP-2.24.007-A unit (was integration); VP-2.24.007-B integration (was unit);
> VP-2.24.008-B unit (was integration). Stale BC-clause tags ({PC-001} etc.) removed from
> BC Anchor column — VP-INDEX carries bare BC-IDs in the catalog. Total SS-24 VP rows: 20
> (19 A/B-series + VP-2.24.002-D).

### NFR to Stories Matrix

> NFR catalog defined at `.factory/specs/prd-supplements/nfr-catalog.md`.
> The following NFR to story mappings use NFR identifiers from that catalog.
> Stories are not gated on NFR verification at Phase 2; NFR validation occurs in
> Phase 3 (per-story) and Phase 6 (formal hardening).

| NFR Category | Stories Implementing It | Validation Method |
|-------------|------------------------|-------------------|
| NFR: No unwrap in non-test code (production-grade default) | All Wave 1+2 stories | cargo clippy -D clippy::unwrap_used |
| NFR: reqwest rustls-tls mandatory | S-1.02, S-2.07, S-2.08, S-2.09 | cargo deny + CI |
| NFR: 30s HTTP timeout default | S-1.02, S-2.07, S-2.09 | Adversarial review per SAP |
| NFR: Redacted Debug for credentials | S-1.02, S-2.07, S-2.09 | Adversarial review |
| NFR: Non-exhaustive on public API types | All stories with new public types | compile-fail test gates |
| NFR: No println! in library crates | All crate stories | cargo clippy |
| NFR: 500 code-lines soft / 750 hard per file | All stories | cargo xtask check-file-size |
| NFR: Tokio multi-threaded async runtime | S-1.10, S-1.16, S-1.26, S-2.07, S-2.09, S-2.10 | runtime config in tests |
| NFR: Arc-DI wiring per constructor | S-1.14, S-1.18, S-1.19, S-1.20, S-2.02, S-2.03 | adversary fresh-context review |
| NFR: Structured tracing events + catalog row | All stories emitting events | SAP-1 adversary standing probe |

---

## BC Clause Coverage Matrix

> Abbreviated to Red Gate BCs and VP-anchored BCs. Full per-clause coverage
> is established at the story spec authoring stage (subsequent bursts).
> GAP-001 through GAP-003 represent intentionally-deferred P2 and Phase 6 items.

| BC | Key Clauses | Covering Story | AC Gap |
|----|-------------|---------------|--------|
| BC-2.02.003 | NamedBarrierValue missing-writer boundary (RG) | S-1.14 | Covered; RG test required |
| BC-2.02.004 | EphemeralValue cleared-after-super-step (RG) | S-1.14 | Covered; RG test required |
| BC-2.03.001 | BSP determinism (VP-001 Kani P0) | S-1.16 | Covered; Kani harness in S-6.01 |
| BC-2.04.006 | Session triple-address uniqueness (VP-002 Kani P0) | S-1.10 | Covered; Kani harness in S-6.01 |
| BC-2.07.002 | Non-ASCII boundary parity (RG) | S-1.08 | Covered; RG test required |
| BC-2.09.004 | MCP bare ToolException re-raise (RG, VP-004) | S-2.10 | Covered; integration test |
| BC-2.09.005 | MultiServerMcpClient no live connections (RG, VP-005) | S-2.10 | Covered; integration test |
| BC-2.13.004 | Workspace confinement (VP-003 Kani P0) | S-1.09 | Covered; Kani harness in S-6.01 |
| BC-2.18.004 | Injection guard fail-closed (RG, VP-006) | S-2.05 | Covered; Kani harness in S-6.01 |
| BC-2.18.005 | SlotTrustPolicy TrustAll construction error (RG) | S-2.05 | Covered; RG test required |
| BC-2.19.005 | Reviver allowlist fail-closed (RG, VP-010 Kani P0) | S-2.01 | Covered; Kani harness in S-6.01 |
| BC-2.20.002 | RAGRetrieval guardrail coverage (RG) | S-2.02 | Covered; RG test required |
| BC-2.21.003 | Zero-norm vector guard (RG, VP-009 Kani P0) | S-2.03 | Covered; Kani harness in S-6.01 |
| BC-2.22.002 | EmbeddingsOpenAI credential opacity + batch failure (RG) | S-2.09 | Covered; RG test required |
| BC-2.19.004 | Legacy namespace remap (P2) | S-2.01 | GAP-001 (P2 — lower priority but v1 in-scope) |

---

## Edge Case Coverage Matrix

> Edge cases are fully enumerated in per-story spec bodies (subsequent bursts).
> Key security-critical edge cases are listed here for early reference.

| Category | Edge Case | Description | Story | Status |
|----------|-----------|-------------|-------|--------|
| Sandbox | Symlink workspace escape | Resolved symlink points outside root | S-1.09 | Covered — BC-2.13.005 |
| Sandbox | macOS Seatbelt + ProcessBackend | Seatbelt profile denied operation | S-1.09 | Covered — BC-2.13.006 |
| Checkpoint | Concurrent put_writes collision | Two tasks write same key in same step | S-1.10 | Covered — BC-2.04.001 |
| BSP | Concurrent LastValue write | Two nodes write same channel in same step | S-1.16 | Covered — BC-2.03.002 |
| HITL | Resume on empty queue | No pending resume values | S-1.20 | Covered — BC-2.05.005 |
| Guardrail | No hook registered | Default pass-through with WARNING | S-1.19 | Covered — BC-2.11.006 |
| Serialization | Unknown type ID in reviver | Type not in OnceLock allowlist | S-2.01 | Covered — BC-2.19.005 |
| Serialization | Langchain monolith namespace | lc_type from python monolith | S-2.01 | Covered — BC-2.19.006 |
| VectorStore | Zero-norm embedding vector | Division by zero in cosine similarity | S-2.03 | Covered — BC-2.21.003 |
| Budget | Ceiling reached mid-run | Budget halt fires during BSP step | S-1.18 | Covered — BC-2.10.003 |
| Provider | Transport error on streaming | Network failure mid-stream | S-2.07 | Covered — BC-2.08.007 |
| MCP | ToolException from MCP server | Raw exception must propagate | S-2.10 | Covered — BC-2.09.004 |

---

## Gap Register

| Gap ID | Level | Source | Item | Justification | Resolution Target |
|--------|-------|--------|------|---------------|------------------|
| GAP-001 | L1 | BC-2.19.004 | P2 legacy namespace remap for OLD_CORE_NAMESPACES_MAPPING | Implemented in S-2.01 at P2 priority — lower urgency than P0/P1 BCs but v1 in-scope; resolution is implementation ordering, not deferral | S-2.01 Wave 2 |
| GAP-002 | L3 | VP-001 through VP-013 (Kani) | Kani harness execution | Harnesses authored in story specs but compiled and verified in S-6.01 (Phase 6); formal verification requires all Wave 1+2 crates compiled first | S-6.01 Wave 6 |
| GAP-003 | L3 | VP-004, VP-005 (integration) | MCP integration test against live server | Integration tests require MCP server running; exercised via in-process DTU-style mock server in S-2.10/2.11 unit tests; live-server tests tagged #[ignore] pending provisioned test environment per SID-1 | S-2.10, S-2.11 |

---

## Changelog

- **2.0 (D-356/DC-06/2026-09-07):** F-PDC06-01 (HIGH) — SS-24 VP-to-Stories matrix rows rewritten to byte-match VP-INDEX §VP Catalog v1.47 (source of truth). Twelve tool/phase/story corrections across 12 existing rows; VP-2.24.002-D row added (unit / S-console-02 / console::span_exporter SEC-BOUND-001 sanitization, DC-02 addendum). Stale BC-clause tags removed from BC Anchor column. Stale "VP-INDEX sync pending" marker retired and replaced with DC-06 sync-confirmed note. Total SS-24 VP rows: 20. See DC-06 delta note above the VP rows for full per-row correction table.
- **1.9 (D-356/2026-09-06):** Wave-3 developer console roadmap cluster integrated. New DAG section: 10 S-console-01..10 stories with 9 dependency edges and zero inter-wave edges to Wave-1/2/6 nodes. Crate-Level Dependency Edges: `pregolya-console → pregolya-server` row added (ADR-031 §Decision 1; BC-2.24.001 {PC-004}, BC-2.24.002 {PC-003}). Topological sort: Wave-3 sub-waves 3A–3F added (parallel batches within E-console). BC-to-Stories Matrix: SS-24 row added covering BC-2.24.001–008 across 10 stories (full spec coverage). VP-to-Stories Matrix: 20 new VP-2.24 rows added (VP-2.24.001-A/B/C through VP-2.24.008-A/B; all P1, Phase 3). DAG acyclicity confirmed: S-console sub-graph is a DAG; no cross-wave edges introduced; full augmented graph remains a DAG. Census delta (state-manager to propagate): +8 BCs, +10 stories, +1 epic.
- **1.8 (round-77/F-P2A249-01+F-P2A249-02/2026-09-02):** Full VP-to-Stories Matrix re-derivation from source-of-truth (VP-INDEX.md §VP Catalog BC-Anchor column + STORY-INDEX §VP-to-Story Anchor Map + S-6.01 frontmatter `verification_properties`). (F-P2A249-01 MED) VP-017 BC anchor corrected `BC-2.02.007` → `BC-2.02.007 + BC-2.02.008` (dual anchor; VP-INDEX §VP Catalog VP-017 row, VP-017 body frontmatter `bc_anchor`, and STORY-INDEX §VP-to-Story Anchor Map all confirm dual form). (F-P2A249-02 MED) VP-006-B Additional-Stories corrected `S-6.01` → `—` (S-6.01 frontmatter `verification_properties: [VP-001...VP-014]` does not include VP-006-B; sibling Phase-3 proptests VP-016/017/018/020 all show `—` consistently). Clause tags synced to VP-INDEX exact BC-Anchor form in four additional rows: VP-015 `BC-2.09.007` → `BC-2.09.007 {INV-003}`; VP-016 `BC-2.09.008` → `BC-2.09.008 {INV-001}`; VP-018 `BC-2.04.011` → `BC-2.04.011 {INV-001}`; VP-006-B `BC-2.18.004` → `BC-2.18.004 {PC-005}`. All other 15 rows confirmed correct (no additional drift). Total changes: 6 cells across 5 rows.
- **1.7 (round-62/D-340/2026-09-01):** VP-020 row added to VP-to-Stories Matrix (BC-2.02.009 {INV-001}+{INV-002} / proptest / 3 / P1 / S-1.28 / —); matrix now enumerates all 21 VPs. Version bump for census parity with VP-INDEX §VP-020.
- **1.6 (round-60/F-P2A232-03+F-P2A232-04/2026-09-01):** (F-P2A232-03) S-1.10 `blocks:` extended to include S-2.12 — reverse-edge fix for S-2.12 `depends_on: [S-1.10]` asymmetry (sibling of v1.5 S-1.14→S-1.28 fix). Full DAG reverse-edge sweep performed: all other `depends_on`↔`blocks` pairs confirmed symmetric; no additional asymmetries found. (F-P2A232-04) VP-to-Stories Matrix: VP-019 row added (`BC-2.04.011 {INV-003} | integration | 6 | P1 | S-2.12 | —`) to match VP-INDEX source of truth; matrix now enumerates all 20 VPs. DAG acyclicity unaffected.
- **1.5 (round-54/F-P2A224-05/2026-09-01):** S-1.14 `blocks:` extended to include S-1.28 (reverse edge fix — S-1.28 depends_on S-1.14, so S-1.14 must list S-1.28 in blocks). DAG acyclicity unaffected: S-1.28 depends on S-1.14 (Wave-1 upstream); topological sort batch-1e already correctly placed S-1.28 after S-1.14 (batch-1d); no new ordering constraints introduced.
- **1.4 (Stage-3/CAP-040/2026-08-31):** Two new stories integrated: S-1.28 (LedgerChannel + PromoteRetireChannel, pregolya-graph, BC-2.02.007/008/009, VP-017 proptest P1 anchor) and S-2.12 (Durable Audit Trajectory, pregolya-checkpoint, BC-2.04.009/010/011, VP-018 proptest P1 anchor). DAG entries added for both. Wave-1 batch-1e extended: S-1.28 added (depends_on [S-1.14]; S-1.14 in batch-1d — no new deps required). Wave-2 batch-2a extended: S-2.12 added (depends_on [S-1.10]; Wave-1 dep satisfied before Wave 2 begins). BC to Stories Matrix: SS-02 range BC-2.02.001–006 → BC-2.02.001–009 / S-1.14+S-1.15+S-1.28; SS-04 range BC-2.04.001–008 → BC-2.04.001–011 / S-1.10+S-1.11+S-2.12. VP to Stories Matrix: VP-017 (BC-2.02.007 / proptest / P1 / S-1.28) and VP-018 (BC-2.04.011 / proptest / P1 / S-2.12) added. BC coverage header updated to 140 BCs / 41 product stories (preamble census pending state-manager STATE.md sync). DAG-acyclicity confirmed: S-1.28 depends_on S-1.14 (Wave 1 upstream) — no cycle; S-2.12 depends_on S-1.10 (Wave 1 upstream) — no cycle.
- **1.3 (GAP-01-nongeneric/round-10/2026-08-27):** Crate-Level Dependency Edges live row updated to round-10 non-generic design: `Arc<CompiledGraph<S>>` → `Arc<CompiledStateGraph>`; `from_graph<S>` generic constructor clause removed (`from_graph` is now a non-generic constructor per ADR-029 §Symbol Grounding / BC-2.02.001 {PC-001}); `CompiledGraph<S>` type reference → `CompiledStateGraph`; ADR source updated to ADR-029 §Consequences, BC-2.02.001 {PC-001}, BC-2.09.008 {PC-001}. Historical §Changelog rows preserved as records.
- **1.2 (F-P2A066-02/round-7/2026-08-26):** Crate-Level Dependency Edges: `GraphAgentTool<S>` → `GraphAgentTool` (struct is non-generic; `from_graph<S>` constructor and `Arc<CompiledGraph<S>>` remain generic per ADR-029 §Decision); clarification note added.
- **1.1 (F1/round-5/2026-08-26):** (a) BC count updated 133 → 134 to reflect BC-2.09.008 addition. (b) SS-09 BC range updated BC-2.09.001–007 → BC-2.09.001–008. (c) VP-to-Stories Matrix extended: VP-015 (BC-2.09.007 / unit / S-2.11), VP-016 (BC-2.09.008 / proptest / S-2.11), VP-006-B (BC-2.18.004 / Kani / S-2.05) added. (d) Crate-Level Dependency Edges section added: `pregolya-mcp → pregolya-graph` (ADR-029 / BC-2.09.008 PC-001; GraphAgentTool wraps Arc<CompiledGraph<S>>). S-1.14 added as upstream of S-2.11 (S-2.11 depends_on updated to [S-2.10, S-1.14]; S-1.14 blocks updated to include S-2.11). Topological sort batch 2d rationale updated; DAG-acyclicity confirmed (S-1.14 Wave-1 upstream of S-2.11 Wave-2 — no cycle).
