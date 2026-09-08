---
document_type: story
level: ops
story_id: S-console-05
epic_id: E-console
version: "1.3"
status: draft
producer: story-writer
timestamp: 2026-09-06T00:00:00Z
changelog:
  - "1.0 (D-356/2026-09-06, story-writer): Initial story — SPA build pipeline, framework selection (deferred per ADR-031 Decision 4), bundler config, rust_embed binding, CI integration, <500KB gzip target."
  - "1.1 (D-356/2026-09-07, story-writer): Adversary fix DC-06 sweep — remove VP-2.24.001-A from verification_properties; VP-2.24.001-A anchors to S-console-01 (console server lifecycle unit test) per VP-INDEX; S-console-05 SPA build coverage is AC-level only (AC-002 test_BC_2_24_001_spa_index_present_in_bundle traces to BC-2.24.001 PC-002); no registered VP warranted for a bundle-presence AC check."
  - "1.2 (D-356/DC-27/L-288/2026-09-08, story-writer): F-L288-007 — AC-005 trace corrected from BC-2.24.001 INV-002 (TLS-loopback exception) to ADR-031 Decision 3 / BC-2.24.004 INV-002 (SSE-only transport; no WebSocket)."
  - "1.3 (D-356/DC-28/2026-09-08, story-writer): F-PDC28-01 — Token Budget table backfilled with BC-2.24.004.md row (~300 tokens); total updated to ~8,400 (POL-8 step 4: Token Budget BC count matches len(bcs))."
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.001.md
  - .factory/specs/behavioral-contracts/ss-24/BC-2.24.004.md
  - .factory/specs/architecture/decisions/ADR-031-developer-console-architecture.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "a675a8d"
traces_to: .factory/stories/STORY-INDEX.md
points: 8
depends_on: [S-console-01]
blocks: [S-console-06, S-console-07]
behavioral_contracts: [BC-2.24.001, BC-2.24.004]
verification_properties: []
priority: P1
cycle: v1.0.0-greenfield
wave: 3
target_module: pregolya-console
subsystems: [SS-24]
estimated_days: 3
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-console-05: Web SPA Build Pipeline

> **D-356 dev-console scope expansion (2026-09-06, story-writer).** Roadmap-only.
> Wave 3 — not built in the current Phase 3 implementation cycle.

> **D-356 adversary fix DC-06 sweep (2026-09-07, story-writer).** VP-2.24.001-A removed from `verification_properties` (`[]` is now correct). VP-2.24.001-A anchors to S-console-01 per VP-INDEX (console server lifecycle unit test built by the scaffold story). S-console-05 SPA build pipeline coverage is AC-level: AC-002 (`test_BC_2_24_001_spa_index_present_in_bundle`) is an acceptance-criterion test tracing to BC-2.24.001 PC-002, not a separately-registered VP. No new VP minted; `[]` is the correct scoping. No body references to VP-2.24.001-A were present; POLICY-8 gate remains satisfied.

> **D-356 adversary fix DC-27/L-288 (2026-09-08, story-writer).** F-L288-007 — AC-005 trace annotation corrected. The INV-002 clause in the console startup behavioral contract is the TLS-loopback exception, not the SSE-only rule. The SSE-only transport mandate is Decision 3 in the console architecture ADR, reflected in the run inspection event-timeline behavioral contract's SSE-only invariant. AC-005 trace and body BC table updated accordingly.

> **D-356 adversary fix DC-28 (2026-09-08, story-writer).** F-PDC28-01 — Token Budget Estimate table backfilled with run-inspection event-timeline behavioral contract row (~300 tokens, INV-002 SSE-only clause). Total updated from ~8,100 to ~8,400. POL-8 step 4: Token Budget BC count now matches `len(behavioral_contracts)` = 2.

## Narrative

- **As a** developer implementing the pregolya console frontend
- **I want to** have a reproducible SPA build pipeline that produces a static bundle embeddable via `rust_embed`
- **So that** the `pregolya-console` binary can embed the compiled SPA at build time and serve it without an external static file server

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.24.001 | `pregolya-console` Startup, Asset Serving, and `ConsoleConfig` (CAP-041) | AC-001..AC-006 (SPA asset preconditions) |
| BC-2.24.004 | Run Inspection Event Timeline and Live Monitoring Panel (CAP-043) | AC-005 (SSE-only transport invariant) |

## Acceptance Criteria

### AC-001 (traces to BC-2.24.001 precondition PRE-002)
The compiled web SPA artifact is embedded in the `pregolya-console` binary via `rust_embed` `#[folder = "assets/webui"]` at build time. The `assets/webui/` directory contains `index.html`, at minimum one JavaScript bundle file, and the `runtime-config.json` handler path is reserved. Running `cargo build -p pregolya-console` with an empty `assets/webui/` fails at compile time (rust_embed enforces folder non-empty). Verified by build integration test.

### AC-002 (traces to BC-2.24.001 postcondition PC-002)
The SPA build output satisfies the client-side routing contract: a single `index.html` is the entry point, and all routes are handled client-side (the HTML file is returned for any `/ui/*` path, consistent with the SPA fallback in S-console-01 AC-003). The build tool generates `index.html` as a root asset. Verified by `test_BC_2_24_001_spa_index_present_in_bundle()`.

### AC-003 (traces to BC-2.24.001 postcondition PC-003)
After SPA build, `assets/webui/assets/config/runtime-config.json` does NOT override the server-injected config. The SPA reads `runtime-config.json` from the URL path `/ui/assets/config/runtime-config.json` at runtime. The build pipeline must NOT embed a static `runtime-config.json` at a path that would shadow the server-injected version. Verified by asserting the build output does not contain a conflicting `runtime-config.json` at the expected static path.

### AC-004 (traces to BC-2.24.001 invariant INV-001)
The SPA imports NO symbols from `pregolya-graph`, `pregolya-server`, or any Rust crate internal. The SPA is a pure REST+SSE client of the public wire contract. This is enforced by the framework's module system: no Wasm bindings, no shared WASM modules, no crate imports. Verified by code review of SPA's `package.json`/import graph.

### AC-005 (per ADR-031 Decision 3 / traces to BC-2.24.004 INV-002 — SSE-only transport; no WebSocket)
The SPA build uses native browser `EventSource` for SSE — no WebSocket polyfill or client library is included. The SPA bundle does NOT contain WebSocket client code. Verified by `grep -r "WebSocket" src/` on SPA source returns zero matches; bundle analysis confirms no WebSocket dependency.

### AC-006 (traces to BC-2.24.001 postcondition PC-002)
The gzip-compressed total bundle size is < 500 KB. `gzip -c dist/assets/*.js | wc -c` reports < 512000 bytes. This gate is enforced in CI as part of `just check-ci`. Verified by `check-spa-bundle-size` CI task.

## Architecture Mapping

| Component | Module | Pure/Effectful |
|-----------|--------|----------------|
| SPA source code | `crates/pregolya-console/spa/src/` | N/A (TypeScript/JS frontend) |
| Build tool config | `crates/pregolya-console/spa/vite.config.*` (or equivalent) | N/A (build tooling) |
| Build output | `crates/pregolya-console/assets/webui/` | N/A (static assets embedded at compile time) |
| `rust_embed` binding | `pregolya-console/src/console/server.rs` | Effectful Shell (compiles in embedded assets) |

## Purity Classification

| Module | Classification | Justification |
|--------|---------------|---------------|
| SPA source and bundle | N/A | TypeScript/JS; not subject to Rust pure/effectful classification |
| SPA at runtime | Pure consumer | REST+SSE client only; no server writes, no crate internals |

## Edge Cases

| ID | Scenario | Expected Behavior |
|----|----------|-------------------|
| EC-001 | `assets/webui/` empty at cargo build time | Compile-time failure from `rust_embed` |
| EC-002 | Bundle size exceeds 500 KB gzip | CI gate `check-spa-bundle-size` fails; build blocked |
| EC-003 | SPA imports a WebSocket library | CI review catches it; fails `grep -r "WebSocket"` check |
| EC-004 | Framework choice changed in Wave 3 planning | Binding constraints from ADR-031 Decision 4 apply regardless of framework; new framework must still satisfy all ACs |

## Token Budget Estimate (MANDATORY)

| Context Source | Estimated Tokens |
|----------------|-----------------|
| This story spec | ~3,500 |
| BC-2.24.001.md (PRE-002, asset-serving clauses) | ~1,500 |
| BC-2.24.004.md (INV-002 SSE-only clause) | ~300 |
| ADR-031 §Decision 4 (SPA constraints) | ~600 |
| SPA build config files (vite/webpack/rollup, ~100 lines) | ~1,200 |
| `package.json` + lockfile excerpts | ~500 |
| CI task additions (~30 lines Justfile) | ~400 |
| Tool outputs | ~400 |
| **Total** | **~8,400** |
| Agent context window | 200K (Sonnet) |
| **Budget usage** | **~4%** |

## Tasks (MANDATORY)

1. [ ] Select SPA framework at Wave 3 planning time per ADR-031 Decision 4 constraints (team decision; must support native `EventSource`, static bundle, no SSR, < 500 KB gzip)
2. [ ] Initialize SPA project in `crates/pregolya-console/spa/` with chosen framework + bundler (Vite preferred; ensures native ES module output compatible with `rust_embed`)
3. [ ] Configure bundler output directory to `../assets/webui/` (relative to SPA project root)
4. [ ] Remove placeholder `assets/webui/index.html` from S-console-01; replace with real SPA `index.html` output
5. [ ] Verify `cargo build -p pregolya-console` embeds the real SPA bundle
6. [ ] Add `just spa-build` recipe in Justfile to run the SPA build step before `cargo build -p pregolya-console`
7. [ ] Add `check-spa-bundle-size` CI check: `gzip -c dist/assets/*.js | wc -c` < 512000
8. [ ] Add `grep -r "WebSocket" spa/src/` = 0 matches check to CI
9. [ ] Update `just check` to run `spa-build` before `cargo build`
10. [ ] Verify `cargo nextest run -p pregolya-console` — SPA asset tests from S-console-01 (AC-003, AC-004) pass with real bundle

## Previous Story Intelligence (MANDATORY)

Predecessor: S-console-01 (pregolya-console crate scaffolding). S-console-01 created a placeholder `assets/webui/index.html`. This story replaces that placeholder with the real SPA build output. The `rust_embed` binding is already wired; the SPA build pipeline feeds into it. Coordinate with ADR-031 Decision 4 framework selection.

## Architecture Compliance Rules (MANDATORY)

| Rule | Source | Enforcement |
|------|--------|-------------|
| Bundle < 500 KB gzip | ADR-031 Decision 4 | CI `check-spa-bundle-size` |
| No WebSocket in SPA | ADR-031 Decision 3, Decision 4 | CI grep check |
| No SSR — pure client-side SPA | ADR-031 Decision 4 | Code review; bundler config |
| SPA does not import Rust crate internals | BC-2.24.001 INV-001 | `package.json` import graph review |
| Native `EventSource` used for SSE (no polyfill) | ADR-031 Decision 3, Decision 4 | Bundle analysis; `grep -r "EventSource\|eventsource"` confirms native usage |
| Static bundle embeddable via `rust_embed` `#[folder]` | BC-2.24.001 PRE-002 | `cargo build -p pregolya-console` succeeds with real bundle |

**Forbidden in SPA bundle:** WebSocket client libraries (`ws`, `socket.io-client`, `reconnecting-websocket`), Wasm bindings to pregolya crates, server-side rendering framework features, `runtime-config.json` at a path that shadows the server-injected version.

## Library & Framework Requirements (MANDATORY)

| Tool | Version | Purpose |
|------|---------|---------|
| Framework (TBD at Wave 3) | Latest stable at Wave 3 | SPA UI framework — must satisfy ADR-031 Decision 4 constraints |
| Vite (or equivalent bundler) | Latest stable at Wave 3 | Build tool producing static `HTML + JS + CSS` embeddable by `rust_embed` |
| Node.js | LTS at Wave 3 | SPA build toolchain |
| TypeScript | Latest stable at Wave 3 | Type-safe SPA implementation |

## File Structure Requirements (MANDATORY)

| File | Action | Purpose |
|------|--------|---------|
| `crates/pregolya-console/spa/` | CREATE (directory) | SPA project root (framework source) |
| `crates/pregolya-console/spa/package.json` | CREATE | SPA dependencies |
| `crates/pregolya-console/spa/src/main.ts` | CREATE | SPA entry point |
| `crates/pregolya-console/assets/webui/` | REPLACE | Replace placeholder with real SPA build output |
| `Justfile` | MODIFY | Add `spa-build` recipe; update `check` and `check-ci` to include SPA build step |
| `.gitignore` | MODIFY | Exclude `crates/pregolya-console/assets/webui/` from git (generated by build); keep placeholder `index.html` |
