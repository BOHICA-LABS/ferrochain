#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-vectorstores — vector storage and retrieval.
//!
//! Modules (filled by TDD stories):
//! - `store`      — `VectorStore` trait, `VectorStoreFactory` (MEDIUM, SS-21)
//! - `retriever`  — `VectorStoreRetriever` owning `Arc<dyn VectorStore>` (MEDIUM, SS-20)
//! - `memory`     — in-memory VectorStore backend (MEDIUM, SS-21)
//! - `similarity` — `cosine_similarity` pure primitive (CRITICAL, VP-009, SS-21)
//! - `mmr`        — Maximal Marginal Relevance selection (MEDIUM, SS-21)
