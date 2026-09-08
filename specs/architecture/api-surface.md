---
document_type: architecture-section
level: L3
section: api-surface
version: "1.32"
status: active
producer: architect
timestamp: 2026-09-07T00:00:00Z
changelog:
  - "1.32 (D-356/DC-07/2026-09-07, architect): F-PDC07-01 — sweep debug_api_key → debug_route_key (5 sites: changelog 1.31, §Security, Debug Endpoints preamble blockquote, DC-02 blockquote, Cargo Feature Flags table). F-PDC07-02 — §Security updated to state both auth behaviors: (a) empty/absent debug_route_key → E-SERVER-013 InvalidDebugRouteKey startup-refusal before HTTP listener binds; (b) valid key + unauthenticated request → E-SERVER-004 DebugRouteUnauthorized 403 at runtime. input-hash unchanged (inputs did not change)."
  - "1.31 (D-356/DC-02/2026-09-07, architect): F-PDC02-05 — §Security note updated: debug_route_key is now MANDATORY (not opt-in) when debug-endpoints feature is enabled; unauthenticated /debug/* returns 403 E-SERVER-004 DebugRouteUnauthorized. DNS-rebinding/CSRF-to-127.0.0.1 rationale added (SpanData exposes llm_request/llm_response; SEC-BOUND-001 parity; BC-2.24.002). Companion: ADR-031 D6-2 and §Security interaction updated. input-hash unchanged (inputs did not change)."
  - "1.30 (D-356/2026-09-06, architect): F1 consistency fix — three debug endpoint error codes corrected: E-SERVER-020→E-SERVER-023 (DebugExporterNotConfigured, minted error-taxonomy.md v1.72) on GET /debug/trace/session/{session_id} and GET /debug/trace/{event_id}; E-SERVER-021→E-SERVER-009 (AssistantNotFound, existing code) on GET /assistants/{id}/graph. Per source-of-truth precedence rule 3: error-taxonomy.md supersedes prose for error code assignments. input-hash unchanged (inputs did not change)."
  - "1.29 (D-356/2026-09-06, architect): D-356 dev-console scope expansion — three new debug endpoints added (feature-gated debug-endpoints, default OFF): GET /debug/trace/session/{session_id}, GET /debug/trace/{event_id}, GET /assistants/{id}/graph. debug-endpoints Cargo feature added (Security-annotated, NO default). SSE transport formally confirmed for run streaming (ADR-031 §Decision 3 — no WebSocket). input-hash refreshed from pre-existing drift d55270a→c34f721."
  - "1.28 (R44/F-P2A184-03/2026-08-30): F-P2A184-03 [MED] §Public Rust Traits DynTool blockquote — stale 'impl Stream return' description corrected. OLD: 'which exposes `stream()` (opaque `impl Stream` return)'. NEW: 'which exposes `stream()` (RPITIT `impl Future` return — opaque, non-dyn-compatible)'. Post-R43, `Runnable::stream` returns an RPITIT `impl Future` whose output boxes the stream via `Pin<Box<dyn Stream...>>`; describing it as 'impl Stream return' is inaccurate. The E0038 non-object-safety conclusion for `dyn Tool` is unchanged. input-hash refreshed."
  - "1.27 (round-25/F-P2A111-01+F-P2A111-02/2026-08-28): §Crates with No Public Traits — `pregolya-mcp` description updated to reflect the nine-module canonical structure established by the round-25 module→file mapping decision. Listed by role: invocation stack (mcp::client/session/interceptor), tool adaptation (mcp::discovery with canonical `pregolya-mcp/src/discovery.rs`), security seam (mcp::ingress DI-012 HIGH with `ingress.rs`), error handling (mcp::exception), server-side (mcp::sanitize/graph_tool/server). Consumer types updated: `DynTool` and `GuardrailHook` from pregolya-core (not `Tool` — Tool is non-object-safe E0038; DynTool is the wire type; GuardrailHook is the ingress seam). input-hash refreshed."
  - "1.26 (fix-burst-P2A026/P2A026-02/2026-08-22): Move StreamEvent row from §pregolya-graph Public Types to §pregolya-core Public Types. Canonical home is pregolya-core (`core::events`) per ADR-006 §Consequences ('StreamEvent is a public type in pregolya-core') and module-decomposition.md §F-P2A017-02 fix (v1.45 corrected the erroneous graph-defines-StreamEvent claim). Presenting it under §pregolya-graph Public Types mis-stated crate ownership. Inclusion criterion note extended to document StreamEvent's criterion (b) rationale. Sweep: all four §pregolya-graph Public Types rows verified — StateGraph (SS-02/graph::definition), GraphConfig (SS-03/graph::scheduler), Command (SS-05/graph::hitl) are correctly attributed; only StreamEvent was misattributed. No other cross-section misattributions found."
  - "1.25 (FIX-BURST-291/D-134-corpus-sweep/2026-08-16): Fix phantom §-citation in RunnableConfig table row. 'BC-2.12.003 §Run-Config Merge Precedence Invariant' → 'BC-2.12.003 §Invariants (Run-Config Merge Precedence)'. Rationale: BC-2.12.003 has no §Run-Config Merge Precedence Invariant subheading; the rule is a list item within §Invariants. Also sibling-fixed in ADR-021 Decision 2 body. input-hash refreshed (inputs changed since last hash computation; pre-existing drift resolved)."
  - "1.24 (burst-290/F-180-01+02+08/2026-08-16): Three phantom/malformed ADR §-citation fixes. (1) F-180-08 — §Public Rust Traits blockquote line 77: `ADR-005 §Adjacent Adjudications corrected list` → `ADR-005 §Adjacent Trait Object-Safety Adjudications` (real heading per ADR-005). (2) F-180-01 — §Public Traits (pregolya-vectorstores) blockquote line 175: chained double-§ `ADR-014 §Decision 2 §Object-safety` split into `ADR-014 §Decision 2` and `ADR-005 §Adjacent Trait Object-Safety Adjudications` per ADR-022 §Decision 5 prescribed fix. (3) F-180-02 — §Error Type line 282: `ADR-010 §impl PregolyaError — sole sanctioned paths` → `ADR-010 §Error-Construction Notation Canon` (ADR-022 §Form B — impl block identifier is not a heading; real governing section is Error-Construction Notation Canon)."
  - "1.23 (burst-289/F-178-01/2026-08-16): StreamEvent variant count corrected 15→16 in §pregolya-graph Public Types table. Variant 16 (StreamEvent::Error) was added in burst-288 per EC-005 mandate; api-surface.md was not updated in that burst. BC-2.06.001 §Postconditions (PC2) is the authoritative enumeration."
  - "1.22 (fix-burst-283/F-P175-C113/ADR-021-Decision-2/2026-07-30): RunnableConfig row updated — add configurable: Option<HashMap<String, Value>> field. LangGraph-parity configurable map (semport §RunnableConfig mapping §11); enables Assistant 'reusable agent persona' design in BC-2.12.002. Graphs read model, tool-set, system-prompt overrides from this map at execution time. BC anchor: BC-2.12.002, ADR-021 Decision 2."
  - "1.21 (FIX-BURST-280-corr/F-P175-A24-followup/2026-07-28): Add §Public Functions (pregolya-core) section registering `validate_embedding_batch` as a `pub` free function in `core::embeddings`. Visibility `pub` — cross-crate callers are pregolya-openai and pregolya-ollama provider embeddings impls. BC anchors: BC-2.22.001 PC-2, INV-2, EC-003, EC-004. Error anchor: E-EMBED-001. VP anchor: VP-008 (proptest P1). Resolves F-P175-A24-followup: the function was introduced by VP-008 redesign in FIX-BURST-280 but was absent from api-surface.md, making a VP body its sole signature authority (the F-P175-B117 phantom-signature defect class). TD-VSDD-060 sibling sweep included in burst report."
  - "1.20 (FIX-BURST-278/L9b-de-pin/2026-07-28): L9b de-pin: one version-pin-to-section-anchor conversion in the FIX-BURST-277-WAVE-B-errata changelog entry. ADR-005 version pin replaced with ADR-005 §Adjacent Trait Object-Safety Adjudications (Wave C migration list cross-reference)."
  - "1.19 (FIX-BURST-278/Wave-C-S4/2026-07-28): S4 canon — three changelog/body lines citing Arc<dyn pregolya_core::Tool> or Arc<dyn Tool> as migration origins annotated with non-object-safe (E0038) qualifier to satisfy verify-signature-canon.sh S4 gate exemption. All three sites are classification (b): hazard-describing prose and migration routing notes, not live signatures requiring DynTool conversion. The live DynTool migration blockquote already reads DynTool in the canonical final form; the non-object-safe annotations clarify the prohibited origin type in context."
  - "1.18 (FIX-BURST-278/F-P175-D48+D202/2026-07-28): Two findings closed. (1) F-P175-D48 — §Public Traits (pregolya-vectorstores) blockquote: `as_retriever` signature receiver corrected to `self: Arc<Self>` per ADR-014 §Decision 2 (dyn-compatible receiver; the reference-to-Arc form causes E0038). (2) F-P175-D202 — DynTool migration blockquote count corrected from 2→3 sites: add `BC-2.09.007 ToolRegistry` as the third migration site (per ADR-005 §Wave C migration list)."
  - "1.17 (FIX-BURST-277-WAVE-B-errata/2026-07-28): Correct Wave C DynTool migration list blockquote — prior v1.16 cited BC-2.05.003/BC-2.05.004/BC-2.08.010/BC-2.09.001 as `dyn Tool` sites; corpus re-verification found zero `dyn Tool` in BC-2.05.003/BC-2.05.004/BC-2.08.010 and ToolCallPreview never had a `tool` field. Corrected list: BC-2.09.001 (Description+PC2) and BC-2.09.002 (PC1) — both cite `Arc<dyn pregolya_core::Tool>` (non-object-safe E0038; migrate to DynTool) in MCP tool discovery/invocation context. ADR-005 §Adjacent Trait Object-Safety Adjudications carries the same correction."
  - "1.16 (FIX-BURST-277-WAVE-B/2026-07-28): Three api-surface propagations from fix-burst 277. (1) DynTool — add DynTool row to §Public Rust Traits (pregolya-core): DynTool is the type-erased object-safety seam for Arc<dyn Tool> dispatch; Tool inherits Runnable::stream (opaque impl Stream return) and Runnable::pipe (impl Runnable + where Self: Sized), making direct dyn Tool non-trivially non-object-safe (E0038 fires on direct dyn Tool); blanket impl: T: Tool + Send + Sync + 'static auto-implements DynTool; SS-08, BC-2.08.010 (ADR-005 §Adjacent Trait Object-Safety Adjudications). (2) VectorStoreRetriever lifetime + as_retriever fallibility — fix stale blockquote in §Public Traits (pregolya-vectorstores): remove the lifetime annotation from VectorStoreRetriever; document store: Arc<dyn VectorStore> field enabling Retriever + 'static coercion so Arc<dyn Retriever> compiles; document fallible signature as_retriever(self: Arc<Self>) -> Result<VectorStoreRetriever, PregolyaError> with Err(E-VS-003) on invalid config (ADR-014 Decision 2). (3) PregolyaError constructor — add construction note to §Error Type: PregolyaError::new(component, category, retry_hint, code, message: impl Into<String>) and .with_source(Arc<dyn Error + Send + Sync>) are sole sanctioned construction paths; struct literal construction barred by #[non_exhaustive] from external crates (ADR-010 §impl PregolyaError)."
  - "1.15 (FIX-BURST-276-TD091/2026-07-27): TD-VSDD-091 anti-volatile-pin repair — §Error Type source field inline comment: replace live-body sibling-artifact version pin with stable section anchor. ADR-010 §Decision (the section containing the PregolyaError struct definition and the Arc-not-Box source field rationale) replaces a specific version number. Sibling-sweep of this file live body: no additional version pins found."
  - "1.14 (FIX-BURST-276-WAVE-B3/F-P173-201+203+204+205+206+207/2026-07-27): Six HIGH findings from P1D-173. F-P173-201 — move BudgetConfig (SS-10/core::budget), CompactionTrigger (SS-10/core::budget), and ProvenanceTag (SS-11/core::guardrail) from §pregolya-graph Public Types to §pregolya-core Public Types; all three are pregolya-core types — cataloguing them under graph implied a circular core→graph dependency (D-24/BudgetPolicy/ADR-009, GuardrailHook/ADR-014 Decision 6, MemoryWriteGuard/ADR-012 relocation precedents confirm pattern; ProvenanceTag must be in pregolya-core because GuardrailHook::evaluate in core takes it as a parameter); inclusion criterion note updated. F-P173-203 — remove standalone §pregolya-graph Public Types row for CompactionEvent; CompactionEvent is a StreamEvent enum variant, not a top-level type; StreamEvent row already reads '15 variants ... CompactionEvent'; variant count 15 confirmed intact after deletion. F-P173-204 — PathGuard row in §Public Traits and Types (pregolya-tools): E-TOOLS-001 → E-SBXD-001 on workspace escape; BC-2.13.004 PC4 raises E-SBXD-001 at the sandbox layer (module-decomposition.md sandbox::path_guard row confirms); E-TOOLS-001 is the tool-layer translation per interface-definitions.md F-P173-601; crate attribution pregolya-sandbox/SS-13 and VP-003 anchor unchanged. F-P173-205 — add five missing D21 pregolya-core traits to §Public Rust Traits (pregolya-core): Retriever (SS-20/core::retriever, ADR-014 Decision 1, BC-2.20.001-003), Embeddings (SS-22/core::embeddings, ADR-017 Decision 2, BC-2.22.001-003), LcSerializable (SS-19/core::serializable, ADR-016 Decision 1+2, BC-2.19.001-006), MemoryWriteGuard (SS-15/core::write_guard, ADR-012 D20, BC-2.15.005), ToolCallDialect (SS-08/pregolya-core, ADR-018, BC-2.08.013; interface-definitions.md §ToolCallDialect source confirms pregolya-core placement); add SkillStore (SS-15/memory::skills, ADR-012 Decision 1, BC-2.15.004) to §Public Traits (pregolya-memory); add §Public Traits (pregolya-graph) with PreToolCallHook (SS-05/graph::hitl, ADR-018 Decision 1, BC-2.05.007); add §Public Traits (pregolya-vectorstores) with VectorStore (SS-21, ADR-014 Decision 2, BC-2.21.001-004) and VectorStoreFactory (SS-21, ADR-014 Decision 2, BC-2.21.001); add explicit no-public-traits notes for pregolya-prompts, pregolya-mcp, pregolya-sandbox, pregolya-splitters, pregolya-macros, SDK crates, provider impl crates, and pregolya-standard-tests. TD-VSDD-060 sibling sweep: other architecture files do not enumerate per-crate trait sections — no further changes required outside this file. F-P173-206 — add 4 missing Cargo Feature Flags (total 6→10): sandbox-process (off; security: NOT enforcing — no filesystem/network/memory isolation; accessible ONLY via Sandbox::unsafe_process_no_isolation(); BC-2.13.001/BC-2.13.002), mcp (off; BC-2.09.001), budget (on; BC-2.10.001), guardrail (on; BC-2.11.001). Derivation: cross-checked against interface-definitions.md §Cargo Feature Flags (authoritative 10-flag list: checkpoint-sqlite, checkpoint-memory, checkpoint-postgres, sandbox-wasm, sandbox-container, sandbox-process, server, mcp, budget, guardrail); total confirmed 10. F-P173-207 — apply F-P170-03 crate qualification to sibling types PreToolDecision and ToolCallPreview in §Public Traits and Types (pregolya-tools): both defined in pregolya-graph::hitl per ADR-018 Decision 1; D-24 relocated ActionRisk to pregolya-core but the three HITL types (PreToolCallHook/PreToolDecision/ToolCallPreview) remained in graph::hitl."
  - "1.13 (FIX-BURST-276-WAVE-B1/F-P173-202+210+619+214/2026-07-27): F-P173-202 (HIGH) — add missing `message` and `source` fields to §Error Type `PregolyaError` struct display: `message: String` (Human-readable; MUST NOT contain credentials per DI-010) and `source: Option<Arc<dyn std::error::Error + Send + Sync>>` (causal error chain; MUST NOT be exposed in HTTP responses; `Arc` not `Box` — Arc preserves Clone per F-P173-211 adjudication in ADR-010 §Decision). F-P173-210/619 — add `#[non_exhaustive]` attribute to PregolyaError in §Error Type; all sibling public API surface types carry `#[non_exhaustive]` per CLAUDE.md Code Conventions. F-P173-214 (LOW) — fix stale `17→18` transition delta: `gate count 17→18` → `gate count 18` (transition completed in v1.7/D23; delta notation no longer meaningful)."
  - "1.12 (FIX-BURST-273/F-P171a-19/2026-07-25): Adjudicate `ActionRisk` row inclusion criterion in §pregolya-core Public Types. `ActionRisk` has a row because: (a) it is consumed cross-crate by pregolya-tools as a standalone API input (`ToolConfig::override_risk(risk: ActionRisk)`) and must be addressable without a pregolya-graph dependency; (b) no other pregolya-core type currently meets criterion (a) — BoundaryType/IngressContent/GuardrailResult are only consumed through `GuardrailHook::evaluate` trait method signatures, not as standalone parameters in cross-crate public APIs. Inclusion criterion documented in §pregolya-core Public Types note."
  - "1.11 (FIX-BURST-272/F-P170-03+04+06/2026-07-25): Three api-surface fixes in one burst. (1) F-P170-03 — Remove `PreToolCallHook` from §Public Rust Traits (pregolya-core); ADR-018 Decision 1 places it in `pregolya-graph::hitl`, not core; putting it in core was exactly the 'orphan definitions module' alternative ADR-018 rejected by name. Fix pregolya-tools section note: 'trait is defined in core, tools crate provides impls' → 'trait defined in pregolya-graph::hitl per ADR-018 Decision 1'. (2) F-P170-04 — Correct PathGuard SS-23 → SS-13 with amended BC anchor; PathGuard is owned by pregolya-sandbox/SS-13/BC-2.13.004 and is the CRITICAL path-guard module with VP-003 Kani P0. (3) F-P170-06 adjudication (option b) — ActionRisk relocates to pregolya-core (core::action_risk) per dependency-inversion precedent; pregolya-tools needs ActionRisk at compile time without depending on pregolya-graph. Move ActionRisk row from pregolya-tools section to pregolya-core Public Types section; SS-23 → SS-05 (HITL risk tiering); add BC-2.05.006 anchor."
  - "1.10 (FIX-BURST-266/OBS-P164-B/2026-07-25): Adjudicate and fix Tool trait row mixed anchoring. `Tool | pregolya-core | SS-09 | BC-2.09.002` was wrong on both anchors: SS-09 is pregolya-mcp (the CONSUMER crate — BC-2.09.002 PC1 takes `Arc<dyn pregolya_core::Tool>` (non-object-safe E0038) as input); BC-2.09.002 is 'ToolInvocation Routing to Correct MCP Server Transport' (MCP routing, not trait definition). Adjudicated: Tool trait is DEFINED in `pregolya-core/src/tool.rs` (BC-2.08.010 Architecture Anchors), owned by SS-08 (macros::tool module is SS-08 per module-decomposition.md; BC-2.08.010 lives in ss-08/). Correct row: `Tool | pregolya-core | SS-08 | BC-2.08.010`. Parallel to BaseChatModel | pregolya-core | SS-08 pattern. Trait-row audit: all other 6 pregolya-core trait rows (Runnable/SS-01, BaseChatModel/SS-08, GuardrailHook/SS-11, BudgetPolicy/SS-10, PreToolCallHook/SS-05, CompactionPolicy/SS-10) are correctly definition-anchored — no further mixing found."
  - "1.9 (burst-242/2026-07-23): Fix-242 Command-notation sweep — convert residual enum-style notation Command::resume(value) in §pregolya-graph Public Types table to canonical struct kwarg form Command(resume=value). Canonical form per BC-2.05.004 v1.5 + F-P120-01 adjudication."
  - "1.8 (burst-238/2026-07-23): F-P138-02 stale-handoff sweep — remove stale Note on api-surface.md §Error Type: 'ADR-010 amendment required to add TOOLS variant — architect task per error-taxonomy.md §TOOLS delegation note.' ADR-010 v1.3 (burst-232) already registered TOOLS as component 17; error-taxonomy.md §TOOLS delegation note was removed in v1.32 (burst-233 F-P133-09); TOOLS already listed as 17th component in the enum. Dangling cross-reference to removed delegation note deleted."
  - "1.7 (D23/2026-07-22): Add D23 API surfaces. (1) pregolya-core Public Traits: +PreToolCallHook (SS-05, BC-2.05.007), +CompactionPolicy (SS-10, BC-2.10.005/006). (2) pregolya-graph Public Types: StreamEvent BC range 001–002→001–006 + 15-variant count noted; +CompactionTrigger (SS-10, BC-2.10.005), +CompactionEvent (SS-10, BC-2.10.006/BC-2.06.006). (3) §Public Traits and Types (pregolya-tools) added: ActionRisk, PreToolDecision, ToolCallPreview, PathGuard, ReadFileTool, WriteFileTool, EditFileTool, ListDirTool, BashTool (VP-013), GrepTool. (4) Component enum 16→17 (+TOOLS); #[non_exhaustive] gate count 17→18. ADR-010 amendment delegated to architect."
  - "1.6 (D21/Batch-3b-i/2026-07-20): Component enum expanded 12→16 per ADR-010 v1.1. Added TMPL (pregolya-prompts), SRLZ (pregolya-core::serializable), VS (pregolya-vectorstores), EMBED (pregolya-core::embeddings) to Component list. #[non_exhaustive] gate count 13→17 (16 named variants + Custom = 17). Implementer updates ALL three gate locations (gate crate, expected count constant, expected symbol list) when creating pregolya-core/src/error.rs at Wave 0 per CLAUDE.md non-exhaustive gate rule."
  - "1.5 (F-P115-02 ripple, 2026-07-19): Extend CheckpointSaver BC anchor range from BC-2.04.001–006 to BC-2.04.001–007. BC-2.04.007 is now a live anchor because the `put` method (added to the trait per F-P115-02 adjudication) carries BC-2.04.007 PC1/INV-1 encryption-parity obligations. Sweep: no method-count enumerations or get_next_version absence claims present in this file — api-surface.md delegates all signatures to interface-definitions.md."
  - "1.4 (F-P92-02, 2026-07-17): Add §pregolya-core Public Types table. RunnableConfig gains budget_config: Option<BudgetConfig> (OPTION A — BC-2.10.004 PC6 / BC-2.10.003 PC7/TV-004). Row documents all four known RunnableConfig fields (recursion_limit, thread_id, budget_config, context_mutations)."
  - "1.3 (provenance-fix-169/2026-07-17): hash-currency refresh — prd.md updated to v1.2 in same burst; add [Section Content] template compliance fix. No spec content changes."
  - "1.2 (ADV-P1D-PASS-64): F-P64-01 adjudication — default port 7437 is mandated; replaced 'no default port mandated' with authoritative default per interface-definitions.md §Base URL."
  - "1.1 (ADV-P1D-PASS-25): F-P25-04 to_problem_detail()→to_problem() method name correction."
  - "1.0 (initial / 2026-07-13): initial API surface authored — pregolya-core Public Traits, pregolya-server HTTP endpoint catalog, and pregolya-server Public Types. NOTE (F-P104-01, 2026-07-18): reconstructed from commit ef41eda (burst 73, 2026-07-13) — no initial changelog row was written at authoring."
phase: 1b
inputs:
  - .factory/specs/prd.md
  - .factory/specs/prd-supplements/interface-definitions.md
input-hash: "4c5f776"
traces_to: ARCH-INDEX.md
decisions: [D13, D17]
---

# API Surface: pregolya

> Full signatures in `prd-supplements/interface-definitions.md`. This file is the
> architecture-level summary: which traits belong to which crate/subsystem, and
> the HTTP endpoint catalog for pregolya-server.

## [Section Content]

This file documents pregolya's public API surface: the public Rust traits by crate/subsystem, and the HTTP endpoint catalog for pregolya-server. It is the architecture-level summary; full signatures live in `prd-supplements/interface-definitions.md`.

## Public Rust Traits (pregolya-core)

| Trait | Crate | SS | BC Anchors |
|-------|-------|----|-----------|
| `Runnable<Input, Output>` | pregolya-core | SS-01 | BC-2.01.003, BC-2.01.004 |
| `BaseChatModel` | pregolya-core | SS-08 | BC-2.08.001–005 |
| `GuardrailHook` | pregolya-core | SS-11 | BC-2.11.002–004 |
| `BudgetPolicy` | pregolya-core | SS-10 | BC-2.10.001 |
| `Tool` | pregolya-core | SS-08 | BC-2.08.010 |
| `DynTool` | pregolya-core (`core::tool`) | SS-08 | BC-2.08.010 |
| `CompactionPolicy` | pregolya-core | SS-10 | BC-2.10.005, BC-2.10.006 |
| `Retriever` | pregolya-core | SS-20 | BC-2.20.001–003 |
| `Embeddings` | pregolya-core | SS-22 | BC-2.22.001–003 |
| `LcSerializable` | pregolya-core | SS-19 | BC-2.19.001–006 |
| `MemoryWriteGuard` | pregolya-core | SS-15 | BC-2.15.005 |
| `ToolCallDialect` | pregolya-core | SS-08 | BC-2.08.013 |

> `DynTool` is the type-erased object-safety seam per ADR-005
> §Adjacent Trait Object-Safety Adjudications (option b). `Tool` inherits from `Runnable`,
> which exposes `stream()` (RPITIT `impl Future` return — opaque, non-dyn-compatible) and `pipe()` (`impl Runnable` +
> `where Self: Sized`), making `dyn Tool` non-trivially non-object-safe (E0038). `DynTool`
> re-exposes the tool API via object-safe `invoke_dyn(&self, Value) -> Result<Value, PregolyaError>`.
> A blanket impl provides `T: Tool + Send + Sync + 'static → DynTool` automatically.
> `Arc<dyn DynTool>` is the composition seam for all dynamic dispatch sites.
> Wave C BC-side migration (ADR-005 §Adjacent Trait Object-Safety Adjudications — 3 sites):
> `BC-2.09.001` (Description + PC2), `BC-2.09.002 PC1`, and `BC-2.09.007` (ToolRegistry:
> `Option<Arc<dyn Tool>>` → `Option<Arc<dyn DynTool>>`) — `Arc<dyn pregolya_core::Tool>` (non-object-safe E0038)
> → `Arc<dyn DynTool>` (MCP tool discovery/invocation BCs; BC-2.09.007 ToolRegistry).

## pregolya-core Public Types

| Type | Role | SS | BC Anchors |
|------|------|----|-----------|
| `RunnableConfig` | Per-invocation config: `recursion_limit` (default 25), `thread_id`, `budget_config: Option<BudgetConfig>` (per-run budget override — `None` inherits `GraphConfig::budget_config`; `Some` overrides for that run; used by `BudgetResume::Extend`), `context_mutations: Option<ContextMutationConfig>`, `configurable: Option<HashMap<String, Value>>` (graph-specific key-value overrides — model, tools, system_prompt; LangGraph-parity field; graphs read their parameters at execution time via this map; merge semantics: run-level keys win over Assistant-stored keys per BC-2.12.003 §Invariants (Run-Config Merge Precedence); ADR-021 Decision 2) | SS-01 | BC-2.01.003 PC5, BC-2.10.003 PC7/TV-004, BC-2.10.004 PC6, BC-2.15.006 PC1, BC-2.12.002 |
| `ActionRisk` | Risk classification enum for tool dispatch; 4 variants: `ReadOnly`/`Low`/`Medium`/`High` (`#[non_exhaustive]`); relocated from `pregolya-graph::hitl` to `pregolya-core` (`core::action_risk`) per dependency-inversion precedent — `pregolya-tools` consumes it at compile time without a `pregolya-graph` dep (F-P170-06/ADR-020 adjudication) | SS-05 | BC-2.05.006, BC-2.23.005 |
| `BudgetConfig` | Budget ceiling + on_ceiling policy; embedded in `RunnableConfig.budget_config` (per-run override) and `GraphConfig.budget_config` (graph-level default); defined in `core::budget` (pregolya-core — ADR-009 Option 3) | SS-10 | BC-2.10.001 |
| `CompactionTrigger` | `Disabled \| OnWatermark{fraction: f64} \| OnMessageCount{count: usize} \| OnTokenCount{tokens: u64}`; field in `BudgetConfig.compaction_trigger`; defined in `core::budget` (pregolya-core — ADR-019 Decision 1) | SS-10 | BC-2.10.005 |
| `ProvenanceTag` | Content source tag attached at every ingress boundary; parameter to `GuardrailHook::evaluate` in pregolya-core; defined in pregolya-core (`core::guardrail` area — cannot be in pregolya-graph without creating a circular core→graph dependency) | SS-11 | BC-2.11.001 |
| `StreamEvent` | Streaming event enum; run_id + parent_ids; 16 variants (D23 adds ToolApprovalRequest/Resolved/CompactionEvent as variants 13–15; burst-288 adds StreamEvent::Error as 16th variant — BC-2.06.001 §Postconditions PC2); defined in `core::events` (pregolya-core) per ADR-006 §Consequences; emitted by `graph::event_emitter`, consumed cross-crate by pregolya-server SSE streaming endpoint | SS-06 | BC-2.06.001–006 |

> **Public Types inclusion criterion (F-P171a-19 adjudication, extended F-P173-201, P2A026-02):** A type earns a row in
> §pregolya-core Public Types when (a) it is consumed by a downstream crate as a
> standalone API input or output independent of any trait method signature — i.e., the
> downstream crate passes it directly as a function argument or struct field without
> going through a trait; OR (b) it is defined in pregolya-core but was previously
> misattributed to pregolya-graph, implying a circular core→graph dependency.
> `ActionRisk` meets criterion (a): `pregolya-tools` passes it directly to
> `ToolConfig::override_risk(risk: ActionRisk)`. `BudgetConfig` meets criterion (a):
> embedded as `RunnableConfig.budget_config` (struct field consumed cross-crate).
> `CompactionTrigger` meets criterion (a): embedded in `BudgetConfig.compaction_trigger`.
> `ProvenanceTag` meets criterion (b): it is a pregolya-core type (parameter to
> `GuardrailHook::evaluate`; GuardrailHook is defined in pregolya-core) — cataloguing
> it under pregolya-graph would imply core depends on graph, which is forbidden.
> `StreamEvent` meets criterion (b): defined in `core::events` per ADR-006 §Consequences
> ("StreamEvent is a public type in pregolya-core"); module-decomposition.md §graph::event_emitter
> row explicitly states its role as emitter only (type defined in pregolya-core); cataloguing
> it under pregolya-graph would imply graph defines a type that pregolya-server consumes
> independently, introducing a phantom circular dependency.
> Types such as `GuardrailResult`, `IngressContent`, `BoundaryType`, `WriteGuardDecision`,
> `MemoryWriteRequest`, `PolicyDecision`, and `OnCeiling` do not currently meet either
> criterion — they appear only in trait method signatures and are not standalone
> cross-crate function inputs or misattributed graph types.
> When a new type meets criterion (a) or (b), add it here.

## Public Functions (pregolya-core)

| Function Signature | Module | SS | BC Anchors |
|--------------------|--------|----|-----------|
| `pub fn validate_embedding_batch(texts: &[String], vecs: &[Vec<f32>]) -> Result<(), PregolyaError>` | `core::embeddings` (pregolya-core) | SS-22 | BC-2.22.001 PC-2, INV-2, EC-003, EC-004 |

> `validate_embedding_batch` is a `pub` free function in `pregolya-core: core::embeddings`.
> Visibility: `pub` — `pregolya-openai::openai::embeddings` and `pregolya-ollama::ollama::embeddings`
> call it cross-crate before returning `Ok` from `embed_documents`. `#[non_exhaustive]` does not
> apply (free function; no associated struct or enum). Error anchor: `E-EMBED-001`.
> VP anchor: VP-008 (proptest P1; VP-008-A/B/C/D/E harnesses call this function directly,
> gating against the self-proving mock defect — deletion or regression fails all five
> harnesses immediately; F-P175-A24 structural fix, FIX-BURST-280).
> Placement: `pregolya-core/src/embeddings.rs`; if the module splits past the 500-line
> soft target, placement is `pregolya-core/src/embeddings/mod.rs`.

## Public Traits (pregolya-memory)

| Trait | Crate | SS | BC Anchors |
|-------|-------|----|-----------|
| `MemoryStore` | pregolya-memory | SS-15 | BC-2.15.001–003 |
| `SkillStore` | pregolya-memory | SS-15 | BC-2.15.004 |

## Public Traits (pregolya-checkpoint)

| Trait | Crate | SS | BC Anchors |
|-------|-------|----|-----------|
| `CheckpointSaver` | pregolya-checkpoint | SS-04 | BC-2.04.001–007 |

## Public Traits (pregolya-server)

| Trait | Crate | SS | BC Anchors |
|-------|-------|----|-----------|
| `IdempotencyStore` | pregolya-server | SS-12 | BC-2.12.006 |
| `RateLimitStore` | pregolya-server | SS-12 | BC-2.12.006 |
| `RunStore` | pregolya-server | SS-12 | BC-2.12.006 |

## Public Traits (pregolya-graph)

| Trait | Crate | SS | BC Anchors |
|-------|-------|----|-----------|
| `PreToolCallHook` | pregolya-graph (`graph::hitl`, ADR-018 Decision 1) | SS-05 | BC-2.05.007 |

> `PreToolCallHook` is defined in `pregolya-graph::hitl` per ADR-018 Decision 1.
> The alternative of placing it in pregolya-core was explicitly rejected by ADR-018
> (the "orphan definitions module" option). `pregolya-tools` interacts with it via
> `ActionRisk` risk-tier defaults (sourced from `pregolya-core::ActionRisk`) without
> taking a compile-time pregolya-graph dependency (ADR-020 Decision 3).

## Public Traits (pregolya-vectorstores)

| Trait | Crate | SS | BC Anchors |
|-------|-------|----|-----------|
| `VectorStore` | pregolya-vectorstores (`vectorstores::store`) | SS-21 | BC-2.21.001–004 |
| `VectorStoreFactory` | pregolya-vectorstores (`vectorstores::store`; `Sized`-bounded for `Arc<dyn VectorStore>` dyn-safety) | SS-21 | BC-2.21.001 |

> `VectorStore` and `VectorStoreFactory` are both defined in `pregolya-vectorstores`.
> `VectorStoreFactory: VectorStore + Sized` — the `Sized` bound preserves `Arc<dyn VectorStore>`
> object-safety (ADR-014 Decision 2). `Retriever` (the trait) is defined in pregolya-core.
> `VectorStoreRetriever` (no lifetime parameter; `store: Arc<dyn VectorStore>`) is the adapter
> struct. `Arc<dyn VectorStore>` ownership (not a borrow) allows `VectorStoreRetriever` to satisfy
> `Retriever + 'static`, enabling `Arc<dyn Retriever>` coercion without a lifetime bound error.
> `VectorStore::as_retriever` signature: `fn as_retriever(self: Arc<Self>) -> Result<VectorStoreRetriever, PregolyaError>` —
> fallible; returns `Err(E-VS-003)` when store configuration is invalid for retrieval
> (ADR-014 §Decision 2). `Arc<Self>` is a dyn-compatible receiver (ADR-014 §Decision 2; dyn-compatibility precedent: ADR-005 §Adjacent Trait Object-Safety Adjudications).

## Crates with No Public Traits

The following crates define no public Rust traits. Each is listed with its reason to make
omissions falsifiable rather than silent.

| Crate | Reason |
|-------|--------|
| `pregolya-prompts` | Concrete types only (`PromptTemplate`, `ChatPromptTemplate`, `FewShotPromptTemplate`, `MessagesPlaceholder`, `SlotTrustPolicy` enum, `TrustLevel` enum); no trait definitions |
| `pregolya-mcp` | Nine implementation modules — invocation stack: `mcp::client` (`pregolya-mcp/src/client.rs`) + `mcp::session` (`session.rs`) + `mcp::interceptor` (`interceptor.rs`); tool adaptation: `mcp::discovery` (`discovery.rs`, `convert_mcp_tool`); security seam: `mcp::ingress` (DI-012 HIGH; `ingress.rs`, `GuardrailHook` invocation + provenance tagging); error handling: `mcp::exception` (`exception.rs`); server-side: `mcp::sanitize` + `mcp::graph_tool` + `mcp::server`; no public trait definitions; consumes `DynTool` and `GuardrailHook` from pregolya-core |
| `pregolya-sandbox` | `SandboxPolicy` and `ProcessBackend` are structs/enums, not public trait definitions; `WorkspaceFs` facade is a struct; `sandbox::path_guard` exposes free functions (`canonicalize_beneath_root`, `canonicalize_beneath_root_pure`) |
| `pregolya-splitters` | Free-function splitter implementations; no public trait definitions |
| `pregolya-macros` | Proc-macro crate (`#[tool]`, `#[entrypoint]`, `#[task]`); proc-macros are attribute macros, not Rust trait definitions |
| `pregolya-openai` | Implements `BaseChatModel` and `Embeddings` from pregolya-core; defines no new public traits |
| `pregolya-anthropic` | Implements `BaseChatModel` from pregolya-core; defines no new public traits |
| `pregolya-ollama` | Implements `BaseChatModel` and `Embeddings` from pregolya-core; defines no new public traits |
| `pregolya-openai-sdk` | Wire client; no pregolya-core dependency; no public trait definitions |
| `pregolya-anthropic-sdk` | Wire client; no pregolya-core dependency; no public trait definitions |
| `pregolya-ollama-sdk` | Wire client; no pregolya-core dependency; no public trait definitions |
| `pregolya-standard-tests` | Shared conformance test suite and `eval::judge` module; test-only crate; no public trait definitions shipped to consumers |

## pregolya-graph Public Types

| Type | Role | SS | BC Anchors |
|------|------|----|-----------|
| `StateGraph<State>` | Graph builder: nodes, edges, channels | SS-02 | BC-2.02.001–006 |
| `GraphConfig` | Execution config: checkpoint_saver, interrupt_before/after | SS-03 | BC-2.03.001 |
| `Command` | HITL resume carrier: `Command(resume=value)` | SS-05 | BC-2.05.004 |

## Public Traits and Types (pregolya-tools)

| Symbol | Kind | SS | BC Anchors |
|--------|------|----|-----------|
| `PreToolCallHook` | trait (defined in `pregolya-graph::hitl` per ADR-018 Decision 1; pregolya-tools registers tools that interact with this hook via `ActionRisk` risk-tier defaults — ADR-020 Decision 3) | SS-05 | BC-2.05.007 |
| `PreToolDecision` | enum (4 variants: Approve/Deny/Edit/PendingHumanApproval) (defined in `pregolya-graph::hitl` per ADR-018 Decision 1; D-24 relocated `ActionRisk` to pregolya-core but these three HITL types remained in graph::hitl) | SS-05 | BC-2.05.007 |
| `ToolCallPreview` | struct (tool_name, tool_args, action_risk: Option\<ActionRisk\>) (defined in `pregolya-graph::hitl` per ADR-018 Decision 1) | SS-05 | BC-2.05.007 |
| `PathGuard` | struct (workspace-root-confined path validator; `E-SBXD-001` on workspace escape at sandbox layer — entry points: `canonicalize_beneath_root` / `canonicalize_beneath_root_pure`; tool layer translates to `E-TOOLS-001` per interface-definitions.md §First-Party Tools error layer split) — owned by pregolya-sandbox/SS-13 (VP-003 Kani P0); consumed by SS-23 tools | SS-13 | BC-2.13.004 |
| `ToolConfig` | shared per-tool framework configuration; `override_risk(self, risk: ActionRisk) -> Result<ToolConfig, PregolyaError>` builder-consuming validator (`#[non_exhaustive]`); ADR-020 Decision 3 | SS-23 | BC-2.23.005 |
| `ReadFileTool` | first-party tool | SS-23 | BC-2.23.001 |
| `WriteFileTool` | first-party tool (High ActionRisk) | SS-23 | BC-2.23.002 |
| `EditFileTool` | first-party tool | SS-23 | BC-2.23.003 |
| `ListDirTool` | first-party tool (ReadOnly) | SS-23 | BC-2.23.004 |
| `BashTool` | first-party tool (Medium ActionRisk floor; VP-013 Kani seed) | SS-23 | BC-2.23.005 |
| `GrepTool` | first-party tool | SS-23 | BC-2.23.006 |

## pregolya-server HTTP Endpoints

Base URL: configurable; default port 7437 (server.port in pregolya-server.toml — see interface-definitions.md §Base URL).

| Method | Path | Description | BC Anchor |
|--------|------|-------------|-----------|
| POST | `/threads` | Create thread | BC-2.12.001 |
| GET | `/threads/{thread_id}` | Read thread | BC-2.12.001 |
| GET | `/threads` | List threads | BC-2.12.001 |
| DELETE | `/threads/{thread_id}` | Delete thread | BC-2.12.001 |
| GET | `/threads/{thread_id}/state` | Latest checkpoint state (`{ values, checkpoint, next }`) | BC-2.12.001 |
| POST | `/threads/{thread_id}/state` | Apply state delta (`{ values, as_node? }` → `{ checkpoint }`) | BC-2.12.001 |
| GET | `/threads/{thread_id}/history` | Checkpoint history, newest-first (`?limit=N`) | BC-2.12.001 |
| POST | `/assistants` | Create assistant (named agent config) | BC-2.12.002 |
| GET | `/assistants` | List assistants | BC-2.12.002 |
| GET | `/assistants/{assistant_id}` | Read assistant (resolves via latest-version pointer) | BC-2.12.002 |
| PATCH | `/assistants/{assistant_id}` | Sparse update; creates immutable new version | BC-2.12.002 |
| DELETE | `/assistants/{assistant_id}` | Delete assistant | BC-2.12.002 |
| GET | `/assistants/{assistant_id}/versions` | List immutable version snapshots (ascending) | BC-2.12.002 |
| POST | `/assistants/{assistant_id}/set_latest` | Set latest-version pointer (`{ version: N }`) | BC-2.12.002 |
| POST | `/threads/{thread_id}/runs` | Create and start run (async; 202 Accepted) | BC-2.12.003 |
| GET | `/threads/{thread_id}/runs` | List runs for thread (`?status=`) | BC-2.12.003 |
| GET | `/threads/{thread_id}/runs/{run_id}` | Read run status and result | BC-2.12.003 |
| GET | `/threads/{thread_id}/runs/{run_id}/stream` | SSE streaming run output | BC-2.12.007 |
| POST | `/threads/{thread_id}/runs/{run_id}/resume` | Deliver HITL resume value | BC-2.05.004 |
| POST | `/threads/{thread_id}/runs/{run_id}/cancel` | Cancel queued/in_progress run (→ cancelled) | BC-2.12.003 |
| DELETE | `/threads/{thread_id}/runs/{run_id}` | Delete terminal run record (409 if non-terminal) | BC-2.12.003 |
| POST | `/schedules` | Create cron schedule (assistant-owned; flat path) | BC-2.12.004 |
| GET | `/schedules/{cron_id}` | Read schedule (enabled state, last_fired_at) | BC-2.12.004 |
| PATCH | `/schedules/{cron_id}` | Enable/disable schedule (`{ "enabled": false }`) | BC-2.12.004 |
| DELETE | `/schedules/{cron_id}` | Delete schedule; halts future firings | BC-2.12.004 |
| GET | `/runs?schedule_id={cron_id}` | Cross-thread aggregate: list all Runs for a schedule (read-only; flat) | BC-2.12.004 |

**URL scheme (F-P23-01):** Runs are thread-nested (`/threads/{thread_id}/runs/...`). Schedules are
flat (`/schedules/{cron_id}`). The one flat `/runs?schedule_id=` endpoint is a read-only
cross-thread aggregate query for schedule-fired runs only.

**Wire format:** JSON for HTTP responses. msgpack for checkpoint state (ADR-002).

**Security:** `SecurityConfig::default()` denies CORS. When the `debug-endpoints` feature is enabled: (a) empty/absent `debug_route_key` (BC-2.12.005) → server refuses to start — `E-SERVER-013 InvalidDebugRouteKey` raised during config validation before the HTTP listener binds (startup-refusal, not a runtime error); (b) valid key configured + unauthenticated request → `403` with `E-SERVER-004 DebugRouteUnauthorized` at runtime. Loopback bind alone is insufficient against DNS-rebinding/CSRF-to-127.0.0.1; `SpanData` exposes `llm_request`/`llm_response` payloads (SEC-BOUND-001 parity; sanitization specified in BC-2.24.002).

### Debug Endpoints (feature `debug-endpoints`, default OFF)

> **D-356 dev-console scope expansion (2026-09-06, architect).** These three endpoints are
> compiled into `pregolya-server` ONLY when the `debug-endpoints` Cargo feature is enabled
> (default: OFF). Production deployments that do not enable this feature compile out all debug
> routing with zero overhead. All three endpoints are subject to
> `SecurityConfig.debug_route_key` (BC-2.12.005). Authoritative decisions: ADR-031 §Decision 2.

> **D-356 adversary fix DC-07 (2026-09-07, architect).** F-PDC07-01: swept `debug_api_key` → `debug_route_key` at all 5 api-surface.md sites (changelog 1.31, §Security, Debug Endpoints preamble blockquote, DC-02 blockquote, Cargo Feature Flags table). F-PDC07-02: §Security updated to state both auth behaviors explicitly: (a) empty/absent `debug_route_key` → `E-SERVER-013 InvalidDebugRouteKey` startup-refusal before HTTP listener binds; (b) valid key + unauthenticated request → `E-SERVER-004 DebugRouteUnauthorized` 403 at runtime. Companion: ADR-031 updated in same burst.

> **D-356 adversary fix DC-02 (2026-09-07, architect).** F-PDC02-05: `SecurityConfig.debug_route_key`
> is MANDATORY (not opt-in) when `debug-endpoints` is enabled — unauthenticated `/debug/*` returns
> `403` with `E-SERVER-004 DebugRouteUnauthorized`. Rationale: `SpanData` exposes `llm_request`/
> `llm_response` payloads; loopback bind alone is insufficient (DNS-rebinding/CSRF-to-127.0.0.1).
> SEC-BOUND-001 parity: `SpanData` sanitization (strip LLM payload fields before export) specified
> in BC-2.24.002. ADR-031 D6-2 and §Security interaction updated in the same burst.

| Method | Path | Description | CAP Anchor |
|--------|------|-------------|------------|
| GET | `/debug/trace/session/{session_id}` | Ordered `SpanData` list for a session — sourced from in-memory `DebugSpanExporter` (hosted by `pregolya-console`); `503` with `E-SERVER-023 DebugExporterNotConfigured` when no exporter is configured | CAP-042 |
| GET | `/debug/trace/{event_id}` | `SpanData` for a single event — same exporter source; `503` with `E-SERVER-023` when not configured | CAP-042 |
| GET | `/assistants/{id}/graph` | Compiled `StateGraph` as JSON node/edge descriptor + optional `dot_src: String` (Graphviz DOT; `null` when `dot` binary absent); `404` with `E-SERVER-009 AssistantNotFound` when assistant does not exist | CAP-042, CAP-003 |

**`SpanData` shape:** `{ span_id, trace_id, start_time_ms, end_time_ms, attributes: JSON,
llm_request: JSON|null, llm_response: JSON|null }`. Matches adk-rust `convert_to_span_data()`
→ `Trace.ts` SpanData shape (research memo §2.2 table row 5) for frontend interoperability.

**Graph descriptor shape:** `{ nodes: [{name, kind}], edges: [{source, target, condition}],
dot_src: String|null }`. Static structural snapshot of the compiled graph; carries no runtime
state. Served by the `server::debug_routes` module (Effectful Shell); pure serialization
extracted to `graph::descriptor` (Pure Core, pregolya-graph) before Phase 6 per ADR-031
§Decision 5.

**Transport note (ADR-031 §Decision 3):** SSE remains the sole streaming transport for
run events (`GET /threads/{id}/runs/{run_id}/stream`, BC-2.12.007). No WebSocket endpoint
is added by D-356. The debug endpoints are unary REST (JSON request/response), not streaming.

## Cargo Feature Flags

| Feature | Default | Description | BC Anchor |
|---------|---------|-------------|-----------|
| `checkpoint-sqlite` | YES | SQLite checkpoint backend | BC-2.04.002 |
| `checkpoint-memory` | NO | In-memory backend (tests) | — |
| `checkpoint-postgres` | NO | PostgreSQL backend (stretch) | — |
| `sandbox-wasm` | YES | WASM execution backend (enforcing default) | BC-2.13.001 |
| `sandbox-container` | NO | Container execution backend | BC-2.13.001 |
| `sandbox-process` | NO | **Security-annotated.** Process backend — NOT enforcing (no filesystem/network/memory isolation); compiles `ProcessBackend` but does NOT make it a default; accessible ONLY via `Sandbox::unsafe_process_no_isolation()`; `SandboxBackend::default()` returns `Err(E-SBXD-003)` when no enforcing backend is compiled (BC-2.13.001 PC3/PC4) | BC-2.13.001, BC-2.13.002 |
| `server` | NO | Include pregolya-server in binary | BC-2.12.001 |
| `mcp` | NO | pregolya-mcp adapter | BC-2.09.001 |
| `budget` | YES | Budget governance policy primitive | BC-2.10.001 |
| `guardrail` | YES | Content provenance + guardrail hook | BC-2.11.001 |
| `debug-endpoints` | **NO** | **Security-annotated.** Feature-gates `/debug/trace/*` + `/assistants/{id}/graph` endpoints. Off by default — production builds MUST NOT enable unless behind `SecurityConfig.debug_route_key` (BC-2.12.005) and explicitly scoped to developer/staging. Compiled out entirely when off. CI gate `check-debug-endpoints-default` (authored at Wave 3) verifies this feature is absent from `[features].default`. See ADR-031 §Decision 2 and §Decision 6 D6-3. | CAP-042 (D-356/ADR-031) |

## Error Type

`#[non_exhaustive] PregolyaError { component: Component, category: Category, retry_hint: RetryHint, code: &'static str, message: String /* Human-readable; MUST NOT contain credentials */, source: Option<Arc<dyn std::error::Error + Send + Sync>> /* Causal chain; MUST NOT appear in HTTP responses (DI-010); Arc not Box — Arc preserves Clone (F-P173-211 adjudication, ADR-010 §Decision) */ }`

Construction (ADR-010 §Error-Construction Notation Canon — sole sanctioned paths):
- `PregolyaError::new(component: Component, category: Category, retry_hint: RetryHint, code: &'static str, message: impl Into<String>) -> Self` — `source` defaults to `None`.
- `.with_source(self, source: Arc<dyn std::error::Error + Send + Sync>) -> Self` — builder; threads a causal error into the chain. Chain as needed: `PregolyaError::new(...).with_source(Arc::new(e))`.
- Struct literal construction is barred by `#[non_exhaustive]` (E0639) from external crates.

Authoritative list lives in `error-taxonomy.md` §Components; enum reproduced here for the PregolyaError type definition:
`Component` = CORE | GRAPH | CHKPT | SERVER | PROV | MCP | SPLIT | SBXD | RETRY | CRON | MEMORY | BUDGET | TMPL | SRLZ | VS | EMBED | TOOLS (17 components as of D23; `#[non_exhaustive]` gate count 18: 17 named + `Custom`).
Full catalog: `prd-supplements/error-taxonomy.md`.
RFC-7807 serialization: `PregolyaError::to_problem()` (BC-2.14.002). Note: corrected from `to_problem_detail()` (F-P25-04; BC-2.14.002 is authoritative for method name).
