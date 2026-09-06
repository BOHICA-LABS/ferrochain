#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-ollama-sdk — Ollama wire client.
//!
//! Standalone crate with no pregolya-core dependency (D17-Q5 / ADR-007).
//! Contains HTTP client and Ollama API type definitions.
//! Consumed by `pregolya-ollama` which adds the pregolya-core trait impl layer.
