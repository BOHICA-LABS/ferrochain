---
document_type: behavioral-contract
level: L3
bc_id: BC-2.24.001
version: "1.1"
status: draft
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-24
capability: CAP-041
crate: pregolya-console
wave: 3
phase: 1b
producer: product-owner
timestamp: 2026-09-06T00:00:00Z
di_anchors: [DI-014]
vp_seed: false
red_gate: false
changelog:
  - "1.1 (D-356-fix/DC-07/2026-09-07, product-owner): F-PDC07-01: INV-003 corrected — SecurityConfig field name debug_api_key→debug_route_key (canonical field per BC-2.12.005 PRE-004/PC-006/PC-007/INV-001; ADR-021 §Decision 1; E-SERVER-013 InvalidDebugRouteKey)."
  - "1.0 (D-356/2026-09-06, product-owner): Initial BC — D-356 dev-console scope expansion. pregolya-console startup, ConsoleConfig, run_console entry point, CLI subcommand, SPA asset serving, runtime-config.json injection."
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-041
  - architecture/decisions/ADR-031-developer-console-architecture.md
inputs:
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/planning/devconsole-adk-research.md
input-hash: "0493743"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.24.001: `pregolya-console` Startup, Asset Serving, and `ConsoleConfig` (CAP-041)

> **D-356 dev-console scope expansion (2026-09-06, product-owner).** Roadmap-only.
> Not built in the current cycle — spec and storyboard only. Build in Wave 3.

> **D-356 adversary fix DC-07 (2026-09-07, product-owner).** F-PDC07-01: INV-003 corrected — `SecurityConfig.debug_api_key` → `SecurityConfig.debug_route_key`. `debug_route_key: Option<String>` is the canonical SecurityConfig gate field (BC-2.12.005 PRE-004/PC-006/PC-007/INV-001; ADR-021 §Decision 1).

## Description

`pregolya-console` is a binary crate that hosts the developer console web SPA. It binds to
`127.0.0.1:7437` by default, embeds the compiled SPA via `rust_embed` and serves it under
`/ui/`, injects `runtime-config.json` so the SPA resolves the backend API, and in `--dev`
mode co-launches an in-process `pregolya-server`. The crate's entry point is
`run_console(config: ConsoleConfig) -> Result<(), PregolyaError>`. The console drives the
engine exclusively via the public REST+SSE wire contract — it never reaches into engine
internals or imports from `pregolya-graph` crate-private modules.

## Preconditions

1. {PRE-001} `ConsoleConfig` is fully constructed with valid values:
   - `host`: a parseable socket address (default `127.0.0.1`).
   - `port`: a valid port number, default `7437`.
   - `dev_mode: bool` — when `true`, co-launches an in-process `pregolya-server` on the same address/port.
   - `span_retention_cap: usize` — default `10_000`; must be `> 0` for `DebugSpanExporter` allocation.
2. {PRE-002} The compiled web SPA artifact is embedded in the binary via `rust_embed` `#[folder = "assets/webui"]` at build time.
3. {PRE-003} When `dev_mode = true`, a valid `pregolya-server` configuration is available for co-launch (in-process server uses the same `host`/`port`).
4. {PRE-004} The specified `host:port` is available (not already bound by another process).

## Postconditions

1. {PC-001} **Axum listener bound:** `run_console` binds the Axum HTTP server to `<host>:<port>` and begins accepting connections. For default config: `127.0.0.1:7437`.
2. {PC-002} **SPA served at `/ui/`:** All `GET /ui/*` requests are served from the embedded SPA assets. Requests to unknown SPA routes fall back to `index.html` (client-side routing). Status: 200 OK with correct `Content-Type`.
3. {PC-003} **`runtime-config.json` injected:** `GET /ui/assets/config/runtime-config.json` returns `{"apiBaseUrl": "/api"}` so the SPA resolves the pregolya-server API relative to the same host. Content-Type: `application/json`.
4. {PC-004} **Dev mode co-launch:** When `dev_mode = true`, the pregolya-server `/api/*` routes are merged into the same Axum router as `/ui/*`. Both SPA assets and server API are served from the single `<host>:<port>` listener. `POST /api/shutdown` (dev-only endpoint from pregolya-server) is available.
5. {PC-005} **`DebugSpanExporter` instantiated:** When `dev_mode = true`, a `DebugSpanExporter` (ring buffer of `span_retention_cap` spans) is instantiated and injected into the co-launched pregolya-server as its configured OTel span exporter (used by BC-2.24.002 debug trace endpoints). In standalone mode (`dev_mode = false`), `DebugSpanExporter` is not instantiated by this crate (it is the operator's responsibility to inject one into a separately running pregolya-server).
6. {PC-006} **Clean shutdown:** On SIGTERM/SIGINT, `run_console` completes in-flight requests and returns `Ok(())`. On bind error or co-launch failure, returns `Err(PregolyaError)` with a structured error — not a panic, not an `unwrap()`.
7. {PC-007} **`pregolya console` subcommand:** The `pregolya` CLI facade crate exposes `pregolya console [--host <host>] [--port <port>] [--dev]` as a subcommand. The subcommand constructs `ConsoleConfig` from CLI flags and calls `run_console(config)`.

## Invariants

- {INV-001} **Dependency boundary (ADR-031 Decision 1):** `pregolya-console` MUST NOT import from `pregolya-graph` internals, executor internals, or any crate-private module. It drives the engine exclusively through the public pregolya-server REST+SSE contract. This is enforced at the `Cargo.toml` level — `pregolya-console` depends on `pregolya-server` (public API) but not on `pregolya-graph` directly.
- {INV-002} **TLS exception (ADR-031 Decision 6):** Loopback bind (`127.0.0.1`) does not require TLS. If the operator changes `host` to a non-loopback address, TLS is the operator's responsibility (unsupported in v1). The console does not enforce or validate this.
- {INV-003} **No auth on `/ui/` routes:** Asset routes under `/ui/` have no auth layer. The loopback bind is the security boundary per ADR-031 Decision 6. `SecurityConfig.debug_route_key` governs `/debug/*` endpoints when co-launched (BC-2.12.005).
- {INV-004} **`ConsoleConfig` is `#[non_exhaustive]`:** `ConsoleConfig` is a public API-surface type and MUST be annotated `#[non_exhaustive]` per workspace conventions.
- {INV-005} **No `println!` in `console::server`:** `console::server` and `console::span_exporter` use `tracing::*!` for structured logging. Only `main.rs` / CLI entrypoint may emit `println!` for port announcement output.
- {INV-006} **DI-014:** Startup errors propagate via `Err(PregolyaError)` — no silent swallowing, no `unwrap()`, no `expect()` in non-test code paths.

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| {EC-001} | Port already bound by another process | `run_console` returns `Err(PregolyaError)` with descriptive bind-error message; process exits with a non-zero status code; does not panic |
| {EC-002} | `span_retention_cap = 0` | `run_console` returns `Err(PregolyaError)` (VAL — zero-cap ring buffer is nonsensical); no server started |
| {EC-003} | `dev_mode = true` but pregolya-server co-launch fails (port conflict, config error) | `run_console` returns `Err(PregolyaError)` with co-launch error; no partial state left |
| {EC-004} | SPA asset not embedded (build artifact missing `assets/webui/`) | Compile-time failure (`rust_embed` panics at build time if `#[folder]` path is empty/missing); visible before runtime |
| {EC-005} | SPA requests a path not in the embedded asset set | Fallback serves `index.html` (client-side routing); response is 200 OK |
| {EC-006} | `GET /ui/assets/config/runtime-config.json` requested before server is fully ready | Standard TCP accept queue behavior; accepted only after `bind()` completes; no partial-response risk |

## Canonical Test Vectors

| # | Input | Expected Output | Category |
|---|-------|-----------------|----------|
| TV-001 | `ConsoleConfig { host: "127.0.0.1", port: 7437, dev_mode: false, span_retention_cap: 10_000 }` | Server binds; `GET /ui/` returns 200 with HTML; `GET /ui/assets/config/runtime-config.json` returns `{"apiBaseUrl": "/api"}`; no `/api/*` routes available | happy-path, standalone |
| TV-002 | `ConsoleConfig { dev_mode: true, ... }` | Server binds; `/api/*` routes available (co-launched server); `GET /api/threads` returns valid JSON response | happy-path, dev-mode |
| TV-003 | `ConsoleConfig { span_retention_cap: 0, ... }` | `run_console` returns `Err(PregolyaError)` before binding; no server started | EC-002, validation |
| TV-004 | `pregolya console --dev` CLI invocation | `ConsoleConfig { dev_mode: true, host: "127.0.0.1", port: 7437, span_retention_cap: 10_000 }` constructed from defaults; subcommand calls `run_console` | CLI subcommand |
| TV-005 | SPA request to `/ui/some/deep/route` | Response 200 OK with `index.html` content (SPA fallback routing) | EC-005, SPA routing |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.24.001-A | `runtime-config.json` always contains `{"apiBaseUrl": "/api"}` | Unit test: assert response body of `GET /ui/assets/config/runtime-config.json` |
| VP-2.24.001-B | `span_retention_cap = 0` rejected before bind | Unit test: assert `run_console` returns Err on zero cap |
| VP-2.24.001-C | `ConsoleConfig` is `#[non_exhaustive]` | Compile-fail test: external match arm without wildcard fails to compile |

## Related BCs

- BC-2.24.002 — composes with: `DebugSpanExporter` ring buffer instantiated in dev-mode (this BC) is the data source for trace-read endpoints (BC-2.24.002)
- BC-2.24.003 — depends on: graph-descriptor endpoint in pregolya-server (BC-2.24.003) is available via the co-launched server in dev-mode
- BC-2.12.007 — depends on: SSE streaming endpoint consumed by the SPA (public contract)

## Architecture Anchors

- `architecture/decisions/ADR-031-developer-console-architecture.md` — Decision 1 (`pregolya-console` crate), Decision 5 (purity boundary: `console::server` Effectful Shell, `console::span_exporter` Boundary), Decision 6 (NFR/security deltas)
- `architecture/ARCH-INDEX.md` — SS-24 entry

## Story Anchor

S-console-01 (Wave 3 — pregolya-console crate init)

## VP Anchors

- VP-2.24.001-A
- VP-2.24.001-B
- VP-2.24.001-C

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-041 |
| Capability Anchor Justification | CAP-041 ("Developer Console Composition Layer (`pregolya-console` Crate)") per capabilities-p1-p2.md §CAP-041 — this BC specifies the startup, `ConsoleConfig`, CLI subcommand, SPA asset serving, and `runtime-config.json` injection that constitute the composition layer described in CAP-041 |
| L2 Domain Invariants | DI-014 (Error Propagation — startup errors propagate via Err; no silent swallowing, no unwrap) |
| Architecture Authority | ADR-031 Decision 1 (pregolya-console crate responsibilities), Decision 6 (NFR/security deltas: localhost-bind, no TLS required, no auth on /ui/) |
| Binding Decisions | D-356 (developer console scope expansion, 2026-09-06) |
| VP Registration | VP-2.24.001-A/B/C |
| Module | pregolya-console / console::server (Effectful Shell) |
| Priority | P1 |
| Wave | 3 |
| Test Types | unit + integration |
