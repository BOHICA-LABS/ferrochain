#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-openai-sdk — OpenAI wire client.
//!
//! Standalone crate with no pregolya-core dependency (D17-Q5 / ADR-007).
//! Contains HTTP client, SSE parsing, and OpenAI API type definitions.
//! Consumed by `pregolya-openai` which adds the pregolya-core trait impl layer.
