---
document_type: domain-spec-section
level: L2
section: capabilities-p1-p2
version: "1.40"
status: active
producer: business-analyst
timestamp: 2026-09-08T00:00:00Z
phase: 1b
inputs:
  - .factory/specs/product-brief.md
  - .factory/comparative/COMPARATIVE-ASSESSMENT.md
  - .factory/planning/holdout-domains/domain-c-openclaw.md
  - .factory/planning/holdout-domains/domain-d-hermes-agent.md
  - .factory/planning/holdout-domains/domain-e-agentic-coding-assistant.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "371c041"
traces_to: L2-INDEX.md
decisions: [D1, D3, D7, D8, D13, D17, D19, D20, D21, D23, D170, D275, D356]
changelog:
  - "1.40 (records-straggler/A-04/2026-09-09, business-analyst): CAP-047 IngressBoundary boundary bullet — §PC-002 notation corrected to {PC-002} (CLASS A records-lint fix; curly-brace subclause notation per records-lint CLASS_A rule)."
  - "1.39 (DC-33/F-PDC33-02/2026-09-08, business-analyst): CAP-047 rewrite per architect DC-33 ruling. Completed-run guardrail substrate corrected from evidence_journal? to guardrail_journal? (BC-2.11.007). EvidenceJournal is BUDGET-ONLY (PolicyDecision); GuardrailResult (Pass/Fail/Transform) outcomes now persist in the GuardrailJournal entity (entities-server.md §GuardrailJournal). Capability description replaced with architect-canonical form: live runs consume GuardrailDecision StreamEvent variants; completed runs reconstruct from guardrail_journal? (BC-2.11.007) on run-read. DC-33 dated delta note added to CAP-047 body. Prior DC-29-sibling and DC-31 interim delta notes superseded. Trace anchors: removed evidence_journal? guardrail-substrate claims (BC-2.24.008 {PC-004} + BC-2.12.003 {PC-013}); added BC-2.11.007 (guardrail_journal? projection). Anchor justification extended to reference entities-server.md §GuardrailJournal. CAP-043 cascade: DC-33 superseding note added after DC-31 delta note — DC-31 stated guardrail completed-run history arrives via evidence_journal? (BC-2.24.008 {PC-004}); superseded per DC-33: guardrail history is in guardrail_journal? (BC-2.11.007); EvidenceJournal is BUDGET-ONLY; DC-31 note preserved for audit. CAP-043 live body confirmed clean — evidence_journal? references in live body are for budget history (correct), not guardrail history. Authority: F-PDC33-02, architect DC-33 ruling."
  - "1.38 (D-356/DC-31/F-PDC31-01+02/2026-09-08, business-analyst): CAP-043 + CAP-047 3-substrate model corrections per DC-31. F-PDC31-01 (HIGH): (1) CAP-043 trace-span content list: struck 'guardrail decisions' — guardrail completed-run history arrives via evidence_journal? on run-read (BC-2.24.008 {PC-004}), NOT trace spans. (2) CAP-047 completed-run substrate: replaced trace-span read (BC-2.24.002) with evidence_journal? on run-read (BC-2.12.003 {PC-013}, BC-2.24.008 {PC-004}). F-PDC31-02 (MED): CAP-043 trace-span content list: struck 'compaction summaries' — compaction per-event markers/timeline are LIVE-run SSE only, unavailable for completed runs (BC-2.24.007); clarifying clause added. O-PDC31-A sweep: CAP-041/042/044/045/046 already correct per 3-substrate model; only CAP-043/047 required fixes. CAP-047 trace anchors updated to add BC-2.24.008 {PC-004} + BC-2.12.003 {PC-013}."
  - "1.37 (D-356/F-PDC29-01-sibling/2026-09-08, business-analyst): CAP-047 sibling fix — TD-VSDD-060 sweep found same transient-StreamEvent class of defect as F-PDC29-01 in CAP-047 body. 'reconstructs from stored events for completed runs' → 'reconstructs from persisted trace spans (GET /debug/trace/session/{run_id}, BC-2.24.002) for completed runs (StreamEvent TRANSIENT, ADR-030; no event-replay endpoint, ADR-031 Decision 8)'. Dated delta note added to CAP-047 body."
  - "1.36 (D-356/F-PDC29-01/2026-09-08, business-analyst): CAP-043 completed-run inspection substrate correction — adversary finding F-PDC29-01 (HIGH). Opening paragraph rewrote to split completed-run vs live-run workflows. Completed run: trace spans (GET /debug/trace/session/{run_id}, BC-2.24.002) + run-state summary + evidence_journal? (BC-2.12.003 {PC-013}) — NOT StreamEvent replay (StreamEvent is TRANSIENT per ADR-030; no run-event endpoint, ADR-031 Decision 8). Live run: SSE StreamEvent stream (BC-2.12.007) — unchanged. Anchor justification and trace anchors updated; CAP-007 scope now explicitly LIVE only."
  - "1.35 (D-356/F-L288-002+005/2026-09-08, business-analyst): Two L-288 exhaustive-sweep fixes. (1) F-L288-002 [MED] CAP-042 graph-descriptor field: dotSrc: String → dot_src: String (snake_case per BC-2.24.003 PC-001/PC-004 + S-console-04 AC-001/AC-004; CAP-042 was the lone camelCase outlier). (2) F-L288-005 [MED] CAP-046 EvidenceJournal scope: 'For completed runs' → 'For terminal-status (finished) runs (completed, failed, cancelled, summary_halt)' per DC-24/DC-25 broadening in BC-2.24.007 + BC-2.12.003 {PC-013} evidence_journal? projection. Dated delta notes added to both CAP bodies."
  - "1.34 (D-356/F-PDC26-03/2026-09-08, business-analyst): CAP-045 two-site drift correction — adversary finding F-PDC26-03 (MED). (1) node_name drift: node-boundary interrupt dialog bullet 'scratchpad value and node name' corrected to 'value (scratchpad JSON) and interrupt_id' per BC-2.24.006 PC-002 + S-console-08; InterruptPayload has only value+interrupt_id, not node_name. (2) same-run drift: 'subscribes to the new run stream' corrected to 'same run stream (run_id unchanged)' per DC-23 canonical ruling: resume is interrupted→in_progress on the SAME run_id. Dated delta note added to CAP-045 body."
  - "1.33 (D-356/F-PDC06-03/2026-09-07, business-analyst): CAP-047 field-name correction — adversary finding F-PDC06-03 site 1 (HIGH). Wrong SS-11 ProvenanceTag names replaced with correct guardrail_decision StreamEvent wire names per BC-2.06.001 §PC-002. boundary_type:RAGRetrieval/MemoryIngress → boundary:IngressBoundary ToolResult|RagChunk|MemoryItem; GuardrailSeverity → severity:Option<GuardrailSeverityWire> (Some for Fail, None for Transform); outcome bullets restructured to decision/severity/reason per BC-2.06.001 §PC-002 shape. Dated delta note added to CAP-047 body. input-hash updated."
  - "1.32 (D-356/2026-09-06, business-analyst): D-356 dev-console scope expansion — new section 'P1 — Developer Console (D-356, Wave 3)' added with CAP-041 through CAP-047 (all P1), and 'P2 — Deferred Dev Console Capability' with CAP-048 (DEFERRED). CAP count 40→48. Research memo (.factory/planning/devconsole-adk-research.md) added to inputs. D356 added to decisions list. Roadmap-only delta: no existing capabilities modified."
  - "1.31 (round-57/F-P2A228-02/2026-09-01): CAP-040 §PromoteRetireChannel body: stale DI-014 parenthetical corrected to DI-001 — pure infallible Vec<T> reducer determinism (BSP reducer determinism = DI-001). Consistent with §Authored BCs footer BC-2.02.009 anchor (DI-001) already fixed in round-55. POL-24 sibling sweep: sole stale DI-014 in PromoteRetireChannel/LedgerChannel/BC-2.02.007/BC-2.02.009 context; no additional stale citations found. Neighboring TrajectoryWriter DI-014 (§error-propagation bullet, §Authored BCs BC-2.04.009/BC-2.04.010/BC-2.04.011) retained — legitimately fallible Result-returning operations."
  - "1.30 (round-55/F-P2A225-01/2026-09-01): CAP-040 §Authored BCs: DI-014 removed from BC-2.02.007 and BC-2.02.009 per architect ADR-030 §VP ruling — both reducers are pure infallible Vec<T> functions; DI-014 inapplicable; DI-001 is the correct anchor. BC-2.02.007: DI-014/DI-001 → DI-001; BC-2.02.009: DI-014/DI-001 → DI-001."
  - "1.29 (Round-25/F-P2A108-02-blast-radius/2026-08-28): F-P2A108-02 notation fix — CAP-039 body: doubled non-resolving notation `pregolya-core::core::runnable` → canonical parenthetical `pregolya-core (core::runnable)` per ADR-023 normalization. Sibling sweep: zero other doubled `<crate>::<shorthand>::<module>` occurrences in live body. TD-VSDD-091: citation by symbol/module-path only."
  - "1.28 (Round-19/GAP-01-bidirectional-link/2026-08-27): CAP-021 body extended to describe GraphAgentTool wrapping behavior and cite BC-2.09.008 — closes the missing CAP→BC direction for the D-275/GAP-01 scope addition (2026-08-26). Added GraphAgentTool paragraph (CompiledStateGraph as DynTool, STATE-ISOLATION {INV-001}, DenyInterrupts fail-closed policy, E-MCP-010) and 'Authored BCs: BC-2.09.008' entry per D23/D-170 citation convention. No behavioral scope expansion beyond BC-2.09.008 + D-275 human approval. D275 added to decisions list. TD-VSDD-091: all citations by symbol/section name only."
  - "1.27 (P2A-021/2026-08-21): CAP-028 ingestion-method name reconciled: add_texts→add_documents (add_texts is legacy; add_documents(docs: Vec<Document>) is the canonical modern primary per LangChain reference). Four live-body sites updated in capabilities-p1-p2.md: (1) CAP-028 heading token; (2) CAP-028 method signature form; (3) CAP-028 &self-receiver rationale sentence; (4) CAP-029 'generated at ... time' clause. TD-VSDD-060 sweep: entities-graph.md §VectorStore also contains a live add_texts reference — outside business-analyst capability-doc scope; reported for routing to entities-doc owner."
  - "1.26 (burst-316/F-P206-01/2026-08-18): F-P206-01 (MED) CAP-038 E-TOOLS-006 name: retired informal name 'SearchResultsCapped' replaced with canonical payload field path per error-taxonomy §E-TOOLS-006 and BC-2.23.006. Before: 'E-TOOLS-006 `SearchResultsCapped` on ceiling (informational — partial results returned)'. After: 'E-TOOLS-006 (`GrepResult.capped` — informational payload field, not a raised Err; partial results returned on ceiling)'. Authority: error-taxonomy §E-TOOLS-006 canonical payload field path GrepResult.capped (established burst-247/F-P146-02); BC-2.23.006 PC-2. Corpus sweep: sole SearchResultsCapped live-body occurrence in domain-spec; zero others found. ADR-020 §First-Party Tool Error Codes mnemonic-label table correctly excluded (intentional label column). TD-VSDD-060 sweep: sole E-TOOLS-006/SearchResultsCapped occurrence in this file."
  - "1.25 (burst-304/F-P195-01/2026-08-17): F-P195-01 (HIGH) invoke_dyn residual in CAP-039 RunnablePassthrough description: 'invoke_dyn(input, config)' → 'invoke(input, config)'. Canon: DynRunnable method is invoke (not invoke_dyn — that is DynTool's method). TD-VSDD-060 sweep: zero other invoke_dyn occurrences in DynRunnable/RunnableParallel/RunnablePassthrough/RunnableAssign context in live body; zero E-CORE-NNN/MMM, core::runnable::parallel/::passthrough, or DynRunnable< residuals in live body."
  - "1.24 (burst-303/F-P194-02/F-P194-03/2026-08-17): F-P194-02 (HIGH) error-code placeholder resolution — CAP-039 §RunnableParallel fail-fast body: E-CORE-NNN → E-CORE-009 (EXEC, RunnableParallelBranchFailure, anchor BC-2.01.006); CAP-039 §RunnableAssign body: E-CORE-MMM → E-CORE-010 (VAL, RunnableAssignNonDictInput, anchor BC-2.01.008). F-P194-03 (MED) module-path canonicalization — CAP-039 module placement: non-canonical 3-level paths (pregolya-core::core::runnable::parallel / ::passthrough) → canonical 2-level form (core::runnable) per ADR-026 and module-registry canon. TD-VSDD-060 sweep: zero E-CORE-NNN/MMM remain in live body; zero 3-level runnable submodule paths remain in live body."
  - "1.23 (burst-302b/D-170/2026-08-17): D-170 LCEL composition scope expansion — CAP-039 authored (RunnableParallel, RunnablePassthrough, RunnableAssign; SS-01/pregolya-core). New section 'P1 — LCEL Map/Passthrough Composition (Wave 1, D-170)' added before P2 section. P1 count 26→27; total section CAPs 29→30; L2 total 38→39. D170 added to decisions list. BCs BC-2.01.005–008 and VP-014 referenced (product-owner authoring in parallel)."
  - "1.22 (burst-291/D-134/2026-08-16): §-anchor phantom sweep — two error-taxonomy component shortcode phantoms fixed. (1) CAP-029 §VS — VAL... context: §VS is a shortcode, not a heading (heading is '### Component: VS (pregolya-vectorstores)'). Corrected to error-taxonomy.md §Component: VS. (2) CAP-031 §EMBED — VAL... context: same pattern; corrected to error-taxonomy.md §Component: EMBED (heading '### Component: EMBED (pregolya-core::embeddings)')."
  - "1.21 (F-P175-D101/fix-burst-283/2026-07-30): Close F-P175-D101 (CRIT) — as_retriever fallibility and receiver form omitted from two CAP bodies. (1) CAP-027: 'Constructed via VectorStore::as_retriever()' corrected to show self: Arc<Self> receiver and Result<VectorStoreRetriever, PregolyaError> fallible return with Err(E-VS-003 InvalidConfig) on invalid config. (2) CAP-028: 'as_retriever(self: Arc<Self>) → VectorStoreRetriever' corrected to '→ Result<VectorStoreRetriever, PregolyaError>'; fallibility note added (Err(E-VS-003 InvalidConfig) on invalid config). Grounds: interface-definitions.md §VectorStore Trait (as_retriever fallible return, F-P174-as-retriever-fallible/fix-burst-277) and ADR-014 §Decision 2. TD-VSDD-060 sibling sweep: entities-graph.md §VectorStore §Instance methods and ubiquitous-language-core.md §VectorStore/§VectorStoreRetriever terms corrected in this burst."
  - "1.20 (wave-b-tail/D-35-xtask-rename-notation/2026-07-29): Two Class 3 notation violations and one xtask rename. (1) CAP-029 zero-norm guard prose: PregolyaError { code: \"E-VS-001\" } → PregolyaError { code: \"E-VS-001\", .. } — Class 3 VIOLATION (partial fields, missing ..) per ADR-010 §Error-Construction Notation Canon. (2) CAP-031 dimensionality contract prose: PregolyaError { code: \"E-EMBED-001\" } → PregolyaError { code: \"E-EMBED-001\", .. } — Class 3 VIOLATION (same class). (3) CAP-032 DI-009 CI-gate prose: workspace CI gate `deny-client-new` → `check-client-timeout` (D-80 canonical check-<subject> form). TD-VSDD-060 sweep: zero additional superseded names (lint-no-timeout, lint-no-panic, deny-expect-in-lib) found in live body text."
  - "1.19 (fix-burst-278/wave-b/2026-07-28): Sites 8a and 8b per wave-b-po-routing-spec §Item-8. (1) CAP-027 Site 8a: VectorStoreRetriever lifetime annotation removed — type is 'static, owns Arc<dyn VectorStore>; verifiable: verify-signature-canon S2 returns zero hits. (2) CAP-027 adjacent to Site 8a: backing-store form corrected from borrow-ref to Arc<dyn VectorStore> (same paragraph); verifiable: borrow-backed VectorStoreRetriever form absent from this file. (3) CAP-028 Site 8b: as_retriever receiver corrected from bare self-ref to self: Arc<Self>; return-type lifetime annotation removed; verifiable: verify-signature-canon S1b returns zero hits. (4) CAP-027 config bullets k, fetch_k, lambda_mult: Err(E-VS-003 InvalidConfig) rejection semantics added per D-44 — rejected not clamped (verifiable: grep 'E-VS-003 InvalidConfig' capabilities-p1-p2.md returns three hits, one per config bullet). TD-VSDD-060 sibling sweep: same borrow-backed class found and corrected in entities-graph.md §VectorStore/§Relationships-Summary and ubiquitous-language-core.md §VectorStoreRetriever/§VectorStore this burst."
  - "1.18 (FC-4/burst-277/2026-07-28): False-closure FC-4 correction — v1.13 claim 'L-026 stale-delegation sweep: zero additional hits' was false. Sweep term: 'PO BC obligations' (verifiable: grep 'PO BC obligations' capabilities-p1-p2.md returns zero hits after this fix). Three surviving stale-completed-delegation instances corrected: (1) CAP-034 §PendingHumanApproval: '(PO BC obligation, SS-05 extension)' → '(BC-2.05.008)' — BC-2.05.008 exists, covers skip-hook-on-resume invariant. (2) CAP-034 §streaming events: '**PO BC obligations:** BC-2.06.004 / BC-2.06.005 (SS-06); amend BC-2.08.010 ...' → '**Authored BCs:** BC-2.06.004 / BC-2.06.005 (SS-06); BC-2.08.010 amended ...' — all three BCs exist. (3) CAP-035 §PO BC obligations: '**PO BC obligations:** new BCs for SS-10 ...; amend BC-2.06.001 or author BC-2.06.006 ...' → '**Authored BCs:** BC-2.10.005 / BC-2.10.006 (SS-10); BC-2.06.006 authored ...' — BC-2.10.005, BC-2.10.006, BC-2.06.006 all exist. TD-VSDD-060 sibling sweep: same 'PO BC obligations' class also found and fixed in entities-graph.md (v1.12→v1.13) and ubiquitous-language-core.md (v1.8→v1.9) this burst."
  - "1.17 (F-P173-106/F-P173-702/burst-276/2026-07-27): Two CAP body corrections. (1) F-P173-106 CAP-038: remove stale 'confirm regex is already a workspace dependency' open instruction; ADR-020 Decision 7 already resolved that regex is NOT an existing workspace dep — it will be a net-new [workspace.dependencies] entry at workspace init; replace with confirmed fact per ADR-020 Decision 7. (2) F-P173-702 CAP-029: correct mis-citation ADR-014 Decision 4 → ADR-017 Decision 4 for InMemoryVectorStore struct and Arc-DI wiring. ADR-014 Decision 4 is the External Adapter Extension Seam (inventory crate for community adapters); ADR-017 Decision 4 explicitly defines the InMemoryVectorStore struct with Arc<dyn Embeddings> + RwLock<Vec<(Document, Vec<f32>)>> and the Arc-DI wiring contract. ADR-014 Decision 2 §Hardening note attribution for zero-norm guard unchanged (correct). TD-VSDD-060 sweep: no other ADR-014 Decision 4 mis-citations for InMemoryVectorStore in this file."
  - "1.16 (burst-273/2026-07-25): Date-monotonicity repair: v1.10 changelog date 2026-07-22 → 2026-07-23 (burst-242; corroborating carrier: api-surface.md v1.9 burst-242/2026-07-23). TD-VSDD-060 temporal-neighbor sweep: no additional inversions found in this file."
  - "1.15 (F-P170-16/burst-272/2026-07-25): Fix CAP-037 risk floor — retire unqualified ToolConfig::override_risk(ReadOnly)/override_risk(Low) spellings; replace with canonical ToolConfig::override_risk(ActionRisk::ReadOnly) and ToolConfig::override_risk(ActionRisk::Low) per BC-2.23.005 v1.7 §Invariants adjudication (ADR-020 Decision 3). TD-VSDD-060 sweep: sole unqualified override_risk occurrence in this file."
  - "1.14 (2026-07-24): Fix burst 252 BA — ADR-019 v1.4 compaction type canon applied at CAP-035. (1) CompactionTrigger OnWatermark: `fraction: f32` → `f64`; predicate `<` → `<=` (non-strict; strict < cannot fire at fraction=1.0). (2) CompactionSummary: `compacted_range: RangeInclusive<usize>` → flat `compacted_start: usize, compacted_end: usize`; slice form `messages[compacted_start..=compacted_end]`. (3) BudgetEngine description: `messages[compacted_range]` → `messages[compacted_start..=compacted_end]`. TD-VSDD-060 sweep: zero compacted_range / RangeInclusive / fraction: f32 occurrences remain in this file's body text (CAP-035 sites only; changelog exempt)."
  - "1.13 (2026-07-24): Fix burst 251 F-P150-02 (MED) — remove stale completed-delegation residue at two sites. (1) CAP-029 §Zero-norm guard: '(ADR-authored code; PO to formalize in error taxonomy)' → '(registered in error-taxonomy §VS — VAL, zero-norm cosine guard, BC-2.21.003)'. (2) CAP-031 §Dimensionality contract: '(ADR-authored code; PO to formalize in error taxonomy)' → '(registered in error-taxonomy §EMBED — VAL, dimensionality contract violation, BC-2.22.001)'. Both E-VS-001 and E-EMBED-001 were registered in error-taxonomy v1.27 (2026-07-20). L-026 stale-delegation sweep across all domain-spec shards: zero additional hits — only these two sites required remediation."
  - "1.12 (2026-07-24): Fix burst 250 F-P149-01 + F-P149-02 (TD-VSDD-091) — de-pin ADR version citations in live body text. (1) CAP-029 §Zero-norm guard heading: 'ADR-014 v1.1 hardening' → 'ADR-014 Decision 2 §Hardening note'. (2) CAP-029 §Grounding: 'ADR-014 v1.1 §Hardening note' → 'ADR-014 Decision 2 §Hardening note'. (3) CAP-033 §Endpoint behavior heading: 'ADR-017 v1.1' → 'ADR-017 Decision 3'. (4) CAP-033 §Grounding near-miss (outside grep pattern; same violation): 'ADR-017 Decision 3 and v1.1 specify' → 'ADR-017 Decision 3 specifies'. TD-VSDD-060 sibling sweep: no other ADR version pins in live body text of this file."
  - "1.11 (2026-07-23): Fix burst 243 F-P143-01 (MED) — CAP-029 VP-009 mis-description corrected. Two sites: (1) Grounding §VP-009 connection — stale 'MMR cosine values ∈ [-1.0, 1.0] + no NaN in output scores for any valid non-zero query embedding' replaced with Zero-Norm Cosine Guard framing: `cosine_similarity` in `vectorstores::similarity`, fail-closed via E-VS-001 before division, `Ok(f32::NAN)` unreachable, BC-2.21.003, DI-014, harness `zero_norm_guard_fail_closed`. (2) Anchor justification — 'VP-009 (Kani MMR bounded proof)' replaced with 'VP-009 (Kani Zero-Norm Cosine Guard — `zero_norm_guard_fail_closed` on `cosine_similarity`, BC-2.21.003, DI-014)'. TD-VSDD-060 sibling sweep: no other MMR-proof or vectorstores-mmr VP-009 framing found in live body text of .factory/specs/."
  - "1.10 (2026-07-23): Fix burst 242 BA residual sweep — Command notation: 1 enum-variant form occurrence of `Command::Resume(PreToolDecision)` corrected to struct kwarg form `Command(resume=PreToolDecision)` per BC-2.05.004/F-P120-01 adjudication. Site: CAP-034 §PendingHumanApproval bullet. TD-VSDD-060 sweep: zero Command:: enum-form occurrences remain in this file's body text."
  - "1.9 (2026-07-23): Fix burst 241 F-P141-02 (BA wave 2) — CAP-019 VP gate expanded 3 → 6 P0 Kani proofs: added VP-009 (zero-norm cosine guard, DI-014/BC-2.21.003), VP-010 (reviver allowlist containment, DI-014/BC-2.19.005), VP-011 (PreToolCallHook fail-closed, DI-014/BC-2.05.007) per architect P0-intent ruling. Grounding wording updated 3→6 VP obligations; DI invariant list in phase-placement note extended to DI-001/DI-005/DI-007/DI-014. TD-VSDD-060 sibling sweep: no other '3 committed VP' gate phrasing found in this file."
  - "1.8 (2026-07-22): Fix burst 233 F-P133-08 (BA micro-fix) — CAP-036 similar-crate facts corrected per ADR-020 Decision 7 v1.1: `similar = \"3\"`, owner mitsuhiko (Armin Ronacher), Apache-2.0 single-licensed (NOT MIT), cargo-deny `[licenses.allow]` must include `\"Apache-2.0\"`; stale pre-write confirm instruction removed. TD-VSDD-060 sibling sweep: no other dtolnay/MIT similar-crate references in this file."
  - "1.7 (2026-07-22): D23 CAP layer (burst-230) — CAP-017/018 promoted P2/Wave 2 → P1/Wave 1 per domain-e forcing function (domain-e-agentic-coding-assistant.md §3 items 13/16 DEGRADED closures); CAP-034..038 authored (per-tool-call approval hook CAP-034, rolling context compaction CAP-035, first-party fs tools CAP-036, shell tool CAP-037, search tool CAP-038). P1 count 19→26; P2 count 3→1 (CAP-019 only); total section CAPs 22→29; L2 total 33→38. CAP-018 strengthened with ADR-018 Decision 6 retry-approval ordering. CAP-017 strengthened with Embeddings availability and CAP-035 additive coupling. domain-e-agentic-coding-assistant.md added to inputs. D23 added to decisions list. TD-VSDD-060 sweep: CAP-017/018 removed from P2 section; P2 now CAP-019 only."
  - "1.6 (2026-07-21): F-P131-04/05 adjudication (burst-226) — CAP-022: strict-undefined is now a UNIVERSAL engine-neutral contract; both f-string (default) and jinja2 engines raise E-TMPL-003 on undefined variables (ADR-015 Decision 4 F-P131-04); Security invariant updated to reference TrustLevel::Untrusted explicitly instead of generic 'untrusted-tagged'. CAP-023: 'highest-severity ProvenanceTag across substituted variables' → 'highest-severity TrustLevel across substituted variables' (ADR-015 §Decision 3 F-P131-05). TD-VSDD-060 sibling sweep: no other ProvenanceTag trust-variant or engine-gated strict-undefined residue in this file."
  - "1.5 (2026-07-20): D21 second-half CAP authoring — CAP-028..033 added (SS-21 VectorStore Abstraction, SS-22 Embeddings). P1 count 13→19; total section CAP count 16→22. New section 'P1 — VectorStore Abstraction and Embeddings (Wave 2 / SS-21..22)' added. Grounded in ADR-014 (SS-21), ADR-017 (SS-22), burst-217 handoff table. Domain C forcing-function linkage for SS-22 documented in CAP-031."
  - "1.4 (2026-07-20): D21 first-half CAP authoring — CAP-022..027 added (SS-18 Prompt Templates, SS-19 LC Serialization, SS-20 Document Retrieval). P1 count 7→13; total section CAP count 10→16. Section header updated. Grounded in ADR-014 (SS-20), ADR-015 (SS-18), ADR-016 (SS-19), burst-217 handoff table. D21 added to decisions list. input-hash unchanged (no new planning-level inputs; ADR grounding is inline per convention)."
  - "1.3 (2026-07-17): Provenance-integrity fix — STATE.md removed from inputs (D-NNN decisions baked at authoring time); COMPARATIVE-ASSESSMENT.md added (HS-6/D17-Q5 grounding for CAP-009, CONFLICT-7 for CAP-017, NE-09 for CAP-018, D17-Q7 for CAP-019); domain-c-openclaw.md added (CAP-017 long-horizon memory forcing function); domain-d-hermes-agent.md added (CAP-020/CAP-021 D19/D20 forcing functions); input-hash recomputed."
  - "1.2 (OBS-P77-C, 2026-07-15): ADR-012 DI-001 renamed to ADR-012 INV-1 per architect adjudication D18-P77-A (propagation from BC-2.15.006 v1.1 and ADR-012 v1.2 local-invariant rename)."
  - "1.1 (D20 sub-burst 1, 2026-07-15): CAP-020 (Self-Improvement Primitives, P1) and CAP-021 (MCP Server Role, P1) added per D20 human authority + D19 forcing function (domain-d-hermes-agent.md). P1 count 5→7. ADR-012 is the architecture authority for both new CAPs."
---

# Domain Capabilities — P1 and P2

> **Sharded L2 section (DF-021).** Navigate via `L2-INDEX.md`.
> P0 capabilities are in `capabilities-p0.md`.
> **Pass-21 update:** CAP-012, CAP-013, CAP-016 relocated to `capabilities-p0.md` (elevated
> to P0 per ADV-P1D-PASS-21 F-P21-01). This file now holds P1/P2 only.
> **D20 update (2026-07-15):** CAP-020 and CAP-021 added (P1). See changelog.
> **D21 update (2026-07-20):** CAP-022..033 added (P1, full D21 expansion SS-18..22). First
> half (CAP-022..027): SS-18 Prompt Templates, SS-19 LC Serialization, SS-20 Document
> Retrieval. Second half (CAP-028..033): SS-21 VectorStore Abstraction, SS-22 Embeddings.
> P1 count 7→19; total P1/P2 count 10→22. See changelog and the two D21 sections below.
> **D23 update (2026-07-22):** CAP-017 and CAP-018 promoted P2/Wave 2 → P1/Wave 1 (domain-e
> forcing function). CAP-034..038 authored: per-tool-call approval hook (ADR-018), rolling
> context compaction (ADR-019), first-party tool library fs/shell/search (ADR-020 / SS-23).
> P1 count 19→26; P2 count 3→1 (CAP-019 only); total 33→38. See D23 section below.
> **D-170 update (2026-08-17):** CAP-039 authored (LCEL fan-out and identity-pass-through
> composition: RunnableParallel, RunnablePassthrough, RunnableAssign). Human-directed
> Phase-1 approval-gate scope expansion analogous to D21/D23. P1 count 26→27; total 38→39.
> See D-170 section below.

---

## P1 — Partners, Conformance, MCP, and Server (Wave 2 + Wave 0/1)

### CAP-009: Provider-Conformant Chat Model Interface

Expose a chat model trait that passes pregolya-standard-tests for streaming, tool calling,
structured output, error propagation, and token accounting. First-party implementations for
OpenAI, Anthropic, Ollama. Architecture uses standalone SDK crate split (HS-6/D17-Q5):
`pregolya-<provider>-sdk` (wire client) + `pregolya-<provider>` (Runnable adapter).

**Grounding:** product-brief.md §Scope Wave 2 — `pregolya-openai`, `pregolya-anthropic`,
`pregolya-ollama` first-party provider crates (D3 early-integration priority); standalone
SDK crate split architecture (HS-6/D17-Q5).
**Anchor justification:** CAP-009 covers provider conformance because the brief names the three
provider crates explicitly in Wave 2 scope and market differentiator #5 requires a
LangChain-semantic migration story.

### CAP-010: MCP Tool Adapter

Discover tools from MCP servers at runtime, present them to a graph as standard pregolya
Tools, and route ToolInvocation requests to the correct MCP server transport. Treat all
tool-result content as untrusted ingress (DI-012). Target semantic surface:
langchain-mcp-adapters==0.3.0 (D1/D2).

**Grounding:** product-brief.md §Scope Wave 2 — `pregolya-mcp` port of
langchain-mcp-adapters==0.3.0 (D2); MCP client adapter for security, productivity, and
custom server integration.
**Anchor justification:** CAP-010 covers MCP adapter because D1 mandates pregolya-mcp as
the primary integration surface after langchain-community was archived. Overflow §MCP-Surface
lists verified active MCP servers that must be supported.

### CAP-011: Provider Conformance Suite (Standard Tests)

Provide a test crate (`pregolya-standard-tests`) that every pregolya provider crate must
pass before v1 release. Tests exercise: streaming completions, tool-call round-trips,
structured output, error-type fidelity, and token-usage accounting. Port of LangChain's
`langchain-tests` conformance suite.

**Grounding:** product-brief.md §Scope Wave 2 — `pregolya-standard-tests` port of
LangChain's langchain-tests conformance suite; "all Wave 2 provider crates must pass before
v1 release."
**Anchor justification:** CAP-011 covers the conformance suite because it is an explicit Wave 2
deliverable named in the brief and market differentiator #2.

### CAP-014: Durable-Run HTTP Server (Threads, Assistants, Runs, Crons)

Provide a first-party HTTP server that manages: Thread (durable conversation history),
Assistant (named agent config), Run (single execution), and CronSchedule (recurring
proactive runs). Streaming and unary run endpoints drive the same graph execution engine.
No wire-compatibility with LangGraph Platform (D13).

**Grounding:** product-brief.md §Scope Wave 1 — `pregolya-server`: threads, assistants,
cron scheduler, streaming and unary run equivalence (NE-13/D17); first-party per D13.
**Anchor justification:** CAP-014 covers pregolya-server because D13 names it as first-party
and the brief lists its required resource types (threads, assistants, cron, streaming/unary
equivalence) explicitly.

### CAP-015: Sandboxed Tool Execution (Enforcing Backend Default)

Execute tools in an enforcing isolation backend (WASM or container) by default. The process
backend requires explicit opt-in and emits a loud warning. On a strict policy with a
non-enforcing backend, return `Err(PolicyNotEnforceable)` — do not silently fall back. All
workspace file operations call `canonicalize_beneath_root(base, path)` at access time.

**Grounding:** product-brief.md §Scope Wave 0 NE catalog — NE-01/NE-02/D17: "Enforcing
sandbox backend (WASM/container) must be the default; process backend is loud opt-in."
**Anchor justification:** CAP-015 covers sandbox enforcement because NE-01 and NE-02 are both
named as first-class BC candidates in the brief's Overflow §Security-PRD-Carry-Forward.

### CAP-020: Self-Improvement Primitives (Skill Registry, Guarded Memory Writes, Frozen-Snapshot Context Mutation)

Provide three framework-scope primitives that enable a self-improving agent loop:
(a) **Skill registry** (`memory::skills`): load skill documents (agentskills.io SKILL.md pattern)
into agent context on demand; list skills by tag; check existence without loading. Skill
documents stored as ordinary KV entries in `MemoryStore` with routing semantics added by
`SkillStore`. (b) **Guarded memory/skill writes** (`core::write_guard` + `memory::write_guard`):
every write to a guarded memory namespace goes through `MemoryWriteGuard::validate(req)`
before commit; validator returns Allow / Deny(reason) / Transform(sanitized); built-in scanner
checks for prompt-injection patterns and invisible-Unicode; Deny raises `E-MEMORY-007
MemoryWriteGuardDenied`. (c) **Frozen-snapshot context mutation** (`core::context_mutation` +
`graph::scheduler`): `RunnableConfig.context_mutations` declares which memory keys are loaded
into the system-prompt context; loaded once at run start before the first super-step; writes
during the run take effect on the NEXT run (cache-coherence invariant, per ADR-012 INV-1).

**Grounding:** D20 human authority — self-improvement loop promoted from application-layer to
framework-scope. domain-d-hermes-agent.md req 4 (runtime-mutable procedural skills) and req 3
(frozen-snapshot system-prompt semantics) are the forcing functions.
**Anchor justification:** CAP-020 is a net-new capability with no prior CAP ID. It covers the
three primitives ADR-012 Decision 1 adopts: skill registry in `pregolya-memory`, write guard
split between `pregolya-core` (types/trait) and `pregolya-memory` (enforcement), and
context mutation config in `pregolya-core` loaded by `pregolya-graph`.
**Architecture authority:** ADR-012 (`decisions/ADR-012-self-improvement-primitives.md`).

### CAP-021: MCP Server Role (Expose Registered Tools as MCP Server Endpoint)

Expose pregolya's registered tools and resources as an MCP server so that external LLM
applications can connect as MCP clients and invoke pregolya tools via the MCP protocol.
`mcp::server` module in `pregolya-mcp` provides: server startup with a configured transport
(stdio or SSE), `tools/list` advertisement of all tools registered in the tool registry,
`tools/call` dispatch to the underlying pregolya `Tool` implementation and return of the
result via MCP response format. This is the **server** role complementing the existing MCP
**client** role (CAP-010 / SS-09 / BC-2.09.001–005).

`GraphAgentTool` (`mcp::graph_tool`) wraps a registered `CompiledStateGraph` as a `DynTool`,
enabling pregolya agent graphs to be registered in the `ToolRegistry` and exposed to external
MCP clients via the same `tools/list` advertisement and `tools/call` dispatch paths. The
STATE-ISOLATION invariant ({INV-001}) restricts the output to only the fields selected by the
caller-supplied `extract_output` closure — no internal checkpoint IDs, run IDs, message
history, or intermediate node state are included unless explicitly selected.
`GraphToolApprovalPolicy::DenyInterrupts` (default, fail-closed) converts any in-graph
`interrupt()` call to `Err(E-MCP-010 GraphAgentInterruptDenied)`.
**Authored BCs:** BC-2.09.008 (GAP-01/D-275 — `GraphAgentTool` wrapping of `CompiledStateGraph`
as `DynTool`; STATE-ISOLATION {INV-001}; fail-closed interrupt policy
`GraphToolApprovalPolicy::DenyInterrupts`; E-MCP-010 `GraphAgentInterruptDenied`; VP-016 proptest P1).

**Grounding:** D19 forcing function — domain-d-hermes-agent.md req 11 ([NEW framework-scope]):
"pregolya exposes its own tools and resources via the MCP protocol so that other LLM
applications can connect as clients — entirely absent from all BCs and capabilities." D20
adoption decision includes MCP server role in Phase-1 scope.
**Anchor justification:** CAP-021 is a net-new capability. MCP client role (CAP-010) covers the
client direction; CAP-021 covers the server direction. These are architecturally independent
surfaces in `pregolya-mcp`: client code (`mcp::client`) and server code (`mcp::server`) are
separate modules. CAP-010 cannot cover server-role behavior without creating a
client-vs-server semantic collision.

---

## P1 — Prompt Templates, LC Serialization, and Document Retrieval (Wave 2 / SS-18..20)

> D21 ecosystem-parity scope expansion (burst 216) promoted SS-18 (Prompt Templates),
> SS-19 (LC Serialization), and SS-20 (Document Retrieval) to full v1 scope.
> CAP-022..027 author the first-half D21 expansion. SS-21 (VectorStore Abstraction) and
> SS-22 (Embeddings) CAPs will follow in the second-half D21 authoring pass.

### CAP-022: PromptTemplate and ChatPromptTemplate as Runnable (f-string Default, Jinja2 Optional)

Construct single-message PromptTemplates and multi-message ChatPromptTemplates as Runnables.
Render via f-string engine (always-on, in-house ~100 LOC, Python `str.format` semantics:
`{variable}` substitution, `{{` / `}}` literal-brace escapes, no nested attribute access in v1;
strict-undefined: raises E-TMPL-003 when a `{variable}` placeholder references a name absent
from the input variable map — always-on regardless of engine).
Optionally render via jinja2 engine (Cargo feature `"jinja2"`, minijinja 2.x, sandboxed mode
mandatory; strict-undefined: minijinja configured with `strict_undefined = true`, raising
E-TMPL-003 for undefined references — same error, same semantics as f-string engine).
**Strict-undefined is a UNIVERSAL engine-neutral contract** (ADR-015 Decision 4, F-P131-04
adjudication): E-TMPL-003 is raised by BOTH engines on any undefined variable reference.
Callers may not assume undefined variables are silently empty-substituted in either engine.
Support partial variable binding: pre-bound variables are merged with call-time variables;
call-time wins on key collision. Detect required variable names at template-construction time
(static introspection, not deferred to render).

**Grounding:** D21 human authority (burst 216) — SS-18 (pregolya-prompts) promoted from
post-v1/community to full v1 scope, superseding the product-brief §Out-of-Scope entry for
PromptTemplate. ADR-015 Decision 1 establishes pregolya-prompts as crate #19. Burst-217
handoff table names "template construction, rendering, injection guard, FewShot" as SS-18 CAP
targets.
**Anchor justification:** CAP-022 covers PromptTemplate and ChatPromptTemplate as Runnable
because D21 explicitly names SS-18 as a v1 deliverable, ADR-015 Decision 4 locks f-string as
the default engine (mustache DROPPED as production-grade violation — crates.io stale since
2018; jinja2 optional via minijinja 2.x), and partial variable binding is required per semport
rust-translation-strategy §4 `.partial()` requirement. Rendering and composition cannot share
a CAP with FewShot/MessagesPlaceholder because the acceptance shapes differ (scalar vs
message-list substitution).
**Security invariant:** SystemMessage slots are hard-coded `TrustRequired`; variables carrying
`TrustLevel::Untrusted` (see entities-graph.md §TrustLevel) substituted into a TrustRequired
slot → E-TMPL-001 (SECURITY/InjectionAttempt) at render time via `injection_guard` pure-core
blocker (ADR-015 Decision 3). This block is unconditional — not dependent on a configured
GuardrailHook. VP-006 Kani candidate.
**Architecture authority:** ADR-015.

### CAP-023: MessagesPlaceholder and FewShotPromptTemplate — Message-List and Few-Shot Composition

Insert a named `Vec<Message>` variable into a chat template position via `MessagesPlaceholder`,
enabling dynamic message-list injection (conversation history windows, streamed tool-result
sequences). Compose few-shot examples into a ChatPromptTemplate via `FewShotPromptTemplate`:
accepts a `Vec` of `(input, output)` example pairs, formats each as a Human/AI message pair,
and injects the sequence before the user-turn slot. All composition produces a `PromptValue`
output carrying per-message `MessageProvenance` (highest-severity `TrustLevel` across
substituted variables + SlotTrustPolicy), enabling downstream guardrail and observability use
(ADR-015 Decision 3).

**Grounding:** D21/SS-18. MessagesPlaceholder and FewShot* are first-class LangChain v1
composition types (semport Corpus 1, langchain==1.3.13). Burst-217 handoff table lists
"FewShot" alongside template construction and rendering as explicit SS-18 CAP targets.
**Anchor justification:** CAP-023 is separated from CAP-022 because MessagesPlaceholder and
FewShot operate at message-list granularity, not scalar-string substitution. MessagesPlaceholder
expands a `Vec<Message>` variable in-place; FewShotPromptTemplate drives a template-per-example
composition loop producing multiple message pairs. Each has an independent BC acceptance shape
(message-list expansion vs. example-sequence formatting) that cannot be collapsed into
CAP-022's f-string/jinja2 scalar rendering shape.
**Architecture authority:** ADR-015.

### CAP-024: LcSerializable Round-Trip (Serialize → Serialized → Deserialize → Equivalent Value)

Serialize any type implementing `LcSerializable` to a `Serialized::Constructor` JSON envelope
(fields: `lc`, `id: Vec<String>`, `kwargs: Map<String, Value>`) and deserialize back to a
type-equivalent value via Reviver. Round-trip invariant: `deserialize(serialize(x))` produces
a value semantically equivalent to `x` for all 141 core-registered types. Credential fields
listed in `lc_secrets()` are stripped from `kwargs` before serialization and before Reviver
dispatch — they are never present in the wire representation (DI-010 credential opacity).
`LcSerializable::is_lc_serializable()` returns false for types that opt out; no serialization
is attempted for opt-out types.

**Grounding:** D21/SS-19. The lc-JSON round-trip protocol is a first-class LangChain v1
serialization contract characterized in semport Pass 7 + Pass 8 ADR-3
(rust-translation-strategy §9). ADR-016 Decision 1 places `core::serializable` in
pregolya-core with 141 core registrations. Decision 3 Property 3 defines the lc_secrets
stripping invariant grounded in DI-010.
**Anchor justification:** CAP-024 covers the serialize→deserialize lifecycle including secret
stripping because ADR-016 Decisions 2 and 3 together specify these behaviors as the core
safety-critical lc-JSON contract. The 141-entry count grounds the v1 scope in the semport
analysis; any new registration requires an `inventory::submit!` call, not a spec amendment.
CAP-024 covers behavioral equivalence; CAP-025 covers containment and error handling — the two
are distinct BC axes.
**Architecture authority:** ADR-016.

### CAP-025: Reviver and Type Registry (Inventory-Based; Allowlist Containment; Legacy-Namespace Remap)

Deserialize a `Serialized::Constructor` to a typed value by looking up `id` in the
`inventory`-based static registry of `LcEntry` records, populated at link time via
`inventory::submit!` (no runtime mutation possible — allowlist is structurally determined by
Cargo feature selection). The valid-namespace allowlist is derived from the registered set at
startup (OnceLock<HashSet<String>>) not hand-maintained, so allowlist-vs-registry drift cannot
occur. Unknown `id` → E-SRLZ-001 (structured error; no silent None, no fallback).
`langchain`-monolith types (12 entries: LLMChain, ToolAgentAction, OutputFixingParser, etc.)
→ E-SRLZ-002 (structured error with clear message). Legacy namespace aliases
(OLD_CORE_NAMESPACES_MAPPING, 58 entries) remap transparently to canonical constructors.
Path-based loading does not exist — the registry is the only deserialization path, eliminating
the path-traversal attack class entirely.

**Grounding:** D21/SS-19. ADR-016 Decisions 2 and 3 define the five untrusted-input safety
properties, allowlist derivation (derived-not-hand-maintained), the 12 langchain-monolith
entries (E-SRLZ-002), and 58 legacy aliases — all explicitly characterized in semport Pass 8
ADR-3. No path-based loading per ADR-016 Decision 3 Property 2.
**Anchor justification:** CAP-025 is separated from CAP-024 because the Reviver and registry
are the containment and error-handling surface for unknown or untrusted input; CAP-024
describes the round-trip behavioral contract for known registered types. Distinct BC axes:
CAP-024 = behavioral equivalence; CAP-025 = allowlist containment, E-SRLZ-001/002, legacy
remap, no-path-loading. VP-010 Kani candidate (type not in registry never successfully
deserializes) is anchored to this CAP.
**Architecture authority:** ADR-016.

### CAP-026: Retriever Trait — get_relevant_documents; Arc<dyn Retriever> Seam; DI-012 RAGRetrieval Guardrail Coverage

Provide the `Retriever` dyn-compatible async trait (`pregolya-core: core::retriever`):
`async fn get_relevant_documents(&self, query: &str) → Result<Vec<Document>, PregolyaError>`.
Object-safe via `#[async_trait]` desugaring and `&self` receiver, consistent with ADR-005
precedent. Graph nodes hold `Arc<dyn Retriever>` for RAG operations without depending on
pregolya-vectorstores. All `Document` values returned by any `Retriever` implementation and
entering graph context pass the `BoundaryType::RAGRetrieval` guardrail (DI-012 / BC-2.11.001)
— the existing `BoundaryType::RAGRetrieval` variant already covers this seam; no BoundaryType
extension is required (ADR-014 §Consequences confirms this explicitly).

**Grounding:** D21/SS-20. ADR-014 Decision 1 places `Retriever` in pregolya-core for the
same gravity reason as `Runnable` and `BaseChatModel` — graph nodes performing RAG need
`Arc<dyn Retriever>` without pulling in pregolya-vectorstores. DI-012 / BC-2.11.001's
`BoundaryType::RAGRetrieval` variant was authored before D21 and already covers RAG retrieval
ingress; ADR-014 §Consequences confirms no extension is needed.
**Anchor justification:** CAP-026 covers the Retriever trait seam because it is the dyn-dispatch
boundary all RAG-using graph nodes depend on. The DI-012 linkage is mandatory: documents
entering graph context via any Retriever are untrusted RAG ingress by definition (DI-012
source: NE-06, HS-8, D17-Q8). CAP-026 confirms DI-012 coverage — it does not redefine or
extend BC-2.11.001, which remains the BC authority for the guardrail invariant.
**Architecture authority:** ADR-014.

### CAP-027: VectorStoreRetriever — SearchType Enum; k / fetch_k / lambda_mult Configuration

Provide a concrete `Retriever` implementation (`VectorStoreRetriever` in
`pregolya-vectorstores: vectorstores::retriever`) backed by `Arc<dyn VectorStore>`,
configurable via:
- **SearchType enum:** `Similarity` (default) | `SimilarityScoreThreshold { score_threshold: f32 }` | `Mmr`
- **k:** number of final documents to return; negative `k` returns `Err(E-VS-003 InvalidConfig)` — rejected, not clamped (D-44)
- **fetch_k:** candidate pool size fetched before MMR re-ranking (applicable to SearchType::Mmr only); `fetch_k < k` returns `Err(E-VS-003 InvalidConfig)` — rejected, not clamped (D-44)
- **lambda_mult ∈ [0.0, 1.0]:** MMR diversity parameter (0.0 = maximum diversity, 1.0 = pure relevance); values outside [0.0, 1.0] return `Err(E-VS-003 InvalidConfig)` — rejected, not clamped (D-44)

Constructed via `VectorStore::as_retriever(self: Arc<Self>) → Result<VectorStoreRetriever, PregolyaError>` — a concrete (non-opaque) fallible constructor: returns `Err(E-VS-003 InvalidConfig)` when config is invalid (lambda_mult outside [0.0, 1.0]; fetch_k < k for SearchType::Mmr). Preserves VectorStore dyn-compatibility (ADR-014 Decision 2 §Object-safety). Implements
`Retriever` and can be type-erased to `Arc<dyn Retriever>` for use in graph nodes via the
CAP-026 seam. DI-012 RAGRetrieval guardrail applies to all returned Documents via CAP-026.

**Grounding:** D21/SS-20/SS-21. ADR-014 Decision 2 defines the `VectorStoreRetriever` struct
and fields, the `SearchType` enum variants and behavioral semantics, and the `as_retriever()`
concrete-return-type pattern required for E0038-safe VectorStore dyn-compatibility.
**Anchor justification:** CAP-027 is separated from CAP-026 because VectorStoreRetriever is a
specific, configurable VectorStore-backed implementation with its own BC surface (SearchType,
k, fetch_k, lambda_mult). CAP-026 is the abstract `Arc<dyn Retriever>` seam in pregolya-core;
CAP-027 is the concrete VectorStore-backed implementation in pregolya-vectorstores. The two
have independent acceptance shapes. The `as_retriever()` concrete-return-type design is a load-
bearing object-safety choice documented in ADR-014 (dyn-compatible via non-opaque return).
**Architecture authority:** ADR-014.

---

## P1 — VectorStore Abstraction and Embeddings (Wave 2 / SS-21..22)

> D21 second-half expansion. SS-21 (VectorStore Abstraction) lives in pregolya-vectorstores
> (crate #20). SS-22 (Embeddings) lives in pregolya-core (core::embeddings) plus provider
> modules in pregolya-openai and pregolya-ollama. pregolya-anthropic has NO embedding
> impl (Anthropic has no public embedding API — ADR-017 Decision 3).

### CAP-028: VectorStore Trait — add_documents; Similarity Search; MMR; delete; as_retriever (Concrete Return for Dyn-Compat)

Provide the `VectorStore` async trait (`pregolya-vectorstores: vectorstores::store`) with
instance methods only — all `&self` receivers, dyn-compatible via `#[async_trait]` desugaring:
`add_documents(docs: Vec<Document>)` (returns Vec<String> of assigned document IDs),
`similarity_search(query, k)` (k-nearest documents),
`similarity_search_with_score(query, k)` (returns Vec<(Document, f32)> with scores ∈ [0.0, 1.0]),
`max_marginal_relevance_search(query, k, fetch_k, lambda_mult)` (diversity-aware MMR retrieval),
`delete(ids)`, and `as_retriever(self: Arc<Self>) → Result<VectorStoreRetriever, PregolyaError>` (concrete, non-opaque fallible return — `Err(E-VS-003 InvalidConfig)` on invalid config; required to preserve VectorStore dyn-compatibility, ADR-014 Decision 2 §Object-safety).
Static constructors (`from_texts`) live on the separate `VectorStoreFactory` trait (Sized-bounded,
NOT on the VectorStore vtable) — this split is required for E0038-safe `Arc<dyn VectorStore>`.
`add_documents` uses `&self` (not `&mut self`) because external backends are stateless from the
client perspective; the in-memory backend uses `RwLock` interior mutability (CAP-029).

**Grounding:** D21/SS-21. ADR-014 Decision 2 specifies the VectorStore trait instance method
surface, the `&self`-not-`&mut self` rationale, the `as_retriever` concrete-return-type
requirement, and the `VectorStoreFactory` separation for E0038-safe dyn dispatch.
**Anchor justification:** CAP-028 covers the VectorStore trait (abstract seam) because it is the
foundational document-index contract that the in-memory backend (CAP-029), MetadataFilter
(CAP-030), and all future community adapters implement. The `VectorStoreFactory` split is a
load-bearing architectural constraint (not a style preference) — a `fn from_texts()` on the
main VectorStore trait would make `Arc<dyn VectorStore>` impossible in Rust (E0038). BC authors
must express the `as_retriever()` concrete-return-type invariant in the BC acceptance shape.
**Architecture authority:** ADR-014.

### CAP-029: InMemoryVectorStore — Arc<dyn Embeddings> DI; RwLock Interior Mutability; Vec<f32> Cosine; E-VS-001 Zero-Norm Guard

Provide the reference `VectorStore` implementation (`pregolya-vectorstores: vectorstores::memory`,
struct `InMemoryVectorStore`) backed by `RwLock<Vec<(Document, Vec<f32>)>>` (document +
pre-computed embedding vector). Constructed with `Arc<dyn Embeddings>` injected at creation
time via `VectorStoreFactory::from_texts_sync` — Arc-DI wiring per workspace convention; no
placeholder construction is permitted. Text queries are converted to query vectors via the injected
`Embeddings` impl at search time. Document vectors are generated at `add_documents` time.
Cosine similarity is computed from `Vec<f32>` inner products (no ndarray — semport §8 avoidance).
**Zero-norm guard (ADR-014 Decision 2 §Hardening note):** before any cosine division, the implementation
checks `norm = vec.iter().map(|x| x*x).sum::<f32>().sqrt()`. If `norm == 0.0`:
`return Err(PregolyaError { code: "E-VS-001", .. })` (registered in error-taxonomy.md §Component: VS — E-VS-001, VAL, zero-norm cosine guard, BC-2.21.003). A zero-length embedding produces NaN that silently corrupts ranking — this guard
is two lines and is unconditional. Implements `VectorStoreFactory` for `from_texts_sync`.

**Grounding:** D21/SS-21. ADR-017 Decision 4 specifies the InMemoryVectorStore struct
(`Arc<dyn Embeddings>` + `RwLock<Vec<(Document, Vec<f32>)>>`), the Arc-DI wiring contract,
and the `Vec<f32>` cosine approach (semport §8 avoidance of ndarray in core). ADR-014 Decision 2 §Hardening note specifies the zero-norm guard and its VP-009 connection (Zero-Norm Cosine Guard
on `cosine_similarity` in `vectorstores::similarity`: fail-closed via E-VS-001 before division;
`Ok(f32::NAN)` is unreachable for any input — BC-2.21.003, DI-014, harness `zero_norm_guard_fail_closed`).
**Anchor justification:** CAP-029 is separated from CAP-028 because the in-memory implementation
has its own BC surface — Arc-DI wiring, RwLock semantics, Vec<f32> cosine math, NaN prevention
via E-VS-001, and VP-009 (Kani Zero-Norm Cosine Guard — `zero_norm_guard_fail_closed` on
`cosine_similarity`, BC-2.21.003, DI-014). These are not part of the abstract VectorStore
contract and must not be forced on external backends.
**Architecture authority:** ADR-014.

### CAP-030: MetadataFilter — Eq / Ne / In Clause Filtering on Document Metadata During Search

Provide optional metadata-based pre/post-filtering for VectorStore similarity searches via
`MetadataFilter { filters: Vec<FilterClause> }` with clause types `Eq { key: String, value: Value }`,
`Ne { key, value }`, `In { key, values: Vec<Value> }`. MetadataFilter is an optional parameter
on an additive `similarity_search_with_filter` method — it does NOT change the base VectorStore
trait contract and does NOT break existing implementations that omit it. Community adapters
supporting native server-side metadata filtering dispatch the filter to the backend; the
InMemoryVectorStore (CAP-029) applies MetadataFilter as a post-filter over the similarity result
set. Both `MetadataFilter` and `FilterClause` are `#[non_exhaustive]`; new clause variants
(e.g., `Gte`, `Lt`, `Contains`) can be added in future minor versions without breaking existing
match arms in community adapter implementations.

**Grounding:** D21/SS-21. ADR-014 Decision 2 §Metadata filter surface defines the MetadataFilter
and FilterClause types (Eq/Ne/In), the additive `similarity_search_with_filter` method pattern,
and the pre-filter (native adapters) vs post-filter (in-memory) behavioral split.
**Anchor justification:** CAP-030 is separated from CAP-028 because MetadataFilter is an optional
capability addon — community adapters may or may not support it natively — and it must not be
a required method on the base VectorStore contract. Its own BC axis covers clause semantics,
evaluation order, and the native-vs-post-filter distinction.
**Architecture authority:** ADR-014.

### CAP-031: Embeddings Trait — embed_documents (Batch); embed_query; Dimensionality Contract; Arc<dyn Embeddings> Seam

Provide the `Embeddings` dyn-compatible async trait (`pregolya-core: core::embeddings`):
`async fn embed_documents(&self, texts: Vec<String>) → Result<Vec<Vec<f32>>, PregolyaError>`
and `async fn embed_query(&self, text: String) → Result<Vec<f32>, PregolyaError>`.
Object-safe via `&self` receivers and `#[async_trait]` desugaring (ADR-005 precedent). `Arc<dyn
Embeddings>` compiles without E0038. **Dimensionality contract** (MUST hold for every impl):
(1) `embed_documents(texts).len() == texts.len()` — one vector per input; (2) all returned
vectors have identical length (the model's embedding dimension); (3) `embed_query` returns a
vector of the same length as any `embed_documents` vector for the same model. Contract violation
→ `Err(PregolyaError { code: "E-EMBED-001", .. })` (registered in error-taxonomy.md §Component: EMBED — E-EMBED-001, VAL, dimensionality contract violation, BC-2.22.001). Batch failure (e.g., provider rate limit mid-batch) → entire call returns `Err` —
no silent partial-batch degradation to a truncated or empty Vec (DI-014). VP-008 proptest
candidate (any valid Embeddings impl returns vectors with consistent length across embed_documents
and embed_query).

**Grounding:** D21/SS-22. ADR-017 Decisions 1 and 2 place `Embeddings` in pregolya-core
(same gravity as Retriever, BudgetPolicy, GuardrailHook — avoiding dependency inversion with
pregolya-memory), define the `&self`/`#[async_trait]` dyn-compatible shape, the three
dimensionality invariants, and the DI-014-aligned batch error semantics.
**Anchor justification:** CAP-031 covers the Embeddings trait seam because it is the dyn-dispatch
boundary used by InMemoryVectorStore (CAP-029 via Arc<dyn Embeddings>), pregolya-memory
(semantic search), and all first-party and community embedding providers. Placement in
pregolya-core is required — if the trait lived in pregolya-vectorstores, pregolya-memory
would depend on pregolya-vectorstores (inverted dependency direction).
**Forcing-function linkage (Domain C — OpenClaw):** Domain C requires pluggable embedding
backends as a [NEW] forcing-function requirement. CAP-017's vector retrieval path (long-horizon
memory with vector similarity) is only executable with a concrete `Embeddings` impl at runtime.
CAP-031 is the abstract seam; CAP-032 (OpenAI) and CAP-033 (Ollama) are the first-party v1
impls that make Domain C's vector path holdout-executable. This is the one strictly
holdout-necessary piece of D21: without CAP-031/032/033, the Domain C evaluation cannot
complete the vector retrieval branch.
**Architecture authority:** ADR-017.

### CAP-032: EmbeddingsOpenAI — text-embedding-3-small/large; OpenAiApiKey Newtype; Batch Semantics; reqwest/rustls-tls

Provide a first-party `Embeddings` impl (`pregolya-openai: openai::embeddings`, struct
`EmbeddingsOpenAI`) targeting the OpenAI `/v1/embeddings` endpoint. **Model currency
(crates.io/2026-07-20):** `text-embedding-3-small` (default — cost/performance balance),
`text-embedding-3-large` (higher quality), `text-embedding-ada-002` (legacy — still supported
by OpenAI but superseded by the 3-series). Model name is a configurable `String` field (not an
enum) so future models are supported without a breaking change. **Credential handling:** API key
is accepted as `OpenAiApiKey` newtype with redacted `Debug` implementation — credential values
never appear in AI context, logs, or lc-JSON serialized output (DI-010). **Batch failure:**
if the provider returns a partial batch error (e.g., rate limit), the entire call returns `Err`
— no silent partial-batch degradation (DI-014). **HTTP client:** reqwest MUST use
`default-features = false, features = ["rustls-tls"]` and `.timeout(Duration::from_secs(30))`
(DI-009); workspace CI gate `check-client-timeout` enforces the timeout constraint.

**Grounding:** D21/SS-22. ADR-017 Decision 3 specifies pregolya-openai gaining
`openai::embeddings`, model currency (verified crates.io/2026-07-20), OpenAiApiKey
newtype credential handling (DI-010), batch-failure Err semantics (DI-014), and the
reqwest/rustls-tls/timeout constraints (DI-009).
**Anchor justification:** CAP-032 is separated from CAP-031 (the abstract trait) because it is
a provider-specific implementation with its own BC surface: OpenAI endpoint configuration,
model name selection, OpenAiApiKey DI, HTTP client constraints, and batch error behavior at
the provider boundary.
**Architecture authority:** ADR-017.

### CAP-033: EmbeddingsOllama — Model-Configurable; /api/embed (Default); use_legacy_endpoint Toggle; No API Key

Provide a first-party `Embeddings` impl (`pregolya-ollama: ollama::embeddings`, struct
`EmbeddingsOllama`) for local Ollama deployments. No model default — callers configure a
locally-pulled model name (e.g., `nomic-embed-text`, `mxbai-embed-large`). No API key
required (Ollama is a local service; uses the existing Ollama base URL config). **Endpoint
behavior (ADR-017 Decision 3):** default sends `POST /api/embed` with `{ model, input: [text] }`
(preferred — newer Ollama releases). When `use_legacy_endpoint: bool` is set to `true`, sends
`POST /api/embeddings` with `{ model, prompt: text }` (legacy fallback for Ollama deployments
that predate `/api/embed`). The legacy toggle is an explicit opt-in, not silent auto-detection
or feature sniffing. **HTTP client:** reqwest MUST use `default-features = false, features =
["rustls-tls"]` and `.timeout(Duration::from_secs(30))` (DI-009) — the 30-second timeout
applies even for localhost targets; the workspace CI gate enforces this unconditionally.

**Grounding:** D21/SS-22. ADR-017 Decision 3 specifies pregolya-ollama gaining
`ollama::embeddings`, the `/api/embed` preferred endpoint with `use_legacy_endpoint` toggle
for `/api/embeddings`, the no-API-key characteristic, and the reqwest/rustls-tls/timeout
constraints.
**Anchor justification:** CAP-033 is separated from CAP-032 because Ollama embeddings have a
distinct operational profile: no API key, local deployment, fully configurable model, and a
dual-endpoint legacy compatibility requirement with its own BC axis (endpoint selection, toggle
semantics, failure behavior when the local Ollama process is unreachable on the configured
base URL).
**Architecture authority:** ADR-017.

---

## P1 — Long-Horizon Memory, Tool Retry, Approval Hook, Context Compaction, and First-Party Tools (Wave 1, D23)

> **D23 (2026-07-22):** CAP-017 and CAP-018 promoted P2/Wave 2 → P1/Wave 1 per
> domain-e-agentic-coding-assistant.md §3 items 13 and 16 DEGRADED closures. CAP-034
> through CAP-038 are net-new D23 capabilities: per-tool-call approval hook (ADR-018),
> rolling context compaction (ADR-019), and first-party tool library (ADR-020 / SS-23).

### CAP-017: Long-Horizon Cross-Session Memory Store (KV + Vector) [D23: P2→P1, Wave 2→Wave 1]

Persist key-value and vector-embedding memory across threads, decoupled from checkpoints.
Support hybrid retrieval (vector similarity + keyword). Provide user-private, app-scoped,
and session-scoped tiers. GDPR erasure must remove all traces from all tiers (CONFLICT-7
memory scope model). Default backend: SQLite with optional vector embeddings via the
`Arc<dyn Embeddings>` seam (CAP-031/032/033 — Embeddings impls are v1 deliverables, making
the vector retrieval path holdout-executable from Wave 1). Rolling compaction (CAP-035) MAY
write CompactionSummary to MemoryStore as an additive opt-in path (ADR-019 Decision 5); the
two capabilities are independent — within-session compaction works without CAP-017, and
CAP-017 is available without CAP-035.

**Grounding:** product-brief.md §Constraints (implied by Domain C OpenClaw forcing function
and LangGraph Store analog); CONFLICT-7 memory scope — user/app/session partitioning + GDPR
erasure; domain-c-openclaw.md §2.6; domain-e-agentic-coding-assistant.md §3 item 13 / §6
"Multi-session cross-session project memory" DEGRADED — D23 Wave 1 promotion authority.
**Anchor justification:** CAP-017 covers long-horizon memory because Domain C identifies
file-backed memory with vector retrieval as a gap (domain-c §5, item #2), CONFLICT-7 shapes
the tier model, and Domain E requires multi-session project knowledge accumulation for the
coding-assistant holdout evaluation. **D23 promotion (2026-07-22):** elevated P2/Wave 2 →
P1/Wave 1; Embeddings impls (CAP-031/032/033) are now Wave 1 deliverables, making the full
vector retrieval path viable at v1.

### CAP-018: Tool Retry with Circuit Breaker [D23: P2→P1, Wave 2→Wave 1]

Retry tool invocations with a per-tool retry policy keyed by `(tool_name)` — not args hash.
Enforce a finite `global_limit` (not None). Trip a circuit breaker after repeated failures
to prevent infinite retry on permanently failing tools.

**Retry-approval ordering (ADR-018 Decision 6):** The ordered dispatch sequence for each
tool invocation is: `circuit_breaker.check(tool_name)` → `pre_tool_dispatch(hook)` →
`tool.invoke(args)` → `retry_policy.record(result)`. Circuit-breaker check is first — if
the breaker is open, no approval dialog is presented (fast-reject for persistently failing
tools). Each retry attempt flows through `pre_tool_dispatch(hook)` independently — an
interactive PreToolCallHook may deny a retry even if it approved the first attempt. See
CAP-034 for the per-tool-call approval hook.

**Grounding:** product-brief.md §Constraints NE catalog — NE-09 (adk-rust P-63 termination
hole REJECT): "Retry bound keyed on (tool_name) not args; finite global_limit non-None
default; circuit-breaker on by default." domain-e-agentic-coding-assistant.md §3 item 16 /
§6 "Tool retry for transient failures" DEGRADED — D23 Wave 1 promotion authority.
**Anchor justification:** CAP-018 covers tool retry because NE-09 is listed in the NE catalog
as a pregolya requirement derived from the adk-rust counter-example. **D23 promotion
(2026-07-22):** elevated P2/Wave 2 → P1/Wave 1; transient bash/network failures in
coding-agent loops require circuit-breaker protection for Domain E holdout reliability.
Retry-approval ordering (ADR-018 Decision 6) is a new v1 constraint added at promotion time.

### CAP-034: Per-Tool-Call Interactive Approval Hook (PreToolCallHook / PreToolDecision)

Provide a first-class `PreToolCallHook` trait in `pregolya-graph::hitl` (NOT
pregolya-core — no dependency-inversion motivation exists; ADR-018 Decision 1 rationale)
that the graph engine invokes before every tool dispatch, eliminating the 2-node-per-tool
workaround. `GraphConfig.pre_tool_hook: Option<Arc<dyn PreToolCallHook>>`. Default:
`AlwaysApprovePolicy` (backward compatible — existing graphs see no behaviour change).

`PreToolCallHook::pre_invoke(preview: &ToolCallPreview, run_ctx: &RunContext)` returns a
`PreToolDecision` (`#[non_exhaustive]`):
- **Approve** — proceed to tool execution unchanged.
- **Deny { reason }** — construct `ToolOutput::Error(reason)`; tool is NOT invoked.
  Fail-closed under all code paths. VP-011 Kani candidate.
- **Edit { modified_args }** — replace tool_args with modified_args; proceed.
- **PendingHumanApproval { prompt }** — suspend via `interrupt()` (BC-2.05.001 machinery
  reused); resume delivers `Command(resume=PreToolDecision)`. Survives process restart.
  "Skip-hook-on-resume" invariant: hook is NOT re-called on the resumed dispatch (BC-2.05.008).

Two new streaming events: `tool_approval_request` (before internal interrupt) and
`tool_approval_resolved` (on resume decision). BC-2.06.001 12-variant taxonomy grows to
14. **Authored BCs:** BC-2.06.004 / BC-2.06.005 (SS-06); BC-2.08.010 amended for
`#[tool(action_risk = ...)]` macro parameter (SS-08).

**Grounding:** D23 authority — domain-e-agentic-coding-assistant.md §3 item 5 / §6
"Per-tool-call interactive HITL (fine-grained)" DEGRADED → closure "first-class pre-tool
interrupt hook at sub-node granularity."
**Anchor justification:** CAP-034 covers per-tool-call approval because D23 mandates closure
of the Domain E DEGRADED gap. ADR-018 is the architecture authority. CAP-034 is distinct
from CAP-006 (node-boundary HITL): CAP-006 governs graph-level interrupt/resume; CAP-034
governs sub-node tool-dispatch granularity. PendingHumanApproval composes with CAP-006
interrupt machinery rather than replacing it.
**Architecture authority:** ADR-018. **Subsystems:** SS-05 (HITL extended), SS-06 (streaming
events +2), SS-16 (ActionRisk / hook integration).

### CAP-035: Rolling Proactive Context Compaction (CompactionTrigger / CompactionPolicy)

Provide a first-class rolling compaction primitive in the budget engine. New types added to
`core::budget` (definitions-only, ADR-009 Option 3):

- `CompactionTrigger` (`#[non_exhaustive]`): `Disabled` (default; backward compatible),
  `OnWatermark { fraction: f64 }` (trigger when `tokens_remaining / ceiling <= (1.0 - fraction)`;
  non-strict `<=` — strict `<` cannot fire at fraction=1.0; f64 arithmetic;
  VP-012 Kani candidate — pure arithmetic), `OnMessageCount { count: usize }`,
  `OnTokenCount { tokens: u64 }`.
- `CompactionPolicy` trait: `async fn compact(&self, snapshot: &ConversationSnapshot,
  run_ctx: &RunContext) → Result<CompactionSummary, PregolyaError>`.
- `ConversationSnapshot`: ordered Vec<(turn_index, Message)> + token_estimate; assembled
  from checkpoint FTS (BC-2.04.008) by the BudgetEngine.
- `CompactionSummary`: `summary_text: String` + `compacted_start: usize` + `compacted_end: usize` (flat; slice form `messages[compacted_start..=compacted_end]`).

`BudgetConfig` gains `compaction_trigger: CompactionTrigger` (default `Disabled`) and
`compaction_policy: Option<Arc<dyn CompactionPolicy>>` (None = `DefaultSummarizationPolicy`
which prompts the model, same mechanism as `OnCeiling::Summarize`).

`BudgetEngine` in `graph::budget` evaluates the trigger after each super-step; on trigger:
assembles ConversationSnapshot → calls compact() → replaces messages[compacted_start..=compacted_end] with
SystemMessage(summary_text) in the active window → appends CompactionEvent to EvidenceJournal
→ emits `compaction_event` streaming event (15th variant). Original checkpoint records are
NOT deleted (BC-2.04.001 immutability). Custom CompactionPolicy impls MAY also write
CompactionSummary to MemoryStore (CAP-017) as project knowledge — the framework imposes no
constraint on compact() beyond returning CompactionSummary (ADR-019 Decision 5 additive).

**Authored BCs:** BC-2.10.005 (SS-10 compaction trigger semantics, watermark arithmetic),
BC-2.10.006 (SS-10 compaction execution, journal entry); BC-2.06.006 authored for
`compaction_event` (SS-06).

**Grounding:** D23 authority — domain-e-agentic-coding-assistant.md §3 item 10 / §6 "Rolling
proactive context compaction" DEGRADED → closure "first-class rolling-compaction primitive."
**Anchor justification:** CAP-035 covers rolling compaction because D23 mandates closure of
the Domain E DEGRADED gap. ADR-019 is the architecture authority. CAP-035 is distinct from
CAP-012 OnCeiling::Summarize: CAP-012 governs what happens WHEN the ceiling is reached;
CAP-035 governs proactive compaction BEFORE the ceiling. Both reside in SS-10 but at
different trigger points. Additive with CAP-017 (cross-session persistence of summaries is
opt-in at the application layer — not a mandatory coupling).
**Architecture authority:** ADR-019. **Subsystems:** SS-10 (budget governance), SS-04
(scheduler — BudgetEngine dispatch site), SS-06 (streaming events +1).

### CAP-036: First-Party Filesystem Tools (tools::fs — ReadFileTool, WriteFileTool, EditFileTool, ListDirTool)

Provide four `Tool`-implementing types in `pregolya-tools::tools::fs` (SS-23, crate #21):

| Tool | ActionRisk | Key constraints |
|------|-----------|-----------------|
| `ReadFileTool` | ReadOnly | max_bytes limit (default 1 MiB); E-TOOLS-002 on excess |
| `WriteFileTool` | High | PathGuard-confined; non-idempotent; no auto-retry |
| `EditFileTool` | High | exact-match old_string → new_string; E-TOOLS-003 if absent; conditional retry safe (old_string mismatch is structural no-op) |
| `ListDirTool` | ReadOnly | PathGuard-confined; no size limit |

All four validate path arguments against `PathGuard` (pregolya-sandbox) at invocation time;
out-of-guard paths return `Err(E-TOOLS-001 PathConfinementViolation)`. VP-003 (workspace
path-confinement Kani proof) coverage extends to all four tools without modification —
PathGuard is the same type already proven. `EditFileTool` exact-match only by default; opt-in
fuzzy fallback via `EditConfig::fuzzy_threshold: Option<f32>` (`similar = "3"`, mitsuhiko,
Apache-2.0 — ADR-020 Decision 7; cargo-deny `[licenses.allow]` must include `"Apache-2.0"`).

All four integrate with PreToolCallHook (CAP-034) via ActionRisk annotations and with
RetryPolicy (CAP-018) per BC-2.16.001. WriteFileTool and EditFileTool non-idempotent —
require re-approval before retry (ADR-020 Decision 4).

**Granularity justification (3 CAPs for 3 modules):** tools::fs BC axis covers
PathGuard-confinement + mixed ReadOnly/High risk + VP-003 Kani reuse. tools::shell (CAP-037)
has a unique non-lowerable risk floor invariant (VP-013) warranting its own band. tools::search
(CAP-038) is in-process ReadOnly with no PathGuard dependency. Three distinct BC acceptance
shapes → three CAPs, following the D21 module-granularity convention.

**Grounding:** D23 authority — ADR-020 Decision 2, SS-23. domain-e-agentic-coding-assistant.md
§3 items 2–3 / §6 "File/bash tool substrate" + "Workspace confinement" first-party closure.
**Anchor justification:** CAP-036 covers tools::fs because D23 mandates first-party Tool
implementations on the pregolya-sandbox substrate (Domain E holdout requires file read/write
without application-authored wrapper code). ADR-020 is the architecture authority.
**Architecture authority:** ADR-020. **Subsystem:** SS-23 (pregolya-tools, crate #21).

### CAP-037: First-Party Shell Execution Tool (tools::shell — BashTool)

Provide `BashTool` in `pregolya-tools::tools::shell` (SS-23, crate #21): executes shell
commands via the pregolya-sandbox WASM/container backend (BC-2.13.001–003; enforcing sandbox
mandatory — no direct OS process execution outside the sandbox policy).

**ActionRisk and risk floor invariant:** `BashTool` default `ActionRisk::High`. Risk tier
CANNOT be lowered below `ActionRisk::Medium` — `ToolConfig::override_risk(ActionRisk::ReadOnly)` or
`ToolConfig::override_risk(ActionRisk::Low)` returns a configuration error at startup. This is a framework safety
invariant, not an application convention. VP-013 Kani candidate.

Output: `BashOutput { stdout: String, stderr: String, exit_code: i32, truncated: bool }`.
`max_output_bytes` limit (default 256 KiB); exceeding it yields first 256 KiB with
`truncated = true` (non-fatal; E-TOOLS-005 informational). `max_duration` timeout (default
30s per NFR catalog); E-TOOLS-004 on breach.

Retry: explicitly enrolled per-`tool_name` via RetryPolicy (CAP-018 / BC-2.16.001); NOT
auto-retried (commands are not generally idempotent). Each retry flows through
PreToolCallHook (CAP-034) independently — hook may deny a retry (ADR-018 Decision 6 /
ADR-020 Decision 4). E-TOOLS-007 if risk floor violated at startup.

**Grounding:** D23 authority — ADR-020 Decision 2, SS-23. domain-e-agentic-coding-assistant.md
§3 item 4 / §6 "Shell sandboxing (WASM/container default)" first-party tool closure.
**Anchor justification:** CAP-037 covers tools::shell as a separate CAP from CAP-036 because
BashTool carries a uniquely important framework safety invariant (non-lowerable risk floor +
VP-013 Kani proof candidate) requiring its own BC band. Conflating BashTool with filesystem
tools would obscure this invariant and its acceptance shape.
**Architecture authority:** ADR-020. **Subsystem:** SS-23 (pregolya-tools, crate #21).

### CAP-038: First-Party Search Tool (tools::search — GrepTool)

Provide `GrepTool` in `pregolya-tools::tools::search` (SS-23, crate #21): in-process regex
pattern matching using the `regex` crate (NOT shelling out to system grep or ripgrep —
hermetic and unit-testable without system tool availability). `ActionRisk::ReadOnly`.

Accepts: `{ pattern: String, path: String, recursive: bool, case_insensitive: bool,
max_results: usize }`. Results capped at `max_results` (default 100); E-TOOLS-006
(`GrepResult.capped` — informational payload field, not a raised Err; partial results returned on ceiling). Returns
matches with file path and line number. Path argument validated by PathGuard for directory
scoping (E-TOOLS-001 on out-of-guard paths). No sandbox execution — in-process std::fs.
No retry enrollment needed (pure read, idempotent).

Performance note: in-process `regex` is sufficient for typical coding-assistant search
radius; a ripgrep-backed variant is deferred to a future `pregolya-tools-rg` extension
(ADR-020 Decision 2 §Alternative D). Dependency: `regex` is a net-new `[workspace.dependencies]`
entry — confirmed NOT an existing workspace dep per ADR-020 Decision 7; devops-engineer adds
`regex = "1"` when initializing the workspace.

**Grounding:** D23 authority — ADR-020 Decision 2, SS-23. domain-e-agentic-coding-assistant.md
§3 item 1 / §6 "File/bash tool substrate" first-party search closure.
**Anchor justification:** CAP-038 covers tools::search as a separate CAP from CAP-036
(filesystem) because GrepTool is in-process (no sandbox), ReadOnly only, and hermetic (no
system tool dependency). Its BC acceptance shape covers regex semantics, max_results capping,
and hermeticity — distinct from the filesystem tools' PathGuard-confinement + mixed-risk
surface.
**Architecture authority:** ADR-020. **Subsystem:** SS-23 (pregolya-tools, crate #21).

---

## P1 — LCEL Map/Passthrough Composition (Wave 1, D-170)

> **D-170 (burst-302, 2026-08-17):** Human-directed Phase-1 approval-gate scope expansion.
> Adds the second of the two main LCEL composition primitives: RunnableParallel (fan-out),
> RunnablePassthrough (identity pass-through), and RunnableAssign (dict augmentation via
> `RunnablePassthrough::assign`). All three live in SS-01 (pregolya-core, `core::runnable`).
> Architecture authority: ADR-026.

### CAP-039: LCEL Map/Passthrough Composition: RunnableParallel and RunnablePassthrough

Provide LCEL fan-out and identity-pass-through composition primitives in
`pregolya-core (core::runnable)` (SS-01):

**(1) RunnableParallel** — invokes a named dict of `Arc<dyn DynRunnable>` branches
concurrently (via `tokio::task::JoinSet`) on the same input, returning a
`serde_json::Value::Object` keyed by branch name. Key order follows `IndexMap` insertion
order (deterministic; matches Python 3.7+ insertion-ordered `Mapping`).
**Fail-fast error semantics:** the first branch failure aborts all remaining in-flight
branches (`JoinSet::abort_all()`) and returns
`Err(PregolyaError { category: EXEC, code: E-CORE-009, message: "RunnableParallelBranchFailure: branch '<key>' failed: <cause>", .. })`
identifying the failing branch key; no partial output dictionary is produced (DI-016, DI-014).
If `Ok(output)`, `output` contains exactly one key for every configured branch — no key
silently absent (DI-016). Constructor: `RunnableParallel::new(pairs)`.
Alias: `RunnableMap = RunnableParallel`.

**(2) RunnablePassthrough** — passes input through unchanged
(`invoke(input, config)` → `Ok(input)` — exact same value, no copy except where needed
for type ownership). Optional `inspect_fn: Option<Arc<dyn Fn(&serde_json::Value) + Send + Sync>>`
called for side effects (logging, tracing, metrics) without altering the return value; the
inspect function MUST NOT alter the return value — read-only callback contract.
Streaming passes each chunk through unchanged. Constructors: `RunnablePassthrough::new()`
(no inspect) and `RunnablePassthrough::with_inspect(f)`.

**(3) RunnableAssign** (via `RunnablePassthrough::assign(pairs)`) — augments a dict input
with additional computed keys by internally wrapping a `RunnableParallel` as its mapper.
Input MUST be a `serde_json::Value::Object`; non-object input returns
`Err(PregolyaError { category: VAL, code: E-CORE-010, message: "RunnableAssignNonDictInput: ..", .. })`.
Output: `{**input, **mapper.invoke(input)}` — mapper keys overwrite on key collision
(Python parity: `{**value, **mapper.invoke(value)}`).

All three types implement `DynRunnable` and compose freely via `pipe()` (BC-2.01.004).
All three are `#[non_exhaustive]` per ADR-023 Required Inventory. Module placement:
`core::runnable` in `pregolya-core` (canonical 2-level module-registry form per ADR-026;
all three types reside in this module).

Enables canonical LangChain patterns: RAG context-fetch + question pass-through,
multi-model fan-out, structured field extraction. Second of the two main LCEL composition
primitives alongside RunnableSequence (CAP-001/CAP-003).

**Authored BCs:** BC-2.01.005 (RunnableParallel construction + concurrent invocation +
keyed dict output), BC-2.01.006 (fail-fast branch failure propagation + abort-remaining +
no partial results), BC-2.01.007 (RunnablePassthrough identity + inspect side-effect
contract), BC-2.01.008 (RunnableAssign dict augmentation + input-must-be-object + mapper-
wins-on-collision). **VP:** VP-014 (proptest P1, `core::runnable`,
key-completeness property: Ok(output) → output.len() == configured branch count).

**Grounding:** D-170 human-directed Phase-1 approval-gate scope expansion (burst-302).
Human senior architect ruled RunnableParallel and RunnablePassthrough IN SCOPE for
pregolya v1 at the Phase-1 approval gate. ADR-026 §Context establishes the justification:
these are the two main LCEL composition primitives alongside RunnableSequence; without
RunnableParallel, canonical LangChain patterns such as RAG context-fetch + question
pass-through and multi-model fan-out are not expressible in pregolya. RunnableAssign is
co-delivered because `RunnablePassthrough.assign()` is the primary consumer pattern in LCEL
pipelines; without it, RunnablePassthrough has limited real-world utility (ADR-026
§Alternatives, "Delay RunnableAssign to Wave 2 REJECT").
**Anchor justification:** CAP-039 covers LCEL fan-out and identity-pass-through composition
because ADR-026 §Decision 5 explicitly assigns CAP-039 to these three types in SS-01 scope
("The CAP assigned to these types is CAP-039"). The product brief's Wave 1 LangChain parity
mandate (D17-HYBRID: "LangChain semantics are the API-surface authority") requires the two
main LCEL composition primitives; RunnableParallel is the primary mechanism for RAG pipeline
construction and multi-model fan-out in all real-world LangChain applications. This CAP is
grounded in D-170 and ADR-026, not invented.
**Architecture authority:** ADR-026.
**Subsystem:** SS-01 (Core Primitives, pregolya-core). **Wave:** 1.

---

## P1 — Research Orchestrator Composition Primitives (Wave 1+2, ADR-030)

> **ADR-030 (2026-08-31):** Human-directed Phase-1 scope expansion.
> Adds two additive composition primitives: (1) `checkpoint::trajectory` — durable audit-grade
> `TrajectoryRecord` write/replay in pregolya-checkpoint; (2) `graph::channels` ledger types —
> `LedgerChannel<T>` (dedup-idempotent accumulator) and `PromoteRetireChannel<T>`
> (promote/retire lifecycle) in pregolya-graph. Both primitives compose with existing
> StateGraph and CheckpointSaver APIs without modifying them.
> Clean-room behavioral inspiration from the praxist-pattern research orchestrator; no code or
> documentation copied. The pattern is expressed natively in pregolya terms.

### CAP-040: Durable Trajectory Records and Ledger-Style State Channels (Research Orchestrator Primitives)

Provide two additive composition primitives that enable the autonomous research orchestrator
pattern in pregolya — where a StateGraph drives multi-generation generation-evaluation-commit
cycles with durable audit trails and quality-diversity candidate tracking:

**(1) Trajectory Primitives** (definitions in pregolya-core `core::trajectory`; execution in
pregolya-checkpoint `checkpoint::trajectory`):

- **`TrajectoryRecord`** — a `#[non_exhaustive]` struct capturing a single audit event in a
  research run: `run_id: Uuid` (research-session identifier), `step_idx: u64` (logical-clock
  position sourced from the checkpoint clock; DI-004 Monotonic Checkpoint Clock), `event_kind:
  String` (non-empty event label, e.g., `"generation_complete"`), `payload: serde_json::Value`
  (structured JSON; no credential material per DI-010 Credential Opacity).
- **`TrajectoryWriter`** — an async trait (`async fn put_record(&self, record: TrajectoryRecord)
  -> Result<(), PregolyaError>`) that durably commits `TrajectoryRecord`s to a storage slice
  **isolated** from the `CheckpointSaver` rolling-context compaction (ADR-019). After `Ok(())`
  returns, the record survives process restart (DI-002 Per-Task Durability). Storage errors
  propagate as `Err(PregolyaError)` — no silent swallowing (DI-014).
- **`TrajectoryReader`** — an async trait (`async fn replay(run_id: Uuid) ->
  Result<Vec<TrajectoryRecord>, PregolyaError>`) that returns all records for a `run_id` in
  **strictly ascending `step_idx` order**. An unknown or unused `run_id` returns `Ok(vec![])`
  without error. Completeness is absolute: all committed records are returned, no pagination.

**(2) Ledger-Style State Channels** (pregolya-graph, `graph::channels`):

- **`LedgerEntry`** — a marker trait (`fn entry_id(&self) -> &str`) shared by both channel
  entry types. Implementations declare stable, semantically meaningful identity keys.
- **`LedgerChannel<T: LedgerEntry>`** — a `StateGraph` channel reducer type that accumulates
  entries in a `Vec<T>` with **dedup-idempotent** semantics: a `T` with a novel `entry_id` is
  appended to the end (monotonically non-decreasing length); a `T` with an already-seen
  `entry_id` is a no-op (no error). Iteration order is first-appearance order — stable under
  duplicate submissions. VP-017 (proptest P1, harness `ledger_channel_dedup_idempotency`)
  formally verifies this property.
- **`PromoteRetireOp<T: LedgerEntry>`** — a `#[non_exhaustive]` enum:
  `Promote(T)` adds an entry to the active set (idempotent if already present);
  `Retire(String)` removes an entry by `entry_id` (idempotent on absent `entry_id`).
  Within a super-step, operations are processed in deterministic task-identity order (DI-001).
- **`PromoteRetireChannel<T: LedgerEntry>`** — a `StateGraph` channel reducer that maintains
  a `Vec<T>` active set via `PromoteRetireOp<T>` operations. The active set contains no
  duplicate `entry_id` values. Idempotent operations return the correct `Vec<T>` without
  raising `Err` (DI-001). Used in quality-diversity allocation cycles where candidates
  advance from pending to active and are retired when superseded or committed.

**Composition pattern (clean-room, native pregolya):** A research orchestrator `StateGraph`
can compose all three primitives independently:
- A `LedgerChannel<Evidence>` field monotonically accumulates evidence entries across
  generation super-steps; dedup ensures duplicate evidence from retry paths is harmless.
- A `PromoteRetireChannel<Candidate>` field tracks which candidates are currently active;
  the promote/retire lifecycle maps naturally onto generation → evaluation → commit/retire.
- `TrajectoryWriter::put_record` records an audit event at each major step; the audit log
  is isolated from compaction and replayable via `TrajectoryReader::replay` for reproducibility
  review, debugging, or downstream quality-diversity analysis.
The three types are independently composable — using one does not require using the others.

**Authored BCs:**
BC-2.02.007 (LedgerChannel dedup-idempotent append — VP-017 proptest anchor; DI-001),
BC-2.02.008 (LedgerChannel first-appearance ordering; DI-001),
BC-2.02.009 (PromoteRetireChannel promote/retire lifecycle; DI-001),
BC-2.04.009 (TrajectoryWriter::put_record durability; DI-002/DI-014),
BC-2.04.010 (TrajectoryReader::replay ascending step_idx order; DI-004/DI-014),
BC-2.04.011 (Trajectory Compaction Isolation — atomic crash-safe compaction; DI-002/DI-004/DI-014).

**Grounding:** ADR-030 human-directed Phase-1 scope expansion (2026-08-31). Behavioral
inspiration is clean-room — no code or documentation from any Fair Source or proprietary
implementation was copied. The composition primitives are expressed natively in pregolya terms
via existing StateGraph channel infrastructure and CheckpointSaver tier isolation.
**Architecture authority:** ADR-030.
**Subsystems:** SS-02 (pregolya-graph, `graph::channels`) for ledger channel types;
SS-04 (pregolya-checkpoint, `checkpoint::trajectory`) for trajectory primitives. **Wave:** 1
(ledger channels — co-delivered with StateGraph infrastructure), 2 (trajectory — co-delivered
with CheckpointSaver infrastructure).

---

## P2 — Extended Capabilities (Post-v1 Candidates)

> **D23 update (2026-07-22):** CAP-017 (cross-session memory) and CAP-018 (tool retry)
> promoted P2 → P1 per domain-e forcing function. This section now contains only CAP-019.

### CAP-019: Formal Verification Pipeline (Kani + cargo-fuzz)

Run Kani harness proofs for the six committed P0 VP obligations (D17-Q7 + D21 + D23): BSP
determinism VP (VP-001, DI-001/NE-17), session triple-address uniqueness VP (VP-002,
DI-005/NE-12), workspace path confinement VP (VP-003, DI-007/NE-02), zero-norm cosine guard
VP (VP-009, DI-014/BC-2.21.003), reviver allowlist containment VP (VP-010,
DI-014/BC-2.19.005), and PreToolCallHook fail-closed VP (VP-011, DI-014/BC-2.05.007). Run
cargo-fuzz on the core serialization and graph-execution paths. Both tools locked by D17-Q7.

**Grounding:** product-brief.md §Success Criteria — "All 6 P0 Kani VP obligations pass Kani
harness before v1 convergence (D17-Q7 + D21 + D23)"; §Scope cross-cutting — "Formal
verification pipeline: Kani proofs + cargo-fuzz [both locked: D17-Q7]."
**Anchor justification:** CAP-019 covers formal verification because D17-Q7 commits the
original three VP obligations by name; D21 and D23 added VP-009/010/011 as P0 fail-closed
security/safety proofs confirmed by architect P0-intent ruling (burst-241 F-P141-02). The
brief's success criteria include VP coverage as a gate metric.
**Note on phase placement:** VP deliverables belong to Phase 6 (formal hardening). The
behavioral invariants they prove (DI-001, DI-005, DI-007, DI-014) are Phase-1 BC scope.

---

## P1 — Developer Console (D-356, Wave 3)

> **D-356 dev-console scope expansion (2026-09-06, business-analyst).** Append-only delta.
> All capabilities below are ROADMAP-ONLY: spec and storyboard now, build in Wave 3 (or later).
> No existing capabilities above are modified. The console is a CONSUMER of the existing
> pregolya-server wire contract (REST+SSE, CAP-007 StreamEvent taxonomy, CAP-005/CAP-006
> checkpoint/HITL substrate) — not a peer of the engine. Net-new server additions are minimal
> and feature-gated. The web SPA is the dominant new effort and the natural Wave 3 anchor.
> Actor: developer-operator (see entities-server.md §Actors / Roles (D-356)).
> Reference implementations: adk-rust `adk-server` (devconsole-adk-research.md §2.2);
> LangGraph Studio (devconsole-adk-research.md §3).

### CAP-041: Developer Console Composition Layer (`pregolya-console` Crate)

Provide a `pregolya-console` binary crate that embeds the compiled web SPA via `rust_embed`,
serves it over a configurable local address (default `127.0.0.1:7437`), and injects a
`runtime-config.json` pointing at the pregolya-server `/api` prefix. In dev mode
(`pregolya console --dev`), optionally co-launches an in-process `pregolya-server` instance
so that `pregolya console` starts both server and UI in a single command. The composition
layer hosts the in-memory span exporter (`DebugSpanExporter`) that the debug trace endpoints
(CAP-042) read from.

The console is architecturally a client: it drives runs via `POST /threads/{id}/runs`,
streams events via `GET .../runs/{run_id}/stream` (BC-2.12.007), reads history via
`GET /threads/{id}/history` (BC-2.12.001), and submits approvals via
`POST .../resume` (BC-2.05.004). It never reaches into engine internals.

**Grounding:** research memo §4.3 "pregolya-console (new binary crate)" component boundary;
§2.2 adk-rust `web_ui.rs` architecture (rust_embed + runtime-config.json pattern).
**Anchor justification:** CAP-041 covers the composition layer because without it none of the
developer-operator's workflows (CAP-043 through CAP-047) have a launch vehicle. It is the
foundation of the console surface, grounded in the research memo's recommended split and the
adk-rust architecture reference. Distinct from `pregolya-server` (headless) and the web SPA
(frontend build artifact).
**Trace anchors:** existing pregolya-server REST+SSE wire contract (api-surface.md);
CAP-007 (StreamEvent taxonomy consumed as-is); CAP-005 (checkpoint history via /threads history endpoint); CAP-006 (HITL resume endpoint).
**Priority:** P1. **Wave:** 3.

---

### CAP-042: Debug Infrastructure Endpoints (Feature-Gated)

Provide two new read-only debug endpoints on `pregolya-server`, compiled in only when the
`debug-endpoints` Cargo feature is enabled (production deployments compile them out):

1. **Trace/span read endpoints:**
   - `GET /debug/trace/session/{session_id}` — returns ordered span list for a session.
   - `GET /debug/trace/{event_id}` — returns span attributes for a single event.
   An in-memory `DebugSpanExporter` (hosted in `pregolya-console`, injected into the server
   as a configured span exporter) retains spans in a retention-capped ring buffer. The
   adk-rust `convert_to_span_data()` → `Trace.ts` SpanData shape is the UX model
   (devconsole-adk-research.md §2.2 table row 5).

2. **Graph descriptor endpoint:**
   `GET /assistants/{id}/graph` — emits the compiled `StateGraph` for the named assistant as
   a JSON node/edge document plus optional Graphviz DOT source (`dot_src: String`). Each node
   entry carries its name and kind; each edge entry carries source, target, and optional
   condition label. The graph descriptor is a static structural snapshot; it does NOT carry
   runtime state. These endpoints are library-consumer-useful beyond the console (CI trace
   inspection, tooling) and therefore belong in `pregolya-server` (not in `pregolya-console`).

   > **D-356 adversary fix DC-27/L-288 (2026-09-08, business-analyst).** F-L288-002 [MED]:
   > `dotSrc: String` corrected to `dot_src: String` (snake_case per BC-2.24.003 PC-001/PC-004
   > and S-console-04 AC-001/AC-004; CAP-042 was the lone camelCase outlier in the D-356 delta).

**Grounding:** research memo §4.2 gap items "Trace/span endpoints + OTel exporter wiring" and
"Graph/DAG visualization"; §4.3 "add only the *data* endpoints the console needs that are
genuinely server-tier." adk-rust `debug.rs` controller is the reference for the trace shape.
**Anchor justification:** CAP-042 is separated from CAP-041 because the trace/span and
graph-descriptor endpoints live in `pregolya-server` (not the composition layer) and are
independently useful to tooling consumers beyond the browser UI. They are gated behind a
Cargo feature for production safety.
**Trace anchors:** CAP-003 (StateGraph definition — source of graph descriptor data);
CAP-007 (StreamEvent taxonomy — spans align with event phases run_start/node_start/etc.);
existing `tracing` subsystem and Canonical Structured Event Catalog.
**Priority:** P1. **Wave:** 3.

---

### CAP-043: Run Inspection and Live Monitoring Panel

For **completed runs**: inspection reconstructs from the persisted trace-span layer — not from
stored StreamEvents (StreamEvent is transient per ADR-030; no run-event replay endpoint exists,
per ADR-031 Decision 8). The console calls `GET /debug/trace/session/{run_id}` (BC-2.24.002)
to retrieve persisted trace spans, which carry per-span detail: node input/output diffs and
tool args and results (span attributes, ADR-031 Decision 8 table). Compaction per-event markers
and timeline are LIVE-run SSE only; they are not available for completed runs (BC-2.24.007).
The panel also surfaces
the final run-state summary (status/output/error from the Run record) and the `evidence_journal?`
projection (BC-2.12.003 {PC-013}). Span latency detail (CAP-042 trace data) is accessible
per entry.

For **live runs**: subscribes to `GET /threads/{id}/runs/{run_id}/stream` (BC-2.12.007, SSE)
and renders events in real time. Drives live node highlighting on the StateGraph DAG
visualization (CAP-042 graph descriptor) by matching incoming `node_start` and `node_end`
StreamEvents to descriptor nodes by name. Token-level streaming (`run_stream`/`node_stream`)
is displayed inline as the model generates.

The console is a pure SSE+REST client for this capability — no new server engine additions.

**Grounding:** research memo §5 workflows "Inspect a run" (P2) and "Watch a live run"
(P1, P2); §1 table rows 1, 4 (interactive run + event inspection); §4.1 "pregolya's backend
is already a superset" for run/session/event data.
**Anchor justification:** CAP-043 is the primary value-delivery capability for developer-
operator personas P1 and P2. The two workflows use distinct substrates: completed-run
inspection uses persisted trace spans (`GET /debug/trace/session/{run_id}`, BC-2.24.002) plus
final run-state summary and `evidence_journal?` (BC-2.12.003 {PC-013}); live-run monitoring
uses the real-time SSE StreamEvent stream (BC-2.12.007). Neither workflow requires new server
engine additions.
**Trace anchors:** BC-2.24.002 (`GET /debug/trace/session/{run_id}` trace-span endpoint,
completed-run inspection substrate; ADR-031 Decision 8); BC-2.12.003 {PC-013}
(`evidence_journal?` for terminal runs); CAP-007 (16 StreamEvent variants, live-run monitoring
only); CAP-003 (StateGraph nodes matched by name for live highlighting);
existing SSE endpoint BC-2.12.007; CAP-042 (span latency detail per entry).
**Priority:** P1. **Wave:** 3.

> **D-356 adversary fix DC-29 (2026-09-08, business-analyst).** F-PDC29-01 (HIGH).
> Completed-run inspection description rewritten. OLD: opening paragraph implied StreamEvent
> replay for any `run_id` (including completed runs) — a sorted list of StreamEvents ordered
> by emission sequence. NEW: completed run = trace spans (`GET /debug/trace/session/{run_id}`,
> BC-2.24.002) + run-state summary + `evidence_journal?` (BC-2.12.003 {PC-013}). StreamEvent
> is TRANSIENT (ADR-030); no run-event replay endpoint (ADR-031 Decision 8). Live-run workflow
> (SSE StreamEvent stream, BC-2.12.007) unchanged. Anchor justification and trace anchors
> updated; CAP-007 scope now explicitly live-run monitoring only.

> **D-356 adversary fix DC-31 (2026-09-08, business-analyst).** F-PDC31-01 (HIGH) + F-PDC31-02 (MED).
> CAP-043 trace-span content list corrected per 3-substrate model (ADR-031 Decision 8 table).
> Struck "guardrail decisions" from trace-span content (F-PDC31-01): guardrail completed-run
> decision history arrives via `evidence_journal?` on run-read (BC-2.24.008 {PC-004}), NOT via
> trace spans. Struck "and compaction summaries" from trace-span content (F-PDC31-02):
> compaction per-event markers/timeline are LIVE-run SSE only and unavailable for completed runs
> (BC-2.24.007). Added clarifying clause per BC-2.24.007. Trace spans carry: per-span latency,
> LLM request/response, and span attributes only (ADR-031 Decision 8 table).

> **D-356 adversary fix DC-33 superseding (2026-09-08, business-analyst).** F-PDC33-02 cascades
> to CAP-043: the DC-31 note above stated "guardrail completed-run decision history arrives via
> `evidence_journal?` on run-read (BC-2.24.008 {PC-004})." That substrate statement is superseded
> per architect DC-33 ruling. `EvidenceJournal` is BUDGET-ONLY (`PolicyDecision: Allow | Escalate
> | Deny`); `GuardrailResult (Pass | Fail | Transform)` outcomes from `GuardrailHook::evaluate()`
> are recorded in the distinct `GuardrailJournal` entity (entities-server.md §GuardrailJournal).
> Completed-run guardrail decision history is reconstructed from `guardrail_journal?` (BC-2.11.007)
> on run-read — NOT `evidence_journal?`. The DC-31 note is preserved for historical audit; only
> its guardrail-substrate statement is superseded by this note.

---

### CAP-044: Checkpoint History Browser and Trajectory Replay

The console presents a thread's checkpoint history as a browsable ordered timeline: each
entry shows its `step_idx` (logical clock position per DI-004), a summary of which node
executed, and a delta of state changes applied. Selecting an entry calls
`GET /threads/{id}/state?checkpoint_id=<id>` to show the full state snapshot at that point.

**Trajectory replay (fork-from-checkpoint):** from any historical checkpoint, the operator
can fork a new Run starting from that checkpoint to explore alternative execution paths.
Forking creates a new Run via `POST /threads/{id}/runs` with the selected checkpoint as
starting state — reusing the standard run-creation path; no new server machinery.

All data plane operations use existing endpoints: `GET /threads/{id}/history` (BC-2.12.001,
newest-first, `?limit=N`) and `GET /threads/{id}/state` (latest checkpoint with checkpoint
history). The console adds only the frontend presentation layer.

**Grounding:** research memo §3 "Time-travel/replay is a checkpointer feature, not a UI
feature. The console is a thin read/resume client over a durable checkpoint + event history";
§4.1 "Time-travel / replay substrate" (already present); §5 workflow "Replay a trajectory"
(P3 persona). LangGraph Studio "Checkpoint / state inspection + Time-travel / replay"
feature is the UX reference (devconsole-adk-research.md §3).
**Anchor justification:** CAP-044 is grounded in the research memo's explicit finding that the
checkpoint-history substrate is already present and makes time-travel a presentation problem,
not an engine problem. The developer-operator's need to explore "what if this node had
produced X" is the forcing function; the checkpoint history API is the enabler.
**Trace anchors:** CAP-005 (three-tier checkpointing — the checkpoint history substrate,
DI-002/DI-004); CAP-006 (HITL resume machinery — reused for forking from checkpoint);
existing Thread history endpoint BC-2.12.001.
**Priority:** P1. **Wave:** 3.

---

### CAP-045: HITL Console Resume (Operator Approval Dialog)

The console detects Runs in `interrupted` status and surfaces the pending approval(s) to
the developer-operator via an interactive approval dialog. The dialog shows:

> **D-356 adversary fix DC-26 (2026-09-08, business-analyst).** Two CAP-045 field drifts
> corrected per F-PDC26-03 (MED): (1) node-boundary bullet: "scratchpad value and node name"
> corrected to "value (scratchpad JSON) and interrupt_id" — InterruptPayload (BC-2.05.001
> PC-004) carries only `value` + `interrupt_id`; `node_name` is a server-side Interrupt
> entity field not present in the consumed payload. (2) post-resume subscription: "new run
> stream" corrected to "same run stream (run_id unchanged)" per DC-23 ruling: resume
> transitions the run interrupted→in_progress on the same run_id; no new run is created.

- For node-boundary interrupts (CAP-006 `interrupt()` machinery): the interrupt's
  `value` (scratchpad JSON) and `interrupt_id` (per BC-2.05.001 PC-004 InterruptPayload).
- For per-tool-call interrupts (CAP-034 `PendingHumanApproval`): the `ToolCallPreview`
  (tool name, args as JSON, ActionRisk) carried in the `tool_approval_request` StreamEvent.

The operator selects Approve, Deny (with reason text), or Edit (modify args inline). The
console maps the selection to the appropriate `Command` struct fields and sends
`POST /threads/{id}/runs/{run_id}/resume` (BC-2.05.004). Multi-interrupt queues are surfaced
in FIFO arrival order per DI-003. After resume, the console subscribes to the same run stream
(run_id unchanged) to continue live monitoring (CAP-043).

All operations use existing endpoints; no new server machinery. The console is the first
human-facing UI that makes the HITL mechanics previously accessible only programmatically
available interactively.

**Grounding:** research memo §5 workflow "Resume HITL" (P3 persona); §4.1 "HITL resume"
already in api-surface.md (BC-2.05.004); LangGraph Studio "Interrupts / HITL" feature.
**Anchor justification:** CAP-045 covers the HITL approval UI because the developer-operator
persona (P3 — Trajectory Replayer / HITL Operator) is specifically grounded in the D-356
research. The console does not extend HITL mechanics; it provides a human-operable UI surface
over the existing POST resume endpoint.
**Trace anchors:** CAP-006 (HITL interrupt/resume machinery — console drives existing resume endpoint);
CAP-034 (PreToolCallHook/PreToolDecision — tool approval request events and decision mapping);
CAP-007 (`tool_approval_request` and `tool_approval_resolved` StreamEvent variants);
BC-2.05.004 (POST resume endpoint); DI-003 (FIFO resume delivery).
**Priority:** P1. **Wave:** 3.

---

### CAP-046: Token/Context Budget Monitoring Panel

The console provides a live context-window gauge panel for running or completed runs. The
gauge is driven by `compaction_event` StreamEvents (CAP-035, 15th variant): the
`tokens_remaining_after` and `summary_token_count` fields from the `compaction_event` payload
fill a proportional indicator showing remaining context budget. On each compaction event, the
panel annotates the event timeline (CAP-043) to mark the compaction boundary and which
message range was summarized. For terminal-status (finished) runs (`completed`, `failed`,
`cancelled`, `summary_halt`), the panel surfaces the full EvidenceJournal decision history
via the Run record's `evidence_journal?` projection (BC-2.12.003 {PC-013}), including
`PolicyDecision` values (Allow/Escalate/Deny) per evaluation point.

> **D-356 adversary fix DC-27/L-288 (2026-09-08, business-analyst).** F-L288-005 [MED]:
> "For completed runs" broadened to "For terminal-status (finished) runs (completed, failed,
> cancelled, summary_halt)" per DC-24/DC-25 arc — BC-2.24.007 + BC-2.12.003 {PC-013} make
> `evidence_journal?` available for all four terminal states, not only `completed`.

No new server machinery is needed; the `compaction_event` variant is already part of the
StreamEvent grammar and the EvidenceJournal is already a Run entity field.

**Grounding:** research memo §5 workflow "Watch budget/compaction" (P4 persona); §1 table
row 10 "Token usage / cost display"; §4.1 "Compaction observability: CompactionEvent variant
with token-impact payload — enables live context-window viz."
**Anchor justification:** CAP-046 is grounded in the research memo's explicit finding that the
`CompactionEvent` variant (added by D23/CAP-035) already carries the data needed for a live
context panel; the console only needs to consume and render it. The P4 developer-operator
persona's need for budget visibility during long-running agent runs is the forcing function.
**Trace anchors:** CAP-035 (`compaction_event` StreamEvent, `tokens_remaining_after`,
`summary_token_count` payload fields); CAP-012 (budget governance — EvidenceJournal,
PolicyDecision outcomes); CAP-007 (compaction_event as 15th StreamEvent variant).
**Priority:** P1. **Wave:** 3.

---

### CAP-047: Guardrail/Security Decision Review Panel

> **D-356 adversary fix DC-33 (2026-09-08, business-analyst).** F-PDC33-02 (HIGH) — completed-run guardrail substrate corrected. Prior description claimed completed-run guardrail history was reconstructed from `evidence_journal?` on run-read (cited BC-2.24.008 {PC-004} and BC-2.12.003 {PC-013}). This was wrong: `EvidenceJournal` is BUDGET-ONLY — `JournalEntry.decision` records `PolicyDecision (Allow | Escalate | Deny)` from token-budget checks only; `GuardrailResult (Pass | Fail | Transform)` outcomes from `GuardrailHook::evaluate()` had no persistence substrate. Architect DC-33 ruling (F-PDC33-02): `GuardrailJournal` entity created (entities-server.md §GuardrailJournal) as the durable per-run guardrail log. Completed-run substrate is `guardrail_journal?` (BC-2.11.007). All prior `evidence_journal?` guardrail-substrate claims superseded. Supersedes DC-29-sibling and DC-31 interim fixes for this CAP. The two governance journals are distinct and MUST NOT be conflated.

Guardrail security review panel — displays guardrail evaluation history for active and completed runs. For active runs: consumes `GuardrailDecision` `StreamEvent` variants over the live SSE stream. For completed runs: reconstructs guardrail history from `guardrail_journal?` (BC-2.11.007) on the run-read response — each entry records the result (Pass/Fail/Transform) and provenance for one `GuardrailHook::evaluate` call. The panel is both live (streaming) and retrospective (completed-run reconstruction).

For live runs, each `guardrail_decision` StreamEvent entry shows:

> **D-356 adversary fix DC-06 (2026-09-07, business-analyst).** Field names corrected from
> SS-11 ProvenanceTag/BoundaryType names (RAGRetrieval/MemoryIngress) to the authoritative
> `guardrail_decision` StreamEvent wire names per BC-2.06.001 §PC-002 GuardrailDecision bullet.
> The two type systems must not be conflated: ProvenanceTag (SS-11 ingress audit struct) and
> the guardrail_decision StreamEvent payload use different enum shapes.

- `boundary: IngressBoundary` — `ToolResult | RagChunk | MemoryItem` (per BC-2.06.001 {PC-002};
  NOT RAGRetrieval/MemoryIngress, which are the distinct SS-11 ProvenanceTag BoundaryType values)
- `decision: Fail | Transform` (Pass decisions are NOT shown — not streamed per CAP-007, F-P99-01)
- `severity: Option<GuardrailSeverityWire>` — `Some(Critical | High | Medium | Low)` for `Fail`;
  `None` for `Transform` (severity is only meaningful when content is blocked)
- `reason: Option<String>` — `Some(reason_string)` for `Fail`; `None` for `Transform`

The Domain A SOC analyst use case (guardrail visibility during untrusted-tool-result ingestion)
is served by this panel — the same content drives both the interactive local-debug workflow and
the broader security audit requirement.

**Grounding:** research memo §5 workflow "Watch guardrails" (P5 persona); domain-a-soc-analyst
forcing function (CAP-013 D17-Q8 — real-time guardrail visibility for prompt-injection
isolation); §4.1 "guardrail observability: GuardrailDecision StreamEvent variant — richer
than ADK's trace-only model."
**Anchor justification:** CAP-047 is grounded in the research memo's explicit finding that
`GuardrailDecision` events are already emitted and richer than the reference implementation's
trace-only model. The P5 developer-operator persona and the Domain A SOC forcing function
together justify a dedicated panel. The `GuardrailJournal` entity (entities-server.md §GuardrailJournal)
provides the durable completed-run inspection substrate via `guardrail_journal?` (BC-2.11.007).
**Trace anchors:** CAP-013 (content provenance tagging and guardrail-on-ingress — source
of the events this panel surfaces); CAP-007 (`guardrail_decision` StreamEvent variant, Fail/Transform
only per F-P99-01); DI-012 (no guardrail bypass — all qualifying events appear in the feed);
BC-2.11.007 (`guardrail_journal?` projection for terminal-status runs — completed-run guardrail history substrate);
entities-server.md §GuardrailJournal (`GuardrailEntry` type; `guardrail_journal: Vec<GuardrailEntry>` per-run append-only log).
**Priority:** P1. **Wave:** 3.

---

## P2 — Deferred Dev Console Capability (D-356)

> **D-356 dev-console scope expansion (2026-09-06, business-analyst).** The following
> capability is explicitly DEFERRED per the research memo finding that the reference
> implementation (adk-rust) stubs this as `501 NOT_IMPLEMENTED` and pregolya has no eval
> framework at v1.0.0. It is documented here for completeness so the deferred scope is visible
> and traceable. It may be promoted to P1 when pregolya adds an eval surface.

### CAP-048: [DEFERRED P2] Eval-Set Runner Console

**Status: DEFERRED.** The console's eval tab would provide: create or import eval sets, run
an eval set against a registered assistant, view a results table (latency, token usage,
pass/fail per scenario), and diff two eval runs. Deferred because:
- adk-rust stubs all eval console endpoints as `501 NOT_IMPLEMENTED`
  (devconsole-adk-research.md §1 table row 7).
- pregolya has no eval crate at v1.0.0; the LangGraph eval surface (LangSmith) is an
  external dependency not in scope.
- Promoting to P1 requires: (a) a pregolya eval framework surface (new crate or BC surface);
  (b) eval-runner endpoints on `pregolya-server`; (c) results storage.
When pregolya adds an eval surface, this CAP can be promoted from P2-DEFERRED to P1 and
Wave 3+ stories authored.

**Grounding:** research memo §4.2 "Eval runner + results viewer" gap item; §1 table row 7
adk-rust `501 NOT_IMPLEMENTED`; §5 workflow "Compare eval results" (P6 — Eval Analyst persona).
**Anchor justification:** CAP-048 is included (rather than omitted) because the P6 persona is
explicitly documented in the research memo and the scope boundary must be visible. Marking it
DEFERRED rather than absent avoids silent future scope creep.
**Trace anchors:** None established at this point; depends on a future pregolya eval surface.
**Priority:** P2 [DEFERRED]. **Wave:** TBD (post-Wave 3; gated on eval surface existence).
