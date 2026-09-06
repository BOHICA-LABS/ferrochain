#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-checkpoint — durable per-task checkpointing.
//!
//! Modules (filled by TDD stories):
//! - `saver`         — `CheckpointSaver` trait + `put_writes` contract (CRITICAL, VP-002, SS-04)
//! - `session_index` — triple-address enforcement (CRITICAL, SS-04)
//! - `clock`         — monotonic logical clock (CRITICAL, SS-04)
//! - `lineage`       — fork via `parent_checkpoint_id` (HIGH, SS-04)
//! - `encryption`    — at-rest encryption with rotation (CRITICAL, SS-04)
//! - `sqlite`        — SQLite backend (`checkpoint-sqlite` feature, SS-04)
//! - `memory`        — in-memory backend for tests (`checkpoint-memory` feature, SS-04)
//! - `postgres`      — PostgreSQL backend (`checkpoint-postgres` feature, SS-04)
//! - `trajectory`    — `TrajectoryWriter` + `TrajectoryReader` impl (MEDIUM, SS-04)
