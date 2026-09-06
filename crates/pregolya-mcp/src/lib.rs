#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-mcp — MCP client, server, and tool adapters.
//!
//! Modules (filled by TDD stories):
//! - `client`      — `MultiServerMcpClient` (MEDIUM, SS-09)
//! - `discovery`   — tool discovery and registration (MEDIUM, SS-09)
//! - `exception`   — bare `ToolException` re-raise detection (MEDIUM, VP-004, SS-09)
//! - `graph_tool`  — wraps `CompiledStateGraph` as `DynTool` (MEDIUM, VP-016, SS-09)
//! - `ingress`     — untrusted-ingress routing, guardrail seam (HIGH, SS-09)
//! - `interceptor` — `ToolCallInterceptor` trait, onion-order chain (MEDIUM, SS-09)
//! - `registry`    — `ToolRegistry` Arc<RwLock<...>> (MEDIUM, SS-09)
//! - `sanitize`    — credential redaction, `redact_credentials` (MEDIUM, VP-015, SS-09)
//! - `server`      — MCP server endpoint (MEDIUM, SS-09)
//! - `session`     — `McpSessionGuard` RAII, `SessionSource::OnDemand` (MEDIUM, SS-09)
