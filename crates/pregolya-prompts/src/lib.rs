#![forbid(unsafe_code)]
#![warn(missing_docs)]
//! pregolya-prompts — prompt template construction and injection safety.
//!
//! Modules (filled by TDD stories):
//! - `template`         — `PromptTemplate`, f-string engine (MEDIUM, SS-18)
//! - `chat_template`    — `ChatPromptTemplate`, `MessagesPlaceholder` (MEDIUM, SS-18)
//! - `few_shot`         — `FewShotPromptTemplate`, example selectors (MEDIUM, SS-18)
//! - `injection_guard`  — `SlotTrustPolicy`, `TrustLevel` (HIGH, VP-006, SS-18)
