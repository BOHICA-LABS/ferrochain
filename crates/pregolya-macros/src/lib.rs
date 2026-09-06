//! Procedural macros for pregolya.
//!
//! Provides `#[tool]`, `#[entrypoint]`, and `#[task]` attribute macros.
//! These are pass-through stubs during workspace init; TDD stories fill the implementations.

extern crate proc_macro;
use proc_macro::TokenStream;

/// `#[tool]` attribute macro — generates `Tool` trait implementation with JSON Schema derivation.
///
/// Stub implementation: passes through the item unchanged.
/// Full implementation delivered by story S-1.x (macros::tool).
#[proc_macro_attribute]
pub fn tool(_attr: TokenStream, item: TokenStream) -> TokenStream {
    item
}

/// `#[entrypoint]` attribute macro — wires the START edge for `StateGraph` nodes.
///
/// Stub implementation: passes through the item unchanged.
/// Full implementation delivered by story S-1.x (macros::entrypoint).
#[proc_macro_attribute]
pub fn entrypoint(_attr: TokenStream, item: TokenStream) -> TokenStream {
    item
}

/// `#[task]` attribute macro — generates task registration boilerplate.
///
/// Stub implementation: passes through the item unchanged.
/// Full implementation delivered by story S-1.x (macros::task).
#[proc_macro_attribute]
pub fn task(_attr: TokenStream, item: TokenStream) -> TokenStream {
    item
}
