#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-openai — OpenAI provider implementation.
//!
//! Implements `BaseChatModel` for `ChatOpenAI` and `Embeddings` for `EmbeddingsOpenAI`.
//! Uses `pregolya-openai-sdk` for the HTTP wire layer and `pregolya-core` for traits.
//!
//! Modules (filled by TDD stories):
//! - `chat`       — `ChatOpenAI` impl `BaseChatModel`
//! - `embeddings` — `EmbeddingsOpenAI` impl `Embeddings` (HIGH, SS-22)
