---
document_type: story
level: ops
story_id: S-console-01
epic_id: E-console
version: "1.3"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — pregolya-console crate scaffolding, ConsoleConfig, CLI subcommand, rust_embed SPA serving, runtime-config.json, localhost :7437."
  - "1.1 (D-356/DC-12/2026-09-07, story-writer): F-PDC12-01 — blocks list updated to include S-console-03 (invariant: blocks is exact inverse of depends_on; S-console-03 declares depends_on [S-console-01])."
  - "1.2 (D-356/DC-46/2026-09-09, story-writer): F-PDC46-01 — AC header citation form corrected to M4-strict bare-tag: BC-S.SS.NNN TAG (section-words removed per verify-ac-pc-trace.sh CHECK-1)."
  - "1.3 (D-356/DC-50/2026-09-09, story-writer): F-PDC50-02 — File Structure: added MODIFY row for crates/pregolya/Cargo.toml (add pregolya-console path dependency under [dependencies] — compile-time dep required for cli/console.rs to call pregolya_console::run_console())."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.001.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "1aea225"
traces_to: .factory/stories/STORY-INDEX.md
points: 5
depends_on: []
blocks: [S-console-02, S-console-03, S-console-05]
behavioral_contracts: [BC-2.24.001]
verification_properties: [VP-2.24.001-A, VP-2.24.001-B, VP-2.24.001-C]
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24]
estimated_days: 2
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-01: `pregolya-console` Crate Scaffolding

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

## Narrative

- **As a** developer using the pregolya framework
- **I want to** run `pregolya console` and have the developer console SPA available at `http://127.0.0.1:7437/ui/`
- **So that** I have a single-command entry point for the local developer console, analogous to `adk web` or `langgraph dev`, without needing to manage a separate SPA server

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.001 | `pregolya-console` Startup, Asset Serving, and `ConsoleConfig` (CAP-041) | AC-001..AC-009 |

Note: BC-2.24.001 postconditions PC-004 and PC-005 (dev-mode co-launch + DebugSpanExporter instantiation) are covered by S-console-02, which depends on this story.

## Acceptance Criteria

### AC-001 (traces to BC-2.24.001 PC-007)
The `pregolya` CLI facade crate exposes `pregolya console [--host <H>] [--port <P>] [--dev]` as a subcommand. Invoking `pregolya console` with no flags constructs `ConsoleConfig { host: "127.0.0.1", port: 7437, dev_mode: false, span_retention_cap: 10_000 }` and calls `run_console(config)`. Each flag overrides the corresponding default. Verified by `test_BC_2_24_001_cli_defaults()` and `test_BC_2_24_001_cli_flags()`.

### AC-002 (traces to BC-2.24.001 PC-001)
`run_console(config)` binds an Axum HTTP server to `<config.host>:<config.port>` and begins accepting connections. The default bind address is `127.0.0.1:7437`. `run_console` is an `async fn` accepting a `ConsoleConfig`. Verified by `test_BC_2_24_001_bind_default_address()`.

### AC-003 (traces to BC-2.24.001 PC-002)
`GET /ui/` returns `200 OK` with `Content-Type: text/html` serving the embedded SPA `index.html`. `GET /ui/some/deep/nested/route` falls back to `index.html` with `200 OK` (client-side SPA routing). `GET /ui/app.js` returns the embedded script asset with the correct `Content-Type`. Verified by `test_BC_2_24_001_spa_served()` and `test_BC_2_24_001_spa_fallback_index()`.

### AC-004 (traces to BC-2.24.001 PC-003)
`GET /ui/assets/config/runtime-config.json` returns `200 OK` with body `{"apiBaseUrl": "/api"}` and `Content-Type: application/json`. The body is static and does not vary with runtime state. Verified by `test_BC_2_24_001_runtime_config_json()` (VP-2.24.001-A).

### AC-005 (traces to BC-2.24.001 PC-006)
On receipt of `SIGTERM` or `SIGINT`, `run_console` gracefully completes in-flight requests and returns `Ok(())`. When the bind address is already in use, `run_console` returns `Err(PregolyaError)` with a descriptive message before starting the server — no panic, no `unwrap()`. Verified by `test_BC_2_24_001_port_conflict_err()`.

### AC-006 (traces to BC-2.24.001 EC-002)
`run_console(ConsoleConfig { span_retention_cap: 0, .. })` returns `Err(PregolyaError)` immediately, before attempting to bind the socket. No server is started. Verified by `test_BC_2_24_001_zero_cap_err()` (VP-2.24.001-B).

### AC-007 (traces to BC-2.24.001 INV-004)
`ConsoleConfig` carries `#[non_exhaustive]`. A compile-fail test in `tests/external/console-config-non-exhaustive/` confirms that external code attempting to construct `ConsoleConfig { .. }` as a struct literal fails to compile. Verified by compile-fail test (VP-2.24.001-C).

### AC-008 (traces to BC-2.24.001 INV-001)
The `pregolya-console/Cargo.toml` dependency list does NOT include `pregolya-graph` as a direct dependency. `cargo tree -p pregolya-console --depth 1` does not show `pregolya-graph` as a first-level dependency. The console depends on `pregolya-server` (public API only). Verified by CI `check-console-dep-boundary` task.

### AC-009 (traces to BC-2.24.001 INV-005)
`console::server` and all `pregolya-console` library modules use `tracing::*!` macros exclusively for logging — no `println!` or `eprintln!` in library code. `cargo clippy -p pregolya-console -D clippy::print_stdout -D clippy::print_stderr` passes with zero warnings. Verified by CI clippy gate.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| `ConsoleConfig` struct | `pregolya-console/src/lib.rs` | Pure Core (plain data) |
| `run_console` entry point | `pregolya-console/src/lib.rs` | Effectful Shell (async, network I/O) |
| Axum server + asset router | `pregolya-console/src/console/server.rs` | Effectful Shell |
| `runtime-config.json` handler | `pregolya-console/src/console/server.rs` | Effectful Shell |
| `pregolya console` CLI subcommand | `crates/pregolya/src/cli/console.rs` | Effectful Shell |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| `ConsoleConfig` struct | Pure Core | Plain data, no I/O, deterministic construction |
| `console::server` | Effectful Shell | Binds network socket, performs async I/O, manages process lifecycle |
| CLI argument parsing | Effectful Shell | Reads `std::env::args`, interacts with OS |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | Port already bound | `run_console` returns `Err(PregolyaError)` with bind-error message; no panic |
| EC-002 | `span_retention_cap = 0` | `run_console` returns `Err(PregolyaError)` before bind; no server started |
| EC-003 | SPA asset directory empty at build time | Compile-time failure from `rust_embed` — visible before runtime |
| EC-004 | Unknown SPA route requested | Fallback serves `index.html`; `200 OK` |
| EC-005 | `GET /ui/assets/config/runtime-config.json` requested before server fully bound | Standard TCP accept queue; no partial response |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~4,000 |
| BC-2.24.001.md (~150 lines) | ~2,500 |
| ADR-031 §Decision 1 (~60 lines) | ~1,000 |
| `module-decomposition.md` (SS-24 section) | ~500 |
| `pregolya-console/src/lib.rs` + `server.rs` (to create, ~200 code lines) | ~2,500 |
| CLI subcommand `cli/console.rs` (~60 lines) | ~800 |
| Test module (~120 lines) | ~1,500 |
| Tool outputs (cargo check, nextest) | ~500 |
| **Total** | **~13,300** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~7%** |

## Tasks (MANDATORY)

1. [ ] Write failing tests for all ACs — `test_BC_2_24_001_*` family (test-writer)
2. [ ] Verify Red Gate — `cargo nextest run -p pregolya-console` shows all new tests as failures (Red Gate ≥ 0.5)
3. [ ] Add `"crates/pregolya-console"` to workspace `Cargo.toml` `members` list
4. [ ] Create `crates/pregolya-console/Cargo.toml` — binary crate; deps: `axum`, `tokio`, `rust_embed`, `tower-http`, `tracing`, `pregolya-core`
5. [ ] Scaffold `ConsoleConfig` with `#[non_exhaustive]` in `pregolya-console/src/lib.rs`
6. [ ] Implement `run_console` — Axum bind, `/ui/` asset routes with `rust_embed`, `/ui/assets/config/runtime-config.json` static handler, SPA fallback to `index.html`, `span_retention_cap = 0` guard
7. [ ] Add `#[folder = "assets/webui"]` `rust_embed` struct; create placeholder `assets/webui/index.html`
8. [ ] Wire `pregolya console` subcommand into the `pregolya` facade CLI
9. [ ] Add compile-fail test in `tests/external/console-config-non-exhaustive/`
10. [ ] Run `cargo xtask check-file-size` — confirm `server.rs` < 500 code lines
11. [ ] Run `cargo clippy -p pregolya-console -D warnings -D clippy::print_stdout` — zero warnings
12. [ ] Final `cargo nextest run -p pregolya-console` — all AC tests pass

## Previous Story Intelligence (MANDATORY)

N/A — S-console-01 is the root story in the E-console epic. No predecessor within this epic. Follow the existing `pregolya` CLI facade crate subcommand pattern already established in the workspace for adding new subcommands.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| `ConsoleConfig` is `#[non_exhaustive]` | BC-2.24.001 INV-004, CLAUDE.md | Compile-fail test in external test crate |
| `pregolya-console` MUST NOT depend on `pregolya-graph` directly | BC-2.24.001 INV-001, ADR-031 Decision 1 | `cargo tree -p pregolya-console --depth 1` |
| No `println!` / `eprintln!` in library modules | BC-2.24.001 INV-005, CLAUDE.md | `cargo clippy -D clippy::print_stdout` |
| No `unwrap()` / `expect()` in non-test code | CLAUDE.md, BC-2.24.001 INV-006 | `cargo xtask check-no-panic -p pregolya-console` |
| Default bind is loopback `127.0.0.1` | ADR-031 Decision 6 (D6-1) | Unit test asserting default host value |
| Tokio multi-threaded runtime | CLAUDE.md | `#[tokio::main]` with default multi-threaded runtime |
| No `reqwest` in `pregolya-console` | ADR-031 Decision 6 (D6-5) | `cargo tree` — reqwest absent |

**Forbidden dependencies for `pregolya-console`:** `pregolya-graph`, `pregolya-checkpoint` internals. Console is a server + SPA host, not a business logic executor.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| `axum` | workspace pin | HTTP server for asset serving and route composition |
| `tokio` | workspace pin | Async runtime (multi-threaded per CLAUDE.md) |
| `rust_embed` | workspace pin | Embeds `assets/webui/` into binary at build time |
| `tower-http` | workspace pin | `ServeDir`/`ServeFile` for embedded SPA assets |
| `tracing` | workspace pin | Structured logging in library modules |
| `pregolya-core` | path dep | `PregolyaError` type for error returns |
| `clap` | workspace pin | CLI argument parsing for `pregolya console` subcommand |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `Cargo.toml` (workspace root) | MODIFY | Add `"crates/pregolya-console"` to `members` |
| `crates/pregolya-console/Cargo.toml` | CREATE | Binary crate manifest |
| `crates/pregolya-console/src/lib.rs` | CREATE | `pub struct ConsoleConfig`, `pub async fn run_console` |
| `crates/pregolya-console/src/console/mod.rs` | CREATE | Re-export only (`pub use server::…`) |
| `crates/pregolya-console/src/console/server.rs` | CREATE | Axum router, asset handler, `runtime-config.json` handler |
| `crates/pregolya-console/src/main.rs` | CREATE | Binary entrypoint — `#[tokio::main]` |
| `crates/pregolya-console/assets/webui/index.html` | CREATE | Placeholder SPA scaffold (filled in S-console-05) |
| `crates/pregolya/src/cli/console.rs` | CREATE | `ConsoleArgs`, `fn run_console_subcommand` |
| `crates/pregolya/src/cli/mod.rs` | MODIFY | Register `console` subcommand variant |
| `crates/pregolya/Cargo.toml` | MODIFY | Add `pregolya-console = { path = "../pregolya-console" }` under `[dependencies]` — compile-time dep required for `cli/console.rs` to call `pregolya_console::run_console()` |
| `tests/external/console-config-non-exhaustive/` | CREATE | Compile-fail test for `ConsoleConfig` non-exhaustive |
