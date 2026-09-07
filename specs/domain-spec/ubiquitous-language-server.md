---
document_type: domain-spec-section
level: L2
section: ubiquitous-language-server
version: "1.7"
status: active
producer: business-analyst
timestamp: 2026-09-06T00:00:00Z
phase: 1a
inputs:
  - .factory/specs/product-brief.md
  - .factory/comparative/COMPARATIVE-ASSESSMENT.md
  - .factory/semport/reference-manifest.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "be93076"
traces_to: L2-INDEX.md
decisions: [D2, D13, D17, D356]
changelog:
  - "1.7 (D-356/2026-09-06, business-analyst): D-356 dev-console scope expansion — Dev Console Terms section added (§Dev Console Terms). New terms: Developer Console, Developer-Operator, Graph Descriptor, Trajectory Replay, Console Run Inspector. Research memo (.factory/planning/devconsole-adk-research.md) added to inputs; input-hash set to pending-recompute (state-manager updates). D356 added to decisions list."
  - "1.6 (burst-291/D-134/2026-08-16): §-anchor phantom sweep — §TrustLevel (line 77 context) is a phantom anchor (TrustLevel is a bold term entry within '## Prompts, Serialization, and Retrieval Terms (D21 Additions)' in ubiquitous-language-core.md; no ## or ### TrustLevel heading exists). Corrected to ubiquitous-language-core.md §Prompts, Serialization, and Retrieval Terms."
  - "1.5 (fix-burst-276/F-P173-505/2026-07-27): D-28 banner added to body ## Changelog section, declaring Form A (frontmatter changelog:) authoritative; body table preserved as historical record."
  - "1.4 (2026-07-21): F-P131-05 adjudication (burst-226) — §ProvenanceTag: disambiguation note added clarifying that ProvenanceTag (SS-11, no trust-level dimension) is distinct from TrustLevel (SS-18, pregolya-prompts: prompts::template; ADR-015 §Decision 3). Changelog table updated. TD-VSDD-060 sweep: no ProvenanceTag trust-variant residue in this file."
  - "1.3 (2026-07-19): F-P117-01 — add summary_halt to Run status lifecycle. Terminal set now: completed | failed | cancelled | summary_halt. summary_halt reached via in_progress to summary_halt on the OnCeiling::Summarize path (BC-2.12.003 PC7/PC8); first-class terminal state per product-owner adjudication. Body changelog table row added. Whole-file sweep: no other terminal-set enumerations found."
  - "1.2 (ADV-P1D-PASS-58): F-P58-03 — update ProvenanceTag and GuardrailHook to BC-authoritative terminology. ProvenanceTag: source_type/tool_name/invocation_id/timestamp to boundary_type (ToolResult|RAGRetrieval|MemoryIngress), ingress_id, sequence_position; removed User/Model per BC-2.11.001 EC-004. GuardrailHook: Accept/Reject/Redact retired to Pass/Fail{reason,severity}/Transform{new_content}; callable signature updated to match interface-definitions.md v2.13."
  - "1.1 (initial active version)."
---

# Ubiquitous Language — Server, Policy/Safety, Error Terms, and Reconciliation

> **Sharded L2 section (DF-021).** Navigate via `L2-INDEX.md`.
> Core Primitives and Graph terms are in `ubiquitous-language-core.md`.

---

## Server Terms

**Assistant**
A named agent configuration hosted by pregolya-server: a compiled graph reference plus
run configuration. Corresponds to LangGraph Platform's "assistant." No wire compatibility
with LangGraph Platform (D13).

**Run**
A single execution of an Assistant with a Thread. Status lifecycle:
`queued → in_progress → completed | failed | cancelled | summary_halt; in_progress ⇄ interrupted (resume via POST .../resume)`.
`summary_halt` is reached via in_progress on the OnCeiling::Summarize path (BC-2.12.003 PC7/PC8); it is a first-class terminal state carrying the summarize model response as final output. State-machine authority: BC-2.12.003 PC7/PC8.
(`requires_action` renamed to `interrupted` for HITL-parked runs; `expired` deferred — v1.0.0 maps timeout-expired interrupts to `failed` via E-GRAPH-014 InterruptApprovalTimeout.)
Streaming and unary Run endpoints drive the same execution engine (DI-011).

**CronSchedule**
A recurring run trigger registered on an Assistant. Each firing creates a new Run. Each Run
from a CronSchedule starts with a fresh session (no prior context carried over unless
explicitly configured). Corresponds to LangGraph Platform "crons."

**Streaming / Unary equivalence**
The guarantee that the streaming endpoint and the unary endpoint produce the same final
answer for the same inputs. The streaming endpoint is not a stub — it invokes the same
execution engine and emits typed StreamEvents as the graph progresses (DI-011, NE-13).

---

## Policy / Safety Terms

**BudgetPolicy**
A composable allow/escalate/deny policy evaluated against token and cost tallies for a Run.
Configured per Run via RunnableConfig. Multiple policies chain; first Deny wins.

**EvidenceJournal**
Append-only record of BudgetPolicy evaluations and usage events for one Run. Never modified;
only appended. Provides an audit trail for cost governance decisions.

**ProvenanceTag**
Metadata attached to content at ingress, recording `boundary_type` (ToolResult | RAGRetrieval | MemoryIngress),
`ingress_id` (unique per ingress event), and `sequence_position` (zero-indexed position within the event).
Used for forensic audit trails (Domain A SOC) and guardrail call context.
User messages and model scratch-pad are not tagged — they do not traverse the guardrail path (BC-2.11.001 EC-004).
Authority: entities-server.md §ProvenanceTag.
**Disambiguation (ADR-015 §Decision 3, burst-226):** `ProvenanceTag` is the SS-11 ingress-boundary
audit record with three structural fields — it has NO trust-level dimension and carries no variants
named Untrusted, UserInput, or Trusted. Template-composition trust is handled by `TrustLevel`
(`pregolya-prompts: prompts::template`; see ubiquitous-language-core.md §Prompts, Serialization, and Retrieval Terms).
The two types serve distinct axes and must not be conflated.

**GuardrailHook**
A registered callable that validates content at an ingress boundary (ToolResult, RAG chunk,
memory item) before it enters the model context. Outcome: `GuardrailResult::Pass` (forward
unchanged), `Fail { reason, severity: GuardrailSeverity }` (content blocked; error block
injected at content position; run continues unless severity == Critical), or
`Transform { new_content }` (sanitized replacement forwarded; original discarded).
There is no bypass code path (DI-012).
Authority: interface-definitions.md §GuardrailHook, BC-2.11.002–BC-2.11.005.

**Untrusted ingress**
Content that crosses an external trust boundary before entering the model context. Categories:
tool results (from any Tool including MCPTool), RAG chunks retrieved from vector stores, and
memory retrieved from external stores. Untrusted ingress must pass GuardrailHook.
This is the boundary that Domain A's prompt-injection isolation requirement defends.

**Sandbox enforcement**
The property that tool execution occurs inside an enforcing isolation backend (WASM or
container) by default. A non-enforcing backend (process-native execution) requires explicit
opt-in and emits a loud warning. "Sandbox enforcement" is the *enforcement* of the policy —
not just the presence of a sandbox configuration option (DI-006, NE-01).

**Workspace confinement**
The guarantee that every workspace file operation calls `canonicalize_beneath_root(base, path)`
at access time, and that no file operation can observe content outside the declared workspace
root. Symlink traversal that escapes returns `Err(WorkspaceEscape)` (DI-007, NE-02).

---

## Error Terms

**PregolyaError**
The 2D error type: `component` (which pregolya crate raised the error) × `category` (what
class of error it is). Not derived from a Python exception hierarchy. Adopted from adk-rust
P-01/P-04 (CONFLICT-6). Every public pregolya API returns `Result<T, PregolyaError>`.

**RetryHint**
A field on PregolyaError indicating whether the caller should retry: `Never`,
`Maybe`, or `Later(Duration)`. Allows callers to implement backoff without inspecting
internal error details.

**InvalidUpdateError**
The specific PregolyaError raised when two PregelTasks in the same super-step both write
to the same LastValue channel. Surfaced immediately during ReducersApplied; terminates the
Run with `status: failed`.

**PolicyNotEnforceable**
The PregolyaError returned by `Sandbox::execute` when a strict BudgetPolicy or sandbox
policy is applied against a non-enforcing backend. The caller cannot proceed; the error is
not retriable.

---

## Term Reconciliation Table (LangChain Python → pregolya)

| LangChain Python term | pregolya term | Change from Python |
|----------------------|-----------------|-------------------|
| `Runnable` | Runnable | Identical semantics; Rust async trait |
| `RunnableSequence` (`A \| B`) | RunnableSequence (via `\|` operator) | Identical composition semantics |
| `StateGraph` | StateGraph | Identical; BSP execution model from LangGraph |
| `interrupt()` | `interrupt()` | HITL semantics preserved; FIFO resume is pregolya-native (CONFLICT-3) |
| `put_writes` | `put_writes` | Per-task durability; sync-default is pregolya-native (CONFLICT-2) |
| `BaseCheckpointSaver` | CheckpointSaver | name preserved from LangGraph BaseCheckpointSaver; same interface |
| `RunnableConfig` | RunnableConfig | name preserved; no rename |
| `BaseMessage` | Message | Renamed; ContentBlock replaces raw string content |
| `HumanMessage`, `AIMessage`, `SystemMessage`, `ToolMessage` | Message enum: Ai(AiMessage) \| Human(HumanMessage) \| System(SystemMessage) \| Tool(ToolMessage) | Variant instead of subclass |
| `ToolCall` / `ToolMessage` | ContentBlock::ToolCall / ToolMessage | Typed ContentBlock variants; tool-result: ToolMessage per BC-2.09.002 |
| `BaseException` hierarchy | PregolyaError 2D struct | Different structure; adk-rust P-01/P-04 adopted (CONFLICT-6) |
| Thread (LangGraph Platform) | Thread | Same concept; no wire compat with Platform |
| Assistant (LangGraph Platform) | Assistant | Same concept; no wire compat with Platform |
| `BaseStore` (LangGraph) | MemoryStore (long-horizon KV+vector) | Same concept; CAP-017 |
| `Send` (LangGraph) | `Send(node, state)` in SendEdge | Identical fan-out semantics |

---

## Dev Console Terms (D-356)

> **D-356 dev-console scope expansion (2026-09-06, business-analyst).** Append-only delta.
> Terms below are net-new to the pregolya ubiquitous language. All prior terms above are
> unchanged. These terms are specific to the developer console surface (CAP-041 through
> CAP-048 in capabilities-p1-p2.md §P1 — Developer Console).

**Developer Console**
The local development and debugging UI served by the `pregolya-console` crate and launched
via `pregolya console` (CAP-041). A pure SSE+REST client of the existing pregolya-server wire
contract: it renders the compiled StateGraph visually, streams live run events with node
highlighting, enables checkpoint browsing and trajectory replay, surfaces HITL approval
dialogs, and provides token-budget and guardrail event feeds. It is an inspection surface, not
an execution engine — the same posture as `adk web` (Google ADK) and LangGraph Studio.
The console consumes only the public wire contract (same as an embedding host); it does NOT
reach into engine internals. Analogous reference implementations: `adk web` / `adk-server`
(adk-rust v1.0.0); LangGraph Studio. Transport: REST+SSE (no WebSocket — confirmed by
research memo §4.0 premise correction; ADR-006 SSE transport is already the reference).

**Developer-Operator**
The human actor who runs `pregolya console` locally to inspect, debug, and approve agent
runs. See entities-server.md §Actors / Roles (D-356) for the full behavioral cluster
definition and sub-persona breakdown (P1 — Graph Author through P5 — Security Reviewer).
Distinct from the SDK integrator (authoring graphs) and the embedding host (programmatic
production consumer).

**Graph Descriptor**
A server-produced document describing the compiled `StateGraph` as a structured node/edge
list. Emitted by the graph-descriptor endpoint (CAP-042, `GET /assistants/{id}/graph`).
Format: JSON node/edge object plus optional Graphviz DOT source (`dotSrc: String`).
Each node entry carries its name and kind (regular node vs. conditional-edge router); each
edge entry carries source, target, and an optional condition label. Used by the console
frontend to render the DAG view and drive live node-highlighting during runs
(nodes matched by name against incoming `node_start`/`node_end` StreamEvents). The Graph
Descriptor is a static structural snapshot of the compiled graph; it does NOT carry runtime
execution state (that lives in the checkpoint + event stream).

**Trajectory Replay**
The developer-operator workflow of browsing a thread's checkpoint history
(`GET /threads/{id}/history`), inspecting state at any checkpoint step
(`GET /threads/{id}/state?checkpoint_id=<id>`), and optionally forking a new run from an
earlier checkpoint to explore alternative execution paths. Backed by the CAP-005 checkpoint
substrate; the console is a thin UI client over the existing history API. Enabled by
CAP-044 (Checkpoint History Browser and Trajectory Replay). The term "replay" means: read
state and re-execute from a prior point via the existing HITL resume machinery, not a
separate replay engine.
**Disambiguation from TrajectoryRecord (CAP-040):** `TrajectoryRecord` is an audit-grade
durable record for the research orchestrator pattern (`checkpoint::trajectory` module,
ADR-030). Trajectory Replay is the human-facing dev console workflow that browses the
standard checkpoint history via the Thread history endpoint. Both use the word "trajectory"
but refer to distinct mechanisms: CAP-040's records live in a storage slice isolated from
compaction; Trajectory Replay reads the rolling checkpoint history that IS subject to
compaction boundary effects. The two must not be conflated.

**Console Run Inspector**
The console panel that renders a sorted event timeline for any `run_id` — from stored events
(completed runs) or live SSE stream (in-progress runs). Provides expandable per-event
payloads (node input/output state, tool args/result, guardrail boundary and outcome) and
integrates with the Trace/Span backend (CAP-042) for sub-event span latency detail.
For live runs, drives real-time node highlighting on the StateGraph visualization by matching
incoming `node_start`/`node_end` events to Graph Descriptor nodes. A frontend surface only —
it is not an engine component and does not modify execution. Enabled by CAP-043 (Run
Inspection and Live Monitoring Panel).

---

## Changelog

> **Historical record — superseded by frontmatter `changelog:` (Form A).**
> The frontmatter `changelog:` YAML list above is the **authoritative** changelog for this file.

| Version | Date | Change | Source |
|---------|------|--------|--------|
| 1.7 | 2026-09-06 | D-356 dev-console scope expansion — §Dev Console Terms section added (Developer Console, Developer-Operator, Graph Descriptor, Trajectory Replay, Console Run Inspector). Research memo added to inputs. | D-356 |
| 1.4 | 2026-07-21 | F-P131-05 (burst-226) — §ProvenanceTag: disambiguation note added. ProvenanceTag (SS-11, 3-field ingress-boundary audit struct) has no trust-level dimension. Template-composition trust is handled by `TrustLevel` (`pregolya-prompts: prompts::template`; ADR-015 §Decision 3). Two axes must not be conflated. | F-P131-05 |
| 1.3 | 2026-07-19 | F-P117-01 — add `summary_halt` to Run status lifecycle. Terminal set: completed \| failed \| cancelled \| summary_halt. `summary_halt` is a first-class terminal state reached via in_progress on the OnCeiling::Summarize path (BC-2.12.003 PC7/PC8). | F-P117-01 |
| 1.2 | 2026-07-15 | F-P58-03 — §ProvenanceTag and §GuardrailHook updated to BC-authoritative terminology. ProvenanceTag: `source_type`/`tool_name?`/`invocation_id?`/`timestamp` → `boundary_type` (ToolResult\|RAGRetrieval\|MemoryIngress), `ingress_id`, `sequence_position`; User/Model removed per BC-2.11.001 EC-004. GuardrailHook: Accept/Reject/Redact retired → `Pass`/`Fail{reason,severity}`/`Transform{new_content}` with `GuardrailResult`; callable signature updated to match interface-definitions.md v2.13. | F-P58-03 |
| 1.1 | 2026-07-14 | Reconciliation table line 132: changed pregolya identifier from `Store` to `MemoryStore` to match canonical Rust trait name per BC-2.15.001 Architecture Anchors and module-decomposition.md §Server-crate canonical types (F-P39-01, ADV-P1D-PASS-39) | F-P39-01 |
