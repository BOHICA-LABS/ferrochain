#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-graph — StateGraph definition, BSP execution, HITL, budget governance.
//!
//! Modules (filled by TDD stories):
//! - `definition`    — `StateGraph` builder, node/edge registration (HIGH, SS-02)
//! - `channels`      — channel types: `LastValue`, `Append`, `Barrier`, `LedgerChannel` (HIGH, SS-02)
//! - `bsp_engine`    — super-step executor, `reduce_super_step` (CRITICAL, VP-001, SS-03)
//! - `hitl`          — interrupt queue, suspend/resume, `PreToolCallHook` (CRITICAL, VP-011, SS-05)
//! - `scheduler`     — outer orchestrator loop, `CompiledStateGraph::invoke` (CRITICAL, SS-03)
//! - `budget`        — `BudgetEngine` dispatch, `EvidenceJournal`, compaction (HIGH, SS-10)
//! - `provenance`    — `ProvenanceTag` attachment, `GuardrailHook` dispatch (HIGH, SS-11)
//! - `event_emitter` — streaming event emission channel (MEDIUM, SS-06)
