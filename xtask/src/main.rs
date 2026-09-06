//! cargo xtask — workspace task runner for pregolya.
//!
//! Usage: cargo xtask <subcommand>
//!
//! Subcommands:
//!   check-file-size   Enforce production file size gates (CLAUDE.md §File size & module splitting)
//!   check-client-timeout  CI lint gate: reject reqwest Client::new() outside tests
//!   check-no-panic    CI lint gate: reject .expect()/.unwrap() in library src/
//!   deny-anyhow-in-lib    CI lint gate: reject anyhow imports in library crates
//!   deny-description-cache-key  CI lint gate: reject description-proxy cache-key usage

use std::process::{Command, exit};

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let subcommand = args.get(1).map(String::as_str).unwrap_or("");
    match subcommand {
        "check-file-size" => check_file_size(),
        "check-client-timeout" => check_client_timeout(),
        "check-no-panic" => check_no_panic(),
        "deny-anyhow-in-lib" => deny_anyhow_in_lib(),
        "deny-description-cache-key" => deny_description_cache_key(),
        _ => {
            eprintln!("Usage: cargo xtask <subcommand>");
            eprintln!("Subcommands:");
            eprintln!(
                "  check-file-size           File size gate (prod 500/750, test 1000/1500 code-lines)"
            );
            eprintln!(
                "  check-client-timeout      Lint: reqwest Client::new() outside tests is forbidden"
            );
            eprintln!(
                "  check-no-panic            Lint: .expect()/.unwrap() in library src/ is forbidden"
            );
            eprintln!(
                "  deny-anyhow-in-lib        Lint: anyhow imports in pregolya-* library crates"
            );
            eprintln!("  deny-description-cache-key Lint: description-proxy cache-key usage");
            exit(1);
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Returns true when `path` identifies a test-only file.
///
/// Matches:
/// - Files named `tests.rs` (any directory depth, e.g. `src/tests.rs`)
/// - Files ending with `_test.rs` or `_tests.rs`
/// - Files under a `tests/` directory component (e.g. `crates/foo/tests/integration.rs`)
///
/// Does NOT use `.contains("test")` substring matching, which would
/// incorrectly suppress production files in crates whose names contain
/// "test" (e.g. `pregolya-standard-tests`).
fn is_test_file(path: &str) -> bool {
    path.ends_with("/tests.rs")
        || path == "tests.rs"
        || path.contains("/tests/")
        || path.ends_with("_test.rs")
        || path.ends_with("_tests.rs")
}

// ─────────────────────────────────────────────────────────────────────────────
// check-file-size
// ─────────────────────────────────────────────────────────────────────────────

fn check_file_size() {
    // NOTE: tokei counts ALL code-lines in a file (including #[cfg(test)] blocks
    // that are inline in production files).  The test-file thresholds (1000/1500)
    // apply only to files under `tests/` or ending with `_test.rs` / `_tests.rs`.
    // Inline test modules contribute to the production file's code count — this is
    // intentional: a production file whose inline tests push it over the
    // production hard gate (750 lines) should be split anyway.
    //
    // Exclusions (auto-skipped in post-processing):
    //   *.gen.rs          — generated code, not subject to size gate
    //   paths with /target/ or OUT_DIR  — build artifacts
    //   paths with /tests/fixtures/     — test fixture data
    //
    // Scan paths: crates/ + xtask/src/ (both are workspace members).
    let output = Command::new("tokei")
        .args([
            "--output",
            "json",
            "--exclude",
            "*.gen.rs",
            "--exclude",
            "*/tests/fixtures/*",
            "crates/",
            "xtask/src/",
        ])
        .output();

    let output = match output {
        Ok(o) => o,
        Err(_) => {
            eprintln!("ERROR: tokei not found on PATH. Install with: cargo install tokei --locked");
            eprintln!("The file-size gate requires tokei to measure code lines.");
            eprintln!("Run 'just setup' to install all required tools.");
            exit(1);
        }
    };

    if !output.status.success() {
        eprintln!("tokei failed: {}", String::from_utf8_lossy(&output.stderr));
        exit(1);
    }

    let json: serde_json::Value = match serde_json::from_slice(&output.stdout) {
        Ok(v) => v,
        Err(e) => {
            eprintln!("Failed to parse tokei output: {e}");
            exit(1);
        }
    };

    let allowlist = load_allowlist();
    let prod_soft: u64 = 500;
    let prod_hard: u64 = 750;
    let test_soft: u64 = 1000;
    let test_hard: u64 = 1500;

    let mut violations: Vec<String> = Vec::new();
    let mut warnings: Vec<String> = Vec::new();

    if let Some(rust) = json.get("Rust")
        && let Some(reports) = rust.get("reports").and_then(|r| r.as_array())
    {
        for report in reports {
            let name = report
                .get("name")
                .and_then(|n| n.as_str())
                .unwrap_or("<unknown>");
            let code = report
                .get("stats")
                .and_then(|s| s.get("code"))
                .and_then(|c| c.as_u64())
                .unwrap_or(0);

            // Skip generated code, build artifacts, and fixture data.
            if name.contains("/target/")
                || name.contains("OUT_DIR")
                || name.ends_with(".gen.rs")
                || name.contains("/tests/fixtures/")
            {
                continue;
            }

            if allowlist.is_allowed(name) {
                continue;
            }

            let is_test = is_test_file(name);
            let (soft, hard) = if is_test {
                (test_soft, test_hard)
            } else {
                (prod_soft, prod_hard)
            };

            if code > hard {
                violations.push(format!(
                    "HARD GATE FAIL: {name} has {code} code lines (limit: {hard})"
                ));
            } else if code > soft {
                warnings.push(format!(
                    "soft warning: {name} has {code} code lines (soft limit: {soft})"
                ));
            }
        }
    }

    for w in &warnings {
        eprintln!("WARN: {w}");
    }

    if !violations.is_empty() {
        for v in &violations {
            eprintln!("ERROR: {v}");
        }
        eprintln!(
            "File size gate FAILED. Add an allowlist entry to xtask/file-size-allowlist.toml or split the file."
        );
        exit(1);
    }

    println!("check-file-size PASSED ({} warnings).", warnings.len());
}

// ─────────────────────────────────────────────────────────────────────────────
// check-client-timeout (NE-04 / DI-009)
// ─────────────────────────────────────────────────────────────────────────────

fn check_client_timeout() {
    // Scan library crate src/ for reqwest Client::new() outside test files.
    // Uses file-by-file scanning (same as check-no-panic) so that path-based
    // exclusions are applied correctly — grep line filtering with contains("test")
    // would incorrectly suppress production code in crates whose path contains
    // "test" (e.g. pregolya-standard-tests).
    let output = Command::new("find")
        .args(["crates/", "-name", "*.rs", "-not", "-path", "*/target/*"])
        .output();

    let files_output = match output {
        Ok(o) => o,
        Err(e) => {
            eprintln!("find failed: {e}");
            exit(1);
        }
    };

    let files_str = String::from_utf8_lossy(&files_output.stdout);
    let mut all_findings: Vec<String> = Vec::new();

    for file_path in files_str.lines() {
        let content = match std::fs::read_to_string(file_path) {
            Ok(c) => c,
            Err(_) => continue,
        };
        let findings = scan_for_timeout_violations_in_source(&content, file_path);
        all_findings.extend(findings);
    }

    if !all_findings.is_empty() {
        for f in &all_findings {
            eprintln!("ERROR: reqwest::Client::new() without timeout: {f}");
        }
        eprintln!("Use Client::builder().timeout(Duration::from_secs(30)).build() instead.");
        exit(1);
    }
    println!("check-client-timeout PASSED.");
}

/// Scan `src` for reqwest client timeout violations using `proc_macro2` token-tree walking.
///
/// Detects:
///   - `reqwest::Client::new()` (fully qualified)
///   - `Client::new()` (unqualified, from `use reqwest::Client`)
///   - `Client::builder().build()` or `reqwest::Client::builder()...build()` without `.timeout()`
///
/// Uses token-level scanning so string literals, comments, and char literals
/// (which were the source of F-2, B-5, and related false positive/negative bugs)
/// are handled correctly by the lexer.
fn scan_for_timeout_violations_in_source(src: &str, path: &str) -> Vec<String> {
    if is_test_file(path) {
        return Vec::new();
    }

    use proc_macro2::TokenStream;

    let ts: TokenStream = match src.parse() {
        Ok(s) => s,
        Err(e) => return vec![format!("{}:0: FAILED TO LEX FILE: {}", path, e)],
    };

    let mut findings = Vec::new();
    walk_timeout_tokens(ts.into_iter(), &mut findings, path);
    findings
}

/// Recursive token-tree walker for `scan_for_timeout_violations_in_source`.
fn walk_timeout_tokens(
    iter: proc_macro2::token_stream::IntoIter,
    findings: &mut Vec<String>,
    path: &str,
) {
    use proc_macro2::{Delimiter, TokenTree};

    let tokens: Vec<TokenTree> = iter.collect();
    let mut i = 0;
    while i < tokens.len() {
        // Recurse into any group (brace, paren, bracket).
        if let TokenTree::Group(g) = &tokens[i] {
            walk_timeout_tokens(g.stream().into_iter(), findings, path);
            i += 1;
            continue;
        }

        // Try to match: reqwest :: Client :: new ( ... )
        // Token sequence: Ident("reqwest") Punct(":") Punct(":") Ident("Client")
        //                 Punct(":") Punct(":") Ident("new") Group(Paren)
        if matches!(&tokens[i], TokenTree::Ident(id) if id == "reqwest") {
            if is_double_colon(&tokens, i + 1)
                && matches!(tokens.get(i + 3), Some(TokenTree::Ident(id)) if id == "Client")
                && is_double_colon(&tokens, i + 4)
                && matches!(tokens.get(i + 6), Some(TokenTree::Ident(id)) if id == "new")
                && matches!(tokens.get(i + 7), Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Parenthesis)
            {
                let line = if let Some(TokenTree::Ident(id)) = tokens.get(i + 6) {
                    id.span().start().line
                } else {
                    0
                };
                findings.push(format!("{}:{}: reqwest::Client::new()", path, line));
                i += 8;
                continue;
            }
            // Also check reqwest :: Client :: builder() chain
            if is_double_colon(&tokens, i + 1)
                && matches!(tokens.get(i + 3), Some(TokenTree::Ident(id)) if id == "Client")
                && is_double_colon(&tokens, i + 4)
                && matches!(tokens.get(i + 6), Some(TokenTree::Ident(id)) if id == "builder")
            {
                if let Some(finding) = check_builder_chain_violation(&tokens, i, path) {
                    findings.push(finding);
                }
                i += 1;
                continue;
            }
        }

        // Try to match standalone Client :: new ( ... ) — NOT preceded by `:`.
        // Preceding `:` means this Client is part of a qualified path (mcp_sdk::Client),
        // which must not be flagged.
        if matches!(&tokens[i], TokenTree::Ident(id) if id == "Client") {
            let prev_is_colon =
                i > 0 && matches!(&tokens[i - 1], TokenTree::Punct(p) if p.as_char() == ':');
            if !prev_is_colon {
                // Check for Client :: new ( ... )
                if is_double_colon(&tokens, i + 1)
                    && matches!(tokens.get(i + 3), Some(TokenTree::Ident(id)) if id == "new")
                    && matches!(tokens.get(i + 4), Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Parenthesis)
                {
                    let line = if let Some(TokenTree::Ident(id)) = tokens.get(i + 3) {
                        id.span().start().line
                    } else {
                        0
                    };
                    findings.push(format!("{}:{}: Client::new()", path, line));
                    i += 5;
                    continue;
                }
                // Check for Client :: builder chain
                if is_double_colon(&tokens, i + 1)
                    && matches!(tokens.get(i + 3), Some(TokenTree::Ident(id)) if id == "builder")
                {
                    if let Some(finding) = check_builder_chain_violation(&tokens, i, path) {
                        findings.push(finding);
                    }
                    i += 1;
                    continue;
                }
            }
        }

        i += 1;
    }
}

/// Returns true when `tokens[idx]` and `tokens[idx+1]` are both `:` puncts.
fn is_double_colon(tokens: &[proc_macro2::TokenTree], idx: usize) -> bool {
    use proc_macro2::TokenTree;
    matches!(tokens.get(idx), Some(TokenTree::Punct(p)) if p.as_char() == ':')
        && matches!(tokens.get(idx + 1), Some(TokenTree::Punct(p)) if p.as_char() == ':')
}

/// Scan forward from `start` to find a `.build()` call in a builder chain.
/// Returns a finding if `.build()` is reached without `.timeout()`.
/// Stops at `;` (end of statement) without returning a finding.
fn check_builder_chain_violation(
    tokens: &[proc_macro2::TokenTree],
    start: usize,
    path: &str,
) -> Option<String> {
    use proc_macro2::TokenTree;
    let mut has_timeout = false;
    let mut i = start;
    while i < tokens.len() {
        match &tokens[i] {
            TokenTree::Punct(p) if p.as_char() == ';' => return None,
            TokenTree::Punct(p) if p.as_char() == '.' => {
                if let Some(TokenTree::Ident(id)) = tokens.get(i + 1) {
                    let name = id.to_string();
                    if name == "timeout" {
                        has_timeout = true;
                    }
                    if name == "build" {
                        let line = id.span().start().line;
                        if !has_timeout {
                            return Some(format!(
                                "{}:{}: Client::builder().build() without .timeout()",
                                path, line
                            ));
                        } else {
                            return None;
                        }
                    }
                }
            }
            _ => {}
        }
        i += 1;
    }
    None
}

// ─────────────────────────────────────────────────────────────────────────────
// check-no-panic (NE-07)
// ─────────────────────────────────────────────────────────────────────────────

fn check_no_panic() {
    // Scan library src/ for .unwrap() and .expect() outside #[cfg(test)] blocks.
    // Uses a file-level scanner to track test-block boundaries via brace depth,
    // avoiding false positives on legitimate test code (CLAUDE.md §SID-1).
    let output = Command::new("find")
        .args(["crates/", "-name", "*.rs", "-not", "-path", "*/target/*"])
        .output();

    let files_output = match output {
        Ok(o) => o,
        Err(e) => {
            eprintln!("find failed: {e}");
            exit(1);
        }
    };

    let files_str = String::from_utf8_lossy(&files_output.stdout);
    let mut all_findings: Vec<String> = Vec::new();

    for file_path in files_str.lines() {
        let content = match std::fs::read_to_string(file_path) {
            Ok(c) => c,
            Err(_) => continue,
        };
        let findings = scan_for_panics_in_source(&content, file_path);
        all_findings.extend(findings);
    }

    if !all_findings.is_empty() {
        for f in &all_findings {
            eprintln!("ERROR: panic-potential in library code: {f}");
        }
        eprintln!("Use ? propagation with structured error variants instead.");
        exit(1);
    }
    println!("check-no-panic PASSED.");
}

/// Scan `src` for `.unwrap()` and `.expect(` patterns outside `#[cfg(test)]` scopes.
///
/// Uses `proc_macro2` token-tree walking so that string literals, char literals,
/// and comments are handled at the lexer level rather than via ad-hoc string
/// scanning. This eliminates the entire class of F-1/B-2/B-3/B-6/B-7/B-8 edge
/// cases.
///
/// Returns a `Vec<String>` of `"path:line_num: .method()"` findings.
/// Returns empty when `path` is a test file (per `is_test_file`).
fn scan_for_panics_in_source(src: &str, path: &str) -> Vec<String> {
    if is_test_file(path) {
        return Vec::new();
    }

    use proc_macro2::TokenStream;

    let ts: TokenStream = match src.parse() {
        Ok(s) => s,
        Err(e) => return vec![format!("{}:0: FAILED TO LEX FILE: {}", path, e)],
    };

    let mut findings = Vec::new();
    walk_panic_tokens(ts.into_iter(), &mut findings, path, &mut 0u32);
    findings
}

/// Recursive token-tree walker for `scan_for_panics_in_source`.
fn walk_panic_tokens(
    iter: proc_macro2::token_stream::IntoIter,
    findings: &mut Vec<String>,
    path: &str,
    in_test_depth: &mut u32,
) {
    use proc_macro2::{Delimiter, TokenTree};

    let tokens: Vec<TokenTree> = iter.collect();
    let mut i = 0;
    while i < tokens.len() {
        match &tokens[i] {
            // Detect `#` followed by a `[...]` group — could be `#[cfg(test)]`.
            TokenTree::Punct(p) if p.as_char() == '#' => {
                if let Some(TokenTree::Group(g)) = tokens.get(i + 1)
                    && g.delimiter() == Delimiter::Bracket
                    && is_cfg_test_group(g)
                {
                    // Look ahead past the attribute to find the body.
                    // A brace body → walk it with incremented depth.
                    // A semicolon → semicolon-terminated form (use, mod decl, etc.),
                    //   do NOT increment depth (no inline block to suppress).
                    let mut j = i + 2;
                    while j < tokens.len() {
                        match &tokens[j] {
                            TokenTree::Group(body) if body.delimiter() == Delimiter::Brace => {
                                *in_test_depth += 1;
                                walk_panic_tokens(
                                    body.stream().into_iter(),
                                    findings,
                                    path,
                                    in_test_depth,
                                );
                                *in_test_depth -= 1;
                                i = j; // advance past the body
                                break;
                            }
                            TokenTree::Punct(p2) if p2.as_char() == ';' => {
                                i = j; // advance past the semicolon
                                break;
                            }
                            // Skip ident tokens (mod, fn, tests, etc.) and other attrs
                            _ => {}
                        }
                        j += 1;
                    }
                    i += 1;
                    continue;
                }
            }
            // Brace group NOT preceded by cfg(test) — walk it at current depth.
            TokenTree::Group(g) if g.delimiter() == Delimiter::Brace => {
                walk_panic_tokens(g.stream().into_iter(), findings, path, in_test_depth);
            }
            // Detect `.unwrap` or `.expect` when not inside a test scope.
            TokenTree::Punct(p) if p.as_char() == '.' && *in_test_depth == 0 => {
                if let Some(TokenTree::Ident(id)) = tokens.get(i + 1) {
                    let name = id.to_string();
                    if name == "unwrap" || name == "expect" {
                        let line = id.span().start().line;
                        findings.push(format!("{}:{}: .{}()", path, line, name));
                    }
                }
            }
            // Other non-brace groups (parens, brackets) — walk them too.
            TokenTree::Group(g) => {
                walk_panic_tokens(g.stream().into_iter(), findings, path, in_test_depth);
            }
            _ => {}
        }
        i += 1;
    }
}

/// Returns true when the token-tree group `g` (contents of `[...]`) represents
/// `cfg(test)` — i.e., the bracket stream is exactly `cfg ( test )`.
fn is_cfg_test_group(g: &proc_macro2::Group) -> bool {
    use proc_macro2::{Delimiter, TokenTree};
    let tokens: Vec<TokenTree> = g.stream().into_iter().collect();
    // Expect exactly: Ident("cfg") Group(Paren, [Ident("test")])
    if tokens.len() != 2 {
        return false;
    }
    let is_cfg = matches!(&tokens[0], TokenTree::Ident(id) if id == "cfg");
    let is_test_inner = if let TokenTree::Group(inner) = &tokens[1] {
        if inner.delimiter() == Delimiter::Parenthesis {
            let inner_toks: Vec<TokenTree> = inner.stream().into_iter().collect();
            inner_toks.len() == 1 && matches!(&inner_toks[0], TokenTree::Ident(id) if id == "test")
        } else {
            false
        }
    } else {
        false
    };
    is_cfg && is_test_inner
}

// ─────────────────────────────────────────────────────────────────────────────
// deny-anyhow-in-lib (NE-03 / DI-014 / ADR-010)
// ─────────────────────────────────────────────────────────────────────────────

fn deny_anyhow_in_lib() {
    let output = Command::new("grep")
        .args(["-rn", "--include=*.rs", "use anyhow", "crates/"])
        .output();

    match output {
        Ok(o) => {
            let stdout = String::from_utf8_lossy(&o.stdout);
            if !stdout.trim().is_empty() {
                eprintln!(
                    "ERROR: anyhow is banned from pregolya-* library crates (ADR-010 / NE-03):"
                );
                for line in stdout.lines() {
                    eprintln!("  {line}");
                }
                exit(1);
            }
        }
        Err(e) => {
            eprintln!("grep failed: {e}");
            exit(1);
        }
    }
    println!("deny-anyhow-in-lib PASSED.");
}

// ─────────────────────────────────────────────────────────────────────────────
// deny-description-cache-key (NE-05 / ADR-011)
// ─────────────────────────────────────────────────────────────────────────────

fn deny_description_cache_key() {
    for pattern in &["cache_key", "CacheKey", "cache_key_for"] {
        let output = Command::new("grep")
            .args(["-rn", "--include=*.rs", pattern, "crates/"])
            .output();

        match output {
            Ok(o) => {
                let stdout = String::from_utf8_lossy(&o.stdout);
                // Only flag if it looks like description-proxy usage
                let findings: Vec<&str> = stdout
                    .lines()
                    .filter(|l| l.contains("description") || l.contains("Description"))
                    .collect();
                if !findings.is_empty() {
                    for f in &findings {
                        eprintln!(
                            "ERROR: description-proxy cache-key usage (ADR-011 / NE-05): {f}"
                        );
                    }
                    exit(1);
                }
            }
            Err(e) => {
                eprintln!("grep failed: {e}");
                exit(1);
            }
        }
    }
    println!("deny-description-cache-key PASSED.");
}

// ─────────────────────────────────────────────────────────────────────────────
// Allowlist support
// ─────────────────────────────────────────────────────────────────────────────

#[derive(serde::Deserialize, Default)]
struct AllowList {
    #[serde(default)]
    allow: Vec<AllowEntry>,
}

#[derive(serde::Deserialize)]
struct AllowEntry {
    path: String,
    #[allow(dead_code)]
    reason: String,
    #[allow(dead_code)]
    approver: String,
    #[allow(dead_code)]
    date: String,
}

impl AllowList {
    fn is_allowed(&self, path: &str) -> bool {
        // Use ends_with only — contains() would match substrings (e.g.,
        // "pregolya-core" matching "pregolya-core-extra"), causing false negatives.
        self.allow.iter().any(|e| path.ends_with(&e.path))
    }
}

fn load_allowlist() -> AllowList {
    let path = "xtask/file-size-allowlist.toml";
    match std::fs::read_to_string(path) {
        Ok(content) => toml::from_str(&content).unwrap_or_default(),
        Err(_) => AllowList::default(),
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// Unit tests (file-module form — body lives in tests.rs)
// ─────────────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests;
