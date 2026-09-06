# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> **Toolchain:** Rust stable (pinned via `rust-toolchain.toml`, created at workspace init), edition 2024, resolver 2. Single Cargo workspace — root `Cargo.toml` `members` list is the authoritative source of truth for the crate list once the workspace is initialized. Initial crate family: `pregolya`, `pregolya-core`, `pregolya-graph`, `pregolya-checkpoint`, `pregolya-openai`, `pregolya-anthropic`, `pregolya-ollama`, `pregolya-community`, `pregolya-splitters`; final crate names are established in the architecture ADR at Phase 1.

---

## Project References

| Path | Description |
|------|-------------|
| `.factory/STATE.md` | Live pipeline state (current phase, decisions log D1–D8, session resume checkpoint) |
| `.factory/semport/` | Semantic port analysis — per-package behavioral-intent, module-inventory, dependency-disposition, rust-translation-strategy, test-inventory |
| `.factory/semport/reference-manifest.md` | Pinned reference corpus versions (langchain 1.3.13, langgraph 1.2.9, langchain-community 0.4.2, langchain-mcp-adapters 0.3.0) |
| `.factory/planning/` | Pre-pipeline artifacts (market-intel, naming-decision-study, repo-initialization-log) |
| `.factory/specs/architecture/` | Architecture docs + ADRs + ARCH-INDEX.md (populated at Phase 1) |
| `.factory/specs/behavioral-contracts/` | BC files + BC-INDEX.md (populated at Phase 1) |
| `.factory/specs/domain-spec/` | L2 domain spec — entities, invariants, capabilities, edge cases (populated at Phase 1) |
| `.factory/specs/prd-supplements/` | error-taxonomy, nfr-catalog, interface-definitions, test-vectors (populated at Phase 1) |
| `.factory/specs/verification-properties/` | VP files + VP-INDEX.md — Kani proofs + fuzz targets (populated at Phase 6) |
| `.factory/stories/` | Per-story implementation specs + STORY-INDEX.md (populated at Phase 2) |
| `.factory/holdout-scenarios/` | Hidden acceptance scenarios — Domain A (Virtual SOC analyst) + Domain B (Dark factory); sealed until Phase 4 evaluation |
| `.factory/namespace-reservation/` | Placeholder Cargo.toml stubs for crates.io name reservation; `publish-all.sh` reserves all `pregolya-*` names |
| `.factory/cycles/` | Per-cycle burst logs, convergence trajectories, session checkpoints, lessons learned |
| `.factory/policies.yaml` | Project governance policy registry (created when policy management starts) |
| `.reference/` | 4 pinned reference corpora — gitignored, read-only; do not modify |
| `Justfile` | Task runner — created at workspace init; `just --list` for recipes |
| `lefthook.yml` | Pre-commit/push/tag git hook config — created at workspace init |
| `rust-toolchain.toml` | Pinned Rust toolchain channel + components + targets — created at workspace init |
| `Cargo.toml` | Workspace root — created at workspace init; `members` is source of truth for crate list |
| `crates/` | Pregolya workspace crates — populated during Phase 3 TDD |

---

## Source-of-Truth Precedence

When two artifacts disagree, the **LATER, MORE-SPECIFIC artifact wins**. Apply this rule when adversary, consistency-validator, or spec-reviewer surfaces a conflict between two project documents:

1. **Story spec** (under `.factory/stories/`) supersedes the BC it traces to, when the conflict is about implementation scope. The BC supersedes when the conflict is about contract semantics.
2. **ADR** (under `.factory/specs/architecture/adr/` or numbered `ADR-NNN-*.md`) supersedes earlier ADRs that address the same decision; superseded ADRs are marked with explicit `Supersedes: ADR-NNN` and `Superseded by: ADR-MMM` frontmatter back-refs.
3. **PRD supplements** (`interface-definitions`, `error-taxonomy`, `nfr-catalog`, `test-vectors`) supersede the PRD prose for the same surface area.
4. **VP files** (`.factory/specs/verification-properties/`) supersede the prose verification narrative in PRD/architecture for the property they cover.
5. **Recent `.factory/STATE.md` decision rows (D-NNN)** supersede earlier-recorded but conflicting narrative in any session handoff document.
6. **Recent adversary pass reports** supersede earlier pass reports for the same finding ID (cascade closure rationale tracks the chain).
7. **For code-vs-spec conflicts**: the SPEC wins (Standing Rule for VSDD). Code is brought into alignment via fix-burst or follow-up story, not the other way around. Only the human can authorize spec amendment to match code.

If two artifacts are at the same precedence level and disagree, surface to the orchestrator. The orchestrator routes to the artifact's owner-specialist (e.g., BC vs BC → product-owner; ADR vs ADR → architect) for adjudication.

---

## Pipeline Authority

The orchestrator (`vsdd-factory:orchestrator` agent) coordinates all phases. Specialist agents do the writing. **The orchestrator does NOT write files itself** — it delegates via the `Agent` tool with `subagent_type` set to the specialist (see Agent Routing Table in the Companion Principle section below). The single permitted exception is direct human-mandated edits to this CLAUDE.md or other project-root meta-docs.

Phase sequence for pregolya (greenfield + semport mode):

- **pre-1: Semport Analysis** (IN PROGRESS) — semantic port of langchain-core, langgraph, langchain-mcp-adapters; outputs: behavioral-intent, module-inventory, dependency-disposition, rust-translation-strategy per package
- Phase 1: Spec Crystallization — domain spec / PRD / architecture / adversarial review; pydantic→serde/schemars ADR required before BCs (D5)
- Phase 2: Story Decomposition — per-story specs, dependency graph, wave schedule; holdout scenarios authored (Domains A + B from D8)
- Phase 3: TDD Implementation — wave-by-wave delivery; wave priority: pregolya-core → pregolya-graph → partners (D7)
- Phase 4: Holdout Evaluation (gated on per-wave readiness; strict information asymmetry)
- Phase 5: Adversarial Refinement (post-implementation cascade)
- Phase 6: Formal Hardening (Kani + cargo-fuzz + cargo-mutants + semgrep)
- Phase 7: Convergence — 7-dimensional convergence assessment

Per-story Phase 3 sub-workflow: stubs → failing tests → TDD green → LOCAL adversary 3-CLEAN → demo-recorder per-AC → push → pr-manager 9-step PR cycle → squash-merge → state-manager post-merge burst. BC-5.39.001 3-CLEAN protocol applies to every cascade.

---

## CANONICAL PRINCIPLE — Production-Grade Default

This principle binds every AI agent operating on this project. It overrides any default behavior in agent prompts, skills, or templates that conflicts with it.

### Statement

**Default behavior is enterprise/production-grade correctness. Speed lives in feature *ordering*, not feature *completeness*.**

### Six rules

1. **No MVP-driven deferrals.** Phrases like "for now," "good enough," "we can fix later," "minimum viable," and "ship fast and iterate" are RATIONALIZATIONS, not engineering decisions. Treat them as defect-pattern smells. If a thing is worth doing in v1, it is worth doing correctly in v1.

2. **Feature order is the only acceptable speed lever.** It is acceptable to defer an entire feature (e.g., a future story or wave) to a later cycle. It is NOT acceptable to ship the current story partially or with shortcuts that need later cleanup. Each shipped feature must be production-grade on the cycle it ships.

3. **Tech debt register (`.factory/tech-debt-register.md`) is for HUMAN-DIRECTED deferrals ONLY.** AI agents must NOT add entries to it as a default catchment for issues found during review. If an agent discovers a defect, the default action is to FIX it in-scope. Adding to the register requires ALL of:
   - Explicit human direction to defer, AND
   - A concrete future dependency that makes the deferral necessary (e.g., "this depends on Wave 5 MCP SDK"), AND
   - Attachment to the specific future story or wave where it will be resolved (so it cannot get lost).

4. **AI-built defects are the AI's responsibility to fix.** Every artifact in `.factory/` and most code in `crates/` was written by AI (with human approval). When an AI agent finds an issue in another AI agent's output, the default is to fix it in the current scope — even if that means expanding scope. Surfacing the issue as a question, an "advisory," a "TODO for architect," or a "pending architect review" is the WRONG default. The correct default is to fix.

5. **`Suggest` is acceptable. `Default to cheap path` is not.** Agents may propose cheaper alternatives to the human, but the agent's DEFAULT action must be the correct path. "I noticed this would be faster if we skipped X — would you like to?" is fine. Skipping X without surfacing the option is not.

6. **"Pending architect review" / "TODO for architect" / "Placeholder for architect" in spec artifacts is forbidden when the question is answerable in current scope.** If the question requires architect adjudication only because the answer needs cross-component reasoning that hasn't happened yet, that's legitimate. If the question is mechanical (path migration, version pin selection, conventional clippy lint configuration), the AI handling the spec must answer it now.

### What this means in practice

| Anti-pattern | Production-grade replacement |
|--------------|------------------------------|
| "MVP: ship without test coverage on edge case X" | Write the edge case test. Cover it now. |
| "For now we'll hardcode this value; refactor later" | Read the value from config now. Write the config schema. |
| "We can add error handling in v2" | Add error handling now. Define the error taxonomy in scope. |
| "Architect TODO: confirm patch-version pinning policy" | Pick the production-grade default and write the rationale inline. |
| "Pending architect review: should we support this endpoint shape?" | Read the canonical contract, decide based on existing parity argument, document the decision. |
| "Phase 5 deferred: add this to tech-debt-register" | First ask: did the human direct this deferral? If no, fix it now. |
| "Good enough for v1" | "Production-grade for v1." If you can't say production-grade, you're not done. |
| Implementer claims "MVP scope" / "test-path-only" / "deferred to follow-up" | Adversary independently verifies the claim under fresh-context analysis. Implementer self-disclosure of risk severity is NOT authoritative. |
| Silent `Vec::new()` return where partial-failure data should propagate | Thread proper plumbing through; surface-and-defer-via-error violates the production-grade default. |
| Doc comment claiming "this requires capability X" with no capability check | Either implement the gate or remove the docs. |
| Adding `Arc<dyn Foo>` plumbing to a constructor that didn't have it, to close a finding correctly | DO IT. Arc-DI wiring means don't *replace* existing implementations; it does NOT mean don't *add* proper plumbing where it was missing. |
| File a P4 TD for cosmetic cleanup of 2 byte-identical types (~45 min total) | Fix the 2 cosmetic cleanups in-scope. P4 TDs that could have been a single inline edit are a defer-pattern smell. |

### Self-Audit Checklist (every agent, before declaring work done)

Run this checklist as the last act of every task. If any answer is "yes" or "I'm not sure," stop and remediate before declaring done.

- [ ] Did I rationalize any decision with "MVP," "for now," "good enough," or "we can fix later"?
- [ ] Did I add a new tech-debt-register entry without **all three** of: explicit human direction, concrete future dependency, and a specific future story/wave anchor?
- [ ] Did I leave any "pending architect review," "TODO for architect," or "Placeholder for architect" in a spec artifact for a question I could have answered in scope?
- [ ] Did I find a bug or gap in another AI's output and surface it as a question/advisory instead of fixing it in scope?
- [ ] Did I default to the cheapest mechanism instead of the correct mechanism?
- [ ] If I added an ADVISORY-severity finding to a report, did I evaluate whether it should be a BLOCKER under the production-grade lens? (Most "advisories" become blockers.)
- [ ] Did I paper-fix a finding by renaming, doc-commenting, or asserting-only when the real fix is structural? (TD-VSDD-059 paper-fix detection.)
- [ ] Did I sibling-sweep all callsites when I changed a function signature, constant, or canonical identifier? (TD-VSDD-060 sibling-site sweep.)

### Boundaries — what the principle does NOT mean

- **It does not mean "do everything before shipping anything."** Phasing waves is correct. Within a wave, every shipped story must be production-grade.
- **It does not mean "no asks of the human."** Genuine human decisions — risk acceptance, business priorities, scope vs deadline tradeoffs, versioning policy — should be surfaced. The principle forbids deferring WORK that the AI can do; it does not forbid surfacing DECISIONS that only the human can make.
- **It does not mean "infinite scope expansion."** If you find an issue, fix it. If the fix requires expanding into a new domain that requires new specs or new architecture decisions, surface it cleanly and request scope expansion. The principle requires fixing, not infinite recursion.
- **It does not override security or correctness.** If a "production-grade fix" requires a security review, run the security review.

### When in Doubt

If you are an AI agent and you are uncertain whether the production-grade default applies in a specific case, the answer is YES. The principle is the default. Ask only if you have a concrete reason to suspect this case is an exception.

If you are a human reviewing this file and you want to change the principle, edit this file and commit. The principle becomes whatever this file says.

---

## Companion Principle — Correct Agent Routing

"Fix in scope" works ONLY when paired with correct agent routing. Otherwise it degrades into "every agent does everything," which destroys specialization and produces worse work than the defer-pattern it replaces.

### Rules

1. **Agents own their domain.** A consistency-validator does NOT silently rewrite spec content. An implementer does NOT silently rewrite the spec. Each specialist agent has a defined scope (see Agent Routing Table below); work outside that scope is routed to the correct specialist via the orchestrator.
2. **The orchestrator owns routing.** When a specialist agent discovers a defect outside its own domain, it surfaces the finding to the orchestrator with the proposed routing. The orchestrator then dispatches the correct specialist. This is NOT a defer-pattern — it is correct-agent-pattern. The fix still happens in scope of the same work cycle.
3. **Surface vs defer — the critical distinction:**
   - **Surface (production-grade):** Agent A finds issue → routes to orchestrator → orchestrator dispatches specialist B → specialist B fixes in scope. **No human round-trip required for the routing.**
   - **Defer (forbidden):** Agent A finds issue → adds to tech-debt-register / advisory / "TODO for X" → original work declared done → issue persists. **Requires human to discover and re-prioritize.**
4. **When in doubt about routing, ask the orchestrator** — not the human. The orchestrator has the routing table loaded; let it route.
5. **The orchestrator NEVER does specialist work itself.** It coordinates, dispatches, and validates gates. If the orchestrator is tempted to write a file directly (other than this CLAUDE.md per direct human mandate), that is a routing failure — find the correct specialist and dispatch.

### Agent Routing Table

Use this table to determine which specialist handles which kind of work. Authoritative reference; supersedes any conflicting routing in upstream skills.

| If the work is... | Route to agent ID |
|-------------------|-------------------|
| Product brief, PRD, behavioral contracts (BCs), holdout scenarios | `vsdd-factory:product-owner` |
| Market analysis, L2 domain spec, ubiquitous language | `vsdd-factory:business-analyst` |
| Architecture, ADRs, DTU assessment, dependency manifest | `vsdd-factory:architect` |
| UX spec, design system, wireframes, interaction design | `vsdd-factory:ux-designer` |
| Story decomposition, dependency graph, wave schedule | `vsdd-factory:story-writer` |
| Cross-document consistency (IDs, anchors, counts, naming) | `vsdd-factory:consistency-validator` |
| Adversarial fresh-context review (specs or implementation) | `vsdd-factory:adversary` |
| Constructive spec/story review (different-model cognitive diversity) | `vsdd-factory:spec-reviewer` |
| PR diff code review (different-model cognitive diversity) | `vsdd-factory:code-reviewer` |
| Deep codebase scanning, semantic analysis, brownfield ingest | `vsdd-factory:codebase-analyzer` |
| Brownfield extraction validation (catch hallucinated dependencies) | `vsdd-factory:validate-extraction` |
| TDD test stubs and failing tests | `vsdd-factory:test-writer` |
| TDD implementation (one failing test → minimum code → micro-commit) | `vsdd-factory:implementer` |
| E2E browser tests (Playwright/Cypress) | `vsdd-factory:e2e-tester` |
| Demo recordings (VHS terminal or Playwright browser) | `vsdd-factory:demo-recorder` |
| PR lifecycle (create, review dispatch, finding triage, merge) | `vsdd-factory:pr-manager` |
| Final fresh-eyes PR diff review before merge | `vsdd-factory:pr-reviewer` |
| Formal proofs (Kani), fuzzing, mutation testing, security scan | `vsdd-factory:formal-verifier` |
| Security review / triage (CWE/CVE, OWASP) | `vsdd-factory:security-reviewer` |
| Holdout scenario evaluation against implementation (strict info asymmetry) | `vsdd-factory:holdout-evaluator` |
| DTU clone validation against real third-party services | `vsdd-factory:dtu-validator` |
| Repo setup, worktrees, CI/CD, release, Cargo workspace init | `vsdd-factory:devops-engineer` |
| Toolchain preflight, env setup, dependency installation | `vsdd-factory:dx-engineer` |
| `.factory/STATE.md` updates, `.factory/` commits, cycle bookkeeping | `vsdd-factory:state-manager` |
| Spec governance, versioning, traceability audit | `vsdd-factory:spec-steward` |
| Documentation generation from code/specs (current behavior only) | `vsdd-factory:technical-writer` |
| External research (Perplexity, Context7, Tavily MCP access) | `vsdd-factory:research-agent` |
| GitHub CLI operations on behalf of agents without shell access | `vsdd-factory:github-ops` |
| Performance benchmarks, regression detection | `vsdd-factory:performance-engineer` |
| Data schemas, migrations, pure-core / effectful-I/O boundary | `vsdd-factory:data-engineer` |
| WCAG AA/AAA accessibility audit | `vsdd-factory:accessibility-auditor` |
| Visual regression, mockup fidelity comparison | `vsdd-factory:visual-reviewer` |
| Post-pipeline analysis, lessons capture, improvement proposals | `vsdd-factory:session-reviewer` |

### Routing examples

- **Cross-document consistency defect found during a phase gate:** correct routing is `product-owner` (owner of BC/PRD content) OR `architect` (owner of ADR content), NOT consistency-validator-fixes-it. The orchestrator dispatches.
- **TDD red-gate violation where a test does not align with a BC:** route to `product-owner` (if the BC is the problem) or to the human (if the spec is genuinely contradictory). DO NOT have the test-writer modify the BC silently.
- **Security finding in a partner crate (credential handling, API key exposure):** triage classification is security-reviewer's job. The FIX is implementer's job (with security-reviewer re-running to confirm).
- **BC ↔ tracing-emission catalog drift discovered during implementation:** the implementer must amend the Canonical Structured Event Catalog in the SAME atomic commit (catalog location bound at Phase 1 — see SAP-1 below). Post-merge, state-manager + adversary verify.
- **Out-of-scope finding (legitimate scope-boundary defer):** route to orchestrator. Orchestrator records the deferral with explicit future-story attachment per Canonical Principle Rule 3. The deferral target must be a real story ID, not "Wave X" or "later."

### When the routing is unclear

If a defect doesn't obviously map to a specialist:

1. **Ask the orchestrator first.** The orchestrator has the routing table loaded; let it route.
2. **If the orchestrator is uncertain, the orchestrator asks the human.** This is the legitimate use of human time — routing-table extensions, not domain-fixes-by-wrong-agent.
3. **Default fallback for unmapped work: research → architect.** Most truly novel work that doesn't fit a specialist needs external research first (`vsdd-factory:research-agent`), then architectural decision (`vsdd-factory:architect`).

### Anti-patterns this principle blocks

- Adversary rewrites failing tests "to make them pass" (wrong: route to test-writer or implementer).
- State-manager writes spec content like BC bodies or ADR rationale (wrong: route to product-owner or architect; state-manager handles index rows, frontmatter syncs, decision logs, and cross-document version bumps).
- Consistency-validator silently edits brief frontmatter (wrong: route to product-owner).
- Implementer adds a new BC to fix a TDD red-gate (wrong: route to product-owner; implementer cannot author specs).
- Orchestrator writes the artifact itself when a specialist's output is unsatisfactory (wrong: re-dispatch the specialist with better instructions, or escalate to human).
- Any agent edits `.factory/STATE.md` directly (wrong: state-manager owns STATE.md).
- Filing a P4 "opportunistic cleanup" TD when the fix is ~45 minutes of in-scope work (wrong: fix in-scope per Canonical Principle Rules 3 and 4).

### Conflict with upstream

If a vsdd-factory agent prompt or skill defines a different routing than the table above, this table wins for pregolya.

---

## Operational Discipline TDs

These project-specific operational rules layer onto the canonical principle and are enforced by the factory-dispatcher hook chain:

- **TD-VSDD-053 — Single-commit-per-burst.** Each logical burst → ONE commit in `.factory/`. Multi-commit chains (HEAD and HEAD^ both containing "backfill" / "Stage 1" / "Stage 2") trigger `MULTI_COMMIT_CHAIN_NOT_ALLOWED`. Recovery procedure documented in "Factory Hook Diagnostics" below.
- **TD-VSDD-059 — Paper-fix detection.** State-manager and adversary must verify every claimed closure has a load-bearing test or assertion, not just a doc-comment or rename. Implementer self-disclosure of risk severity is NOT authoritative — adversary independently verifies.
- **TD-VSDD-060 — Sibling-site sweep on value changes.** When changing a function signature, constant, or canonical identifier, grep for ALL callsites in the same crate (and adjacent crates if `pub`) before committing.
- **TD-VSDD-091 — Anti-volatile-pin (records line-cite ban).** ALL spec, record, ledger, changelog, and ratification text must cite function / method / symbol names and behavioral anchors ONLY — NEVER `file.rs:NNN` or `path/file:NNN` line-number citations (which decay on the next diff and rot the trace). The prior "Justified citations" exception (Red Gate test tables, AC source-of-truth tables, pass-report changelogs) is **retired**: six consecutive adversarial passes in the CLIP email-notifications workstream minted findings exclusively from the frame/off-by-one family that exist only because record text cited volatile line numbers. Mechanical enforcement: `.factory/hooks/records-lint.sh` check L9 gates every factory commit on newly-authored additions (existing text grandfathered). Cross-applied from the CLIP email-notifications Stage-3 cascade (trend-gate #4 structural intervention + S3-39..S3-42 evidence), human-directed 2026-07-24.
- **TD-RECORDS-MICRO-BURST-001 — Records-only micro-burst ceremony.** When an adversarial pass returns findings that are exclusively records-tier severity (LOW or OBS only — zero CRIT, HIGH, or MED), the fix ceremony is a 2-step micro-burst instead of the full cascade: (1) ownership-routed specialist fixes the records-tier findings; `.factory/hooks/records-lint.sh` must exit 0 before the specialist declares done; (2) state-manager single-commit per TD-VSDD-053. The BC-5.39.001 3-CLEAN streak is NOT reset by a records-only micro-burst pass (LOW/OBS do not gate CLEAN(PR-merge)); the convergence trajectory records the pass result with label `RECORDS-ONLY`. Full cascade ceremony (adversary re-pass, full routing) is required when any MED/HIGH/CRIT finding is present. Cross-applied from the CLIP email-notifications Stage-3 cascade (trend-gate #4 structural intervention + S3-39..S3-42 evidence), human-directed 2026-07-24.
- **BC-5.39.001 — 3-CLEAN convergence protocol.** Adversarial cascades require three consecutive clean passes for convergence; any finding resets the streak to 0/3. Applies to both LOCAL and PR-LEVEL cascades.

  **Strict vs PR-Merge Convergence Disambiguation:**

  The CLEAN status reported by the adversary at the end of each pass has TWO INTERPRETATIONS:

  - **CLEAN (strict)** — ZERO findings of ANY severity (CRIT + HIGH + MED + LOW + OBS + PROCESS-GAP). This is the criterion required for **streak advancement** under BC-5.39.001 3-CLEAN. The 3-CLEAN streak advances only when 3 consecutive passes are CLEAN (strict).

  - **CLEAN (PR-merge)** — ZERO findings of CRIT + HIGH + MED severity (LOW/OBS/PROCESS-GAP findings present but non-blocking). This is a PR-merge-gate threshold ONLY; it does NOT advance the 3-CLEAN streak.

  **Adversary CLEAN reports MUST specify both criteria explicitly.** Recommended report format:

  ```
  CLEAN (strict): yes/no
  CLEAN (PR-merge): yes/no
  ```

  **Orchestrator dispatch decisions** for fix-bursts use the STRICT criterion. If CLEAN(strict)=no, orchestrator dispatches a fix-burst regardless of CLEAN(PR-merge) status.

  **Frozen-HEAD streak rule:** the 3-CLEAN streak only counts consecutive CLEAN(strict) passes taken against an UNCHANGED feature/PR HEAD. Pushing any new commit to the branch mid-cascade — a fix-burst, evidence refresh, or rebase — RESETS the streak to 0/3; the cascade must re-gate on the newly-pushed HEAD. Never count a pass taken before a push toward a streak completed after it.

- **TD-FACTORY-HOOK-BYPASS-001 P0** — Use Edit/Write tools ONLY for `.factory/` mutations. NEVER use Python/sed/echo bypass.
- **POL-14 — Auto-promotion at merge.** When a story's PR merges, BCs in `behavioral_contracts` frontmatter auto-promote `draft → active`. State-manager runs this transition.

- **Heartbeat Auto-Recovery (standing operating procedure; D-318, 2026-08-29).** A durable recurring cron (job `60fc8eb8`, schedule `8,23,38,53 * * * *`, ~15 min cadence) fires while the REPL is idle to detect dead/stalled agents and keep the convergence loop running without a human present. Standing policy: **AUTO-RECOVER + DRIVE TO CONVERGENCE** — the heartbeat re-dispatches dead or stalled agents and drives to convergence autonomously; it STOPS + alerts ONLY at human-approval phase gates and true blockers (missing repo, unresolvable conflict, force-push required, budget exhaustion). Composes with DIRECTIVE 1 (keep going to convergence) and DIRECTIVE 2 (fix-in-scope default). Authoritative protocol: `.factory/rules/heartbeat-recovery-protocol.md`. Portable reproduction guide: `.factory/rules/heartbeat-setup-guide.md`. Teardown: `CronDelete 60fc8eb8`.

---

## Code Conventions

Pregolya-specific coding patterns enforced by CI and/or adversarial review. These are non-negotiable under the production-grade default — violations are bugs, not style preferences.

### reqwest TLS backend — rustls-tls mandatory

Every `reqwest` dependency entry in the workspace — `[dependencies]`, `[dev-dependencies]`, and optional/feature-gated entries — must declare `default-features = false, features = ["rustls-tls"]`. Omitting `default-features = false` silently enables `native-tls`, which causes ~65s macOS Keychain init overhead and opens a corporate MITM proxy interception path for outbound provider API credentials (OpenAI, Anthropic, Ollama, and all partner crate API keys transit reqwest). The `native-tls` feature and its aliases (`default-tls`, `native-tls-alpn`, `native-tls-vendored`) are forbidden workspace-wide. New workspace crates must declare `rustls-tls` at first write — there is no acceptable "fix in a follow-up."

### HTTP client timeout

Production `reqwest::Client` instances must use `.timeout(Duration::from_secs(30))`. The 30-second default applies until pregolya's NFR catalog (`.factory/specs/prd-supplements/nfr-catalog.md`, created at Phase 1) overrides it per-provider. New clients without an explicit timeout are a P1 finding in adversarial review.

### Newtype + redacted Debug for credentials

All credential and API key types (`OpenAiApiKey`, `AnthropicApiKey`, `OllamaBaseUrl` when auth-bearing, and equivalent types in every partner crate) must be newtypes with redacted `Debug` implementations. Credential values must never transit AI context. No `Debug` or `Display` implementation may leak key material. The newtype pattern applies to every type that wraps a secret; `impl fmt::Debug for T { fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result { f.write_str("<redacted>") } }` is the canonical form.

### No unwrap / expect in non-test code

`unwrap()` and `expect()` on `Result` or `Option` are forbidden in all code paths outside `#[cfg(test)]` blocks. Use `?` propagation with structured error variants. The error-code namespaces for pregolya are defined in `.factory/specs/prd-supplements/error-taxonomy.md` at Phase 1; the no-unwrap rule binds from the first line of production code.

### No silent empty returns where partial-failure should propagate

Returning a default `Vec::new()` or `None` where the operation encountered a partial failure is a production-grade violation. Batch, streaming, and fan-out operations must surface partial failures via the error taxonomy, not silently degrade to empty output. This is particularly critical for LLM message generation, tool call dispatch, and graph node execution paths.

### No println! in library crates

`println!` and `eprintln!` are forbidden in every crate except binary crates' CLI formatting helpers. Use `tracing::info!` / `tracing::warn!` / `tracing::error!` / `tracing::debug!` with structured field syntax. Example: `tracing::info!(event_type = "chain.invoke.started", model = %model_id, "chain invocation started")`.

### #[non_exhaustive] on public API surface types

All public types in the API surface — message types, content block variants, error types, provider config structs, graph node types, tool call shapes — require `#[non_exhaustive]`. External match arms must include a wildcard `_ => {}` arm. Compile-fail enforcement gates follow the pattern in `tests/external/<gate-name>/`; the exact inventory starts empty and grows as the workspace is built. When the non-exhaustive gate grows, update ALL three locations: the gate crate, the expected count constant, and the expected symbol list. The gate is the authority — CI failure means a new type was added without `#[non_exhaustive]` or without a gate update.

### Single-workspace MSRV

Toolchain is pinned via `rust-toolchain.toml` (created at workspace init). No per-crate MSRV divergence. All crates build on the single pinned stable channel.

### Tokio multi-threaded runtime, async-first

The Tokio multi-threaded runtime is the execution environment (AD-013 equivalent for pregolya, established at architecture phase). All I/O-bound operations — LLM calls, tool invocations, graph node execution, checkpoint reads/writes — are async. Do not block the Tokio thread pool with synchronous I/O. Sync facades are permitted only where the port spec explicitly requires a synchronous API surface.

### Arc-DI wiring per constructor

Production runtime wires dependencies via `Arc<dyn Trait>` constructors. The placeholder-construct anti-pattern — constructing a type without wiring real `Arc` dependencies "for now" — is explicitly forbidden. Adding `Arc<dyn Foo>` to a constructor that lacked it is "wiring, not redesign" and must be done in-scope.

### Structured event catalog discipline

Every `tracing::*!(event_type = …)` site must appear as a row in the Canonical Structured Event Catalog with full field schema, audit role, and recurrence policy. The catalog's location is assigned at Phase 1 (expected path: `.factory/specs/prd-supplements/observability.md` or a dedicated behavioral contract section). New emission sites added without a corresponding catalog row are a P1 finding in adversarial review. The obligation binds from the first tracing emission in `crates/`; see SAP-1 below for the adversary standing probe.

### File size & module splitting

Rationale: `.factory/planning/file-size-standard-study.md`.

**Thresholds** (measured by `tokei --output json` `Code` metric — blanks, comments, doc-comments, `#[cfg(test)] mod` blocks, and generated code excluded from the count):

| File class | Soft target (warn — split during authoring) | Hard gate (CI fails) |
|------------|---------------------------------------------|----------------------|
| Production files | 500 code-lines | 750 code-lines |
| Test files (`tests/**` and `#[cfg(test)]`-dominant files) | 1,000 code-lines | 1,500 code-lines |

**Enforcement:** A required CI job `cargo xtask check-file-size` reads `tokei --output json` and enforces both gates. The job is created at workspace init and binds from the first crate. Complement (do not replace) with `clippy::too_many_lines = 150` in `clippy.toml` for function-level discipline. **Clippy has no file-level lint** (`too_many_lines` is function-scoped only; a file-level lint is merely an open proposal, not shipped) — do not assume Clippy covers this gate.

**Exceptions:** Central allowlist at `xtask/file-size-allowlist.toml`. Each entry requires: `path` + `reason` + `approver` + `date`. Entries require PR review. Generated code (`OUT_DIR/`, `*.gen.rs`, prost/tonic output) and `tests/fixtures/` are auto-excluded by glob — no allowlist entry needed. The allowlist is audited periodically to shrink it (mirroring rustc's effort to remove `ignore-tidy-filelength` overrides). Inline opt-out comments are not permitted — the allowlist is the only opt-out path.

**Cohesion clause — how to split, not just when:** The size gate is a split *trigger*, not a fragmentation mandate. When a file crosses the soft line, the question is "does this file still do one thing?" — if yes and the unit is cohesive, the allowlist exists for exactly that case. When splitting is warranted, split by concern or type-family, keeping one cohesive unit per file. `mod.rs` files must be re-export-only surfaces (`pub use` declarations; no logic). Over-splitting into many ~100-line files is an anti-pattern in Rust: a file is a module is a privacy boundary, and fragmentation creates grep-hostile `pub(crate)` noise without improving reviewability. If a file exceeds the soft target but splitting would break a cohesive unit (e.g., a match-heavy state machine or a table-driven conformance suite), that is exactly what the allowlist is for.

**Context note:** This rule exists partly because the Python reference corpus contains files up to ~6,700 lines. The port must NOT mirror source-file structure — behavioral fidelity is to semantics, not file layout.

### Forbidden patterns

| Pattern | Reason |
|---------|--------|
| `reqwest::Client::new()` without `.timeout()` in production code | Must set 30s timeout (or NFR-catalog override); clientless timeouts hang the executor |
| `reqwest` dep without `default-features = false` or with `native-tls` / `default-tls` / `native-tls-alpn` / `native-tls-vendored` feature | native-tls causes ~65s macOS Keychain init in tests and enables MITM proxy interception of provider API credentials; use `rustls-tls` |
| `unwrap()` / `expect()` on `Result` or `Option` in non-test code paths | Error taxonomy rule; use `?` + structured error variants |
| `println!` / `eprintln!` in library crate code | Use `tracing::*!` with structured fields; `println!` in libraries is untestable and untraceable |
| `Arc::new(SomeThing::placeholder())` style stub construction in production boot path | Arc-DI wiring contract; placeholder-construct is a production-grade violation |
| `tracing::*!(event_type = …)` without a Canonical Structured Event Catalog row | Catalog completeness rule (SAP-1); new emission sites require same-commit catalog row |
| Credential or API key value in any `Debug` or `Display` impl | Credential safety; use redacted newtype pattern |
| Production file exceeding 750 code-lines (tokei `Code` metric) without an `xtask/file-size-allowlist.toml` entry | File-size gate; CI fails; get an allowlist entry PR-reviewed or split the file |
| Logic (impl blocks, functions, type definitions) in `mod.rs` files | `mod.rs` must be re-export-only (`pub use …`); logic belongs in the named module file |

### Error handling

- Error namespaces and variant hierarchy: defined in `.factory/specs/prd-supplements/error-taxonomy.md` at Phase 1. The no-unwrap rule binds NOW; the taxonomy binds from the moment the file exists.
- Partial failures in fan-out operations (parallel tool calls, batch embeddings, graph node dispatch): propagate via structured error variants; do not swallow and return empty collections.
- Boot step failures: exit codes per the architecture ADR (authored at Phase 1); structured error logging required at every boot step boundary.

### Logging

- Use `tracing::info!` / `tracing::warn!` / `tracing::error!` / `tracing::debug!` with structured field syntax.
- All `event_type` values must be registered in the Canonical Structured Event Catalog before the PR merges (catalog location assigned at Phase 1).
- Log target discipline: subsystem-keyed targets defined in the observability spec (authored at Phase 1); match the target to the subsystem.

### Channels / async

- Tokio multi-threaded runtime. All LLM provider calls, tool invocations, graph traversal steps, and checkpoint operations are async.
- Do not block the Tokio thread pool with synchronous I/O. Use `tokio::task::spawn_blocking` for unavoidable sync operations.
- Arc-based immutable config snapshots for hot-reload patterns; in-flight operations hold a snapshot reference across their lifetime.

### Conflict resolution

If this principle conflicts with a vsdd-factory agent prompt, skill, or rule, this principle wins for pregolya.

---

## Standing Adversary Probes & Implementer Disciplines

### SAP-1 — Adversary standing probe: tracing emission catalog completeness

For EVERY adversarial pass on stories or PRs touching `crates/**/*.rs`:

1. Grep `event_type =` across the entire `crates/` workspace (not just changed files): `rg 'event_type\s*=' crates/ --type rust`
2. For each `event_type` value found, verify a corresponding row exists in the Canonical Structured Event Catalog (location assigned at Phase 1; expected: `.factory/specs/prd-supplements/observability.md` or a dedicated BC section) with full field schema, audit role, and recurrence policy
3. Tracing emission WITHOUT a catalog row = **P1 finding**
4. Same-commit catalog row required for emissions added in the branch
5. Removal of an emission (e.g., replaced by `?` propagation) does NOT require a new catalog row — `?` propagation provides audit trail without catalog overhead

### SAP-2 — DTU schema parity (partner crate stories) — pattern adoption note

The DTU↔schema parity probe pattern from the VSDD framework (verify every column in a schema spec matches the corresponding Rust type in the DTU clone) is adopted for pregolya. The full probe applies to pregolya partner crates that implement DTU clones (e.g., `pregolya-openai` against the OpenAI API contract). The probe is operationalized at Phase 3 when the first partner DTU crates are implemented; the standing rule is established now.

### SID-1 — Implementer discipline: no-ignored-test rationalization prohibition

When no failing test drives a spec-required behavior because integration tests are `#[ignore]`'d (e.g., external-service dependency, LLM API key required):

1. This is NOT justification to defer the behavior.
2. The correct response: add a unit test in the production module's `#[cfg(test)] mod tests` block that drives the behavior WITHOUT the external dependency (mock or stub at the dependency boundary).
3. The unit test must actually exercise the production code path.
4. `#[ignore]`'d integration test must include a code comment citing the blocking dependency (e.g., `// EXT-001: requires live OpenAI API key; ungated in CI after key provisioning`).
5. "Deferred to non-ignored test" is ONLY valid if a SPECIFIC story ID and SPECIFIC test name are cited in the deferral.
6. Implementer must self-check this before declaring a Red Gate test pass via a non-`#[ignore]`'d substitute.

### Conflict with upstream agent prompts

If the upstream vsdd-factory adversary or implementer agent prompt defines a probe / discipline that contradicts SAP-1, SAP-2, or SID-1, the project-local rule wins for pregolya.

---

## Build & Test

The Justfile and lefthook hooks are created at workspace init (Phase 3 prerequisite). Until then, raw `cargo` commands apply. The TDD inner-loop discipline below binds from the first test written.

```bash
# TDD inner loop — single crate, fast iteration (~10-30 sec warm)
just iter <crate> [test_filter]
# Examples:
just iter pregolya-core
just iter pregolya-graph test_BC_2_01

# Pre-push gate — full strict workspace check
just check          # fmt + clippy + nextest + doctests + crate-layout
just check-fast     # clippy + layout only (no tests; for refactor sweeps)

# CI-equivalent local run — adds deny + audit + semver-checks + file-size gate
just check-ci
cargo xtask check-file-size  # file-size CI gate only (fast; tokei code-lines; required CI job)

# Diagnostics
just clippy         # workspace clippy with -D warnings
just fmt            # cargo fmt --all
just cov            # coverage via cargo-llvm-cov

# Specialty (require external toolchain installs)
just kani-local     # Kani formal verification proofs
just fuzz-local <crate> <target>   # cargo-fuzz
just mutants        # mutation testing
just udeps          # unused-dep detection (requires nightly)
```

**Until the Justfile exists:** substitute `cargo nextest run -p <crate>` for `just iter <crate>` and `cargo fmt --all && cargo clippy --workspace -D warnings && cargo nextest run --workspace` for `just check`.

**DO NOT** run full workspace checks between every TDD fix in a multi-finding burst — use the per-crate command instead.

### TDD Inner Loop Discipline

When iterating through a TDD fix-burst (closing multiple findings in sequence), use the cheapest verification that proves what you need. Match the tool to the question:

| Question | Command | Time (warm) |
|---|---|---|
| Did my single fix make its target test pass? | `cargo nextest run -p <crate> -E 'test(<test_name>)'` | < 1s after build |
| Did my fix break anything in this crate? | `just iter <crate>` | 10-30s |
| See ALL failing tests at once (don't stop at first) | `cargo nextest run -p <crate> --no-fail-fast` | 30-60s |
| Final pre-push gate (workspace canonical) | `just check` | 1min warm / 5-8min cold |

**Common anti-pattern:** running `just check` (full workspace) between every TDD fix in a multi-finding burst. For a 10-fix burst this burns 10-50 minutes that adds nothing the per-crate run wouldn't already have caught. Reserve `just check` for ONCE at end of fix-burst before declaring done.

**Auto-iteration:** `cargo watch -x 'nextest run -p <crate> --no-fail-fast'` re-runs on save — useful for tight feedback when iterating on a single module.

**In-process vs subprocess tests:** Integration tests under `crates/<crate>/tests/` that invoke external processes carry significant overhead. Unit tests inside `src/*.rs` `#[cfg(test)] mod tests` blocks run in-process at ~5ms. For tight inner-loop iteration on logic, prefer unit tests; reserve subprocess integration tests for behavior that genuinely needs the full binary or a live network dependency.

---

## Formal Verification (Kani)

Phase 6 (Formal Hardening) includes Kani proofs for high-value invariants (graph cycle detection, checkpoint integrity, message token bounds). Proofs live in `crates/<crate>/src/proofs/` once established.

```bash
just kani-local            # all crate proofs
cargo kani -p <crate>      # single-crate proofs
```

**Platform support:** Kani is **Linux/macOS only** (upstream Kani uses CBMC as its backend; Windows is not supported by the Kani project). Windows contributors rely on concrete unit tests + CI's Linux/macOS proof job — proof validity is platform-agnostic (Rust code is the same on all platforms; one proof = truth for all).

VP coverage layers:
- **Kani proof** (formal, exhaustive within bounds) — Linux/macOS only
- **Concrete unit tests** (specific points, deterministic) — all platforms
- **Fuzz target** (random exploration) — Linux CI smoke + nightly long-run

---

## Git Workflow

### Branch model

- **Default branch:** `main` (release branch, infrequent commits)
- **Active development:** `develop` (PRs target `develop`)
- **Feature branches:** `feature/<story-id>` (e.g., `feature/S-3.01`)
- **Maintenance branches:** `maintenance/<scope>` (e.g., `maintenance/rename-core-trait`)
- **Worktree pattern:** per-story worktrees in `.worktrees/<story-id>/` for parallel work
- **Factory artifacts branch:** `factory-artifacts` (orphan branch mounted at `.factory/` via worktree). State-manager pushes it as part of each `.factory/` burst under the standing authorization granted at project init; no per-burst re-authorization needed. A force-push of `factory-artifacts` still requires explicit human approval.

### Commit conventions

- **Conventional Commits** enforced by `lefthook.yml` (created at workspace init):
  - `pre-commit`: fmt + clippy + layout
  - `pre-push`: `just check`
  - `pre-tag`: semver-checks + audit + deny
- **Factory hook chain** (`.factory/` commits): single-commit-per-burst per TD-VSDD-053; MULTI_COMMIT_CHAIN_NOT_ALLOWED detector blocks two consecutive commits with "backfill" / "Stage 1" / "Stage 2" in their subjects. See "Factory Hook Diagnostics" section below for the full recovery procedure.

### Non-negotiable git rules

- **NEVER skip hooks** (`--no-verify`, `--no-gpg-sign`). If a hook fails, investigate and fix the underlying issue. Bypassing is a TD-FACTORY-HOOK-BYPASS-001 P0 violation.
- **NEVER add AI attribution to commits** — no `Co-Authored-By: Claude`, no robot emoji. This is a standing human directive for pregolya.
- **NEVER force-push to `main`.** Force-push to `develop` requires explicit human approval. Force-push to feature/maintenance branches is acceptable when the work is local-only (no collaborators); `--force-with-lease` preferred over raw `--force`.
- **NEVER use destructive operations as a first-line response.** `git reset --hard`, `git clean -f`, `git checkout --` should be the last option after exhausting safer alternatives (`git stash`, `git reset --soft`, worktree-based isolation).

### Operational tips

- **Heredoc workaround:** large commit-message heredocs are sometimes blocked by hook payload limits. When `git commit -m "$(cat <<'EOF' ... EOF)"` fails, write the message to `/tmp/<file>` and use `git commit -F /tmp/<file>`.
- **Soft reset for recovery, never `--hard`.** Per the multi-commit-chain recovery procedure: `git -C .factory reset --soft HEAD~N` preserves the working tree state; re-author as a single combined commit.
- **`git stash` for in-progress work** when context-switching between worktrees — preserves uncommitted changes without losing them to a reset.

---

## Factory Hook Diagnostics

When `Agent` tool dispatches fail with errors like:

```
PreToolUse:Agent hook error: [...factory-dispatcher]: factory-dispatcher trace=<UUID> event=PreToolUse tool=Agent host_abi=1 matched_tiers=N plugins_run=N total_ms=N block_intent=true exit_code=2
```

— the factory-dispatcher hook chain blocked the dispatch. The error message itself carries NO human-readable reason — only the trace UUID. To diagnose, follow this procedure.

### Step 1 — Locate the dispatcher log

Internal logs live at:

```
.factory/logs/dispatcher-internal-YYYY-MM-DD.jsonl
```

(One file per day, JSONL format, one event per line.)

### Step 2 — Find the block reason

Search the day's log for the trace UUID:

```bash
grep '<TRACE-UUID>' .factory/logs/dispatcher-internal-$(date +%Y-%m-%d).jsonl
```

Look for `plugin.log` entries with `level: warn` — those carry the human-readable block reason as an embedded multi-line `message` field. Example payload from a real block:

```
"FAIL: MULTI_COMMIT_CHAIN_NOT_ALLOWED — HEAD and HEAD^ both contain 'backfill'.
 The single-commit protocol (TD-VSDD-053) does not use backfill commits.
 ...
 Recover with: git -C .factory reset --soft HEAD~2 then re-author as a single commit"
```

The `plugin_name` field on the same record (e.g., `validate-wave-gate-prerequisite`, `validate-pr-merge-prerequisites`, `regression-gate`) tells you which guard fired.

### Step 3 — Common blockers and recovery procedures

| Blocker | Detection | Recovery |
|---------|-----------|----------|
| **Multi-commit chain (TD-VSDD-053)** | HEAD and HEAD^ both have `backfill` / `Stage 1` / `Stage 2` in their commit messages | `git -C .factory reset --soft HEAD~N` (preserves working tree); re-author as one combined commit; force-push with `--force-with-lease` (requires explicit user approval) |
| **SHA drift** | STATE.md cites a develop SHA that doesn't match `git rev-parse origin/develop` | Update narrative via state-manager dispatch; STATE.md `develop_head` and any cited SHAs must match current `git log -1 --format=%H develop` |
| **In-progress narrative** | STATE.md decision log has an open phase without closure | Add closure row via state-manager; bump version |
| **factory-artifacts dirty** | `git -C .factory status --porcelain` is non-empty | Commit/discard pending changes via state-manager |

### Step 4 — Re-run the validator before re-dispatching

```bash
bash .factory/hooks/verify-sha-currency.sh
```

Expected: exit 0 with `PASS` lines and no `FAIL` lines. If it still fails, repeat Step 2 with the new dispatch's trace.

### Step 5 — Going-forward discipline (orchestrator)

To avoid the multi-commit-chain block:

- **Bundle backfills.** When state-manager performs multi-document backfills (e.g., adversary pass-N report + fix-pass-N closure report), stage all files THEN commit ONCE. Never two state-manager dispatches in a row both producing "backfill" commits.
- **Single-commit-per-burst.** Each logical burst (one adversary cascade step, one fix-pass cycle, one phase transition) → one commit in `.factory/`. Multiple consecutive commits with the same theme word (`backfill`, `Stage`) trigger the chain detector.
- **Soft-reset for recovery, never `--hard`.** The working tree state is what we want to preserve.
- **Force-push always needs user approval.** Per project git-safety protocol; orchestrator must request it from the human.

### Hook source locations (read-only reference)

- Dispatcher binary: `~/.claude/plugins/cache/claude-mp/vsdd-factory/<version>/hooks/dispatcher/bin/<platform>/factory-dispatcher`
- Hook registry config: `~/.claude/plugins/cache/claude-mp/vsdd-factory/<version>/hooks-registry.toml`
- Hook plugins (WASM): `~/.claude/plugins/cache/claude-mp/vsdd-factory/<version>/hook-plugins/*.wasm`
- Project-side validator scripts: `.factory/hooks/*.sh` (e.g., `verify-sha-currency.sh`)
