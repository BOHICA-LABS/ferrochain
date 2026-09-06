#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-anthropic — Anthropic provider implementation.
//!
//! Implements `BaseChatModel` for `ChatAnthropic`.
//! Note: Anthropic provides no public embeddings API — `EmbeddingsAnthropic` is not implemented
//! (ADR-017).
//!
//! Modules (filled by TDD stories):
//! - `chat` — `ChatAnthropic` impl `BaseChatModel`
