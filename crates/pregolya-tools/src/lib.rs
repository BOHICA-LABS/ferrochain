#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-tools — first-party tool implementations.
//!
//! Modules (filled by TDD stories):
//! - `config` — `ToolConfig` shared per-tool configuration (MEDIUM, VP-013, SS-23)
//! - `fs`     — `ReadFileTool`, `WriteFileTool`, `EditFileTool`, `ListDirTool` (MEDIUM, SS-23)
//! - `shell`  — `BashTool` subprocess execution (HIGH, VP-013, SS-23)
//! - `search` — `GrepTool` in-process regex search (MEDIUM, SS-23)
