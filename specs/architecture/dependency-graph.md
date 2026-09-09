---
document_type: architecture-section
level: L3
section: dependency-graph
version: "1.15"
status: active
producer: architect
timestamp: 2026-09-09T00:00:00Z
phase: 1b
inputs:
  - .factory/specs/prd-supplements/module-criticality.md
  - .factory/specs/prd.md
  - .factory/specs/module-criticality.md
input-hash: "90c00a6"
traces_to: ARCH-INDEX.md
decisions: [D4, D6, D7, D21, D23]
changelog:
  - "1.15 (DC-52/2026-09-09, architect): OBS (pre-existing gap, not a D-356 defect) — pregolya-community fully registered in the DAG to close 22-vs-21 crate roster inconsistency (ARCH-INDEX §Canonical Crate Roster lists 22 crates including pregolya-community #8 at D6/post-v1). (1) §Crate DAG: added pregolya-community [post-v1] node (community→core; LOW criticality; third-party integrations; D6 post-v1). (2) §Edge Table: added pregolya-community→pregolya-core (runtime; core types + traits for integration impls). No community→graph edge (community extensions depend on core types only at this level). (3) §Topological Build Order Wave 3: added pregolya-community at position 20 (post-v1); pregolya-console renumbered to 21; facade renumbered to 22; wave heading updated to include post-v1. Acyclicity confirmed: community→core only; nothing depends on community (not yet); facade is terminal. input-hash unchanged (inputs did not change)."
  - "1.14 (DC-51/F-PDC51-01/2026-09-09, architect): F-PDC51-01 (MED) — pregolya-console fully registered in the DAG. (1) §Crate DAG: added pregolya-console [PLANNED Wave 3] node with console→server (SpanData+DebugSpanSource; ADR-031 Decision 7) and console→core (shared core types) edges; facade depends list extended to include pregolya-console. (2) §Edge Table: added two rows — pregolya-console→pregolya-server (SpanData + DebugSpanSource; BC-2.24.001 {INV-001}; S-console-02) and pregolya-console→pregolya-core (shared core types; BC-2.24.001 {INV-001}; S-console-01); no console→graph edge (BC-2.24.001 {INV-001} forbids). (3) §Topological Build Order: heading updated to include Wave 3; pregolya-console at position 20 (PLANNED); facade renumbered to position 21; title updated. Acyclicity confirmed: console→server→graph→core; console→core; facade→console; nothing depends back on console or facade. input-hash unchanged (inputs did not change)."
  - "1.13 (DC-50/F-2/2026-09-09, architect): F-2 (story-scope fix) — add missing Edge Table row `pregolya (facade) → pregolya-console` (runtime; facade `pregolya console` subcommand calls `pregolya_console::run_console(config)`; S-console-01 AC-001). Acyclicity confirmed: pregolya (facade) is the terminal node (position 20); pregolya-console is an impl crate that cannot depend back on the facade; no cycle introduced. input-hash unchanged (inputs did not change)."
  - "1.12 (D-356/DC-48/F-PDC48-04/2026-09-09, architect): F-PDC48-04 (LOW) — two stale edge rationales corrected. (1) pregolya-checkpoint→pregolya-core: add GuardrailEntry (core::guardrail) and associated types (GuardrailResult, IngressBoundary) as checkpoint deps — required for typed CheckpointSaver GuardrailJournal ops (append_guardrail_entry/get_guardrail_journal; BC-2.11.007); checkpoint→core dep allowed. (2) pregolya-graph→pregolya-checkpoint: add graph::provenance GuardrailJournal write-path (init_guardrail_journal, append_guardrail_entry) alongside existing graph::budget compaction read-path. input-hash updated 90c00a6 (input drift from prior burst — prd.md and module-criticality.md had changed)."
  - "1.11 (R46/F-193-01-sibling/2026-08-30): CLASS-AUDIT-2 CompiledGraph phantom sweep — Edge Table `pregolya` facade→pregolya-graph row: `CompiledGraph` (phantom bare name, non-canonical per ADR-029 §Symbol Grounding) replaced with `CompiledStateGraph` (canonical non-generic type per BC-2.02.001 {PC-001}). Sibling sweep: this was the sole remaining live-body `CompiledGraph` (bare, non-grandfathered) occurrence in this file; changelog entries v1.8/v1.10 retain old names as historical records (grandfathered per TD-VSDD-091). input-hash updated to e2207b1."
  - "1.10 (round-10-sibling-sweep/2026-08-27): GAP-01 type-grounding straggler sweep — three `CompiledGraph<S>` live-body sites replaced with `CompiledStateGraph` (non-generic; BC-2.02.001 {PC-001}): (1) Crate DAG pregolya-mcp annotation; (2) Edge Table pregolya-mcp→pregolya-graph rationale; (3) Build Order Wave 2 position-19 annotation. Sibling sweep: no additional CompiledGraph<S> or Fn(&S) sites in this file (v1.8 changelog entry retains old symbol as historical record; grandfathered per TD-VSDD-091). input-hash updated to 69778ab."
  - "1.9 (round-6/BLOCKER-3/2026-08-26): §Cross-Cutting Dependencies proptest row: add `pregolya-prompts [VP-006-B]` (injection_guard Multi-Pair FewShotExamples fail-closed; proptest P1; multi-pair injection-guard mandate SEC-003 per VP-INDEX). Proptest crate now covers 7 crates: pregolya-graph, pregolya-checkpoint, pregolya-splitters, pregolya-core, pregolya-memory, pregolya-mcp, pregolya-prompts."
  - "1.8 (GAP-01/ADR-029/2026-08-26): Add new runtime edge `pregolya-mcp → pregolya-graph` (mcp::graph_tool module wraps CompiledGraph<S> as DynTool; ADR-029 Decision 1). (1) Crate DAG: update pregolya-mcp leaf annotation to include `CompiledGraph<S>` from pregolya-graph. (2) Edge Table: add pregolya-mcp → pregolya-graph runtime row. (3) Build Order: update pregolya-mcp annotation (position 19, Wave 2 — topological order valid since pregolya-graph is position 8, Wave 1). (4) Cross-Cutting Dependencies proptest row: add pregolya-mcp [VP-016 STATE-ISOLATION]. Input-hash refresh pending (state-manager task)."
  - "1.7 (BURST-311/F-P202-01/2026-08-17): Rename CheckpointSaver::search_history → CheckpointSaver::fts_search at two live-body sites (F-P202-01 HIGH drift; fts_search is the canonical CheckpointSaver trait method per BC-2.04.008 §Description; search_history is the agent-callable Tool wrapper per BC-2.04.008 PC5). (1) Crate DAG annotation: 'graph::budget uses CheckpointSaver::search_history (BC-2.04.008)' → 'graph::budget uses CheckpointSaver::fts_search (BC-2.04.008)'. (2) Edge Table pregolya-graph→pregolya-checkpoint rationale: 'uses CheckpointSaver::search_history to build' → 'uses CheckpointSaver::fts_search to build'. TD-VSDD-060 sibling sweep: the two corrected sites are the only live-body search_history-as-method occurrences in this file; changelog entry 1.6 retains the old name as historical record (grandfathered per TD-VSDD-091)."
  - "1.6 (FIX-BURST-275/F-P172b-07+08+16+17/2026-07-26): F-P172b-07 — add missing Edge Table row `pregolya-graph → pregolya-checkpoint` (runtime; graph::budget builds ConversationSnapshot via CheckpointSaver::search_history per BC-2.04.008 compaction engine; this edge exists in the Crate DAG nesting but was absent from Edge Table). F-P172b-07 sibling sweep (TD-VSDD-060) — 3-way DAG↔Edge-Table↔Build-Order diff complete: no other missing edges found; all DAG visual nesting edges verified against Edge Table; Build Order Wave 1 position ordering validates (pregolya-graph at position 8 after pregolya-checkpoint at position 5 is correct given this new runtime edge). F-P172b-16 — add `pregolya` facade crate (#1 per ARCH-INDEX Canonical Crate Roster) everywhere it was absent: Crate DAG (terminal re-export node after all impl crates), Edge Table (one row listing all 14 impl crate dependencies), Build Order position 20. F-P172b-17 — fix Crate DAG pregolya-checkpoint annotation: remove 'uses core: CheckpointSaver' (CheckpointSaver is DEFINED in pregolya-checkpoint::checkpoint::saver, not imported from core); correct to 'uses core: PregolyaError'. TD-VSDD-060 sibling sweep: Edge Table pregolya-checkpoint row rationale also corrected (CheckpointSaver removed, PregolyaError only). F-P172b-08 — update Cross-Cutting Dependencies Kani row from 3 crates to 7 crates (add pregolya-vectorstores, pregolya-core, pregolya-prompts, pregolya-tools per VP catalog expansion in D21/D23); update proptest row to add pregolya-splitters, pregolya-core, pregolya-memory (proptest P1 obligations VP-007/VP-008 + memory write-guard invariants require proptest in those crates). OBS-P172b-A — add `specs/module-criticality.md` to inputs."
  - "1.5 (FIX-BURST-273/F-P171a-06/2026-07-25): Add two missing Edge Table rows: (1) pregolya-tools → pregolya-macros (build; #[tool] proc-macro used directly in pregolya-tools implementations per ADR-020 Decision 1 / ADR-008); (2) pregolya-core → pregolya-macros (build; re-exports proc-macro items from pregolya-macros per ADR-008 Decision 2). The Crate DAG annotation and Topological Build Order already documented both edges; the Edge Table was inconsistent. Amend §Invariant: 'pregolya-core MUST NOT depend on any other pregolya crate' to add the proc-macro exception (build-time only, no runtime circular dependency)."
  - "1.4 (FIX-BURST-272/F-P170-06/2026-07-25): ActionRisk dependency adjudication propagation. Crate DAG: update pregolya-tools annotation — ActionRisk is now sourced from pregolya-core (core::action_risk), not pregolya-graph; annotation rewritten to reflect this. Edge Table: update pregolya-tools→pregolya-core rationale to include ActionRisk."
  - "1.3 (FIX-BURST-267/F-P165-04/2026-07-25): Remove spurious DI-012 anchor from §[Section Content] intro sentence — DI-012 is 'Guardrail Coverage at Ingress Boundaries' (unrelated to graph acyclicity). Correct cite to P-06 alone (system-overview §Architecture Principles). DI-NNN sweep: only remaining DI cite is DI-009 at reqwest row in Cross-Cutting Dependencies table, which correctly anchors the outbound HTTP timeout invariant."
  - "1.2 (FIX-BURST-265/F-P163-03/2026-07-25): Propagate D21+D23 21-crate roster. Crate DAG: add pregolya-prompts (D21/ADR-015), pregolya-vectorstores (D21/ADR-014), pregolya-tools (D23/ADR-020) after pregolya-memory. Edge Table: 4 new rows (prompts→core, vectorstores→core, tools→core, tools→sandbox). Topological Build Order: Wave 1 gains pregolya-memory (D23 Wave 2→1, position 6) + pregolya-tools (position 7), now 9 items; Wave 2 loses pregolya-memory, gains pregolya-prompts (position 13) + pregolya-vectorstores (position 14), now 10 items. Add D21/D23 to decisions list."
  - "1.1 (provenance-fix-169/2026-07-17): hash-currency refresh — prd.md updated to v1.2 in same burst; add [Section Content] template compliance fix. No spec content changes."
  - "1.0 (initial): crate dependency DAG authored."
---

# Dependency Graph: pregolya

> All edges are uni-directional. No cycles are permitted (P-06).
> External crates (tokio, axum, reqwest, serde, etc.) omitted for clarity.

## [Section Content]

This file documents pregolya's crate dependency DAG, external integration surfaces, and the acyclicity constraint (P-06). External crates (tokio, axum, reqwest, serde, etc.) are omitted for clarity; only workspace-internal dependency edges are shown.

## Crate DAG

```
pregolya-core
  ├── pregolya-macros         (proc-macro crate; re-exported from core)
  │
  ├── pregolya-graph          (uses core: Runnable, Message, PregolyaError)
  │   ├── pregolya-checkpoint (uses core: PregolyaError; defines CheckpointSaver internally)
  │   │   └── pregolya-server (uses graph + checkpoint: runs + threads + cron)
  │   └── [pregolya-graph → pregolya-checkpoint: graph::budget uses CheckpointSaver::fts_search (BC-2.04.008)]
  │
  ├── pregolya-splitters      (uses core: PregolyaError only; isolated)
  │
  ├── pregolya-sandbox        (uses core: PregolyaError; pregolya-graph uses sandbox)
  │   [pregolya-graph → pregolya-sandbox for tool dispatch]
  │
  ├── pregolya-memory         (uses core: PregolyaError; MemoryStore trait)
  │
  ├── pregolya-prompts        (uses core: Message, Runnable, PregolyaError; D21/ADR-015)
  │
  ├── pregolya-vectorstores   (uses core: Document, Retriever, Embeddings, PregolyaError; D21/ADR-014)
  │
  ├── pregolya-tools          (uses core + sandbox: Tool, ActionRisk, PathGuard, SandboxPolicy; D23/ADR-020)
  │   [depends on pregolya-core + pregolya-sandbox + pregolya-macros; ActionRisk sourced from core::action_risk (relocated per F-P170-06); no pregolya-graph compile-time dep]
  │
  ├── pregolya-openai-sdk     (NO pregolya-core dep; reqwest + serde only) [D17-Q5]
  │   └── pregolya-openai     (uses core: BaseChatModel + openai-sdk)
  ├── pregolya-anthropic-sdk  (NO pregolya-core dep) [D17-Q5]
  │   └── pregolya-anthropic  (uses core: BaseChatModel + anthropic-sdk)
  ├── pregolya-ollama-sdk     (NO pregolya-core dep) [D17-Q5]
  │   └── pregolya-ollama     (uses core: BaseChatModel + ollama-sdk)
  │
  ├── pregolya-standard-tests (dev-deps on each adapter crate + core)
  │
  └── pregolya-mcp            (uses core: Tool, Runnable; uses graph: `CompiledStateGraph` for mcp::graph_tool GraphAgentTool; optional dep on providers)

pregolya-console [PLANNED Wave 3]  (developer console binary; depends on pregolya-server + pregolya-core; BC-2.24.001 {INV-001} forbids pregolya-graph dep)
  [console→server: SpanData type + DebugSpanSource trait (ADR-031 Decision 7); console→core: shared core types]

pregolya-community [post-v1]       (community extensions crate — third-party integrations; LOW criticality; D6 post-v1)
  [depends on: pregolya-core (core types + traits for integration impls)]

pregolya (facade)             (re-exports public API from all impl crates; terminal node)
  [depends on: pregolya-core, pregolya-graph, pregolya-checkpoint, pregolya-server,
   pregolya-splitters, pregolya-sandbox, pregolya-memory, pregolya-prompts,
   pregolya-vectorstores, pregolya-tools, pregolya-openai, pregolya-anthropic,
   pregolya-ollama, pregolya-mcp, pregolya-console]
```

## Edge Table

| From | To | Kind | Rationale |
|------|----|------|-----------|
| pregolya-graph | pregolya-core | runtime | Runnable, Message, ContentBlock, PregolyaError |
| pregolya-graph | pregolya-sandbox | runtime | Tool execution dispatch (via trait object) |
| pregolya-graph | pregolya-checkpoint | runtime | graph::budget uses CheckpointSaver::fts_search to build ConversationSnapshot for compaction engine (BC-2.04.008 / ADR-019); graph::provenance uses CheckpointSaver journal ops (init_guardrail_journal, append_guardrail_entry) for checkpoint-backed GuardrailJournal persistence (BC-2.11.007; F-PDC48-04/DC-48) |
| pregolya-checkpoint | pregolya-core | runtime | PregolyaError; GuardrailEntry (core::guardrail) and associated types GuardrailResult, IngressBoundary for typed CheckpointSaver GuardrailJournal ops (append_guardrail_entry, get_guardrail_journal; BC-2.11.007; checkpoint→core dep allowed; F-PDC48-04/DC-48) |
| pregolya-server | pregolya-graph | runtime | Runs invoke the graph engine |
| pregolya-server | pregolya-checkpoint | runtime | Threads/runs read/write checkpoints |
| pregolya-memory | pregolya-core | runtime | PregolyaError; MemoryStore trait definition |
| pregolya-prompts | pregolya-core | runtime | Message, Runnable, PregolyaError; template composition (ADR-015 Decision 1) |
| pregolya-vectorstores | pregolya-core | runtime | Document, Retriever, Embeddings, PregolyaError (ADR-014 Decision 1) |
| pregolya-tools | pregolya-core | runtime | Tool, ToolOutput, PregolyaError, ActionRisk (core::action_risk, relocated from graph::hitl per F-P170-06) (ADR-020 Decision 1) |
| pregolya-tools | pregolya-sandbox | runtime | PathGuard, SandboxPolicy, sandbox execution (ADR-020 Decision 1) |
| pregolya-tools | pregolya-macros | build | `#[tool]` proc-macro attribute used directly in pregolya-tools tool implementations; direct Cargo dependency required for proc-macro attribute resolution (ADR-020 Decision 1 / ADR-008 Decision 2) |
| pregolya-core | pregolya-macros | build | Re-exports `#[tool]` and related proc-macro items from pregolya-macros for user-facing API; compile-time only — proc-macro crates do not create runtime circular dependencies (ADR-008 Decision 2) |
| pregolya-openai-sdk | (none) | — | Standalone: reqwest + serde only; no pregolya-core [D17-Q5] |
| pregolya-openai | pregolya-core | runtime | BaseChatModel + PregolyaError |
| pregolya-openai | pregolya-openai-sdk | runtime | Wire client for SDK adapter pattern |
| pregolya-anthropic-sdk | (none) | — | Standalone; no pregolya-core dep |
| pregolya-anthropic | pregolya-core | runtime | BaseChatModel + PregolyaError |
| pregolya-anthropic | pregolya-anthropic-sdk | runtime | Wire client |
| pregolya-ollama-sdk | (none) | — | Standalone; no pregolya-core dep |
| pregolya-ollama | pregolya-core | runtime | BaseChatModel + PregolyaError |
| pregolya-ollama | pregolya-ollama-sdk | runtime | Wire client |
| pregolya-standard-tests | pregolya-openai | dev | Conformance test harness |
| pregolya-standard-tests | pregolya-anthropic | dev | Conformance test harness |
| pregolya-standard-tests | pregolya-ollama | dev | Conformance test harness |
| pregolya-standard-tests | pregolya-core | dev | Test trait surface |
| pregolya-mcp | pregolya-core | runtime | Tool, Runnable, PregolyaError |
| pregolya-mcp | pregolya-graph | runtime | `mcp::graph_tool` wraps `CompiledStateGraph` as a `DynTool`; `GraphRunner::run` dispatches to the compiled graph at invocation time; new dep introduced by ADR-029 mcp::graph_tool module (BC-2.09.008 / SS-09) |
| pregolya-splitters | pregolya-core | runtime | PregolyaError for Result |
| pregolya-macros | (none) | — | Proc-macro crate; no pregolya-core dep at compile time |
| `pregolya` (facade) | pregolya-core | runtime | Public API re-export: re-exports core trait surface, message types, error types |
| `pregolya` (facade) | pregolya-graph | runtime | Public API re-export: StateGraph, CompiledStateGraph, graph execution |
| `pregolya` (facade) | pregolya-checkpoint | runtime | Public API re-export: CheckpointSaver, backend types |
| `pregolya` (facade) | pregolya-server | runtime | Public API re-export: Axum server builder, RunConfig |
| `pregolya` (facade) | pregolya-splitters | runtime | Public API re-export: RecursiveSplitter, PariTySplitter |
| `pregolya` (facade) | pregolya-sandbox | runtime | Public API re-export: SandboxBackend, SandboxPolicy |
| `pregolya` (facade) | pregolya-memory | runtime | Public API re-export: MemoryStore, SkillStore |
| `pregolya` (facade) | pregolya-prompts | runtime | Public API re-export: PromptTemplate, ChatPromptTemplate, injection_guard |
| `pregolya` (facade) | pregolya-vectorstores | runtime | Public API re-export: VectorStore, VectorStoreRetriever |
| `pregolya` (facade) | pregolya-tools | runtime | Public API re-export: ReadFileTool, WriteFileTool, BashTool, GrepTool |
| `pregolya` (facade) | pregolya-openai | runtime | Public API re-export: ChatOpenAI, EmbeddingsOpenAI |
| `pregolya` (facade) | pregolya-anthropic | runtime | Public API re-export: ChatAnthropic |
| `pregolya` (facade) | pregolya-ollama | runtime | Public API re-export: ChatOllama, EmbeddingsOllama |
| `pregolya` (facade) | pregolya-mcp | runtime | Public API re-export: MultiServerMcpClient, MCP tool adapters |
| pregolya-community [post-v1] | pregolya-core | runtime | Core types + traits for third-party integration impls; LOW criticality (D6 post-v1; pre-existing gap — not a D-356 defect; DC-52) |
| pregolya-console [PLANNED] | pregolya-server | runtime | `SpanData` type + `DebugSpanSource` trait (console→server dep direction per ADR-031 Decision 7; dependency inversion breaks console→server→console cycle); BC-2.24.001 {INV-001}; S-console-02 |
| pregolya-console [PLANNED] | pregolya-core | runtime | Shared core types per BC-2.24.001 {INV-001}; S-console-01 |
| `pregolya` (facade) | pregolya-console | runtime | facade `pregolya console` subcommand calls `pregolya_console::run_console(config)`; compile-time dep (S-console-01 AC-001; F-2/DC-50) |

## Cross-Cutting Dependencies (Shared by All Crates)

| Crate | Role |
|-------|------|
| `tokio` | Async runtime (all crates) |
| `serde` + `serde_json` | Serialization (all crates) |
| `rmp-serde` / `msgpack` | Checkpoint wire format (pregolya-checkpoint; ADR-002) |
| `reqwest` | HTTP client (provider crates + pregolya-mcp; DI-009 timeout mandatory) |
| `axum` | HTTP server (pregolya-server only) |
| `tracing` | Structured logging (all crates) |
| `kani` | Formal verification harnesses (pregolya-graph [VP-001/VP-011], pregolya-checkpoint [VP-002], pregolya-sandbox [VP-003], pregolya-vectorstores [VP-009], pregolya-core [VP-010/VP-012], pregolya-prompts [VP-006], pregolya-tools [VP-013]; dev-dep in all 7) |
| `proptest` | Property tests (pregolya-graph [reducers/clock], pregolya-checkpoint [clock/backends], pregolya-splitters [boundary invariants], pregolya-core [VP-007 LcSerializable round-trip, VP-008 dimensionality contract], pregolya-memory [write-guard invariants], pregolya-mcp [VP-016 STATE-ISOLATION], pregolya-prompts [VP-006-B injection_guard Multi-Pair FewShotExamples]; dev-dep) |

## Topological Build Order (Wave 1 → Wave 2 → Wave 3)

```
Wave 1:
  1. pregolya-macros           (proc-macro crate; no internal deps)
  2. pregolya-core             (foundation; depends on macros for re-export)
  3. pregolya-splitters        (parallel; depends only on core)
  4. pregolya-sandbox          (parallel; depends only on core)
  5. pregolya-checkpoint       (depends on core)
  6. pregolya-memory           (parallel; depends only on core; promoted Wave 2→1 per D23 item 3)
  7. pregolya-tools            (depends on core + sandbox; D23/ADR-020)
  8. pregolya-graph            (depends on core + sandbox)
  9. pregolya-server           (depends on graph + checkpoint)

Wave 2:
  10. pregolya-openai-sdk      (standalone; no pregolya-core dep) [D17-Q5]
  11. pregolya-anthropic-sdk   (standalone) [D17-Q5]
  12. pregolya-ollama-sdk      (standalone) [D17-Q5]
  13. pregolya-prompts         (depends on core; D21/ADR-015)
  14. pregolya-vectorstores    (depends on core; D21/ADR-014)
  15. pregolya-openai          (depends on core + openai-sdk)
  16. pregolya-anthropic       (depends on core + anthropic-sdk)
  17. pregolya-ollama          (depends on core + ollama-sdk)
  18. pregolya-standard-tests  (depends on core + all adapter crates)
  19. pregolya-mcp             (depends on core + graph [mcp::graph_tool/`CompiledStateGraph`] + optional providers; graph at position 8 satisfies topological order)

Wave 3 [PLANNED / post-v1]:
  20. pregolya-community [post-v1] (depends on pregolya-core [position 2]; community extensions crate; D6 post-v1; LOW criticality)
  21. pregolya-console [PLANNED] (depends on pregolya-server [position 9] + pregolya-core [position 2]; BC-2.24.001 {INV-001} forbids pregolya-graph dep; ADR-031 Decision 7)
  22. pregolya (facade)        (re-exports all impl crates including pregolya-community + pregolya-console; terminal node; depends on all above)
```

**Note:** pregolya-graph depends on pregolya-sandbox for tool dispatch. However,
sandbox is in the same Wave 1 build. The dependency is via a trait object
(`dyn SandboxBackend`), enabling pregolya-sandbox to compile independently before
pregolya-graph binds it. pregolya-tools also depends on pregolya-sandbox
(ADR-020 Decision 1) and builds after sandbox (position 7 after position 4).

## Invariant: No Circular Dependencies

The crate DAG is strictly acyclic. Enforced by Cargo's compiler. Any proposal to add an
edge that would create a cycle requires an ADR and architectural review. Key cycles to
prevent:

- pregolya-core MUST NOT depend on any other pregolya crate. Exception: `pregolya-macros` is a `proc-macro = true` crate; its compilation model is compile-time only (it produces no runtime code in dependents) and does not create circular runtime dependencies. Build order: pregolya-macros(1) → pregolya-core(2) (ADR-008 Decision 2).
- pregolya-checkpoint MUST NOT depend on pregolya-graph (graph depends on checkpoint, not vice versa)
- Provider crates MUST NOT depend on each other

## Feature Flag Interaction

Cargo features create conditional dependencies:
- `checkpoint-sqlite` (default): `pregolya-checkpoint` + `rusqlite`
- `checkpoint-postgres`: + `tokio-postgres`
- `checkpoint-memory`: no additional dep
- `sandbox-wasm` (default): `pregolya-sandbox` + `wasmtime`
- `sandbox-container`: + Docker API client
- `server`: `pregolya-server` included in workspace binary builds

See ADR-007 for full feature interaction rules.
