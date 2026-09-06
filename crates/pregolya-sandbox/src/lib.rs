#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-sandbox — secure execution backends.
//!
//! Modules (filled by TDD stories):
//! - `path_guard` — `canonicalize_beneath_root`, `WorkspaceFs` facade (CRITICAL, VP-003, SS-13)
//! - `wasm`       — WASM execution backend (`sandbox-wasm` feature, SS-13)
//! - `container`  — container execution backend (`sandbox-container` feature, SS-13)
//! - `seatbelt`   — macOS Seatbelt deny-by-default profile (NE-16, SS-13)
//! - `process`    — `ProcessBackend` — explicit non-default OS process (SS-13)
//! - `policy`     — `SandboxPolicy` enforcement (SS-13)
