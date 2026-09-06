#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-ollama — Ollama provider implementation.
//!
//! Implements `BaseChatModel` for `ChatOllama` and `Embeddings` for `EmbeddingsOllama`.
//! No API key newtype (Ollama runs locally without credentials by default).
//!
//! Modules (filled by TDD stories):
//! - `chat`       — `ChatOllama` impl `BaseChatModel`
//! - `embeddings` — `EmbeddingsOllama` impl `Embeddings` (HIGH, SS-22)
