# pregolya task runner — see CLAUDE.md §Build & Test for full recipe reference.
#
# Requires: just, cargo-nextest, tokei, cargo-deny, cargo-audit
# Optional: cargo-llvm-cov, cargo kani, cargo-fuzz, cargo-mutants, cargo-udeps

_default:
    @just --list

# Install all required external tools (run once after cloning)
setup:
    cargo install tokei@13.0.0 --locked
    cargo install cargo-deny@0.20.2 --locked
    cargo install cargo-audit@0.22.2 --locked
    cargo install cargo-nextest --locked

# TDD inner loop — single crate, fast iteration (~10-30s warm)
iter crate filter="":
    cargo nextest run -p {{crate}} --no-tests=warn {{ if filter != "" { "--filter-expr 'test(" + filter + ")'" } else { "" } }}

# Run all xtask lint gates (client-timeout, no-panic, anyhow-ban, cache-key-ban, file-size)
lint-extra:
    cargo xtask check-file-size
    cargo xtask check-client-timeout
    cargo xtask check-no-panic
    cargo xtask deny-anyhow-in-lib
    cargo xtask deny-description-cache-key

# Pre-push gate — full strict workspace check
check:
    cargo fmt --all --check
    cargo clippy --workspace --all-targets --all-features -- -D warnings
    cargo nextest run --workspace --all-features --no-tests=warn
    cargo test --workspace --doc
    just lint-extra

# Clippy + layout only (no tests; for refactor sweeps)
check-fast:
    cargo clippy --workspace --all-targets --all-features -- -D warnings
    cargo xtask check-file-size

# CI-equivalent local run
check-ci:
    cargo fmt --all --check
    cargo clippy --workspace --all-targets --all-features -- -D warnings
    cargo nextest run --workspace --all-features --no-tests=warn
    cargo test --workspace --doc
    just lint-extra
    cargo deny check
    cargo audit
    cargo semver-checks

# clippy with -D warnings
clippy:
    cargo clippy --workspace --all-targets --all-features -- -D warnings

# cargo fmt --all
fmt:
    cargo fmt --all

# coverage via cargo-llvm-cov
cov:
    cargo llvm-cov --workspace

# Kani formal verification proofs
kani-local:
    cargo kani --workspace

# cargo-fuzz target
fuzz-local crate target:
    cargo fuzz run -p {{crate}} {{target}} -- -max_total_time=300

# mutation testing
mutants:
    cargo mutants --workspace

# unused-dep detection (requires nightly)
udeps:
    cargo +nightly udeps --workspace
