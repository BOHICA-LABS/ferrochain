---
document_type: prd-supplement-test-vectors
level: L3
version: "3.26"
status: active
producer: product-owner
timestamp: 2026-09-09T00:00:00Z
phase: 1a
inputs:
  - .factory/specs/prd.md
  - .factory/specs/behavioral-contracts/ss-01/BC-2.01.001.md
  - .factory/specs/behavioral-contracts/ss-07/BC-2.07.002.md
input-hash: "2394e59"
traces_to: prd.md
primary_consumers: [test-writer, holdout-evaluator]
changelog:
  - "3.26 (D-356/DC-46/2026-09-09, product-owner): B-PDC46: §Grand-Total corrected — D-356 SS-24 dev-console BCs (BC-2.24.001..008, +46 canonical TVs) and BC-2.11.007 (+5 canonical TVs) were never rolled into the grand-total (10 new BCs, PG-DC46 pre-commit hook was no-op). Canonical total 795→841 (+46 SS-24 + not yet individually subtotalled; validator basis). GTV count unchanged at 11. Total 806→852. BC count 140→150. verify-tv-registry-count.sh blocker cleared."
  - "3.25 (round-63/D-341/2026-09-01): BC-2.04.009 TV count 6→7 (+1 TV: TV-007 AES-GCM authentication failure — single-byte ciphertext tamper during conflict-detection decrypt → E-TRAJ-006; BC-local EC-006 path; F-P2A235-05). SS-04 subtotal +1. Grand total 794→795 canonical + 11 GTV = 805→806."
  - "3.24 (round-52/F-P2A216-02+F-P2A217-01+F-P2A216-01+F-P2A219-01/2026-08-31): BC-2.04.009 TV count 4→6 (+2 TVs: TV-005 encryption+duplicate-identical-plaintext→Ok(()) no false E-TRAJ-002 — plaintext comparison under per-record-nonce; TV-006 encryption+duplicate-divergent-plaintext→E-TRAJ-002 — correct conflict detection under encryption; F-P2A217-01/{INV-001}+{INV-002}). BC-2.04.011 TV count 5→4 (TV-003 REMOVED — E-TRAJ-004 structurally unreachable; F-P2A216-01/F-P2A216-03). Net TV delta: +2-1=+1. SS-04 subtotal +1. Grand total 793→794 canonical + 11 GTV = 804→805."
  - "3.23 (round-50/D-328/2026-08-31): BC-2.04.009 TV count 3→4 (+1 TV: TV-004 at-rest EncryptedSerializer plaintext-not-observable — when EncryptedSerializer configured, TrajectoryWriter::put_record MUST encrypt payload before SQLite WAL write; plaintext MUST NOT be observable at rest; CWE-311; F-P2A209-01). SS-04 subtotal +1. Grand total 792→793 canonical + 11 GTV = 803→804."
  - "3.22 (ADR-030-Stage2b/2026-08-31): PromoteRetireChannel BC renumbered (SS-04→SS-02; 4 TVs): BC-2.04.011 row retired from SS-04 inventory; BC-2.02.009 row registered under SS-02 (4 TVs, same contract). New BC-2.04.011 (SS-04, 5 TVs): Trajectory Compaction Isolation. SS-02 subtotal +4 (BC-2.02.009); SS-04 net +1 (−4 PromoteRetire row + 5 new compaction row). Grand total 787→792 canonical + 11 GTV = 798→803. BC count 139→140."
  - "3.21 (ADR-030-Stage2a/2026-08-31): 5 new CAP-040 BC inventory rows registered (ADR-030 Research Orchestrator Composition). BC-2.02.007 (SS-02, 4 TVs): LedgerChannel dedup-idempotent append; VP-017 proptest anchor. BC-2.02.008 (SS-02, 3 TVs): LedgerChannel first-appearance ordering. BC-2.04.009 (SS-04, 3 TVs): TrajectoryWriter::put_record durability. BC-2.04.010 (SS-04, 3 TVs): TrajectoryReader::replay ascending step_idx order. BC-2.04.011 (SS-04, 4 TVs): PromoteRetireChannel promote/retire lifecycle. SS-02 subtotal +7; SS-04 subtotal +10. Grand total 770→787 canonical + 11 GTV = 781→798. BC count 134→139."
  - "3.20 (round-49/F-P2A205-01+F-P2A205-02/2026-08-31): BC-2.09.007 TV count 10→13 (+3 TVs: TV-011 step-3 UUID redaction — plain-tool error with UUID run_id → `<redacted-id>` via sanitize_internal_ids (SEC-BOUND-001 step 3; F-P2A205-01); TV-012 URL-userinfo redaction — `scheme://user:pass@host` → `<redacted>` (pattern 5; CWE-522; F-P2A205-02); TV-013 Basic-auth redaction — `Basic <base64>` → `<redacted>` (pattern 6; CWE-522; F-P2A205-02)). SS-09 subtotal 69→72. Grand total 767→770 canonical + 11 GTV = 778→781."
  - "3.19 (round-48/F-P2A203-02+F-P2A201-01/2026-08-30): BC-2.09.007 TV count 9→10 (+1 TV: TV-010 Bearer-token pattern added to canonical sanitizer — Authorization: Bearer <token> matched by redact_credentials 4th pattern; production-grade addition; CWE-522; F-P2A203-02). BC-2.12.007 TV count 6→9 (+3 TVs: TV-007 SSE boundary credential-leak redacted; TV-008 SSE boundary sanitize_internal_ids pass; TV-009 SSE boundary static-replace for panic; SEC-BOUND-001 3rd external boundary; F-P2A201-01/F-P2A203-01). SS-09 subtotal 68→69. SS-12 subtotal 57→60. Grand total 763→767 canonical + 11 GTV = 774→778."
  - "3.18 (round-47/F-P2A197-01+F-P2A197-02/2026-08-30): BC-2.12.003 TV count 11→13 (+2 TVs: TV-012 E-GRAPH-011 conditional-edge panic → static 'internal error' + source_node suppressed ({INV-007} extended; CWE-209; F-P2A197-01); TV-013 credential-in-Run.error.message → redact_credentials 3-step sanitization pipeline ({INV-008} External-Boundary Error-Sanitization; CWE-209/532; F-P2A197-02)). SS-12 subtotal 55→57. Grand total 761→763 canonical + 11 GTV = 772→774."
  - "3.17 (round-42/F-P2A177-01+F-P2A179-01+F-P2A177-02/2026-08-29): BC-2.09.008 TV count 18→19 (+1 TV: TV-019 path_fn conditional-edge panic → E-GRAPH-011 ConditionalEdgePanic → static 'internal error' at MCP boundary; ADR-029 §Decision 5 EC-003 static-replace exception; CWE-209; F-P2A177-02). BC-2.12.003 TV count 10→11 (+1 TV: TV-011 node-body-panic → Run.status=failed + E-GRAPH-019 STATIC message + no panic text + no orphan in_progress; {INV-007} panic-text-isolation; SEC-008 requires panic=unwind on pregolya-server; F-P2A177-01). Grand total 759→761 canonical + 11 GTV = 770→772."
  - "3.16 (round-40/F-P2A170-01/2026-08-29): F-P2A170-01 [MED, POL-21/census] — BC-2.09.008 inventory row TV Count cell corrected 17→18 (stale; changelog v3.15 claimed 17→18 applied but inventory row was not updated; ground-truth BC body has 18 canonical TVs TV-001..TV-018). Notes cell updated to append TV-018 ForceApproveHooks unconditional ActionRisk pre-hook gate ({INV-004}; F-P2A165-01). TV grand total is 759 canonical + 11 GTV = 770; no TV count change (TV-018 was minted in r39; this is a census-row fix only)."
  - "3.15 (round-39/F-P2A165-01/2026-08-29): BC-2.09.008 TV count 17→18 (+1 TV: TV-018 ForceApproveHooks ActionRisk gate pre-empts inner hook call — None/Some(>=Medium)→Deny+E-MCP-011 without calling inner hook; CWE-862 gate; product-owner). Grand total 758→759 canonical + 11 GTV = 769→770."
  - "3.14 (round-30/F-P2A129-01/2026-08-28): BC-2.09.008 TV count 16→17 (+1 TV: TV-017 `sanitize_internal_ids` unit-isolation test — `\\b` non-over-match property for 64-char hex sequences at the sanitizer isolation layer; TV-015 corrected to full-pipeline expected output `\"digest: <redacted>\"` — `redact_credentials` rule `[A-Za-z0-9]{64,}` fires first in mandatory chain (ADR-029 §Decision 3 and Decision 5) and catches 64-char lowercase hex token before `sanitize_internal_ids` runs). Grand total 757→758 canonical + 11 GTV = 768→769."
  - "3.13 (round-28/GATE-READY-finding/2026-08-28): Ground-truth reconciliation — column sum was 724 vs declared 754; body ground-truth measured at 757 canonical (33-unit delta from column sum). Corrected 21 stale BC rows: BC-2.04.001 (4→5), BC-2.04.005 (5→6), BC-2.04.008 (7→8), BC-2.05.004 (6→9), BC-2.06.006 (4→5), BC-2.08.001 (4→5), BC-2.08.013 (6→7), BC-2.09.006 (6→8), BC-2.09.008 (13→16), BC-2.10.005 (6→9), BC-2.12.001 (7→9), BC-2.12.002 (8→9), BC-2.12.003 (7→10), BC-2.15.001 (7→8), BC-2.15.004 (9→10), BC-2.15.005 (7→8), BC-2.16.001 (5→6), BC-2.21.002 (6→7), BC-2.22.002 (5→7), BC-2.23.003 (5→6), BC-2.23.005 (6→8). Authoritative canonical total: 757 canonical + 11 GTV = 768 grand total. Note: v3.10 contained a +9-claimed/+6-recorded arithmetic error (746→752 instead of correct 755), now superseded by this ground-truth count; if corrected, declared total progression after v3.10 would have been 755→756→757 matching ground truth. Unlabelled-format BCs (SS-04 001–007, SS-11, SS-13 001–006) body count measured as table data rows excluding header row."
  - "3.12 (round-19/F-P2A088-01/2026-08-27): BC-2.09.008 TV count 12→13 (+1 TV: TV-013 u64 CheckpointId NOT covered by sanitize_internal_ids framework pass; authoring-site convention sole guarantee per {INV-001} / ADR-029 §Decision 3 SEC-005 canonical text). Grand total 753→754 canonical + 11 GTV = 764→765."
  - "3.11 (P2A-057-round-2/D-277/2026-08-26): BC-2.09.008 TV count 11→12 (+1 TV: TV-012 None/undeclared action_risk path, F-057-01 {INV-004} coverage). Grand total 752→753 canonical + 11 GTV = 764."
  - "3.10 (SEC-review-adjudication/D-276/2026-08-26): BC-2.09.007 TV count 6→9 (+3 TVs: credential-opacity enforcement paths, SEC-001 coverage). BC-2.09.008 TV count 7→11 (+4 TVs: ForceApproveHooks override scope {PC-006}, BoundaryApprovalHook ActionRisk>=Medium Deny {INV-004} E-MCP-011, additional state-isolation paths). BC-2.18.004 TV count 5→7 (+2 TVs: TV-006 FewShotExamples Red Gate {PC-005} + TV-007 multi-pair middle-untrusted Red Gate {PC-005} VP-006-B proptest). Grand total 746→752 canonical + 11 GTV = 757→763."
  - "3.9 (GAP-01/D-275/2026-08-26): BC-2.09.008 (StateGraph-as-MCP-Tool Wrapping; GraphAgentTool; mcp::graph_tool) registered — 7 TVs (TV-001..TV-007): STATE-ISOLATION invariant {INV-001} (VP-016 proptest P1), interrupt fail-closed E-MCP-010 (TV-002), isolation positive/negative paths (TV-001/TV-003), credential redaction {INV-003} (TV-007), error propagation (TV-004/TV-005/TV-006). Grand total 739→746 canonical + 11 GTV = 750→757. BC count 133→134."
  - "3.8 (P2A-037-gaps/2026-08-22): BC-2.18.001 Runnable/pure-core gaps closed — TV-008 (Runnable invoke wraps as PromptValue::String) added; TV count 7→8. BC-2.18.002 Runnable/PromptValue-enum gaps closed — TV-005 (ChatPromptTemplate Runnable invoke delegation) added; TV count 4→5. Grand total 701→703 canonical + 11 GTV = 714."
  - "3.7 (F-036-01/D-244/2026-08-22): BC-2.01.005 §PC-1 infallible amendment — EC-006 (duplicate-key last-write-wins) + TV-006 added; TV count 5→6. Grand total 700→701 canonical + 11 GTV = 712."
  - "3.6 (P2A-029-fix-burst/D-235/2026-08-22): BC-2.09.001 §PC9 amendment — TV-009 (overflow Err/E-MCP-008) + TV-010 (unknown-server Err/E-MCP-009) added. TV count 8→10. Grand total 698→700 canonical + 11 GTV = 711."
  - "3.5 (P2A-005-fix-burst/D-212/2026-08-20): BC-2.04.008 §Invariant-5 (EC-007 + TV-007) added by product-owner — FtsEncryptionIncompatible construction-time guard. TV count 6→7. Grand total: 697→698 canonical + 11 GTV = 708→709 total."
  - "3.4 (burst-302b/D-171/2026-08-17): LCEL composition scope expansion (D-170) — Add 4 new BC rows: BC-2.01.005 (5 TV), BC-2.01.006 (5 TV), BC-2.01.007 (5 TV), BC-2.01.008 (6 TV). Grand total: 676→697 canonical + 11 GTV = 687→708 total. BC count 129→133."
  - "3.3 (burst-291/D-134/2026-08-16): §-anchor phantom sweep — four phantom citations fixed. (1) §GTV below (line 38 context): no heading §GTV exists; corrected to §Golden Test Vectors — BC-2.07.002. (2) §GTV (line 87 context, same phantom): same fix. (3) §GTV (line 185 GTV convention blockquote): same fix. (4) §Test Vectors (line 199 context): BC bodies use heading '## Canonical Test Vectors', not '## Test Vectors'; corrected to §Canonical Test Vectors. TV counts and grand totals UNCHANGED."
  - "3.2 (burst-290/F-180-04, 2026-08-16): Fix live-body phantom ADR §-citation in Red Gate Vector Summary table. BC-2.20.002 row §Anchor column: `ADR-014 §DI-012` → `ADR-014 §Decision 6 — GuardedDocuments Typed Wrapper (DI-012 Mechanization)` (no heading §DI-012 exists in ADR-014; DI-012 mechanization is governed by `## Decision 6 — GuardedDocuments Typed Wrapper (DI-012 Mechanization)`). TV count and grand totals UNCHANGED."
  - "3.1 (burst-288/F-P177-C-SS17/2026-08-15): BC-2.17.001 Notes VP enumeration corrected — was '(VP-001/002/003 + VP-009/010/011)' missing P1 harnesses VP-006/012/013; corrected to '(VP-001/002/003/009/010/011 (P0) + VP-006/012/013 (P1))'. TV count and grand totals UNCHANGED (687 = 676 canonical + 11 GTV)."
  - "3.0 (fix-burst-287/F-P176-D001/2026-08-01): Ground-truth reconciliation — 8 stale registry rows corrected. Prior registry declared 664 canonical + 11 GTV = 675; ground truth (summed from BC bodies) is 676 canonical + 11 GTV = 687. Delta: +12 canonical TVs missing from registry. Rows corrected: BC-2.03.001 (5→6), BC-2.09.001 (7→8), BC-2.12.002 (7→8), BC-2.15.004 (7→9), BC-2.15.006 (6→7), BC-2.17.001 (5→9), BC-2.18.001 (6→7), BC-2.18.004 (4→5). Grand total corrected: 664→676 canonical + 11 GTV = 675→687. Normative ground-truth validation note added to §BC Test Vector Inventory preamble. Root cause: Mechanism 3 (arithmetic identity satisfiable without ground truth — column sum equals declared total at each update step, masking BC-body-vs-registry drift). Adversary finding D001 closed."
  - "2.9 (D-51-census/2026-07-28): BC-2.21.003 TV count 5→6 (+TV-006 overflow-norm guard; EC-006 overflow complement per BC-2.21.003 §Canonical Test Vectors v1.7 add). Grand total 674→675 (663→664 canonical + 11 GTV). Gate #28 resolved: v2.8 body ## Changelog row backfilled."
  - "2.8 (fix-burst-276/F-P173-505/2026-07-27): D-28 banner added to body ## Changelog section, declaring Form A (frontmatter changelog:) authoritative; body table preserved as historical record."
  - "2.7 (F-P152-01/F-P152-03/burst-253/2026-07-24): BC-2.10.005 TV count 5→6 (+TV-006 v1.2 add). BC-2.07.002 GTV count 9→11 (+GTV-010/011 grapheme-cluster discriminators, Python-verified). Group 4 added to §GTV. Grand total 671→674 (663 canonical + 11 GTV)."
  - "2.6 (F-P148-03/F-P148-05/burst-249/2026-07-24): Red Gate Vector Summary — de-pin ADR anchor labels: BC-2.18.004 'ADR-015 Security Invariant 1' → 'ADR-015 Decision 3 §Security Invariant 1'; BC-2.18.005 'ADR-015 Security Invariant 2' → 'ADR-015 Decision 2 §Security Invariant 2'; BC-2.19.005 'ADR-016 Security Invariant' → 'ADR-016 Decision 3 §Security Invariant'; BC-2.21.003 'ADR-014 v1.1 Hardening' → 'ADR-014 Decision 2 §Hardening note' (TD-VSDD-060 sibling sweep). Usage Notes §2: splitter version updated langchain-text-splitters==0.3.8 → langchain-text-splitters==1.1.2 (in-tree at langchain==1.3.13 SHA 42f8f79). Body changelog synced: backfill v2.5 row (was frontmatter-only)."
  - "2.5 (F-P142-03, burst-242, 2026-07-23): BC-2.06.005 Notes column updated — 'payload on Command::Resume' → 'payload on Command(resume=…)' per BC-2.05.004 struct kwarg authority."
  - "2.4 (burst-235/F-P135-05/2026-07-22): BC-2.13.002 TV count 4→5 (+kill-on-drop DI-015 co-enforcement TV). Grand total 670→671 (662 canonical + 9 GTV)."
  - "2.3 (burst-234/F-P134-01/2026-07-22): BC-2.23.006 TV count 5→6 (+TV-006 traversal I/O error, E-TOOLS-008). Grand total 669→670 (661 canonical + 9 GTV). Notes column updated to add E-TOOLS-008 cite."
  - "2.2 (D23/2026-07-22): Add 13 new D23 BC rows (+60 TVs); grand total 609→669 (660 canonical + 9 GTV). New rows: BC-2.05.007 (6 TV, VP-011 Kani seed), BC-2.05.008 (4 TV), BC-2.06.004 (4 TV), BC-2.06.005 (3 TV), BC-2.06.006 (4 TV), BC-2.10.005 (5 TV, VP-012 Kani seed), BC-2.10.006 (4 TV), BC-2.23.001 (5 TV), BC-2.23.002 (5 TV), BC-2.23.003 (5 TV), BC-2.23.004 (4 TV), BC-2.23.005 (6 TV, VP-013 Kani seed), BC-2.23.006 (5 TV). BC count 116→129."
  - "2.1 (D21/2026-07-21): Initial supplement created from prd.md §7 RTM inventory. 116 BCs catalogued; 600 canonical TV + 9 GTV = 609 total. RG BCs: 11. GTV source: BC-2.07.002 §Golden Test Vectors."
---

# Test Vector Catalog: pregolya

> **Index model:** This supplement is an index — it does NOT duplicate the canonical
> test vectors that live inside individual BC files. Each row below points to the
> authoritative source in `behavioral-contracts/ss-NN/BC-S.SS.NNN.md`.
>
> **Golden Test Vectors (GTVs):** BC-2.07.002 contains the normative golden vector
> set for non-ASCII splitter parity. These GTVs are reproduced in §Golden Test Vectors — BC-2.07.002 below because
> they constitute the Red Gate acceptance data — the test-writer needs them inline
> without loading the full BC file.
>
> **Red Gate vectors** are marked **RG** — they must exist as failing tests BEFORE
> implementation begins (D17-Q9 mandate).

---

## BC Test Vector Inventory

| BC ID | Subsystem | TV Count | GTV Count | Format | RG | Notes |
|-------|-----------|----------|-----------|--------|-----|-------|
| BC-2.01.001 | SS-01 | 5 | — | `TV-NNN` | | Typed ContentBlock happy/error/edge |
| BC-2.01.002 | SS-01 | 5 | — | `TV-NNN` | | Message type-safety: wrong type rejects |
| BC-2.01.003 | SS-01 | 5 | — | `TV-NNN` | | Runnable invoke/stream/batch dispatch |
| BC-2.01.004 | SS-01 | 5 | — | `TV-NNN` | | Pipe A\|B produces AB chain |
| BC-2.01.005 | SS-01 | 6 | — | `TV-NNN` | | RunnableParallel construction and concurrent invocation; infallible §PC-1 last-write-wins; EC-006 (D-170, D-244) |
| BC-2.01.006 | SS-01 | 5 | — | `TV-NNN` | | RunnableParallel branch failure — fail-fast, structured error E-CORE-009 (D-170) |
| BC-2.01.007 | SS-01 | 5 | — | `TV-NNN` | | RunnablePassthrough identity semantics and inspect contract (D-170) |
| BC-2.01.008 | SS-01 | 7 | — | `TV-NNN` | | RunnableAssign dict augmentation — mapper-wins, non-dict E-CORE-010, safetee streaming TV-007 (D-170) |
| BC-2.02.001 | SS-02 | 5 | — | `TV-NNN` | | StateGraph node + channel happy path |
| BC-2.02.002 | SS-02 | 6 | — | `TV-NNN` | | Reducer semantics: LastValue/Append/Barrier |
| BC-2.02.003 | SS-02 | 5 | — | `TV-NNN` | **RG** | NamedBarrierValue missing-writer → default |
| BC-2.02.004 | SS-02 | 5 | — | `TV-NNN` | **RG** | EphemeralValue cleared after super-step |
| BC-2.02.005 | SS-02 | 6 | — | `TV-NNN` | | Conditional edge routing |
| BC-2.02.006 | SS-02 | 6 | — | `TV-NNN` | | Send API fan-out |
| BC-2.02.007 | SS-02 | 4 | — | `TV-NNN` | | LedgerChannel dedup-idempotent append; VP-017 proptest anchor (CAP-040) |
| BC-2.02.008 | SS-02 | 3 | — | `TV-NNN` | | LedgerChannel first-appearance ordering (CAP-040) |
| BC-2.02.009 | SS-02 | 4 | — | `TV-NNN` | | PromoteRetireChannel promote/retire lifecycle; idempotent ops (CAP-040; renumbered from BC-2.04.011 per ADR-030 §Decision 3) |
| BC-2.03.001 | SS-03 | 6 | — | `TV-NNN` | | BSP determinism; VP seed |
| BC-2.03.002 | SS-03 | 5 | — | `TV-NNN` | | Concurrent LastValue → InvalidUpdateError |
| BC-2.03.003 | SS-03 | 5 | — | `TV-NNN` | | Task-identity sort order |
| BC-2.04.001 | SS-04 | 5 | — | table (unlabelled) | | put_writes before next super-step |
| BC-2.04.002 | SS-04 | 4 | — | table (unlabelled) | | Sync tier is default |
| BC-2.04.003 | SS-04 | 4 | — | table (unlabelled) | | Monotonic clock rejects wall-clock |
| BC-2.04.004 | SS-04 | 4 | — | table (unlabelled) | | Fork via parent_checkpoint_id |
| BC-2.04.005 | SS-04 | 6 | — | table (unlabelled) | | Crash recovery; completed not re-run |
| BC-2.04.006 | SS-04 | 4 | — | table (unlabelled) | | Triple-address uniqueness; VP seed |
| BC-2.04.007 | SS-04 | 4 | — | table (unlabelled) | | Encryption covers state AND events |
| BC-2.04.008 | SS-04 | 8 | — | `TV-NNN` | | FTS conversation search (SQLite FTS5; single-process); §Invariant-5 EC-007+TV-007 FtsEncryptionIncompatible |
| BC-2.04.009 | SS-04 | 7 | — | `TV-NNN` | | TrajectoryWriter::put_record durability; process-restart survival; at-rest EncryptedSerializer plaintext-not-observable TV-004; encryption idempotency TV-005 (no false E-TRAJ-002 on identical-plaintext duplicate); encryption conflict TV-006 (E-TRAJ-002 on divergent-plaintext duplicate); TV-007 AES-GCM auth failure during conflict-detection decrypt → E-TRAJ-006 (BC-local EC-006; F-P2A235-05) (CAP-040; F-P2A209-01/CWE-311; F-P2A217-01) |
| BC-2.04.010 | SS-04 | 3 | — | `TV-NNN` | | TrajectoryReader::replay ascending step_idx order (CAP-040) |
| BC-2.04.011 | SS-04 | 4 | — | `TV-NNN` | | Trajectory Compaction Isolation — atomic crash-safe compaction; crash-isolated WAL-mode segment swap; E-TRAJ-005 {PC-006} storage-error propagation (TV-003 removed: E-TRAJ-004 structurally unreachable; CAP-040; ADR-030 §Decision 2; F-P2A216-01) |
| BC-2.05.001 | SS-05 | 5 | — | `TV-NNN` | | Interrupt + durable suspend |
| BC-2.05.002 | SS-05 | 5 | — | `TV-NNN` | | FIFO resume order |
| BC-2.05.003 | SS-05 | 5 | — | `TV-NNN` | | Node re-executes from start on resume |
| BC-2.05.004 | SS-05 | 9 | — | `TV-NNN` | | Command(resume=value) API |
| BC-2.05.005 | SS-05 | 8 | — | `TV-NNN` | | Empty queue → Err(NoActiveInterrupt) (v1.5 adds TV-006/007/008) |
| BC-2.05.006 | SS-05 | 6 | — | `TV-NNN` | | Risk-tiered classification for Domain A |
| BC-2.05.007 | SS-05 | 6 | — | `TV-NNN` | | PreToolCallHook dispatch — Approve/Deny/Edit/PendingHumanApproval; fail-closed Deny (VP-011 Kani seed) |
| BC-2.05.008 | SS-05 | 4 | — | `TV-NNN` | | Skip-hook-on-resume invariant; ToolApprovalRequest checkpoint persistence |
| BC-2.06.001 | SS-06 | 5 | — | `TV-NNN` | | Typed event taxonomy |
| BC-2.06.002 | SS-06 | 5 | — | `TV-NNN` | | run_id + parent_ids correlation |
| BC-2.06.003 | SS-06 | 5 | — | `TV-NNN` | | Streaming/unary identical final answer |
| BC-2.06.004 | SS-06 | 4 | — | `TV-NNN` | | `tool_approval_request` StreamEvent (event 13); payload; emission before interrupt |
| BC-2.06.005 | SS-06 | 3 | — | `TV-NNN` | | `tool_approval_resolved` StreamEvent (event 14); payload on Command(resume=…) |
| BC-2.06.006 | SS-06 | 5 | — | `TV-NNN` | | `compaction_event` StreamEvent (event 15); payload; emission after compaction completes |
| BC-2.07.001 | SS-07 | 7 | — | `TV-NNN` | | Code-point chunk size (not bytes) |
| BC-2.07.002 | SS-07 | 3 | 11 | `TV-NNN` + GTV | **RG** | Non-ASCII parity (see §Golden Test Vectors — BC-2.07.002); (v1.6 adds GTV-010/011 grapheme-cluster discriminators) |
| BC-2.07.003 | SS-07 | 7 | — | `TV-NNN` | | Short doc < chunk_size → single chunk |
| BC-2.08.001 | SS-08 | 5 | — | `TV-NNN` | | Streaming conformance |
| BC-2.08.002 | SS-08 | 5 | — | `TV-NNN` | | Tool-call round-trip conformance |
| BC-2.08.003 | SS-08 | 5 | — | `TV-NNN` | | Structured output conformance |
| BC-2.08.004 | SS-08 | 5 | — | `TV-NNN` | | Error-type fidelity conformance |
| BC-2.08.005 | SS-08 | 5 | — | `TV-NNN` | | Token-usage accounting conformance |
| BC-2.08.006 | SS-08 | 4 | — | `TV-NNN` | | SDK crate split (sdk + adapter) |
| BC-2.08.007 | SS-08 | 5 | — | `TV-NNN` | | Transport error → Err(Timeout) |
| BC-2.08.008 | SS-08 | 5 | — | `TV-NNN` | | Eval arithmetic mean + InfraError |
| BC-2.08.009 | SS-08 | 5 | — | `TV-NNN` | | Schema naming stability snapshot |
| BC-2.08.010 | SS-08 | 6 | — | `TV-NNN` | | `#[tool]` proc-macro; duplicate-name E-TOOLS-010 TV-006 (burst-B) |
| BC-2.08.011 | SS-08 | 5 | — | `TV-NNN` | | `#[entrypoint]` proc-macro |
| BC-2.08.012 | SS-08 | 6 | — | `TV-NNN` | | `#[task]` proc-macro; reserved-name hard error TV-006 (burst-B) |
| BC-2.08.013 | SS-08 | 7 | — | `TV-NNN` | | Pluggable tool-call dialect (ToolCallDialect; Hermes ChatML XML) |
| BC-2.08.014 | SS-08 | 7 | — | `TV-NNN` | | Provider failover chain (ProviderFallbackPolicy; 429/5xx/auth) |
| BC-2.09.001 | SS-09 | 10 | — | `TV-NNN` | | MCP tool discovery |
| BC-2.09.002 | SS-09 | 7 | — | `TV-NNN` | | ToolInvocation routing |
| BC-2.09.003 | SS-09 | 5 | — | `TV-NNN` | | Tool-result as untrusted ingress |
| BC-2.09.004 | SS-09 | 5 | — | `TV-NNN` | **RG** | Bare ToolException re-raise |
| BC-2.09.005 | SS-09 | 5 | — | `TV-NNN` | **RG** | MultiServerMcpClient no live connections |
| BC-2.09.006 | SS-09 | 8 | — | `TV-NNN` | | MCP server tool advertisement (tools/list; mcp::server) |
| BC-2.09.007 | SS-09 | 13 | — | `TV-NNN` | | MCP server tool invocation (tools/call; external client); TV-010 Bearer-token pattern 4 (CWE-522; F-P2A203-02); TV-011 step-3 UUID sanitize_internal_ids (SEC-BOUND-001 step 3; F-P2A205-01); TV-012 URL-userinfo pattern 5 (CWE-522; F-P2A205-02); TV-013 Basic-auth pattern 6 (CWE-522; F-P2A205-02) |
| BC-2.09.008 | SS-09 | 19 | — | `TV-NNN` | | StateGraph-as-MCP-Tool Wrapping (GraphAgentTool; mcp::graph_tool); VP-016 proptest P1 seed ({INV-001} STATE-ISOLATION); TV-012 None/undeclared action_risk path ({INV-004}); TV-013 u64 CheckpointId NOT covered by sanitize_internal_ids (authoring-site convention sole guarantee; {INV-001}); TV-014/016 simple-UUID sanitize_internal_ids coverage; TV-015 full-pipeline (redact_credentials catches 64-char hex first — corrected F-P2A129-01); TV-017 sanitize_internal_ids isolation (non-over-match property at unit layer; F-P2A121-01/F-P2A129-01); TV-018 ForceApproveHooks unconditional ActionRisk pre-hook gate ({INV-004}; F-P2A165-01); TV-019 path_fn-panic → E-GRAPH-011 ConditionalEdgePanic → static "internal error" at MCP boundary (ADR-029 §Decision 5 EC-003 static-replace exception; CWE-209; F-P2A177-02) |
| BC-2.10.001 | SS-10 | 5 | — | `TV-NNN` | | Budget allow/escalate/deny evaluation |
| BC-2.10.002 | SS-10 | 5 | — | `TV-NNN` | | EvidenceJournal append-only |
| BC-2.10.003 | SS-10 | 7 | — | `TV-NNN` | | Graceful halt \| summarize on ceiling (v1.2 adds TV-006/007) |
| BC-2.10.004 | SS-10 | 6 | — | `TV-NNN` | | Budget escalation → HITL (v1.5 adds TV-006) |
| BC-2.10.005 | SS-10 | 9 | — | `TV-NNN` | | CompactionTrigger config — Disabled/OnWatermark/OnMessageCount/OnTokenCount (VP-012 Kani seed); (v1.2 adds TV-006); TV-007/008/009 fraction domain guards |
| BC-2.10.006 | SS-10 | 4 | — | `TV-NNN` | | Compaction execution — ConversationSnapshot, mid-run REPLACEMENT, EvidenceJournal, checkpoint immutability |
| BC-2.11.001 | SS-11 | 4 | — | table (unlabelled) | | ProvenanceTag at all ingress boundaries |
| BC-2.11.002 | SS-11 | 5 | — | table (unlabelled) | | GuardrailHook at tool-result ingress |
| BC-2.11.003 | SS-11 | 4 | — | table (unlabelled) | | GuardrailHook at RAG ingress |
| BC-2.11.004 | SS-11 | 4 | — | table (unlabelled) | | GuardrailHook at memory ingress |
| BC-2.11.005 | SS-11 | 4 | — | table (unlabelled) | | Rejected content never in model context |
| BC-2.11.006 | SS-11 | 4 | — | table (unlabelled) | | No-hook default: WARNING LOG |
| BC-2.12.001 | SS-12 | 9 | — | `TV-NNN` | | Thread CRUD |
| BC-2.12.002 | SS-12 | 9 | — | `TV-NNN` | | Assistant CRUD |
| BC-2.12.003 | SS-12 | 13 | — | `TV-NNN` | | Run lifecycle; TV-011 node-body-panic → E-GRAPH-019 STATIC ({INV-007}); TV-012 E-GRAPH-011 conditional-edge panic → static + source_node suppressed ({INV-007}; F-P2A197-01); TV-013 credential-in-Run.error.message → redact_credentials ({INV-008}; F-P2A197-02) |
| BC-2.12.004 | SS-12 | 7 | — | `TV-NNN` | | CronSchedule + proactive run |
| BC-2.12.005 | SS-12 | 7 | — | `TV-NNN` | | SecurityConfig::default() deny-CORS |
| BC-2.12.006 | SS-12 | 6 | — | `TV-NNN` | | Trait seams (IdempotencyStore etc.) |
| BC-2.12.007 | SS-12 | 9 | — | `TV-NNN` | | Streaming/unary same graph engine; TV-007/008/009 SSE boundary SEC-BOUND-001 3rd external boundary (credential-leak redact + sanitize_internal_ids + static-replace; {INV-004}; F-P2A201-01/F-P2A203-01) |
| BC-2.13.001 | SS-13 | 4 | — | table (unlabelled) | | Enforcing sandbox is default |
| BC-2.13.002 | SS-13 | 5 | — | table (unlabelled) | | Process backend requires explicit opt-in |
| BC-2.13.003 | SS-13 | 5 | — | table (unlabelled) | | Strict policy + non-enforcing → Err |
| BC-2.13.004 | SS-13 | 5 | — | table (unlabelled) | | canonicalize_beneath_root; VP seed |
| BC-2.13.005 | SS-13 | 5 | — | table (unlabelled) | | Symlink escape → Err(WorkspaceEscape) |
| BC-2.13.006 | SS-13 | 5 | — | table (unlabelled) | | macOS Seatbelt deny-by-default |
| BC-2.13.007 | SS-13 | 6 | — | `TV-NNN` | | Env var sanitization at sandbox execution boundary |
| BC-2.14.001 | SS-14 | 5 | — | `TV-NNN` | | PregolyaError 2D struct |
| BC-2.14.002 | SS-14 | 5 | — | `TV-NNN` | | RFC-7807 emission |
| BC-2.14.003 | SS-14 | 5 | — | `TV-NNN` | | Constructor Result; no unwrap |
| BC-2.14.004 | SS-14 | 5 | — | `TV-NNN` | | HTTP timeout 30s enforced |
| BC-2.14.005 | SS-14 | 5 | — | `TV-NNN` | | API key newtype redacted Debug |
| BC-2.14.006 | SS-14 | 5 | — | `TV-NNN` | | No silent None for validation failure |
| BC-2.15.001 | SS-15 | 8 | — | `TV-NNN` | | KV/vector memory across threads |
| BC-2.15.002 | SS-15 | 7 | — | `TV-NNN` | | User/app/session tier isolation |
| BC-2.15.003 | SS-15 | 7 | — | `TV-NNN` | | GDPR erasure all tiers |
| BC-2.15.004 | SS-15 | 10 | — | `TV-NNN` | | SkillStore registry — load-on-demand skill documents |
| BC-2.15.005 | SS-15 | 8 | — | `TV-NNN` | | Guarded memory and skill writes (MemoryWriteGuard) |
| BC-2.15.006 | SS-15 | 7 | — | `TV-NNN` | | Frozen-snapshot context mutation (memory-sourced sys prompt) |
| BC-2.16.001 | SS-16 | 6 | — | `TV-NNN` | | Retry keyed by tool_name not args |
| BC-2.16.002 | SS-16 | 5 | — | `TV-NNN` | | Finite global_limit non-None |
| BC-2.16.003 | SS-16 | 5 | — | `TV-NNN` | | Circuit breaker after repeated failure |
| BC-2.17.001 | SS-17 | 9 | — | `TV-NNN` | | Six P0 + three P1 Kani VP harnesses (VP-001/002/003/009/010/011 (P0) + VP-006/012/013 (P1)) |
| BC-2.17.002 | SS-17 | 5 | — | `TV-NNN` | | cargo-fuzz targets |
| BC-2.18.001 | SS-18 | 8 | — | `TV-NNN` | | PromptTemplate f-string render; partial binding; strict-undefined guard; Runnable invoke wraps as PromptValue::String |
| BC-2.18.002 | SS-18 | 5 | — | `TV-NNN` | | ChatPromptTemplate multi-message render; PromptValue enum (String/Messages); MessageProvenance; Runnable invoke delegation |
| BC-2.18.003 | SS-18 | 4 | — | `TV-NNN` | | MessagesPlaceholder expansion; FewShotPromptTemplate composition |
| BC-2.18.004 | SS-18 | 7 | — | `TV-NNN` | **RG** | injection_guard — TrustRequired slot + Untrusted tag → E-TMPL-001 |
| BC-2.18.005 | SS-18 | 4 | — | `TV-NNN` | **RG** | SlotTrustPolicy::TrustAll on SystemMessage → E-TMPL-002 at construction |
| BC-2.19.001 | SS-19 | 4 | — | `TV-NNN` | | LcSerializable round-trip; Serialized::Constructor form |
| BC-2.19.002 | SS-19 | 4 | — | `TV-NNN` | | lc_secrets() strips credential fields before serialization |
| BC-2.19.003 | SS-19 | 4 | — | `TV-NNN` | | Inventory-based type registry; OnceLock allowlist |
| BC-2.19.004 | SS-19 | 4 | — | `TV-NNN` | | Legacy namespace remap; OLD_CORE_NAMESPACES_MAPPING aliases |
| BC-2.19.005 | SS-19 | 4 | — | `TV-NNN` | **RG** | Reviver allowlist containment — unregistered id → E-SRLZ-001 (VP-010) |
| BC-2.19.006 | SS-19 | 4 | — | `TV-NNN` | | Langchain-monolith type ids → E-SRLZ-002 (not silent None) |
| BC-2.20.001 | SS-20 | 3 | — | `TV-NNN` | | Retriever trait; get_relevant_documents dyn-compatible; Arc<dyn Retriever> |
| BC-2.20.002 | SS-20 | 3 | — | `TV-NNN` | **RG** | BoundaryType::RAGRetrieval guardrail covers all Retriever returns (DI-012) |
| BC-2.20.003 | SS-20 | 5 | — | `TV-NNN` | | VectorStoreRetriever; SearchType; k/fetch_k/lambda_mult config; as_retriever() |
| BC-2.21.001 | SS-21 | 5 | — | `TV-NNN` | | VectorStore trait; VectorStoreFactory; Arc<dyn VectorStore> dyn-safety |
| BC-2.21.002 | SS-21 | 7 | — | `TV-NNN` | (v1.1 adds TV-006) | InMemoryVectorStore; Arc<dyn Embeddings> DI; cosine similarity; write-time zero-norm guard E-VS-004 |
| BC-2.21.003 | SS-21 | 6 | — | `TV-NNN` | **RG** | Zero-norm guard — cosine denominator → E-VS-001 before division (VP-009); (v1.7 adds TV-006 overflow-norm guard) |
| BC-2.21.004 | SS-21 | 5 | — | `TV-NNN` | | MetadataFilter Eq/Ne/In; similarity_search_with_filter; #[non_exhaustive] |
| BC-2.22.001 | SS-22 | 5 | — | `TV-NNN` | | Embeddings trait; embed_documents batch; dimensionality contract → E-EMBED-001 (VP-008) |
| BC-2.22.002 | SS-22 | 7 | — | `TV-NNN` | **RG** | EmbeddingsOpenAI; OpenAiApiKey redacted-Debug credential opacity (DI-010) |
| BC-2.22.003 | SS-22 | 5 | — | `TV-NNN` | | EmbeddingsOllama; no API key; POST /api/embed; use_legacy_endpoint toggle |
| BC-2.23.001 | SS-23 | 5 | — | `TV-NNN` | | ReadFileTool — PathGuard-confined file read; 1 MiB max_bytes; E-TOOLS-001/002 |
| BC-2.23.002 | SS-23 | 5 | — | `TV-NNN` | | WriteFileTool — PathGuard-confined atomic write; High ActionRisk; E-TOOLS-001 |
| BC-2.23.003 | SS-23 | 6 | — | `TV-NNN` | | EditFileTool — exact-match string replace; E-TOOLS-003 on no-match; opt-in fuzzy fallback |
| BC-2.23.004 | SS-23 | 4 | — | `TV-NNN` | | ListDirTool — PathGuard-confined directory listing; ReadOnly; DirEntry struct; E-TOOLS-001 |
| BC-2.23.005 | SS-23 | 8 | — | `TV-NNN` | | BashTool — sandboxed shell; non-lowerable Medium risk floor; 256 KiB cap; 30 s timeout (VP-013 Kani seed) |
| BC-2.23.006 | SS-23 | 6 | — | `TV-NNN` | | GrepTool — in-process regex; linear-time `regex`; max_results 100 cap; PathGuard scope; E-TOOLS-001/006/008/009 (TV-006 traversal I/O error) |

**Total vectors (150 authored BCs):** 841 canonical test vectors (TV Count column) + 11 golden test vectors (GTV Count column, BC-2.07.002 only) = **852 total vectors** across 150 BC files. (D-356 SS-24 dev-console BCs BC-2.24.001..008 contributed +46 canonical TVs; BC-2.11.007 contributed +5 canonical TVs; 10 new BCs since v3.25 round-63.)

> **Ground-truth validation requirement:** The declared total above MUST equal the sum of TV Count values parsed from individual BC body files under `behavioral-contracts/ss-NN/BC-S.SS.NNN.md §Canonical Test Vectors`, counted as data rows with `^| TV-` prefix. A validator that only checks column arithmetic (sum of TV Count column == declared total) satisfies an internal identity, not a ground-truth comparison, and will not detect drift between BC bodies and this registry. The correct check is: `sum(BC body TV counts)` == `registry declared canonical total`. devops-engineer must implement this as a blocking gate before Phase 3.

> **GTV convention:** The TV Count column counts standard canonical vectors; the GTV Count column counts golden test vectors (Red Gate acceptance data reproduced in §Golden Test Vectors — BC-2.07.002). Grand totals are expressed as `<TV Count> + <GTV Count> = <total>` to prevent ambiguity.

**Red Gate BCs (11):** BC-2.02.003, BC-2.02.004, BC-2.07.002, BC-2.09.004, BC-2.09.005, BC-2.18.004, BC-2.18.005, BC-2.19.005, BC-2.20.002, BC-2.21.003, BC-2.22.002

---

## Per-Subsystem Test Vectors

> **Index model:** Canonical per-BC vectors reside in individual BC files under
> `behavioral-contracts/ss-NN/BC-S.SS.NNN.md`. The inventory table above is the
> authoritative index. Per-subsystem inline vector tables are not duplicated here —
> see each BC file's `## Test Vectors` section for the full `TV-NNN` rows.

Canonical per-BC vector tables reside in the individual BC files
(`behavioral-contracts/ss-NN/BC-S.SS.NNN.md §Canonical Test Vectors`). No inline per-subsystem
duplication exists in this supplement by design — the BC Test Vector Inventory table above
is the authoritative index. To inspect a specific BC's vectors, load the corresponding BC file.

---

## Cross-Subsystem Integration Vectors

> Integration scenarios that span multiple subsystems. These are not covered by
> individual BC files and require end-to-end test composition.

Cross-subsystem integration scenarios are authored by the test-writer at Phase 3 from the
wave schedule (`stories/STORY-INDEX.md`). This section is populated during Phase 3 story
delivery; no integration vectors exist at Phase 1a by design.

---

## Golden File References

> Pointers to golden test data files on disk. BC-2.07.002 GTVs are reproduced
> inline in §Golden Test Vectors below; this table references persistent fixture
> files when they exist.

| Vector Set | File | Format | BC Coverage |
|-----------|------|--------|------------|
| Non-ASCII splitter parity | `tests/fixtures/splitter_golden.toml` (created at Phase 3) | TOML | BC-2.07.002 |

---

## Golden Test Vectors — BC-2.07.002 (Non-ASCII Boundary Parity)

> **Source of truth:** `behavioral-contracts/ss-07/BC-2.07.002.md §Golden Test Vectors`
> These GTVs are reproduced here as a convenience for the test-writer.
> The BC file is authoritative; this section is a read-only copy.
>
> **Red Gate requirement:** `tests/red_gate/test_BC_2_07_002_python_parity.rs` must be
> committed and FAILING before any splitter implementation code is written (D17-Q9).
>
> **Reference implementation:** `langchain_text_splitters.RecursiveCharacterTextSplitter`
> with `separators=["\n\n", "\n", " ", ""]` and `length_function=len` (code-point counts).

### Group 1: Emoji (U+1F600 family, 4 bytes each in UTF-8)

| GTV ID | Input | chunk_size | overlap | Expected Chunks |
|--------|-------|------------|---------|-----------------|
| GTV-001 | `"😀😃😄😁😆"` (5 emoji = 5 code pts, 20 bytes) | 3 | 0 | `["😀😃😄", "😁😆"]` |
| GTV-002 | `"😀😃😄😁😆"` (5 emoji) | 3 | 1 | `["😀😃😄", "😄😁😆"]` |
| GTV-003 | `"hello 😀 world"` (13 code pts) | 7 | 0 | `["hello 😀", "world"]` (Python-verified; prior value `["hello", "😀 world"]` was wrong — splitter merges "hello"+" "+"😀" = 7 code pts into chunk 1) |
| GTV-004 | `"😀" * 100` (100 emoji, 400 bytes) | 10 | 0 | 10 chunks of 10 emoji each |

### Group 2: CJK Unified Ideographs (U+4E00–U+9FFF, 3 bytes each in UTF-8)

| GTV ID | Input | chunk_size | overlap | Expected Chunks |
|--------|-------|------------|---------|-----------------|
| GTV-005 | `"中文测试内容"` (6 CJK = 6 code pts, 18 bytes) | 3 | 0 | `["中文测", "试内容"]` |
| GTV-006 | `"中文测试内容"` (6 CJK) | 3 | 1 | `["中文测", "测试内", "内容"]` |
| GTV-007 | `"a中b文c"` (5 code pts: 1+1+1+1+1) | 3 | 0 | `["a中b", "文c"]` |

### Group 3: Mixed ASCII and Multi-Byte

| GTV ID | Input | chunk_size | overlap | Expected Chunks |
|--------|-------|------------|---------|-----------------|
| GTV-008 | `"abc" + "🎉" * 5 + "xyz"` (3+5+3=11 code pts) | 5 | 0 | `["abc🎉🎉", "🎉🎉🎉xy", "z"]` (Python-verified; prior PROVISIONAL value `["abc🎉🎉", "🎉🎉🎉x", "yz"]` was wrong) |
| GTV-009 | `"ñoño"` (4 code pts: ñ=U+00F1, o, ñ, o — 2 bytes each for ñ) | 2 | 0 | `["ño", "ño"]` |

### Group 4: Combining Sequences and ZWJ Emoji (Grapheme-Cluster Discriminators)

> These vectors are specifically designed so that a Rust implementation using
> `unicode-segmentation graphemes()` for length measurement would produce **different**
> output than the correct code-point-counting reference. Each row states the wrong
> (grapheme-aware) output so the discriminating power is explicit.

| GTV ID | Input | chunk_size | overlap | Expected Chunks |
|--------|-------|------------|---------|-----------------|
| GTV-010 | `"abcéxyz"` (NFD é = e + U+0301 combining acute: 2 code pts, 1 grapheme; total 8 code pts, 7 graphemes) | 4 | 0 | `["abce", "́xyz"]` — code-point boundary 4 falls between e and its combining accent, orphaning U+0301 into chunk 2. **Wrong (grapheme):** `["abcé", "xyz"]` — a grapheme-aware impl keeps é intact (5 code pts in chunk 1 vs correct 4). Python-verified. |
| GTV-011 | `"👨‍👩‍👧‍👦 hi"` (ZWJ family: U+1F468+ZWJ+U+1F469+ZWJ+U+1F467+ZWJ+U+1F466 = 7 code pts, 1 grapheme; total 10 code pts, 4 graphemes) | 4 | 0 | `["👨‍👩‍", "👧‍👦", "hi"]` — ZWJ sequence split at code-point boundary 4 → 3 chunks. **Wrong (grapheme):** `["👨‍👩‍👧‍👦", "hi"]` — a grapheme-aware impl treats ZWJ sequence as 1 grapheme (≤ chunk_size=4), producing 2 chunks instead of 3. Python-verified. |

> **Note (burst-249/2026-07-24 + burst-253/2026-07-24):** GTV-003 and GTV-008 were **Python-verified** in
> burst-249 against the pinned corpus (`langchain-text-splitters==1.1.2` in-tree at `langchain==1.3.13`
> SHA `42f8f79293cfb7589e5bc1d74a8ae4dfd0bf15e3`). Both PROVISIONAL markers removed.
> GTV-008 correction: `["abc🎉🎉", "🎉🎉🎉x", "yz"]` → `["abc🎉🎉", "🎉🎉🎉xy", "z"]`.
> GTV-003 correction: `["hello", "😀 world"]` → `["hello 😀", "world"]`.
> GTV-010 and GTV-011 added in burst-253 as grapheme-cluster discriminators — Python-verified
> against same pinned corpus.
> All 11 GTVs are now verified; the test-writer may author Red Gate tests directly from this table.
> Authoritative source: BC-2.07.002 §Golden Test Vectors.

---

## Red Gate Vector Summary

| BC ID | Red Gate Test File | D17 Source | Test Must FAIL Before |
|-------|-------------------|-----------|----------------------|
| BC-2.02.003 | `tests/red_gate/test_BC_2_02_003_named_barrier.rs` | R10 | NamedBarrierValue implementation |
| BC-2.02.004 | `tests/red_gate/test_BC_2_02_004_ephemeral_value.rs` | R10 | EphemeralValue implementation |
| BC-2.07.002 | `tests/red_gate/test_BC_2_07_002_python_parity.rs` | R8 | pregolya-splitters implementation |
| BC-2.09.004 | `tests/red_gate/test_BC_2_09_004_tool_exception.rs` | R11 | pregolya-mcp ToolException impl |
| BC-2.09.005 | `tests/red_gate/test_BC_2_09_005_no_live_connections.rs` | R11 | MultiServerMcpClient impl |
| BC-2.18.004 | `tests/red_gate/test_BC_2_18_004_injection_guard.rs` | ADR-015 Decision 3 §Security Invariant 1 | injection_guard impl in pregolya-prompts |
| BC-2.18.005 | `tests/red_gate/test_BC_2_18_005_trustall_rejection.rs` | ADR-015 Decision 2 §Security Invariant 2 | from_messages() SlotTrustPolicy guard in pregolya-prompts |
| BC-2.19.005 | `tests/red_gate/test_BC_2_19_005_reviver_allowlist.rs` | ADR-016 Decision 3 §Security Invariant | Reviver::revive() in pregolya-core |
| BC-2.20.002 | `tests/red_gate/test_BC_2_20_002_rag_guardrail.rs` | ADR-014 §Decision 6 — GuardedDocuments Typed Wrapper (DI-012 Mechanization) | Retriever guardrail wiring in pregolya-graph |
| BC-2.21.003 | `tests/red_gate/test_BC_2_21_003_zero_norm_guard.rs` | ADR-014 Decision 2 §Hardening note | cosine similarity impl in pregolya-vectorstores |
| BC-2.22.002 | `tests/red_gate/test_BC_2_22_002_credential_opacity.rs` | DI-010 Credential Opacity | EmbeddingsOpenAI::new() credential impl in pregolya-openai |

---

## Usage Notes for test-writer

1. **Happy-path minimum:** Each BC has at least one happy-path vector. Start there.
2. **GTV discipline (BC-2.07.002):** Do not author the GTV-based tests until you have
   run the reference Python implementation to verify GTV-003 and GTV-008. Use
   `langchain-text-splitters==1.1.2` (in-tree at `langchain==1.3.13` SHA `42f8f79293cfb7589e5bc1d74a8ae4dfd0bf15e3` per `.factory/semport/reference-manifest.md`; standalone `langchain-text-splitters==0.3.8` cited in earlier BC versions is superseded by this in-tree pin).
3. **Table (unlabelled) format (SS-04, SS-11, SS-13):** Test vectors in these BCs use
   markdown tables with `| Input | Expected Output | Category |` columns but without
   `TV-NNN` row identifiers (contrast with `TV-NNN` tables in SS-01–SS-03, SS-05–SS-10,
   SS-12, SS-14–SS-17). The header row is NOT a test vector — TV Count in the inventory
   above counts data rows only. Translate each data row into a test scenario following
   the naming convention: `test_BC_S_SS_NNN_<short_description>`.
4. **Integration tests:** BCs marked `I` in the PRD RTM Test Types column require a
   running pregolya instance or mock. Structure these under `tests/integration/`.
5. **Soak tests:** BCs marked `S` (BC-2.04.001, BC-2.04.005, BC-2.06.003, BC-2.12.007)
   require sustained execution; put them under a `#[ignore]` soak feature flag.

---

## Changelog

> **Historical record — superseded by frontmatter `changelog:` (Form A).**
> The frontmatter `changelog:` YAML list above is the **authoritative** changelog for this file.

| Version | Date | Change | Source |
|---------|------|--------|--------|
| 3.25 | 2026-09-01 | round-63/D-341: BC-2.04.009 TV count 6→7 (+TV-007 AES-GCM auth failure during conflict-detection decrypt → E-TRAJ-006; BC-local EC-006; F-P2A235-05). SS-04 subtotal +1. Grand total 794→795 canonical + 11 GTV = 806. | round-63 D-341 |
| 3.24 | 2026-08-31 | round-52/F-P2A216-02+F-P2A217-01+F-P2A216-01+F-P2A219-01: BC-2.04.009 TV count 4→6 (+TV-005 encryption idempotency no-false-E-TRAJ-002; +TV-006 encryption conflict E-TRAJ-002). BC-2.04.011 TV count 5→4 (TV-003 removed: E-TRAJ-004 structurally unreachable). Net +1. Grand total 793→794 canonical + 11 GTV = 805. | round-52 F-P2A216-02+F-P2A217-01+F-P2A216-01+F-P2A219-01 |
| 3.23 | 2026-08-31 | round-50/D-328: BC-2.04.009 TV count 3→4 (+TV-004 at-rest EncryptedSerializer plaintext-not-observable; CWE-311; F-P2A209-01). SS-04 subtotal +1. Grand total 792→793 canonical + 11 GTV = 804. | round-50/D-328 |
| 3.22 | 2026-08-31 | ADR-030-Stage2b: PromoteRetireChannel BC renumbered SS-04→SS-02 (BC-2.02.009, +4 TVs). New BC-2.04.011 (SS-04, +5 TVs): Trajectory Compaction Isolation. Grand total 787→792 canonical + 11 GTV = 803. BC count 139→140. | ADR-030-Stage2b |
| 3.21 | 2026-08-31 | ADR-030-Stage2a: 5 new CAP-040 BC inventory rows added. BC-2.02.007 (+4 TVs), BC-2.02.008 (+3 TVs), BC-2.04.009 (+3 TVs), BC-2.04.010 (+3 TVs), BC-2.04.011 (+4 TVs). Grand total 770→787 canonical + 11 GTV = 798. BC count 134→139. | ADR-030-Stage2a |
| 3.20 | 2026-08-31 | round-49/F-P2A205-01+F-P2A205-02: BC-2.09.007 TV count 10→13 (+TV-011 step-3 UUID sanitize_internal_ids; +TV-012 URL-userinfo pattern 5; +TV-013 Basic-auth pattern 6). SS-09 subtotal 69→72. Grand total 767→770 canonical + 11 GTV = 781. | round-49 F-P2A205-01+F-P2A205-02 |
| 3.19 | 2026-08-30 | round-48/F-P2A203-02+F-P2A201-01: BC-2.09.007 TV count 9→10 (+TV-010 Bearer-token pattern in redact_credentials canonical sanitizer; CWE-522). BC-2.12.007 TV count 6→9 (+TV-007/008/009 SSE boundary SEC-BOUND-001 3rd external boundary). SS-09 subtotal 68→69. SS-12 subtotal 57→60. Grand total 763→767 canonical + 11 GTV = 778. | round-48 F-P2A203-02+F-P2A201-01 |
| 3.18 | 2026-08-30 | round-47/F-P2A197-01+F-P2A197-02: BC-2.12.003 TV count 11→13 (+TV-012 E-GRAPH-011 conditional-edge panic→static "internal error"+source_node suppressed {INV-007}; +TV-013 credential-in-Run.error.message→redact_credentials 3-step pipeline {INV-008}; both CWE-209/532). SS-12 subtotal 55→57. Grand total 761→763 canonical + 11 GTV = 774. | round-47 F-P2A197-01+F-P2A197-02 |
| 3.17 | 2026-08-29 | round-42/F-P2A177-01+F-P2A179-01+F-P2A177-02: BC-2.09.008 TV count 18→19 (+TV-019 path_fn-panic E-GRAPH-011→static "internal error" at MCP boundary). BC-2.12.003 TV count 10→11 (+TV-011 node-body-panic→failed+E-GRAPH-019 STATIC message+no orphan in_progress). Grand total 759→761 canonical + 11 GTV = 772. | round-42 F-P2A177-01+F-P2A179-01+F-P2A177-02 |
| 3.16 | 2026-08-29 | round-40/F-P2A170-01: BC-2.09.008 inventory row TV Count cell corrected 17→18 (stale; census-row fix only; TV-018 minted in r39). Grand total UNCHANGED: 759 canonical + 11 GTV = 770. | round-40 F-P2A170-01 |
| 3.15 | 2026-08-29 | round-39/F-P2A165-01: BC-2.09.008 TV count 17→18 (+1 TV: TV-018 ForceApproveHooks ActionRisk gate pre-empts inner hook call — None/Some(>=Medium)→Deny+E-MCP-011 without calling inner hook; CWE-862 gate). Grand total 758→759 canonical + 11 GTV = 770. | round-39 F-P2A165-01 |
| 3.14 | 2026-08-28 | round-30/F-P2A129-01: BC-2.09.008 TV count 16→17 — TV-017 added (sanitize_internal_ids isolation) + TV-015 corrected to full-pipeline output "digest: <redacted>" (F-P2A129-01 [MED]). Grand total 757→758 canonical + 11 GTV = 769. | round-30 F-P2A129-01 |
| 3.13 | 2026-08-28 | round-28/GATE-READY-finding: Ground-truth reconciliation — column sum was 724 vs declared 754; body ground-truth 757 canonical. Corrected 21 stale BC rows (see frontmatter changelog for full list). Grand total 754→757 canonical + 11 GTV = 768. Note: v3.10 arithmetic error (+9 claimed / +6 recorded) now superseded. | round-28 GATE-READY |
| 3.12 | 2026-08-27 | round-19/F-P2A088-01: BC-2.09.008 TV count 12→13 (+TV-013 u64 CheckpointId NOT covered by sanitize_internal_ids framework pass; authoring-site convention sole guarantee per {INV-001}). Grand total 753→754 canonical + 11 GTV = 765. | round-19 F-P2A088-01 |
| 3.11 | 2026-08-26 | P2A-057-round-2/D-277: BC-2.09.008 TV count 11→12 (+TV-012 None/undeclared action_risk path, F-057-01 {INV-004} coverage). Grand total 752→753 canonical + 11 GTV = 764. | P2A-057 D-277 |
| 3.10 | 2026-08-26 | SEC-review-adjudication/D-276: BC-2.09.007 TV count 6→9; BC-2.09.008 TV count 7→11; BC-2.18.004 TV count 5→7 (TV-006 FewShotExamples Red Gate + TV-007 multi-pair VP-006-B proptest). Grand total 746→752 canonical + 11 GTV = 763. | SEC-review-adjudication D-276 |
| 3.9 | 2026-08-26 | GAP-01/D-275: BC-2.09.008 registered (7 TVs: state-isolation, interrupt fail-closed E-MCP-010, credential redaction, error propagation). Grand total 739→746 canonical + 11 GTV = 757. BC count 133→134. | GAP-01 D-275 |
| 3.8 | 2026-08-22 | P2A-037-gaps: BC-2.18.001 TV-008 added (Runnable invoke → PromptValue::String); TV count 7→8. BC-2.18.002 TV-005 added (ChatPromptTemplate Runnable invoke delegation); TV count 4→5. Grand total 701→703 canonical + 11 GTV = 714. | P2A-037-gaps |
| 3.7 | 2026-08-22 | F-036-01/D-244: BC-2.01.005 §PC-1 infallible amendment — EC-006 (duplicate-key last-write-wins) + TV-006 added; TV count 5→6. Grand total 700→701 canonical + 11 GTV = 712. | F-036-01/D-244 |
| 3.6 | 2026-08-22 | P2A-029-fix-burst/D-235: BC-2.09.001 §PC9 amendment — TV-009 (overflow Err/E-MCP-008) + TV-010 (unknown-server Err/E-MCP-009) added. TV count 8→10. Grand total 698→700 canonical + 11 GTV = 711. | P2A-029-fix-burst/D-235 |
| 3.5 | 2026-08-20 | P2A-005-fix-burst/D-212: BC-2.04.008 §Invariant-5 (EC-007 + TV-007) added — FtsEncryptionIncompatible construction-time guard. TV count 6→7. Grand total 697→698 canonical + 11 GTV = 709. | P2A-005-fix-burst/D-212 |
| 3.4 | 2026-08-17 | burst-302b/D-171: LCEL scope expansion — add 4 BC rows (BC-2.01.005: 5 TV, BC-2.01.006: 5 TV, BC-2.01.007: 5 TV, BC-2.01.008: 6 TV). Grand total 676→697 canonical + 11 GTV = 708. BC count 129→133. | burst-302b/D-171 |
| 3.3 | 2026-08-16 | burst-291/D-134: §-anchor phantom sweep — four phantom §GTV/§Test Vectors citations corrected. TV counts and grand totals UNCHANGED. | burst-291/D-134 |
| 3.2 | 2026-08-16 | burst-290/F-180-04: Fix live-body phantom ADR §-citation in Red Gate Vector Summary table. BC-2.20.002 row §Anchor column: `ADR-014 §DI-012` → `ADR-014 §Decision 6 — GuardedDocuments Typed Wrapper (DI-012 Mechanization)`. TV count and grand totals UNCHANGED. | burst-290/F-180-04 |
| 3.1 | 2026-08-15 | burst-288/F-P177-C-SS17: BC-2.17.001 Notes VP enumeration corrected — VP-001/002/003/009/010/011 (P0) + VP-006/012/013 (P1). TV count and grand totals UNCHANGED (687 = 676 canonical + 11 GTV). | burst-288 F-P177-C-SS17 |
| 3.0 | 2026-08-01 | fix-burst-287/F-P176-D001: Ground-truth reconciliation. 8 stale BC rows corrected: BC-2.03.001 (5→6), BC-2.09.001 (7→8), BC-2.12.002 (7→8), BC-2.15.004 (7→9), BC-2.15.006 (6→7), BC-2.17.001 (5→9), BC-2.18.001 (6→7), BC-2.18.004 (4→5). Grand total corrected: 664→676 canonical + 11 GTV = 675→687. BC-2.17.001 Notes updated. Ground-truth validation normative note added. | fix-burst-287 |
| 2.9 | 2026-07-28 | D-51-census: BC-2.21.003 TV count 5→6 (+TV-006 overflow-norm guard; EC-006 overflow case; BC-2.21.003 §Canonical Test Vectors v1.7 add). Grand total 674→675 (663→664 canonical + 11 GTV). Gate #28 resolved: v2.8 body table row backfilled. | D-51 |
| 2.8 | 2026-07-27 | fix-burst-276/F-P173-505: D-28 banner added to body ## Changelog section, declaring Form A (frontmatter changelog:) authoritative; body table preserved as historical record. | fix-burst-276/F-P173-505 |
| 2.7 | 2026-07-24 | F-P152-01/F-P152-03/burst-253: (1) F-P152-01: BC-2.10.005 TV count 5→6 (+TV-006 OnWatermark fraction=1.0 boundary, burst-252 add; v1.2 annotation). (2) F-P152-03: BC-2.07.002 GTV count 9→11 (+GTV-010 NFD combining discriminator, +GTV-011 ZWJ emoji discriminator; both Python-verified against pinned corpus). Group 4 added to §Golden Test Vectors. Grand total 671→674 (663 canonical + 11 GTV). | F-P152-01/F-P152-03 |
| 2.6 | 2026-07-24 | F-P148-03/F-P148-05/burst-249: Red Gate Vector Summary — de-pin ADR anchor labels: BC-2.18.004 'ADR-015 Security Invariant 1' → 'ADR-015 Decision 3 §Security Invariant 1'; BC-2.18.005 'ADR-015 Security Invariant 2' → 'ADR-015 Decision 2 §Security Invariant 2'; BC-2.19.005 'ADR-016 Security Invariant' → 'ADR-016 Decision 3 §Security Invariant'; BC-2.21.003 'ADR-014 v1.1 Hardening' → 'ADR-014 Decision 2 §Hardening note' (TD-VSDD-060 sibling sweep). Usage Notes §2 GTV discipline: splitter version langchain-text-splitters==0.3.8 → langchain-text-splitters==1.1.2 (in-tree at langchain==1.3.13 SHA 42f8f79). | F-P148-03 |
| 2.5 | 2026-07-23 | F-P142-03/burst-242: BC-2.06.005 Notes column — 'payload on Command::Resume' → 'payload on Command(resume=…)' per BC-2.05.004 struct kwarg authority. (Backfill: this row was recorded in frontmatter changelog only; body table now synced.) | F-P142-03 |
| 2.4 | 2026-07-22 | burst-235/F-P135-05: BC-2.13.002 TV count 4→5 (+kill-on-drop DI-015 co-enforcement TV). Grand total 670→671 (662 canonical + 9 GTV). | burst-235/F-P135-05 |
| 2.3 | 2026-07-22 | burst-234/F-P134-01: BC-2.23.006 TV count 5→6 (+TV-006 traversal I/O error, E-TOOLS-008 FileIoError). Grand total 669→670 (661 canonical + 9 GTV). Notes column updated to cite E-TOOLS-008/009. | burst-234/F-P134-01 |
| 2.2 | 2026-07-22 | D23: Add 13 new D23 BC rows (+60 TVs); grand total 609→669 (660 canonical + 9 GTV). New rows: BC-2.05.007 (6 TV, VP-011 Kani seed), BC-2.05.008 (4 TV), BC-2.06.004 (4 TV), BC-2.06.005 (3 TV), BC-2.06.006 (4 TV), BC-2.10.005 (5 TV, VP-012 Kani seed), BC-2.10.006 (4 TV), BC-2.23.001 (5 TV), BC-2.23.002 (5 TV), BC-2.23.003 (5 TV), BC-2.23.004 (4 TV), BC-2.23.005 (6 TV, VP-013 Kani seed), BC-2.23.006 (5 TV). BC count 116→129. | D23 |
| 2.1 | 2026-07-21 | F-P224/H-2: BC-2.21.002 v1.1 adds TV-006 (write-time zero-norm guard — add_texts returns Err(E-VS-004) when any document embedding has L2 norm == 0.0; document_index context field). BC-2.21.002 row: TV Count 5→6. SS-21 subtotal: 20→21 TVs (BC-2.21.001=5, BC-2.21.002=6, BC-2.21.003=5, BC-2.21.004=5). Grand total: 599→600 canonical TVs; 600+9 GTVs = 609 total vectors. | F-P224, H-2 |
| 2.0 | 2026-07-20 | D21/Batch-3b-ii: Added 21 new BC inventory rows (SS-18 BCs 2.18.001–005, SS-19 BCs 2.19.001–006, SS-20 BCs 2.20.001–003, SS-21 BCs 2.21.001–004, SS-22 BCs 2.22.001–003). SS-18 subtotal=22 TVs, SS-19=24, SS-20=11, SS-21=20, SS-22=15; total new canonical TVs=92. Grand total updated: 507→599 canonical TVs; 599+9 GTVs = 608 total vectors. Red Gate BCs updated from 5→11: added BC-2.18.004, BC-2.18.005, BC-2.19.005, BC-2.20.002, BC-2.21.003, BC-2.22.002 to Red Gate Vector Summary. | D21/ADR-014/015/016/017 |
| 1.9 | 2026-07-19 | F-P119-01 + OBS-1 + OBS-2, fix burst 122: BC-2.05.005 v1.4→v1.5 adds 3 canonical TVs (TV-006 summary_halt guard, TV-007 queued guard, TV-008 cancelled guard per OBS-1 production-grade totality adjudication). BC-2.05.005 row: TV Count 5→8; Notes updated to '(v1.5 adds TV-006/007/008)'. SS-05 subtotal 32→35. Grand total: 504→507 canonical TVs; 507+9 GTVs = 516 total vectors. | F-P119-01 |
| 1.8 | 2026-07-17 | F-P94-02: Convention verdict — renumber (option ii): TV-001b in BC-2.10.004 renamed TV-006, eliminating the corpus's only lettered sub-vector. BC-2.10.004 row: TV Count 5→6, Notes updated to "(v1.5 adds TV-006)". Recount from ground truth: SS-10 subtotal 22→23 (BC-2.10.001=5, BC-2.10.002=5, BC-2.10.003=7, BC-2.10.004=6). Grand total: 503→504 canonical TVs; 504+9 GTVs = 513 total vectors. BC-2.10.004 v1.4→v1.5. | F-P94-02 |
| 1.7 | 2026-07-16 | F-P86-01: replaced TODO markers with authoritative forward-reference text in two sections. Per-Subsystem Test Vectors: removed conditional TODO, replaced with authoritative statement that canonical per-BC vectors reside in individual BC files (`behavioral-contracts/ss-NN/BC-S.SS.NNN.md §Test Vectors`); no inline duplication by design. Cross-Subsystem Integration Vectors: removed empty placeholder table row, replaced with forward-reference statement that integration scenarios are authored by test-writer at Phase 3 from the wave schedule (`stories/STORY-INDEX.md`). Retroactive changelog note: v1.6 added three template-conformance sections (Per-Subsystem Test Vectors, Cross-Subsystem Integration Vectors, Golden File References) as structural stubs per template compliance; this was not recorded in the v1.6 changelog entry. | F-P86-01 |
| 1.6 | 2026-07-16 | F-P85-04 (MED): Grand-total reconciliation. Independent recount of TV Count column (95 rows, header excluded) yields 503 canonical test vectors (per-SS: SS-01=20, SS-02=33, SS-03=15, SS-04=35, SS-05=32, SS-06=15, SS-07=17, SS-08=71, SS-09=41, SS-10=22, SS-11=25, SS-12=47, SS-13=34, SS-14=30, SS-15=41, SS-16=15, SS-17=10). BC-2.07.002 GTV Count column = 9 golden test vectors (separate classification from canonical TVs). Convention established: 503 canonical TVs + 9 GTVs = 512 total vectors. Old total "approximately 516" replaced with exact reconciled figures. "approximately" hedge removed. v1.5 figure of 516 was carried forward from the v1.5 "534→516 (−18)" arithmetic without a fresh row-sum. Sibling-sweep: no other .factory/specs/ or .factory/planning/ documents cite 516 as a test-vector total. Stale "516" appears only in this file's grand-total line (fixed here) and in v1.5 changelog history (preserved). | F-P85-04 |
| 1.5 | 2026-07-15 | F-P84-01 + OBS-P84-A + OBS-P84-B (D18-P84-A): SS-11 counts corrected (header-row over-count): BC-2.11.001 5→4, BC-2.11.002 6→5, BC-2.11.003 5→4, BC-2.11.004 5→4, BC-2.11.005 5→4, BC-2.11.006 5→4. SS-04 same defect audited and corrected: BC-2.04.001/002/003/004/006/007 5→4 each (BC-2.04.005 was already correct at 5). SS-13 same defect audited and corrected: BC-2.13.001/002 5→4, BC-2.13.003/004/005/006 6→5. Format label "narrative" → "table (unlabelled)" for all 19 affected rows (SS-04 001–007, SS-11 001–006, SS-13 001–006) — these BCs use `\| Input \| Expected Output \| Category \|` tables without TV-NNN IDs, not prose narrative. Usage note 3 rewritten accordingly. Total updated 534→516 (−18). | F-P84-01, OBS-P84-A, OBS-P84-B |
| 1.4 | 2026-07-15 | F-P73-01: added 9 D20 BC inventory rows (BC-2.04.008, BC-2.08.013, BC-2.08.014, BC-2.09.006, BC-2.09.007, BC-2.13.007, BC-2.15.004, BC-2.15.005, BC-2.15.006) with live-derived vector counts; BC-2.10.003 TV count corrected 5→7 (v1.2 added TV-006/007 for OnCeiling::Summarize + RunContext.budget_info); total updated 86→95 BCs, ~475→~534 vectors; frontmatter input-hash annotation updated 86→95. | F-P73-01 |
| 1.3 | 2026-07-15 | F-P64-02 sweep fix: corrected v1.1 changelog row date `2026-07-16` → `2026-07-14` (same root cause as bc-authoring-plan.md v1.1; PASS-36 = 2026-07-14). No content change; metadata-only. (F-P64-02, ADV-P1D-PASS-64) | F-P64-02 |
| 1.2 | 2026-07-14 | GTV annotation sync (OBS-P37-2): GTV-003 Expected-cell parenthetical corrected to match BC-2.07.002.md authoritative text ("after separator split on space"); GTV-008 Input-cell code-point note corrected ("3+5+3=11 code pts"); GTV-009 Input-cell annotation corrected ("4 code pts: ñ=U+00F1, o, ñ, o — 2 bytes each for ñ"). All 9 GTV rows now byte-identical to BC-2.07.002.md including non-normative annotations (ADV-P1D-PASS-37) | OBS-P37-2 |
| 1.1 | 2026-07-14 | GTV-008 row synced to concrete value `["abc🎉🎉", "🎉🎉🎉x", "yz"]` with PROVISIONAL marker (was: placeholder); GTV-003/GTV-008 note updated to clarify PROVISIONAL semantics; removed contradictory "Do not hard-code these without verification" language (F-P36-03 fix, ADV-P1D-PASS-36) | F-P36-03 |
| 1.0 | 2026-07-13 | Initial authoring | Greenfield Phase 1a |
