#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-core — universal composition protocol, typed message model,
//! error taxonomy, credential security primitives, and streaming event types.
//!
//! This crate is the foundation of the pregolya workspace. All other crates
//! depend on it (except `pregolya-macros` and the standalone SDK crates).
//!
//! Module layout (to be filled by TDD stories):
//! - `runnable`  — `Runnable<I,O>` trait + composition combinators (SS-01)
//! - `message`   — `Message` enum + `ContentBlock` (SS-01)
//! - `error`     — `PregolyaError` 2D struct (SS-14)
//! - `credentials` — API key newtypes with redacted `Debug` (SS-14)
//! - `events`    — streaming event taxonomy (SS-06)
//! - `config`    — `RunnableConfig`, `ChatConfig` (SS-01)
//! - `retry`     — `ToolRetryPolicy`, `CircuitBreaker` (SS-16)
//! - `budget`    — budget governance types + `check_watermark_trigger` (SS-10)
//! - `tool`      — `Tool` trait, `DynTool`, `ToolInput`, `ToolOutput` (SS-08)
//! - `documents` — `Document` carrier type (definitions-only, SS-20)
//! - `retriever` — `Retriever` trait, `GuardedDocuments` (SS-20)
//! - `embeddings` — `Embeddings` trait + `validate_embedding_batch` (SS-22)
//! - `serializable` — `LcSerializable`, `Reviver`, `Serialized` (SS-19)
//! - `guardrail` — `GuardrailHook` + boundary types (definitions-only, SS-11)
//! - `action_risk` — `ActionRisk` enum (definitions-only, SS-05)
//! - `context_mutation` — `ContextMutationConfig` (definitions-only, SS-01)
//! - `write_guard` — `MemoryWriteGuard` trait (definitions-only, SS-15)
//! - `invocation_context` — `InvocationContext` (definitions-only, SS-11)
//! - `trajectory` — `TrajectoryRecord`, `TrajectoryWriter`, `TrajectoryReader` (definitions-only, SS-04)
