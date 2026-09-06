#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-memory — long-horizon memory persistence.
//!
//! Modules (filled by TDD stories):
//! - `store`       — `MemoryStore` trait (KV + vector ops, GDPR erasure, SS-15)
//! - `sqlite`      — SQLite durable backend (SS-15)
//! - `in_memory`   — ephemeral in-memory backend (test/dev, SS-15)
//! - `search`      — keyword, vector, and hybrid search (SS-15)
//! - `skills`      — `SkillStore` routing overlay (definitions row only, SS-15)
//! - `write_guard` — guarded write enforcement engine (HIGH, SS-15)
