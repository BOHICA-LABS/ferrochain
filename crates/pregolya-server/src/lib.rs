#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-server — Axum HTTP server.
//!
//! Modules (filled by TDD stories):
//! - `handlers`  — Thread/Assistant/Run/Schedule CRUD routes (HIGH, SS-12)
//! - `security`  — `SecurityConfig::default()` deny-CORS, debug route opt-in (HIGH, SS-12)
//! - `streaming` — SSE streaming endpoint (HIGH, SS-12)
//! - `stores`    — `IdempotencyStore`, `RateLimitStore`, `RunStore` trait seams (HIGH, SS-12)
//! - `cron`      — `CronSchedule` parsing and proactive run triggering (MEDIUM, SS-12)
