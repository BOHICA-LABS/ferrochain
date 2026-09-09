---
document_type: domain-spec-section
level: L2
section: entities-server
version: "1.22"
status: active
producer: business-analyst
timestamp: 2026-09-09T00:00:00Z
changelog:
  - "1.22 (DC-39/2026-09-09, business-analyst): Persistence model corrected for both journals per architect DC-39 re-adjudication. (1) §GuardrailJournal: DC-39 dated delta note added; persistence-path bullet added — checkpoint-backed (pregolya-checkpoint, SQLite, same backend as EvidenceJournal per BC-2.10.002 INV-003); appended sync-durable per successfully-returning GuardrailHook::evaluate() in graph::provenance before execution continues; Projection bullet corrected to clarify run-read assembly by server::run_read_handler querying checkpoint store at read time, NOT a RunStore terminal write; OBS-2 IngressBoundary↔BoundaryType vocabulary mapping note added. (2) §EvidenceJournal: persistence-path bullet added (checkpoint-backed, same model); run-read bridge note added (assembled by server::run_read_handler at read time). (3) §Run Journal projections bullet: run-read bridge note added for both journals (assembled by server::run_read_handler, not accumulated in Run record). No existing content deleted; all additions are additive with dated notes."
  - "1.21 (consistency-audit/F-A-MED/2026-09-08, business-analyst): §Run §Fields: evidence_journal and guardrail_journal added — terminal-status-only optional run-read projections omitted in v1.20 despite being the same class as completed_at/output/error. evidence_journal: Option<Vec<JournalEntry>> — budget PolicyDecision (Allow|Escalate|Deny) history per BC-2.10.002; projected per BC-2.12.003 {PC-013}. guardrail_journal: Option<Vec<GuardrailEntry>> — GuardrailHook evaluation outcomes (Pass|Fail|Transform) per BC-2.11.007; projected per BC-2.12.003 {PC-013}. Inline separation note added: MUST NOT be conflated. JournalEntry name confirmed against §EvidenceJournal (canonical Rust struct name); GuardrailEntry name confirmed against §GuardrailJournal (4 fields: boundary/result/provenance/timestamp_ms — no transform_applied). Dated delta note added to §Run."
  - "1.20 (DC-34/F-PDC34-03+O-PDC34-A/2026-09-08, business-analyst): §GuardrailJournal GuardrailEntry type corrected per architect DC-34 ruling. F-PDC34-03: boundary field type String → IngressBoundary (existing canonical enum, BC-2.06.001 §Postconditions {PC-002}; values ToolResult | RagChunk | MemoryItem). O-PDC34-A: transform_applied: Option<String> field DROPPED — result.Transform.new_content: IngressContent is the authoritative transform payload; the prose description field was redundant and non-canonical. Resulting canonical GuardrailEntry shape: { boundary: IngressBoundary, result: GuardrailResult (Pass | Fail{reason,severity} | Transform{new_content}), provenance: ProvenanceTag, timestamp_ms: u64 }. Whole-file sweep: two live-body hits corrected (boundary:String and transform_applied lines); v1.19 changelog entry is historical and preserved. Dated DC-34 delta note added to §GuardrailJournal."
  - "1.19 (DC-33/F-PDC33-02/2026-09-08, business-analyst): GuardrailJournal entity added — durable per-run guardrail evaluation log closing the CAP-047 completed-run substrate gap. (1) §EvidenceJournal: budget-only clarifying note added — EvidenceJournal records PolicyDecision (Allow/Escalate/Deny) only; GuardrailResult (Pass/Fail/Transform) outcomes from GuardrailHook::evaluate() live in the separate GuardrailJournal; the two governance dimensions MUST NOT be conflated. (2) §GuardrailJournal: new entity — GuardrailEntry type { boundary: String, result: GuardrailResult, provenance: ProvenanceTag, timestamp_ms: u64, transform_applied: Option<String> }; guardrail_journal: Vec<GuardrailEntry> per-run append-only log; guardrail_journal? projected on terminal-status runs in run-read response, parity with evidence_journal? (BC-2.11.007). (3) §GuardrailHook: cross-ref bullet added — each evaluate() call appends one GuardrailEntry to the run's GuardrailJournal. (4) Relationships Summary: GuardrailJournal belongs-to Run (1——1) added. Authority: F-PDC33-02, architect DC-33 ruling."
  - "1.18 (D-356/2026-09-06, business-analyst): D-356 dev-console scope expansion — Actors/Roles section added (§Actors / Roles). Introduces the developer-operator as an explicit first-class actor with persona breakdown (P1–P5) and need→WF→CAP chain. Cross-references CAP-041–CAP-047 (capabilities-p1-p2.md §P1 — Developer Console). Research memo (.factory/planning/devconsole-adk-research.md) added to inputs; input-hash set to PENDING-RECOMPUTE. D356 added to decisions list. Roadmap-only delta: no existing content modified."
  - "1.17 (burst-315/F-AUD-C-02/2026-08-17): §PregolyaError category field: append EXEC as 13th Category variant. Prior text listed 12 codes (VAL | AUTH | RATE | TIMEOUT | TRANSPORT | INTERNAL | DURABILITY | POLICY | TOOL | CONCURRENCY | SECURITY | TENANCY); EXEC was added burst-302b/D-170 per ADR-010 §Category Axis Expansion but was not propagated to this L2 entity definition. Fix: appended '| EXEC' so all 13 taxonomy codes are present. Authority: error-taxonomy §Error Categories (EXEC row) + ADR-010 §Category Axis Expansion (D26)."
  - "1.16 (2026-07-29): Error-construction notation correction per ADR-010 §Error-Construction Notation Canon. 1 CLASS3_UNICODE_ELLIPSIS_VIOLATION corrected: replaced `…` (U+2026) in field-elision position with `..` in PregolyaError { category: TOOL, … } (MCPTool §Error, DEC-012 reference). The `…` appeared after `, ` (comma-whitespace), placing it in field-elision position per the discriminator."
  - "1.15 (2026-07-27): F-P173-211 — source field corrected from Box<dyn StdError> to Arc<dyn std::error::Error + Send + Sync> (Box does not implement Clone, causing E0277 on #[derive(Clone)] in pregolya-core error type; Arc refcount-clone resolves this without requiring inner error to be Clone). message constraint added: MUST NOT contain credentials (DI-010). source constraint added: MUST NOT be exposed in HTTP responses. Naming adjudications: (1) component field retains L2 domain name PregolyaComponent with explicit Rust cross-ref to Component; (2) category variants aligned from PascalCase English (third-rendering) to taxonomy codes per casing canon, type name corrected from ErrorCategory to Category."
  - "1.14 (2026-07-25): TD-VSDD-091 BC-pin sweep — de-pin live normative prose: OnCeiling variants annotation 'BC-2.10.003 v1.2 + BC-2.10.004' → 'BC-2.10.003 + BC-2.10.004'. Version pins belong in changelog entries only; live body cites bare BC IDs."
  - "1.13 (burst-241 F-P141-05, 2026-07-23): Run entity: add error: Option<PregolyaError> field (BC-2.12.003 PC13/PC16 + invariant 'Run error populated ONLY when status=failed'). The field was absent despite being a first-class Read-Run response field per PC13 and PC16. output/error symmetry documented: output is Some when status∈{completed, summary_halt}; error is Some when status=failed; all other states both are None. Wire representation of error exposes {code, message, component, category} subset of PregolyaError (RFC-7807 compatible, PC16)."
  - "1.12 (burst-226, 2026-07-21): F-P131-05 adjudication — §ProvenanceTag: disambiguation note added clarifying that ProvenanceTag (SS-11, 3-field ingress-boundary audit struct) has no trust-level dimension, and that template-composition trust is handled by TrustLevel in pregolya-prompts: prompts::template (entities-graph.md §TrustLevel). The two axes must not be conflated (ADR-015 §Decision 3). TD-VSDD-060 sweep: no ProvenanceTag trust-variant residue in this file."
  - "1.11 (F-P121-01, fix burst 124, 2026-07-19): §Cross-Section Relationships: 'produces ToolResult → GuardrailHook fires → content enters Message' → 'produces ToolMessage (BC-2.09.002) → GuardrailHook fires on content as IngressContent::ToolResult → filtered content enters model context'. TD-VSDD-060 sweep: this was the only ToolResult-as-ContentBlock site in this file; fixed."
  - "1.10 (F-P120-01, fix burst 123, 2026-07-19): Correct Command depiction in §ResumeValue from 2-variant enum (Command::Resume/Command::Goto) to struct-with-optional-fields form matching BC-2.05.004. Command { resume, update, goto, graph } with independently-settable combinable fields and Command.PARENT subgraph-escape semantics documented. TD-VSDD-060 sweep: capabilities-p0.md:113 'Command(resume=value)' is API-call notation (not enum variant syntax), already-consistent with BC-2.05.004 struct form; exempt. ubiquitous-language-core.md:142 drifted; fixed in same burst (file bumped to v1.1). No other drifted Command-depiction sites found in domain-spec shards."
  - "1.9 (2026-07-19): F-P118-03 — fix wrong BC citation on completed_at semantics line. Changed Source from 'F-P24-01, BC-2.12.003 PC8(c)(d)' to 'F-P24-01, BC-2.12.003 PC13, BC-2.10.003 PC8(c)(d)'. PC13 is the correct BC-2.12.003 clause governing completed_at (matches updated_at's PC13 citation on the adjacent line and interface-definitions:867). PC8(c)(d) belongs to BC-2.10.003 (OnCeiling::Summarize → summary_halt path), retained as a separate correctly-attributed reference. TD-VSDD-060 sweep: line 58 BC-2.10.003 PC8(c)(d) was already correct; frontmatter v1.8 entry references BC-2.12.003 PC7/PC8 (no lettered subparts) which is correct for the lifecycle state-machine; no other BC-2.12.003 PC8(c)(d) conflations found."
  - "1.8 (2026-07-19): F-P117-01 — add `summary_halt` to the RunStatus terminal set throughout §Run. completed_at semantics: add `summary_halt` as a terminal state that sets completed_at. RunStatus lifecycle: add `| summary_halt` as a fourth terminal alternative reached via in_progress → summary_halt on the OnCeiling::Summarize path (BC-2.12.003 PC7/PC8); carries the summarize model response as final output. §OnCeiling Summarize bullet already correctly cited summary_halt (line ~91); no change needed there. Whole-file sweep confirmed no other RunStatus terminal-set enumerations missed."
  - "1.7 (2026-07-17): F-P93-01 — correct v1.6 semantic drift in §BudgetConfig and §EvidenceJournal. BudgetConfig fields renamed from invented {token_ceiling, cost_ceiling_usd, on_ceiling: PolicyOutcome (Allow|Escalate|Deny)} to verbatim canon {soft_limit: Option<u64>, hard_limit: Option<u64>, on_ceiling: OnCeiling (Halt|Escalate|Summarize)} per interface-definitions.md §BudgetPolicy v2.29, BC-2.10.001 TV-001–003, BC-2.10.003 v1.2, and BC-2.10.004. EvidenceEntry field set replaced with BC-2.10.002 PC2 JournalEntry verbatim: {run_id, sub_agent_id, evaluation_point, token_usage, policy_name, decision: PolicyDecision (Allow|Escalate|Deny), reason, timestamp}; invented fields node_name/cost_usd/tokens_used/policy_outcome removed — none exist in canon. Residue sweep: 'PolicyOutcome', 'token_ceiling', 'cost_ceiling_usd' are zero live occurrences post-fix (changelog exempt). entities-graph.md confirmed clean."
  - "1.6 (2026-07-17): D18-P92-A budget canon — BudgetPolicy rewritten as pure data-free trait; BudgetConfig added as the configuration data struct carrying token_ceiling/cost_ceiling_usd/on_ceiling; ER relationship updated from stale BudgetPolicy-injection phrasing to BudgetConfig per-run override model."
  - "1.5 (2026-07-17): Provenance-integrity fix — STATE.md removed from inputs (D11/D13/D17 decisions and CONFLICT-6 grounding baked at authoring time from COMPARATIVE-ASSESSMENT.md, not live state); input-hash recomputed."
  - "1.4 (ADV-P1D-PASS-59): F-P59-02 — add Transform same-boundary rule to §GuardrailHook: new_content must be the same IngressContent variant as the evaluated content (ToolResult stays ToolResult, RagChunk stays RagChunk, MemoryItem stays MemoryItem); inner payload may change freely per BC-2.11.002 EC-003."
  - "1.3 (ADV-P1D-PASS-58): F-P58-03 — rewrite §ProvenanceTag and §GuardrailHook to BC-authoritative shapes. ProvenanceTag: source_type/IngressSource/tool_name/invocation_id/timestamp retired → boundary_type: BoundaryType (ToolResult|RAGRetrieval|MemoryIngress), ingress_id: Uuid, sequence_position: usize (BC-2.11.001 PC1–PC3); User/Model variants removed per BC-2.11.001 EC-004. GuardrailHook: action_fn/GuardrailAction/Accept/Reject/Redact retired → evaluate(content: IngressContent, provenance_tag: ProvenanceTag) → GuardrailResult (Pass/Fail{reason,severity: GuardrailSeverity}/Transform{new_content}); authority interface-definitions.md v2.13 §GuardrailHook, BC-2.11.002 PC1–PC4."
  - "1.2 (ADV-P1D-PASS-30): OBS-P30-1 add Timestamp UTC canon under Server Domain — all Timestamp values RFC 3339 UTC at construction; wire serialization preserves UTC form."
  - "1.1 (ADV-P1D-PASS-25): F-P25-03 PregolyaError.code changed from u32 to String."
phase: 1a
inputs:
  - .factory/specs/product-brief.md
  - .factory/comparative/COMPARATIVE-ASSESSMENT.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "519ce06"
traces_to: L2-INDEX.md
decisions: [D11, D13, D17, D356]
---

# Domain Entities — Server, Policy/Governance, and Provider

> **Sharded L2 section (DF-021).** Navigate via `L2-INDEX.md`.
> Core Primitives, Graph, and Checkpoint entities are in `entities-graph.md`.

---

## Server Domain

> **Canonical Timestamp semantics (OBS-P30-1):** All Timestamp values are RFC 3339 date-time normalized to UTC (offset +00:00 / Z) at construction; wire serialization preserves UTC form. Applies to all `created_at`, `updated_at`, `completed_at`, `last_fired_at`, and `timestamp` fields throughout this section.

### Thread
A named, durable sequence of checkpoints representing one conversation or pipeline run lineage.
- **Fields:** thread_id: Uuid, metadata: Map<String, Value>, created_at: Timestamp, updated_at: Timestamp, status: ThreadStatus
- **ThreadStatus:** `idle` (no active run on this thread), `busy` (a run is queued or in_progress on this thread), `interrupted` (the most recent active run is interrupted; awaiting HITL resume), `error` (the most recent run failed and no other run is active). Derived from the state of the most recent active Run on the thread. Source: BC-2.12.001 PC5.
- **Relationships:** Thread 1→N Run. Thread 1→N Checkpoint (via thread_id in CheckpointSaver).
- **Note:** Corresponds to LangGraph Platform "thread." All Runs sharing a Thread share a checkpoint history.

### Assistant
A named agent configuration hosted by pregolya-server.
- **Fields:** assistant_id: Uuid, graph_id: GraphId (references a registered CompiledGraph), config: RunnableConfig, context: Option<Value>, metadata: Map<String, Value>, name: Option<String>, description: Option<String>, version: u32, created_at: Timestamp
- **version semantics:** Starts at 1. Each `PATCH` creates a new immutable version snapshot (N+1); the `latest` pointer is mutable. Source: BC-2.12.002 PC3/PC10.
- **Relationships:** Assistant 1→N Run.
- **Note:** No wire compatibility with LangGraph Platform (D13). pregolya-server is first-party.

### Run
A single execution of an Assistant with a Thread.

> **Consistency-audit Finding A (2026-09-08, business-analyst).** `evidence_journal: Option<Vec<JournalEntry>>` and `guardrail_journal: Option<Vec<GuardrailEntry>>` added to §Run §Fields — terminal-status-only optional run-read projections of the same class as `completed_at`, `output`, and `error`, omitted in v1.20. Authority: BC-2.12.003 {PC-013} + BC-2.11.007 {PC-002} + BC-2.10.002.

- **Fields:** run_id: Uuid, thread_id: Uuid, assistant_id: Uuid, status: RunStatus, config: RunnableConfig, created_at: Timestamp, updated_at: Timestamp, completed_at: Option<Timestamp>, output: Option<Value>, error: Option<PregolyaError>, evidence_journal: Option<Vec<JournalEntry>>, guardrail_journal: Option<Vec<GuardrailEntry>>
- **Journal projections (terminal-status only):** `evidence_journal?` records `PolicyDecision` budget outcomes; `guardrail_journal?` records `GuardrailResult` guardrail outcomes — MUST NOT be conflated. Both fields are `None` in non-terminal states (`queued`, `in_progress`, `interrupted`); projected on terminal-status runs (`completed | failed | cancelled | summary_halt`). Both fields are assembled by `server::run_read_handler` querying the checkpoint store by `run_id` at read time — they are NOT accumulated in the Run record itself during execution. Authority: BC-2.10.002, BC-2.11.007, BC-2.12.003 {PC-013}.
- **output/error symmetry (BC-2.12.003 PC15/PC16 + invariants):** `output` is `Some(GraphOutput)` when `status ∈ {completed, summary_halt}` (for `summary_halt`, output carries the summarize model response per BC-2.10.003 PC8(c)); `None` in all other states. `error` is `Some(PregolyaError)` ONLY when `status = failed`; carries `{code, message, component, category}` from the propagated `PregolyaError` (BC-2.12.003 PC16); `None` in all other states. The two fields are mutually exclusive — a Run is never both `output`-populated and `error`-populated.
- **updated_at semantics:** Set on every state mutation (status transition, output/error write). Always present. Source: BC-2.12.003 PC13.
- **completed_at semantics:** Set only on terminal transition (to `completed`, `failed`, `cancelled`, or `summary_halt`); `None` in non-terminal states (`queued`, `in_progress`, `interrupted`). Operationally distinct from updated_at — provides a clean terminal-timestamp without noise from intermediate mutations. Source: F-P24-01, BC-2.12.003 PC13, BC-2.10.003 PC8(c)(d).
- **RunStatus lifecycle:** queued → in_progress → completed | failed | cancelled | summary_halt; in_progress ⇄ interrupted (resume via POST .../resume)
  State-machine authority: BC-2.12.003 PC7/PC8. `summary_halt` is reached via in_progress → summary_halt on the OnCeiling::Summarize path (BC-2.10.003 PC8(c)(d)); it is a first-class terminal state — carries the summarize model response as final output, sets completed_at, is not cancellable, and is directly deletable.
  (F-03 alignment: `requires_action` renamed to `interrupted` for HITL-parked runs; `expired` deferred — v1.0.0 uses `failed` with E-GRAPH-014 InterruptApprovalTimeout for timeout-expired runs; a dedicated `expired` state may be added in a future version)
- **Relationships:** Run belongs-to Thread and Assistant. Run 1→N StreamEvent emitted. Run 0→N Interrupt.

### CronSchedule
A recurring proactive run trigger registered on an Assistant.
- **Fields:** cron_id: Uuid, assistant_id: Uuid, schedule: CronExpression, config: RunnableConfig, enabled: bool, last_fired_at: Option<Timestamp>
- **last_fired_at semantics:** Set when the most recent schedule firing completes Run creation; `None` until the first firing. Exposed in `GET /schedules/{cron_id}` response per BC-2.12.004 PC3.
- **Behavior:** Each firing creates a new Run with a fresh session (no prior thread context unless explicitly configured). Corresponds to LangGraph Platform "crons."

### Interrupt
A suspended execution point within a Run, awaiting an external ResumeValue.
- **Fields:** interrupt_id: Uuid, run_id: Uuid, node_name: NodeName, scratchpad: Option<Value>, created_at: Timestamp
- **Invariant (DI-003):** Interrupts are consumed in strict FIFO order. The interrupted node re-executes from the start of its super-step with the dequeued resume value.
- **Relationships:** Interrupt belongs-to Run. Interrupt 0——1 pending ResumeValue.

### ResumeValue
The external value injected to resume a pending Interrupt.
- **Fields:** interrupt_id: Uuid, value: Command
- **Command shape (authority: BC-2.05.004):** A struct with four independently-settable optional fields — `resume`, `update`, `goto`, `graph` — freely combinable (e.g., resume+goto per EC-001; resume+update per TV-002; resume+goto per TV-003):
  - `resume: Option<Value>` — places the value into the interrupted task's FIFO scratchpad slot; the node re-executes with it available via `interrupt()`.
  - `update: Option<StateDelta>` — state side-load: channel updates applied BEFORE the node re-executes.
  - `goto: Option<GotoTarget>` — forces routing to one or more nodes or `Send`s after command processing; bypasses normal conditional-edge routing.
  - `graph: Option<GraphRef>` — `None` (default) = current graph; `Command.PARENT` = escape to parent graph (valid only inside a subgraph; returns `Err(E-GRAPH-015 NoParentGraph)` at root level).
  A `Command` with no `resume`, no `update`, and no `goto` is a valid no-op resume signal that merely unblocks the super-step.
- **Invariant (DI-003):** Delivery is strictly FIFO; injection into an empty interrupt queue returns `Err(NoActiveInterrupt)`.

---

## Policy / Governance Domain

### BudgetConfig
Configuration data for token-ceiling thresholds and ceiling-response behavior for a Run.
- **Fields (verbatim — interface-definitions.md §BudgetPolicy v2.29, BC-2.10.001 TV-001–003):**
  - `soft_limit: Option<u64>` — token count at which `PolicyDecision::Escalate` is returned; `None` = no soft ceiling
  - `hard_limit: Option<u64>` — token count at which `PolicyDecision::Deny` is returned; `None` = no hard ceiling
  - `on_ceiling: OnCeiling` — engine behavior when the hard ceiling is reached
- **OnCeiling variants (verbatim — BC-2.10.003 + BC-2.10.004):** `Halt` | `Escalate` | `Summarize { summarize_prompt: String }`
  - `Halt` — stop run immediately; transition to `failed` with E-BUDGET-001
  - `Escalate` — suspend via HITL interrupt; awaits `BudgetResume::Extend` or `BudgetResume::Halt`
  - `Summarize { summarize_prompt: String }` — one final LLM call using the prompt; transition to `summary_halt`
- **Relationships:** Optionally set in RunnableConfig::budget_config (per-run override, 0——1); graph-level default lives in GraphConfig::budget_config. The engine constructs the effective BudgetPolicy from the resolved BudgetConfig at run time.
- **Source:** D17-Q4, HS-4/HS-9, domain-b dark-factory; interface-definitions.md §BudgetPolicy (F-P91-02 v2.29).

### BudgetPolicy (trait)
A composable allow/escalate/deny policy evaluated against token tallies for a Run.
- **Nature:** Pure trait — data-free. The engine constructs a BudgetPolicy implementation from the effective BudgetConfig (RunnableConfig::budget_config if set, otherwise GraphConfig::budget_config).
- **Composition:** Policies form a chain; first Deny outcome wins.
- **Source:** D17-Q4, D18-P92-A.

### EvidenceJournal
Append-only log of BudgetPolicy evaluations for a single Run.
- **Fields:** run_id: Uuid, entries: Vec<JournalEntry>
- **JournalEntry fields (verbatim — BC-2.10.002 PC2; canonical Rust struct name `JournalEntry`):**
  - `run_id: Uuid` — UUID of the run that triggered the evaluation
  - `sub_agent_id: Option<SubAgentId>` — sub-agent identifier; null if not a sub-agent run
  - `evaluation_point: EvaluationPoint` — trigger: `AfterLlmCall | AfterToolInvocation`
  - `token_usage: TokenUsage` — snapshot at evaluation time (prompt, completion, total, estimated_cost)
  - `policy_name: String` — name of the policy or composed chain evaluated
  - `decision: PolicyDecision` — `Allow | Escalate | Deny` (BC-2.10.001 PC3)
  - `reason: String` — human-readable reason; empty string for Allow when no threshold message
  - `timestamp: Timestamp` — wall-clock timestamp of the evaluation
- **Invariant:** Append-only — no entry may be modified or deleted after writing (BC-2.10.002 INV).
- **Governance dimension — BUDGET ONLY (F-PDC33-02):** EvidenceJournal records exclusively BudgetPolicy evaluations — every `JournalEntry.decision` is a `PolicyDecision (Allow | Escalate | Deny)` from a token-budget check. Guardrail outcomes (`GuardrailResult: Pass | Fail | Transform`) produced by `GuardrailHook::evaluate()` at ingress boundaries are a separate governance dimension — they are recorded in the distinct `GuardrailJournal` (§GuardrailJournal below). The two journals serve different purposes and MUST NOT be conflated.
- **Persistence path (DC-39):** Checkpoint-backed (`pregolya-checkpoint`, SQLite); each `JournalEntry` is appended sync-durable to the checkpoint store after the BudgetPolicy evaluation completes and before execution continues (BC-2.10.002 INV-003).
- **Run-read assembly (DC-39):** The `evidence_journal?` field on the run-read response (`GET /threads/{id}/runs/{run_id}`) is assembled by `server::run_read_handler` querying the checkpoint store by `run_id` at read time — NOT a terminal-state write to the Run record.

### GuardrailJournal
Append-only log of `GuardrailHook` evaluations for a single Run — one entry per `evaluate()` call at an ingress boundary. Provides the durable completed-run inspection substrate for CAP-047 (guardrail panel) via the `guardrail_journal?` projection on the run-read response.

> **DC-33/F-PDC33-02 (2026-09-08, business-analyst).** Net-new entity per architect DC-33 ruling. Prior to this addition, `GuardrailResult (Pass | Fail | Transform)` outcomes from `GuardrailHook::evaluate()` had no persistence substrate — the `EvidenceJournal` is budget-only and records only `PolicyDecision (Allow | Escalate | Deny)`. `GuardrailJournal` closes that gap. Completed-run guardrail history substrate for CAP-047 is now `guardrail_journal?` (BC-2.11.007).

> **DC-34/F-PDC34-03+O-PDC34-A (2026-09-08, business-analyst).** GuardrailEntry type corrected per architect DC-34 ruling. F-PDC34-03: `boundary` type was `String` — corrected to `IngressBoundary` (existing canonical enum, BC-2.06.001 §Postconditions {PC-002}). O-PDC34-A: `transform_applied: Option<String>` field DROPPED — `result.Transform.new_content: IngressContent` is the authoritative transform payload; the prose description field was redundant and non-canonical. Canonical shape is now `{ boundary: IngressBoundary, result: GuardrailResult, provenance: ProvenanceTag, timestamp_ms: u64 }`.

> **DC-39 (2026-09-09, business-analyst).** Persistence model corrected per architect DC-39 re-adjudication. Prior Projection bullet implied server-side assembly at terminal-state write time — WRONG. Correct model: GuardrailJournal is checkpoint-backed (`pregolya-checkpoint`, SQLite, same backend as EvidenceJournal per BC-2.10.002 INV-003); entries appended sync-durable per successfully-returning `GuardrailHook::evaluate()` in `graph::provenance` before execution continues; `server::run_read_handler` assembles `guardrail_journal?` by querying the checkpoint store by `run_id` at read time. Persistence-path bullet, Projection/run-read-assembly bullet, and OBS-2 IngressBoundary↔BoundaryType mapping note added below.

- **Fields:** run_id: Uuid, entries: Vec<GuardrailEntry>
- **GuardrailEntry type:**
  - `boundary: IngressBoundary` — ingress boundary at which the evaluation occurred: `ToolResult | RagChunk | MemoryItem` — canonical enum per BC-2.06.001 §Postconditions {PC-002}
  - `result: GuardrailResult` — evaluation outcome: `Pass` | `Fail { reason: String, severity: GuardrailSeverity }` | `Transform { new_content: IngressContent }` — canonical variants per §GuardrailHook; `Transform.new_content: IngressContent` is the authoritative transform payload
  - `provenance: ProvenanceTag` — the `ProvenanceTag` attached to the evaluated content at the ingress boundary (§ProvenanceTag)
  - `timestamp_ms: u64` — wall-clock timestamp (milliseconds since Unix epoch) of the evaluation
- **Invariant:** Append-only — no entry may be modified or deleted after writing. One entry is appended per `GuardrailHook::evaluate()` call at an ingress boundary.
- **Persistence path (DC-39):** Checkpoint-backed (`pregolya-checkpoint`, same SQLite backend as EvidenceJournal per BC-2.10.002 INV-003); each `GuardrailEntry` is appended sync-durable to the checkpoint store per successfully-returning `GuardrailHook::evaluate()` call in `graph::provenance`, before execution continues. There is no "RunStore terminal write" or accumulated Vec returned in graph result — entries are durable individually as they occur.
- **Projection / run-read assembly (DC-39):** The `guardrail_journal?` field on the run-read response (`GET /threads/{id}/runs/{run_id}`) is assembled by `server::run_read_handler` querying the checkpoint store by `run_id` at read time — NOT a terminal-state write to the Run record. Available on terminal-status runs (`completed`, `failed`, `cancelled`, `summary_halt`) — parity with `evidence_journal?` (BC-2.11.007).
- **IngressBoundary↔BoundaryType vocabulary mapping (OBS-2):** `GuardrailEntry.boundary: IngressBoundary` and `GuardrailEntry.provenance.boundary_type: BoundaryType` (§ProvenanceTag) refer to the same physical boundary under two vocabularies: `IngressBoundary::ToolResult` ↔ `BoundaryType::ToolResult`; `IngressBoundary::RagChunk` ↔ `BoundaryType::RAGRetrieval`; `IngressBoundary::MemoryItem` ↔ `BoundaryType::MemoryIngress`. `IngressBoundary` is the `guardrail_decision` StreamEvent wire vocabulary (BC-2.06.001 §Postconditions {PC-002}); `BoundaryType` is the `ProvenanceTag` ingress-audit vocabulary (BC-2.11.001 PC1–PC3). Both describe the same boundary; the vocabulary divergence is historical.
- **Relationships:** GuardrailJournal belongs-to Run (1——1).

### ProvenanceTag
Metadata attached to content at an ingress boundary, recording its origin.
- **Fields:** boundary_type: BoundaryType (ToolResult | RAGRetrieval | MemoryIngress), ingress_id: Uuid, sequence_position: usize
- **Note (BC-2.11.001 EC-004):** BoundaryType covers exactly ToolResult, RAGRetrieval, and MemoryIngress. User messages and model scratch-pad do not receive a ProvenanceTag and do not traverse the guardrail path.
- **Relationships:** ProvenanceTag attached to every content unit at an ingress boundary before GuardrailHook fires or the content is forwarded to model context (BC-2.11.001 PC1–PC3).
- **Disambiguation — ProvenanceTag vs TrustLevel (ADR-015 §Decision 3, burst-226):**
  `ProvenanceTag` is the SS-11 ingress-boundary audit struct. Its three fields record WHICH
  ingress event produced content (`boundary_type`) and WHERE within that event (`ingress_id`,
  `sequence_position`). It has NO trust-level dimension and carries no variants named Untrusted,
  UserInput, or Trusted. Template-composition trust is a separate concern handled by `TrustLevel`
  (enum: Untrusted | UserInput | Trusted; severity ordering Untrusted > UserInput > Trusted;
  located in `pregolya-prompts: prompts::template` — see entities-graph.md §TrustLevel).
  When ingress content is later used as a template variable, developers translate the ingress
  provenance into a `TrustLevel` for the composition step. The two types serve distinct axes
  and must never be conflated.

### GuardrailHook
A registered callable that validates content at an ingress boundary before model context entry.
- **Callable:** `evaluate(content: IngressContent, provenance_tag: ProvenanceTag) → GuardrailResult` — authority: interface-definitions.md §GuardrailHook, BC-2.11.002 PC1.
- **GuardrailResult variants:** `Pass`, `Fail { reason: String, severity: GuardrailSeverity }`, `Transform { new_content: IngressContent }` — authority: BC-2.11.002 PC2–PC4.
- **Transform same-boundary rule:** `new_content` must be the same `IngressContent` variant as the evaluated content (ToolResult stays ToolResult, RagChunk stays RagChunk, MemoryItem stays MemoryItem); the inner payload may change freely — e.g. a different `ContentBlock` variant within `ToolResult` is permitted (BC-2.11.002 EC-003). Cross-boundary transforms are not authorized.
- **GuardrailSeverity values:** Critical (run transitions to `failed`; inference halted) | High | Medium | Low (error block substituted; run continues) — BC-2.11.002 INV-3, BC-2.11.005 PC4/PC5.
- **Invariant (DI-012):** There is no code path through which ToolResult, RAG, or memory content bypasses a registered GuardrailHook before entering the model context.
- **GuardrailJournal cross-ref (F-PDC33-02):** Each `evaluate()` call appends one `GuardrailEntry` to the run's `GuardrailJournal` (§GuardrailJournal). The `GuardrailJournal` is the durable per-run store of all guardrail evaluation outcomes and provides the completed-run inspection substrate for CAP-047.

---

## Provider Domain

### ProviderClient
A connection to a model provider implementing the ChatModel Runnable interface.
- **Fields:** provider: ProviderId (openai | anthropic | ollama | …), model_id: String, credentials: ApiKey (newtype), config: ProviderConfig
- **Architecture:** Standalone SDK crate split (HS-6/D17-Q5): `pregolya-<provider>-sdk` owns the wire client; `pregolya-<provider>` is the Runnable adapter.
- **Invariant (DI-010):** ApiKey implements `Debug` → `"<redacted>"`. No `#[derive(Serialize)]`. No `Deref<Target = str>`.

### PregolyaError
The 2D error type for all pregolya crates.
- **Fields:** component: PregolyaComponent (L2 domain name; Rust: `Component` — enum covering all pregolya crate names, 17 variants as of D23), category: Category (taxonomy codes: VAL | AUTH | RATE | TIMEOUT | TRANSPORT | INTERNAL | DURABILITY | POLICY | TOOL | CONCURRENCY | SECURITY | TENANCY | EXEC), retry_hint: RetryHint (Never | Maybe | Later(Duration)), code: String (wire representation; Rust: `&'static str` per api-surface.md — e.g. `"E-CORE-001"`; fixed F-P25-03 from incorrect `u32`), message: String (MUST NOT contain credentials — DI-010), source: Option<Arc<dyn std::error::Error + Send + Sync>> (causal error chain; MUST NOT be exposed in HTTP responses; Arc preserves Clone — fixed F-P173-211 from non-cloneable `Box<dyn StdError>`)
- **Source:** CONFLICT-6 — adk-rust P-01/P-04 adopted; Python exception hierarchy does not translate to Rust.
- **RFC-7807:** PregolyaError supports serialization to RFC-7807 Problem Details JSON for HTTP error responses.

### MCPTool
A Tool whose schema and invocation semantics are discovered from an external MCP server.
- **Fields:** server_id: String, tool_name: String, description: String, input_schema: JsonSchema, transport: MCPTransport (Stdio | HTTP | WebSocket)
- **Behavior:** MCPTool implements the Tool Runnable interface. ToolResult produced by MCPTool is always tagged as untrusted ingress.
- **Error:** Bare ToolException from MCP server must be preserved and wrapped as `PregolyaError { category: TOOL, .. }` (DEC-012).

---

## Actors / Roles (D-356 Dev Console Scope Expansion)

> **D-356 dev-console scope expansion (2026-09-06, business-analyst).** This section is a
> dated delta. The domain spec did not previously contain an explicit Actors/Roles section;
> pregolya's runtime actors were implicit in the holdout domain descriptions (product-brief.md,
> domain-a through domain-e). This delta makes the primary human actors explicit for the
> developer console surface. Append-only: all existing entity definitions above are unchanged.

### Existing Implicit Actors (Acknowledged)

Prior to D-356, two actors were implicit in the holdout domain descriptions and product brief:

**SDK Integrator** — A pregolya library consumer who builds and wires StateGraphs in
application code. The SDK integrator is the actor whose perspective drives CAP-001 through
CAP-040: authoring correct graphs, composing Runnables, configuring providers, and deploying
agent applications. All existing capabilities are grounded in this actor's needs.

**Embedding Host** — An external system or application that consumes the pregolya-server
REST+SSE API in production. Validated by HS-C-001 (holdout scenario: FlowLoom embedding-host
end-to-end). The embedding host is programmatic and production-facing; it consumes the
StreamEvent grammar over the existing SSE endpoint to build downstream products.

### Developer-Operator (Net-New, D-356)

A human actor who runs pregolya locally in a development or debug context and uses the dev
console to inspect, trace, replay, and approve agent runs.

**Is this a distinct behavioral cluster?** Yes. The console-facing workflows (inspect event
timeline, browse checkpoint history, drive HITL approval from a UI, watch live streaming
events with node-highlighting, monitor token budget) are not expressible through the SDK
integrator or embedding-host behavioral clusters. A dedicated actor is warranted even though
the same human may wear multiple hats in a small team.

**Distinction from SDK integrator:** The SDK integrator's concern is *authoring* correct
graphs. The developer-operator's concern is *observing and diagnosing* running or completed
graphs. The developer-operator is typically the same human in a different phase of their
workflow — the hat they wear when they run `pregolya console` rather than when they write
`StateGraph::new().add_node(...)` code.

**Distinction from embedding host:** The embedding host is programmatic and production-facing.
The developer-operator is human and local-dev-facing. The developer-operator uses the console
UI; the embedding host consumes the API programmatically.

**Five developer-operator sub-personas (grounded in research memo §5):**

| Sub-Persona | Primary Concern | Primary Console Capabilities |
|-------------|----------------|------------------------------|
| P1 — Graph Author | See the graph I wired, run it interactively, watch which node fires when | CAP-042 (graph descriptor), CAP-043 (live run + node highlighting) |
| P2 — Run Debugger | Open a specific run_id, step through event timeline, expand per-event payloads, read spans | CAP-043 (run inspector), CAP-042 (span detail) |
| P3 — Trajectory Replayer / HITL Operator | Browse checkpoint history, resume interrupted run, fork from earlier checkpoint | CAP-044 (trajectory replay), CAP-045 (HITL console resume) |
| P4 — Budget/Context Watcher | Watch token budget, see when compaction fires, how much it reclaimed | CAP-046 (budget panel) |
| P5 — Security Reviewer | Watch guardrail_decision events in real time, review Fail/Transform outcomes | CAP-047 (guardrail panel) |

P6 (Eval Analyst) is DEFERRED — see CAP-048.

**Need → WF → CAP chain (D-356 capabilities):**
Developer-operator need: *observe and diagnose agent runs locally* →
Workflow clusters: run-inspection, trajectory-replay, HITL-resume, graph-visualization,
budget-watch, guardrail-watch →
Capabilities: CAP-041 (console layer), CAP-042 (debug infra), CAP-043 (run inspection +
live monitoring), CAP-044 (trajectory replay), CAP-045 (HITL console resume), CAP-046
(budget panel), CAP-047 (guardrail panel).

**Grounding:** research memo §5 personas P1–P6 (devconsole-adk-research.md); product-brief.md
§In Scope pregolya-server; HS-C-001 embedding-host holdout (validates the actor boundary —
the console is a client of the same wire contract as the embedding host).

---

## Relationships Summary (This Section)

```
Thread 1——N Run
Thread 1——N Checkpoint (cross-reference to entities-graph.md)
Run belongs-to Thread and Assistant
Run 0——N Interrupt
Run 0——N StreamEvent
Interrupt 0——1 pending ResumeValue
Assistant 1——N Run
CronSchedule belongs-to Assistant
EvidenceJournal belongs-to Run (1——1)
GuardrailJournal belongs-to Run (1——1)
BudgetConfig optionally set in RunnableConfig::budget_config (0——1, per-run override; graph-level default in GraphConfig::budget_config)
GuardrailHook 0——N registered on IngressBoundary
ProviderClient implements ChatModel (Runnable)
MCPTool implements Tool (Runnable)
PregolyaError emitted by all pregolya crates
```

## Cross-Section Relationships

- `Node` (entities-graph.md) invokes `Tool` (entities-graph.md) → produces `ToolMessage` (BC-2.09.002) → `GuardrailHook` fires on content as `IngressContent::ToolResult` → filtered content enters model context
- `Run` (this section) uses `CheckpointSaver` (entities-graph.md) via `thread_id`
- `ProviderClient` (this section) produces `Message` (entities-graph.md) containing `ContentBlock`
