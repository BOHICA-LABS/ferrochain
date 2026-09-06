use super::*;

// ── check-no-panic gate ──────────────────────────────────────────────────

/// Gate-bypass regression: production `.unwrap()` that follows a
/// `#[cfg(test)] mod tests;` FILE-MODULE declaration must NOT be skipped.
///
/// Before the M-1 fix the semicolon-terminated declaration latched
/// `pending_cfg_test = true`; the next `{` (the production function's opening
/// brace) then activated `in_test_block`, suppressing the finding.
#[test]
fn test_no_panic_finds_unwrap_after_cfg_test_mod_decl() {
    let src = r#"
#[cfg(test)] mod tests;

pub fn production_fn() -> i32 {
    let x: Option<i32> = Some(1);
    x.unwrap()
}
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "should detect unwrap in production code after cfg(test) mod decl; got: {findings:?}"
    );
}

/// Correctly suppressed: `.unwrap()` inside an inline `#[cfg(test)]` block
/// must NOT be reported.
#[test]
fn test_no_panic_ignores_unwrap_in_cfg_test_block() {
    let src = r#"
#[cfg(test)]
mod tests {
    #[test]
    fn my_test() {
        let x: Option<i32> = Some(1);
        assert_eq!(x.unwrap(), 1);
    }
}
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        findings.is_empty(),
        "should NOT flag unwrap inside #[cfg(test)] block; got: {findings:?}"
    );
}

/// Correctly suppressed: entire file is a test file (path ends with `tests.rs`).
#[test]
fn test_no_panic_ignores_tests_rs_file() {
    let src = r#"
pub fn test_helper() -> i32 {
    let x: Option<i32> = Some(1);
    x.unwrap()
}
"#;
    let findings = scan_for_panics_in_source(src, "src/tests.rs");
    assert!(
        findings.is_empty(),
        "should NOT flag src/tests.rs; got: {findings:?}"
    );
}

/// Production code after an inline cfg(test) block (which DOES have braces)
/// must still be scanned after the block closes.
#[test]
fn test_no_panic_finds_unwrap_after_cfg_test_block_closes() {
    let src = r#"
#[cfg(test)]
mod tests {
    fn helper() {
        let _x: Option<i32> = Some(1);
    }
}

pub fn production_fn() -> i32 {
    let x: Option<i32> = Some(1);
    x.unwrap()
}
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "should detect unwrap in production code after cfg(test) block closes; got: {findings:?}"
    );
}

// ── check-client-timeout gate ────────────────────────────────────────────

/// M-3 regression: a crate whose PATH contains "test" (e.g. pregolya-standard-tests)
/// must NOT be suppressed by the timeout scanner.
#[test]
fn test_timeout_scanner_does_not_suppress_standard_tests_crate() {
    let src = "let client = reqwest::Client::new();\n";
    let findings =
        scan_for_timeout_violations_in_source(src, "crates/pregolya-standard-tests/src/lib.rs");
    assert!(
        !findings.is_empty(),
        "should detect missing timeout in standard-tests crate; got: {findings:?}"
    );
}

/// Actual test files (path ends with `tests.rs`) must be suppressed.
#[test]
fn test_timeout_scanner_suppresses_actual_test_file() {
    let src = "let client = reqwest::Client::new();\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-core/src/tests.rs");
    assert!(
        findings.is_empty(),
        "should suppress actual test files; got: {findings:?}"
    );
}

/// Files under a `tests/` directory component must be suppressed.
#[test]
fn test_timeout_scanner_suppresses_tests_dir_file() {
    let src = "let client = reqwest::Client::new();\n";
    let findings =
        scan_for_timeout_violations_in_source(src, "crates/pregolya-core/tests/integration.rs");
    assert!(
        findings.is_empty(),
        "should suppress files under tests/ directory; got: {findings:?}"
    );
}

// ── F-1 / F-2 / F-3 regression tests ───────────────────────────────────

/// F-1 regression: unbalanced { in string literal inside cfg(test) must NOT
/// suppress production code that follows.
#[test]
fn test_no_panic_string_literal_brace_does_not_latch_test_block() {
    let src = r#"
#[cfg(test)]
mod tests { const S: &str = "{"; fn h() {} }
pub fn prod() -> i32 { let x: Option<i32> = Some(1); x.unwrap() }
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "string-literal {{ must not latch in_test_block; got: {findings:?}"
    );
}

/// F-2 regression: line with Client::new() AND a URL string containing //
/// must still be flagged.
#[test]
fn test_timeout_scanner_flags_client_new_on_line_with_url_string() {
    let src = r#"let c = reqwest::Client::new(); let u = "https://api.openai.com/v1";"#;
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        !findings.is_empty(),
        "Client::new() on line with URL string must be flagged; got: {findings:?}"
    );
}

/// F-3 regression: Client::builder().build() on same line without .timeout() must be flagged.
#[test]
fn test_timeout_scanner_flags_builder_build_without_timeout_single_line() {
    let src = r#"let c = reqwest::Client::builder().build()?;"#;
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        !findings.is_empty(),
        "Client::builder().build() without .timeout() must be flagged; got: {findings:?}"
    );
}

/// F-3 negative: Client::builder() with .timeout() must NOT be flagged.
#[test]
fn test_timeout_scanner_does_not_flag_builder_with_timeout() {
    let src = r#"let c = reqwest::Client::builder().timeout(Duration::from_secs(30)).build()?;"#;
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        findings.is_empty(),
        "Client::builder().timeout(...).build() must NOT be flagged; got: {findings:?}"
    );
}

// ── is_test_file helper ──────────────────────────────────────────────────

#[test]
fn test_is_test_file_patterns() {
    assert!(is_test_file("src/tests.rs"));
    assert!(is_test_file("crates/foo/src/tests.rs"));
    assert!(is_test_file("crates/foo/tests/integration.rs"));
    assert!(is_test_file("src/foo_test.rs"));
    assert!(is_test_file("src/foo_tests.rs"));

    // Must NOT flag production files in crates with "test" in the crate name.
    assert!(!is_test_file("crates/pregolya-standard-tests/src/lib.rs"));
    assert!(!is_test_file("crates/pregolya-standard-tests/src/main.rs"));
    // Must NOT flag arbitrary files that happen to have "test" in a directory name
    // other than a `tests/` component.
    assert!(!is_test_file("crates/pregolya-core/src/latest.rs"));
}

// ── B-2 regression tests ─────────────────────────────────────────────────

/// B-2 regression: double-backslash before closing quote must not misflag.
#[test]
fn test_no_panic_double_backslash_before_quote() {
    let src = r#"
#[cfg(test)]
mod tests { const P: &str = "C:\\"; fn h() {} }
pub fn prod() -> i32 { let x: Option<i32> = Some(1); x.unwrap() }
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "double-backslash before closing quote must not latch test block; got: {findings:?}"
    );
}

/// B-2 regression: brace in char literal must not skew brace depth.
#[test]
fn test_no_panic_brace_in_char_literal() {
    let src = r#"
#[cfg(test)]
mod tests { let c = '{'; fn h() {} }
pub fn prod() -> i32 { let x: Option<i32> = Some(1); x.unwrap() }
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "brace in char literal must not skew depth; got: {findings:?}"
    );
}

/// B-2 regression: double-quote in char literal must not toggle string mode.
#[test]
fn test_no_panic_quote_in_char_literal() {
    let src = r#"
#[cfg(test)]
mod tests { let q = '"'; fn h() {} }
pub fn prod() -> i32 { let x: Option<i32> = Some(1); x.unwrap() }
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "double-quote in char literal must not latch test block; got: {findings:?}"
    );
}

// ── S-1 regression test ──────────────────────────────────────────────────

/// S-1 regression: Client::builder() stored in a variable (no .build() on same chain)
/// must not leave chain armed for later .build() calls on unrelated builders.
#[test]
fn test_timeout_scanner_builder_stored_in_var_does_not_leak() {
    let src = "let b = reqwest::Client::builder();\nlet g = other::Builder::new().build()?;\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        findings.is_empty(),
        "stored builder without .build() must not arm chain for next .build(); got: {findings:?}"
    );
}

// ── S-3 regression tests ─────────────────────────────────────────────────

/// S-3 regression: mcp_sdk::Client::new() must NOT be flagged.
#[test]
fn test_timeout_scanner_does_not_flag_non_reqwest_client_new() {
    let src = "let c = mcp_sdk::Client::new();\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        findings.is_empty(),
        "mcp_sdk::Client::new() must not be flagged; got: {findings:?}"
    );
}

/// S-3 positive: reqwest::Client::new() IS still flagged after S-3 fix.
#[test]
fn test_timeout_scanner_still_flags_reqwest_client_new() {
    let src = "let c = reqwest::Client::new();\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        !findings.is_empty(),
        "reqwest::Client::new() must still be flagged; got: {findings:?}"
    );
}

// ── B-3 / B-4 regression tests ───────────────────────────────────────────

/// B-3 regression: lifetime annotation 'a must NOT enter char-literal mode.
/// When in_char_literal is latched by a lifetime, brace counting breaks, which
/// can cause production .unwrap() to be missed or test-block suppression to misfire.
#[test]
fn test_no_panic_lifetime_annotation_does_not_latch_char_literal() {
    let src = r#"
pub fn foo<'a>(x: &'a str) -> i32 {
    let v: Vec<&'a str> = vec![];
    let _ = v;
    let opt: Option<i32> = Some(1);
    opt.unwrap()
}
"#;
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "lifetime annotation must not latch char-literal mode; got: {findings:?}"
    );
}

/// B-4 regression: unqualified Client::new() (from use import) must be flagged.
#[test]
fn test_timeout_scanner_flags_unqualified_client_new_from_import() {
    // Simulates: use reqwest::Client; ... Client::new()
    let src = "let c = Client::new();\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        !findings.is_empty(),
        "unqualified Client::new() (use reqwest::Client import) must be flagged; got: {findings:?}"
    );
}

/// B-4 negative: mcp_sdk::Client::new() must NOT be flagged.
#[test]
fn test_timeout_scanner_does_not_flag_mcp_client_new() {
    let src = "let c = mcp_sdk::Client::new();\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        findings.is_empty(),
        "mcp_sdk::Client::new() must not be flagged; got: {findings:?}"
    );
}

// ── B-5 regression tests ─────────────────────────────────────────────────

/// B-5 regression: OpenAiClient::new() must NOT be flagged.
#[test]
fn test_timeout_scanner_does_not_flag_openai_client_new() {
    let src = "let c = OpenAiClient::new();\n";
    let findings = scan_for_timeout_violations_in_source(src, "crates/pregolya-openai/src/lib.rs");
    assert!(
        findings.is_empty(),
        "OpenAiClient::new() must not be flagged; got: {findings:?}"
    );
}

/// B-5 regression: AnthropicClient::new() must NOT be flagged.
#[test]
fn test_timeout_scanner_does_not_flag_anthropic_client_new() {
    let src = "let c = AnthropicClient::new();\n";
    let findings =
        scan_for_timeout_violations_in_source(src, "crates/pregolya-anthropic/src/lib.rs");
    assert!(
        findings.is_empty(),
        "AnthropicClient::new() must not be flagged; got: {findings:?}"
    );
}

// ── B-6 regression tests ─────────────────────────────────────────────────

/// B-6 regression: #[cfg(test)] in a // comment must NOT latch test suppression.
#[test]
fn test_no_panic_cfg_test_in_comment_does_not_latch() {
    let src = "// #[cfg(test)]\npub fn prod() { let x: Option<i32> = Some(1); x.unwrap() }\n";
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "cfg(test) in comment must not suppress production code; got: {findings:?}"
    );
}

/// B-6 regression: braces in // comments must NOT skew brace_depth.
#[test]
fn test_no_panic_braces_in_comment_do_not_skew_depth() {
    let src = "#[cfg(test)]\nmod tests {\n    // }\n}\npub fn prod() { let x: Option<i32> = Some(1); x.unwrap() }\n";
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "brace in comment must not skew depth; got: {findings:?}"
    );
}

// ── B-7 regression test ──────────────────────────────────────────────────

/// B-7 regression: multi-byte UTF-8 chars BEFORE `//` must not cause the `//`
/// comment boundary to be missed due to byte/char index divergence.
///
/// Pre-fix string scanners used `line.as_bytes().get(char_index + 1)` to check
/// for `//`. The byte-index/char-index drift must exceed the two-char `//` width
/// for the boundary check to be missed: with drift ≤ 1 the lookahead window lands
/// on the first `/`; with drift = 2 it lands on the second `/` (one char late but
/// still fires a break before the comment body); only with drift ≥ 3 does the
/// window slide past both `/` chars so `bytes[i+1]` never sees either slash and
/// the break never fires. `h_réésumé` has **three** multi-byte `é` chars before
/// the `//` — drift = 3 — so the pre-fix check misses the comment boundary,
/// the `{ brace_in_comment` is processed as structural code, brace depth is
/// inflated by 1, the test-block close does not fire at the right depth, and the
/// production `.unwrap()` is suppressed (false negative).
///
/// The proc_macro2 scanner is immune: comments are stripped at tokenisation,
/// so no `{` from comment text is ever seen by the walker.
#[test]
fn test_no_panic_non_ascii_line_does_not_corrupt_depth() {
    // Three multi-byte `é` chars before `//` → drift = 3, which exceeds the
    // two-char `//` width. The pre-fix byte-indexed lookahead slides past both
    // slash chars, the comment `{ brace` corrupts brace depth, and the production
    // `.unwrap()` is suppressed. The proc_macro2 scanner handles it correctly.
    let src = "#[cfg(test)]\nmod tests {\n    fn h_réésumé() {} // { brace_in_comment\n}\npub fn prod() { let x: Option<i32> = Some(1); x.unwrap() }\n";
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "non-ASCII before // must not cause comment boundary miss; got: {findings:?}"
    );
}

// ── B-8 regression test ──────────────────────────────────────────────────

/// B-8 regression: #[cfg(test)] use statement must NOT latch test suppression.
/// A semicolon-terminated attribute form has no following brace block; the
/// production `.unwrap()` on the next line must still be reported.
#[test]
fn test_no_panic_cfg_test_use_statement_does_not_latch() {
    let src = "#[cfg(test)] use super::SomeType;\npub fn prod() { let x: Option<i32> = Some(1); x.unwrap() }\n";
    let findings = scan_for_panics_in_source(src, "src/lib.rs");
    assert!(
        !findings.is_empty(),
        "cfg(test) use stmt must not latch pending_cfg_test; got: {findings:?}"
    );
}

// ── MED-1 lex-failure propagation tests ──────────────────────────────────

/// MED-1: An unparseable source file must produce a non-empty findings vec
/// (containing a FAILED TO LEX FILE message) rather than silently returning
/// an empty vec.  Before the fix, `Err(_) => return Vec::new()` caused the
/// scanner to treat all lex errors as "no violations found" — a false
/// negative that hid corrupt files from CI.
#[test]
fn test_no_panic_lex_error_propagates_as_finding() {
    // An unclosed string literal is unparseable by proc_macro2.
    let src = "fn foo() { let s = \"unclosed string; }";
    let findings = scan_for_panics_in_source(src, "src/foo.rs");
    assert!(
        !findings.is_empty(),
        "lex error must produce a finding, not a silent empty vec; got: {findings:?}"
    );
    assert!(
        findings[0].contains("FAILED TO LEX FILE"),
        "finding must contain 'FAILED TO LEX FILE'; got: {}",
        findings[0]
    );
}

#[test]
fn test_timeout_lex_error_propagates_as_finding() {
    // An unclosed string literal is unparseable by proc_macro2.
    let src = "fn foo() { let s = \"unclosed string; }";
    let findings = scan_for_timeout_violations_in_source(src, "src/foo.rs");
    assert!(
        !findings.is_empty(),
        "lex error must produce a finding in timeout scanner, not a silent empty vec; got: {findings:?}"
    );
    assert!(
        findings[0].contains("FAILED TO LEX FILE"),
        "finding must contain 'FAILED TO LEX FILE'; got: {}",
        findings[0]
    );
}
