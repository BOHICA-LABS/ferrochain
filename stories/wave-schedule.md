---
document_type: wave-schedule
level: ops
version: "1.2"
status: active
producer: story-writer
timestamp: 2026-09-01T00:00:00Z
phase: 2
inputs: [STORY-INDEX.md, dependency-graph.md]
input-hash: "c526ad7"
traces_to: STORY-INDEX.md
---

# Wave Schedule: pregolya

## Summary

| Metric | Value |
|--------|-------|
| Total stories | 42 |
| Total waves | 3 (Wave 1, Wave 2, Wave 6) |
| Max parallelism (groups per wave) | 6 groups in Wave 1 / sub-batch 1d (sub-batch 1e has 5 groups; sub-batch 1j has 3 groups after adding S-1.29) |
| Estimated agent spawns | 42 implementer agents total |

## Wave Plan

> **Priority axis (D7):** pregolya-core → pregolya-graph → partners → remaining.
> Stories in the same group have no inter-story dependencies and can be dispatched
> to separate implementer agents concurrently. Sub-batches reflect topological ordering
> within each wave.

### Wave 1 (no cross-wave dependencies)

#### Sub-batch 1a — pregolya-core root

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.01 | 5 | S | 1 story/agent |

#### Sub-batch 1b — pregolya-core tier 1 + pregolya-splitters (depends on S-1.01)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.02 | 5 | S | 1 story/agent |
| B | S-1.03 | 5 | S | 1 story/agent |
| C | S-1.08 | 8 | M | 1 story/agent |

#### Sub-batch 1c — pregolya-core Runnable + pregolya-sandbox (depends on 1b)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.04 | 5 | S | 1 story/agent |
| B | S-1.09 | 13 | XL | 1 story/agent |

#### Sub-batch 1d — Dependent crates tier 1 (depends on 1c) — max parallelism (6 groups)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.05 | 8 | M | 1 story/agent |
| B | S-1.06 | 5 | S | 1 story/agent |
| C | S-1.07 | 5 | S | 1 story/agent |
| D | S-1.10 | 13 | XL | 1 story/agent |
| E | S-1.12 | 8 | M | 1 story/agent |
| F | S-1.14 | 8 | M | 1 story/agent |

#### Sub-batch 1e — Dependent crates tier 2 + graph tier 1 (depends on 1d)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.11 | 3 | XS | 1 story/agent |
| B | S-1.15 | 5 | S | 1 story/agent |
| C | S-1.19 | 13 | XL | 1 story/agent |
| D | S-1.21 | 8 | M | 1 story/agent |
| E | S-1.28 | 5 | S | 1 story/agent |

#### Sub-batch 1f — Streaming events + Bash tool (depends on 1e)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.17 | 5 | S | 1 story/agent |
| B | S-1.22 | 8 | M | 1 story/agent |

#### Sub-batch 1g — Context mutation + budget policy (depends on 1f; concurrent — disjoint scheduler.rs regions)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.13 | 8 | M | 1 story/agent |
| B | S-1.18 | 8 | M | 1 story/agent |

#### Sub-batch 1h — BSP engine determinism (depends on 1g)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.16 | 13 | XL | 1 story/agent |

#### Sub-batch 1i — HITL core + server CRUD (depends on 1h)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.20 | 13 | XL | 1 story/agent |
| B | S-1.26 | 8 | M | 1 story/agent |

#### Sub-batch 1j — PreToolCallHook + server security config + GuardrailJournal (depends on 1i)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.23 | 5 | S | 1 story/agent |
| B | S-1.27 | 8 | M | 1 story/agent |
| C | S-1.29 | 5 | S | 1 story/agent |

#### Sub-batch 1k — Approval + compaction events (depends on S-1.23, S-1.17, S-1.18)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.24 | 5 | S | 1 story/agent |

#### Sub-batch 1l — Compaction execution (depends on S-1.10, S-1.18, S-1.24)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-1.25 | 5 | S | 1 story/agent |

---

### Wave 2 (depends on Wave 1 merge)

#### Sub-batch 2a — Wave 2 roots (parallel)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-2.01 | 13 | XL | 1 story/agent |
| B | S-2.04 | 8 | M | 1 story/agent |
| C | S-2.06 | 3 | XS | 1 story/agent |
| D | S-2.12 | 8 | M | 1 story/agent |

#### Sub-batch 2b — Wave 2 second tier (parallel)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-2.02 | 5 | S | 1 story/agent |
| B | S-2.05 | 8 | M | 1 story/agent |
| C | S-2.07 | 13 | XL | 1 story/agent |
| D | S-2.09 | 8 | M | 1 story/agent |

#### Sub-batch 2c — Wave 2 third tier (parallel)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-2.03 | 10 | M | 1 story/agent |
| B | S-2.08 | 8 | M | 1 story/agent |
| C | S-2.10 | 8 | M | 1 story/agent |

#### Sub-batch 2d — MCP server (depends on S-2.10)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-2.11 | 5 | S | 1 story/agent |

---

### Wave 6 (depends on Wave 1 + Wave 2 merge)

| Group | Stories | Points | Complexity | Agent Scope |
|-------|---------|--------|-----------|-------------|
| A | S-6.01 | 8 | M | 1 story/agent |

---

## Pipeline Overlap Plan

| Parallel Activity | When |
|------------------|------|
| Wave 1 stubs (pregolya-core) | Start at Phase 3 kickoff |
| Wave 1 stubs (pregolya-checkpoint, pregolya-sandbox, pregolya-splitters, pregolya-macros, pregolya-memory) | Start when pregolya-core types compile (after S-1.04 merges) |
| Wave 1 stubs (pregolya-graph) | Start when pregolya-core + pregolya-checkpoint types compile (after S-1.10 merges) |
| Wave 1 stubs (pregolya-tools, pregolya-server) | Start when pregolya-sandbox + pregolya-graph types compile |
| Wave 2 stubs (all Wave 2 crates) | Start when Wave 1 stories S-1.01 through S-1.22 are merged and crate types stable |
| Wave 2 implementation | Start after Wave 1 Red Gate fully verified and develop HEAD stable |
| Wave 6 Kani harnesses | Harness skeletons authored in S-6.01 spec; execution starts after all Wave 1+2 crates merged |
| VP proptest targets (VP-007, VP-008, VP-014) | Authored in their anchor stories (S-2.01, S-2.09, S-1.05); run at Phase 3 alongside TDD |
| VP integration tests (VP-004, VP-005) | Authored in S-2.10; run at Phase 3 with in-process mock server (SID-1 compliant) |

## Critical Path

> The critical path is the longest chain of sequentially-dependent **implementation stories**
> (Wave 1 + Wave 2). S-6.01 (Phase-6 formal-verification terminal aggregator) is excluded from
> this measurement: it depends on nearly all implementation stories by design and would trivially
> dominate any chain, making critical-path analysis uninformative for implementation scheduling.
> Total: **S-1.01 → S-1.03 → S-1.04 → S-1.14 → S-1.15 → S-1.17 → {S-1.13 | S-1.18} → S-1.16 → S-1.20 → S-1.23 → S-1.24 → S-1.25**
> = 12 stories, 82 points (S-1.13 and S-1.18 run concurrently in batch 1g; both feed S-1.16).

| Sequence Position | Story | Points | Depends On |
|------------------|-------|--------|-----------|
| 1 | S-1.01 | 5 | — |
| 2 | S-1.03 | 5 | S-1.01 |
| 3 | S-1.04 | 5 | S-1.03, S-1.02 |
| 4 | S-1.14 | 8 | S-1.04 |
| 5 | S-1.15 | 5 | S-1.14 |
| 6 | S-1.17 | 5 | S-1.14, S-1.04, S-1.15 |
| 7a | S-1.13 | 8 | S-1.12, S-1.04, S-1.14, S-1.17 (concurrent with S-1.18) |
| 7b | S-1.18 | 8 | S-1.14, S-1.04, S-1.10, S-1.17 (concurrent with S-1.13) |
| 8 | S-1.16 | 13 | S-1.14, S-1.15, S-1.10, S-1.13, S-1.17, S-1.18 |
| 9 | S-1.20 | 13 | S-1.16, S-1.17, S-1.10 |
| 10 | S-1.23 | 5 | S-1.20, S-1.17 |
| 11 | S-1.24 | 5 | S-1.23, S-1.17, S-1.18 |
| 12 | S-1.25 | 5 | S-1.10, S-1.18, S-1.24 |

**Critical path total: 82 points across 12 sequential positions (positions 7a/7b are concurrent).**
Note: S-1.17 is now on the critical path backbone (positions 5→6→7→8). S-1.15 is also on the
critical path because S-1.17 depends on it. S-1.10 (checkpoint) feeds into S-1.18 (concurrent with
S-1.13 at position 7) and into S-1.16 at position 8. Co-schedule S-1.10 with the S-1.14 batch
to avoid it becoming the actual critical path constraint.

## Crate Implementation Order

> Respects D7 priority: pregolya-core → pregolya-graph → partners → remaining.

| Tier | Crate | Wave | Notes |
|------|-------|------|-------|
| 1 | pregolya-core | 1 | Foundation; no deps |
| 2 | pregolya-splitters | 1 | Parallel with tier 2 |
| 2 | pregolya-sandbox | 1 | Parallel with tier 2 |
| 2 | pregolya-checkpoint | 1 | Parallel with tier 2 |
| 2 | pregolya-memory | 1 | Parallel with tier 2 |
| 2 | pregolya-macros | 1 | Parallel with tier 2 |
| 3 | pregolya-graph | 1 | D7 priority 2 |
| 4 | pregolya-tools | 1 | Dep sandbox + macros |
| 5 | pregolya-server | 1 | Dep graph + checkpoint |
| 6 | pregolya-vectorstores | 2 | Wave 2; no internal pregolya-* deps |
| 6 | pregolya-prompts | 2 | Wave 2; no internal pregolya-* deps |
| 6 | pregolya-openai-sdk | 2 | D17-Q5 wire client; no pregolya-core dep (builds before adapter) |
| 6 | pregolya-anthropic-sdk | 2 | D17-Q5 wire client; no pregolya-core dep (builds before adapter) |
| 6 | pregolya-ollama-sdk | 2 | D17-Q5 wire client; no pregolya-core dep (builds before adapter) |
| 7 | pregolya-openai | 2 | D7 partners priority; dep openai-sdk (tier 6) |
| 7 | pregolya-anthropic | 2 | D7 partners priority; dep anthropic-sdk (tier 6) |
| 7 | pregolya-ollama | 2 | D7 partners priority; dep ollama-sdk (tier 6) |
| 7 | pregolya-standard-tests | 2 | Shared test infra for providers |
| 8 | pregolya-mcp | 2 | Dep tools + graph |
| 9 | xtask (formal) | 6 | Terminal — all crates compiled |
| — | pregolya (facade) | v1 (incremental) | Re-export-only umbrella; Cargo.toml stub scaffolded at workspace init (namespace reservation); `pub use` re-exports assembled incrementally as member-crate stories land; no dedicated story (ADR-007 §Consequences) |
| — | pregolya-community | post-v1 | Zero v1 scope per ADR-007 + ARCH-INDEX roster; no v1 stories target this crate |

---

## Changelog

- **1.2 (D-356/DC-35/2026-09-08, story-writer):** F-PDC35-02 — S-1.29 (GuardrailJournal Persistence, 5 pts, S complexity) added to sub-batch 1j as Group C. Sub-batch 1j header updated to reflect 3 concurrent groups. Summary: Total stories 41 → 42; Estimated agent spawns 41 → 42. Critical path unchanged (S-1.29 is not on the critical path — it shares batch 1j with S-1.23 and S-1.27, neither of which is on the critical path). Input-hash updated to reflect dependency-graph.md changes.
- **1.1 (round-60/F-P2A232-02/2026-09-01):** S-1.28 inserted into sub-batch 1e as Group E (5 pts, S; depends_on S-1.14 per §Wave-1-Topological-Batches in dependency-graph). S-2.12 inserted into sub-batch 2a as Group D (8 pts, M; depends_on S-1.10 per §Wave-2-Topological-Batches in dependency-graph). Summary reconciled: Total stories 39 → 41; Estimated agent spawns 39 → 41; sub-batch 1e group count 4 → 5. Input-hash refreshed to match current inputs state. Critical path unchanged — neither S-1.28 nor S-2.12 blocks any downstream story.
