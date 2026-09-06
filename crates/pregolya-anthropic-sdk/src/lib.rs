#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-anthropic-sdk — Anthropic wire client.
//!
//! Standalone crate with no pregolya-core dependency (D17-Q5 / ADR-007).
//! Contains HTTP client, SSE parsing, and Anthropic API type definitions.
//! Consumed by `pregolya-anthropic` which adds the pregolya-core trait impl layer.
