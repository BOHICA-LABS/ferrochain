---
document_type: story-index
level: L3
version: "1.82"
status: active
producer: state-manager
timestamp: 2026-09-08T23:45:00Z
changelog:
  - "1.82 (D-356/DC-29/2026-09-08, state-manager): S-console-06 (story-writer; D8 completed-run sweep — run-read+evidence_journal?+trace spans; no StreamEvent replay per ADR-031 §Decision 8). S-console-09 (story-writer; D8 completed-run sweep). S-console-10 (story-writer; D8 completed-run sweep). BC-INDEX. ARCH-INDEX. L2-INDEX. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.81 (D-356/DC-28/2026-09-08, state-manager): S-console-05 v1.3 (story-writer; F-PDC28-01[LOW] — Token Budget Estimate table backfilled with BC-2.24.004 row (~300 tokens); total ~8,100→~8,400; POL-8 step 4: BC count matches len(behavioral_contracts)=2). ARCH-INDEX v1.80 (architect; F-PDC28-02[OBS] — DI-annotation uniformity: removed vestigial '; DI-004)' from VP-2.24.005-A/B description cells; all 20 SS-24 §VP rows now DI-annotation-free). verify-form-a-changelog-direction.sh PASS: FAIL=0 BC_UNVERIFIED=0. ZERO 0000000 remain. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.80 (D-356/DC-27/L-288/2026-09-08, state-manager): L-288 exhaustive semantic-coherence sweep of ALL 8 SS-24 BCs complete — 8 findings [F-L288-001..008] ALL CLOSED. BC-2.24.006 v1.6 (F-L288-001[HIGH] §Description 'new run stream'→'same run SSE stream (run_id unchanged)'). capabilities-p1-p2.md v1.35 (F-L288-002[MED] CAP-042 dotSrc→dot_src; F-L288-005[MED] CAP-046 'completed'→'terminal-status (finished)'). BC-2.24.007 v1.4 (F-L288-003[MED] INV-004 'completed'→'terminal-status (finished)'; F-L288-004[MED] §Related BCs BC-2.10.006 'completed-run'→'terminal-status (finished) run'). S-console-09 v1.1 (F-L288-006 — 7 sites 'completed'→'terminal-status'; test renamed evidence_journal_terminal_run). S-console-05 v1.2 (F-L288-007 — AC-005 trace corrected BC-2.24.001 INV-002→ADR-031 D3/BC-2.24.004 INV-002; BC-2.24.004 added to behavioral_contracts per POLICY-8). BC-2.24.002 v1.10 (F-L288-008[OBS] DC-04 blockquote Arc<Mutex<...>> SUPERSEDED-BY-DC-23 annotation). BC-2.24.004 v1.3 (reverse-anchor: §Story-Anchor +S-console-05; 4 of 8 SS-24 BCs verified fully coherent). Story-Inventory S-console-05 BCs column: BC-2.24.001→BC-2.24.001, BC-2.24.004. BC-to-Story map BC-2.24.004: S-console-06→S-console-05, S-console-06. BC-INDEX v4.41→v4.42. L2-INDEX v1.32→v1.33. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.79 (D-356/DC-25/2026-09-08, state-manager): S-console-08 v1.3 (story-writer; F-PDC25-01 sibling-sweep — AC-001/AC-002/Task-3b/EC-004/PSI corrected to terminal {\"__interrupt__\":[InterruptPayload]} frame model; zero node_name residue; zero no-dedicated-event over-correction residue). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.78 (D-356/DC-23/2026-09-08, state-manager): S-console-08 v1.2 (story-writer; F-PDC23-01[HIGH] — resume same-run per BC-2.12.003 canonical SAME-run_id; BC-2.24.006 PC-005/EC-006/TV-002/§Composes aligned). S-console-03 v1.4 (story-writer; F-PDC23-02[MED] — error envelope {code,message} per BC-2.24.002 v1.9/BC-2.24.003 v1.3). S-console-04 v1.3 (story-writer; F-PDC23-02[MED] — envelope {code,message}). All three changelogs ascending, version==last. OBS-DC05-01 RESOLVED-BY-DC-23. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.77 (D-356/DC-19/2026-09-08, state-manager): VP-2.24.003-C Crate cell corrected pregolya-server→pregolya-graph in §VP-to-Story-Anchor-Map (architect re-anchored VP-2.24.003-C to graph::descriptor/pregolya-graph per BC-2.24.003 §VP property table — 'start node always present in descriptor', unit/phase-3; VP-INDEX §VP-Catalog v1.50 source of truth). VP-2.24.003-B confirmed pregolya-graph (no change needed). sprint-state.yaml unchanged (S-console-04 crate list [pregolya-graph, pregolya-server] correct — both crates still apply to story). S-console-04 v1.2 (story-writer; DC-19 F-PDC19-02 — stale v1.1 changelog claim 'VP-2.24.003-C is pregolya-server' corrected to pregolya-graph; AC-007 already correct; VP-2.24.003-B Kani/phase-6 correctly needs no Phase-3 AC). L-285 codified: BC §VP-property ↔ VP-harness/description/module semantic-coherence sub-check missing from byte-agreement consistency checks. input-hash: fc84e85 (VP-INDEX §VP-Catalog v1.50). ZERO 0000000 remain. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.76 (D-356/DC-18/2026-09-08, state-manager): S-console-01 v1.1 (story-writer; DC-18 F-PDC18-01[HIGH] — frontmatter changelog reordered strict ascending [1.0, 1.1]; input-hash 1e04879→8fe60e4; pure reorder, no content change). S-console-04 v1.1 (story-writer; DC-18 F-PDC18-01[HIGH] — frontmatter changelog reordered strict ascending [1.0, 1.1]; input-hash 0b706dc→5ca2a1f; pure reorder, no content change). epics.md v1.9 (story-writer; DC-18 F-PDC18-02[MED] — v1.9 body changelog entry added at TOP documenting DC-10+DC-11 dep-inversion + sub-wave restructure 3A-3F→3A-3E; descending-class body changelog, version==first confirmed). verify-form-a-changelog-direction.sh FAIL=0 BC_UNVERIFIED=0 perimeter-wide confirmed. Input-hash: STORY-INDEX inputs not modified. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.75 (D-356/DC-16/2026-09-08, state-manager): S-1.26 v1.14→v1.15 (story-writer; F-PDC16-02 [LOW, records] — frontmatter changelog reordered to strict ascending (1.1→1.15); v1.13 entry backfilled from body table verbatim (round-79/F-P2A251-02 wording)). BC-to-Story map BC-2.12.003 row updated: S-1.26→S-1.26 + S-console-07 (roadmap, Wave 3 — consumes {INV-009} fork-start via BC-2.24.005 {PC-003}). Input-hash: 5e6586a (S-1.26 current hash; no other index inputs modified). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.74 (D-356/DC-15/2026-09-08, state-manager): S-console-04 v1.0→v1.1 (story-writer; F-PDC15-01 [MED] — target_module scalar `pregolya-server`→list `[pregolya-graph, pregolya-server]`; third-carrier completion of DC-14 crate-drift fix; story-inventory row + sprint-state.yaml were already corrected in DC-14; story frontmatter now aligned; all three crate carriers consistent). input-hash: 34034c0 UNCHANGED (index inputs not modified). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.73 (D-356/DC-14/2026-09-08, state-manager): F-PDC14-01 [MED] — S-console-04 crate corrected pregolya-console→[pregolya-graph, pregolya-server] in §Story-Inventory row (Target Crate column) and sprint-state.yaml (crate: field); story builds graph::descriptor (pregolya-graph; VP-2.24.003-A/B) + GET /assistants/{id}/graph endpoint (pregolya-server; VP-2.24.003-C); ZERO pregolya-console footprint per §File Structure. F-PDC14-02 [MED] — §Wave-3 blockquote blanket claim 'All 10 Wave-3 stories target pregolya-console' reworded — S-console-03 (pregolya-server) + S-console-04 (pregolya-graph + pregolya-server) explicitly excepted. BC-INDEX v4.34→v4.35 (F-PDC14-03 BC-2.24.002 v1.7→v1.8 TV-006 canonical redaction). Input-hash: f963961→34034c0 (BC-INDEX updated). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.72 (D-356/DC-13/2026-09-08, state-manager): F-PDC13-02 [MED] — S-1.26 v1.13→v1.14 (story-writer; AC-021 added for BC-2.12.001 {PC-015} checkpoint historical-state read with TV-010 + EC-010/422; AC-022 added for BC-2.12.003 {INV-009} fork-start with TV-014 + EC-008/422; EC-022 E-CHKPT-011 on ?checkpoint_id read absent; EC-023 E-CHKPT-011 on fork ?checkpoint_id absent; input-hash 23d15a2). F-PDC13-01 [MED] — sprint-state.yaml S-console-05 vps [VP-2.24.001-A]→[] (VP-2.24.001-A anchors S-console-01 ONLY per dependency-graph VP-to-Stories matrix and VP-INDEX; double-assignment removed). F-PDC13-03 [LOW, adjudicated=populate-all] — sprint-state.yaml depends_on populated for all console stories with edges: S-console-04 [S-console-03]; S-console-05 [S-console-01]; S-console-06 [S-console-03, S-console-04, S-console-05]; S-console-07 [S-console-05]; S-console-08 [S-console-06]; S-console-09 [S-console-06]; S-console-10 [S-console-06] (dependency-graph.md v2.3 authoritative source; acyclicity unchanged — no new edges; DAG confirmed). sprint-state.yaml input-hash 788aace→8f01c71. STORY-INDEX input-hash: f963961 UNCHANGED (index inputs not modified). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.71 (D-356/DC-12/2026-09-07, state-manager): S-console-01 v1.0→v1.1 (story-writer; F-PDC12-01: blocks list updated [S-console-02, S-console-05]→[S-console-02, S-console-03, S-console-05] — reverse-edge for S-console-03.depends_on [S-console-01]; input-hash 94119d2→1e04879). dependency-graph.md v2.2→v2.3 (story-writer; S-console-01 blocks entry updated to include S-console-03; acyclicity re-confirmed; DAG holds). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.70 (D-356/DC-11/2026-09-07, state-manager): S-console-02 v1.2→v1.3 (story-writer; F-PDC11-01: dep-inversion sweep — depends_on [S-console-01]→[S-console-01, S-console-03]; Arc<dyn DebugSpanSource> injection; compile-fail test relocated to S-console-03; SpanData row removed from Architecture Mapping). S-console-03 v1.2→v1.3 (story-writer; F-PDC11-02: build-owner of server::debug_span; depends_on [S-console-02]→[S-console-01]; blocks [S-console-02, S-console-04, S-console-06]; debug_span.rs CREATE task added; compile-fail gate relocated here; PSI corrected). dependency-graph.md v2.1→v2.2 (story-writer; edge flip S-console-03→S-console-02; acyclicity re-confirmed; sub-waves 3A–3E). epics.md v1.8→v1.9 (story-writer; Wave-3 dep-inversion description + sub-wave table). BC-2.24.002 v1.6→v1.7 (product-owner; VP-2.24.002-C annotation corrected server::debug_routes only; server::debug_span →  'no dedicated VP; exercised via VP-2.24.002-C/D'). story-inventory S-console-02 depends_on updated + S-console-03 depends_on updated + S-console-03 Target Crate pregolya-console→pregolya-server. L-283 codified (BC sibling-sweep blast radius). Input hashes: S-console-02 e14e9b1; S-console-03 fcf62aa. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.69 (D-356/DC-10/2026-09-07, state-manager): S-console-03 v1.1→v1.2 (story-writer; F-PDC10-02: dependency inversion per ADR-031 Decision 7 — Arc<dyn DebugSpanSource> DI; server::debug_span own-module replaces pregolya-console path dep; AC-001/AC-002/AC-008/Task 5 updated). S-console-06 v1.2→v1.3 (story-writer; F-PDC10-03 records: inline superseded-marker appended to DC-01 blockquote flagging graph_interrupt as phantom → DC-02 correction). dependency-graph.md v2.0→v2.1 (story-writer; no-cycle explanation updated to dependency-inversion; F-PDC10-04 (v1.47) version-pin removed). Input hashes: S-console-03 2d81652; S-console-06 1358551. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.68 (D-356/DC-09 fix-burst/2026-09-07, state-manager): S-console-07 v1.1→v1.2 (story-writer; F-PDC09-01 BC-2.12.001 BC-table Title cell corrected to canonical H1 'Thread Resource CRUD (Create, Read, List, Delete Durable Conversation History)' per POL-7/L-276 verbatim-H1 rule; consumed-slice scope note (?checkpoint_id PC-015 variant) preserved in AC-002/AC-007 body prose). input-hash unchanged (STORY-INDEX inputs not modified). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.67 (D-356/DC-07-residue/2026-09-07, state-manager): STORY-S-console-03 v1.0→v1.1 (story-writer; F-PDC07-01 residual: debug_api_key→debug_route_key in ×3 live-body sites — AC-005, Task 7, Architecture Compliance Rules; AC-005 updated to cover both behaviours per BC-2.24.002 PC-007/EC-007: E-SERVER-013 InvalidDebugRouteKey startup-refusal + E-SERVER-004 DebugRouteUnauthorized runtime-403). input-hash 718d986. Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.66 (D-356/DC-06-sweep fix-burst/2026-09-07, state-manager): F3–F6 [MED] — §VP-to-Story-Anchor-Map Crate column corrected for 4 rows: VP-2.24.002-C pregolya-console→pregolya-server (server::debug_routes per VP-INDEX §VP-Catalog); VP-2.24.003-A pregolya-console→pregolya-graph (graph::descriptor per VP-INDEX §VP-Catalog); VP-2.24.003-B pregolya-console→pregolya-graph (graph::descriptor Kani per VP-INDEX §VP-Catalog); VP-2.24.003-C pregolya-console→pregolya-server (server::debug_routes per VP-INDEX §VP-Catalog). Story column was already correct for all 4 rows. input-hash refreshed (VP-INDEX §VP-Catalog updated). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41."
  - "1.65 (D-356/DC-06 fix-burst/2026-09-07, state-manager): F-PDC06-02 [MED] — VP-to-Story Anchor Map VP-2.24.002-D row added after VP-2.24.002-C (SS-24 block now 20 VP rows). dependency-graph.md v2.0 noted (D-356/DC-06 SS-24 VP-to-Stories matrix 20 rows byte-matched VP-INDEX v1.47; VP-2.24.002-D row added; sync-pending marker retired). prd.md v1.34 noted (D-356/DC-06 BC-2.24.008 catalog row boundary_type→boundary F-PDC06-03 site 2). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 41."
  - "1.64 (D-356/DC-04 fix-burst/2026-09-07, state-manager): S-console-07 v1.1 (story-writer; F-PDC04-01 u64 checkpoint_id; F-PDC04-02 BC-2.12.001 {PC-015} v1.11 + E-CHKPT-011 EC-010; POLICY-8 behavioral_contracts [BC-2.24.005]→[BC-2.24.005, BC-2.12.001]). S-console-07 Story-Inventory BCs column updated: BC-2.24.005→BC-2.24.005 + BC-2.12.001 (POLICY-8 hard gate — legitimate override). BC-to-Story map BC-2.12.001 row: S-1.26→S-1.26 + S-console-07 (roadmap, Wave 3; consumes ?checkpoint_id PC-015 variant). Version bumps: BC-2.24.005 v1.2, BC-2.12.001 v1.11, BC-2.24.008 v1.4, BC-2.24.002 v1.3. error-taxonomy v1.74 (E-CHKPT-011 second raise site + E-SERVER-004 msg correction). Input hashes: ADR-031 00c95fd, vcm 82e8ad9, purity-boundary-map 83d67fc. Story/pts UNCHANGED: 52 / 372. Census: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.63 (D-356/DC-03 fix-burst/2026-09-07, state-manager): S-console-10 v1.1 (story-writer sibling-sweep corrections; F-PDC03-01/03/04 BC-2.24.008 updates propagated). BC-2.24.005 v1.1 (F-PDC03-02 fork mechanism). BC-2.12.003 v1.20 (supporting; E-CHKPT-011 registered). EC 143→145 (E-CHKPT-011 CheckpointNotFound + E-SERVER-023 gap fix). Census: stories 52 / pts 372 / BCs 148 / VPs 41 / EC 145."
  - "1.62 (D-356/DC-02 fix-burst/2026-09-07, state-manager): F-PDC02-06 [LOW records] — v1.61 entry description corrected: 'LLM tool-call type list' → 'StreamEvent variant list' (those 16 are StreamEvent variants per BC-2.06.001 §PC-002, not LLM tool-call types). VP census updated: VPs 40→41 (VP-2.24.002-D registered by architect). Census: stories 52 / pts 372 / BCs 148 / VPs 41."
  - "1.61 (D-356/DC-01 fix-burst/2026-09-06, state-manager): STORY-S-console-06 v1.0→v1.1 (story-writer): AC-001 corrected to canonical 16-variant StreamEvent variant list (F-PDC01-04). Census UNCHANGED: stories 52 / pts 372 / BCs 148 / VPs 40."
  - "1.60 (D-356/2026-09-06): SS-24 Developer Console registered — Wave 3 ROADMAP-ONLY section added (10 stories: S-console-01..10; E-console epic; 56 pts; all P1; pregolya-console crate). BC-to-Story Coverage Map §SS-24 added (8 BCs: BC-2.24.001..008). VP-to-Story Anchor Map +19 rows (VP-2.24.001-A/B/C through VP-2.24.008-A/B). Census: stories 42→52 / pts 316→372 / BCs 140→148 / VPs 21→40 / product-epics 22→23 / total-epics 23→24 / stories-with-VP-anchor 15→25."
  - "1.59 (Phase-2-gate/D-354/2026-09-02): STORY-S-MAINT-001 v1.2→v1.3 (C-2 fix; story-writer; 9 live BC-corpus count references updated 134→140 to reflect final BC census; input-hash refreshed 9d09df5→21647fd; §Changelog v1.3 added). Phase-2 CONVERGED + gate APPROVED (D-354, 2026-09-02): 3/3 CLEAN(strict) on frozen anchor 81d16ca (P2A-252/253/254, rounds 80/81/82; axis-diverse: parity/semantics/completeness); consistency-validator PERIMETER-CONSISTENT; human gate APPROVED. 4 deferrals recorded: C-1 VP naming pre-Phase-6; PG-1 multi-anchor mirror hook pre-Phase-3-wave-close; PG-2 story-changelog machine-coverage hook; PG-3 BC H1 angle-bracket normalization pre-Phase-6. Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.58 (round-79 fix-burst/D-353/2026-09-02): Corpus-wide verbatim-H1 BC-table title sweep (story-writer; F-P2A251-02[LOW] ~30 spec files / ~90 title cells corrected to byte-exact BC canonical H1 per orchestrator Option A human-confirmed ruling). F-P2A251-01[LOW] S-1.09 NE-02 anchor mis-label corrected. Story version bumps: S-1.02→v1.2, S-1.07→v1.6, S-1.08→v1.4, S-1.09→v1.3, S-1.10→v1.4, S-1.11→v1.4, S-1.12→v1.3, S-1.13→v1.4, S-1.14→v1.8, S-1.15→v1.4, S-1.16→v1.2, S-1.17→v1.6, S-1.18→v1.3, S-1.19→v1.10, S-1.20→v1.4, S-1.21→v1.4, S-1.22→v1.3, S-1.23→v1.7, S-1.24→v1.7, S-1.25→v1.5, S-1.26→v1.13, S-1.27→v1.10, S-2.03→v1.7, S-2.04→v1.7, S-2.06→v1.11, S-2.07→v1.4, S-2.08→v1.3, S-2.09→v1.5, S-2.10→v1.6, S-6.01→v1.3. §Conventions note updated: verbatim-H1 is now enforced for story BC-table title cells corpus-wide (D-353; replaces former paraphrase convention). L-276 codified (3-part lesson). STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.57 (round-77 fix-burst/D-352/2026-09-02): dependency-graph.md §Changelog (v1.7→v1.8) (story-writer; F-P2A249-01[MED] VP-017 BC anchor corrected BC-2.02.007→BC-2.02.007 + BC-2.02.008 per VP-INDEX §VP Catalog dual-anchor form; F-P2A249-02[MED] VP-006-B Additional-Stories corrected S-6.01→— per S-6.01 frontmatter verification_properties exclusion; full 21-row VP-to-Stories Matrix re-derived from VP-INDEX source-of-truth; clause tags synced on VP-015/VP-016/VP-018/VP-006-B). dependency-graph.md input-hash 2dd0b6f→36ce19e. STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.56 (round-74 records-only micro-burst/D-351/2026-09-02): S-2.06 story v1.8→v1.9 (story-writer; F-P2A246-01[LOW] §Changelog entry 1.6 SS-14 parenthetical corrected from stale \"(Credential Safety)\" to canonical \"(Typed Error Taxonomy)\" per ARCH-INDEX Subsystem Registry SS-14 row; F-P2A246-02[LOW] §Behavioral Contracts BC-2.08.006 title cell corrected to byte-verbatim angle-bracket-escaped form per BC-2.08.006 canonical H1 (TD-RECORDS-MICRO-BURST-001 records-only micro-burst)). STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.55 (round-73 fix-burst/D-350/2026-09-02): S-2.06 story v1.7→v1.8 (story-writer; F-P2A245-01[HIGH] BC-2.08.006 BC-table title cell corrected to verbatim canonical H1 'Standalone SDK Crate Split Architecture (pregolya-<provider>-sdk + Adapter)' per POL-7/POL-8; F-P2A245-02[MED,process-gap] changelog entries reordered to strict ascending 1.1→1.8 sequence). S-2.06/BC-2.14.005 co-anchor downstream set verified CLEAN this pass (class closed). STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.54 (round-72 fix-burst/D-349/2026-09-02): S-2.06 Story-Inventory row Priority column P1→P0 (state-manager; F-P2A244-01[MED] — S-2.06 carries P0 BC BC-2.14.005 so derived priority is P0 not P1 per Story-Inventory header rule 'Priority = derived from highest-priority BC in story (P0 > P1 > P2)'; product-owner v1.6→v1.7 story frontmatter priority P1→P0; product-owner corpus-wide derived-priority sweep confirmed S-2.06 is the SOLE mismatch; all other story files (41 of 42) already correct). sprint-state.yaml S-2.06 priority P1→P0 (state-manager). STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.53 (round-70 fix-burst/D-348/2026-09-02): S-2.06 Story-Inventory row synced — BC column BC-2.08.006→BC-2.08.006, BC-2.14.005; Subsystem column SS-08→SS-08, SS-14 (state-manager; F-P2A242-01[HIGH] — multi-anchor BC-2.14.005 co-anchor propagation had not reached the Story-Inventory BC+Subsystem columns in the D-346/D-347 cascade; corpus-wide story sweep by story-writer confirmed no other story has this gap). S-2.06 v1.5→v1.6 (story-writer; subsystems [SS-08]→[SS-08, SS-14]; BC-2.14.005.md added to inputs; input-hash 521e8a7→33834e3). STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.52 (round-68 fix-burst/D-347/2026-09-02): S-2.06 §Changelog (1.4→1.5) (story-writer; F-P2A240-01[MED] — AC-006 test names corrected to traced-BC prefix convention: test_BC_2_08_006_api_key_debug_is_redacted → test_BC_2_14_005_api_key_debug_is_redacted; test_BC_2_08_006_api_key_no_display → test_BC_2_14_005_api_key_no_display; AC-006 traces to BC-2.14.005 PC-002 so test names carry BC-2.14.005 prefix per corpus naming convention; sibling sweep of .factory/ corpus confirmed no other spec artifact carried the old names). Story-writer re-applied to canonical .factory/stories/stories/ path after initial misfire to develop-tree stale copy. S-2.06 input-hash: 521e8a7 UNCHANGED (rename-only burst; BC input files not modified). STORY-INDEX input-hash: 0bcc4f8 UNCHANGED (index inputs not modified). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.51 (round-67 reconciliation/D-346/2026-09-02): BC-to-Story anchor map §SS-14 BC-2.14.005 row updated S-1.02→S-1.02, S-2.06 per product-owner adjudication Decision (a): BC-2.14.005 is a legitimate multi-anchor co-anchored to S-1.02 (primary; credential newtypes in pregolya-core) + S-2.06 (co-anchor; SDK crates cannot depend on pregolya-core per BC-2.08.006 PC-001 so SDK crates define independent credential newtypes governed by same workspace-wide policy). Exclusive S-1.02 anchor was incomplete; S-2.06 AC-006 traces to BC-2.14.005 {PC-002}. sprint-state.yaml S-2.06 bcs synced: [BC-2.08.006]→[BC-2.08.006, BC-2.14.005]. BC-INDEX 4.21→4.22 BC-2.14.005 row v1.4→v1.5. Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.50 (round-66/D-344/2026-09-02): sprint-state.yaml S-1.28 vps [VP-017]→[VP-017, VP-020] (story-writer; F-P2A238-02[MED]). epics.md §E-05: per-run single-txn DELETE / two-crash-point crash-matrix / E-TRAJ-006 added (story-writer; F-P2A238-01[HIGH]); §E-07 VP-020 reference added (story-writer; F-P2A238-03[LOW]). No INDEX carries a structured epics.md version field — INDEX version-row sync NOT required. Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.49 (round-65/D-343/2026-09-01): S-2.12 §VP-019 Phase-6 adjudication (story-writer; F-P2A237-01[HIGH] — red-gate removed; phase-scope corrections; input-hash self-updated). S-1.28 title-column aligned to verbatim-H1 (title-only; version UNCHANGED). Census UNCHANGED: BC 140 / VP 21 / EC 143 / TV 795 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 15."
  - "1.48 (round-62/D-340/2026-09-01): VP-020 minted → BC-2.02.009 {INV-001}+{INV-002} (PromoteRetireChannel idempotency/ordering; proptest P1; S-1.28). BC coverage map: BC-2.02.009 row updated with (VP-020) annotation. VP-to-Story Anchor Map: VP-020 row added (BC-2.02.009 {INV-001}+{INV-002}; S-1.28; P1; pregolya-graph). Story version bumps: S-1.28 v1.8→v1.9 (input-hash 310b574); S-2.12 v1.4→v1.5 (input-hash e151f9d). Census: BC 140 / VP 20→21 / EC 142→143 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%) / NFR 14→15."
  - "1.47 (round-60/D-339/2026-09-01): ops-artifact propagation burst — S-1.28 and S-2.12 (added in D-327/CAP-040) propagated to machine-facing dispatch artifacts: sprint-state.yaml now includes per-story blocks for S-1.28 (Wave 1 sub-batch 1e; pregolya-graph; BC-2.02.007/BC-2.02.008/BC-2.02.009; VP-017; 5 pts) and S-2.12 (Wave 2 sub-batch 2a; pregolya-checkpoint; BC-2.04.009/BC-2.04.010/BC-2.04.011; VP-018/VP-019; 8 pts). wave-schedule.md §sub-batch-1e/2a (sub-batch 1e: S-1.28; sub-batch 2a: S-2.12; input-hash 830a185) and dependency-graph.md §VP-to-Stories-matrix (S-1.10 blocks += S-2.12; VP-019 matrix row added) already completed by story-writer. STORY-INDEX story rows UNCHANGED. Census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%). Process-gap lesson L-262 codified (OPS-ARTIFACT SIBLING-SET COMPLETENESS). streak 0/3 (push resets frozen HEAD; round-61 gates on new HEAD)."
  - "1.46 (round-59/D-338/2026-09-01): S-1.28 v1.7→v1.8 (story-writer; F-P2A230-01 AC-018 dual-test trace — BC-2.02.009 {INV-004} PromoteRetireChannel side now cited to new test_BC_2_02_009_promote_retire_channel_implements_channel_trait() in promote_retire.rs; BC-2.02.007 side retains test_BC_2_02_007_ledger_channel_implements_channel_trait() in ledger.rs; Tasks + File-Structure updated for promote_retire.rs; input-hash 17d12e4). Census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%)."
  - "1.45 (round-58/D-337/2026-09-01): S-1.28 §Rule-4/§Rule-13/AC-011/AC-018 (story-writer; PromoteRetireOp<T> gains #[derive(Clone, Debug)] to satisfy Channel::Update: Clone; Rule 4/Rule 13 exclusion updated — PromoteRetireOp<T> derives Clone because LedgerEntry⊃Clone (distinct from Default which requires manual impl); Tasks + File-Structure updated; input-hash 17d12e4; F-P2A229-01). Census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24=70.8%)."
  - "1.44 (round-56/D-335/2026-09-01): S-1.28 v1.5→v1.6 (story-writer; Rule-13/AC-001/Tasks/File-Structure derive-only→manual bound-free impl Default reversal; AC-018 added dual-tracing BC-2.02.007/BC-2.02.009 {INV-004} Self:Default supertrait; input-hash 8797630; F-P2A227-01). S-1.14 v1.6→v1.7 (story-writer; built-in-channel manual-Default rule added; AC-016/Task-20/File-Structure updated; F-P2A227-01 sibling propagation). Census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24)."
  - "1.43 (round-55/D-334/2026-09-01): S-1.14 v1.5→v1.6 (story-writer round-55 fix-burst; AC-015 citation corrected per F-P2A225-03; input-hash already current 8ce605c). Census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24)."
  - "1.42 (round-54/D-333/2026-09-01): Story version bumps from round-54 fix-burst. S-1.14 v1.4→v1.5 (Channel trait ownership homed in S-1.14; AC-015/AC-016 added for Channel trait definition — these ACs trace to existing BCs BC-2.02.001–BC-2.02.004; story title UNCHANGED). S-1.28 v1.4→v1.5 (Rule 15 provenance trace added per F-P2A224-01; input-hash refreshed to 1ad6532). epics.md preamble OBS-1 resolved: '42 total stories' parenthetical resolved — preamble now reads '42 stories across Wave 1 (28) / Wave 2 (12) / Wave 6 (1) + 1 maintenance'. Census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142 / TV 794 canonical / stories 42 / pts 316 / ADR 30 / holdout 24 (must-pass 17/24)."
  - "1.41 (round-53/D-332/2026-08-31): Story versions S-1.28 (round-53 stage C: ADR-030 §Decision-3 BSP reduce-dispatch wiring + derive bounds) + S-2.12 (round-53 stage C: VP-019 §crash-isolation reconciliation + AC-020 incoherence resolved). Story/artifact census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142; points 316."
  - "1.40 (round-52/D-330/2026-08-31): Round-52 fix-burst (state-manager). (1) BC-coverage-map SS-02: BC-2.02.008 'LedgerChannel First-Appearance Ordering' cell now carries '(VP-017)' annotation — VP-017 proptest P1 dual-anchors both BC-2.02.007 and BC-2.02.008; the asymmetric annotation (only BC-2.02.007 had it) was the OBS finding F-P2A218-01. Consistent annotation rule codified in §Conventions note: 'VP annotation in coverage-map is required for ALL BCs that serve as VP bc_anchor entries in VP-INDEX.' (2) Story versions S-1.28 v1.2→v1.3 (Round-52: PhantomData struct shape canonicalized; interface-definitions.md added to inputs). (3) Story versions S-2.12 v1.2→v1.3 (Round-52: AC-019 removed — E-TRAJ-004 RETIRED; plaintext comparison for conflict detection; TV-005/TV-006 anchors; AC-018 policy-violation path removed; E-TRAJ-005 minted). Story/artifact census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142; points 316. TV 793→794 canonical (must-pass 16→17 / holdout 24; HS-D-007 promoted)."
  - "1.39 (round-51/D-329/2026-08-31): Round-51 records-tier fixes (state-manager). (1) Maintenance section census prose corrected: 'Product-story census is **39**' → '**41**' (stale from pre-D-327; census table correctly shows 41 product stories; F-P2A214-03). (2) S-1.28 story row title corrected: 'PromoteRetireChannel Active-Set Lifecycle' → 'PromoteRetireChannel Promote/Retire Lifecycle' (verbatim-H1 per BC-2.02.009; F-P2A214-04). (3) Summary census label corrected: 'Stories with Red Gate BCs' → 'Stories with Red-Gate obligations' (canonical label per adversary style guide; F-P2A214-05). Story/artifact census UNCHANGED: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142; points 316."
  - "1.38 (round-50/F-R50-01+F-P2A210-01+F-P2A208-07+F-P2A211-03/2026-08-31): STORY-INDEX aggregate summary reconciliation (state-manager round-50 fix-burst). (1) Census table, header blockquote, and BC-coverage-map intro updated from stale D-326 values (40/27/11/134) to post-D-327 correct values (42/28/12/140). Stories-with-VP-anchor 13→15 (VP-017 S-1.28 + VP-018/VP-019 S-2.12). Red-Gate stories 8→10 (S-1.28 VP-017 proptest RG + S-2.12 AC-004/AC-019/AC-020 RG). (2) BC-coverage-map title cells corrected to EXACT BC H1 canonical: BC-2.02.009 'PromoteRetireChannel Promote/Retire Lifecycle' (was 'PromoteRetireChannel Active-Set Lifecycle'); BC-2.04.009 'TrajectoryWriter::put_record Durability' (was 'put_record Durability and Write-Once Integrity'); BC-2.04.010 'TrajectoryReader::replay Ascending step_idx Order' (was 'replay Ascending Step-Index and Completeness'); BC-2.04.011 'Trajectory Compaction Isolation' (was 'Trajectory Compaction Isolation and Crash Safety (VP-018)'). (3) VP-to-Story Anchor Map: VP-017 BC anchor updated to dual BC-2.02.007 + BC-2.02.008 (v1.1 product-owner ruling); VP-019 row added (BC-2.04.011 {INV-003}; S-2.12; pregolya-checkpoint). Story/artifact census: 42 total (41 product + 1 maint) / BC 140 / VP 20 / EC 142; points 316. verify-story-count-propagation.sh exits 0."
  - "1.37 (praxist-Stage-3/2026-08-31): 2 new stories added for the praxist research-orchestrator use case. S-1.28 (STORY-S-1.28-ledger-channel-promote-retire.md, v1.0, 5 pts): LedgerEntry trait + LedgerChannel<T> + PromoteRetireOp<T> + PromoteRetireChannel<T> in graph::channels (pregolya-graph); BC-2.02.007 + BC-2.02.008 + BC-2.02.009; VP-017 proptest P1 anchor; Wave 1 batch-1e; depends_on [S-1.14]; blocks []. S-2.12 (STORY-S-2.12-trajectory-writer-reader-compaction.md, v1.0, 8 pts): TrajectoryRecord/TrajectoryWriter/TrajectoryReader/TrajectoryRetentionPolicy type defs (core::trajectory, pregolya-core) + SqliteTrajectoryStore + TrajectoryCompactor impl (checkpoint::trajectory, pregolya-checkpoint); BC-2.04.009 + BC-2.04.010 + BC-2.04.011; VP-018 proptest P1 anchor; Wave 2 batch-2a; depends_on [S-1.10]; blocks []. E-07 extended: +S-1.28 (wave-1). E-05 extended: +S-2.12 (wave-2). Topological sort: S-1.28 inserts into batch 1e (deps satisfied by 1d); S-2.12 inserts into batch 2a (deps satisfied by Wave 1). DAG acyclicity confirmed: no new cycles. Census updated: 40→42 total (39→41 product, 1 maint unchanged); Wave 1 27→28; Wave 2 11→12; Wave 6 1 unchanged; points 303→316 (+5+8); BC 134→140 (+6: BC-2.02.007/008/009 SS-02 + BC-2.04.009/010/011 SS-04); VP story-anchors 13→15 (VP-017 →S-1.28, VP-018 →S-2.12); Red Gate stories 8→10 (S-1.28 VP-017 proptest RG + S-2.12 AC-004/AC-019/AC-020 RG)."
  - "1.36 (round-49/BC-propagation/2026-08-31): 7 story version bumps (story-writer round-49 Stage-3 fix-burst). BC-2.09.007 {INV-003} extended 4→6 patterns (URL-userinfo + HTTP Basic): S-2.11 (v1.33→v1.34) AC-013 + AC-039 (Arc-DI OBS); S-1.26 (v1.11→v1.12) AC-020 step 2; S-1.27 (v1.8→v1.9) AC-017 step 2. FtsSearchConfig<'a> lifetime: S-1.11 (v1.2→v1.3) AC-001 trait sig. bind_tools/with_structured_output owned Box<dyn> returns: S-2.07 (v1.2→v1.3) AC-007/AC-010. InvocationContext canonical home + S-2.10 forbidden-dep carve-out: S-1.19 (v1.8→v1.9) AC-026; S-2.10 (v1.4→v1.5) forbidden-deps ADR-029 §forbidden-deps. STORY-INDEX: level: L3 field added (GATE-READY gate-obs). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303."
  - "1.35 (round-48/F-P2A200-01+F-P2A200-02+F-P2A201-01+F-P2A203-01+F-P2A203-02+R06/2026-08-30): 3 story version bumps (story-writer round-48 fix-burst). S-1.26 (v1.10→v1.11): F-P2A200-01 [HIGH] — AC-019 catch-boundary mislocation corrected (E-GRAPH-011 is Pregel-caught Err, not server-caught; BC-2.12.003/{INV-007} authority); F-P2A200-02 [MED] — AC-020 sanitizer step 2/3 drift corrected per BC-2.12.003 {INV-008}; input-hash 6483719. S-1.27 (v1.7→v1.8): F-P2A201-01/F-P2A203-01 [HIGH, CWE-209/532] — AC-017/EC-015 SSE boundary SEC-BOUND-001 sanitization pipeline added per BC-2.12.007 {INV-004} (3rd external boundary); input-hash f84a2c4. S-1.17 (v1.4→v1.5): R06 BOUNDARY-SANITIZATION-GATE cross-ref — SEC-BOUND-001 reference added per corpus-wide gate sweep; input-hash 70c134c. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303; TV 763→767 canonical (778 incl GTV)."
  - "1.34 (round-47/F-P2A197-01+F-P2A197-02/2026-08-30): 1 story version bump (story-writer round-47 fix-burst). S-1.26 (v1.9→v1.10): F-P2A197-01 [HIGH, CWE-209] — AC-019 + EC-020 (HTTP-boundary E-GRAPH-011 static-replace per BC-2.12.003 {INV-007}; E-GRAPH-011 ConditionalEdgePanic panics on HTTP path now statically replaced, not forwarded); F-P2A197-02 [MED, CWE-209/532] — AC-020 + EC-021 (3-step sanitization pipeline on Run.error.message per BC-2.12.003 {INV-008}; credential redaction path prior to HTTP surface); input-hash 3d8fb63. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303; TV 761→763 canonical (774 incl GTV)."
  - "1.33 (round-46/F-193-02+F-P2A195-02+SEC-008-class-audit+CompiledGraph-class-audit/2026-08-30): 5 story version bumps (story-writer round-46 fix-burst). S-1.27 (v1.6→v1.7): F-P2A195-02 [HIGH] — phantom CompiledGraph::run (7 sites) replaced with CompiledStateGraph::invoke (BC-2.02.001 {PC-001} canonical). S-2.11 (v1.32→v1.33): O-P2A195-01 [LOW/records] — §Changelog v1.26+v1.28 entries restored (inadvertent omission). S-1.26 (v1.8→v1.9): class-audit-A SEC-008 — 2 stale SEC-008 sites corrected (architect-enumerated, story-sweep miss from round-42). S-1.13 (v1.2→v1.3): R05-gate catch_unwind — SEC-008 workspace-root build-profile obligation note added. S-1.15 (v1.2→v1.3): R05-gate catch_unwind — SEC-008 workspace-root build-profile obligation note added. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303; TV 761 canonical (772 incl GTV)."
  - "1.32 (round-45/F-P2A189-01/2026-08-30): S-1.19 v1.7→v1.8 (F-P2A189-01 [HIGH, CWE-248/703]) — workspace-root panic=unwind pin propagated to all four stale sites (Task 5, AC-024, Task 11, EC-001); library-member-inert clause added throughout; mirrors S-2.11 AC-037 (v1.31). Input-hash refreshed (a4b9338→83861da). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303; TV 761 canonical (772 incl GTV)."
  - "1.31 (round-44/F-P2A187-03/2026-08-30): S-2.11 v1.31→v1.32 (F-P2A187-03 [MED]) — Red-Gate count corrected 13→12 (R43 AC-038-sweep residue; pregolya-server TCP/OS port-allocation AC-038 was added to task-16 in R43; Red-Gate count was 13 including the pre-R43 orphaned AC-038 reference; correct count is 12). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303; TV 761 canonical (772 incl GTV)."
  - "1.30 (round-43/F-P2A180-01+F-P2A183-01/2026-08-30): S-1.04 v1.11→v1.12 (F-P2A180-01 [HIGH]) — AC-002 Runnable::stream return type corrected to `Pin<Box<dyn Stream<Item = Result<Output, PregolyaError>> + Send>>` per BC-2.01.003 {PC-002} v2.9 (E0562 stable Rust boxing fix; nested `impl Trait` inside associated-type binding forbidden). S-2.11 v1.30→v1.31 (F-P2A183-01 [MED] + O-P2A183-01 [LOW/records]) — AC-038 task-plan orphan closed: AC-038 added to task-16 implementation note (pregolya-server TCP/OS port-allocation for MCP integration test); §Changelog reordered ascending (O-P2A183-01 [LOW/records]). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 138 EC; points UNCHANGED 303; TV 761 canonical (772 incl GTV)."
  - "1.29 (round-42/F-P2A176-01+F-P2A177-01+F-P2A177-02+F-P2A179-01/2026-08-30): S-1.04 v1.10→v1.11 (F-P2A176-01 [HIGH]) — batch default strategy corrected to in-task join_all/FuturesOrdered per BC-2.01.003 {PC-003} v2.8; JoinSet::spawn prohibited (borrows &self across await boundary); no max_concurrency cap; AC-003 + §Library-Requirements + §Architecture-Compliance updated. S-2.11 v1.29→v1.30 (F-P2A177-01 [HIGH, CWE-248/703, SEC-008] + F-P2A177-02 [MED, CWE-209] + F-P2A179-01 [HIGH]) — AC-019 non-generic ConcreteGraphRunner::run per BC-2.09.008 {PC-003} v3.4 / ADR-029 §Decision-2; AC-038 TV-019 MCP static-replace exception for E-GRAPH-011/E-GRAPH-019; SEC-008 scope updated. S-1.26 v1.7→v1.8 (F-P2A177-01 [HIGH, CWE-248/703, SEC-008]) — AC-018 + EC-019 node-body-panic recovery per BC-2.12.003 EC-003/{INV-007}; E-GRAPH-019 NodePanic; FutureExt::catch_unwind; Architecture Compliance Rule 9 (panic=unwind pregolya-server release profile); TV-011 anchor. Census: EC 137→138 (E-GRAPH-019 NodePanic minted); TV 759→761 canonical (772 incl GTV; TV-011+TV-019 minted). BC 134 / VP 17 / stories 40 (39 product + 1 maint) UNCHANGED; points 303 UNCHANGED."
  - "1.28 (round-41/F-P2A172-01+F-P2A173-01+F-P2A175-01/2026-08-29): S-1.04 v1.9→v1.10 (F-P2A172-01 [HIGH]) — 'max 10 in-flight' concurrency cap removed from AC-003 and Arch-Compliance rule; rewritten to Tokio-JoinSet pool-bounded with no explicit cap (production-grade default). S-2.11 v1.28→v1.29 (F-P2A173-01 [LOW] + F-P2A175-01 [LOW]) — AC-033 node-body-panic coverage: FutureExt::catch_unwind(AssertUnwindSafe(runner.run(...))) covers ALL panics during .await polling including graph-node-body panics (higher-probability CWE-248 vector) as well as extract_output panics per BC-2.09.008 EC-010; AC-033 heading/body, EC-012, Task-1/Task-36/Task-37, Arch-Compliance EC-010 row updated; AC-020 result_text branching NO-OP (F-P2A175-01: existing text already carries Value::String→verbatim; other variants→serde_json::to_string per BC-2.09.007 {PC-002}). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303; TV 759."
  - "1.27 (R40/F-P2A168-01+F-P2A169-02/2026-08-29): S-1.04 v1.8→v1.9 (ITEM A: F-P2A168-01 [HIGH, POL-18]) — AC-008 pipe serde bounds symmetric per BC-2.01.004 {PC-001}: Input gains Serialize bound; NextOutput gains DeserializeOwned bound; all three type params carry Serialize+DeserializeOwned. Reason updated: RunnableSequence invoke needs Input: Serialize to feed erased first stage + NextOutput: DeserializeOwned to decode erased last stage. Compile-test coverage (a)-(d) added per architect R40: (a) Input: DeserializeOwned-only call fails to compile; (b) NextOutput: Serialize-only call fails to compile; (c) RunnableSequence fields pub(crate) — external construction compile-fail; (d) RunnableParallel::new/RunnablePassthrough::assign take generic K: Into<String> (NOT impl Into<String> in item-binding position). Residual r39 asymmetric-bound language removed. S-2.11 v1.27→v1.28 (ITEM B: F-P2A169-02 [MED, CWE-862/POL-46]) — BC-2.09.008 {PC-006}/{INV-004}/EC-006/TV-005 action_risk precondition propagated to three live-body sites: AC-022 test fixtures specify action_risk = Some(ActionRisk::ReadOnly) for gate-approved path + None/>=Medium gate-denied note; AC-024 ForceApproveHooks path adds action_risk = Some(ActionRisk::ReadOnly) precondition + None/>=Medium gate-denied note + updated test description; EC-009 scenario adds action_risk = Some(ActionRisk::ReadOnly) precondition and gate-denied note. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303; TV 759."
  - "1.26 (R39/F-P2A164-01+F-P2A164-02+F-P2A165-01+F-P2A167-01+F-P2A167-02/2026-08-29): S-1.04 v1.7→v1.8 (ITEMS A: F-P2A164-01 [CRIT] + F-P2A164-02 [MED]): AC-007 rewritten to DynRunnableAdapter ADAPTER boundary model per BC-2.01.003 {INV-006}/{PC-001} — DynRunnableAdapter<I,O,R> implements DynRunnable for R: Runnable<I,O>+Send+Sync+'static; E-CORE-003 raised at ADAPTER boundary when serde_json::from_value::<I> fails inside DynRunnableAdapter, before R::invoke is called; DynRunnableAdapter handles Value→I/O round-trip INTERNALLY; all blanket-auto-coercion language removed. AC-008 rewritten to pipe serde bounds per BC-2.01.004 {PC-001} — Runnable::pipe requires Self: Sized+Send+Sync+'static, Input: DeserializeOwned+Send+'static, Output: Serialize+DeserializeOwned+Send+'static, NextOutput: Serialize+Send+'static; pipe erases via .into_dyn() constructing DynRunnableAdapter<I,O,R>; all Runnable<Value,Value>/without-adapter/blanket-auto-coercion language removed. S-2.11 v1.26→v1.27 (ITEMS B+C+D): ITEM B (F-P2A165-01) BC-2.09.008 unconditional pre-hook gate propagated — AC-022/AC-030/EC-011/Task-22/Task-33/Arch Compliance ForceApproveHooks row updated; ActionRisk gate runs BEFORE invoking inner PreToolCallHook; None/Some(>=Medium) denied WITHOUT calling inner hook (covers AlwaysApprovePolicy/no-hook default); TV-018 reference added throughout. ITEM C (F-P2A167-01 [MED, POL-4]) two live-body tools/call collapsed attribution sites corrected: §Previous Story Intelligence and §File Structure registry.rs row changed from '(tools/list + tools/call dispatch; BC-2.09.006 {PC-002})' to '(tools/list dispatch: BC-2.09.006 {PC-002}; tools/call dispatch: BC-2.09.007 {PC-001})'; historical changelog lines at rows 57 and 736 intentionally preserved. ITEM D (F-P2A167-02 [LOW, POL-4]) phantom S-2.10 filenames corrected: §Previous Story Intelligence tool.rs→discovery.rs, guardrail.rs→ingress.rs per round-25 canonical rename. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303; TV total 759."
  - "1.25 (round-38/F-P2A160-01+F-P2A162-02/2026-08-29): RETRACTION of false round-23 claim — S-1.03 and S-1.04 were NOT reordered in round-23; the v1.21 'S-1.03/S-1.04 descending order restored' entry was unapplied and incorrectly recorded. S-1.03 and S-1.04 changelogs remain ASCENDING, which is VALID per verify-story-changelog-direction.sh §Rule-1 (per-file monotonicity only; no cross-story direction mandate). F-P2A162-02 is the exposing finding. S-1.04 v1.6→v1.7 (F-P2A160-01 [HIGH]): AC-007 trace updated to EC-001/{PC-001} — E-CORE-003 raised at serde-bounded blanket boundary when `serde_json::from_value::<I>` fails, before typed `Runnable<I,O>::invoke` is called; callers not responsible for pre-deserializing Value input. AC-008 trace updated to BC-2.01.004 {PC-001} — typed stages auto-satisfy `DynRunnable` via serde-bounded blanket (`I: DeserializeOwned`, `O: Serialize`) with no `Runnable<Value,Value>` requirement; `RunnableSequence<I,O>` also auto-derives `DynRunnable`. S-1.04 input-hash refreshed. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.24 (R37/2026-08-29): S-1.04 v1.5→v1.6 (F-P2A156-01+02+03+04+F-P2A158-01+02+03): AC-013 outer-Result contradiction resolved, recursion_limit u32→usize, RunnableSequence 3-param→2-param, Runnable positional binding, RunnableConfig anchor corrected to pregolya-core/src/config.rs. S-2.04 v1.5→v1.6 (F-P2A156-02-propagation): AC-005/AC-009 Runnable positional binding. S-2.11 v1.25→v1.26 (O-P2A157-01): BC-2.09.008 {INV-003} v3.0 MUST-language propagation into AC-025 body; §Architecture Compliance Rules BC-2.09.008 INV-003 row source-restriction aligned (sweep). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.23 (round-25/D-295/2026-08-28): S-1.19 (v1.3) — F-P2A109-01 [HIGH] async-panic guardrail: AC-013 + AC-014 added (FutureExt::catch_unwind(AssertUnwindSafe(...await)) for async callee panics; sibling of round-21 S-2.11 §AC-033 fix per INCOMPLETE-SWEEP SIBLING-MIRROR root-cause; SEC-008 note for Phase-3 panic=unwind obligation). S-2.10 (v1.3) — F-P2A111-01/02/03 [HIGH+MED] §File-Structure canonical MCP file names (ingress.rs/discovery.rs/session.rs/interceptor.rs/exception.rs replacing phantom names tools.rs/adapter.rs/guardrail.rs); §Architecture-Mapping updated; F-P2A111-06 [MED] §Architecture-Compliance BC-table titles corrected to BC-INDEX canonical forms. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.22 (round-24/D-294/2026-08-28): S-2.10 v1.1→v1.2 (F-P2A104-01 [HIGH]): AC-026 mirrored from BC-2.09.001 §Description/{PC-003}/{INV-001} — phantom `args_schema` field on `Arc<dyn DynTool>` replaced by `schema()` accessor; schema surface type corrected from `serde_json::Value` to `schemars::Schema`; test renamed `test_BC_2_09_001_schema_verbatim_passthrough`; `schemars` added to §Library & Framework Requirements; input-hash updated. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.21 (round-23/D-293/2026-08-28): Changelog direction normalization — S-2.11 (v1.18) frontmatter ascending order restored (1.17/1.18 entries moved to tail); input-hash recomputed; body §Changelog 1.12/1.11 inversion corrected; 1.18 entry hash literal removed per TD-VSDD-091. S-1.23 (v1.6) frontmatter descending order restored (1.6 first). S-1.03 (v1.4) and S-1.04 (v1.4) descending order restored (1.1–1.3 reordered after 1.4). S-1.24 (v1.6) story-writer burst changelog normalization. Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.20 (round-22/D-292/2026-08-28): S-2.11 v1.17→v1.18 (F-P2A096-01/F-P2A097-01/F-P2A099-02/F-P2A096-03/F-P2A097-02): exhaustive security sweep — AC-031 sanitizer regex corrected to version-agnostic pattern; AC-036 added (u64 CheckpointId passthrough correctness boundary); AC-033 panic recovery corrected to FutureExt::catch_unwind(AssertUnwindSafe(runner.run(input,policy))) inside invoke_dyn; AC-037 added (SEC-008 panic=unwind build-profile obligation); tasks 34/35/36/37 updated + tasks 42/43/44 added. S-1.23 v1.5→v1.6 (F-P2A096-04): PreToolDecision PendingHumanApproval { prompt: Option<String> } corrected (was String; interface-definitions.md §PreToolDecision + ADR-018 §Decision 1 authoritative). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.19 (round-21/D-291/2026-08-28): S-1.14 (stub_terminal test-util feature-gate: AC-014 prerequisite condition updated, Task-18 implementation notes, File-Structure pregolya-graph Cargo.toml [features] test-util=[] — F-P2A093-01). S-2.11 (Task-27 dev-dep+feature wiring: pregolya-mcp [dev-dependencies] pregolya-graph features=[\"test-util\"] — F-P2A093-01). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.18 (round-20/F-P2A092-04/D-290/2026-08-27): STORY-S-MAINT-001 v1.2 (round-20 F-P2A092-04: census 133→134 propagation; Background recount 94-of-134 bullet-invariants / 81-of-134 EC-subsections). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.17 (round-19/D-289/2026-08-27): STORY-S-2.11 v1.16 (round-19 symbol-canon: DynTool::invoke→invoke_dyn at AC-008/AC-009/Purity-table/Prev-Story ×4 sites per F-P2A087-01; PreToolCallHook::PendingHumanApproval→PreToolDecision::PendingHumanApproval at AC-021 per F-P2A087-02). STORY-S-1.23 v1.5 (DynTool::invoke→invoke_dyn ×3 sites; PreToolDecision::PendingHumanApproval per F-P2A087-01/02). dependency-graph.md §Changelog ASCENDING→DESCENDING (F-P2A089-02 MED — matches epics.md/STORY-INDEX convention). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.16 (round-18/F-P2A084-01/D-288/2026-08-27): S-2.11 bumped v1.14→v1.15 (F-P2A084-01 MED — AC-023 and Task-20 ToolOutput→serde_json::Value prose alignment: AC-023 acceptance criterion and Task-20 task description fully re-grounded on serde_json::Value returned by invoke_dyn; eliminates the final story-prose occurrences of 'ToolOutput' as the invoke_dyn return type). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.15 (round-14/semantic-reconciliation/F-P2A079-01/D-286/2026-08-27): S-2.11 bumped v1.13→v1.14 (F-P2A079-01 MED — Task 38 `ToolOutput::Text { text }` → `Ok(Value::String(...))` per AC-034/TV-009; latent Policy-8 citation resolved: Arch-Compliance Source column BC-2.02.001 cross-ref → BC-2.09.008 {PC-003} covered; input-hash refreshed to 06c6d6a). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.14 (round-12/GAP-01-type-grounding-straggler/D-285/2026-08-27): S-2.11 v1.12→v1.13 (round-12: AC-032 closure re-grounded — `|s: &S| json!({api_key: s.api_key})` → `|s: &serde_json::Value|` + JSON index access; Task-41 TestGraphState struct construction → json!({}) + `s[answer]` index form; zero live-body `|s: &S|` or struct-field-access phantoms; input-hash updated). S-2.11 v1.11→v1.12 also in-flight (schema_for!(S) sweep, round-10 straggler — Arch Compliance + Library Requirements `schema_for!(S)` claims removed; caller-supplied input_schema parameter). S-1.07 v1.4→v1.5 (round-12: AC-013 register_into signature de-genericized StateGraph<S>→StateGraph per BC-2.02.001 {PC-001}; input-hash updated). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.13 (round-10/GAP-01-nongeneric/F-P2A073-01/2026-08-27): S-2.11 v1.11: non-generic re-ground (from_graph non-generic; Arc<CompiledStateGraph>; input_schema caller-derived; ToolOutput::Structured eliminated; from_value::<S> eliminated; extract_output takes &serde_json::Value; AC-016/017/018/019/020/021/023/024/027/034/035 updated; Tasks 15/17/18/23 updated; Arch Compliance updated with no from_value::<S> rule). S-1.14 v1.3: AC-014 + Task 18 (CompiledStateGraph::stub_terminal #[cfg(test)] helper; consumed by VP-016 harness in S-2.11); blocks extended to include S-2.11; serde_json added to lib requirements. F-P2A073-01: S-2.11 BC status annotation corrected (BC-2.09.008 draft; auto-promotes at PR merge per POL-27). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC; points UNCHANGED 303."
  - "1.12 (round-7/D-282/2026-08-26): Phase-2 re-convergence round-7 fix-burst CLOSED. S-2.11 v1.10: seam alignment (GraphAgentTool<S>→GraphAgentTool non-generic ×4; Task 23 + Arch-Compliance seam wording; ADR-029 {INV-001} canonical seam statement; AC-035 {INV-005} caller-obligation credential-key test added; AC count 34→35). dependency-graph v1.2: GraphAgentTool<S>→GraphAgentTool non-generic in story DAG. Epics E-21 rollup 13→16 (S-2.10(8)+S-2.11(8)=16 pts; product-epic point total 300→303; GAP-01 growth D-275). Story/artifact census UNCHANGED: 40 total (39 product + 1 maint) / 134 BC / 17 VP / 137 EC."
  - "1.11 (round-6/P2A-063-065/D-281/2026-08-26): STORY-S-2.11 v1.8→v1.9 (F-064-03/BLOCKER-2 MED): RootSchema→schemars::Schema rename applied at four AC-trace/task occurrences within S-2.11 (schemars crate dropped RootSchema as a public type; canonical form is schemars::Schema throughout). No other story file changed this round. Story census UNCHANGED: 40 total (39 product + 1 maint). AC counts UNCHANGED."
  - "1.10 (P2A-060/061/062-round-5/2026-08-26): SS-09 BC coverage header corrected (7 BCs) → (8 BCs) (body already listed BC-2.09.001–008; header lagged by 1). S-2.11 depends_on updated [S-2.10] → [S-2.10, S-1.14] (ADR-029 BC-2.09.008 PC-001 — GraphAgentTool wraps Arc<CompiledGraph<S>>; S-1.14 is StateGraph Node Definition, Wave-1 upstream; DAG-acyclicity confirmed: S-1.14 Wave-1 upstream of S-2.11 Wave-2, no cycle). S-2.11 v1.8 (on-disk per CHANGED FILES: P2A-060/061/062 schema()/input_schema() rename + E-MCP-011 Error-Codes row). Story census UNCHANGED: 40 total (39 product + 1 maint). AC counts UNCHANGED."
  - "1.9 (P2A-058-F058-01..06-SEC009/2026-08-26): S-2.11 v1.7 — F-058-02 MED E-MCP-010 recovery message corrected across AC-021 (BoundaryApprovalHook::Deny interrupt-parking scoping) and AC-026 (ForceApproveHooks cannot resolve E-MCP-010; correct resolution: restructure graph to avoid interrupt() in synchronous tools/call). AC count UNCHANGED 34. S-2.05 v1.6 — F-058-04 MED VP-006-B harness_fn injection_guard_multipair_fewshot_fail_closed confirmation recorded. AC count UNCHANGED 18. Story census UNCHANGED: 40 total (39 product + 1 maint)."
  - "1.8 (P2A-057-round-2/2026-08-26): S-2.11 v1.6 — F-057-01 CRIT fail-closed fix (AC-030: None/undeclared → Deny+E-MCP-011; TV-012 None variant); F-057-02 HIGH Deny-path corrected (AC-021: BoundaryApprovalHook::Deny path scoped to interrupt-parking, graph owns terminal); F-057-04/05 ACs updated (AC-024 binary-interrupt scoped; §Story Anchor populated). AC count UNCHANGED 34. Story census UNCHANGED: 40 total (39 product + 1 maint)."
  - "1.7 (B-SS18-SEC/B-SS09-SEC/ADR-029-v1.2/2026-08-26): S-2.11 v1.5 (+6 ACs; 28→34 ACs total; SEC-006/SEC-007 coverage: {INV-004} BoundaryApprovalHook+ForceApproveHooks, {PC-006} ForceApproveWriteBlocked+E-MCP-011). S-2.05 v1.5 (+1 AC; 17→18 ACs total; SEC-003 coverage: VP-006-B proptest P1 Red-Gate TV-007 4-pair FewShot; verification_properties: [VP-006, VP-006-B]). VP-006-B row added to VP-to-Story Anchor Map. Story census UNCHANGED: 40 total (39 product + 1 maint)."
  - "1.6 (GAP-01/ADR-029/2026-08-26): S-2.11 extended — BC-2.09.008 added (GraphAgentTool wrapping; mcp::graph_tool; Wave 2; v1.4; 5→8 pts); VP-016 proptest P1 seeded (BC-2.09.008 {INV-001}); VP-015/VP-016 rows added to VP-to-Story Anchor Map. BC coverage 133→134; VP Seed BCs 13→14. Story census UNCHANGED: 40 total (39 product + 1 maint)."
  - "1.5 (BC-completeness-propagation/2026-08-26): 23 story files updated with BC-completeness propagation (SS-01 through SS-23 cluster fan-out; AC/task/ACs updated to reflect ADR-014 §D7 MMR, §D8 delete-idempotent, ADR-028 multitask, plus 15 new EC codes); §Census Stories with VP anchor 12→13 (S-2.11 now anchors VP-015 via BC-2.09.007 {INV-003}). Story census UNCHANGED: 40 total (39 product + 1 maint)."
  - "1.4 (P2A-054 F-054-01/2026-08-25): §Census epic axis made symmetric with story axis — Product Epics 22 / Maintenance Epics 1 / Total Epics 23 (EPIC-MAINT accounted; product census unchanged at 22)."
  - "1.3 (P2A-048/2026-08-24): F-048-01: changelog reordered to DESCENDING (newest-first) to match the index-class convention (verify-form-a-changelog-direction.sh: indexes = DESCENDING, version == FIRST entry) and sibling indexes BC-INDEX/VP-INDEX/ARCH-INDEX. STORY-INDEX was the sole ascending outlier."
  - "1.2 (P2A-047/2026-08-24): F-047-02: S-2.03 Subsystem column updated SS-21 → SS-21, SS-20 (BC-2.20.003 owned by SS-20 Document Retrieval per ARCH-INDEX Subsystem Registry; subsystems field is a superset of covered-BC-owning + implementation-touched subsystems, per S-1.13 SS-15,SS-03 precedent). Story versions: S-2.03 v1.3→v1.4; S-2.04 v1.3→v1.4 (verification_properties frontmatter cleared to []; VP-2.18.003-A/B are BC-local not VP-INDEX-registered)."
  - "1.1 (P2A-044/2026-08-24): Revert P2A-043 over-propagation — BC-2.06.001 removed from S-1.27 behavioral_contracts (taxonomy reference not coverage); BC-2.06.001 §Story Anchor updated to S-1.17 only."
phase: 2
traces_to: .factory/specs/behavioral-contracts/BC-INDEX.md
inputs:
  - .factory/specs/behavioral-contracts/BC-INDEX.md
  - .factory/specs/architecture/ARCH-INDEX.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/domain-spec/L2-INDEX.md
  - .factory/specs/verification-properties/VP-INDEX.md
input-hash: "34034c0"
---

# STORY-INDEX: pregolya Phase 2 Story Inventory

> **52 stories total — 28 Wave 1 / 12 Wave 2 / 10 Wave 3 / 1 Wave 6 / 1 Maint (S-MAINT-001 housekeeping, out-of-wave)**
> **Product-story census: 51 (28 Wave 1 / 12 Wave 2 / 10 Wave 3 / 1 Wave 6). S-MAINT-001 is maintenance, not a product feature.**
> **BC coverage: 148 BCs — 51 P0 / 94 P1 / 3 P2 — all covered**
> **Story files:** Individual STORY-NNN specs live in `.factory/stories/stories/`

## Census

| Metric | Count |
|--------|-------|
| Total Story Files | 52 |
| Product Stories | 51 |
| Wave 1 stories | 28 |
| Wave 2 stories | 12 |
| Wave 3 stories | 10 |
| Wave 6 stories | 1 |
| Maintenance Stories | 1 |
| Product Epics | 23 |
| Maintenance Epics | 1 |
| Total Epics | 24 |
| BCs covered | 148 / 148 |
| Stories with VP anchor | 25 |
| Stories with Red-Gate obligations | 10 |

## Story Inventory

> **Columns:** ID | Title | BCs (abbreviated) | SS | Crate(s) | Priority | Points | depends_on | Wave | Status
> **Priority** = derived from highest-priority BC in story (P0 > P1 > P2).

### Wave 1 — pregolya-core Foundation

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.01 | PregolyaError 2D Struct and RFC-7807 Emission | BC-2.14.001, BC-2.14.002 | SS-14 | pregolya-core | P0 | 5 | [] | draft |
| S-1.02 | Error Policy Enforcement — Result, Timeout, Credential, Validation | BC-2.14.003, BC-2.14.004, BC-2.14.005, BC-2.14.006 | SS-14 | pregolya-core | P0 | 5 | [S-1.01] | draft |
| S-1.03 | Message and ContentBlock Type System | BC-2.01.001, BC-2.01.002 | SS-01 | pregolya-core | P0 | 5 | [S-1.01] | draft |
| S-1.04 | Runnable Trait Invocation and Pipe Composition | BC-2.01.003, BC-2.01.004 | SS-01 | pregolya-core | P0 | 5 | [S-1.03, S-1.02] | draft |
| S-1.05 | LCEL Composition Primitives — RunnableParallel, RunnablePassthrough, RunnableAssign | BC-2.01.005, BC-2.01.006, BC-2.01.007, BC-2.01.008 | SS-01 | pregolya-core | P1 | 8 | [S-1.04] | draft |
| S-1.06 | Tool Retry Policy and Circuit Breaker | BC-2.16.001, BC-2.16.002, BC-2.16.003 | SS-16 | pregolya-core | P1 | 5 | [S-1.04, S-1.02] | draft |

### Wave 1 — pregolya-macros (proc-macro attributes)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.07 | Proc-Macro Attributes — #[tool], #[entrypoint], #[task] | BC-2.08.010, BC-2.08.011, BC-2.08.012 | SS-08 | pregolya-macros | P1 | 5 | [S-1.04] | draft |

### Wave 1 — Independent crates (parallel, depend only on pregolya-core)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.08 | Recursive Text Splitter — Unicode Boundaries and Non-ASCII Parity | BC-2.07.001, BC-2.07.002, BC-2.07.003 | SS-07 | pregolya-splitters | P0 | 8 | [S-1.01] | draft |
| S-1.09 | Sandbox Backend Selection, Path Guard and Policy Enforcement | BC-2.13.001, BC-2.13.002, BC-2.13.003, BC-2.13.004, BC-2.13.005, BC-2.13.006, BC-2.13.007 | SS-13 | pregolya-sandbox | P1 | 13 | [S-1.01, S-1.02] | draft |
| S-1.10 | Checkpoint Core — put_writes, Durability Tiers, Monotonic Clock, Fork, Crash Recovery, Encryption | BC-2.04.001, BC-2.04.002, BC-2.04.003, BC-2.04.004, BC-2.04.005, BC-2.04.006, BC-2.04.007 | SS-04 | pregolya-checkpoint | P0 | 13 | [S-1.04, S-1.02] | draft |
| S-1.11 | FTS Conversation Search Over Checkpoint History | BC-2.04.008 | SS-04 | pregolya-checkpoint | P1 | 3 | [S-1.10] | draft |
| S-1.12 | Memory KV and Vector Persistence, Tenant Tier Isolation and GDPR Erasure | BC-2.15.001, BC-2.15.002, BC-2.15.003 | SS-15 | pregolya-memory | P1 | 8 | [S-1.04, S-1.02] | draft |
| S-1.13 | SkillStore Registry, Guarded Memory Writes and Frozen-Snapshot Context Mutation | BC-2.15.004, BC-2.15.005, BC-2.15.006 | SS-15, SS-03 | [pregolya-core, pregolya-memory, pregolya-graph] | P1 | 8 | [S-1.12, S-1.04, S-1.14, S-1.17] | draft |

### Wave 1 — pregolya-graph (StateGraph, BSP, HITL, Streaming, Budget, Guardrail)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.14 | StateGraph Node Definition and Channel Reducer Semantics | BC-2.02.001, BC-2.02.002, BC-2.02.003, BC-2.02.004 | SS-02 | pregolya-graph | P0 | 8 | [S-1.04, S-1.01] | draft |
| S-1.15 | Conditional Edge Routing and Send API Dynamic Fan-Out | BC-2.02.005, BC-2.02.006 | SS-02 | pregolya-graph | P0 | 5 | [S-1.14] | draft |
| S-1.16 | BSP Super-Step Execution Determinism | BC-2.03.001, BC-2.03.002, BC-2.03.003 | SS-03 | pregolya-graph | P0 | 13 | [S-1.14, S-1.15, S-1.10, S-1.13, S-1.17, S-1.18] | draft |
| S-1.17 | Streaming Event Types, run_id Correlation and Run Parity | BC-2.06.001, BC-2.06.002, BC-2.06.003 | SS-06 | [pregolya-core, pregolya-graph] | P0 | 5 | [S-1.14, S-1.04, S-1.15] | draft |
| S-1.18 | Budget Policy Evaluation, EvidenceJournal and Ceiling Halt and Escalate | BC-2.10.001, BC-2.10.002, BC-2.10.003, BC-2.10.004 | SS-10 | pregolya-graph | P0 | 8 | [S-1.14, S-1.04, S-1.10, S-1.17] | draft |
| S-1.19 | GuardrailHook at All Ingress Boundaries — Tool-Result, RAG, Memory | BC-2.11.001, BC-2.11.002, BC-2.11.003, BC-2.11.004, BC-2.11.005, BC-2.11.006 | SS-11 | pregolya-graph | P0 | 13 | [S-1.14, S-1.04] | draft |
| S-1.20 | HITL Interrupt and Resume Core — FIFO Queue, Risk Classification, Command API | BC-2.05.001, BC-2.05.002, BC-2.05.003, BC-2.05.004, BC-2.05.005, BC-2.05.006 | SS-05 | pregolya-graph | P0 | 13 | [S-1.16, S-1.17, S-1.10] | draft |

### Wave 1 — pregolya-tools (depends on pregolya-sandbox and pregolya-core)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.21 | File System Tools — ReadFileTool, WriteFileTool, EditFileTool, ListDirTool | BC-2.23.001, BC-2.23.002, BC-2.23.003, BC-2.23.004 | SS-23 | pregolya-tools | P1 | 8 | [S-1.09, S-1.04, S-1.07] | draft |
| S-1.22 | Shell and Search Tools — BashTool and GrepTool | BC-2.23.005, BC-2.23.006 | SS-23 | pregolya-tools | P1 | 8 | [S-1.09, S-1.21, S-1.06] | draft |

### Wave 1 — pregolya-graph late (depend on HITL, tools, compaction)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.23 | PreToolCallHook Dispatch and Skip-on-Resume Invariant | BC-2.05.007, BC-2.05.008 | SS-05 | pregolya-graph | P1 | 5 | [S-1.20, S-1.17] | draft |
| S-1.24 | Tool Approval and Compaction Streaming Events | BC-2.06.004, BC-2.06.005, BC-2.06.006 | SS-06 | pregolya-graph | P1 | 5 | [S-1.23, S-1.17, S-1.18] | draft |
| S-1.25 | Compaction Trigger Configuration and Mid-Run Execution | BC-2.10.005, BC-2.10.006 | SS-10 | [pregolya-core, pregolya-graph] | P1 | 5 | [S-1.10, S-1.18, S-1.24] | draft |

### Wave 1 — pregolya-server (depends on pregolya-graph and pregolya-checkpoint)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.26 | Thread, Assistant and Run CRUD — Durable HTTP Server | BC-2.12.001, BC-2.12.002, BC-2.12.003 | SS-12 | pregolya-server | P1 | 8 | [S-1.16, S-1.10, S-1.04] | draft |
| S-1.27 | CronSchedule, SecurityConfig, Store Seams, and SSE Streaming | BC-2.12.004, BC-2.12.005, BC-2.12.006, BC-2.12.007 | SS-12 | pregolya-server | P1 | 8 | [S-1.26] | draft |

### Wave 1 — pregolya-graph CAP-040 additions (LedgerChannel and PromoteRetireChannel)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-1.28 | LedgerChannel and PromoteRetireChannel — Ledger-Style State Channels | BC-2.02.007, BC-2.02.008, BC-2.02.009 | SS-02 | pregolya-graph | P1 | 5 | [S-1.14] | draft |

---

### Wave 2 — pregolya-core D21 additions (LC Serialization and Retrieval)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-2.01 | LC Serialization Round-Trip, Inventory Registry and Reviver Allowlist Security | BC-2.19.001, BC-2.19.002, BC-2.19.003, BC-2.19.004, BC-2.19.005, BC-2.19.006 | SS-19 | pregolya-core | P0 | 13 | [S-1.04, S-1.02] | draft |
| S-2.02 | Retriever Trait, GuardedDocuments and RAGRetrieval Guardrail Coverage | BC-2.20.001, BC-2.20.002 | SS-20 | pregolya-core | P0 | 5 | [S-1.19, S-1.04] | draft |

### Wave 2 — pregolya-vectorstores (VectorStore Abstraction)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-2.03 | VectorStore Trait, InMemoryVectorStore, Zero-Norm Guard and MetadataFilter | BC-2.21.001, BC-2.21.002, BC-2.21.003, BC-2.21.004, BC-2.20.003 | SS-21, SS-20 | pregolya-vectorstores | P0 | 10 | [S-2.02, S-1.04, S-2.09] | draft |

### Wave 2 — pregolya-prompts (Prompt Templates and Injection Safety)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-2.04 | Prompt Template Core — PromptTemplate, ChatPromptTemplate, MessagesPlaceholder, FewShot | BC-2.18.001, BC-2.18.002, BC-2.18.003 | SS-18 | pregolya-prompts | P1 | 8 | [S-1.04, S-1.02] | draft |
| S-2.05 | Prompt Injection Safety Guard — TrustLevel Enforcement and Fail-Closed at Render Time | BC-2.18.002, BC-2.18.004, BC-2.18.005 | SS-18 | pregolya-prompts | P1 | 8 | [S-2.04] | draft |

### Wave 2 — Provider crates (SS-08 + SS-22)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-2.06 | Provider SDK Split Architecture — Standalone SDK Crate and Adapter Crate Pattern | BC-2.08.006, BC-2.14.005 | SS-08, SS-14 | pregolya-openai, pregolya-anthropic, pregolya-ollama, pregolya-openai-sdk, pregolya-anthropic-sdk, pregolya-ollama-sdk | P0 | 3 | [S-1.04] | draft |
| S-2.07 | Chat Model Core Conformance — Streaming, Tool-Call, Structured Output, Error Fidelity | BC-2.08.001, BC-2.08.002, BC-2.08.003, BC-2.08.004, BC-2.08.005, BC-2.08.007 | SS-08 | pregolya-openai, pregolya-anthropic, pregolya-ollama | P1 | 13 | [S-2.06, S-1.07, S-1.06] | draft |
| S-2.08 | Advanced Provider Features — Eval Scoring, Schema Stability, Tool Dialects, Failover Chain | BC-2.08.008, BC-2.08.009, BC-2.08.013, BC-2.08.014 | SS-08 | pregolya-openai, pregolya-anthropic, pregolya-ollama, pregolya-standard-tests | P1 | 8 | [S-2.07] | draft |
| S-2.09 | Embeddings Trait and Provider Implementations — OpenAI and Ollama Embeddings | BC-2.22.001, BC-2.22.002, BC-2.22.003 | SS-22 | pregolya-core, pregolya-openai, pregolya-ollama | P1 | 8 | [S-2.06, S-1.02] | draft |

### Wave 2 — pregolya-mcp (MCP Tool Adapter and Server)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-2.10 | MCP Client — Tool Discovery, Invocation Routing and Untrusted Ingress | BC-2.09.001, BC-2.09.002, BC-2.09.003, BC-2.09.004, BC-2.09.005 | SS-09 | pregolya-mcp | P1 | 8 | [S-1.19, S-1.04, S-1.22] | draft |
| S-2.11 | MCP Server — Tool Advertisement and External Client Invocation | BC-2.09.006, BC-2.09.007, BC-2.09.008 | SS-09 | pregolya-mcp | P1 | 8 | [S-2.10, S-1.14] | draft |

### Wave 2 — pregolya-checkpoint CAP-040 additions (Trajectory Writer, Reader, and Compaction)

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-2.12 | Durable Audit Trajectory — Writer, Reader, and Compaction Isolation | BC-2.04.009, BC-2.04.010, BC-2.04.011 | SS-04 | pregolya-checkpoint | P1 | 8 | [S-1.10] | draft |

---

### Wave 6 — Formal Verification Pipeline

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-6.01 | Formal Verification Pipeline — Kani Harness Obligations and cargo-fuzz Targets | BC-2.17.001, BC-2.17.002 | SS-17 | xtask, pregolya-graph, pregolya-checkpoint, pregolya-sandbox, pregolya-core, pregolya-vectorstores, pregolya-prompts, pregolya-tools, fuzz | P2 | 8 | [S-1.16, S-1.10, S-1.09, S-2.01, S-2.03, S-1.23, S-1.25, S-1.05, S-2.09, S-2.05, S-1.22] | draft |

---

### Wave 3 — Developer Console (ROADMAP-ONLY — specced at Phase 1 / D-356; built in Wave 3)

> S-console stories belong to the E-console epic (SS-24), Wave-3 roadmap; primary crate is `pregolya-console` EXCEPT S-console-03 (`pregolya-server`) and S-console-04 (`pregolya-graph` + `pregolya-server`). Status: `roadmap` — not yet scheduled for implementation. No Wave-1/2 story depends on any S-console story.

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-console-01 | `pregolya-console` Crate Scaffolding | BC-2.24.001 | SS-24 | pregolya-console | P1 | 5 | [] | roadmap |
| S-console-02 | `DebugSpanExporter` FIFO Ring Buffer | BC-2.24.001, BC-2.24.002 | SS-24 | pregolya-console | P1 | 5 | [S-console-01, S-console-03] | roadmap |
| S-console-03 | `debug-endpoints` Cargo Feature and Trace-Read HTTP Endpoints | BC-2.24.002 | SS-24 | pregolya-server | P1 | 5 | [S-console-01] | roadmap |
| S-console-04 | `graph::descriptor` Pure Core Module and `GET /assistants/{id}/graph` Endpoint | BC-2.24.003 | SS-24 | [pregolya-graph, pregolya-server] | P1 | 5 | [S-console-03] | roadmap |
| S-console-05 | Web SPA Build Pipeline | BC-2.24.001, BC-2.24.004 | SS-24 | pregolya-console | P1 | 8 | [S-console-01] | roadmap |
| S-console-06 | Run Inspection Event Timeline and Live SSE Monitoring Panel | BC-2.24.004 | SS-24 | pregolya-console | P1 | 8 | [S-console-03, S-console-04, S-console-05] | roadmap |
| S-console-07 | Checkpoint History Browser and Fork-from-Checkpoint Trajectory Replay | BC-2.24.005, BC-2.12.001 | SS-24 | pregolya-console | P1 | 5 | [S-console-05] | roadmap |
| S-console-08 | HITL Approval Dialog and Resume Dispatch | BC-2.24.006 | SS-24 | pregolya-console | P1 | 5 | [S-console-06] | roadmap |
| S-console-09 | Token/Context Budget Monitoring Panel | BC-2.24.007 | SS-24 | pregolya-console | P1 | 5 | [S-console-06] | roadmap |
| S-console-10 | Guardrail/Security Decision Review Panel | BC-2.24.008 | SS-24 | pregolya-console | P1 | 5 | [S-console-06] | roadmap |

---

### Maintenance — EPIC-MAINT (out-of-wave)

> Product-story census is **41** (unchanged). S-MAINT-001 is a housekeeping story outside the wave schedule; it does not block Phase-3.

| ID | Title | Behavioral Contracts | Subsystem | Target Crate | Pri | Pts | depends_on | Status |
|----|-------|---------------------|-----------|-------------|-----|-----|------------|--------|
| S-MAINT-001 | BC Corpus Section Formatting Normalization | [] | — | .factory/specs/behavioral-contracts/ | P2 | 5 | [] | draft |

---

## Conventions

> **Story BC-table "Title" cells** must be BYTE-EXACT to the corresponding BC's canonical H1
> as it appears in the BC file, including any angle-bracket escaping as-is (e.g., `pregolya-\<provider\>-sdk`
> stays escaped; `<Target=str>` stays unescaped — NOT normalized to a house style).
> Enforced corpus-wide since round-79 (D-353; F-P2A251-02; orchestrator Option A, human-confirmed 2026-09-02).
> The canonical BC H1 is authoritative per `BC-INDEX.md` (POL-7/POL-8).
> BC IDs and AC traces (`traces to BC-S.SS.NNN`) are the authoritative cross-references.

> **VP annotation in BC-coverage-map** `(VP-NNN)` suffix is REQUIRED for ALL BCs that appear as
> a `bc_anchor` entry in VP-INDEX (i.e., the BC is the primary anchor of a registered VP). When a
> VP dual-anchors two BCs (e.g., VP-017 anchors both BC-2.02.007 and BC-2.02.008), BOTH cells
> carry the `(VP-NNN)` annotation. Asymmetric annotation — one sibling annotated, the other not —
> is a recordkeeping defect. Rule codified R52 / F-P2A218-01.

> **`verification_properties` frontmatter field** holds canonical VP-INDEX IDs (`VP-0NN`) or `[]`.
> BC-local VP IDs (defined within a BC's §Verification Properties section and deliberately NOT
> registered in VP-INDEX) are documented in the story body, not in this frontmatter field.
> Example: S-1.08 uses VP-SPLIT-01..08 (BC-local, BC-2.07.001/002/003 §Verification Properties);
> these appear in the S-1.08 body's §Behavioral Contracts note, not in the frontmatter array.
> A validator checking `verification_properties ⊆ VP-INDEX` must not flag S-1.08 as having gaps
> because its frontmatter correctly holds `[]`.

> **Status axes:** `STORY-INDEX` `Status: draft` = story-document lifecycle_status (pre-merge); `sprint-state.yaml` `status: spec-ready` = Phase-3 delivery-readiness. Distinct vocabularies; both intentionally uniform pre-Phase-3.

---

## BC to Story Coverage Map

> **All 140 BCs covered. Zero silent gaps.**
> P2 BCs (BC-2.17.001, BC-2.17.002, BC-2.19.004) are explicitly assigned to stories — they are
> in v1 scope at lower priority, not post-v1 deferrals.

### SS-01 Core Primitives (8 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.01.001 | Typed ContentBlock Sequence Construction | S-1.03 | P0 |
| BC-2.01.002 | Message Type-Safety | S-1.03 | P0 |
| BC-2.01.003 | Runnable Trait Invocation | S-1.04 | P0 |
| BC-2.01.004 | Runnable Pipe Composition | S-1.04 | P0 |
| BC-2.01.005 | RunnableParallel Construction and Concurrent Invocation | S-1.05 | P1 |
| BC-2.01.006 | RunnableParallel Branch Failure | S-1.05 | P1 |
| BC-2.01.007 | RunnablePassthrough Identity Pass-Through | S-1.05 | P1 |
| BC-2.01.008 | RunnableAssign Dict Augmentation | S-1.05 | P1 |

### SS-02 StateGraph Definition (9 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.02.001 | StateGraph Node Definition | S-1.14 | P0 |
| BC-2.02.002 | LastValue/Append/BarrierValue Channel Semantics | S-1.14 | P0 |
| BC-2.02.003 | NamedBarrierValue Missing-Writer Boundary (RG) | S-1.14 | P0 |
| BC-2.02.004 | EphemeralValue Cleared-After-Super-Step (RG) | S-1.14 | P0 |
| BC-2.02.005 | Conditional Edge Routing Function | S-1.15 | P0 |
| BC-2.02.006 | Send API Dynamic Fan-Out | S-1.15 | P0 |
| BC-2.02.007 | LedgerChannel Dedup-Idempotent Append (VP-017) | S-1.28 | P1 |
| BC-2.02.008 | LedgerChannel First-Appearance Ordering (VP-017) | S-1.28 | P1 |
| BC-2.02.009 | PromoteRetireChannel Promote/Retire Lifecycle (VP-020) | S-1.28 | P1 |

### SS-03 BSP Execution Engine (3 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.03.001 | BSP Super-Step Execution Determinism (VP-001) | S-1.16 | P0 |
| BC-2.03.002 | Concurrent LastValue Write Rejection | S-1.16 | P0 |
| BC-2.03.003 | Deterministic Reducer Application Order | S-1.16 | P0 |

### SS-04 Durable Checkpointing (11 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.04.001 | Per-Task put_writes Contract | S-1.10 | P0 |
| BC-2.04.002 | Sync Durability Tier Default | S-1.10 | P0 |
| BC-2.04.003 | Monotonic Logical-Clock Checkpoint IDs | S-1.10 | P0 |
| BC-2.04.004 | Fork Lineage via parent_checkpoint_id | S-1.10 | P0 |
| BC-2.04.005 | Crash Recovery — No Re-Execution | S-1.10 | P0 |
| BC-2.04.006 | Session Triple-Address Uniqueness (VP-002) | S-1.10 | P0 |
| BC-2.04.007 | Encryption at Rest — State and Event Payloads | S-1.10 | P0 |
| BC-2.04.008 | FTS Conversation Search | S-1.11 | P1 |
| BC-2.04.009 | TrajectoryWriter::put_record Durability | S-2.12 | P1 |
| BC-2.04.010 | TrajectoryReader::replay Ascending step_idx Order | S-2.12 | P1 |
| BC-2.04.011 | Trajectory Compaction Isolation | S-2.12 | P1 |

### SS-05 HITL Interrupt / Resume (8 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.05.001 | Interrupt Suspension | S-1.20 | P0 |
| BC-2.05.002 | FIFO Resume-Value Delivery | S-1.20 | P0 |
| BC-2.05.003 | Interrupted Node Re-Executes from Start | S-1.20 | P0 |
| BC-2.05.004 | Command(resume=value) API | S-1.20 | P0 |
| BC-2.05.005 | Resume on Empty Queue Returns Err | S-1.20 | P0 |
| BC-2.05.006 | Risk-Tiered Interrupt Classification | S-1.20 | P0 |
| BC-2.05.007 | PreToolCallHook Dispatch — Fail-Closed (VP-011) | S-1.23 | P1 |
| BC-2.05.008 | Skip-Hook-on-Resume Invariant | S-1.23 | P1 |

### SS-06 Streaming Event Taxonomy (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.06.001 | Typed Per-Phase Event Taxonomy — 16 Variants | S-1.17 | P0 |
| BC-2.06.002 | run_id + parent_ids Correlation | S-1.17 | P0 |
| BC-2.06.003 | Streaming and Unary Identical Final Answer | S-1.17 | P0 |
| BC-2.06.004 | tool_approval_request StreamEvent | S-1.24 | P1 |
| BC-2.06.005 | tool_approval_resolved StreamEvent | S-1.24 | P1 |
| BC-2.06.006 | compaction_event StreamEvent | S-1.24 | P1 |

### SS-07 Text Splitting (3 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.07.001 | Chunk Boundaries Are Unicode Code-Point Counts | S-1.08 | P0 |
| BC-2.07.002 | Non-ASCII Boundary Parity with Python Reference (RG) | S-1.08 | P0 |
| BC-2.07.003 | Short Document — Single Chunk, No Overlap, No Panic | S-1.08 | P0 |

### SS-08 Provider Conformance + Standard Tests (14 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.08.001 | Chat Model Streaming Completions Conformance | S-2.07 | P1 |
| BC-2.08.002 | Chat Model Tool-Call Round-Trip Conformance | S-2.07 | P1 |
| BC-2.08.003 | Chat Model Structured Output Conformance | S-2.07 | P1 |
| BC-2.08.004 | Chat Model Error-Type Fidelity | S-2.07 | P1 |
| BC-2.08.005 | Chat Model Token-Usage Accounting | S-2.07 | P1 |
| BC-2.08.006 | Standalone SDK Crate Split Architecture | S-2.06 | P1 |
| BC-2.08.007 | Transport Error Surfaces Err — Not Truncated Success | S-2.07 | P1 |
| BC-2.08.008 | Eval Score Aggregation — Arithmetic Mean + InfraError | S-2.08 | P1 |
| BC-2.08.009 | Tool Schema Naming Stability | S-2.08 | P1 |
| BC-2.08.010 | #[tool] Attribute Macro | S-1.07 | P1 |
| BC-2.08.011 | #[entrypoint] Attribute Macro | S-1.07 | P1 |
| BC-2.08.012 | #[task] Attribute Macro | S-1.07 | P1 |
| BC-2.08.013 | Pluggable Tool-Call Dialect Seam | S-2.08 | P1 |
| BC-2.08.014 | Provider Failover Chain | S-2.08 | P1 |

### SS-09 MCP Tool Adapter (8 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.09.001 | MCP Server Tool Discovery and Registration | S-2.10 | P1 |
| BC-2.09.002 | ToolInvocation Routing to Correct MCP Server | S-2.10 | P1 |
| BC-2.09.003 | Tool-Result Content Treated as Untrusted Ingress | S-2.10 | P1 |
| BC-2.09.004 | MCP Bare ToolException Re-Raise (RG) | S-2.10 | P1 |
| BC-2.09.005 | MultiServerMcpClient Holds No Live Connections (RG) | S-2.10 | P1 |
| BC-2.09.006 | MCP Server Tool Advertisement (tools/list) | S-2.11 | P1 |
| BC-2.09.007 | MCP Server Tool Invocation (tools/call) | S-2.11 | P1 |
| BC-2.09.008 | StateGraph-as-MCP-Tool Wrapping (GraphAgentTool; mcp::graph_tool) | S-2.11 | P1 |

### SS-10 Budget Governance (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.10.001 | BudgetPolicy allow/escalate/deny Evaluation | S-1.18 | P0 |
| BC-2.10.002 | Append-Only EvidenceJournal | S-1.18 | P0 |
| BC-2.10.003 | Graceful Halt When Budget Ceiling Reached | S-1.18 | P0 |
| BC-2.10.004 | Budget Escalation to HITL Interrupt | S-1.18 | P0 |
| BC-2.10.005 | CompactionTrigger Config — Watermark Arithmetic (VP-012) | S-1.25 | P1 |
| BC-2.10.006 | Compaction Execution — Mid-Run Window Replacement | S-1.25 | P1 |

### SS-11 Content Provenance / Guardrail (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.11.001 | ProvenanceTag at Every Ingress Boundary | S-1.19 | P0 |
| BC-2.11.002 | GuardrailHook at Tool-Result Ingress | S-1.19 | P0 |
| BC-2.11.003 | GuardrailHook at RAG Ingress | S-1.19 | P0 |
| BC-2.11.004 | GuardrailHook at Memory Ingress | S-1.19 | P0 |
| BC-2.11.005 | Rejected Content Never Enters Model Context | S-1.19 | P0 |
| BC-2.11.006 | No-Hook Default — Pass-Through with WARNING LOG | S-1.19 | P0 |

### SS-12 Durable-Run HTTP Server (7 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.12.001 | Thread Resource CRUD | S-1.26; S-console-07 (roadmap, Wave 3 — ?checkpoint_id PC-015 variant) | P1 |
| BC-2.12.002 | Assistant Resource CRUD | S-1.26 | P1 |
| BC-2.12.003 | Run Creation and Execution Lifecycle | S-1.26; S-console-07 (roadmap, Wave 3 — consumes {INV-009} fork-start via BC-2.24.005 {PC-003}) | P1 |
| BC-2.12.004 | CronSchedule Creation and Proactive Run | S-1.27 | P1 |
| BC-2.12.005 | SecurityConfig::default() Denies CORS | S-1.27 | P1 |
| BC-2.12.006 | IdempotencyStore / RateLimitStore / RunStore Seams | S-1.27 | P1 |
| BC-2.12.007 | Streaming and Unary Same Graph Engine | S-1.27 | P1 |

### SS-13 Sandboxed Tool Execution (7 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.13.001 | Enforcing Sandbox Backend Is Default | S-1.09 | P1 |
| BC-2.13.002 | Process Backend Requires Explicit Opt-In | S-1.09 | P1 |
| BC-2.13.003 | Strict Policy + Non-Enforcing Backend Returns Err | S-1.09 | P1 |
| BC-2.13.004 | Workspace File Ops Call canonicalize_beneath_root (VP-003) | S-1.09 | P1 |
| BC-2.13.005 | Symlink Workspace Escape Returns Err | S-1.09 | P1 |
| BC-2.13.006 | macOS Seatbelt Deny-by-Default Profile | S-1.09 | P1 |
| BC-2.13.007 | Environment Variable Sanitization | S-1.09 | P1 |

### SS-14 Typed Error Taxonomy (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.14.001 | PregolyaError 2D Component × Category Struct | S-1.01 | P0 |
| BC-2.14.002 | RFC-7807 Compatible Problem Emission | S-1.01 | P0 |
| BC-2.14.003 | All Library Constructors Return Result; No unwrap | S-1.02 | P0 |
| BC-2.14.004 | Every Outbound HTTP Client Must Set .timeout(30s) | S-1.02 | P0 |
| BC-2.14.005 | API Key Newtype with Redacted Debug | S-1.02, S-2.06 | P0 |
| BC-2.14.006 | Validation Failures Propagate Err; No Silent None | S-1.02 | P0 |

### SS-15 Long-Horizon Memory (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.15.001 | KV and Vector Memory Persistence Across Threads | S-1.12 | P1 |
| BC-2.15.002 | User/App/Session Tier Isolation | S-1.12 | P1 |
| BC-2.15.003 | GDPR Erasure — All Traces from All Memory Tiers | S-1.12 | P1 |
| BC-2.15.004 | SkillStore Registry — Load-on-Demand Skill Documents | S-1.13 | P1 |
| BC-2.15.005 | Guarded Memory and Skill Writes (MemoryWriteGuard) | S-1.13 | P1 |
| BC-2.15.006 | Frozen-Snapshot Context Mutation | S-1.13 | P1 |

### SS-16 Tool Retry + Circuit Breaker (3 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.16.001 | Per-Tool Retry Policy Keyed by tool_name | S-1.06 | P1 |
| BC-2.16.002 | Finite global_limit Non-None Default | S-1.06 | P1 |
| BC-2.16.003 | Circuit Breaker Trips After Repeated Failure | S-1.06 | P1 |

### SS-17 Formal Verification Pipeline (2 BCs — P2)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.17.001 | Six P0 Kani VP Obligations + Three P1 Kani VP Obligations | S-6.01 | P2 |
| BC-2.17.002 | cargo-fuzz Targets — Serialization and Graph-Execution Paths | S-6.01 | P2 |

### SS-18 Prompt Templates (5 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.18.001 | PromptTemplate F-String Rendering | S-2.04 | P1 |
| BC-2.18.002 | ChatPromptTemplate Multi-Message Rendering | S-2.04, S-2.05 | P1 |
| BC-2.18.003 | MessagesPlaceholder and FewShotPromptTemplate | S-2.04 | P1 |
| BC-2.18.004 | injection_guard — TrustLevel Untrusted Raises E-TMPL-001 (VP-006, RG) | S-2.05 | P1 |
| BC-2.18.005 | SlotTrustPolicy TrustAll Raises E-TMPL-002 at Construction (RG) | S-2.05 | P1 |

### SS-19 LC Serialization / Round-Trip Registry (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.19.001 | LcSerializable Round-Trip (VP-007) | S-2.01 | P1 |
| BC-2.19.002 | lc_secrets() Credential Stripping Before Serialization | S-2.01 | P1 |
| BC-2.19.003 | Inventory-Based Type Registry — OnceLock Allowlist | S-2.01 | P1 |
| BC-2.19.004 | Legacy Namespace Remap — OLD_CORE_NAMESPACES_MAPPING | S-2.01 | P2 |
| BC-2.19.005 | Reviver Allowlist Containment — E-SRLZ-001 Fail-Closed (VP-010, RG) | S-2.01 | P0 |
| BC-2.19.006 | Langchain Monolith Type Ids Return E-SRLZ-002 | S-2.01 | P1 |

### SS-20 Document Retrieval (3 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.20.001 | Retriever Trait — Arc<dyn Retriever> Graph Seam | S-2.02 | P1 |
| BC-2.20.002 | RAGRetrieval Guardrail Coverage Obligation (RG) | S-2.02 | P0 |
| BC-2.20.003 | VectorStoreRetriever SearchType Config | S-2.03 | P1 |

### SS-21 VectorStore Abstraction (4 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.21.001 | VectorStore Trait — Instance-Method Surface | S-2.03 | P1 |
| BC-2.21.002 | InMemoryVectorStore — Arc DI, RwLock, Vec<f32> Cosine | S-2.03 | P1 |
| BC-2.21.003 | Zero-Norm Vector Guard — VP-009 Kani P0 (RG) | S-2.03 | P0 |
| BC-2.21.004 | MetadataFilter — Eq/Ne/In FilterClause | S-2.03 | P1 |

### SS-22 Embeddings (3 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.22.001 | Embeddings Trait — Dimensionality Contract (VP-008) | S-2.09 | P1 |
| BC-2.22.002 | EmbeddingsOpenAI — Credential Opacity and Batch Failure (RG) | S-2.09 | P1 |
| BC-2.22.003 | EmbeddingsOllama — POST /api/embed and Legacy Toggle | S-2.09 | P1 |

### SS-23 First-Party Tool Library (6 BCs)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.23.001 | ReadFileTool — PathGuard-Confined File Read | S-1.21 | P1 |
| BC-2.23.002 | WriteFileTool — Atomic Write; High ActionRisk | S-1.21 | P1 |
| BC-2.23.003 | EditFileTool — Exact-Match Replace; Fuzzy Fallback | S-1.21 | P1 |
| BC-2.23.004 | ListDirTool — PathGuard-Confined Directory Listing | S-1.21 | P1 |
| BC-2.23.005 | BashTool — Non-Lowerable Medium Risk Floor (VP-013) | S-1.22 | P1 |
| BC-2.23.006 | GrepTool — In-Process Regex; Linear-Time DFA | S-1.22 | P1 |

### SS-24 Developer Console (8 BCs — Wave 3 ROADMAP-ONLY)

| BC ID | Title (abbreviated) | Story | Priority |
|-------|---------------------|-------|---------|
| BC-2.24.001 | `pregolya-console` Startup, Asset Serving, and `ConsoleConfig` | S-console-01, S-console-02, S-console-05 | P1 |
| BC-2.24.002 | `DebugSpanExporter` Retention-Capped Ring Buffer and Trace-Read Debug Endpoints | S-console-02, S-console-03 | P1 |
| BC-2.24.003 | Graph-Descriptor Structural Contract — `GET /assistants/{id}/graph` | S-console-04 | P1 |
| BC-2.24.004 | Run Inspection Event Timeline and Live Monitoring Panel | S-console-05, S-console-06 | P1 |
| BC-2.24.005 | Checkpoint History Browser and Fork-from-Checkpoint Trajectory Replay | S-console-07 | P1 |
| BC-2.24.006 | HITL Approval Dialog and Resume Dispatch | S-console-08 | P1 |
| BC-2.24.007 | Token/Context Budget Monitoring Panel | S-console-09 | P1 |
| BC-2.24.008 | Guardrail/Security Decision Review Panel | S-console-10 | P1 |

---

## VP to Story Anchor Map

| VP | BC Anchor | Story | Priority | Crate |
|----|-----------|-------|---------|-------|
| VP-001 | BC-2.03.001 | S-1.16 | P0 | pregolya-graph |
| VP-002 | BC-2.04.006 | S-1.10 | P0 | pregolya-checkpoint |
| VP-003 | BC-2.13.004 | S-1.09 | P0 | pregolya-sandbox |
| VP-004 | BC-2.09.004 | S-2.10 | P1 | pregolya-mcp |
| VP-005 | BC-2.09.005 | S-2.10 | P1 | pregolya-mcp |
| VP-006 | BC-2.18.004 | S-2.05 | P1 | pregolya-prompts |
| VP-006-B | BC-2.18.004 {PC-005} | S-2.05 | P1 | pregolya-prompts |
| VP-007 | BC-2.19.001 | S-2.01 | P1 | pregolya-core |
| VP-008 | BC-2.22.001 | S-2.09 | P1 | pregolya-core |
| VP-009 | BC-2.21.003 | S-2.03 | P0 | pregolya-vectorstores |
| VP-010 | BC-2.19.005 | S-2.01 | P0 | pregolya-core |
| VP-011 | BC-2.05.007 | S-1.23 | P0 | pregolya-graph |
| VP-012 | BC-2.10.005 | S-1.25 | P1 | pregolya-core (watermark_arithmetic_harness) |
| VP-013 | BC-2.23.005 | S-1.22 | P1 | pregolya-tools |
| VP-014 | BC-2.01.005 + BC-2.01.006 | S-1.05 | P1 | pregolya-core |
| VP-015 | BC-2.09.007 {INV-003} | S-2.11 | P1 | pregolya-mcp |
| VP-016 | BC-2.09.008 {INV-001} | S-2.11 | P1 | pregolya-mcp |
| VP-017 | BC-2.02.007 + BC-2.02.008 | S-1.28 | P1 | pregolya-graph |
| VP-018 | BC-2.04.011 {INV-001} | S-2.12 | P1 | pregolya-checkpoint |
| VP-019 | BC-2.04.011 {INV-003} | S-2.12 | P1 | pregolya-checkpoint |
| VP-020 | BC-2.02.009 {INV-001}+{INV-002} | S-1.28 | P1 | pregolya-graph |
| VP-2.24.001-A | BC-2.24.001 | S-console-01 | P1 | pregolya-console |
| VP-2.24.001-B | BC-2.24.001 | S-console-01 | P1 | pregolya-console |
| VP-2.24.001-C | BC-2.24.001 | S-console-01 | P1 | pregolya-console |
| VP-2.24.002-A | BC-2.24.002 | S-console-02 | P1 | pregolya-console |
| VP-2.24.002-B | BC-2.24.002 | S-console-02 | P1 | pregolya-console |
| VP-2.24.002-C | BC-2.24.002 | S-console-03 | P1 | pregolya-server |
| VP-2.24.002-D | BC-2.24.002 | S-console-02 | P1 | pregolya-console |
| VP-2.24.003-A | BC-2.24.003 | S-console-04 | P1 | pregolya-graph |
| VP-2.24.003-B | BC-2.24.003 | S-console-04 | P1 | pregolya-graph |
| VP-2.24.003-C | BC-2.24.003 | S-console-04 | P1 | pregolya-graph |
| VP-2.24.004-A | BC-2.24.004 | S-console-06 | P1 | pregolya-console |
| VP-2.24.004-B | BC-2.24.004 | S-console-06 | P1 | pregolya-console |
| VP-2.24.005-A | BC-2.24.005 | S-console-07 | P1 | pregolya-console |
| VP-2.24.005-B | BC-2.24.005 | S-console-07 | P1 | pregolya-console |
| VP-2.24.006-A | BC-2.24.006 | S-console-08 | P1 | pregolya-console |
| VP-2.24.006-B | BC-2.24.006 | S-console-08 | P1 | pregolya-console |
| VP-2.24.007-A | BC-2.24.007 | S-console-09 | P1 | pregolya-console |
| VP-2.24.007-B | BC-2.24.007 | S-console-09 | P1 | pregolya-console |
| VP-2.24.008-A | BC-2.24.008 | S-console-10 | P1 | pregolya-console |
| VP-2.24.008-B | BC-2.24.008 | S-console-10 | P1 | pregolya-console |
