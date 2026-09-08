---
document_type: domain-spec-index
level: L2
version: "1.35"
status: active
producer: state-manager
timestamp: 2026-09-08T24:30:00Z
phase: 1a
inputs:
  - .factory/specs/product-brief.md
  - .factory/comparative/COMPARATIVE-ASSESSMENT.md
  - .factory/planning/holdout-domains/domain-a-soc-analyst.md
  - .factory/planning/holdout-domains/domain-b-dark-factory.md
  - .factory/planning/holdout-domains/domain-c-openclaw.md
  - .factory/planning/holdout-domains/domain-d-hermes-agent.md
  - .factory/planning/holdout-domains/domain-e-agentic-coding-assistant.md
input-hash: "8ab469d"
traces_to: .factory/specs/product-brief.md
sections:
  - capabilities-p0.md
  - capabilities-p1-p2.md
  - entities-graph.md
  - entities-server.md
  - invariants.md
  - events.md
  - edge-cases.md
  - assumptions.md
  - risks.md
  - failure-modes.md
  - differentiators.md
  - ubiquitous-language-core.md
  - ubiquitous-language-server.md
  - bounded-contexts.md
decisions: [D1, D2, D3, D4, D6, D7, D8, D11, D12, D13, D17, D19, D20, D21, D23, D356]
changelog:
  - "v1.35 (D-356/DC-31/2026-09-08, state-manager): capabilities-p1-p2.md F-PDC31-01 + F-PDC31-02 substrate corrections. F-PDC31-01 (HIGH): CAP-043 struck 'guardrail decisions' from completed-run trace-span content list (guardrail history via evidence_journal? on run-read per BC-2.24.008 {PC-004}); CAP-047 completed-run substrate corrected from trace spans (BC-2.24.002) to evidence_journal? via run-read (BC-2.12.003 {PC-013} + BC-2.24.008 {PC-004}). F-PDC31-02 (MED): CAP-043 struck 'compaction summaries'; live-SSE-only clarifying clause per BC-2.24.007. O-PDC31-A: CAP-041/042/044/045/046 already-correct. Counts UNCHANGED: CAP 48 / DI 16."
  - "v1.34 (D-356/DC-29/2026-09-08, state-manager): capabilities-p1-p2.md F-PDC29-01 substrate sweep: CAP-043 completed-run inspection re-scoped to run-read (BC-2.12.003 {PC-013}) + evidence_journal? + trace spans (BC-2.24.002); no run-event endpoint (ADR-031 §Decision 8; ADR-030 StreamEvent transient). CAP-047 guardrail review substrate: same run-read+evidence_journal? mechanism. Counts UNCHANGED: CAP 48 / DI 16."
  - "v1.33 (D-356/DC-27/L-288/2026-09-08, state-manager): capabilities-p1-p2.md v1.35 — F-L288-002[MED] CAP-042 graph-descriptor field: dotSrc→dot_src (snake_case per BC-2.24.003 PC-001/PC-004 + S-console-04; CAP-042 was the lone camelCase outlier in the D-356 delta). F-L288-005[MED] CAP-046 EvidenceJournal scope: 'For completed runs' → 'For terminal-status (finished) runs (completed, failed, cancelled, summary_halt)' per DC-24/DC-25 broadening in BC-2.24.007 + BC-2.12.003 {PC-013} evidence_journal? projection. Counts UNCHANGED: CAP 48 / DI 16."
  - "v1.32 (D-356/DC-26/2026-09-08, state-manager): capabilities-p1-p2.md v1.34 — CAP-045 two-site drift correction (F-PDC26-03[MED]): (1) node-boundary interrupt dialog 'scratchpad value and node name' corrected to 'value (scratchpad JSON) and interrupt_id' per BC-2.24.006 PC-002 + S-console-08 (InterruptPayload has only value+interrupt_id, not node_name); (2) 'subscribes to the new run stream' corrected to 'same run stream (run_id unchanged)' per DC-23 canonical ruling (resume is interrupted→in_progress on SAME run_id). Counts UNCHANGED: CAP 48 / DI 16."
  - "v1.31 (D-356/DC-06 fix-burst/2026-09-07, state-manager): capabilities-p1-p2.md v1.33 — CAP-047 guardrail field-name correction (F-PDC06-03 site 1, HIGH): boundary_type:RAGRetrieval/MemoryIngress → boundary:IngressBoundary ToolResult|RagChunk|MemoryItem; GuardrailSeverity → severity:Option<GuardrailSeverityWire>. Counts UNCHANGED: CAP 48 / DI 16."
  - "v1.30 (D-356/2026-09-06): D-356 dev-console scope expansion. ID Registry: CAP-NNN 39→48 (+CAP-040 from D-327 previously missed + CAP-041..048 from D-356: developer-console surface, ROADMAP-ONLY). Priority Distribution: P1 27→36 (CAP-040 P1 + CAP-041..048 all P1). Document Map: capabilities-p1-p2.md row description extended (CAP-040..048; Developer-Operator actor entry). entities-server.md row description extended (Developer-Operator actor). ubiquitous-language-server.md row description extended (Developer-Operator term). D356 added to decisions. CAP count correction note: L2-INDEX v1.28 registered CAP count 38→39 (CAP-039); D-327 (2026-08-31) added CAP-040 to capabilities-p1-p2.md but was not propagated to L2-INDEX at the time; this entry closes both the D-327 gap and the D-356 additions atomically."
  - "v1.29 (burst-325/D-196/2026-08-18): input-hash refreshed (metadata hygiene; D-196 ruling: input-hash refresh is bookkeeping metadata, not normative spec content). Hash was stale since v1.3 authoring; holdout domain input files have been updated since then. No normative content changed. Phase-1 gate-closure burst."
  - "v1.28 (burst-302b/D-171/2026-08-17): ID Registry CAP count 38→39 (CAP-039 LCEL Map/Passthrough Composition: RunnableParallel and RunnablePassthrough, authored business-analyst); DI count 15→16 (DI-016 RunnableParallel Key-Completeness and Branch-Failure Propagation, authored business-analyst). Priority Distribution: P1 26→27 (CAP-039 P1). Document Map: capabilities-p1-p2.md description extended (CAP-039). LCEL scope expansion D-170/D-171."
  - "v1.27 (F-178-01, burst-289, 2026-08-16): Document Map events.md row: StreamEvent taxonomy count corrected 15→16 variants (BC-2.06.001 §Postconditions PC2 authority — burst-288 added StreamEvent::Error as 16th variant). Sibling-sweep: capabilities-p0.md and events.md updated identically in this burst."
  - "v1.26 (burst-284/2026-07-30): Paper-fix repair — fabricated section anchors in two section shards repaired per TD-VSDD-059. entities-graph.md (burst-273 changelog entry: 'api-surface.md §burst-242/2026-07-23' → 'api-surface.md changelog entry burst-242/2026-07-23'; §burst-242/2026-07-23 resolves to 0 headings in api-surface.md; burst-242 identifier is the stable form). risks.md (R-003 mitigation: 'reference-manifest.md §langchain-pin' → 'reference-manifest.md §langchain — Package Layout'; §langchain-pin resolves to 0 headings; §langchain — Package Layout is a real heading at line 36 of reference-manifest.md). L2-INDEX.md burst-276 changelog entry verified semantically complete after version-pin removal: bounded-contexts.md and capabilities-p1-p2.md changes remain described by finding IDs F-P173-104/F-P173-106/F-P173-702."
  - "v1.25 (F-P175-D101/fix-burst-283/2026-07-30): as_retriever fallibility correction across three shards (F-P175-D101 CRIT close). capabilities-p1-p2.md (CAP-027 receiver+Result return added; CAP-028 non-fallible form corrected to Result<VectorStoreRetriever, PregolyaError>). entities-graph.md (§VectorStore §Instance methods non-fallible form corrected). ubiquitous-language-core.md (§VectorStoreRetriever and §VectorStore term entries corrected to show Result return and Err(E-VS-003 InvalidConfig)). Grounds: interface-definitions.md §VectorStore Trait (F-P174-as-retriever-fallible/fix-burst-277) and ADR-014 §Decision 2."
  - "v1.24 (fix-burst-280/wave-c/2026-07-28): Document Map Lines→Size column replacement. Rationale: a precise numeric line-count estimate held in a separate index file decays silently on every shard edit — no gate detects the drift; this burst found four cells stale by +64 to +174 lines (capabilities-p0.md, entities-server.md, ubiquitous-language-server.md, bounded-contexts.md). This is the same structural-decay class TD-VSDD-091 addresses for file:NNN citations — not a pinned cite, but the same unbounded-drift property with no detection gate. S/M/L/XL bands update only when a shard crosses a tier boundary, which coincides with the DF-021 split review; maintenance cost is already paid at that trigger. Column name diverges from the upstream template's Tokens column by orchestrator authorization (Path 2, fix-burst-280); spec-steward holds the governance record — this divergence is intentional, not accidental drift. Band assignments (all 14 rows): XL: capabilities-p1-p2.md; L: entities-graph.md, ubiquitous-language-core.md, bounded-contexts.md; S: assumptions.md, risks.md, differentiators.md; M: all remaining."
  - "v1.23 (fix-burst-280/wave-c/2026-07-28): Document Map full line-count correction — all 14 rows verified against source shards. Four stale entries corrected: capabilities-p0.md ~140→~228, entities-server.md ~95→~201, ubiquitous-language-server.md ~100→~164, bounded-contexts.md ~155→~329."
  - "v1.22 (fix-burst-280/wave-c/2026-07-28): Count-desync correction — Document Map risks.md row: (8 risks)→(9 risks) and line estimate ~51→~79; assumptions.md line estimate ~48→~54. Full ID count sweep: CAP 38, DI 15, DEC 13, ASM 9, R 9, FM 19 all verified correct against source shards."
  - "v1.21 (fix-burst-280/wave-c/2026-07-28): R-009 added to risks.md (no v1 migration path for Python LangGraph checkpoints; orchestrator-approved gap coverage). ID Registry R-NNN count 8→9. ASM-007 Validation Method and Dependency Map updated with R-009 bidirectional link; assumptions.md D11 added to decisions list."
  - "v1.20 (fix-burst-280/wave-c/2026-07-28): assumptions.md — ASM-007 impact re-derivation (F-P175-C207). Impact if Wrong corrected Low→Medium; stale 'import tool in scope' citation replaced with ADR-002 §Consequences anchor; ASM-007 added to Assumption Dependency Map tracing to CAP-005."
  - "v1.19 (fix-burst-278/wave-b/2026-07-28): VectorStore retriever seam — three shards updated per D-48/D-44/D-45. capabilities-p1-p2.md §CAP-027/§CAP-028: VectorStoreRetriever lifetime annotation removed (verify-signature-canon S2 zero hits), as_retriever receiver corrected to self: Arc<Self> (S1b zero hits), backing-store borrow form corrected to Arc<dyn VectorStore>, k/fetch_k/lambda_mult rejection semantics added per D-44. entities-graph.md §VectorStore/§Relationships-Summary: VectorStore entity as_retriever receiver and Relationships Summary borrow-backed form corrected. ubiquitous-language-core.md §VectorStoreRetriever/§VectorStore: term borrow-based forms corrected. Post-fix: verify-signature-canon S1b=0, S2=0; borrow-backed VectorStoreRetriever form absent from all domain-spec shards."
  - "v1.18 (FC-4/burst-277/2026-07-28): False-closure FC-4 correction — 'PO BC obligations' stale-completed-delegation residue removed from 3 shards. capabilities-p1-p2.md v1.17→v1.18 (3 instances at CAP-034 x2, CAP-035 x1; all converted to past-tense 'Authored BCs' citations). entities-graph.md v1.12→v1.13 (1 instance: §PreToolDecision PendingHumanApproval). ubiquitous-language-core.md v1.8→v1.9 (1 instance: §PreToolDecision definition). All 5 instances confirmed stale-completed: BC-2.05.008, BC-2.06.004, BC-2.06.005, BC-2.08.010, BC-2.10.005, BC-2.10.006, BC-2.06.006 all exist. The v1.14 '4 verified structural/legitimate' count was inaccurate — those hits included these now-corrected stale-delegation instances."
  - "v1.17 (F-P173-104/F-P173-106/F-P173-702/burst-276/2026-07-27): bounded-contexts.md (F-P173-104: remove pregolya-graph from pregolya-tools dep list per ADR-020 Decision 1; inline note added citing D-24 ActionRisk-from-core rationale); capabilities-p1-p2.md (F-P173-106: CAP-038 regex dependency confirmed net-new per ADR-020 Decision 7, stale confirm-instruction removed; F-P173-702: CAP-029 ADR-014 Decision 4 → ADR-017 Decision 4 for InMemoryVectorStore/Arc-DI)."
  - "v1.16 (2026-07-25): Burst-262 F-P161-01 BC-pin de-pin sweep — entities-server v1.13→v1.14 (live-body BC-NNN vN.N version pins removed per D18-P84-A); events.md v1.10→v1.11 (live-body BC-NNN vN.N version pins removed per D18-P84-A)."
  - "v1.15 (2026-07-24): Burst 252 F-P151-01..07 ADR-019 compaction type canon — capabilities-p1-p2 v1.13→v1.14 (CompactionTrigger count/tokens field names, OnWatermark non-strict <= predicate, f64 fraction/budget_tokens_used); entities-graph v1.9→v1.10 (CompactionTrigger/CompactionSummary entity type canon: flat compacted_start/end fields, f64, put mechanism); events v1.9→v1.10 (compaction_event wire payload flat fields per ADR-019 Decision 4; mandatory parent_ids per BC-2.06.002 Inv-2); ubiquitous-language-core v1.7→v1.8 (CompactionTrigger term: count/tokens variant fields, f64 fraction; CompactionSummary term: flat compacted_start/end, no RangeInclusive). Document Map line counts updated: capabilities-p1-p2 ~530→~750, entities-graph ~315→~390, ubiquitous-language-core ~330→~420."
  - "v1.14 (2026-07-24): Burst 251 F-P150-02 (MED) — capabilities-p1-p2 v1.12→v1.13 stale-delegation residue removed at CAP-029 (§Zero-norm guard) and CAP-031 (§Dimensionality contract); both 'PO to formalize in error taxonomy' imperatives replaced with past-tense factual citations (E-VS-001 and E-EMBED-001 registered since error-taxonomy v1.27). L-026 sweep: 6 hits in domain-spec, 2 fixed, 4 verified structural/legitimate (BC-to-CAP traceability fields)."
  - "v1.13 (2026-07-24): Burst 250 F-P149-01/F-P149-02 — capabilities-p1-p2 v1.11→v1.12 (TD-VSDD-091 corpus-wide de-pin sweep: §CAP-029 VP-009 framing anchors — 2 sites (F-P149-01) + 3 sites (F-P149-02) + 1 near-miss 'Decision 3 and v1.1' outside grep pattern all replaced with stable 'ADR-014 Decision 2 §Hardening note' per D18-P84-A). Zero live-body ADR version pins remain in domain-spec/ corpus."
  - "v1.12 (2026-07-23): Fix burst 242 F-P142-02 — Document Map failure-modes.md row updated: ~140→~257 lines, (14 modes)→(19 modes). ID Registry: FM-NNN count 14→19 (FM-015..019 added in failure-modes.md v1.1 burst-241). Registry sweep: CAP 38, DI 15, DEC 13, ASM 9, R 8 all confirmed stable — no additional drift found."
  - "v1.11 (2026-07-22): Fix burst 235 F-P135-06 (BA scope) — events.md v1.6→v1.7 (D23 execution-time transitions: StreamEvent taxonomy 12→15 variants; CompactionExecuted domain event added after CheckpointWritten; ToolApprovalRaised + ToolApprovalResolved domain events added after ResumeValueReceived; ordering rules 7-8 added; decisions D21+D23 added). Document Map line count updated: events.md ~140→~175."
  - "v1.10 (2026-07-22): Fix burst 234 — invariants.md v1.1→v1.2 (DI-015 Subprocess Execution Timeout added per F-P134-06 architect adjudication; Tool Execution Invariants section added). DI-NNN census 14→15. Document Map and ID Registry updated."
  - "v1.9 (2026-07-22): Fix burst 233 F-P133-08 (BA micro-fix) — capabilities-p1-p2.md v1.7→v1.8 (CAP-036 similar-crate facts corrected per ADR-020 Decision 7 v1.1: pin `\"3\"`, owner mitsuhiko, Apache-2.0 single-licensed; stale confirm-before-write instruction removed). TD-VSDD-060 sweep: no other dtolnay/MIT similar-crate facts in domain-spec/ tree."
  - "v1.8 (2026-07-22): D23 L2 CAP layer (burst-230) — capabilities-p1-p2.md v1.6→v1.7 (CAP-017/018 promoted P2→P1; CAP-034..038 authored; D23 section added); entities-graph.md v1.5→v1.6 (HITL Approval Hook Domain + Context Compaction Domain sections added; Tool entity first-party subtypes; Relationships Summary extended); ubiquitous-language-core.md v1.5→v1.6 (D23 section: 13 new terms — PreToolCallHook, PreToolDecision, CompactionTrigger, CompactionPolicy, ConversationSnapshot, CompactionSummary, ReadFileTool, WriteFileTool, EditFileTool, ListDirTool, BashTool, BashOutput, GrepTool). CAP census: 33→38. Priority: P1 19→26, P2 3→1. D23 and domain-e added. Document Map updated."
  - "v1.7 (2026-07-21): F-P131-04/05 adjudication (burst-226) — entities-graph.md v1.4→v1.5 (PromptValue MessageProvenance.tag→highest_trust_level; TrustLevel entity added to Retrieval and Serialization Domain; Relationships Summary updated); entities-server.md v1.11→v1.12 (ProvenanceTag disambiguation note added); capabilities-p1-p2.md v1.5→v1.6 (CAP-022 strict-undefined universal; CAP-022 security invariant TrustLevel::Untrusted explicit; CAP-023 highest-severity TrustLevel); ubiquitous-language-core.md v1.4→v1.5 (TrustLevel D21 term added; 15→16 D21 terms); ubiquitous-language-server.md v1.3→v1.4 (ProvenanceTag disambiguation note added). Document Map updated."
  - "v1.6 (2026-07-20): D21 second-half CAP authoring complete. ID Registry: CAP-NNN count 27→33 (CAP-028..033 authored for SS-21/22). Priority Distribution: P1 count 13→19; total 27→33. capabilities-p1-p2.md updated (v1.4→v1.5); entities-graph.md updated (v1.3→v1.4, VectorStore/Embeddings/MetadataFilter/SearchType added); ubiquitous-language-core.md updated (v1.3→v1.4, 6 D21 terms added). Domain C forcing-function row updated (SS-22/CAP-031..033 added). Document Map updated."
  - "v1.5 (2026-07-20): D21 first-half CAP authoring complete. ID Registry: CAP-NNN count 21→27 (CAP-022..027 authored for SS-18/19/20). Priority Distribution: P1 count 7→13; total 21→27. capabilities-p1-p2.md updated (v1.3→v1.4); capabilities-p0.md updated (v1.6→v1.7, CAP-002 D21 reversal); entities-graph.md updated (v1.2→v1.3, Document/PromptValue/Serialized added); ubiquitous-language-core.md updated (v1.2→v1.3, 9 D21 terms added). D21 added to decisions list. Document Map row descriptions updated."
  - "v1.4 (2026-07-20): Design-Forcing-Function Summary updated — Four holdout domains (was three); Domain D (Hermes Agent, inbound MCP server role per D19/D20) added to forcing-function table. D19 added to decisions list. TD-VSDD-060 sweep: one stale occurrence corrected; second occurrence (v1.1 changelog: 'all three were over 1,500-token threshold') refers to split files, not holdout domains — accurate, no change."
  - "v1.3 (2026-07-17): Provenance-integrity fix — STATE.md removed from inputs (D-NNN decisions baked at authoring time, not live state); domain-d-hermes-agent.md added (D19/D20 forcing function for CAP-020/CAP-021 added in v1.2); input-hash recomputed. All section files updated in same burst."
  - "v1.2 (D20 sub-burst 2): CAP-020 (Self-Improvement Primitives: SkillStore + MemoryWriteGuard + Frozen-Snapshot Context Mutation, P1) and CAP-021 (MCP Server Role: Expose Registered Tools as MCP Server Endpoint, P1) added to capabilities-p1-p2.md (v1.1). CAP count 19→21; P1 count 5→7; total 19→21. D20 added to decisions list."
  - "v1.1: Split capabilities.md → capabilities-p0.md + capabilities-p1-p2.md; entities.md → entities-graph.md + entities-server.md; ubiquitous-language.md → ubiquitous-language-core.md + ubiquitous-language-server.md (all three were over 1,500-token threshold per DF-021)"
---

# L2 Domain Specification: pregolya

> **Sharded artifact (DF-021).** This index provides navigation and summary.
> Detail lives in per-section files listed below. Each section targets
> 800-1,200 tokens for optimal LLM consumption.

## Domain Summary

pregolya occupies the agent-orchestration domain: composing AI model calls, tool
invocations, and durable state transitions into resumable graphs with human-in-the-loop
interrupts, structured checkpointing, typed error propagation, and provider conformance —
expressed as a Rust async-native port of the LangChain v1 semantic surface.

## Document Map

> **Size bands (S/M/L/XL):** S = <100 lines · M = 100–300 · L = 300–600 · XL = >600.
> Update a band only when a shard crosses a tier boundary — which coincides with the DF-021
> split review, so the maintenance cost is already paid at that point. This column is an
> orchestrator-authorized project-local divergence from the upstream template's `Tokens`
> column; spec-steward holds the governance record.

| Section | File | Size | Primary Consumer | Purpose |
|---------|------|------|-----------------|---------|
| Capabilities — P0 | capabilities-p0.md | M | product-owner, architect, story-writer | CAP-001–008 (Wave 0/1) + CAP-012, CAP-013, CAP-016 (D17-elevated to P0; cross-cutting Wave 0/1); CAP-002 revised v1.7 (D21 reversal) |
| Capabilities — P1/P2 | capabilities-p1-p2.md | XL | product-owner, architect, story-writer | P1: CAP-009–011, CAP-014–015, CAP-017–018 (D23 Wave 1 promotions), CAP-020–038 (D21 + D23 additions), CAP-039 (D-170 LCEL scope expansion), CAP-040 (D-327 praxist research-orchestrator), CAP-041–048 (D-356 developer-console ROADMAP-ONLY; CAP-048 deferred); P2: CAP-019 only |
| Entities — Core/Graph/Checkpoint/Retrieval/Serialization/VectorStore/Embeddings/HITL/Compaction | entities-graph.md | L | architect, product-owner | Core primitives, graph, checkpoint + D21: Document, PromptValue, TrustLevel, Serialized, VectorStore, Embeddings, MetadataFilter, SearchType + D23: PreToolCallHook, PreToolDecision, ToolCallPreview, ToolApprovalRequest, CompactionTrigger, CompactionPolicy, ConversationSnapshot, CompactionSummary |
| Entities — Server/Policy/Provider | entities-server.md | M | architect, product-owner | Server, governance, and provider entities; Developer-Operator actor (D-356) |
| Domain Invariants | invariants.md | M | product-owner, architect | DI-NNN business rules (16 invariants) |
| Domain Events | events.md | M | architect | Processing stages, triggers, preconditions; StreamEvent taxonomy 16 variants (D23 + burst-288 error terminal event); ToolApprovalRaised/Resolved + CompactionExecuted domain events (D23) |
| Edge Cases | edge-cases.md | M | story-writer, test-writer | DEC-NNN domain-level edge cases (13 cases) |
| Assumptions | assumptions.md | S | product-owner, test-writer | ASM-NNN with validation methods (9 assumptions) |
| Risks | risks.md | S | product-owner, architect | R-NNN risk register (9 risks) |
| Failure Modes | failure-modes.md | M | architect, test-writer | FM-NNN runtime failure catalog (19 modes) |
| Differentiators | differentiators.md | S | product-owner | Competitive differentiator → CAP-NNN traceability |
| Ubiquitous Language — Core/Graph/D21/D23 | ubiquitous-language-core.md | L | all agents | Core and graph term definitions + D21 (16 terms) + D23 (13 terms: PreToolCallHook, PreToolDecision, CompactionTrigger, CompactionPolicy, ConversationSnapshot, CompactionSummary, ReadFileTool, WriteFileTool, EditFileTool, ListDirTool, BashTool, BashOutput, GrepTool) |
| Ubiquitous Language — Server/Policy | ubiquitous-language-server.md | M | all agents | Server, policy/safety, error terms + reconciliation table; Developer-Operator term (D-356) |
| Bounded Contexts | bounded-contexts.md | L | architect | Crate-level subsystem boundaries |

## Cross-References

| If you need... | Read these together |
|----------------|-------------------|
| BC creation input | capabilities-p0.md + capabilities-p1-p2.md + invariants.md + edge-cases.md + assumptions.md + risks.md + differentiators.md |
| Architecture design input | capabilities-p0.md + capabilities-p1-p2.md + entities-graph.md + entities-server.md + invariants.md + events.md + risks.md + failure-modes.md + bounded-contexts.md |
| Story decomposition input | capabilities-p0.md + capabilities-p1-p2.md + edge-cases.md + ubiquitous-language-core.md |
| Holdout scenario generation | assumptions.md + risks.md + failure-modes.md + edge-cases.md |
| NFR derivation | risks.md + failure-modes.md + invariants.md |
| Vocabulary / term resolution | ubiquitous-language-core.md + ubiquitous-language-server.md |
| Full domain review | ALL sections |

## ID Registry Summary

| ID Format | Count | Section |
|-----------|-------|---------|
| CAP-NNN | 48 | capabilities-p0.md (CAP-001–008, CAP-012, CAP-013, CAP-016) + capabilities-p1-p2.md (CAP-009–011, CAP-014–015, CAP-017–040 + CAP-041–048 D-356 developer-console ROADMAP-ONLY) |
| DI-NNN | 16 | invariants.md |
| DEC-NNN | 13 | edge-cases.md |
| ASM-NNN | 9 | assumptions.md |
| R-NNN | 9 | risks.md |
| FM-NNN | 19 | failure-modes.md |

> **Risk ID scheme note (F-10):** The R-NNN scheme in domain-spec/risks.md is canonical for all spec artifacts (PRD RTM, BC Traced-To, NFR catalog). STATE.md uses a separate R-N numeric alias (R8, R10, R11 map to R-004, R-005, R-006 respectively) retained for decision-log continuity only — see risks.md §Dual Risk ID Reconciliation for the full cross-walk table.

## Priority Distribution

| Priority | Count | Capabilities |
|----------|-------|-------------|
| P0 (must-have) | 11 | CAP-001, CAP-002, CAP-003, CAP-004, CAP-005, CAP-006, CAP-007, CAP-008, CAP-012, CAP-013, CAP-016 |
| P1 (should-have) | 36 | CAP-009, CAP-010, CAP-011, CAP-014, CAP-015, CAP-017 (D23), CAP-018 (D23), CAP-020, CAP-021, CAP-022, CAP-023, CAP-024, CAP-025, CAP-026, CAP-027, CAP-028, CAP-029, CAP-030, CAP-031, CAP-032, CAP-033, CAP-034, CAP-035, CAP-036, CAP-037, CAP-038, CAP-039 (D-170), CAP-040 (D-327), CAP-041 (D-356), CAP-042 (D-356), CAP-043 (D-356), CAP-044 (D-356), CAP-045 (D-356), CAP-046 (D-356), CAP-047 (D-356), CAP-048 (D-356, deferred) |
| P2 (nice-to-have) | 1 | CAP-019 |

> **Priority note (ADV-P1D-PASS-21):** CAP-012, CAP-013, and CAP-016 were elevated from P1 to P0
> to align with D17-Q4 (budget governance), D17-Q8 (guardrail-on-ingress), and D17 CONFLICT-6
> (error taxonomy) mandates. All constituent BCs are P0 in the PRD RTM (§2.10, §2.11, §2.14).
> Detail relocated from capabilities-p1-p2.md to capabilities-p0.md.
>
> **D23 promotion note (2026-07-22):** CAP-017 (long-horizon memory) and CAP-018 (tool retry)
> promoted P2 → P1 per domain-e-agentic-coding-assistant.md §3 items 13/16 DEGRADED closures.
> CAP-034..038 authored as net-new P1 Wave 1 capabilities (per-tool-call approval hook ADR-018,
> rolling context compaction ADR-019, first-party tool library ADR-020 / SS-23).

## Design-Forcing-Function Summary (D8)

Five holdout domains constrain the domain model as Phase-1 forcing functions:

| Domain | Primary Forcing Pressure | Key Capabilities |
|--------|--------------------------|-----------------|
| A — SOC Analyst | Risk-tiered HITL auth gates; forensic audit; prompt-injection isolation | CAP-004, CAP-006, CAP-013, CAP-015 |
| B — Dark Factory | Multi-day durable runs; budget governance; convergence loops | CAP-004, CAP-005, CAP-006, CAP-012 |
| C — OpenClaw | Persistent sessions; channel ingress; local-first deployment; pluggable embedding backends [NEW D21 requirement — CAP-017 vector path requires a concrete Embeddings impl; SS-22 is the holdout-necessary D21 piece for Domain C evaluation] | CAP-005, CAP-014, CAP-017, CAP-031, CAP-032, CAP-033 |
| D — Hermes Agent | Inbound MCP server role; expose registered tools as MCP endpoint | CAP-020, CAP-021 |
| E — Agentic Coding CLI | Fine-grained per-tool-call HITL; rolling context compaction; multi-session project memory; tool retry; first-party file/bash/search tools [D22/D23; five DEGRADED gaps closed to Wave 1] | CAP-017 (D23↑), CAP-018 (D23↑), CAP-034, CAP-035, CAP-036, CAP-037, CAP-038 |

## Key Anchors from COMPARATIVE-ASSESSMENT.md (D17)

| Source | Domain Impact |
|--------|--------------|
| CONFLICT-1, NE-17 | BSP determinism → DI-001; FM-001 |
| CONFLICT-2, D11.3 | Per-task durability → DI-002; FM-002 |
| CONFLICT-3 | HITL FIFO resume → DI-003; FM-003 |
| CONFLICT-4 | Monotonic checkpoint clock → DI-004 |
| CONFLICT-6 | PregolyaError 2D struct → entities-server.md, CAP-016 |
| NE-01 | Enforcing sandbox default → DI-006; FM-013 |
| NE-02 | Workspace confinement → DI-007; DEC-011 |
| NE-04 | Outbound timeout → DI-009; FM-011 |
| NE-06, HS-8 | Guardrail ingress coverage → DI-012; CAP-013 |
| NE-07 | Constructor Result → DI-008; FM-014 |
| NE-10 | Credential opacity → DI-010; FM-010 |
| NE-12 | Session triple-address → DI-005; FM-005 |
| NE-13 | Streaming/unary equiv. → DI-011; FM-007 |
| NE-14 | Secure server defaults → DI-013; FM-008, FM-009 |
