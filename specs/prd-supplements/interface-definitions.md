---
document_type: prd-supplement-interface-definitions
level: L3
version: "3.15"
status: active
producer: architect
timestamp: 2026-09-09T00:00:00Z
phase: 1d
changelog:
  - "3.15 (DC-58/F-PDC58-01+OBS-PDC58-1/2026-09-09, architect): F-PDC58-01 [HIGH] Add three GuardrailJournal ops to §CheckpointSaver trait — init_guardrail_journal(run_id: Uuid), append_guardrail_entry(run_id: Uuid, entry: &GuardrailEntry), get_guardrail_journal(run_id: Uuid) -> Result<Option<Vec<GuardrailEntry>>, PregolyaError>. All three are async, #[async_trait]-desugared, and object-safe via Arc<dyn CheckpointSaver> (matching the VP-2.11.007-A §Proof Harness double-unwrap pattern). BC anchor updated to include BC-2.11.007. Gate #31 type note updated with GuardrailEntry resolution. Also add canonical GuardrailEntry struct definition (4 fields: boundary: IngressBoundary, result: GuardrailResult, provenance: ProvenanceTag, timestamp_ms: u64; O-PDC34-A no transform_applied; canonical location core::guardrail). OBS-PDC58-1 [LOW] Add explicit derive sets to GuardrailResult (#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]), IngressContent (same), GuardrailSeverity (#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]), IngressBoundary (same), and new GuardrailEntry (#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]). Also add #[non_exhaustive] to all five per CLAUDE.md API surface mandate. PartialEq + Debug: VP-2.11.007-A assert_eq!(journal[0].result, GuardrailResult::Pass); Serialize + Deserialize + Clone: checkpoint-backed persistence. Harness asymmetry (journal[0] assert_eq!/unit-variant vs journal[1]/[2] matches!/struct-variant) is intentional and correct — assert_eq! for Pass unit variant, matches!+if-let for Fail/Transform struct variants. No harness normalization needed. TD-VSDD-060 sibling sweep: IngressBoundary added as dependency type for GuardrailEntry.boundary."
  - "3.14 (round-62/F-P2A234-01+F-P2A234-02+F-P2A234-03+OBS-3/2026-09-01): §TrajectoryCompactor: doc comment updated from staging-table to per-run single-transaction DELETE mechanism (ADR-030 §Compaction Atomicity Decision). Error note: add E-TRAJ-006 TrajectoryIntegrityCheckFailed (DURABILITY, Never) for AES-GCM auth-tag mismatch during conflict-detection decrypt (F-P2A234-03). §TrajectoryRetentionPolicy promoted field: add semantics note — step_idx values in promoted are retained even if < retention_frontier (OBS-3). No signature changes."
  - "3.13 (round-58/F-P2A229-01/2026-09-01): F-P2A229-01 [MED] §LedgerChannel PromoteRetireOp<T> enum: add #[derive(Clone, Debug)]. Clone satisfies Channel::Update: Clone; derive is sound because LedgerEntry: Clone (supertrait bundles Clone), so no spurious bound beyond T: LedgerEntry is introduced (does not trigger rustc #26925 — contrast with Default, which is NOT in the LedgerEntry bundle and is why the marker structs use manual Default impls). Debug added conventionally for a data-bearing update enum; conditional on T: Debug (LedgerEntry does not bundle Debug). Doc-comment updated to state rationale. LedgerChannel<T> code block is unaffected (Update = T; T: LedgerEntry implies T: Clone — Channel::Update: Clone already satisfied)."
  - "3.12 (round-57/O-P2A228-A/2026-09-01): O-P2A228-A [OBS] §LedgerChannel Invariants table: BC clause tag format corrected from 2-digit ({INV-1}, {INV-2}) to canonical 3-digit form; semantic mapping corrected from {INV-001}/{INV-002} (monotonic-length and entry_id-set structural invariants) to {PC-001}/{PC-002} (novel-reduce appends / seen-reduce no-op postconditions per BC-2.02.007 §Postconditions — the behaviors described in those rows are postconditions of the reduce call, not the monotonicity/uniqueness invariants)."
  - "3.11 (round-57/F-P2A227-01/2026-09-01): F-P2A227-01 [HIGH] §LedgerChannel: derive(Default) dropped from both LedgerChannel<T> and PromoteRetireChannel<T> marker structs; manual bound-free Default impls restored for both. Rationale: derive(Default) on a generic struct emits a spurious T: Default bound (rustc issue #26925); LedgerEntry does not include Default; the Channel supertrait requires Default for all T: LedgerEntry; the spurious bound violates AC-018/BC-2.02.007 {INV-004}. The canonical form is: impl<T: LedgerEntry> Default for LedgerChannel<T> { fn default() -> Self { Self { _inner: PhantomData } } } (and analogously PromoteRetireChannel). This reverses the derive-only mandate from F-P2A220-01/F-P2A224-03 (recorded as non-realizable in ADR-030 §Decision 3). Doc comments on both structs updated to state 'manual bound-free impl'. No other struct attributes modified."
  - "3.10 (round-55/F-P2A225-04/2026-09-01): F-P2A225-04 [MED] Two chained double-§ citations eliminated per POL-19: (1) §Runnable::invoke doc-comment authority line: ADR-005 §Adjacent Trait Object-Safety Adjudications §Send-Bounded RPITIT → ADR-005 §Send-Bounded RPITIT (single heading). (2) §DynRunnable doc-comment authority line: ADR-005 §Adjacent Trait Object-Safety Adjudications §Send-Bounded RPITIT → ADR-005 §Send-Bounded RPITIT (single heading). §Send-Bounded RPITIT is the most-specific heading in ADR-005 for both citations (subsection of §Adjacent Trait Object-Safety Adjudications)."
  - "3.09 (round-54/F-P2A224-03/2026-09-01): F-P2A224-03 [HIGH] §LedgerChannel: LedgerChannel<T> and PromoteRetireChannel<T> marker structs corrected to canonical round-53 derive-set (F-P2A220-01 canon; BC-2.02.007 §Architecture Anchors; S-1.28 Rule 13). (a) LedgerChannel<T>: removed #[derive(Debug, Clone)]; replaced with #[derive(Default)]; deleted manual impl<T: LedgerEntry> Default for LedgerChannel<T> block — derive form is the canonical shape. (b) PromoteRetireChannel<T>: same corrections. No other types in this section are modified — unrelated #[derive(Debug, Clone)] annotations on other types (RunnableConfig, StreamEvent, etc.) are untouched."
  - "3.08 (round-53/F-P2A220-04+F-P2A222-03+F-P2A223-02/2026-08-31): §TrajectoryCompactor error note: removed stale '(pending PO mint)' placeholder on E-TRAJ-005 — E-TRAJ-005 TrajectoryCompactionFailed is minted (error-taxonomy.md; BC-2.04.011 §Changelog (round-52)); replaced placeholder with '(minted; BC-2.04.011 {PC-006})'. Records-tier cleanup only; no structural changes."
  - "3.07 (round-52/F-P2A216-01+F-P2A216-02+F-P2A216-05+F-P2A216-06+F-P2A219-01+F-P2A217-03/2026-08-31): F-P2A216-02 [HIGH] Add §Serializer section (core::serializer, pregolya-core) — object-safe trait with serialize(&self, &[u8])->Result<Vec<u8>, PregolyaError> + deserialize inverse; EncryptedSerializer (checkpoint::serializer, pregolya-checkpoint) as concrete impl; Arc<dyn Serializer + Send + Sync> is the DI seam for both CheckpointSaver and checkpoint::trajectory concrete impl (ADR-030 §Decision 2 at-rest confidentiality, BC-2.04.007 {INV-003}, BC-2.04.009 {INV-002}). F-P2A216-01 [HIGH] §TrajectoryRetentionPolicy BC anchor: removed dead {INV-004} reference — eligible and retained are complements by construction; no external validation required; E-TRAJ-004 / {PC-005} / {INV-004} are retired as structurally unreachable (PO action: remove from BC-2.04.011 and error-taxonomy). F-P2A219-01 [HIGH] §TrajectoryCompactor error note: removed phantom 'E-TRAJ-002 TrajectoryCompactionFailed' (E-TRAJ-002 = ConflictingDuplicate/VAL, unrelated); removed E-TRAJ-004 (retired); replaced with generic DURABILITY note citing E-TRAJ-005 pending PO mint; fixed crash-recovery language to WAL-correct (F-P2A217-03 [MED]): 'rollback journal' → 'uncommitted WAL frames discarded on next open'. F-P2A216-05 [MED] §TrajectoryRetentionPolicy frontier doc: replaced contradictory parenthetical '(highest step_idx ≤ retention_frontier)' with unambiguous threshold definition — retention_frontier is exclusive lower bound for eligibility (< means eligible; >= means retained, including the frontier record). F-P2A216-06 [LOW] §LedgerChannel doc: LastValueChannel/AppendChannel replaced with canonical S-1.14 names LastValue<T>/BinaryOperatorAggregate<T, Op>."
  - "3.06 (round-51/F-P2A212-01+F-P2A212-07/2026-08-31): F-P2A212-01 [HIGH] §Trajectory Primitive: TrajectoryRecord::new(run_id, step_idx, event_kind, payload) constructor added (impl block after struct — #[non_exhaustive] cross-crate construction fix; SqliteTrajectoryStore/pregolya-checkpoint and test callers unblocked); TrajectoryRetentionPolicy::new(retention_frontier, promoted) constructor added (same fix). §LedgerChannel: Default impls added for LedgerChannel<T> and PromoteRetireChannel<T> (zero-sized markers; defensive cross-crate construction; registration seam is type-level, BSP engine constructs internally). F-P2A212-07 [LOW] §LedgerChannel LedgerChannel<T> docstring: IndexMap<String,T> local-variable reference replaced with Vec linear-scan description (decision: no indexmap dependency — O(n) per reduce call is adequate for typical research accumulator sizes; story-writer: S-1.28 Library table requires no new indexmap entry)."
  - "3.05 (round-50/F-P2A208-02+F-P2A208-03+F-P2A208-10+F-P2A211-07/2026-08-31): F-P2A208-02 [HIGH] §LedgerChannel reconcile to reducer model — LedgerEntry trait gains Serialize+DeserializeOwned bounds (F-P2A211-07 serde requirement for checkpoint resume); LedgerChannel<T> struct: #[non_exhaustive] added, 'Internal: IndexMap' comment removed (contradicted PhantomData<T> zero-storage), docstring rewritten to stateless-reducer-marker model (reducer fn reduce(acc: Vec<T>, update: T) -> Vec<T>, no Result); PromoteRetireChannel<T>: #[non_exhaustive] added (F-P2A208-10), docstring adds stateless-reducer-marker note; LedgerChannel Invariants table: append(e)->Ok(())/entries() replaced with reduce(acc, e)->Vec<T> form (no Result). F-P2A208-03 [MED] §Trajectory Primitive: add TrajectoryRetentionPolicy struct (core::trajectory, eligible-vs-retained frontier model) + TrajectoryCompactor trait (checkpoint::trajectory, async compact); BC anchor extended to include BC-2.04.011."
  - "3.04 (ADR-030 Stage 1/2026-08-31): Add §Trajectory Primitive section (pregolya-core core::trajectory + pregolya-checkpoint checkpoint::trajectory; ADR-030 Decision 2): TrajectoryRecord struct (#[non_exhaustive], run_id/step_idx/event_kind/payload), TrajectoryWriter trait (async put_record), TrajectoryReader trait (async replay). Add §LedgerChannel section (pregolya-graph graph::channels; ADR-030 Decision 3): LedgerEntry trait (entry_id), LedgerChannel<T> struct (dedup-idempotent append), PromoteRetireOp<T> enum (Promote/Retire variants), PromoteRetireChannel<T> struct (promote/retire lifecycle). BC anchors: BC-2.02.007, BC-2.02.008, BC-2.04.009, BC-2.04.010, BC-2.04.011. VP-017 (proptest P1 LedgerChannel dedup-idempotency, BC-2.02.007 anchor)."
  - "3.03 (round-49/F-P2A204-01/2026-08-31): F-P2A204-01 [HIGH] §CheckpointSaver::fts_search — `FtsSearchConfig` missing lifetime parameter. Updated §fts_search doc-comment `config` annotation: `FtsSearchConfig { thread_id: Option<&str> }` → `FtsSearchConfig<'_> { thread_id: Option<&'_ str> }`. Updated method signature: `config: FtsSearchConfig,` → `config: FtsSearchConfig<'_>,`. Lifetime required on stable Rust (E0106); BC-2.04.008 {PRE-003} is the authoritative BC (same burst)."
  - "3.02 (round-49/F-P2A207-02+F-P2A202-01/2026-08-30): F-P2A202-01 [OBS] §BaseChatModel — `bind_tools` and `with_structured_output` edition-2024 RPITIT capture adjudication. `bind_tools(&self) -> Result<impl BaseChatModel, PregolyaError>`: RPITIT in edition 2024 auto-captures `&self` lifetime, making the return non-`'static` and preventing pipeline composition, storage, and spawning. Decision: `Box<dyn BaseChatModel + Send + Sync>` (owned/escapable — `'static` by default; enables `.pipe()`, `Arc` storage, `JoinSet::spawn`). `with_structured_output<T>(&self) -> impl Runnable<Vec<Message>, T>`: same capture issue; `T` bound gains `+ Send + 'static` (required for `Box<dyn Runnable>` to be `Send + Sync`; enables multi-threaded pipeline composition). Decision: `Box<dyn Runnable<Vec<Message>, T> + Send + Sync>`. ADR-005 §BaseChatModel adjudication + §Send-Bounded RPITIT table updated in same burst. F-P2A207-02 [HIGH] Add §InvocationContext section — canonical DI seam for per-run guardrail hook registry; SS-11; BC-2.11.001–006 {PRE-001}; BC-2.09.003 {PRE-002}/{PRE-003}; follows trait-in-core precedent."
  - "3.01 (round-44/F-P2A184-01+F-P2A184-02+F-P2A184-03/2026-08-30): F-P2A184-01 [HIGH] §BaseChatModel::stream_chat E0562 fix — `async fn stream_chat(...)` desugars to nested `impl Trait` inside `impl Future<Output = Result<impl Stream<...>, PregolyaError>>`, which is not permitted on stable Rust (E0562 class; same as Runnable::stream R43 / F-P2A180-01). Boxed the return: changed `async fn stream_chat(...) -> Result<impl Stream<Item = Result<AiMessageChunk, PregolyaError>>, PregolyaError>` to `fn stream_chat(...) -> impl std::future::Future<Output = Result<Pin<Box<dyn Stream<Item = Result<AiMessageChunk, PregolyaError>> + Send>>, PregolyaError>> + Send`. ADR-005 §BaseChatModel adjudication updated and §Send-Bounded RPITIT table BaseChatModel row updated in same burst (see ADR-005 §BaseChatModel adjudication and §Send-Bounded RPITIT table). F-P2A184-02 [MED] §DynRunnableAdapter::stream sketch body corrected: `R::stream(...).await` yields `Result<Pin<Box<dyn Stream<Item = Result<O, PregolyaError>> + Send>>, PregolyaError>` (outer Result must be matched). Sketch updated: on `Err(e)` → fold to single-item error stream via `futures::stream::once`; on `Ok(stream)` → `.map()` to convert O→Value then `Box::pin` (item-type change O→Value requires re-boxing in the adapter). §Runnable::stream doc-comment corrected: 'no re-boxing needed in the adapter' replaced with outer-Result + item-type-change note (re-boxing IS needed in the adapter for O→Value conversion). F-P2A184-03 [MED] §DynTool doc-comment stale 'impl Stream return' updated to 'RPITIT `impl Future` return — opaque, non-dyn-compatible' (post-R43, `Runnable::stream` returns an RPITIT `impl Future` whose output boxes the stream; calling it 'impl Stream return' is inaccurate)."
  - "3.00 (round-43/F-P2A180-01/2026-08-30): F-P2A180-01 [HIGH] §Runnable::stream E0562 fix — nested `impl Stream<Item = Result<Output, PregolyaError>> + Send` inside `impl Future<Output = Result<.., PregolyaError>>` is not permitted on stable Rust (E0562 class; nested `impl Trait` inside an associated-type binding). Boxed the yielded stream to `Pin<Box<dyn Stream<Item = Result<Output, PregolyaError>> + Send>>`, removing the nested `impl Trait` while preserving the outer `+ Send` guarantee on the future. Doc-comment for `stream` updated: replaced 'Both the outer future and the yielded `impl Stream` carry `+ Send`, enabling `DynRunnable::stream` to box the stream into `Pin<Box<dyn Stream + Send>>`' with 'The outer future carries `+ Send`. The yielded stream is `Pin<Box<dyn Stream<Item = ..> + Send>>` — boxed to remove nested `impl Trait` inside `impl Future<Output = ..>` (E0562); the boxed form is directly compatible with `DynRunnable::stream` (no re-boxing needed in the adapter)'. `DynRunnableAdapter::stream` comment updated: `R::stream().await` now yields `Pin<Box<dyn Stream<Item = Result<O, PregolyaError>> + Send>>`; adapter maps `Ok(O) → serde_json::to_value(O)`. ADR-005 §Send-Bounded RPITIT inventory table Runnable row updated in same burst. POL-24 sibling sites outside architect domain: BC-2.01.003 §PC-002 live body cites `impl Stream<Item = Result<Output, PregolyaError>> + Send` return form; BC-INDEX §Changelog (round-36 Runnable E0562 entry); STORY-S-1.04 §stream prose — these are in BC / story domain and require product-owner + story-writer routing to mirror the boxed form."
  - "2.99 (round-42/F-P2A176-01/2026-08-29): F-P2A176-01 [HIGH] §Runnable batch doc-comment expanded with in-task cooperative concurrency canon and `'static` corollary. Default `batch` uses `futures::future::join_all` / `FuturesOrdered` — all `invoke` futures polled concurrently within the calling task; no spawn, no thread-pool parallelism; output order matches input order (BC-2.01.003 {INV-002}). `'static` corollary: the `+ Send` RPITIT future from `invoke(&self, ..)` borrows `&self` and is NOT `'static`; `JoinSet::spawn` (requires `F: Future + Send + 'static`) CANNOT be used in a default `&self` batch implementation; implementors holding `'static` / `Arc<Self>` state MAY override `batch` to spawn via `JoinSet`. Authority: ADR-005 §Send-Bounded RPITIT (corollary added in same burst). Realizability self-validation: (a) futures borrow `&self`, do not escape method — no `'static` requirement; (b) `join_all` / `FuturesOrdered` preserve input order ({INV-002}); (c) all futures carry `+ Send` (RPITIT) so combined future is `Send`. PO: BC-2.01.003 {PC-003} drop Tokio-thread-pool claim — in-task `join_all`/`FuturesOrdered`, no concurrency cap, override-for-JoinSet note. Story-writer: S-1.04 AC-003 same."
  - "2.98 (round-41/F-P2A172-03+F-P2A172-04/2026-08-29): F-P2A172-03 [LOW] DynRunnableAdapter._phantom pub → pub(crate): changed `pub _phantom` to `pub(crate) _phantom` in `DynRunnableAdapter<I, O, R>` struct; `inner` was already `pub(crate)`. Final field visibilities: `pub(crate) inner: R` and `pub(crate) _phantom: std::marker::PhantomData<fn(I) -> O>`. Both fields are now sealed — Criterion-B basis for ADR-023 §Exempt Structs DynRunnableAdapter entry (F-P2A172-02). F-P2A172-04 [LOW] RunnableParallel::new doc-comment prose `(impl Into<String>, Arc<dyn DynRunnable>)` → `(K, Arc<dyn DynRunnable>) pairs where K: Into<String>` — closes prose residue from r40 E0562-class fix (r40 fixed the actual signature; this closes the prose). POL-24 sweep: grep `/// .*impl Into` and `/// .*impl Trait` across all doc-comment lines — sole occurrence was RunnableParallel::new construction line; zero occurrences on RunnablePassthrough::assign or any other constructor doc-comment. Architect mirrors: ADR-023 §Exempt Structs gains DynRunnableAdapter entry (F-P2A172-02)."
  - "2.97 (round-40/F-P2A168-01+F-P2A168-02+F-P2A168-03+F-P2A168-04/2026-08-29): Full LCEL composition surface re-derivation — breaks 3-round recurrence. F-P2A168-01 [HIGH] Runnable::pipe serde bounds asymmetric: r39 declared Input: DeserializeOwned only and NextOutput: Serialize only — this covers adapter construction via into_dyn() but NOT the RunnableSequence own Runnable impl which must (1) serialize typed Input→Value to feed erased first stage and (2) deserialize final Value→NextOutput from erased last stage. Corrected to full symmetric bounds: Input: Serialize+DeserializeOwned+Send+'static, Output: Serialize+DeserializeOwned+Send+'static, NextOutput: Serialize+DeserializeOwned+Send+'static. Doc-comment updated to document all three axes. BC-2.01.004 {PC-001} canonical bounds updated. F-P2A168-02 [MED] Nested impl Trait in associated-type binding non-realizable (E0562-class on stable Rust): `impl IntoIterator<Item = (impl Into<String>, Arc<dyn DynRunnable>)>` uses impl Trait inside an associated-type projection, which is not permitted on stable Rust. Fixed at all 2 interface-definitions sites: RunnableParallel::new and RunnablePassthrough::assign now use named generic K: Into<String>: `pub fn new<K: Into<String>>(steps: impl IntoIterator<Item = (K, Arc<dyn DynRunnable>)>) -> Self`. F-P2A168-03 [MED] RunnableSequence PhantomData<(I,O)> imposes spurious Send+Sync/dropck bounds — sibling DynRunnableAdapter correctly uses PhantomData<fn(I)->O>. POL-24 sibling-consistency: changed _phantom to PhantomData<fn(I) -> O>. Enables a.pipe(b).pipe(c) chaining without requiring I: Sync or O: Sync (function pointers are always Send+Sync). F-P2A168-04 [MED] RunnableSequence fields declared pub contradicts ADR-023 §Criterion-B private-field-seal rationale. Adjudicated pub(crate): restores Criterion-B seal, satisfies BC-2.01.004 TV-002 in-crate inspectability, prevents external construction and exhaustive match without requiring #[non_exhaustive]. All four fields (first, middle, last, _phantom) changed to pub(crate). PO must mirror BC-2.01.004 {PC-001} pipe bounds (symmetric serde). Story-writer must mirror S-1.04 AC-008 (symmetric serde bounds on all three type params)."
  - "2.96 (round-39/F-P2A164-01+F-P2A164-02+F-P2A165-01-blast-radius/2026-08-29): F-P2A164-01 [CRIT] DynRunnable erasure seam E0207 — R38 serde-bounded blanket `impl<I, O, T> DynRunnable for T where T: Runnable<I, O>...` is non-realizable: `I` and `O` appear only in the where-clause, not in Self type `T` (RFC 447 → E0207). Replaced with adapter-wrapper model: `pub struct DynRunnableAdapter<I, O, R> { inner: R, _phantom: PhantomData<fn(I)->O> }` with `#[async_trait] impl<I, O, R> DynRunnable for DynRunnableAdapter<I, O, R> where R: Runnable<I,O>+Send+Sync+'static, I: DeserializeOwned+Send+'static, O: Serialize+Send+'static`. Self-validation: (a) all three params on Self → E0207 cleared; (b) each (I,O,R) triple is a distinct Self type → no E0119; (c) Runnable::invoke +Send RPITIT → Pin<Box<dyn Future+Send>> box cast compiles on stable. Added `IntoDynRunnable<I,O>` ergonomic extension trait providing `.into_dyn()`. Updated: §DynRunnable blanket impl domain paragraph → adapter model; §DynRunnable # Errors E-CORE-003 'blanket boundary' → 'adapter boundary'; DynRunnableAdapter struct + impl + IntoDynRunnable added after DynRunnable trait body. ADR-005 §Send-Bounded RPITIT updated. F-P2A164-02 [MED] Runnable::pipe serde bounds: `next: impl Runnable<Output, NextOutput> + Send + Sync + 'static`; where: `Self: Sized + Send + Sync + 'static, Input: serde::de::DeserializeOwned + Send + 'static, Output: serde::Serialize + serde::de::DeserializeOwned + Send + 'static, NextOutput: serde::Serialize + Send + 'static`; pipe erases self/next via `.into_dyn()`. F-P2A165-01-blast-radius: §GraphAgentTool ForceApproveHooks doc-comment updated — ActionRisk gate now runs BEFORE inner hook (covers AlwaysApprovePolicy / no-hook Approve path, not just PendingHumanApproval; CWE-862 closure). PO must mirror: BC-2.09.008 {INV-004} ActionRisk pre-check canon; BC-2.01.004 {PC-001} pipe serde bounds; +1 TV (write-class + AlwaysApprovePolicy + ForceApproveHooks → Deny + E-MCP-011, TV census 758→759). Story-writer: S-1.04 AC-007/AC-008/{INV-006}/compile-test — adapter model + pipe serde bounds."
  - "2.95 (round-38/F-P2A160-01+OBS-P2A160-01/2026-08-29): F-P2A160-01 [HIGH] DynRunnable blanket-impl domain non-realizable (Runnable<Value,Value> bound prevents typed-stage coercion; E-CORE-003 dead code). Replaced blanket `impl<T: Runnable<Value, Value> + Send + Sync + 'static> DynRunnable for T` with serde-bounded bridging blanket `impl<I, O, T> DynRunnable for T where T: Runnable<I, O> + Send + Sync + 'static, I: serde::de::DeserializeOwned + Send + 'static, O: serde::Serialize + Send + 'static` — blanket now performs concrete serde round-trip internally (deserialize Value→I, Runnable::invoke, serialize O→Value). Makes E-CORE-003 reachable (deserialization failure at the blanket boundary), typed stages coercible to Box<dyn DynRunnable> without E0277, and RunnableSequence<I,O> auto-derives DynRunnable; Value,Value case round-trips trivially with no E0119 coherence overlap. DynRunnable doc-comment updated: 'callers are responsible for JSON round-tripping at the boundary' → blanket performs round-trip internally; §Blanket impl domain paragraph updated to reflect serde-bounded blanket; # Errors updated with E-CORE-003 entry. ADR-005 §Send-Bounded RPITIT updated to reflect serde-bounded blanket domain (R38). OBS-P2A160-01 sibling: §SkillStore scope-encapsulation note 'SkillStore::new(...)' names a constructor on a TRAIT — reworded to 'the SkillStore implementor's new(store, app_id) constructor'; v2.93 changelog narrative updated accordingly. PO must mirror into BC-2.01.003 {INV-006}/{PC-001} and BC-2.01.004 {PC-001}: serde-bounded blanket is the authoritative model for typed-stage coercion and E-CORE-003 reachability. Story-writer must mirror into S-1.04 AC-007/008: typed-stage coercion guarantee."
  - "2.94 (round-34/F-P2A144-01+F-P2A144-02/2026-08-29): F-P2A144-01 [HIGH] Runnable native-async-to-async_trait-façade blanket-bridge non-realizability on stable Rust (E0277 Send-future). Exhaustive Send-RPITIT sweep mandate applied. §Runnable<Input,Output> async methods changed from bare `async fn` (no +Send bound on RPITIT future) to explicit RPITIT form `fn ... -> impl Future<Output = ...> + Send` — the only stable-Rust mechanism to impose Send on an RPITIT future without nightly Return-Type-Notation. `invoke` and `batch` carry `+ Send` on the outer future. `stream` carries `+ Send` on both the outer future and the inner `impl Stream` (required for `DynRunnable::stream` to box the stream into `Pin<Box<dyn Stream + Send>>`). `invoke` doc-comment updated: replaced misleading 'synchronously (blocks async task)' with 'completes when the full result is available (non-streaming)'; added §Send-Bounded RPITIT rationale. DynRunnable doc-comment updated: added §Blanket impl realizability prerequisite paragraph explaining that `Runnable`'s RPITIT `+Send` is the prerequisite for the blanket DynRunnable and DynTool impls to compile on stable Rust. ADR-005 §Adjacent Trait Object-Safety Adjudications updated: added §Send-Bounded RPITIT subsection with canon rule and exhaustive native-async-bridge inventory table (Tool: inherits Runnable fix — no own async methods; BaseChatModel: not behind dyn, stream_chat future need not be Send; SkillStore: not behind dyn — confirmed zero dyn SkillStore sites in corpus). BC signature rows referencing Runnable/Tool async signatures — PO routing flagged for Phase B propagation; architect does NOT edit BCs: BC-2.01.003 (invoke/stream/batch postconditions), BC-2.08.010 (Tool invoke inherited from Runnable), and any BC that cites async fn invoke/stream/batch method shapes. F-P2A144-02 [MED] module-path drift runnables/ (plural) → runnable/ (singular): changed four doc-comment module-path strings in §RunnableSequence, §RunnableParallel, §RunnablePassthrough, §RunnableAssign from pregolya-core/src/runnables/ to pregolya-core/src/runnable/ per module-decomposition.md §core::runnable canonical form. Wider-corpus sweep: BC-2.01.003/004/005/006/007/008 have live-body src/runnables/ occurrences — DO NOT edit (product-owner propagates in Phase B); VP-014 src/runnables/ occurrence is in a historical changelog entry (grandfathered)."
  - "2.93 (round-33/F-P2A140-01+comprehensive-object-safety-audit/2026-08-29): F-P2A140-01 [HIGH] DynRunnable missing #[async_trait] — E0038 non-realizable. Added #[async_trait] above pub trait DynRunnable: Send + Sync. Corrected doc-comment: object-safety comes from #[async_trait] boxed-future desugaring (Pin<Box<dyn Future>>) NOT from explicit receiver — rewrote to match sibling async trait description pattern; preserved ADR-005 §Adjacent Trait Object-Safety Adjudications citation. Comprehensive object-safety audit (break-the-per-round-cycle mandate): three additional async traits used behind dyn lacked #[async_trait] — each defect closes a potential E0038 at Phase 3 compile time: (1) CheckpointSaver — used behind Arc<dyn CheckpointSaver> per ADR-005 §Object-Safety-of-the-5-Method-CheckpointSaver-Trait and bounded-contexts.md; async fn put_writes/get_tuple/list/put/fts_search all needed boxed-future desugaring; (2) GuardrailHook — used as &dyn GuardrailHook in GuardedDocuments::rag_ingress (ADR-014 Decision 6; purity-boundary-map.md core::retriever row); async fn evaluate needed boxed-future desugaring; (3) MemoryStore — used as Arc<dyn MemoryStore> in the SkillStore implementor's new constructor (ADR-012 Decision 1); async fn memory_set/memory_get/memory_delete/memory_search/vector_search/hybrid_search all needed boxed-future desugaring. SkillStore confirmed NOT behind dyn (no Arc<dyn SkillStore> in corpus) — no fix needed. TD-VSDD-060 sibling sweep: no other trait declarations in this file were missed; see companion VP-014 §Proof Harness Skeleton (F-P2A140-02) for impl-side fix."
  - "2.92 (round-27/F-P2A117-01/2026-08-28): §GraphAgentTool GraphToolApprovalPolicy::ForceApproveHooks doc-comment SEC-006 bullet: 'CRITICAL-level structured log' → 'ERROR-level (`tracing::error!`) structured log'. The Rust tracing crate has no CRITICAL level; ERROR is the highest level. Aligns with observability.md log-level column (ERROR) and ADR-029 §Decision-4 prose (corrected in round-26). TD-VSDD-060 sibling sweep: only one occurrence of 'CRITICAL-level structured log' in live body — this line."
  - "2.91 (round-25/F-P2A108-02/2026-08-28): Normalize three spec doc-comment lines from doubled path form to parenthetical form per TD-VSDD-091 notation consistency. §PreToolCallHook code-block comment: `pregolya-core::core::action_risk` → `pregolya-core (core::action_risk)`. §Budget code-block comment: `pregolya-core::core::budget` → `pregolya-core (core::budget)`. Same §Budget code-block execution-engine comment: `pregolya-graph::graph::budget` → `pregolya-graph (graph::budget)`. No semantic changes; parenthetical form is the canonical spec-document convention consistent with module-decomposition.md and ADR-023 §Required Inventory."
  - "2.90 (round-24/O-P2A104-01/2026-08-28): O-P2A104-01 [LOW]: §Tool::schema() and §DynTool::schema() doc-comments generalized. Both previously read 'JSON Schema of the tool's argument struct, derived by schemars::schema_for!' — accurate for the #[pregolya::tool] macro case but inaccurate for two verbatim/passthrough producers: convert_mcp_tool (schema sourced verbatim from the MCP server inputSchema, not re-derived) and GraphAgentTool::from_graph (schema supplied by the caller). Updated both doc-comments to note the schema MAY be schemars-derived (macro case) OR supplied verbatim/by the caller (MCP-adapted and GraphAgentTool cases). BC anchors unchanged; no behavioral change to any trait method."
  - "2.89 (round-23/O-P2A102-04/2026-08-28): O-P2A102-04 [LOW]: StreamEvent::ToolApprovalRequest.prompt type corrected String→Option<String>, aligned to PreToolDecision::PendingHumanApproval { prompt: Option<String> } canonical type and entities-graph.md ToolApprovalRequest entity definition. A None prompt is valid — the approver UI falls back to a default message; the hook is not obligated to supply one. Doc comment updated accordingly. Story-writer propagation required for S-1.24 event-13 acceptance criterion (prompt field type reference)."
  - "2.88 (round-21/OBS-P2A094-2/2026-08-28): §CheckpointSaver fts_search arg comment: added rationale note that FtsSearchConfig.thread_id: Option<&str> is legitimately a string-form FTS scope filter (not Option<Uuid>) — the FTS5 virtual table stores thread_ids as serialized strings; FtsSearchResult.thread_id: String confirms FTS operates in string space; callers with a server-layer Uuid pass .to_string() (OBS-P2A094-2 adjudication). Gate #31 type note: same rationale added inline after FtsSearchConfig definition. This closes OBS-P2A094-2 as LEGITIMATE-&str with documented rationale, preventing re-surface as drift finding."
  - "2.87 (round-19/F-P2A087-02/2026-08-27): §GraphAgentTool GraphToolApprovalPolicy::DenyInterrupts doc-comment: `PreToolCallHook::PendingHumanApproval` → `PreToolDecision::PendingHumanApproval` (F-P2A087-02 HIGH — `PendingHumanApproval` is a variant of enum `PreToolDecision` per BC-2.05.007, NOT an associated item of hook trait `PreToolCallHook` whose only method is `pre_invoke`; sibling `ForceApproveHooks` doc-comment already correctly cited `PreToolDecision::PendingHumanApproval` and is unchanged). TD-VSDD-060 sibling sweep: one live-body `PreToolCallHook::PendingHumanApproval` site in `DenyInterrupts` doc-comment corrected; zero remaining occurrences of `PreToolCallHook::PendingHumanApproval` in live body."
  - "2.86 (round-10/F-P2A072-01+F-P2A072-02+F-P2A072-03/2026-08-27): §GraphAgentTool TYPE-GROUNDING reconciliation. F-P2A072-03 HIGH: `from_graph<S>` redesigned as non-generic: signature changed from `from_graph<S>(name, description, Arc<CompiledGraph<S>>, Fn(&S)->Value) where S: GraphState+Deserialize+JsonSchema` to `from_graph(name, description, Arc<CompiledStateGraph>, schemars::Schema, Fn(&serde_json::Value)->serde_json::Value)`. `CompiledGraph<S>` phantom replaced with `CompiledStateGraph` (non-generic, BC-2.02.001 {PC-001}); `GraphState` phantom removed (NOT a trait — entities-graph.md §GraphState); schema derivation is caller responsibility (`schemars::schema_for!(StateType)` passed as `input_schema`). `extract_output` closure receives `&serde_json::Value` (channel-composed state from `CompiledStateGraph::invoke`) instead of `&S`. Dep-edge source note updated. F-P2A072-02 HIGH: `DenyInterrupts` variant doc-comment `Ok(ToolOutput::Structured)` phantom replaced with `Ok(serde_json::Value from extract_output_result)`. F-P2A072-01 HIGH: `GraphRunner` trait doc-comment `hides CompiledGraph<S>` phantom replaced with `holds Arc<CompiledStateGraph> internally`. TD-VSDD-060 sibling sweep: all three live-body phantom-surface sites in this section corrected in same burst."
  - "2.85 (round-8/F-P2A070-01/2026-08-26): §GraphAgentTool GraphToolApprovalPolicy::DenyInterrupts doc-comment corrected (F-P2A070-01 MED). Two defects fixed: (a) umbrella claim 'Any internal graph interrupt is converted to Err(E-MCP-010)' removed — the PendingHumanApproval→Deny path does NOT raise E-MCP-010; (b) 'graph continues to error terminal state' replaced with 'graph CONTINUES to its own terminal — valid terminal yields Ok; error terminal yields Err with graph's own error (NOT E-MCP-010)'. E-MCP-010 is now correctly scoped to node-level interrupt() parking (RunStatus::Interrupted) only, consistent with BC-2.09.008 {PC-005}/{INV-002}. The 'No interrupted run is persisted to durable checkpoint' statement moved inside the node-level interrupt() bullet where it belongs. TD-VSDD-060 sibling sweep: ForceApproveHooks comment (already correct per round-6 v2.83) and GraphRunner trait comment verified CLEAN — both scope E-MCP-010 to interrupt() only."
  - "2.84 (round-7/F-P2A067-02/2026-08-26): §First-Party Tools error-layer-split doc-comment: E-SBXD-001 name corrected from PathEscapeViolation (never canonical) to WorkspaceEscape (taxonomy canonical; BC-2.13.005, SECURITY). Reconciliation: E-SBXD-001 is the correct code (sandbox-layer escape); only the name label was stale. E-TOOLS-001 PathConfinementViolation on the adjacent line was already correct and is unchanged."
  - "2.83 (round-6/F-064-01/2026-08-26): §GraphAgentTool GraphToolApprovalPolicy::ForceApproveHooks doc-comment rewritten to hardened semantics (F-064-01 HIGH). Replaced pre-hardening fail-open text ('overrides ALL PreToolDecision values ... the tool proceeds unconditionally') with: (a) SEC-007 — overrides ONLY PendingHumanApproval to Approve; Deny and ALL other PreToolDecision values pass through UNCHANGED; (b) SEC-006/F-057-01 — runtime BoundaryApprovalHook ActionRisk gate: action_risk None (undeclared, fail-closed per BC-2.05.006 EC-004/{INV-002}) OR Some(r >= Medium) → Deny + E-MCP-011 ForceApproveWriteBlocked + CRITICAL log; only Some(r < Medium) → Approve; (c) node-level interrupt() still causes Err(E-MCP-010); (d) use-restriction framed as architectural enforcement (runtime gate), not caller-responsibility only. BC anchors in doc-comment: BC-2.09.008 {PC-006} (ForceApproveHooks override semantics), {INV-004} (safety restriction), ADR-029 §Decision 4."
  - "2.82 (round-5/F-LOW-schemars+D2/2026-08-26): §GraphAgentTool: input_schema field type corrected from schemars::schema::RootSchema (removed in schemars 1.0) to schemars::Schema (canonical; LOW schemars finding). Blanket omission blockquote: E-MCP-011 ForceApproveWriteBlocked confirmed library-layer only; disposition census 136→137 (62 blanket; E-MCP-* 10→11); D2 [records]."
  - "2.81 (GAP-01/ADR-029/BC-2.09.008/2026-08-26): §GraphAgentTool added (pregolya-mcp: mcp::graph_tool; new module per ADR-029 §Decision 1). Section covers: `GraphAgentTool` struct (BC-2.09.008 authoritative signature carrier per ADR-029 §behavioral-authority note); `from_graph` constructor (inputSchema derivation from S: schemars::JsonSchema; extract_output closure shape; STATE-ISOLATION invariant anchor {INV-001}); `with_approval_policy` builder; `GraphToolApprovalPolicy` enum (`DenyInterrupts` default fail-closed; `ForceApproveHooks` explicit opt-in with read-only restriction); `GraphRunner` pub(crate) type-erased async trait. Blanket omission note update: E-MCP-010 GraphAgentInterruptDenied (EXEC/Never; library-layer Err return from mcp::graph_tool; never direct HTTP terminal in v1) confirmed library-layer only; E-MCP-* namespace 9→10 codes. Census note appended to blanket omission blockquote. BC anchors: BC-2.09.008 (primary), BC-2.09.006, BC-2.09.007, ADR-029 §Decision 1–5."
  - "2.80 (P2A-040-SS18/2026-08-23): §ChatPromptTemplate PromptValue — struct→enum alignment. Before: `#[non_exhaustive] pub struct PromptValue { pub messages: Vec<(Message, MessageProvenance)> }`. After: `#[non_exhaustive] pub enum PromptValue { String(String), Messages(Vec<(Message, MessageProvenance)>) }` (Send+Sync via auto-trait). Type-shape authority: BC-2.18.002 INV-5 + ADR-015 §PromptValue. BC anchor comment updated to cite BC-2.18.002 INV-5 (replacing stale PC2 struct-field citation). No other live-body site references the old struct field — changelog entry 2.45 citing PromptValue.messages is a historical record, grandfathered per TD-VSDD-091."
  - "2.79 (P2A-027/REVERT-D233/2026-08-22): REVERT D-233 signature flips — both unsupported per POL-46: (1) max_marginal_relevance_search lambda_mult f64→f32 (ADR-014 Decision 2 explicit f32; D-233's 'BC-2.21.001 canonical' citation unsupported — BC does not type lambda_mult; f32 consistent with Vec<(Document,f32)> scores); (2) VectorStoreRetriever.lambda_mult f64→f32 (ADR-014 Decision 2 struct field explicit f32); (3) delete ids &[String]→&[&str] (ADR-014 Decision 2 + BC-2.21.001 PC-2 + TV-004 all &[&str]; D-233's 'BC-2.21.001 PC-5 canonical' citation wrong — PC-5 is the as_retriever postcondition, not delete)."
  - "2.78 (P2A026-01/2026-08-22): §VectorStore Trait — P2A-021 add_documents rename propagated to interface-definitions.md (signature authority). Exhaustive surface reconciliation against BC-2.21.001 PC-2 + ADR-014 Decision 2 canonical. Seven changes: (1) add_texts→add_documents: method renamed; parameter list changed from (texts: Vec<String>, metadatas: Option<Vec<serde_json::Map<String, serde_json::Value>>>) to (docs: Vec<Document>); doc comment updated from 'Add texts (with optional per-text metadata) to the store' to 'Add documents to the store'; BC-anchor-comment updated from 'add_texts semantics' to 'add_documents semantics'. (2) max_marginal_relevance_search: lambda_mult type f32→f64 per BC-2.21.001 canonical (P2A-021 addition); VectorStoreRetriever.lambda_mult field corrected f32→f64 for internal consistency. (3) delete: ids param &[&str]→&[String] per BC-2.21.001 PC-5 canonical. (4) similarity_search_with_filter: filter param MetadataFilter→&MetadataFilter (borrowed ref) per BC-2.21.004 canonical; default body unchanged (filter.filters.is_empty() auto-derefs). Methods similarity_search and similarity_search_with_score verified already correct; no change required. as_retriever verified already correct per F-P174-as-retriever-fallible. TD-VSDD-060 sibling sweep: sole live-body add_texts site was the trait method declaration above; corrected; zero live-body add_texts occurrences remaining. Changelog entries 2.42 ('add_texts / from_texts_sync') and 2.59 ('add_texts') are historical records, grandfathered per TD-VSDD-091."
  - "2.77 (BURST-311/F-P202-01/2026-08-17): §CheckpointSaver — add missing `fts_search` trait method and fix snapshot-assembly doc reference (F-P202-01 HIGH, BC-2.04.008 trait-method vs Tool wrapper drift). (1) Added `async fn fts_search(query: &str, config: FtsSearchConfig) -> Result<Vec<FtsSearchResult>, PregolyaError>` to the CheckpointSaver trait after `get_next_version`; doc comment covers PC3 limit guard (E-CHKPT-008/FtsLimitZero at config.limit=0), EC-002 malformed FTS5 (E-CHKPT-008 at fts_search call time), and EC-006 FTS5-unavailable (E-CHKPT-009). (2) BC anchor note: 'BC-2.04.001 through BC-2.04.007' → 'BC-2.04.001 through BC-2.04.008'; per-method precision for `fts_search` appended. (3) Gate #31 type note: heading and body extended with FtsSearchConfig and FtsSearchResult as RESOLVED types per BC-2.04.008 PC1/PC3 (pregolya-checkpoint/src/fts.rs). (4) ConversationSnapshot doc comment (~§Compaction): 'snapshot assembly from search_history' → 'snapshot assembly from `CheckpointSaver::fts_search` call' (`fts_search` is the trait method called by BudgetEngine; `search_history` is the agent-callable Tool wrapper per BC-2.04.008 PC5). TD-VSDD-060 sibling sweep: two live-body search_history-as-method sites corrected (§CheckpointSaver BC anchor note and §Compaction ConversationSnapshot doc comment); changelog entries citing search_history in v2.26/v2.23 are historical records (grandfathered per TD-VSDD-091)."
  - "2.76 (burst-303/F-P194-01+O-P194-B/2026-08-17): Two corrections to LCEL type blocks (D-170). F-P194-01: Fix invoke_dyn→invoke in RunnablePassthrough doc comment (Zero-cost identity runnable) and RunnableAssign doc comment (invoke_dyn validates → invoke(input, config) validates). The canonical DynRunnable trait uses async fn invoke/stream (not invoke_dyn/stream_dyn, which belongs to DynTool); doc comments must match the trait surface. O-P194-B: Split compound ADR-026 §Decision 1 citation in BC anchor footer — separate into four single-§ citations per POL-19/ADR-022 §Decision 5 no-chained-§ rule: §Decision 1 (IndexMap representation, key ordering), §Decision 2 (fail-fast abort), §Decision 3 (zero-cost identity), §Decision 4 (dict-input validation)."
  - "2.75 (burst-302b/D-170/2026-08-17): Add RunnableParallel, RunnablePassthrough, RunnableAssign type signatures to §Core Primitives (pregolya-core: core::runnable), after the DynRunnable/RunnableSequence BC anchor block and before §RunnableConfig Key Reference. Signatures are verbatim from ADR-026 §Interface-Definitions Additions (committed at D-170). Three blocks added: (1) RunnableParallel — IndexMap fan-out, `new(steps)` constructor; (2) RunnablePassthrough — identity with inspect_fn, `new()` / `with_inspect(f)` / `assign(pairs)` constructors; (3) RunnableAssign — `#[non_exhaustive]` struct, constructed via `RunnablePassthrough::assign`, no public constructor. BC anchors: BC-2.01.005 (RunnableParallel construction/invocation), BC-2.01.006 (branch failure/E-CORE-009), BC-2.01.007 (passthrough identity/inspect contract), BC-2.01.008 (dict augmentation/E-CORE-010/mapper-wins). ADR-026 §Decision 1–4 authority."
  - "2.74 (burst-293/F-01/ADR-023/2026-08-16): §RunnableConfig — apply architect F-01 adjudication. (1) Add `#[non_exhaustive]` to struct declaration — ADR-023 §Required Inventory is authoritative; CLAUDE.md §Code Conventions mandates `#[non_exhaustive]` on all public API surface config structs. (2) Add `#[derive(Debug, Clone)]` to struct declaration. (3) Add `impl Default for RunnableConfig` with `recursion_limit: 25`; `#[derive(Default)]` intentionally absent: `usize::default()` yields 0, which would violate the recursion_limit = 25 default semantics per BC-2.01.003 PC5 and BC-2.03.001 PC5. (4) Doc comment updated: 'All fields are optional at construction except recursion_limit' → external-construction guidance via `RunnableConfig::default()`; struct-literal construction barred outside pregolya-core by `#[non_exhaustive]` (E0639). (5) D-134 sibling sweep: BC corpus already uses `RunnableConfig::default()` throughout — BC-2.01.003 §Canonical Test Vectors TV-001 and BC-2.04.002 §Canonical Test Vectors confirmed correct; no BC changes required."
  - "2.73 (burst-291/D-134/2026-08-16): §-anchor phantom sweep — two phantom BC-2.12.003 §Run-Config Merge Precedence Invariant citations corrected. §Run-Config Merge Precedence Invariant is not a heading in BC-2.12.003 (the item is a bold entry within § Invariants, not its own heading). Corrected to BC-2.12.003 §Invariants at §RunnableConfig doc comment (line 299 context) and §Runs table row. Grandfathered: changelog entry 2.4 citing the same phantom anchor (historical, not a live-body citation)."
  - "2.72 (burst-290/F-180-03, 2026-08-16): Fix live-body phantom ADR §-citation in §StreamEvent Rust code comment. `ADR-023 §exhaustive-by-design` → `ADR-023 §Exempt Enums` (no heading §exhaustive-by-design exists in ADR-023; StreamEvent's exhaustive-match exemption is documented under `### Exempt Enums` within `## Decision 3 — Exempt Inventory`)."
  - "2.71 (F-178-01/F-178-04, burst-289, 2026-08-16): F-178-01 — StreamEvent §StreamEvent: (a) count updated 15→16 variants; breakdown corrected to '11 execution lifecycle + 1 guardrail observability + 2 per-tool-call approval [D23/ADR-018] + 1 compaction [D23/ADR-019] + 1 error [F-P177-B01/ADR-023]'; (b) `Error` variant added to the Rust enum body after `CompactionEvent` with field inventory matching BC-2.06.001 PC2 (run_id, parent_ids, error_code, error_message); (c) BC anchor updated: 'updated D23 15 variants' extended with 'updated F-P177-B01/ADR-023 16 variants'. F-178-04 — §§changelog entry 2.70 phantom anchor: `BC-2.10.003 §recursion_limit_canon (BC-2.03.001)` replaced with `BC-2.03.001 §Description`; `§recursion_limit_canon` is not a heading in BC-2.03.001 (grep ^#{1,6} confirms); the formula lives in the §Description section."
  - "2.70 (F-P177-D02+F-P177-B02-sibling, burst-288, 2026-08-15): (1) D-02 HIGH: Add `#[non_exhaustive]` to `ToolCallPreview` struct declaration. ADR-023 §required-types inventory lists ToolCallPreview as required; the missing annotation was a production-grade violation. (2) B02-sibling HIGH: Change `steps_remaining: Option<u32>` → `Option<i64>` in §BudgetInfo block. Rationale: BC-2.03.001 §Description establishes execution proceeds to recursion_limit + 1 steps; at that step steps_remaining = recursion_limit - (recursion_limit + 1) = -1, which underflows u32. Aligns with tokens_remaining design precedent (already signed i64)."
  - "2.69 (fix-burst-283/F-P175-C101+F-P175-C113/2026-07-30): Two architect adjudications from P1D-175 Slice C1 applied. (1) F-P175-C101 ADR-021 Decision 1: TOML sample config debug_route_key corrected — present-but-empty form 'debug_route_key = \"\"' replaced with commented-absent form. Present-but-empty deserializes via serde to Option::Some(\"\") which BC-2.12.005 EC-005 defines as E-SERVER-013 startup failure; the secure default is absence of the key (None via serde default). BC-2.12.005 body is unchanged — EC-005/TV-007/E-SERVER-013 are correct and remain load-bearing. (2) F-P175-C113 ADR-021 Decision 2: add configurable: Option<HashMap<String, Value>> field to RunnableConfig struct. This is the LangGraph-parity configurable map (semport rust-translation-strategy §RunnableConfig mapping §11); graphs use it to read model, tool-set, and system-prompt overrides at execution time. Enables the Assistant 'reusable agent persona' concept in BC-2.12.002. BC-2.12.002 §Description product-owner handoff: replace fabricated 'model, tools, system prompt overrides, checkpointer config' text; see ADR-021 Decision 2 and fix-burst-283 handoff spec."
  - "2.68 (FIX-BURST-280-corr/F-P175-A24-followup/2026-07-28): Add `validate_embedding_batch` free function spec to §Embeddings Trait (core::embeddings, pregolya-core). Function is `pub`; cross-crate callers are pregolya-openai and pregolya-ollama provider embeddings impls. BC anchors: BC-2.22.001 PC-2 (batch dimensionality contract → E-EMBED-001), INV-2 (consistent inner length), EC-003 (count mismatch), EC-004 (zero-length vector). Error anchor: E-EMBED-001. VP anchor: VP-008 (proptest P1; test harnesses call this function directly per FIX-BURST-280 structural redesign — F-P175-A24 self-proving mock fix). TD-VSDD-060 sibling sweep for unregistered VP-body symbols: see FIX-BURST-280-corr report."
  - "2.67 (fix-burst-279/gap-2-TemplateInput+format_messages/2026-07-28): Gap 2 (BLOCKING) TD-VSDD-060 sweep — format_messages signature and TemplateInput enum. (1) Added `TemplateInput` enum definition (§Prompt Templates, before SlotTrustPolicy): three arms — Scalar(TemplateVar), Messages(MessageListVar), FewShotExamples(Vec<(TemplateVar, TemplateVar)>); #[non_exhaustive]; replaces former bare HashMap<String, TemplateVar> parameter. (2) `format_messages` signature corrected: parameter type `HashMap<String, TemplateVar>` → `HashMap<String, TemplateInput>` (breaking change per ADR-015 §Decision 3 Amendment — TemplateInput Enum Concretized). This is the architect-owned portion of the TD-VSDD-060 sweep; BC-2.18.002/004 PO routing in wave-b-po-routing-spec-279.md item 6 and item 7."
  - "2.66 (fix-burst-279/F-P175-B101+F-P175-B102+F-P175-B208/2026-07-28): Three architect security adjudications applied. (1) B101/B102: SkillStore scope-encapsulation note added (SkillStore impls bind MemoryScope::App(app_id) at construction; trait methods scopeless; E-MEMORY-004 NoScopeContext on missing app_id). RunContext gains app_id: String field (system-derived, not RunnableConfig-overridable; empty = no-scope sentinel). ContextMutationConfig loading note: spec.namespace is a key-namespace prefix within MemoryScope::App(run_context.app_id), not the tenant app_id; composite key = {namespace}/{key}. (2) B208: TrustLevel updated — add #[non_exhaustive]; add #[cfg_attr(kani, derive(kani::Arbitrary))]; add Copy derive; add severity() -> u8 method (Untrusted=2, UserInput=1, Trusted=0); explicit Ord-derivation prohibition added."
  - "2.65 (FIX-BURST-278/L9b-de-pin/2026-07-28): L9b de-pin: two version-pin-to-section-anchor conversions in the FIX-BURST-277-WAVE-B-errata changelog entry. Both pins cited ADR-005 by version number; replaced with ADR-005 §Adjacent Trait Object-Safety Adjudications in both positions (DynTool promise cross-reference and Wave C migration list cross-reference)."
  - "2.64 (FIX-BURST-278/Wave-C-S4+S5/2026-07-28): S4 canon — three lines citing Arc<dyn Tool> (non-object-safe E0038) as a migration origin annotated with non-object-safe qualifier to satisfy verify-signature-canon.sh S4 gate exemption. S5 canon — five PregolyaError doc-comment examples in Rust fences collapsed to abbreviated PregolyaError { code: \"E-XXX\", .. } form per D-42/D-49: (1) DynRunnable # Errors E-CORE-004 (Unicode ellipsis → ASCII ..); (2) BaseChatModel bind_tools E-CORE-005 (two-line multifield doc → single-line abbreviated); (3) CheckpointSaver put E-CHKPT-005 (two-field abbreviated → single-field abbreviated with ..); (4) GuardrailHook evaluate E-CORE-007 (unquoted code string quoted, two-field → abbreviated with ..); (5) ProviderFallbackPolicy new E-PROV-011 (two-line multifield doc → single-line abbreviated, unquoted code string quoted)."
  - "2.63 (FIX-BURST-278/F-P175-D48+D208+D212/2026-07-28): Three findings closed. (1) F-P175-D48 — `as_retriever` receiver corrected to `self: Arc<Self>` (dyn-compatible; see ADR-014 §Decision 2); stale 'Wave C PO correction pending' note removed. (2) F-P175-D208 — add `#[derive(Serialize)]` to `ToolOutput` enum (required for blanket `DynTool` impl to convert `ToolOutput` to `serde_json::Value`); blanket impl comment updated to document that `ToolOutput::Error(String)` maps to `Err(PregolyaError)` — not `Ok(json)` — to prevent silent-error-swallow violation per DI-014 / BC-5.39.001. (3) F-P175-D212 — `core::tools` → `core::tool` (singular) in §Tool subsection module comment per BC-2.08.010 Architecture Anchors canonical form."
  - "2.62 (FIX-BURST-277-WAVE-B-errata/2026-07-28): Add §DynTool trait definition (pregolya-core: core::tool) — fulfills ADR-005 §Adjacent Trait Object-Safety Adjudications promise 'DynTool definition added to interface-definitions.md'; omitted from v2.61. DynTool: object-safe façade replacing Arc<dyn Tool> (non-object-safe E0038) dispatch; exposes invoke_dyn + 4 metadata accessors; blanket impl for T: Tool + Send + Sync + 'static; mirrors DynRunnable pattern. Inserted after ToolOutput enum in §Tool subsection. ADR-005 §Adjacent Trait Object-Safety Adjudications carries the corrected Wave C migration list (BC-2.09.001 Description+PC2 + BC-2.09.002 PC1; prior v1.8 list citing BC-2.05.003/BC-2.05.004/BC-2.08.010 was incorrect)."
  - "2.61 (FIX-BURST-277-WAVE-B/F-P174-constructor+F-P174-retriever-lifetime+F-P174-as-retriever-fallible+F-P174-303/2026-07-27): (1) F-P174-constructor: add §PregolyaError Constructor (before §BaseChatModel) — `PregolyaError::new(component, category, retry_hint, code, message: impl Into<String>) -> Self` and `with_source(self, Arc<dyn Error+Send+Sync>) -> Self` per ADR-010; `#[non_exhaustive]` bars struct-literal from external crates; these are the sole construction paths. (2) F-P174-retriever-lifetime: the lifetime-parameterized `VectorStoreRetriever` (with `'a` parameter) → `VectorStoreRetriever` (no lifetime); `store: &'a dyn VectorStore` → `store: Arc<dyn VectorStore>`; `VectorStoreRetriever` is now `'static` for `Arc<dyn Retriever + 'static>` coercion. (3) F-P174-as-retriever-fallible: `fn as_retriever` (with `&self` receiver, returning the lifetime-parameterized type) → `fn as_retriever(self: Arc<Self>) -> Result<VectorStoreRetriever, PregolyaError>`; returns `Err(E-VS-003)` on invalid config. Impl Retriever updated accordingly. (4) F-P174-303: purge phantom 2-arg `PregolyaError::new(\"E-VS-005\", \"...\")` call in `similarity_search_with_filter` default — replace with canonical 5-arg constructor `PregolyaError::new(Component::Vs, Category::Val, RetryHint::Never, \"E-VS-005\", \"...\")` per ADR-010."
  - "2.60 (F-P173-606+F-P173-607+F-P173-608+F-P173-609+F-P173-610+BC-2.08.004-anchor/fix-burst-276/2026-07-27): Six HIGH findings from adversarial pass P1D-173 content wave 3. (1) F-P173-606: §BaseChatModel Gate #31 type note — retired 'corpus-unresolved / implementer defines' for ChatConfig; replaced with spec-anchored partial definition: mandatory field `fallback_policy: Option<ProviderFallbackPolicy>` sourced from BC-2.08.014 Description and BC-2.08.014 PC1; module placement module-decomposition.md §core::config SS-01; provider-specific parameters documented as per-provider extensions. (2) F-P173-607: §ProviderFallbackPolicy — replaced 'UNRESOLVED (implementer-scope) / flagged for architect' notes on ProviderCredential and CredentialRefreshConfig with unconditional DI-010 obligations: both types MUST implement `Debug` rendering only '<redacted>'; canonical impl form documented; per-provider shape acknowledged as implementation-defined but DI-010 is unconditional. (3) F-P173-609: added new §Tool subsection (before §First-Party Tools) declaring `pub trait Tool` in pregolya-core: core::tools — methods name/description/schema/action_risk from BC-2.08.010 PC1; `ToolInput(serde_json::Value)` struct; `#[non_exhaustive] ToolOutput` enum with Text/Json/Error variants from BC-2.23.001-006 and BC-2.05.007 PC2 (Deny → Error); PathGuard::check phantom NOT reintroduced; ADR-020 Decision 1 source cited. (4) F-P173-608: §First-Party Tools ToolConfig — added private `minimum_risk: ActionRisk` field note as the per-tool identity discriminator that makes VP-013 provable (BashTool sets minimum_risk=Medium at construction; override_risk validates risk >= minimum_risk; exhaustive Kani proof over 4 D-25 variants); doc comment updated from 'Errors (BashTool)' to general 'Errors: when risk < self.minimum_risk'; D-25/D-26/D-27/D-30 all preserved. (5) F-P173-610: §ProviderFallbackPolicy — made `chain` field private (prevents struct-literal bypass of non-empty invariant); added `impl ProviderFallbackPolicy` with `new(chain: Vec<ProviderCredential>) -> Result<Self, PregolyaError>` constructor returning E-PROV-011 when empty (BC-2.08.014 EC-006/TV-007); #[non_exhaustive] added to struct. (6) BC-2.08.004 anchor (routed from content wave 2): replaced cross-check note 'orphaned BC until architect adjudicates' with correct anchoring — `has_tool_calling(&self) -> bool` method added to BaseChatModel trait (BC-2.08.002 EC-005/TV-005 guard); BC-2.08.004 anchored at stream_chat per-method as cross-cutting error-fidelity conformance (all provider HTTP 4xx/5xx must map to typed PregolyaError); trait-level anchor block added documenting cross-cutting scope covering both invoke and stream_chat paths."
  - "2.59 (F-P173-101+F-P173-102+F-P173-701/fix-burst-276/2026-07-27): Three HIGH source-attribution findings from adversarial pass P1D-173. (1) F-P173-101: §PreToolCallHook Source — added ADR-020 Decision 1 as primary source (ActionRisk relocation to pregolya-core: core::action_risk; pregolya-tools cross-crate compile-time consumer motivation; sole authority for ToolCallPreview.action_risk type placement); corrected fail-closed Deny anchor from 'Decision 4' to 'Decision 3 step 4' — ADR-018 Decision 3 step 4 verbatim: Deny { reason } → ToolOutput::Error; tool never invoked; VP-011 Kani P0. (2) F-P173-102: §Compaction Source — corrected CompactionPolicy trait attribution from Decision 2 to Decision 1 (ADR-019 Decision 1 defines all core::budget type definitions: CompactionTrigger, ConversationSnapshot, CompactionSummary, and CompactionPolicy trait; Decision 2 is BudgetConfig extensions: compaction_trigger + compaction_policy fields); corrected mid-run/next-run distinction attribution from Decision 5 to Decision 3 (ADR-019 Decision 3 canonical: 'mid-run state mutation — applies immediately to current run's message window, not next-run'; Decision 5 is CAP-017 Wave Promotion Interaction within-session vs cross-session additive design); BC anchor aligned to ADR-019 Decision 3 canonical language: 'mid-run REPLACEMENT' → 'mid-run state mutation per ADR-019 Decision 3'; BC-2.15.006 NEXT-run description updated with ADR-019 Decision 3 anchor. No phantom on_watermark symbol present or introduced. (3) F-P173-701 (mis-citation class): §VectorStore BC anchor footer — all ADR-014 citations enumerated; per-site corrections: (a) 'Decision 3 (InMemoryVectorStore)' WRONG — ADR-014 Decision 3 is SS-15 Boundary Definition MemoryStore vs VectorStore, zero InMemoryVectorStore content → removed; replaced with ADR-017 Decision 4 (InMemoryVectorStore — Arc<dyn Embeddings> DI + RwLock interior mutability; Arc-DI wiring at construction time; ADR-017 Decision 4 verbatim 'no placeholder construction' invariant); (b) 'Decision 4 (zero-norm guard E-VS-001)' WRONG — ADR-014 Decision 4 is External Adapter Extension Seam via inventory crate → corrected to 'ADR-014 Decision 2 §Hardening note (search-time zero-norm guard E-VS-001)'; (c) 'Decision 5 (write-time zero-norm guard E-VS-004)' CORRECT — kept unchanged. Two correct citations left unchanged: Source line (ADR-014 Decision 2) and similarity_search_with_filter comment (ADR-014 Decision 2 §Metadata filter surface F-P131-07 adjudication). Summary: 2 wrong citations corrected, 1 new ADR-017 Decision 4 citation added, 2 correct citations preserved."
  - "2.58 (F-P173-601+F-P173-602+F-P173-603+F-P173-604+F-P173-605+F-P173-614/2026-07-27): Five signature findings from adversarial pass P1D-173. (1) F-P173-601 CRITICAL: §First-Party Tools — deleted erroneous PathGuard struct/impl block that declared PathGuard in pregolya-tools with a non-canonical check() method. Replaced with a consumption note citing the authoritative owner (pregolya-sandbox, sandbox::path_guard, SS-13, BC-2.13.004, VP-003 Kani P0) and the two confinement entry points (canonicalize_beneath_root_pure/canonicalize_beneath_root); error layer split documented (E-SBXD-001 sandbox layer → E-TOOLS-001 tool layer). BC anchor in §First-Party Tools corrected: 'BC-2.23.001-006 shared PathGuard invariant' → 'consumes BC-2.13.004 PathGuard' per tool; PathGuard ownership row added. (2) F-P173-602 HIGH: §BaseChatModel bind_tools — removed async (construction-time validation, no I/O per BC-2.08.002 EC-005); corrected return type from bare 'impl BaseChatModel' to 'Result<impl BaseChatModel, PregolyaError>'; added # Errors doc block citing Err(E-CORE-005) when has_tool_calling=false (BC-2.08.002 EC-005/TV-005). (3) F-P173-603 HIGH: §BaseChatModel with_structured_output — added required schema: serde_json::Value parameter per BC-2.08.003 PC/EC-002/EC-003; added schemars::JsonSchema bound to T per BC-2.08.009; added per-method anchor citation. (4) F-P173-604 HIGH: §Runnable pipe — corrected return type from opaque 'impl Runnable<Input, NextOutput>' to concrete 'RunnableSequence<Input, NextOutput>' per BC-2.01.004 PC1/PC4/TV-002; added doc comment citing flattening invariant. (5) F-P173-605 HIGH: added new §DynRunnable and RunnableSequence section to §Public Rust Trait Signatures (pregolya-core: core::runnable) — DynRunnable object-safe trait with async invoke and boxed-stream stream method (ADR-005 dyn-compat pattern; BC-2.01.003 EC-001 + BC-2.01.004 PC5/EC-001/TV-004); RunnableSequence<I,O> struct with first/middle/last/PhantomData fields (BC-2.01.004 PC1/PC4/TV-002). (6) F-P173-614 HIGH: expanded bare BC-ID anchors in §Runnable and §BaseChatModel to per-method precision; per-method cross-check run — §Runnable PASS (all 4 methods anchored, no orphan BCs); §BaseChatModel PASS with one flag: BC-2.08.004 unmapped to a declared method (flagged for architect adjudication in cross-check note). TD-VSDD-060 sibling sweep results: see report in this burst."
  - "2.57 (F-P171a-02a+F-P171a-02b+F-P171a-03+date-mono/burst-273/2026-07-25): (1) F-P171a-02a Gate #32 carrier-3: Add §ToolConfig subsection to §First-Party Tools — ToolConfig struct in pregolya-tools::tools::config; override_risk(self, risk: ActionRisk) -> Result<ToolConfig, PregolyaError> builder-consuming validator; BashTool risk < Medium → Err(E-TOOLS-007); #[non_exhaustive]; distinct from BashConfig (per-tool impl config). (2) F-P171a-02b lifecycle adjudication: §PreToolCallHook ActionRisk doc-comment — 'BashTool construction time' → 'ToolConfig::override_risk call time'; §First-Party Tools BashTool doc-comment updated to same lifecycle language. (3) F-P171a-03: BashTool canonical annotation corrected ActionRisk::Medium → ActionRisk::High (default declared annotation; Medium is the non-lowerable floor, not the default); BC anchor and doc-comment updated to match. (4) Date-monotonicity (Gate #28 Rule 4 TEMPORAL-NEIGHBOR SWEEP): entry 2.49 date 2026-07-22 → 2026-07-23 (burst-240 ran on 2026-07-23)."
  - "2.56 (sibling-sweep-ADR-016/burst-272/2026-07-25): §LcSerializable and Reviver Surface BC anchor footer — corrected three ADR-016 Decision mis-attributions found during mandatory sibling sweep (TD-VSDD-060). (1) Decision 1 description expanded from bare '(LcSerializable trait)' to '(crate placement — pregolya-core module, no new crate)'; LcSerializable trait definition is in Decision 2, not Decision 1. (2) Decision 2 description corrected from '(Serialized enum)' to '(LcSerializable trait, Serialized enum, LcEntry; inventory-backed OnceLock type registry)'; Decision 2 is the registry/inventory Decision covering all three types plus OnceLock initialization. (3) Decision 4 description corrected from '(inventory crate 0.3.24, dtolnay; OnceLock initialization)' to '(OLD_CORE_NAMESPACES_MAPPING legacy namespace remapping)'; inventory/OnceLock is Decision 2; version pin '0.3.24' removed (TD-VSDD-091). (4) Decision 5 removed from citation; this section covers crate placement, trait/enum/registry definition, secrets/allowlist safety, and legacy remapping (Decisions 1–4) but contains no Python checkpoint import compatibility surface — Decision 5's domain. (5) Decision 3 description expanded to include Reviver allowlist containment and E-SRLZ-002 per §Security Invariant Properties 1–5, which is the correct Decision for those behaviors (previously mis-attributed to Decision 5)."
  - "2.55 (F-P170-17+F-P170-propagation/burst-272/2026-07-25): (1) F-P170-17 MED: §Prompt Templates BC anchor footer — split Decision 3 and Decision 4 attributions. Before: 'Decision 3 (injection_guard fail-closed semantics), Decision 4 (TrustLevel enum — engine-neutral; both f-string and jinja2 raise E-TMPL-003 on undefined variable)'. After: 'Decision 3 (injection_guard fail-closed semantics; TrustLevel enum), Decision 4 (engine-neutral E-TMPL-003 — both f-string and jinja2 raise on undefined variable)'. TrustLevel is defined in ADR-015 Decision 3; E-TMPL-003 engine-neutral clause is Decision 4. (2) F-P170-propagation: §PreToolCallHook — ActionRisk enum crate/module corrected to pregolya-core: core::action_risk per F-P170-06 architect adjudication. Source line updated to cite pregolya-core (ActionRisk) + pregolya-graph::hitl (PreToolCallHook + re-export). Code block split: ActionRisk in pregolya-core block, PreToolCallHook/ToolCallPreview/PreToolDecision in pregolya-graph block with re-export note."
  - "2.54 (F-P161-01/FIX-BURST-262/2026-07-25): Three BC-2.10.003 version pins de-pinned (TD-VSDD-091 stable-anchor enforcement, F-P161-01). All three sites were NORMATIVE authority citations in §OnCeiling and §BudgetInfo. (1) OnCeiling enum doc comment authority line: 'BC-2.10.003 v1.2 (Halt + Summarize variants for Deny)' → 'BC-2.10.003 (Halt + Summarize variants for Deny)'. (2) BudgetInfo RESOLVED block Authority line: 'BC-2.10.003 v1.2 PC5' → 'BC-2.10.003 PC5'. (3) BC anchor footer BudgetPolicy block: 'BC-2.10.003 v1.2 (OnCeiling Halt + Summarize variants; PC5/INV/TV-007 BudgetInfo shape and arithmetic)' → 'BC-2.10.003 (OnCeiling Halt + Summarize variants; PC5/INV/TV-007 BudgetInfo shape and arithmetic)'."
  - "2.53 (F-P151-01/03/burst-252/2026-07-24): Compaction type canon aligned to ADR-019 v1.4 (adjudicated authority). (1) §Compaction CompactionTrigger enum — F-P151-01: `OnMessageCount { threshold: usize }` → `OnMessageCount { count: usize }` (+doc comment 'reaches or exceeds `count`'); F-P151-01: `OnTokenCount { threshold: u64 }` → `OnTokenCount { tokens: u64 }` (+doc comment). (2) /stream endpoint row — F-P151-03: compaction_event SSE prose 'carries run_id, trigger, compacted_turns, summary_token_count, tokens_remaining_after' → 'carries run_id, trigger, parent_ids, compacted_start, compacted_end, summary_token_count, tokens_remaining_after' (flat wire shape, parent_ids mandatory per BC-2.06.002 Inv-2)."
  - "2.52 (F-P149-02/burst-250/2026-07-24): Two live-body version pins de-pinned (TD-VSDD-091 stable-anchor enforcement, F-P149-02). (1) §GuardedDocuments rag_ingress doc comment: 'ADR-014 v1.5' → 'ADR-014 Decision 6 §GuardedDocuments' (severity-bifurcated Fail behavior is defined in Decision 6 rag_ingress code). (2) similarity_search_with_filter default body comment: 'ADR-014 v1.5 F-P131-07 adjudication' → 'ADR-014 Decision 2 §Metadata filter surface F-P131-07 adjudication' (F-P131-07 adjudication is embedded in Decision 2 §Metadata filter surface subsection)."
  - "2.51 (F-P145-01+F-P145-04, burst-246, 2026-07-23): (1) F-P145-01: §First-Party Tools BashTool stub — default max_duration corrected 120s→30s to match canon (BC-2.23.005 H1/Description/PC1/EC-002/TV-004/DI-015 chain, ADR-020 Decision 2, ubiquitous-language-core). TD-VSDD-060 sweep: rg 'max_duration|120s|120 s' .factory/specs/ — sole 120s live-body site was this line; all other max_duration references already read 30s/30 seconds; zero further residue. (2) F-P145-04: §First-Party Tools opening sentence — over-generalization 'All tools use PathGuard' reworded to distinguish the five file-access tools (PathGuard-confined) from BashTool (pregolya-sandbox-confined per BC-2.23.005); 'All tools implement the Tool trait' clause preserved."
  - "2.50 (F-P142-01+F-P142-03, burst-242, 2026-07-23): (1) F-P142-01: §First-Party Tools — three CreateFileTool phantom sites replaced with ListDirTool per BC-2.23.004 H1: BC anchor BC-2.23.004 label, PathGuard shared-list doc comment, and tool stub comment+description. (2) F-P142-03: Sweep Command::Resume(…) enum-variant form → Command(resume=…) struct kwarg form at 6 sites (L835 ToolApprovalResolved emission comment, L881 causal ordering diagram, L921 BC-2.06.005 StreamEvent BC anchor, L931 §PreToolCallHook BC anchor BC-2.05.004 citation, L969 PendingHumanApproval doc comment, L1631 /stream endpoint row). Zero Command:: enum-variant and CreateFileTool residue remains."
  - "2.49 (burst-240/F-P140-04/2026-07-23): Blanket omission annotation updated — E-MCP-006 McpContentUnsupported (VAL/Never, minted burst-240) added to E-MCP-* namespace (5→6 codes). E-MCP-006 confirmed library-layer only: raised by _convert_mcp_content_to_block in pregolya-mcp when a CallToolResult contains an unsupported content block type (e.g., AudioContent); surfaces as library Err(PregolyaError) return, never as a direct HTTP terminal response in v1 (propagates embedded in Run.error if it reaches pregolya-server). Disposition census 107→108: 43 HTTP + 17 individual + 48 blanket. Blanket group breakdown: E-MCP-* 6 + E-SBXD-* 6 + E-RETRY-* 4 + E-BUDGET-* 2 + E-MEMORY-* 8 + E-SPLIT-* 2 + E-TMPL-* 3 + E-SRLZ-* 2 + E-VS-* 5 + E-EMBED-* 1 + E-TOOLS-* 9 = 48."
  - "2.48 (burst-236/F-P136/2026-07-23): Fix burst 236 placement-marker corrections (five findings + sweep). (1) F-P136-01: §Retriever Trait/GuardedDocuments placement marker `core::guardrail` → `core::retriever` (ADR-014 Decision 6; GuardedDocuments struct and rag_ingress are in core::retriever, not core::guardrail); §-source line drops `, core::guardrail`. (2) F-P136-02: §PreToolCallHook three co-located fixes per ADR-018 Decision 1 + BC-2.05.007: (a) module `graph::approval` → `graph::hitl` in both §-source and code-block marker; (b) trait method `pre_tool_dispatch` → `pre_invoke`; (c) restore dropped second parameter `run_ctx: &RunContext`. (3) F-P136-03: §Compaction type-definition marker `pregolya-graph: graph::budget` → `pregolya-core: core::budget` for CompactionTrigger/ConversationSnapshot/CompactionSummary/CompactionPolicy (ADR-019 Decision 1); §-source extended to note execution engine in graph::budget. (4) F-P136-04: StreamEvent::CompactionEvent.tokens_remaining_after type `u64` → `Option<i64>` (source is RunContext.budget_info.tokens_remaining: Option<i64>; three-site reconciliation with BC-2.06.006 v1.2 and BC-2.10.006 v1.3). (5) F-P136-05: §PreToolCallHook BC anchors re-attributed — BC-2.05.004 (Command(resume=value) API) removed from trait/ToolCallPreview/PreToolDecision/fail-closed description; BC-2.05.007 is the authoritative contract; BC-2.05.004 retained only for Command::Resume(PreToolDecision) resume-API role. Sweep also corrects PreToolDecision variant shapes to ADR-018 Decision 1 / BC-2.05.007: Deny { reason: String }, Edit { modified_args: serde_json::Value }, PendingHumanApproval { prompt: Option<String> }."
  - "2.47 (burst-233/F-P133-03/2026-07-22): E-TOOLS-* blanket annotation updated — 7→9 codes (+E-TOOLS-008 FileIoError TOOL/Maybe, +E-TOOLS-009 InvalidRegexPattern VAL/Never, minted burst-233). Disposition census 105→107 (43 HTTP + 17 individual + 47 blanket). Blanket group breakdown: E-MCP-* 5 + E-SBXD-* 6 + E-RETRY-* 4 + E-BUDGET-* 2 + E-MEMORY-* 8 + E-SPLIT-* 2 + E-TMPL-* 3 + E-SRLZ-* 2 + E-VS-* 5 + E-EMBED-* 1 + E-TOOLS-* 9 = 47."
  - "2.46 (D23/2026-07-22): Add D23 API surfaces. (1) StreamEvent enum 12→15 variants: +ToolApprovalRequest (event 13, PendingHumanApproval interrupt signal per ADR-018 Decision 5), +ToolApprovalResolved (event 14, resume decision applied), +CompactionEvent (event 15, post-compaction durable write per ADR-019 Decision 4) — causal ordering diagram updated. BC-2.06.004/005/006 anchor refs added to §StreamEvent. (2) §PreToolCallHook section added: ActionRisk enum (4 tiers: ReadOnly/Low/Medium/High), ToolCallPreview struct (tool_name, tool_args, action_risk: Option<ActionRisk>), PreToolDecision enum (4 variants: Approve/Deny/Edit/PendingHumanApproval), PreToolCallHook trait; source ADR-018 Decision 2–6. (3) §Compaction section added: CompactionTrigger enum (4 variants: Disabled/OnWatermark/OnMessageCount/OnTokenCount), ConversationSnapshot struct, CompactionSummary struct, CompactionPolicy trait; source ADR-019 Decision 1–5. (4) §First-Party Tools section added: PathGuard struct (E-TOOLS-001 sandbox confinement); ReadFileTool/WriteFileTool/EditFileTool/CreateFileTool/BashTool/GrepTool comment anchors. (5) /stream endpoint row: added tool_approval_request, tool_approval_resolved, compaction_event event mentions (D23/ADR-018/ADR-019). (6) Blanket omission annotation: E-TOOLS-* 7 new codes added; census 98→105 (43 HTTP + 17 individual + 45 blanket)."
  - "2.45 (burst-227/F-P132-02/2026-07-21): §ChatPromptTemplate — complete BC-2.18.x anchor swap from burst-226 partial-propagation. (1) SlotTrustPolicy doc anchor: BC-2.18.003 PC1-PC2 (MessagesPlaceholder!) → BC-2.18.002 PC4 (slot_trust_policy field) + BC-2.18.005 PC1-PC5 (construction-time policy guard). (2) from_messages anchor: BC-2.18.001 PC1 (PromptTemplate construction!) → BC-2.18.002 PC1 (ChatPromptTemplate construction). (3) PromptValue struct anchor: BC-2.18.001 PC3 (input_variables()!) → BC-2.18.002 PC2 (PromptValue.messages). (4) MessageProvenance struct anchor: BC-2.18.003 PC2-PC3 (MessagesPlaceholder!) → BC-2.18.002 PC3-PC4 (highest_trust_level + slot_trust_policy). (5) Footer: BC-2.18.001 description corrected to PromptTemplate F-String scope; BC-2.18.003 description corrected to MessagesPlaceholder/FewShot scope; BC-2.18.005 description corrected to construction guard scope."
  - "2.44 (burst-226/F-P131-01+F-P131-05+F-P131-06+F-P131-07/2026-07-21): (1) F-P131-05: ChatPromptTemplate section — TrustLevel migration. Added TrustLevel enum + TemplateVar struct definitions. MessageProvenance.tag → MessageProvenance.highest_trust_level. SlotTrustPolicy TrustRequired doc comment: ProvenanceTag::Trusted/Internal → TrustLevel::Trusted/None. format_messages BC anchor: BC-2.18.001↔BC-2.18.002 swap (format_messages rendering → BC-2.18.002; strict-undefined → BC-2.18.001). BC anchor footer: ProvenanceTag → TrustLevel; ADR-015 Decision 4 added. (2) F-P131-01: GuardedDocuments::rag_ingress docstring updated with severity-bifurcated Fail semantics (Critical → Err(E-CORE-008); Non-Critical → error-entry substitution). E-CORE-008 individual omission note added. (3) F-P131-07: similarity_search_with_filter default method doc updated: lossy fallback → fail-safe Err(E-VS-005 FilterUnsupported) on non-empty filter. (4) Disposition census 96→98: individual 16→17 (+E-CORE-008), blanket 37→38 (+E-VS-005)."
  - "2.43 (F-P130-03/2026-07-21): Add six missing D21 trait sections to §Public Rust Trait Signatures (F-P130-03 HIGH). Sections added with verbatim ADR-authoritative signatures + per-method BC anchors: (1) §Retriever Trait and GuardedDocuments — ADR-014 Decision 2 + Decision 6; anchors BC-2.20.001..003. (2) §VectorStore Trait and VectorStoreFactory — ADR-014 Decision 2; anchors BC-2.21.001..004. (3) §Embeddings Trait — ADR-017 Decision 2; anchors BC-2.22.001..003. (4) §ChatPromptTemplate and PromptValue Surface — ADR-015; anchors BC-2.18.001..005. (5) §LcSerializable and Reviver Surface — ADR-016; anchors BC-2.19.001..006. Coverage cross-check: all methods have BC anchors; no orphan methods found in either direction."
  - "2.42 (F-P224/H-1/2026-07-21): Blanket omission annotation updated for E-VS-004 (ZeroNormWriteTime, VAL, BC-2.21.002) minted in error-taxonomy.md v1.28. E-VS-* namespace 3→4 codes; blanket group total 36→37. Disposition census 95→96 (43 HTTP + 16 individual + 37 blanket = 96). E-VS-004 is library-layer only (write-path Err return from add_texts / from_texts_sync; no direct HTTP terminal response in v1)."
  - "2.41 (D21/Batch-3b-i/2026-07-20): Blanket omission annotation updated for D21 ecosystem-parity expansion. (1) Added four new component namespaces to §Library/execution-layer codes blanket omission: E-TMPL-* (BC-2.18.x, SECURITY/VAL), E-SRLZ-* (BC-2.19.x, VAL), E-VS-* (BC-2.20.x/BC-2.21.x, VAL), E-EMBED-* (BC-2.22.x, VAL) — all library-layer only per ADR-010 v1.1, no HTTP terminal responses. (2) Disposition census updated: 86→95 (blanket 27→36; 43 HTTP + 16 individual + 36 blanket = 95). (3) Note appended to §Error Type citing Component enum expansion 12→16 and #[non_exhaustive] gate count 13→17."
  - "2.40 (F-P124-01, fix burst 127, 2026-07-19): §MemoryStore — E-MEMORY-003 ScopeAccessDenied raise-site mis-anchored to memory_get; BC wins (BC-2.15.002 Invariant defines it as a WRITE error; PC1/TV-001 define cross-owner READ as Ok(None) — isolation-by-invisibility). Three changes: (1) memory_set docstring: added E-MEMORY-003 ScopeAccessDenied raise site with full struct form { requested_scope, caller_identity } (BC-2.15.002 Invariant). (2) memory_get docstring: removed E-MEMORY-003 raise site; replaced with BC-true cross-owner read semantics documenting isolation-by-invisibility (cross-owner reads return Ok(None) per BC-2.15.002 PC1/TV-001); E-MEMORY-004 NoScopeContext placement retained (correct per BC-2.15.002 EC-001). (3) BC anchor footer: E-MEMORY-003 re-anchored from memory_get to memory_set. Sweep of E-MEMORY-001/002/004: all PASS (E-MEMORY-001 on vector_search correct per BC-2.15.001 EC-001; E-MEMORY-002 on memory_set correct per BC-2.15.001 EC-004; E-MEMORY-004 on memory_get correct per BC-2.15.002 EC-001)."
  - "2.39 (OBS-P123-b, fix burst 126, 2026-07-19): §Public Rust Trait Signatures — add §MemoryStore block (OBS-P123-b promoted to blocker under production-grade lens). Derived strictly from BC-2.15.001 PC1–PC7 (6-method surface: memory_set/memory_get/memory_delete/memory_search/vector_search/hybrid_search) + BC-2.15.002 MemoryScope tier-isolation semantics (scope parameter on every method; storage-layer WHERE-predicate enforcement). Supporting types: MemoryScope enum (3 variants: User/App/Session) and MemoryEntry struct (scope/key/value/author_id) defined inline. Error raise sites cited per-method: E-MEMORY-001 (vector_search EC-001), E-MEMORY-002 (memory_set EC-004), E-MEMORY-003 (memory_get scope-mismatch per BC-2.15.002 Invariant, opt-in enforcement), E-MEMORY-004 (memory_get BC-2.15.002 EC-001). BC-2.15.003 GDPR erasure confirmed NOT a trait method (standalone admin fn requiring AdminContext); excluded. memory_delete_session (BC-2.15.002 Invariant) confirmed standalone store fn, not a trait method; excluded from the 6-method surface. Gate #31: MemoryScope RESOLVED, MemoryEntry RESOLVED, query_embedding RESOLVED. Cross-check: api-surface.md MemoryStore BC anchor range BC-2.15.001–003 verified accurate (no architect routing required). Ubiquitous-language-server.md MemoryStore entry (line 142) in sync. BC-2.15.006 PC1 method-name drift fixed in this burst (MemoryStore::get → MemoryStore::memory_get; MemoryScope::App scope type made explicit; EC-001 and Architecture Anchors updated; BC-2.15.006 version 1.1 → 1.2)."
  - "2.38 (F-P117-01, fix burst 120, 2026-07-19): summary_halt promoted to first-class terminal Run status throughout (Option 1 adjudication — BC-2.10.003 PC8(d) is authoritative). (1) §Run Object Schema status enum: add 'summary_halt' (in_progress → summary_halt via OnCeiling::Summarize per BC-2.10.003 PC8(d)). (2) status description: state machine enumeration gains '| summary_halt'. (3) completed_at terminal set: add 'summary_halt'. (4) output note: 'present only when status=completed or status=summary_halt; for summary_halt output=summarize model response (BC-2.10.003 PC8(c))'. (5) §Runs HTTP table GET runs filter: add summary_halt to status filter enumeration. (6) §Runs HTTP table DELETE runs description: add summary_halt to deletable terminal states."
  - "2.37 (F-P116-01, 2026-07-19): §CheckpointSaver — dyn-compatibility fixes per ADR-005 v1.3 §Object-Safety (F-P116-01). (A) `get_next_version` provided-method receiver: `&self` added as first parameter (was receiver-less, causing E0038 on Arc<dyn CheckpointSaver>). Rationale: dyn-compatibility requires a receiver on every non-Sized-bounded method; virtual dispatch of backend overrides through Arc<dyn CheckpointSaver> vtable requires &self; langgraph BaseCheckpointSaver.get_next_version is an instance method — prior 'static method' parity claim corrected (F-P116-01). Default body unchanged — still delegates to MonotonicClock::get_next_version(current, channel), ignoring &self. (B) `list` return type: `Result<impl Stream<Item = Result<CheckpointTuple, PregolyaError>>, PregolyaError>` → `Pin<Box<dyn Stream<Item = Result<CheckpointTuple, PregolyaError>> + Send>>`. Rationale: `impl Stream` opaque return is NOT dyn-compatible even with async-trait desugaring (E0038); Pin<Box<dyn Stream<Item = ...> + Send>> is the established dyn-compatible boxed-stream pattern for object-safe async traits. Authority: ADR-005 v1.3 §Object-Safety of the 5-Method CheckpointSaver Trait."
  - "2.36 (F-P115-02, 2026-07-19): §CheckpointSaver — add `put` and `get_next_version` methods (trait becomes 5-method). (A) `put` method: persists full checkpoint state blob; called once per run under DurabilityTier::Exit or at run completion (BC-2.04.002 PC4/EC-002, BC-2.04.001 EC-003); encrypted when EncryptedSerializer active (BC-2.04.007 PC1); raises E-CHKPT-005 on tenant-context conflict (BC-2.04.006 EC-005). BC anchor annotations: BC-2.04.002 PC4/EC-002, BC-2.04.001 EC-003, BC-2.04.006 PC2, BC-2.04.007 PC1+INV-1. (B) `get_next_version` provided method: default impl delegates to MonotonicClock::get_next_version; implementors MAY override; channel param accepted for API compatibility only (BC-2.04.003 PC1/PC5); E-CHKPT-002 on u64 overflow. BC anchor line extended: BC-2.04.001 through BC-2.04.007 with per-method precision. Gate #31 type note extended: Checkpoint and CheckpointMetadata (entities-graph.md §Checkpoint), CheckpointId (ADR-005 / BC-2.04.003 newtype over u64) added. Architect routing: api-surface.md CheckpointSaver row BC range 001–006 is now stale (needs 001–007); flagged for architect."
  - "2.35 (F-P100-02, 2026-07-17): Citation-completeness amendment — no behavioral change. /stream endpoint row BC citation extended from 'BC-2.11.002 PC3/PC4' to 'BC-2.11.002/003/004 PC3/PC4 (per-boundary)'. §StreamEvent BC anchor extended: BC-2.11.003 PC3/PC4 (GuardrailDecision emitted on Fail/Transform for RagChunk boundary) and BC-2.11.004 PC3/PC4 (GuardrailDecision for MemoryItem boundary) added alongside existing BC-2.11.002 PC3/PC4 (ToolResult boundary). GuardrailDecision fires symmetrically at all three ingress boundaries; prior citations listed only the ToolResult boundary BC. ADR-006 rev-4 is co-artifact."
  - "2.34 (F-P99-01, 2026-07-17): Axis (a) Add GuardrailDecision (12th StreamEvent variant) — fires for non-Pass guardrail outcomes (Fail/Transform only; Pass not streamed) at tool-result, RAG, and memory ingress boundaries. Audit-log-only is insufficient for Domain A SOC live-analyst use case (domain-a-soc-analyst.md §5 NEW forcing function); SSE consumer has zero in-band signal otherwise. Axis (b) ToolEnd.data carries POST-guardrail content — raw rejected payloads must not exit the security boundary via any StreamEvent (same isolation as model input buffer, BC-2.11.005 PC1). Axis (c) Ordering: GuardrailDecision fires before ToolEnd within the ToolStart/ToolEnd window (ToolResult boundary); within NodeStart/NodeEnd window before inference (RagChunk/MemoryItem boundaries). Axis (d) StreamEvent variant count 11→12; wire token guardrail_decision; supporting types IngressBoundary/GuardrailDecisionKind/GuardrailSeverityWire. New §StreamEvent section added to Public Rust Trait Signatures; /stream endpoint row updated to reference guardrail_decision events and ToolEnd post-guardrail semantics. ADR-006 rev-3 is co-artifact. Downstream PO amendments required: BC-2.06.001 PC2/PC4/new-EC-006, BC-2.11.002 PC3/PC4, BC-2.11.005 PC1/new-INV-5, BC-2.06.003 new-INV note."
  - "2.33 (F-P93-02, 2026-07-17): Adjudicate contradictory HITL-trigger model (F-P93-02 HIGH). VERDICT: Model A — `PolicyDecision::Escalate` (soft-ceiling) ALWAYS triggers the HITL interrupt unconditionally, independent of `BudgetConfig::on_ceiling`; `PolicyDecision::Deny` (hard-ceiling) branches on `on_ceiling` (Halt | Escalate→HITL | Summarize). BC authority: BC-2.10.001 PC3 — 'Escalate → execution suspends; the run transitions to `interrupted` via the HITL interrupt mechanism (BC-2.10.004)' — no on_ceiling qualification. Changes: (1) §OnCeiling enum docstring updated: field governs `PolicyDecision::Deny` dispatch ONLY; explicit statement that `PolicyDecision::Escalate` routes to HITL unconditionally per BC-2.10.001 PC3 without consulting `on_ceiling`. (2) `OnCeiling::Escalate` variant docstring updated: this variant means 'when `PolicyDecision::Deny` (hard ceiling) is received, redirect to HITL instead of halting'; clarifies both the soft-limit Escalate path and this hard-ceiling Deny→Escalate path use the same `BudgetEscalation` interrupt mechanism. (3) Engine-branching note replaced with a complete PolicyDecision × on_ceiling decision table — zero unspecified cells. Previously the note covered only `PolicyDecision::Deny` dispatch and left `PolicyDecision::Escalate` entirely unspecified. Now all three PolicyDecision variants are fully specified with Engine Action, Run Status, and Resume Mechanism columns. BC anchor updated to cite BC-2.10.001 PC3 as the Escalate-path authority. Sibling architecture docs (api-surface, module-decomposition) do not state the trigger model at decision-table precision — no change required."
  - "2.32 (F-P92-01-sweep, 2026-07-17): §RunnableConfig doc comment — stale verbatim citations to old BC-2.10.003 PC7 and BC-2.10.004 PC6 text updated to match new wording from same burst (F-P92-01/F-P92-02). Old PC7 quote: 'operator supplies a new RunnableConfig with a higher ceiling'. New: 'operator supplies a new RunnableConfig with budget_config: Some(BudgetConfig { hard_limit: Some(higher_ceiling), .. })'. Old PC6 quote: 'new_ceiling replaces the policy\\'s current ceiling in the RunnableConfig for the resumed execution'. New: 'The new_ceiling is applied by patching RunnableConfig::budget_config with BudgetConfig { hard_limit: Some(new_ceiling), ..original } for the resumed execution'. The struct definition itself (pub budget_config: Option<BudgetConfig>) was already correct from v2.31; this entry corrects only the inline authority citations in the doc comment. Exhaust-sweep finding: pattern 'policy\\'s.{0,20}ceiling' matched interface-definitions.md line 155 (prd-supplement, in-scope for fixes per task)."
  - "2.31 (F-P92-02, 2026-07-17): OPTION A adjudication — add `budget_config: Option<BudgetConfig>` to §RunnableConfig. Authority: BC-2.10.004 PC6 explicitly places new_ceiling 'in the RunnableConfig for the resumed execution'; BC-2.10.003 PC7/TV-004 say 'operator supplies a new RunnableConfig with a higher ceiling'. BudgetResume::Extend { new_ceiling } is processed by the engine, which patches RunnableConfig::budget_config with a cloned BudgetConfig{ hard_limit: Some(new_ceiling), ..original } before resuming — this applies the extended ceiling to only that resumed execution without mutating GraphConfig (which is shared across concurrent runs on the same graph). Formal §RunnableConfig struct block added with all four known fields (recursion_limit, thread_id, budget_config, context_mutations) and per-field BC citations. TOML [budget] comment updated: 'overridable per run' expanded with explicit reference to RunnableConfig::budget_config and BudgetResume::Extend mechanism. Sibling sweep: api-surface.md v1.3→v1.4 (new §pregolya-core Public Types row for RunnableConfig), module-decomposition.md v1.9→v1.10 (budget definitions note extended). purity-boundary-map unchanged — BudgetConfig already a pure core type; adding Option<BudgetConfig> to RunnableConfig does not change core::config purity classification."
  - "2.30 (F-P91-04, 2026-07-17): Census update 85→86 — E-MEMORY-008 (MemoryStoreReadFailed, DURABILITY) minted in error-taxonomy.md v1.18 (BC-2.15.004 EC-004/TV-008 anchor). E-MEMORY-008 is covered by the existing E-MEMORY-* blanket annotation (§Library/execution-layer codes blanket omission); category DURABILITY is already in the blanket annotation category list (VAL/POLICY/DURABILITY/SECURITY); no HTTP routing row or blanket annotation body change needed. Updated census: 43 HTTP + 16 individual + 27 blanket = 86 (E-MEMORY-* 7→8 in blanket group; E-MCP-* 5 + E-SBXD-* 6 + E-RETRY-* 4 + E-BUDGET-* 2 + E-MEMORY-* 8 + E-SPLIT-* 2 = 27)."
  - "2.29 (F-P91-02/F-P91-03, 2026-07-17): F-P91-02 (MED) — add OnCeiling enum and BudgetConfig struct to §BudgetPolicy; both are SS-10 public API surface items absent from the interface spec, leaving implementers unable to build the halt-vs-summarize branch without them. OnCeiling variants: Halt | Escalate | Summarize { summarize_prompt: String } per BC-2.10.003 v1.2 Architecture Anchors + BC-2.10.004. BudgetConfig fields: soft_limit: Option<u64> (Escalate threshold — BC-2.10.001 TV-002), hard_limit: Option<u64> (Deny threshold — BC-2.10.001 TV-003), on_ceiling: OnCeiling (BC-2.10.003 + BC-2.10.004). Prose paragraph added: engine branches on BudgetConfig::on_ceiling after Deny; BudgetPolicy::evaluate stays pure; ADR-009 Option 3 section anchor. BC anchor updated: BC-2.10.003 + BC-2.10.004 + ADR-009 added; TV citation text updated. F-P91-03 (OBS) — fix TOML default_on_ceiling comment: state that 'summarize' is config-API-only (requires summarize_prompt payload; not expressible as a bare-string default; table form documented). Sibling sweep: module-decomposition.md budget note + purity-boundary-map.md core::budget row updated with OnCeiling and BudgetConfig."
  - "2.28 (F-P88-01, 2026-07-17): Version/changelog/timestamp propagation for pass-87 burst body changes. Pass-87 (bc-authoring-plan v2.21) added §CLI Interface, §Exit Code Semantics, and §JSON Output Schema stubs; renamed §'Flag Interaction Rules' → §'Flag Interactions'; and normalized input-hash from legacy 64-char SHA-256 to 7-char MD5 ('cdce094'). Those body modifications landed without a corresponding version/timestamp bump, leaving the file at v2.27/2026-07-15. Correction applied: version 2.27 → 2.28, timestamp → 2026-07-17. No semantic content changes in this entry."
  - "2.27 (2026-07-15, F-P83-01/F-P83-02): Mandatory sibling sweep of all BC anchor lines — two mis-citations corrected. F-P83-01 (ToolCallDialect §ProviderFallbackPolicy, line ~314): old citation 'BC-2.08.013 PC1–PC4 (object-safe trait contract, built-in impls, E-PROV-009 on parse failure)' was wrong on two counts — PC1–PC4 cover only the NativeOpenAiJson and NativeAnthropic dialect round-trips; object-safety lives at PC10; E-PROV-009 is raised at PC8 (HermesChatMlXml malformed JSON) and PC9 (any dialect serialize/deserialize error). Fixed to 'BC-2.08.013 PC1–PC9 (built-in dialect round-trips; PC8/PC9 = E-PROV-009 on parse failure) + PC10 (object-safe trait contract)'. F-P83-02 (ProviderFallbackPolicy, line ~336): old citation 'BC-2.08.014 PC1–PC4 (ordered fallback semantics, E-PROV-010 on chain exhaustion)' incorrectly attributed E-PROV-010 to the PC1–PC4 block; PC4 = ordered chain semantics (no error raised); E-PROV-010 is raised at PC5 (chain exhausted postcondition). Fixed to 'BC-2.08.014 PC1–PC4 (ordered fallback semantics) + PC5 (E-PROV-010 on chain exhaustion)'. Sweep covered all 13 BC anchor locations in the file; no other mis-citations found. Disposition census unchanged: 43 HTTP + 16 individual + 26 blanket = 85."
  - "2.26 (2026-07-15, F-P82-02): E-CHKPT-008 omission note raise-timing corrected. Previous wording stated both sub-cases were raised 'at construction time', which was wrong for the malformed-FTS5-query case. Fixed: (1) `FtsSearchConfig.limit = 0` raised at FtsSearchConfig construction time (BC-2.04.008 PC6/EC-004); (2) malformed FTS5 query string raised at fts_search call time via SQLite FTS5 parse error propagation (BC-2.04.008 EC-002). Clarified that `query` is a standalone first parameter to fts_search, NOT a field of FtsSearchConfig. BC citations split to match each sub-case. Disposition census unchanged: 43 HTTP + 16 individual + 26 blanket = 85."
  - "2.25 (F-P78-SWEEP, 2026-07-15): Gate #33 step-11 follow-through — E-CORE-006 dual-layer table Runnable-layer row corrected. Message was 'recursion limit exceeded at depth N'; corrected to 'RecursionLimitExceeded: recursion limit exceeded at depth <depth>'. (1) Added 'RecursionLimitExceeded:' prefix per D18-P78-A universal <ErrorName>: convention. (2) Changed placeholder N → <depth> for consistency with BC-2.01.003 PC5 authoritative template (updated in same burst). This is the only message string in the dual-layer table; no other content changed. Disposition census unchanged: 43 HTTP + 16 individual + 26 blanket = 85."
  - "2.24 (F-P78-02/F-P78-03, 2026-07-15): Fix two omission-note BC-anchor citations that pointed at success-path PCs/ECs (OBS-P78-E gate #33 step-11 violation class). F-P78-02 — E-PROV-010 note corrected: 'BC-2.08.014 PC4/EC-002' → 'BC-2.08.014 PC5/EC-004'. BC-2.08.014 PC4 = ordered-chain semantics (no error raised); EC-002 = primary auth-refresh success path. Correct raising points: PC5 (chain exhausted postcondition explicitly returns E-PROV-010) and EC-004 (all-providers-exhausted scenario). F-P78-03 — E-PROV-009 note corrected: 'BC-2.08.013 PC4/EC-002' → 'BC-2.08.013 PC8/PC9/EC-002'. BC-2.08.013 PC4 = NativeAnthropic success-parse of tool_use blocks. Correct raising points: PC8 (Hermes <tool_call> payload not valid JSON → E-PROV-009) and PC9 (any dialect serialize/deserialize error → E-PROV-009); EC-002 correctly cites malformed JSON case."
  - "2.23 (F-P74-01, 2026-07-15): Fix retired spelling CheckpointStore::fts_search → CheckpointSaver::fts_search in E-CHKPT-008 library-layer omission note (~line 542). CheckpointSaver is the canonical trait name; CheckpointStore was retired. Full-file scan for other retired spellings (RunConfig, BaseCheckpointSaver, AIMessage-in-Rust-context, Checkpointer-as-type): none found."
  - "2.22 (pass-72 fix, 2026-07-15): F-P72-01 + F-P72-06 — fix SkillStore trait signatures to BC/ADR-authoritative name-keyed + tag-filtered forms (load_skill/skill_exists take name: &str; list_skills takes tags: &[String]) per BC-2.15.004 PC1-PC3 + ADR-012 Decision 1 Primitive A; name→(namespace,key) storage mapping is impl-internal (BC-2.15.004 Invariant). Fix Replace.old_value from Value to Option<Value> per ADR-012 Decision 1 Primitive C (None=unconditional replace; Some(v)=match-based replace) + BC-2.15.005 PC2. Gate #31 SkillStore row stays RESOLVED with corrected shapes; MemoryWriteRequest RESOLVED note unchanged (variant structure correct, type corrected). D18-P72-A + D18-P72-B adjudicated."
  - "2.21 (D20 TOUCH-UP burst/2026-07-15): Residue 1 — §BudgetPolicy RunContext inline note updated: added field `budget_info: Option<BudgetInfo>` (BC-2.10.003 v1.2 PC5/INV); `BudgetInfo` struct defined inline with fields `tokens_remaining: Option<i64>` and `steps_remaining: Option<u32>` (gate #31 RESOLVED). BC anchor updated to cite BC-2.10.003. Disposition census unchanged: 43 HTTP table rows, 16 individual omission notes, 26 blanket library-layer coverage entries = 85. CORRIGENDUM (Residue 2): This document's split (43 HTTP + 16 individual + 26 blanket = 85) is the verified correct partition; error-taxonomy.md v1.11 erroneously stated 44 HTTP + 15 individual + 26 blanket = 85 — the split error arose because the E-CORE-004 move (HTTP table → individual omission note, interface-definitions.md v2.19) was not reflected in error-taxonomy.md v1.10 census; corrected in error-taxonomy.md v1.12."
  - "2.20 (D20 INTEGRATE sub-burst 2/2026-07-15): Four new §Public Rust Trait Signatures added: §ToolCallDialect (BC-2.08.013 — object-safe dialect seam for tool-call serialization; built-ins NativeOpenAiJson/NativeAnthropic/HermesChatMlXml), §ProviderFallbackPolicy (BC-2.08.014 — ordered fallback chain struct; ProviderCredential/CredentialRefreshConfig flagged UNRESOLVED implementer-scope for architect), §SkillStore (BC-2.15.004 — async trait with SkillDescriptor inline struct), §MemoryWriteGuard (BC-2.15.005 — pure sync guard with MemoryWriteRequest + WriteGuardDecision inline enums). Blanket omission MEMORY annotation: VAL/POLICY/DURABILITY → VAL/POLICY/DURABILITY/SECURITY (+E-MEMORY-007 SECURITY). Four individual omission notes added: E-CHKPT-008 (VAL), E-CHKPT-009 (INTERNAL), E-PROV-009 (VAL), E-PROV-010 (POLICY) — all library-layer Err, never direct HTTP terminal. Gate #31 census: 19/21 → 25/28 resolved (+ToolCall, SkillDescriptor, MemoryWriteRequest, WriteGuardDecision all RESOLVED; ProviderCredential, CredentialRefreshConfig UNRESOLVED). Disposition census 78→85: 43 HTTP table rows, 16 individual omission notes (+4), 26 blanket library-layer coverage entries (+3: E-MCP-005 in MCP blanket, E-SBXD-006 in SBXD blanket, E-MEMORY-007 in MEMORY blanket)."
  - "2.19 (ADV-P1D-PASS-69/2026-07-15): F-P69-01 — fix 400 row range-shorthand category mismatch: 'E-CORE-001 through E-CORE-005' silently included E-CORE-004 (INTERNAL, not VAL). (1) 400 row: range replaced with explicit VAL enumeration 'E-CORE-001, E-CORE-002, E-CORE-003, E-CORE-005' — each verified VAL in error-taxonomy.md (lines 68-70, 72). (2) E-CORE-004 (INTERNAL — BC-2.01.004 PC5, pipe-composition type-boundary mismatch) given individual omission note mirroring E-CORE-006/E-CORE-007 (library-layer Err return, never direct HTTP terminal; INTERNAL→500 categorical fallback). (3) Range sweep: 'E-CORE-001 through E-CORE-005' was the only range expression in the status table rows — no other ranges found. Disposition census 78→78: 43 HTTP table rows (−E-CORE-004 from 400 row), 12 individual omission notes (+E-CORE-004 library-layer note), 23 blanket library-layer coverage, 0 uncovered."
  - "2.18 (ADV-P1D-PASS-67/2026-07-15): F-P67-01 — fix 422 row cross-reference enumeration: DURABILITY/INTERNAL E-CHKPT codes listed as routed to the 500 row omitted E-CHKPT-007 (CipherHeaderMissing, INTERNAL), which IS in the 500 row. Enumeration corrected from (E-CHKPT-001, -002, -003, -004, -006) to (E-CHKPT-001, -002, -003, -004, -006, -007). Gate #21 cross-row routing-enumeration completeness sub-check applied — all inter-row enumerations verified. Disposition census unchanged: 44 HTTP table rows, 11 individual omission notes, 23 blanket library-layer coverage, 0 uncovered."
  - "2.17 (ADV-P1D-PASS-66/2026-07-15): F-P66-03 — remove E-SERVER-005 (CorsRejected, POLICY) from 403 row; code RETIRED (tombstone in error-taxonomy.md v1.9). BC-2.12.005 PC2/TV-001 specifies CORS denial as silent header-omission — no error body is ever emitted; listing E-SERVER-005 in the 403 row misled implementers toward building explicit CORS error bodies. 403 row description updated to remove 'CORS'. E-PROV-007 omission note updated to remove E-SERVER-005 from the list of direct-403 codes. Disposition census 79→78: 44 HTTP table rows (−E-SERVER-005), 11 individual omission notes, 23 blanket library-layer coverage, 0 uncovered. Gates #20 POLICY census + gate #21 §17-C re-run: all remaining POLICY codes correctly mapped (E-SERVER-004 → 403 direct; E-GRAPH-013 → 403 direct; others library-layer or per-endpoint overrides). PASS."
  - "2.16 (ADV-P1D-PASS-61/2026-07-15): F-P61-02 (MED) + F-P61-01 (HIGH, partial) — §BudgetPolicy context param corrected per orchestrator canon D18-P61-A. (1) Rename context param &BudgetContext → &RunContext: BC-2.10.001 precondition 3 names RunContext (thread_id, run_id, sub-agent identity) as the context type; BudgetContext was minted without corpus search (gate #31 near-name blindspot); BudgetContext RETIRED per gate #19. (2) RunContext implementer-scope note replaced with RESOLVED note: precondition 3 fully enumerates fields (thread_id, run_id, sub-agent identity) → RunContext is RESOLVED, not implementer-scope. Citation corrected: BC-2.10.001 precondition 3 (NOT PC3/INV — those sections describe PolicyDecision and purity, not context contents). (3) BC anchor note updated: precondition 3 authority added."
  - "2.15 (ADV-P1D-PASS-60/2026-07-15): F-P60-01 (HIGH) + F-P60-02 (MED) + F-P60-03 (HIGH) — rewrite §BudgetPolicy block per orchestrator adjudication D18-P60-A (authority-deference: BC-2.10.001–004 are behavioral authority). (1) Rename BudgetDecision → PolicyDecision (BC-2.10.001 PC3 — three-variant contract is the canonical name); BudgetDecision retired per gate #19. (2) Add current_usage: TokenUsage payload to Escalate and Deny variants (BC-2.10.001 PC3, TV-002, TV-003 — F-P60-02). (3) Rewrite evaluate signature: remove async (pure/sync per BC-2.10.001 INV + ADR-009); remove run_id param; remove journal param (journal writes are caller responsibility per BC-2.10.001 INV + ADR-009); add context: &BudgetContext second param (BC-2.10.001 PC1/PC2 two-param canon) — F-P60-03. (4) BudgetContext flagged implementer-scope (shape not enumerated in spec corpus; BC-2.10.001 PC3/INV provides contextual description — same treatment as ChatConfig). (5) BC anchors corrected: BC-2.10.001 PC3 + TV-001–TV-003 + BC-2.10.002 INV."
  - "2.14 (ADV-P1D-PASS-59/2026-07-15): F-P59-01 (HIGH) — fix GuardrailSeverity::Critical authority mis-citations. BC-2.11.003 INV-2 (ordering invariant) → BC-2.11.003 PC3 (Critical severity rule); BC-2.11.004 INV-4 (ordering invariant) → BC-2.11.004 PC3 (Critical severity rule). Correct authority: BC-2.11.002 INV-3, BC-2.11.003 PC3, BC-2.11.004 PC3, BC-2.11.005 PC4. F-P59-02 (HIGH) — fix Transform doc-comment cross-boundary claim: replace 'any IngressContent variant, including a different variant from the original' with same-boundary rule (new_content must be same IngressContent variant; inner payload may change freely — e.g. different ContentBlock variant within ToolResult per BC-2.11.002 EC-003). No BC authorizes cross-boundary transforms (e.g. ToolResult→RagChunk)."
  - "2.13 (ADV-P1D-PASS-58/2026-07-15): F-P58-02 (HIGH) + F-P58-01 (MED) — define IngressContent and GuardrailSeverity inline in §GuardrailHook block. (1) IngressContent enum: ToolResult(ContentBlock) / RagChunk(Value) / MemoryItem(Value) — BC-2.11.002 PC1 / BC-2.11.003 PC1,PC5 / BC-2.11.004 PC1,PC5; E-CORE-007 content_type placeholder resolved to IngressContent variant name. (2) GuardrailSeverity enum: Critical/High/Medium/Low — authority BC-2.11.002 INV-3, BC-2.11.005 PC4/PC5. (3) Minimal type notes added for ChatConfig (BaseChatModel) and CheckpointConfig (CheckpointSaver) per gate #31 census — both flagged corpus-unresolved for architect. Gate #31 census: 20/22 types resolved; ChatConfig and CheckpointConfig flagged."
  - "2.12 (ADV-P1D-PASS-57/2026-07-15): F-P57-01 (HIGH) — fix GuardrailHook trait signature trilateral contradiction (authority-deference D18-P47-A: BCs win). (1) Method name on_ingress → evaluate (all 6 ss-11 BC postconditions + E-CORE-007 taxonomy message are uniform). (2) Return type Result<IngressContent, GuardrailError> → GuardrailResult enum with Pass / Fail{reason,severity} / Transform{new_content} variants (BC-2.11.002 PC2-PC4). (3) Second parameter renamed provenance → provenance_tag per BC-2.11.002 INV-4. (4) GuardrailResult enum definition added to §GuardrailHook block with Fail/Transform variant bodies. (5) Panic path moved to doc-comment citing E-CORE-007 and BC-2.11.002 EC-001 (panic is a non-return code path; the trait method return type is GuardrailResult not Result). (6) GuardrailError type removed — not defined in spec corpus; was incorrect. BC anchor enumeration expanded to cite all 6 BCs by role."
  - "2.11 (ADV-P1D-PASS-56-COMPLETION/2026-07-15): Gate #30 drain — three new codes from error-taxonomy.md v1.8. (1) E-PROV-008 (ProviderHttpError, TRANSPORT) added to 502 row alongside E-PROV-003 — categorical fallback, surfaced embedded in Run.error. (2) E-CHKPT-007 (CipherHeaderMissing, INTERNAL) added to 500 row alongside other CHKPT INTERNAL codes. (3) E-CORE-007 (GuardrailHookPanic, INTERNAL) individual omission note added — library-layer INTERNAL error, never direct HTTP terminal in v1; INTERNAL→500 categorical fallback. Disposition census 76→79: 45 HTTP table rows (+E-PROV-008 +E-CHKPT-007), 11 individual omission notes (+E-CORE-007), 23 blanket library-layer coverage, 0 uncovered."
  - "2.10 (ADV-P1D-PASS-56/2026-07-15): F-P56-01 — add E-CORE-006 (RecursionLimitExceeded, INTERNAL — BC-2.01.003 PC5) to dual-layer table Runnable-layer row; add E-CORE-006 individual omission note (INTERNAL, library-layer Err return, never direct HTTP response in v1; INTERNAL→500 categorical fallback). OBS-P56-1 resolved: tighten 10007 text in dual-layer note to cite `DEFAULT_RECURSION_LIMIT` constant in `langgraph._internal._config` (reads from `LANGGRAPH_DEFAULT_RECURSION_LIMIT` env var) and distinguish from langchain-core `DEFAULT_RECURSION_LIMIT = 25`. Disposition census 75→76: 43 HTTP table rows, 10 individual omission notes (+E-CORE-006), 23 blanket library-layer coverage, 0 uncovered."
  - "2.9 (ADV-P1D-PASS-55/2026-07-15): F-P55-01 — add E-SERVER-013 (InvalidDebugRouteKey, VAL — BC-2.12.005 EC-005/TV-007) startup-only omission note; raised at boot before any HTTP listener is bound, never surfaced as a terminal HTTP response (same treatment as E-CHKPT-005). Full disposition census: 75 live codes — 43 HTTP table rows, 9 explicit individual omission notes, 23 blanket library-layer coverage, 0 uncovered."
  - "2.8 (ADV-P1D-PASS-49/2026-07-15): F-P49-02 — add RunnableConfig recursion_limit dual-interpretation note (§Runnable trait); add E-GRAPH-017 (GraphRecursionLimitExceeded, POLICY — BC-2.03.001 PC5) to the graph execution errors embedded-in-Run.error blockquote. No HTTP status table row change (E-GRAPH-017 surfaces embedded in Run.error, never as a direct terminal HTTP status; POLICY→403 categorical fallback applies only if ever surfaced directly — not in v1)."
  - "2.7 (ADV-P1D-PASS-48/2026-07-15): F-P48-01 fix E-RETRY-* blanket omission annotation — E-RETRY-004 (VAL, minted P34) expands namespace to POLICY/VAL; annotation corrected from POLICY to POLICY/VAL. OBS-P48-1 (adjudicated D17-Q2 FIFO-resume contract) add FIFO-only documentation line to Resume Request Schema: REST resume delivers to single active interrupt slot FIFO; targeted delivery by interrupt_id is library-API only (Command(resume={interrupt_id: value}), BC-2.05.004 EC-002)."
  - "2.6 (ADV-P1D-PASS-47/2026-07-15): F-P47-01 (CRITICAL) fix Flag Interaction Rules row for sandbox-wasm+container-both-off — remove silent-process-fallback claim, replace with SandboxBackend::default()→Err(E-SBXD-003 SandboxInitFailed) per BC-2.13.001 PC4/EC-002/DI-006/NE-01; F-P47-02 fix [sandbox] config comment 'process emits WARNING on startup'→'once per execute() invocation — NOT construction/startup' per BC-2.13.002 PC2/EC-002; OBS-P47-1 add sandbox-process row to Cargo Feature Flags table with NOT-enforcing/explicit-constructor-only semantics per BC-2.13.001 PC3/PC4."
  - "2.5 (ADV-P1D-PASS-46/2026-07-15): F-P46-01 — clarify /stream row description: run_end is emitted on completion only; interrupt and failure paths truncate stream without run_end (BC-2.06.001 PC2 + EC-005 authority; BC-2.12.007 v1.2)."
  - "2.4 (ADV-P1D-PASS-33/2026-07-14): F-P33-01 add BC-2.12.002 PC21-PC23 to §Canonical Pagination Convention BC anchors list (list-assistants anchor). F-P33-02 add run-config merge precedence note to POST /threads/{thread_id}/runs row description (deep-merge over Assistant config, run wins at leaf key; BC-2.12.003 §Run-Config Merge Precedence Invariant)."
  - "2.3 (ADV-P1D-PASS-32/2026-07-14): F-P32-03 add canonical pagination to GET /assistants/{id}/versions row (limit default 10 max 100 clamped / offset / ordering exemption: version ASC — deviates from created_at DESC default); BC-2.12.002 PC20 added as anchor. OBS-P32-1 add no-list-schedules note in §Cron Schedules."
  - "2.2 (ADV-P1D-PASS-31/2026-07-14): F-P31-01 add §Canonical Pagination Convention section; propagate limit (default 10, max 100, silently clamped if > 100) + offset (default 0) + created_at DESC ordering to GET /threads (explicit defaults), GET /threads/{id}/history (declare default 10/max 100 on existing limit), GET /assistants (add limit/offset), GET /threads/{id}/runs (add limit/offset alongside status filter), GET /runs?schedule_id={cron_id} (add limit/offset, declare created_at DESC). Out-of-range canon: clamp (not reject). BC anchors: BC-2.12.001 PC8/PC17, BC-2.12.003 PC18, BC-2.12.004 PC7."
  - "2.1 (ADV-P1D-PASS-30/2026-07-14): F-P30-01 blanket omission note: TOOL→N/A corrected to TOOL→422 (BC-2.14.002 PC3 categorical authority); full 12-category token diff applied — added TRANSPORT→502 and INTERNAL→500 (both present in family labels but absent from summary); corrected VAL→400/422 to VAL→400 (categorical default; 422 requires per-endpoint override decision, not applicable to library-layer fallback)."
  - "2.0 (ADV-P1D-PASS-29/2026-07-14): F-P29-03 fix SSE description on /stream row: node_start/delta/end → node_start/stream/end (node_delta was never canonical; BC-2.06.001 is the streaming taxonomy authority). OBS-P29-1 add blanket omission note for library/execution-layer codes (E-MCP-*, E-SBXD-*, E-RETRY-*, E-BUDGET-*, E-MEMORY-*, E-SPLIT-*) confirming none has a direct HTTP row."
  - "1.9 (ADV-P1D-PASS-28/2026-07-14): OBS-P28-3 add E-PROV-007 (StructuredOutputRefused, POLICY) omission note — categorical POLICY→403 fallback only; surfaced embedded in Run.error, not as a direct terminal HTTP status."
  - "1.8 (ADV-P1D-PASS-27/2026-07-14): F-P27-01 add E-GRAPH-002 (POLICY→422 per-endpoint override) to 422 row; F-P27-02/03 replace 'all E-CHKPT-*' over-broad text with specific enumeration, add E-CHKPT-004 (INTERNAL) to 500 row, add E-CHKPT-005 omission note; F-P27-04 add E-GRAPH-013 (SECURITY) to 403 row, add E-GRAPH-001/014/016 embedded omission notes; 422 row description updated to note POLICY→422 overrides."
  - "1.7 (ADV-P1D-PASS-26/2026-07-14): F-P26-04 config comment X-Debug-Key+/debug/*→Authorization:Bearer+/_debug; F-P26-05 rewrite 401 row with E-PROV-004 categorical-fallback; OBS-1 narrow 422 wildcard to enumerated VAL E-GRAPH codes; OBS-2 add E-CRON-001/003 intentional-omission note; OBS-3 add E-PROV-005/006 to 400 row with embedded-in-Run.error annotation."
  - "1.6 (ADV-P1D-PASS-25/2026-07-14): F-P25-01 add 503 row (E-SERVER-016 IdempotencyLockTimeout per-endpoint override); F-P25-02 recategorize 401→reserved, 403 now E-SERVER-004 POLICY + E-SERVER-005; F-P25-06 reconcile Run.interrupt sub-fields (interrupt_id, node_name, value, action_risk, action, context added; node_id→node_name, risk_tier→action_risk renamed); F-P25-07 add 201 and 204 rows, add E-CRON-002 to 400 row; OBS-2 add 502 and 504 categorical fallback rows."
inputs:
  - .factory/specs/prd.md
  - .factory/specs/domain-spec/capabilities-p0.md
  - .factory/specs/domain-spec/capabilities-p1-p2.md
input-hash: "11ea31c"
traces_to: prd.md
primary_consumers: [implementer, test-writer, devops-engineer]
note: "pregolya is a Rust library framework, not a CLI tool. 'Interface' covers public Rust traits/types, pregolya-server HTTP API, Cargo feature flags, and config schemas."
---

# Interface Definitions: pregolya

> PRD supplement — extracted from PRD Section 3.
> pregolya is a library crate workspace, not a CLI application.
> The public interface is the set of public Rust traits, types, and the
> pregolya-server HTTP API.

## CLI Interface

pregolya is a Rust library framework — there is no standalone CLI tool. The interface surface consists of: (a) public Rust traits and types (see §Public Rust Trait Signatures below), (b) the embedded `pregolya-server` HTTP API (see §pregolya-server HTTP API below), and (c) Cargo feature flags (see §Cargo Feature Flags below). All interface contracts are expressed in Rust types; there are no command-line flags or environment variable arguments.

## Public Rust Trait Signatures (pregolya-core)

### Runnable\<Input, Output\>

```rust
pub trait Runnable<Input, Output>: Send + Sync {
    /// Invoke the runnable; completes when the full result is available (non-streaming).
    ///
    /// Declared as explicit RPITIT `+ Send` (not bare `async fn`) so the blanket
    /// `DynRunnable` and `DynTool` impls compile on stable Rust. Bare `async fn`
    /// carries no `Send` bound on its RPITIT future, making the `#[async_trait]`
    /// blanket-impl's `Pin<Box<dyn Future + Send>>` box cast fail with E0277.
    /// Authority: ADR-005 §Send-Bounded RPITIT.
    fn invoke(&self, input: Input, config: Option<RunnableConfig>)
        -> impl std::future::Future<Output = Result<Output, PregolyaError>> + Send;

    /// Invoke and stream output chunks.
    ///
    /// The outer future carries `+ Send`. The yielded stream is
    /// `Pin<Box<dyn Stream<Item = Result<Output, PregolyaError>> + Send>>` —
    /// boxed to remove the nested `impl Trait` inside `impl Future<Output = ..>`,
    /// which is not permitted on stable Rust (E0562). The outer `Result` from `.await`
    /// must be matched in `DynRunnableAdapter::stream`: on `Err(e)`, fold to a
    /// single-item error stream; on `Ok(stream)`, `.map()` to convert `O →
    /// serde_json::Value` then `Box::pin` (item-type change requires re-boxing).
    fn stream(&self, input: Input, config: Option<RunnableConfig>)
        -> impl std::future::Future<Output = Result<Pin<Box<dyn Stream<Item = Result<Output, PregolyaError>> + Send>>, PregolyaError>> + Send;

    /// Invoke in batch; returns results in input order.
    ///
    /// **Default concurrency model:** in-task cooperative concurrency via
    /// `futures::future::join_all` / `FuturesOrdered` — all `invoke` futures polled
    /// concurrently within the calling task; no Tokio spawn, no thread-pool parallelism;
    /// output order matches input order (BC-2.01.003 {INV-002}).
    ///
    /// **`'static` corollary (ADR-005 §Send-Bounded RPITIT):** the `+ Send` RPITIT
    /// future returned by `invoke(&self, ..)` borrows `&self` and is NOT `'static`;
    /// `JoinSet::spawn` (which requires `F: Future + Send + 'static`) CANNOT be used
    /// in a default `&self` batch implementation. Implementors that hold `'static` /
    /// `Arc<Self>` state MAY override `batch` to use `JoinSet::spawn` for true
    /// task-spawned parallelism.
    fn batch(&self, inputs: Vec<Input>, config: Option<RunnableConfig>)
        -> impl std::future::Future<Output = Result<Vec<Result<Output, PregolyaError>>, PregolyaError>> + Send;

    /// Pipe this runnable into another: self | other.
    ///
    /// Returns a concrete `RunnableSequence<Input, NextOutput>` (BC-2.01.004 PC1).
    /// Flattening: `a.pipe(b).pipe(c)` produces one flat `RunnableSequence` with
    /// `first=a, middle=[b], last=c` — NOT nested sequences (BC-2.01.004 PC4, TV-002).
    ///
    /// Serde bounds are required because `pipe` erases `self` and `next` via
    /// `.into_dyn()` into `Box<dyn DynRunnable>` fields of `RunnableSequence`.
    /// Symmetric bounds (all three type params carry both Serialize + DeserializeOwned):
    /// `Input` needs `Serialize` to feed the erased `first` stage with a `Value` at
    /// invoke time, and `DeserializeOwned` for the `into_dyn()` adapter construction.
    /// `Output` needs both as it is simultaneously the output of `self` and the input
    /// of `next`. `NextOutput` needs `Serialize` for the `into_dyn()` adapter, and
    /// `DeserializeOwned` to yield the typed result by deserializing the erased `last`
    /// stage's `Value` output. Chaining `a.pipe(b).pipe(c)` also requires the symmetric
    /// bounds because `RunnableSequence<A,B>` must satisfy `Self: Sync` for the second
    /// `pipe` call; `PhantomData<fn(A)->B>` is always Sync regardless of A and B.
    /// Authority: ADR-005 §Send-Bounded RPITIT.
    fn pipe<NextOutput>(self, next: impl Runnable<Output, NextOutput> + Send + Sync + 'static)
        -> RunnableSequence<Input, NextOutput>
    where
        Self: Sized + Send + Sync + 'static,
        Input: serde::Serialize + serde::de::DeserializeOwned + Send + 'static,
        Output: serde::Serialize + serde::de::DeserializeOwned + Send + 'static,
        NextOutput: serde::Serialize + serde::de::DeserializeOwned + Send + 'static;
}
```

**BC anchor (per-method):**
- `invoke`: BC-2.01.003 PC1 (invocation semantics), BC-2.01.003 PC5 (recursion limit → `E-CORE-006`)
- `stream`: BC-2.01.003 PC2 (streaming semantics)
- `batch`: BC-2.01.003 PC3 (batch semantics, results in input order)
- `pipe`: BC-2.01.004 PC1 (returns concrete `RunnableSequence`), BC-2.01.004 PC4 (sequence flattening), BC-2.01.004 TV-002 (structure inspectable)

### DynRunnable and RunnableSequence

Type-erased composition path and the concrete sequence type returned by `pipe`.
**Module:** `pregolya-core: core::runnable`.

```rust
// pregolya-core: core::runnable

/// Object-safe, type-erased handle for heterogeneous pipeline composition.
///
/// Used when the concrete `Runnable<I, O>` types differ (e.g. mixing model, retriever,
/// and tool nodes in a single `Vec`). `DynRunnable` erases both `Input` and `Output`
/// to `serde_json::Value`; the blanket impl performs the concrete `serde_json`
/// round-trip internally (deserialize `Value → I` on input, serialize `O → Value` on output).
///
/// **Dyn-compatibility:** the `#[async_trait]` macro desugars each `async fn` into a
/// regular method returning `Pin<Box<dyn Future<Output = ...> + Send>>`, erasing the
/// opaque return type that would otherwise make the trait non-dyn-compatible (E0038).
/// This is the same boxed-future desugaring used by every other async object-safe trait
/// in the codebase (CheckpointSaver, GuardrailHook, Retriever, VectorStore, Embeddings,
/// PreToolCallHook, CompactionPolicy, DynTool — all carry `#[async_trait]` for the
/// same reason). `Arc<dyn DynRunnable>` and `Box<dyn DynRunnable>` compile without
/// E0038 because every method is desugared to a concrete boxed-future signature.
/// ADR-005 §Adjacent Trait Object-Safety Adjudications — BC-2.01.003 EC-001,
/// BC-2.01.004 EC-001.
///
/// **Adapter model (R39/F-P2A164-01; supersedes R38 serde-bounded blanket):** the direct
/// blanket `impl<I, O, T> DynRunnable for T where T: Runnable<I, O> + ...` is E0207 on
/// stable Rust — `I` and `O` appear only in the where-clause, not in the Self type `T`
/// (RFC 447). The adapter-wrapper resolves E0207: `DynRunnableAdapter<I, O, R>` places
/// all three type params on Self (`R` directly; `I` and `O` via `PhantomData<fn(I) -> O>`).
/// The impl `impl<I, O, R> DynRunnable for DynRunnableAdapter<I, O, R>` carries the serde
/// bounds: `R: Runnable<I, O> + Send + Sync + 'static,`
/// `I: serde::de::DeserializeOwned + Send + 'static, O: serde::Serialize + Send + 'static`.
/// The body deserializes `Value → I` (raising `E-CORE-003` on failure), calls `R::invoke`,
/// and serializes `O → Value`; `stream` is analogous, boxing the `+Send` stream. Each
/// (I, O, R) triple yields a distinct Self type — no E0119 coherence overlap. The ergonomic
/// `IntoDynRunnable<I, O>` extension trait (defined below) provides `.into_dyn()` on any
/// `Runnable<I, O> + Sized`; `pipe()` uses `.into_dyn()` internally to erase its stages.
/// `Runnable`'s async methods carry explicit RPITIT `+ Send` — required for the
/// `Pin<Box<dyn Future + Send>>` box cast to compile on stable Rust. Authority: ADR-005
/// §Send-Bounded RPITIT.
///
/// # Errors
/// - `Err(PregolyaError { code: "E-CORE-003", .. })` — `Value → I` deserialization
///   failure at the adapter boundary (BC-2.01.003 {PC-001}).
/// - `Err(PregolyaError { code: "E-CORE-004", .. })` — type boundary mismatch
///   between adjacent stages detected at the first `invoke` call
///   (BC-2.01.004 PC5/EC-001/TV-004).
#[async_trait]
pub trait DynRunnable: Send + Sync {
    /// Invoke with JSON input; return JSON output.
    async fn invoke(
        &self,
        input: serde_json::Value,
        config: Option<RunnableConfig>,
    ) -> Result<serde_json::Value, PregolyaError>;

    /// Stream JSON output chunks. Boxed stream for dyn-compatibility following the
    /// `CheckpointSaver::list` pattern (ADR-005 §Object-Safety).
    async fn stream(
        &self,
        input: serde_json::Value,
        config: Option<RunnableConfig>,
    ) -> Pin<Box<dyn Stream<Item = Result<serde_json::Value, PregolyaError>> + Send>>;
}

/// Adapter wrapper that implements `DynRunnable` for any `R: Runnable<I, O>`.
///
/// Resolves E0207: all three type params are on Self — `R` directly, `I` and `O`
/// via `PhantomData<fn(I) -> O>` which appears in the struct fields and therefore
/// constrains the impl block's Self type (RFC 447). The impl body deserializes
/// `Value → I` (raising `E-CORE-003` on failure), calls `R::invoke`, and serializes
/// `O → Value`. Authority: ADR-005 §Send-Bounded RPITIT.
/// Module: `pregolya-core/src/runnable/adapter.rs`.
pub struct DynRunnableAdapter<I, O, R> {
    pub(crate) inner: R,
    pub(crate) _phantom: std::marker::PhantomData<fn(I) -> O>,
}

#[async_trait]
impl<I, O, R> DynRunnable for DynRunnableAdapter<I, O, R>
where
    R: Runnable<I, O> + Send + Sync + 'static,
    I: serde::de::DeserializeOwned + Send + 'static,
    O: serde::Serialize + Send + 'static,
{
    // invoke: from_value::<I>(input) → E-CORE-003 on failure → inner.invoke(typed, config) →
    //         to_value(out) → Ok(json_value). See BC-2.01.003 {PC-001}.
    async fn invoke(
        &self,
        input: serde_json::Value,
        config: Option<RunnableConfig>,
    ) -> Result<serde_json::Value, PregolyaError>;

    // stream: R::stream(...).await yields Result<Pin<Box<dyn Stream<Item = Result<O, PregolyaError>> + Send>>, PregolyaError>
    //         (Runnable::stream is RPITIT-boxed at source — E0562 fix; outer Result must be matched).
    //         On Err(e): return Box::pin(futures::stream::once(async { Err(e) })) — single-item error stream.
    //         On Ok(stream): .map(|r| r.and_then(|v| serde_json::to_value(v).map_err(PregolyaError::from)))
    //         then Box::pin the mapped stream. Item type changes O → serde_json::Value (re-boxing required).
    //         See BC-2.01.003 {PC-002}.
    async fn stream(
        &self,
        input: serde_json::Value,
        config: Option<RunnableConfig>,
    ) -> Pin<Box<dyn Stream<Item = Result<serde_json::Value, PregolyaError>> + Send>>;
}

/// Ergonomic extension trait: `.into_dyn()` on any `Runnable<I, O> + Sized`.
///
/// The blanket `impl<I, O, T: Runnable<I, O> + Sized> IntoDynRunnable<I, O> for T`
/// is realizable: `I` and `O` constrain the TRAIT's type parameters, not only the
/// where-clause (RFC 447). Used by `Runnable::pipe` to erase each stage.
/// Module: `pregolya-core/src/runnable/adapter.rs`.
pub trait IntoDynRunnable<I, O>: Runnable<I, O> + Sized {
    fn into_dyn(self) -> DynRunnableAdapter<I, O, Self>
    where
        Self: Send + Sync + 'static,
        I: serde::de::DeserializeOwned + Send + 'static,
        O: serde::Serialize + Send + 'static;
}

impl<I, O, T: Runnable<I, O> + Sized> IntoDynRunnable<I, O> for T {
    fn into_dyn(self) -> DynRunnableAdapter<I, O, Self>
    where
        Self: Send + Sync + 'static,
        I: serde::de::DeserializeOwned + Send + 'static,
        O: serde::Serialize + Send + 'static,
    {
        DynRunnableAdapter { inner: self, _phantom: std::marker::PhantomData }
    }
}

/// Concrete return type of `Runnable::pipe`.
///
/// Holds the composed pipeline as `first → middle* → last` in a flat, non-nested
/// structure. Each stage holds an erased `Box<dyn DynRunnable>` so heterogeneous
/// types can participate in the sequence.
///
/// Authority: BC-2.01.004 PC1 (concrete return type for `pipe`),
///            BC-2.01.004 PC4 (flattening — `a.pipe(b).pipe(c)` yields `first=a,
///            middle=[b], last=c`, NOT nested sequences),
///            BC-2.01.004 TV-002 (structure must be inspectable: `RunnableSequence
///            { first, middle, last }`).
/// Module: `pregolya-core/src/runnable/sequence.rs`.
pub struct RunnableSequence<I, O> {
    /// The first stage in the pipeline.
    pub(crate) first: Box<dyn DynRunnable>,
    /// Zero or more intermediate stages (empty when `pipe` was called exactly once).
    pub(crate) middle: Vec<Box<dyn DynRunnable>>,
    /// The final stage whose output type is `O`.
    pub(crate) last: Box<dyn DynRunnable>,
    /// `fn(I) -> O` phantom: always Send+Sync regardless of I/O (function pointers
    /// are unconditionally Send+Sync), so chaining pipe().pipe() does not impose
    /// spurious I: Sync or O: Sync bounds. Sibling-consistent with DynRunnableAdapter.
    /// Authority: ADR-005 §Send-Bounded RPITIT; POL-24 sibling-consistency.
    pub(crate) _phantom: std::marker::PhantomData<fn(I) -> O>,
}
```

**BC anchor:** BC-2.01.003 EC-001 (`DynRunnable` object-safe composition path),
BC-2.01.004 PC5/EC-001/TV-004 (`E-CORE-004` on type-boundary mismatch at `DynRunnable::invoke`),
BC-2.01.004 PC1/PC4/TV-002 (`RunnableSequence` concrete type, flattening invariant, inspectable structure)

---

**`RunnableParallel` — Fan-Out Composition Primitive** (D-170/burst-302b)

```rust
/// Fan-out combinator: runs all branches concurrently against the same input.
/// Output is a `serde_json::Value::Object` with exactly one key per branch,
/// in `steps` insertion order regardless of task-completion order.
/// Construction: `RunnableParallel::new(steps)` where `steps` is an iterator of
///   `(K, Arc<dyn DynRunnable>)` pairs where `K: Into<String>`.
/// Module: `pregolya-core/src/runnable/parallel.rs`.
#[non_exhaustive]
pub struct RunnableParallel {
    steps: IndexMap<String, Arc<dyn DynRunnable>>,
}
impl RunnableParallel {
    pub fn new<K: Into<String>>(
        steps: impl IntoIterator<Item = (K, Arc<dyn DynRunnable>)>
    ) -> Self;
}
```

**`RunnablePassthrough` — Identity Runnable with Optional Inspect Side-Effect** (D-170/burst-302b)

```rust
/// Zero-cost identity runnable. `invoke(input, config)` always returns `Ok(input.clone())`.
/// Optional `inspect_fn` is called once with `&input` before the Ok return; its return value
/// is discarded. `inspect_fn` is never called on the error path (RunnablePassthrough never fails).
/// Factory for `RunnableAssign`: `RunnablePassthrough::assign(pairs)`.
/// Module: `pregolya-core/src/runnable/passthrough.rs`.
#[non_exhaustive]
pub struct RunnablePassthrough {
    inspect_fn: Option<Arc<dyn Fn(&serde_json::Value) + Send + Sync>>,
}
impl RunnablePassthrough {
    pub fn new() -> Self;
    pub fn with_inspect(f: impl Fn(&serde_json::Value) + Send + Sync + 'static) -> Self;
    pub fn assign<K: Into<String>>(
        pairs: impl IntoIterator<Item = (K, Arc<dyn DynRunnable>)>
    ) -> RunnableAssign;
}
```

**`RunnableAssign` — Dict Augmentation** (D-170/burst-302b)

```rust
/// Dict augmentation runnable. Always constructed via `RunnablePassthrough::assign(pairs)`.
/// `invoke(input, config)` validates that `input` is `Value::Object`; on non-Object input returns
/// `Err(PregolyaError { category: VAL, code: "E-CORE-010", .. })`.
/// On success merges mapper output over input: mapper keys overwrite input keys on collision.
/// Module: `pregolya-core/src/runnable/passthrough.rs` (same file as `RunnablePassthrough`).
#[non_exhaustive]
pub struct RunnableAssign {
    mapper: RunnableParallel,
}
```

**BC anchor:** BC-2.01.005 PC1–PC6 (`RunnableParallel` construction, concurrent invocation,
N-key output, insertion-order), BC-2.01.006 PC1–PC5 (branch failure, fail-fast, structured
`E-CORE-009` error with branch key, no partial result), BC-2.01.007 PC1–PC7 (`RunnablePassthrough`
identity semantics, inspect contract, infallibility), BC-2.01.008 PC1–PC5 (`RunnableAssign`
construction via `RunnablePassthrough::assign`, non-dict `E-CORE-010`, merge semantics
mapper-wins-on-collision). ADR-026 §Decision 1 (IndexMap representation, key ordering),
ADR-026 §Decision 2 (fail-fast abort), ADR-026 §Decision 3 (zero-cost identity),
ADR-026 §Decision 4 (dict-input validation).

#### RunnableConfig Key Reference — `recursion_limit` Dual-Layer Interpretation (F-P49-02, ADV-P1D-PASS-49)

`recursion_limit: usize` (default **25**) in `RunnableConfig` serves two distinct enforcement
purposes at two independent layers. Both read the same key; enforcement, error code, and
failure scope differ:

| Layer | What is counted | Halt condition | Error | BC authority |
|-------|----------------|---------------|-------|-------------|
| **Runnable-layer** (pregolya-core) | Nested `invoke`/`stream` call depth across chained Runnables (e.g., A pipes into B pipes into C…) | Depth exceeds `recursion_limit` | `Err(PregolyaError { category: INTERNAL, code: "E-CORE-006", message: "RecursionLimitExceeded: recursion limit exceeded at depth <depth>", .. })` | BC-2.01.003 PC5 |
| **Graph-engine-layer** (pregolya-graph BSP loop) | Super-steps per invocation segment; `stop = step_at_invoke_start + recursion_limit + 1` | `current_step > stop` before dispatching next super-step | `Err(E-GRAPH-017 GraphRecursionLimitExceeded)` — run transitions to `failed` | BC-2.03.001 PC5-PC6 |

Upstream parity: LangGraph reuses the same `RunnableConfig.recursion_limit` key for both layers.
LangGraph's graph-layer default is 10007 (the `DEFAULT_RECURSION_LIMIT` constant in the
`langgraph._internal._config` module reads from the `LANGGRAPH_DEFAULT_RECURSION_LIMIT`
environment variable with a hardcoded default of 10007 — verified against
`.reference/langgraph/langgraph/_internal/_config.py` `DEFAULT_RECURSION_LIMIT`
symbol; distinct from langchain-core's `DEFAULT_RECURSION_LIMIT = 25` in
`langchain_core.runnables.config` which is the Runnable-layer default); pregolya
aligns both layers at 25 per langchain-core `RunnableConfig` convention. The graph-engine-layer
halt produces a run-level failure embedded in `Run.error` (see embedded omission note below).

#### RunnableConfig — Struct Definition (F-P92-02)

```rust
/// Per-invocation execution config passed to every `Runnable` method.
/// Carries per-run overrides for runtime parameters; absent/`None` fields inherit
/// the graph-level or system defaults.
///
/// Module: `pregolya-core/src/config.rs` (`core::config`), re-exported at crate root.
/// External callers construct via `RunnableConfig::default()` (yields `recursion_limit = 25`,
/// all `Option` fields `None`). Direct struct-literal construction is barred outside
/// `pregolya-core` by `#[non_exhaustive]` (E0639). Fields may be assigned after
/// `default()` construction via the mutable field syntax.
#[derive(Debug, Clone)]
#[non_exhaustive]
pub struct RunnableConfig {
    /// Maximum Runnable call depth (Runnable-layer) and graph super-step count
    /// (graph-engine-layer). Default: 25. Dual-layer semantics documented above in
    /// §RunnableConfig Key Reference.
    /// Authority: BC-2.01.003 PC5 (Runnable-layer halt), BC-2.03.001 PC5 (graph-layer halt).
    pub recursion_limit: usize,

    /// Thread identity for checkpoint addressing. `None` = stateless run (no prior
    /// thread context shared; each invocation is isolated — BC-2.12.004 PC1/EC-001).
    /// Authority: BC-2.12.004 (schedule thread assignment), entities-server.md §Run.
    pub thread_id: Option<Uuid>,

    /// Per-run budget policy override.
    ///
    /// - `None` → inherit `GraphConfig::budget_config` for this run (graph-level default).
    /// - `Some(bc)` → use `bc` for this run or resumed execution; `GraphConfig::budget_config`
    ///   is ignored for the duration of this invocation.
    ///
    /// **Precedence rule:** `RunnableConfig::budget_config = Some(_)` takes priority over
    /// `GraphConfig::budget_config` for the single run or resumed execution. The graph-level
    /// config is NOT mutated — concurrent runs on the same graph are unaffected.
    ///
    /// **BudgetResume::Extend mechanism:** When the execution engine processes a
    /// `Command(resume = BudgetResume::Extend { new_ceiling })`, it constructs a patched
    /// `BudgetConfig { hard_limit: Some(new_ceiling), ..original }` and places it in
    /// `RunnableConfig::budget_config` for the resumed execution. This is the canonical
    /// mechanism by which the extended ceiling is applied to only that resume.
    ///
    /// Authority: BC-2.10.003 PC7 ("operator supplies a new `RunnableConfig` with
    /// `budget_config: Some(BudgetConfig { hard_limit: Some(higher_ceiling), .. })`"),
    /// BC-2.10.003 TV-004 (halted checkpoint resumable via new RunnableConfig with budget_config),
    /// BC-2.10.004 PC6 ("The `new_ceiling` is applied by patching `RunnableConfig::budget_config`
    /// with `BudgetConfig { hard_limit: Some(new_ceiling), ..original }` for the resumed execution").
    pub budget_config: Option<BudgetConfig>,

    /// Per-run memory context mutation spec. Declares which memory keys are loaded as a
    /// frozen-snapshot prompt prefix at run start (`graph::scheduler`). `None` = no memory
    /// context loaded for this run. Writes during the run are visible at next run start only.
    ///
    /// Scope bridge (F-P175-B101 / ADR-012 Decision 1 Amendment): `ContextSourceSpec.namespace`
    /// is a key-namespace PREFIX within the tenant partition, NOT the `app_id`. Loading uses
    /// `MemoryScope::App(run_context.app_id)` with composite key `"{namespace}/{key}"`.
    /// The caller controls WHICH keys to load; the tenant scope comes exclusively from
    /// `RunContext.app_id` (system-derived, not settable via `RunnableConfig`).
    ///
    /// Authority: BC-2.15.006 PC1 (frozen-snapshot context mutation at run start),
    /// ADR-012 Decision 1 Primitive B and Decision 1 Amendment.
    pub context_mutations: Option<ContextMutationConfig>,

    /// Graph-specific runtime overrides: an untyped key-value map that graphs inspect
    /// at execution time. Key names are graph-defined; the framework performs no
    /// validation at `RunnableConfig` construction time — each graph validates the keys
    /// it expects. Typical uses: model selection (`"model": "gpt-4o"`), system prompt
    /// override (`"system_prompt": "You are a helpful assistant."`), tool-set selection.
    ///
    /// - `None` (default): no graph-specific overrides; graph uses its built-in defaults.
    /// - `Some(map)`: graph reads its parameters from the map via
    ///   `config.configurable.as_ref().and_then(|m| m.get("key"))`.
    ///
    /// **Merge semantics (BC-2.12.003 §Invariants):** when a
    /// Run request supplies `config.configurable`, it is merged over the Assistant's
    /// stored `configurable` map at the key level; run-level keys win on collision.
    /// Merge is applied at run-creation time before dispatch to the executor.
    ///
    /// Port authority: langchain-core `RunnableConfig.configurable` dict
    /// (semport §RunnableConfig mapping §11).
    /// Authority: BC-2.12.002 (Assistant config field), ADR-021 Decision 2.
    pub configurable: Option<HashMap<String, serde_json::Value>>,
}

impl Default for RunnableConfig {
    /// Constructs `RunnableConfig` with production defaults.
    ///
    /// `recursion_limit` defaults to **25** — the canonical pregolya/langchain-core default
    /// (BC-2.01.003 PC5, BC-2.03.001 PC5). `#[derive(Default)]` is intentionally absent:
    /// `usize::default()` yields 0, which would violate the recursion_limit = 25 default
    /// semantics. All `Option` fields default to `None`.
    ///
    /// External construction path: `RunnableConfig { ..RunnableConfig::default() }` is
    /// valid inside `pregolya-core` (same crate); external crates must use `RunnableConfig::default()`
    /// then assign fields mutably, because `#[non_exhaustive]` bars struct-literal forms (E0639).
    fn default() -> Self {
        Self {
            recursion_limit: 25,
            thread_id: None,
            budget_config: None,
            context_mutations: None,
            configurable: None,
        }
    }
}
```

**BC anchor:** BC-2.01.003 PC5 (`recursion_limit` Runnable-layer), BC-2.03.001 PC5 (`recursion_limit` graph-layer), BC-2.12.004 PC1 (`thread_id`), BC-2.10.003 PC7/TV-004 (`budget_config` resume path), BC-2.10.004 PC6 (`budget_config` BudgetResume::Extend), BC-2.15.006 PC1 (`context_mutations`)

### PregolyaError Constructor

**Source:** ADR-010 §Decision (F-P174-constructor). `#[non_exhaustive]` on `PregolyaError` (ADR-010/F-P173-619) bars struct-literal construction from external crates (E0639). The following `impl PregolyaError` block defines the sole sanctioned construction paths.

```rust
// pregolya-core: core::error
impl PregolyaError {
    /// Primary constructor. `source` defaults to `None`; chain a cause with `.with_source(arc)`.
    ///
    /// This is the ONLY construction path available to code outside pregolya-core.
    /// Direct struct-literal `PregolyaError { component: ..., ... }` is barred by
    /// `#[non_exhaustive]` on external crates.
    ///
    /// BC anchor: BC-2.14.001 (PregolyaError 2D model).
    pub fn new(
        component: Component,
        category: Category,
        retry_hint: RetryHint,
        code: &'static str,
        message: impl Into<String>,
    ) -> Self {
        Self { component, category, retry_hint, code, message: message.into(), source: None }
    }

    /// Builder: attach a causal error chain. Consumes `self`; returns updated instance.
    /// The causal chain is accessible via `std::error::Error::source()` for logging.
    /// MUST NOT be exposed in HTTP responses (DI-010 credential-leak risk).
    pub fn with_source(self, source: Arc<dyn std::error::Error + Send + Sync>) -> Self {
        Self { source: Some(source), ..self }
    }
}
```

**Wave C BC routing note:** BC-2.14.001 must be amended to reflect that `PregolyaError` is `#[non_exhaustive]` and that `new()` + `with_source()` are the sole construction paths. The existing BC body describes the struct fields but not the construction API.

### BaseChatModel

```rust
pub trait BaseChatModel: Runnable<Vec<Message>, AiMessage> + Send + Sync {
    /// Returns the provider model identifier string (BC-2.08.001).
    fn model_name(&self) -> &str;

    /// Returns `true` if this provider model supports tool calling.
    /// Used by `bind_tools` to guard against attaching tools to models that cannot invoke them.
    /// BC anchor: BC-2.08.002 EC-005/TV-005 (guard: `bind_tools` returns `Err(E-CORE-005)` when false).
    fn has_tool_calling(&self) -> bool;

    /// Stream a chat completion, yielding per-token `AiMessageChunk`s
    /// (BC-2.08.001, BC-2.08.005 TV).
    ///
    /// Error fidelity: all provider HTTP 4xx/5xx responses MUST map to typed `PregolyaError`
    /// with the correct `category` field (BC-2.08.004 cross-cutting conformance).
    fn stream_chat(&self, messages: Vec<Message>, config: Option<ChatConfig>)
        -> impl std::future::Future<Output = Result<Pin<Box<dyn Stream<Item = Result<AiMessageChunk, PregolyaError>> + Send>>, PregolyaError>> + Send;

    /// Bind tools to this model, enabling tool-call generation.
    ///
    /// Construction-time validation only — no I/O performed.
    ///
    /// # Errors
    /// `Err(PregolyaError { code: "E-CORE-005", .. })`
    /// when `self.has_tool_calling() == false` (BC-2.08.002 EC-005/TV-005).
    fn bind_tools(&self, tools: Vec<ToolDefinition>) -> Result<Box<dyn BaseChatModel + Send + Sync>, PregolyaError>;

    /// Wrap this model to produce structured output deserialized into `T`.
    ///
    /// `schema` is a `serde_json::Value` JSON Schema passed to the provider's
    /// structured-output API (BC-2.08.003 PC: `model.with_structured_output::<T>(schema)`).
    /// `T` must implement `serde::de::DeserializeOwned`, `schemars::JsonSchema`, `Send`, and
    /// `'static` (BC-2.08.009). The `Send + 'static` bound enables the boxed runnable to be
    /// composed into multi-threaded pipelines and stored in `Arc` (F-P2A202-01 adjudication).
    /// Per-method anchors: BC-2.08.003 PC/EC-002/EC-003, BC-2.08.009.
    fn with_structured_output<T: DeserializeOwned + schemars::JsonSchema + Send + 'static>(
        &self,
        schema: serde_json::Value,
    ) -> Box<dyn Runnable<Vec<Message>, T> + Send + Sync>;
}
```

**BC anchor (per-method):**
- `model_name`: BC-2.08.001 (model identity)
- `has_tool_calling`: BC-2.08.002 EC-005/TV-005 (capability guard — `bind_tools` precondition check)
- `stream_chat`: BC-2.08.001 (streaming completions), BC-2.08.004 (error-type fidelity conformance — all provider HTTP errors must map to typed `PregolyaError`), BC-2.08.005 TV (`AiMessageChunk` shape)
- `bind_tools`: BC-2.08.002 PC (tool binding), BC-2.08.002 EC-005/TV-005 (`Err(E-CORE-005)` when `has_tool_calling = false`)
- `with_structured_output`: BC-2.08.003 PC/EC-002/EC-003 (schema-driven structured output), BC-2.08.009 (`schemars::JsonSchema` bound on `T`)

> **BC-2.08.004 anchor (trait-level cross-cutting):** BC-2.08.004 ("Chat Model Error-Type Fidelity Conformance") is a cross-cutting conformance contract: every call path that makes a provider HTTP request — `invoke` (via `Runnable`) and `stream_chat` — MUST map provider HTTP 4xx/5xx responses to typed `PregolyaError` with the correct `category` field. Anchored at `stream_chat` per-method above; also applies to the inherited `Runnable::invoke` path. No `has_tool_calling` method is introduced by BC-2.08.004; `has_tool_calling` is added here from BC-2.08.002 EC-005.

> **Gate #31 type note — `ChatConfig`, `AiMessageChunk`, `ToolDefinition`:** `ChatConfig` is the per-call provider configuration struct in `pregolya-core: core::config` (module-decomposition.md §core::config; SS-01 MEDIUM). The spec corpus mandates one field: `fallback_policy: Option<ProviderFallbackPolicy>` — source: BC-2.08.014 Description ("ChatConfig.fallback_policy: Option<ProviderFallbackPolicy>") and BC-2.08.014 PC1 ("ChatConfig is constructed with a non-empty fallback_policy"). Provider-specific per-call parameters (temperature, max_tokens, stop sequences, and other provider extensions) are not enumerated in the spec corpus; implementations add them as additional fields alongside the mandatory field above. The "corpus-unresolved / implementer defines" marker is retired: the mandatory field is spec-anchored. `AiMessageChunk` is the per-token streaming output type; defined via BC-2.08.001 PC1 + BC-2.08.005 TV (streaming completions BC). `ToolDefinition` is the public tool-schema type; defined via BC-2.08.009 (tool schema naming stability BC).

### CheckpointSaver

```rust
#[async_trait]
pub trait CheckpointSaver: Send + Sync {
    /// Persist task outputs before the next super-step.
    async fn put_writes(
        &self,
        config: CheckpointConfig,
        writes: &[(ChannelName, ChannelValue)],
        task_id: TaskId,
    ) -> Result<(), PregolyaError>;

    /// Load the most recent checkpoint matching the config.
    async fn get_tuple(&self, config: &CheckpointConfig)
        -> Result<Option<CheckpointTuple>, PregolyaError>;

    /// List checkpoints for a thread (newest first).
    async fn list(&self, config: &CheckpointConfig, limit: Option<usize>)
        -> Pin<Box<dyn Stream<Item = Result<CheckpointTuple, PregolyaError>> + Send>>;

    /// Persist a full checkpoint state blob.
    ///
    /// Called once per run under `DurabilityTier::Exit`, or at the end of any run that
    /// produced a complete checkpoint (BC-2.04.002 PC4/EC-002, BC-2.04.001 EC-003).
    /// Both `checkpoint` and `metadata` bytes are encrypted when an `EncryptedSerializer`
    /// is active (BC-2.04.007 PC1).
    ///
    /// # Errors
    /// - `Err(PregolyaError { code: "E-CHKPT-005", .. })` if the composite
    ///   triple `(config.thread_id, config.checkpoint_ns, config.checkpoint_id)` already
    ///   exists under a different tenant context (BC-2.04.006 EC-005).
    async fn put(
        &self,
        config: CheckpointConfig,
        checkpoint: Checkpoint,
        metadata: CheckpointMetadata,
    ) -> Result<(), PregolyaError>;

    /// Compute the next monotonic checkpoint ID for a `(thread_id, checkpoint_ns)` pair.
    ///
    /// Default implementation delegates to `MonotonicClock::get_next_version`.
    /// Implementors MAY override for backend-specific ordering logic.
    ///
    /// # Arguments
    /// - `current`: `None` for a fresh pair (no prior checkpoints); `Some(c)` for the
    ///   `checkpoint_id` from the most recently loaded `CheckpointTuple` for this pair.
    /// - `channel`: accepted for API compatibility (BC-2.04.003 PC1); unused for ordering
    ///   (all channels within a super-step share a single `next_version` — BC-2.04.003 PC5).
    ///
    /// # Errors
    /// - `Err(E-CHKPT-002)` on `u64` overflow (unreachable in practice).
    fn get_next_version(
        &self,
        current: Option<CheckpointId>,
        channel: &ChannelName,
    ) -> Result<CheckpointId, PregolyaError> {
        MonotonicClock::get_next_version(current, channel)
    }

    /// Full-text search over checkpoint history (FTS5 index covering conversation messages,
    /// tool call arguments, and tool results).
    ///
    /// Returns BM25-ranked results ordered by `rank` ascending (most relevant first).
    /// Returns `Ok(vec![])` when no matches exist — not an error (BC-2.04.008 PC4/EC-001).
    /// This is a pure read; it does not write to or affect the FTS5 index (BC-2.04.008 Invariants).
    ///
    /// # Arguments
    /// - `query`: FTS5 query string; phrase syntax supported (e.g., `"\"Paris weather\""`).
    ///   Malformed FTS5 syntax returns `Err(E-CHKPT-008)` at call time (BC-2.04.008 EC-002).
    /// - `config`: `FtsSearchConfig<'_> { thread_id: Option<&'_ str>, limit: usize }`.
    ///   `thread_id: Option<&'_ str>` is legitimately a string-form FTS scope filter (not
    ///   `Option<Uuid>`): the FTS5 virtual table stores thread_ids as serialized strings;
    ///   `FtsSearchResult.thread_id: String` confirms FTS operates in string space; callers
    ///   with a server-layer `Uuid` thread_id pass `.to_string()` or the hyphenated-string
    ///   form (OBS-P2A094-2 adjudication).
    ///   `config.limit = 0` returns `Err(E-CHKPT-008 FtsLimitZero)` (BC-2.04.008 PC6/EC-004).
    ///
    /// # Errors
    /// - `Err(E-CHKPT-008)` — `FtsLimitZero` (`config.limit == 0`) or malformed FTS5 query syntax.
    /// - `Err(E-CHKPT-009)` — `Fts5Unavailable` (FTS5 not compiled into SQLite build;
    ///   normally caught at `CheckpointSaver::new()` construction time per BC-2.04.008 EC-006).
    async fn fts_search(
        &self,
        query: &str,
        config: FtsSearchConfig<'_>,
    ) -> Result<Vec<FtsSearchResult>, PregolyaError>;

    /// Initialize an empty `GuardrailJournal` record for a run in the checkpoint store.
    ///
    /// Called by `graph::provenance` at run start **iff**
    /// `invocation_context.guardrail_hook().is_some()`, before any ingress boundary
    /// evaluation. Sync-durable write — creates the empty journal record that enables
    /// the 3-state discriminator in [`CheckpointSaver::get_guardrail_journal`]
    /// (BC-2.11.007 {INV-004}; DC-44 ruling):
    ///
    /// - `None`      — no init was called (no hook registered)
    /// - `Some([])` — init called, zero entries appended
    /// - `Some([N])` — init called, N entries appended
    ///
    /// `GuardrailEntry` ∈ `core::guardrail` (`pregolya-core`); `checkpoint → core`
    /// dependency direction is permitted (F-PDC48-04/DC-48).
    ///
    /// # Errors
    /// - `Err(PregolyaError { category: DURABILITY, .. })` on checkpoint storage failure.
    async fn init_guardrail_journal(
        &self,
        run_id: Uuid,
    ) -> Result<(), PregolyaError>;

    /// Append one `GuardrailEntry` to the run's checkpoint-backed journal.
    ///
    /// Called by `graph::provenance` sync-durably after each **successfully-returning**
    /// `GuardrailHook::evaluate()` call, before graph execution continues at the
    /// ingress boundary (BC-2.11.007 {PC-001}/{INV-002}). Not called on panicking or
    /// erroring `evaluate()` calls ({EC-003}).
    ///
    /// # Errors
    /// - `Err(PregolyaError { category: DURABILITY, .. })` on checkpoint storage failure.
    async fn append_guardrail_entry(
        &self,
        run_id: Uuid,
        entry: &GuardrailEntry,
    ) -> Result<(), PregolyaError>;

    /// Read the `GuardrailJournal` for a run from the checkpoint store.
    ///
    /// Returns the 3-state discriminator (BC-2.11.007 {INV-004}; DC-44 ruling):
    ///
    /// - `Ok(None)`       — no journal record for `run_id`
    ///   (hook not registered; `init_guardrail_journal` was never called)
    /// - `Ok(Some([]))`   — journal record exists, zero entries
    ///   (hook registered + zero ingress boundaries reached)
    /// - `Ok(Some([N]))`  — journal record exists with N entries
    ///
    /// Called by the run-read handler in `server::handlers` at run-read time to
    /// assemble the `guardrail_journal?` None/Some projection
    /// (BC-2.12.003 {PC-013}; S-1.29 AC-002/AC-003; `server::run_read_handler`
    /// is not a separate module — F-PDC48-02/DC-48).
    ///
    /// # Errors
    /// - `Err(PregolyaError { category: DURABILITY, .. })` on checkpoint storage failure.
    async fn get_guardrail_journal(
        &self,
        run_id: Uuid,
    ) -> Result<Option<Vec<GuardrailEntry>>, PregolyaError>;
}
```

**BC anchor:** BC-2.04.001 through BC-2.04.008, BC-2.11.007 (guardrail journal ops: `init_guardrail_journal`, `append_guardrail_entry`, `get_guardrail_journal`); `put` method: BC-2.04.002 PC4/EC-002, BC-2.04.001 EC-003, BC-2.04.006 PC2, BC-2.04.007 PC1+INV-1; `get_next_version` provided method: BC-2.04.003 PC1/PC5; `fts_search` method: BC-2.04.008 PC1/PC3–PC6, EC-001–006; guardrail journal methods: BC-2.11.007 {PRE-001}/{PC-001}/{PC-002}/{INV-002}/{INV-004}

> **Gate #31 type note — `CheckpointConfig`, `ChannelName`, `ChannelValue`, `TaskId`, `CheckpointTuple`, `Checkpoint`, `CheckpointMetadata`, `CheckpointId`, `FtsSearchConfig`, `FtsSearchResult`:** `CheckpointConfig` is the checkpoint-addressing config; not formally enumerated as a spec-level struct — logically derived from BC-2.04.006 triple-address invariant (`thread_id: Uuid`, `checkpoint_ns: NamespaceId`, `checkpoint_id: Option<LogicalClockId>`); flagged corpus-unresolved for architect. `ChannelName` and `ChannelValue` are defined in entities-graph.md §GraphState (`Map<ChannelName, ChannelValue>`). `TaskId` is defined in VP-001.md (Kani harness: `TaskId(i as u64)` newtype around u64). `CheckpointTuple` is defined in entities-graph.md §CheckpointTuple. `Checkpoint` and `CheckpointMetadata` are defined in entities-graph.md §Checkpoint (`Checkpoint` has fields `checkpoint_id: LogicalClockId`, `thread_id`, `checkpoint_ns: NamespaceId`, `parent_checkpoint_id: Option<LogicalClockId>`, `state: GraphState`, `metadata: CheckpointMetadata`, `pending_sends: Vec<Send>`; `CheckpointMetadata` is the inline metadata sub-type on `Checkpoint`). `CheckpointId` is a newtype over `u64` per ADR-005 / BC-2.04.003 Architecture Anchors (monotonic logical clock; `get_next_version` produces instances). `FtsSearchConfig` and `FtsSearchResult` are RESOLVED — defined in `pregolya-checkpoint/src/fts.rs` per BC-2.04.008 Architecture Anchors: `FtsSearchConfig { thread_id: Option<&str>, limit: usize }` (BC-2.04.008 PC3; `thread_id: Option<&str>` is legitimately `&str` not `Option<Uuid>` — FTS5 virtual table stores thread_ids as serialized strings; `FtsSearchResult.thread_id: String` confirms FTS operates in string space; OBS-P2A094-2 adjudication); `FtsSearchResult { checkpoint_id: CheckpointId, thread_id: String, checkpoint_ns: String, message_role: MessageRole, content_snippet: String, rank: f64 }` (BC-2.04.008 PC1; BM25 rank ascending = most relevant first). `GuardrailEntry` is RESOLVED — defined in §GuardrailHook below (added DC-58/F-PDC58-01): `{ boundary: IngressBoundary, result: GuardrailResult, provenance: ProvenanceTag, timestamp_ms: u64 }` (entities-server.md §GuardrailJournal; DC-34/O-PDC34-A — no `transform_applied`; canonical location `pregolya-core/src/guardrail.rs`). `run_id: Uuid` used directly in guardrail journal methods — consistent with `TrajectoryRecord.run_id: Uuid` / `TrajectoryReader::replay(run_id: Uuid)` precedent; `RunId` (StreamEvent wire field) is a distinct type from the `Uuid` used in checkpoint store ops.

### GuardrailHook

```rust
#[async_trait]
pub trait GuardrailHook: Send + Sync {
    /// Evaluate a single content unit arriving at a tool-result, RAG retrieval, or
    /// memory ingress boundary before it enters the model context (BC-2.11.001 PC5).
    ///
    /// # Return values
    /// - `GuardrailResult::Pass`                       → content forwarded unchanged
    ///   (BC-2.11.002 PC2)
    /// - `GuardrailResult::Fail { reason, severity }`  → content blocked; error block injected
    ///   at content's position; run continues unless `severity == Critical`
    ///   (BC-2.11.002 PC3, BC-2.11.005 PC4)
    /// - `GuardrailResult::Transform { new_content }`  → replacement forwarded; original
    ///   discarded (BC-2.11.002 PC4)
    ///
    /// # Panic safety
    /// A panic in this method is caught at the ingress boundary and treated as fail-closed:
    /// the pipeline propagates `Err(PregolyaError { code: "E-CORE-007", .. })`
    /// to the caller; content does not enter model context (BC-2.11.002 EC-001, E-CORE-007).
    async fn evaluate(
        &self,
        content: IngressContent,
        provenance_tag: ProvenanceTag,
    ) -> GuardrailResult;
}

#[non_exhaustive]
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum GuardrailResult {
    /// Content passes through to model context unchanged.
    Pass,
    /// Content is blocked; an error block is injected at the content's position.
    /// `severity == Critical` transitions the run to `failed` and halts inference;
    /// lower severities (High, Medium, Low) allow the run to continue with the error
    /// block substituted (BC-2.11.002 PC3, BC-2.11.005 PC4).
    Fail {
        reason: String,
        severity: GuardrailSeverity,
    },
    /// Content is replaced; `new_content` enters model context; original is discarded.
    /// `new_content` MUST be the same `IngressContent` variant as the input content
    /// (same ingress boundary — e.g. a ToolResult evaluator must return ToolResult).
    /// The inner payload may change freely — for example, a different `ContentBlock`
    /// variant within `IngressContent::ToolResult` is permitted (BC-2.11.002 EC-003).
    /// Cross-boundary transforms (e.g. ToolResult → RagChunk) are not authorized
    /// by any contract and are semantically nonsensical at a fixed ingress boundary.
    Transform {
        new_content: IngressContent,
    },
}

/// Content unit passed to `GuardrailHook::evaluate`.
/// Each variant corresponds to one ingress boundary type.
///
/// The `<content_type>` placeholder in E-CORE-007's message format
/// (`GuardrailHook::evaluate panicked at <boundary> for content type '<content_type>'`)
/// is the variant name: `"ToolResult"`, `"RagChunk"`, or `"MemoryItem"`.
///
/// BC authorities: BC-2.11.002 PC1 (ToolResult boundary),
/// BC-2.11.003 PC1/PC5 (RAG boundary), BC-2.11.004 PC1/PC5 (memory boundary).
#[non_exhaustive]
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub enum IngressContent {
    /// ContentBlock from a tool-result ingress boundary (BC-2.11.002 PC1).
    /// Inner type: `ContentBlock` per entities-graph.md §ContentBlock.
    ToolResult(ContentBlock),
    /// Document chunk from a RAG retrieval ingress boundary (BC-2.11.003 PC1, PC5).
    /// Payload type `Value` = `serde_json::Value`; internal structure is backend-specific.
    RagChunk(Value),
    /// Memory item from a memory ingress boundary (BC-2.11.004 PC1, PC5).
    /// Payload type `Value` = `serde_json::Value`; internal structure is store-specific.
    MemoryItem(Value),
}

/// Severity of a `GuardrailResult::Fail` outcome.
/// Determines whether the run continues (High/Medium/Low) or transitions to `failed` (Critical).
#[non_exhaustive]
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum GuardrailSeverity {
    /// Run transitions to `failed`; inference halted; no further nodes execute.
    /// Authority: BC-2.11.002 INV-3, BC-2.11.003 PC3, BC-2.11.004 PC3, BC-2.11.005 PC4.
    Critical,
    /// Error block substituted at content position; run continues (BC-2.11.005 PC5).
    High,
    /// Error block substituted at content position; run continues (BC-2.11.005 PC5).
    Medium,
    /// Error block substituted at content position; run continues (BC-2.11.005 PC5).
    Low,
}

/// A single guardrail evaluation record appended to the checkpoint-backed
/// `GuardrailJournal` (BC-2.11.007) after each successfully-returning
/// `GuardrailHook::evaluate` call.
///
/// Canonical location: `pregolya-core/src/guardrail.rs` (`core::guardrail`).
/// Authority: entities-server.md §GuardrailJournal; DC-34/O-PDC34-A ruling —
/// `transform_applied: Option<String>` is absent; `result.Transform.new_content: IngressContent`
/// is the authoritative transform payload.
///
/// # Derive rationale
/// - `Debug`, `PartialEq`: required by VP-2.11.007-A §Proof Harness —
///   `assert_eq!(journal[0].result, GuardrailResult::Pass)` requires
///   `GuardrailResult: PartialEq + Debug` (propagated from field types).
/// - `Clone`, `Serialize`, `Deserialize`: required for checkpoint-backed persistence —
///   `CheckpointSaver::append_guardrail_entry` serializes `GuardrailEntry` to the SQLite
///   backend; `get_guardrail_journal` deserializes `Vec<GuardrailEntry>` on read
///   (BC-2.11.007 {PC-001}/{INV-002}).
#[non_exhaustive]
#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct GuardrailEntry {
    /// The ingress boundary at which the evaluation occurred.
    /// Canonical enum per BC-2.06.001 {PC-002}; values `ToolResult | RagChunk | MemoryItem`.
    pub boundary: IngressBoundary,
    /// The evaluation outcome returned by `GuardrailHook::evaluate`.
    /// `Transform.new_content: IngressContent` is the authoritative transform payload
    /// (O-PDC34-A — `transform_applied: Option<String>` is not a field).
    pub result: GuardrailResult,
    /// The `ProvenanceTag` attached to the evaluated content at the ingress boundary.
    pub provenance: ProvenanceTag,
    /// Wall-clock timestamp of the evaluation in milliseconds since the Unix epoch.
    /// Monotone across entries within a run (BC-2.11.007 {INV-002}).
    pub timestamp_ms: u64,
}
```

**BC anchor:** BC-2.11.001 (ProvenanceTag precondition for evaluate call),
BC-2.11.002 (tool-result boundary — primary trait-shape authority),
BC-2.11.003 (RAG retrieval boundary), BC-2.11.004 (memory ingress boundary),
BC-2.11.005 (fail-closed rejection guarantee — GuardrailResult::Fail closure contract),
BC-2.11.006 (no-hook default — GuardrailHook not registered)

### InvocationContext

Per-run hook registry struct. Passed by reference into dispatch modules
(`graph::provenance`, `mcp::ingress`) at invocation time. Default construction
yields all-`None` slots (no-hook path, BC-2.11.006). Hook registration is additive
and does not mutate any execution state; the struct owns the `Arc` handle.

Canonical location: `pregolya-core/src/invocation_context.rs` (SS-11;
follows trait-in-core precedent established by `core::guardrail` / ADR-014 Decision 6).

```rust
/// Per-run hook registry. Constructed once per invocation and passed by shared
/// reference to dispatch modules. Definitions-only; no execution logic.
/// BC-2.11.001–006 {PRE-001}; BC-2.09.003 {PRE-002}/{PRE-003}.
pub struct InvocationContext {
    guardrail_hook: Option<Arc<dyn GuardrailHook>>,
}

impl InvocationContext {
    /// Construct with no hooks registered (BC-2.11.006 no-hook default).
    pub fn new() -> Self {
        Self { guardrail_hook: None }
    }

    /// Register a guardrail hook for this invocation context.
    /// Overwrites any previously registered hook; the `Arc` is cloned.
    pub fn register_guardrail(&mut self, hook: Arc<dyn GuardrailHook>) {
        self.guardrail_hook = Some(hook);
    }

    /// Query the registered guardrail hook, if any.
    /// Returns `None` on the no-hook fast path (BC-2.11.006).
    pub fn guardrail_hook(&self) -> Option<&Arc<dyn GuardrailHook>> {
        self.guardrail_hook.as_ref()
    }
}

impl Default for InvocationContext {
    fn default() -> Self {
        Self::new()
    }
}
```

**BC anchor:** BC-2.11.001–006 {PRE-001} (InvocationContext construction, hook
registration, and dispatch preconditions); BC-2.09.003 {PRE-002}/{PRE-003}
(mcp::ingress guardrail dispatch path — `InvocationContext` is the DI seam that
enables `mcp::ingress` to call `GuardrailHook::evaluate` without a direct
`pregolya-graph` dependency).

> **Adjudication note (round-49/F-P2A207-02+F-P2A207-03):** `InvocationContext`
> is definitions-only (no execution logic; no VP target; ADR-009 definitions-only
> precedent). Canonical module: `core::invocation_context` in
> `pregolya-core/src/invocation_context.rs` (SS-11 owner). This is the DI seam
> for guardrail dispatch shared by `graph::provenance` and `mcp::ingress` — placing
> it in `pregolya-core` prevents a `pregolya-mcp` → `pregolya-graph` compile-time
> dependency cycle (trait-in-core precedent: `GuardrailHook`, `BudgetPolicy`,
> `MemoryWriteGuard`, `ActionRisk` all follow this pattern).

### BudgetPolicy

```rust
pub trait BudgetPolicy: Send + Sync {
    /// Evaluate the current token/cost usage against this policy's configured thresholds.
    ///
    /// **Pure, synchronous, and side-effect-free.** This function returns a decision only;
    /// it must not write to any journal, mutate state, or perform I/O.
    /// All side effects (EvidenceJournal append, interrupt trigger, halt sequencing)
    /// are the responsibility of the caller (BudgetEngine / execution engine) after
    /// receiving the decision.
    ///
    /// Authority: BC-2.10.001 INV (purity invariant) + ADR-009.
    fn evaluate(&self, usage: TokenUsage, context: &RunContext) -> PolicyDecision;
}

/// Decision returned by `BudgetPolicy::evaluate`.
///
/// Authority: BC-2.10.001 PC3 (three-variant contract),
/// BC-2.10.001 TV-001 (Allow), TV-002 (Escalate with payload), TV-003 (Deny with payload).
pub enum PolicyDecision {
    Allow,
    Escalate { reason: String, current_usage: TokenUsage },
    Deny { reason: String, current_usage: TokenUsage },
}

/// Engine behavior when `PolicyDecision::Deny` (hard-ceiling exceeded) is received.
///
/// `on_ceiling` is consulted by the execution engine ONLY for `PolicyDecision::Deny`.
/// It does NOT affect handling of `PolicyDecision::Escalate`: a soft-ceiling Escalate
/// decision ALWAYS suspends the run via HITL interrupt — `on_ceiling` is not read for
/// that path (BC-2.10.001 PC3).
///
/// When `PolicyDecision::Deny` is received, the engine reads this field to choose
/// between halting immediately, re-escalating to HITL (same mechanism as the soft-limit
/// path), or issuing a final summarize LLM call. The `BudgetPolicy::evaluate` trait
/// stays pure and data-free; the engine owns all dispatch (ADR-009 Option 3).
///
/// Authority: BC-2.10.001 PC3 (Escalate decision → HITL unconditionally),
/// BC-2.10.003 (Halt + Summarize variants for Deny),
/// BC-2.10.004 (Escalate variant for Deny; also covers the soft-limit Escalate path).
pub enum OnCeiling {
    /// Stop the run immediately when `PolicyDecision::Deny` (hard ceiling) is received;
    /// transition to `failed` with E-BUDGET-001 (BC-2.10.003 PC5).
    Halt,
    /// When `PolicyDecision::Deny` (hard ceiling) is received, suspend via HITL interrupt
    /// rather than halting; run parks in `interrupted` status, awaiting
    /// `BudgetResume::Extend { new_ceiling }` or `BudgetResume::Halt` (BC-2.10.004).
    /// This is the "escalate on ceiling hit" mode: both the soft-ceiling
    /// `PolicyDecision::Escalate` path (always HITL) and this hard-ceiling Deny→Escalate
    /// path use the same `BudgetEscalation` interrupt mechanism (BC-2.10.004).
    Escalate,
    /// Issue one final LLM call using `summarize_prompt` as a `HumanMessage`;
    /// return the model response as run output with `status = summary_halt`
    /// (BC-2.10.003 PC8). If the summarize call itself triggers `Deny`, the run falls
    /// back to `Halt` semantics — E-BUDGET-001, `status = failed` (BC-2.10.003 EC-005).
    Summarize { summarize_prompt: String },
}

/// Configuration for the built-in budget governance policy.
///
/// Carried via `GraphConfig::budget_config: Option<BudgetConfig>` (ADR-009 Option 3).
/// The engine constructs a `BudgetPolicy` implementation from these fields; policy
/// evaluation itself is pure (`BudgetPolicy::evaluate` has no side effects).
///
/// Authority: BC-2.10.001 TV-001/TV-002/TV-003 (`soft_limit` + `hard_limit` thresholds),
/// BC-2.10.003 + BC-2.10.004 (`on_ceiling` behavior), ADR-009 Option 3.
pub struct BudgetConfig {
    /// Token count at which `PolicyDecision::Escalate` is returned.
    /// `None` = no soft ceiling; the Escalate path is never triggered by token count alone.
    pub soft_limit: Option<u64>,
    /// Token count at which `PolicyDecision::Deny` is returned.
    /// `None` = no hard ceiling; the Deny path is never triggered by token count alone.
    pub hard_limit: Option<u64>,
    /// Engine behavior when the hard ceiling (`PolicyDecision::Deny`) is reached.
    pub on_ceiling: OnCeiling,
}
```

> **Engine dispatch decision table — complete `PolicyDecision` × `on_ceiling` → action
> mapping. Zero unspecified cells.**
> `BudgetPolicy::evaluate` is pure and data-free — `evaluate` has no knowledge of
> `on_ceiling`; the engine owns all dispatch (ADR-009 Option 3).
>
> | `PolicyDecision` | `BudgetConfig::on_ceiling` | Engine Action | Run Status | Resume Mechanism |
> |---|---|---|---|---|
> | `Allow` | (any — not consulted) | Continue execution; journal entry written (BC-2.10.002) | unchanged | — |
> | `Escalate` | **(any — not consulted)** | Trigger HITL interrupt with `BudgetEscalation` payload; `on_ceiling` is NOT read for this path (BC-2.10.004; authority: BC-2.10.001 PC3) | `interrupted` | `BudgetResume::Extend { new_ceiling }` or `BudgetResume::Halt` |
> | `Deny` | `Halt` | Graceful halt per BC-2.10.003: complete in-flight super-step tasks, call `put_writes`, error `E-BUDGET-001` | `failed` | Resumable via new `RunnableConfig` with higher `hard_limit` (not a HITL resume) |
> | `Deny` | `Escalate` | Trigger HITL interrupt with `BudgetEscalation` payload; same `interrupt()` mechanism as the `Escalate` row above (BC-2.10.004) | `interrupted` | `BudgetResume::Extend { new_ceiling }` or `BudgetResume::Halt` |
> | `Deny` | `Summarize { summarize_prompt }` | Issue one final LLM call per BC-2.10.003 PC8; fall back to `Halt` semantics (E-BUDGET-001, `status = failed`) if the summarize call itself triggers `Deny` (BC-2.10.003 EC-005) | `summary_halt` (or `failed` on recursive `Deny`) | — |
>
> Escalate-path authority: BC-2.10.001 PC3 — "execution suspends; the run transitions to
> `interrupted` via the HITL interrupt mechanism (BC-2.10.004)" — no `on_ceiling`
> qualification. Deny-path authority: BC-2.10.003 (Halt + Summarize), BC-2.10.004
> (Deny + `on_ceiling = Escalate` → HITL).

> **`RunContext`** — RESOLVED. Defined by BC-2.10.001 precondition 3: "The execution engine
> has access to the `RunContext` (thread_id, run_id, sub-agent identity if applicable) for
> policy evaluation calls." Fields: `thread_id`, `run_id`, `sub_agent_id: Option<SubAgentId>`,
> `budget_info: Option<BudgetInfo>` (BC-2.10.003 PC5/INV; populated by `graph::budget_engine`
> at each super-step boundary before task dispatch; `None` when no `BudgetPolicy` is active),
> `app_id: String` (F-P175-B101 / ADR-012 Decision 1 Amendment — system-derived application
> identity for memory tenancy; set by `graph::scheduler` before the first super-step; NOT
> overridable via `RunnableConfig`; used as the `app_id` for `MemoryScope::App(app_id)` in
> all `ContextMutationConfig` reads and `SkillStore` construction; empty string = no-scope
> sentinel — all `MemoryScope::App` reads return `Ok(None)`).
> Concrete struct definition lives in `pregolya-core/src/budget.rs` per ADR-009 Option 3.
> (gate #31 RESOLVED via BC-2.10.001 precondition 3 — name-equality verified)

> **`BudgetInfo`** — RESOLVED (defined inline). Struct carried in `RunContext.budget_info:
> Option<BudgetInfo>` at each super-step boundary. Fields:
> `tokens_remaining: Option<i64>` — `ceiling - accumulated_tokens` (signed; may be negative
> when a Deny has just been triggered because `accumulated > ceiling`; `None` if no token
> ceiling is configured), `steps_remaining: Option<i64>` — `recursion_limit - current_step`
> (`None` if no step limit is configured).
> Authority: BC-2.10.003 PC5 (remaining-budget exposure postcondition),
> BC-2.10.003 INV (signed arithmetic rationale for `Option<i64>`),
> BC-2.10.003 TV-007 (canonical test vector: ceiling=10000, accumulated=3000,
> recursion_limit=25, step=1 → tokens_remaining=Some(7000), steps_remaining=Some(24)).
> Module: `pregolya-core/src/budget.rs` (alongside `RunContext`).
> (gate #31 RESOLVED — defined inline; added v2.21)

**BC anchor:** BC-2.10.001 precondition 3 (RunContext fields: thread_id, run_id, sub-agent identity),
BC-2.10.001 PC3 (PolicyDecision variants + purity invariant),
BC-2.10.001 TV-001–TV-003 (soft_limit/hard_limit thresholds + variant payloads),
BC-2.10.002 INV (journal writes are caller responsibility),
BC-2.10.003 (OnCeiling Halt + Summarize variants; PC5/INV/TV-007 BudgetInfo shape and arithmetic),
BC-2.10.004 (OnCeiling Escalate variant — HITL interrupt path),
ADR-009 Option 3 (BudgetConfig placement in GraphConfig; pure/effectful boundary)

### ToolCallDialect

```rust
/// Pluggable, object-safe seam for serializing and deserializing tool calls.
/// Implementations: NativeOpenAiJson (default), NativeAnthropic, HermesChatMlXml.
///
/// Authority: BC-2.08.013 (Pluggable Tool-Call Dialect Seam).
/// Module: pregolya-core (trait definition); pregolya-<provider> (dispatch).
pub trait ToolCallDialect: Send + Sync {
    /// Serialize a single ToolCall to the dialect's wire format.
    fn serialize_tool_call(&self, call: &ToolCall) -> Result<String, PregolyaError>;
    /// Deserialize zero or more tool calls from model output content.
    fn deserialize_tool_calls(&self, content: &str) -> Result<Vec<ToolCall>, PregolyaError>;
    /// Machine-readable dialect identifier (e.g., "openai_json", "anthropic", "hermes_chatml_xml").
    fn dialect_name(&self) -> &str;
}
```

**BC anchor:** BC-2.08.013 PC1–PC9 (built-in dialect round-trips; PC8/PC9 = E-PROV-009 on parse failure) + PC10 (object-safe trait contract)

### ProviderFallbackPolicy

```rust
/// Ordered fallback chain for provider-level resilience.
/// Tries each provider in `chain` in order; falls over on 429, 5xx, or auth failure.
///
/// The `chain` field is PRIVATE — use `ProviderFallbackPolicy::new()` to construct.
/// Direct struct literal construction `ProviderFallbackPolicy { chain: vec![] }` is
/// not possible; this enforces the non-empty invariant (BC-2.08.014 Invariant / DI-008).
///
/// Authority: BC-2.08.014 (Provider Failover Chain).
/// Module: pregolya-core (struct definition); pregolya-<provider> (dispatch).
#[non_exhaustive]
pub struct ProviderFallbackPolicy {
    /// Ordered list of provider credentials to try; first entry is primary. PRIVATE — non-empty invariant.
    chain: Vec<ProviderCredential>,
    /// Optional configuration for automatic credential refresh on auth failure.
    pub credential_refresh: Option<CredentialRefreshConfig>,
}

impl ProviderFallbackPolicy {
    /// Construct a fallback policy from an ordered provider chain.
    ///
    /// Validates that `chain` is non-empty at construction time (DI-008; BC-2.08.014 Invariant).
    ///
    /// # Errors
    /// `Err(PregolyaError { code: "E-PROV-011", .. })`
    /// when `chain` is empty (BC-2.08.014 EC-006/TV-007).
    pub fn new(chain: Vec<ProviderCredential>) -> Result<Self, PregolyaError>;
}
```

> **`ProviderCredential`** — Opaque credential type; per-provider shape (API key newtype, OAuth bearer token, custom auth header, etc.) varies by implementation. **DI-010 (Credential Opacity) is unconditional:** every `ProviderCredential` implementation MUST declare `impl fmt::Debug for ProviderCredential { fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result { f.write_str("<redacted>") } }` — key material must never appear in `Debug`, `Display`, or any log output. No `#[derive(Debug)]` is permitted on any type that holds secret values (BC-2.08.004 EC-001: auth error must not reveal the API key; BC-2.14.005 credential opacity invariant). Gate #31: per-provider shape is implementation-defined; the DI-010 redacted-Debug obligation is unconditional and is now the only open item.
>
> **`CredentialRefreshConfig`** — Opaque configuration for automatic credential refresh on auth failure (BC-2.08.014 PC3). May contain callback closures, token endpoints, or refresh secrets. **DI-010 (Credential Opacity) is unconditional:** every `CredentialRefreshConfig` implementation MUST declare `impl fmt::Debug for CredentialRefreshConfig { fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result { f.write_str("<redacted>") } }` — any embedded credentials or token material must never transit AI context. Gate #31: per-provider shape is implementation-defined; the DI-010 redacted-Debug obligation is unconditional and is now the only open item.

**BC anchor:** BC-2.08.014 PC1–PC4 (ordered fallback semantics) + PC5 (E-PROV-010 on chain exhaustion)

### SkillStore

```rust
/// Pluggable skill document registry for load-on-demand skill retrieval.
///
/// Authority: BC-2.15.004 (SkillStore Registry — Load-on-Demand Skill Documents).
/// Module: pregolya-memory (memory::skills).
pub trait SkillStore: Send + Sync {
    /// Load a skill document by its registered name.
    /// Returns `Ok(Some(content))` if found; `Ok(None)` if no skill with that name exists.
    /// The name→(namespace, key) storage mapping is impl-internal (BC-2.15.004 Invariant).
    async fn load_skill(&self, name: &str) -> Result<Option<String>, PregolyaError>;

    /// List all registered skill descriptors, optionally filtered by tags.
    /// Passing an empty slice returns ALL registered descriptors (BC-2.15.004 PC2).
    async fn list_skills(&self, tags: &[String]) -> Result<Vec<SkillDescriptor>, PregolyaError>;

    /// Check whether a skill with the given name is registered, without loading its document.
    /// A cheap existence check — does NOT load content (BC-2.15.004 PC3).
    async fn skill_exists(&self, name: &str) -> Result<bool, PregolyaError>;
}

/// Metadata descriptor for a registered skill document.
///
/// Authority: BC-2.15.004 (SkillStore Registry) — defined inline.
pub struct SkillDescriptor {
    pub name: String,
    pub namespace: String,
    pub key: String,
    pub tags: Vec<String>,
}
```

> **`SkillDescriptor`** — RESOLVED. Defined inline above; fields match BC-2.15.004 postconditions (name, namespace, key, tags). (gate #31 RESOLVED)

> **SkillStore scope encapsulation (F-P175-B102 / ADR-012 Decision 1 Amendment):** `SkillStore`
> trait methods carry NO scope parameter. Scope is encapsulated at construction time:
> the SkillStore implementor's `new(store: Arc<dyn MemoryStore>, app_id: String)` constructor. All `load_skill` /
> `list_skills` / `skill_exists` calls resolve within `MemoryScope::App(app_id)`. If
> `app_id` is empty at construction, the implementation returns `Err(E-MEMORY-004
> NoScopeContext)` — fail-closed. External callers do not supply or observe the scope.

**BC anchor:** BC-2.15.004 PC1–PC4 (load-on-demand, list, exists; None on missing is Ok not Err)

### MemoryWriteGuard

```rust
/// Pure, synchronous guard that validates memory and skill write operations
/// before they are committed to the backing store.
/// Fail-closed: Deny and Transform decisions block writes; Allow proceeds.
///
/// Authority: BC-2.15.005 (Guarded Memory and Skill Writes).
/// Module: pregolya-core (core::write_guard); pregolya-memory (write_guard dispatch).
pub trait MemoryWriteGuard: Send + Sync {
    /// Validate a proposed write operation. Pure — no I/O, no state mutation.
    fn validate(&self, req: &MemoryWriteRequest) -> WriteGuardDecision;
}

/// Describes a proposed write to the memory or skill store.
///
/// Authority: BC-2.15.005 — defined inline.
pub enum MemoryWriteRequest {
    Add { namespace: String, key: String, value: Value },
    /// `old_value: None` — unconditional replace (replace regardless of current value).
    /// `old_value: Some(v)` — match-based replace (only if current value equals `v`).
    /// Authority: ADR-012 Decision 1 / Primitive C; BC-2.15.005 PC2.
    Replace { namespace: String, key: String, old_value: Option<Value>, new_value: Value },
    Remove { namespace: String, key: String },
}

/// Decision returned by `MemoryWriteGuard::validate`.
///
/// Authority: BC-2.15.005 — defined inline.
pub enum WriteGuardDecision {
    Allow,
    Deny { reason: String },
    Transform { sanitized: Value },
}
```

> **`MemoryWriteRequest`** — RESOLVED. Defined inline above; variants match BC-2.15.005 PC1 (Add/Replace/Remove). (gate #31 RESOLVED)
>
> **`WriteGuardDecision`** — RESOLVED. Defined inline above; variants match BC-2.15.005 PC2–PC4 (Allow/Deny/Transform). (gate #31 RESOLVED)
>
> **`Value`** — EXTERNAL. `serde_json::Value` — Rust standard JSON value type. (gate #31 EXTERNAL)

**BC anchor:** BC-2.15.005 PC1–PC5 (guard validation contract, E-MEMORY-007 on Deny, Transform semantics)

### MemoryStore

The foundational long-horizon key-value and vector memory store. Provides cross-thread,
cross-session durability independent of the checkpoint lifecycle (BC-2.15.001 Invariant).
**Six-method surface:** `memory_set`, `memory_get`, `memory_delete`, `memory_search`,
`vector_search`, `hybrid_search` (BC-2.15.001 PC1–PC7). Scope isolation is enforced at
the storage layer, not the application layer (BC-2.15.002 PC6).

```rust
/// Long-horizon KV and vector memory store, decoupled from the checkpoint lifecycle.
/// Entries persist across threads and process restarts (SQLite backend — BC-2.15.001 PC2).
/// An ephemeral in-memory backend is also provided for tests (BC-2.15.001 Invariant).
///
/// Authority: BC-2.15.001 (6-method surface + cross-thread durability),
///            BC-2.15.002 (MemoryScope tier isolation; scope parameter on every method),
///            BC-2.15.003 (GDPR erasure — admin-only standalone fn; NOT a trait method).
/// Module: pregolya-memory (memory::store).
#[async_trait]
pub trait MemoryStore: Send + Sync {
    /// Write a key-value entry to the store under `scope` and `key`.
    ///
    /// The entry is readable from any thread via `memory_get` with the same scope
    /// (BC-2.15.001 PC1–PC2). Concurrent writes to the same `(scope, key)` use
    /// last-writer-wins (LWW) semantics (BC-2.15.001 Invariant).
    /// Raises E-MEMORY-002 StorageFull if the backing store reaches capacity
    /// (BC-2.15.001 EC-004).
    /// Raises E-MEMORY-003 ScopeAccessDenied when identity enforcement is active
    /// (opt-in at the server layer — BC-2.15.002 Invariant) and the caller-supplied
    /// scope mismatches the verified caller identity:
    /// `Err(E-MEMORY-003 ScopeAccessDenied { requested_scope, caller_identity })`
    /// (BC-2.15.002 Invariant).
    async fn memory_set(
        &self,
        scope: MemoryScope,
        key: &str,
        value: Value,
    ) -> Result<(), PregolyaError>;

    /// Read a single entry by `(scope, key)`.
    ///
    /// Returns `Ok(None)` if the key was never written, was explicitly deleted via
    /// `memory_delete` (BC-2.15.001 PC3), or was written under a different owner's
    /// scope (isolation-by-invisibility: cross-owner reads return `Ok(None)`, not an
    /// error — BC-2.15.002 PC1/TV-001). Scope isolation enforced at the storage layer
    /// (`WHERE scope_key = ?` predicate — BC-2.15.002 PC6): entries from other scopes
    /// are silently invisible, never returned.
    /// Raises E-MEMORY-004 NoScopeContext when no session context is derivable from the
    /// call context and the caller omitted an explicit scope (BC-2.15.002 EC-001).
    async fn memory_get(
        &self,
        scope: MemoryScope,
        key: &str,
    ) -> Result<Option<Value>, PregolyaError>;

    /// Delete an entry by `(scope, key)`.
    ///
    /// After deletion, `memory_get` for the same `(scope, key)` returns `Ok(None)`
    /// (BC-2.15.001 PC3). Idempotent: deleting a non-existent key returns `Ok(())`.
    async fn memory_delete(
        &self,
        scope: MemoryScope,
        key: &str,
    ) -> Result<(), PregolyaError>;

    /// Full-text keyword search over entries in `scope`.
    ///
    /// Returns all entries whose stored value contains `query` as a case-insensitive
    /// substring (BC-2.15.001 PC4). Results are ordered by recency (most recently
    /// written first) by default. Search is strictly scoped: app-scoped entries are
    /// not returned by a user-scope search (BC-2.15.002 EC-003).
    async fn memory_search(
        &self,
        scope: MemoryScope,
        query: &str,
    ) -> Result<Vec<MemoryEntry>, PregolyaError>;

    /// Vector similarity search over entries in `scope` that have stored embeddings.
    ///
    /// Returns the top-`top_k` entries ranked by cosine similarity between the stored
    /// embedding and `query_embedding` (BC-2.15.001 PC5). Entries without a stored
    /// embedding are excluded from results (BC-2.15.001 PC6).
    /// Raises E-MEMORY-001 EmbeddingBackendNotConfigured if no embedding backend is
    /// configured (BC-2.15.001 EC-001).
    async fn vector_search(
        &self,
        scope: MemoryScope,
        query_embedding: Vec<f32>,
        top_k: usize,
    ) -> Result<Vec<MemoryEntry>, PregolyaError>;

    /// Hybrid search: union of keyword and vector similarity results.
    ///
    /// De-duplicates by key (higher-ranked copy retained); returns up to `top_k`
    /// results (BC-2.15.001 PC7). Degrades gracefully to keyword-only when no
    /// embedding backend is configured: the vector component is silently skipped
    /// with a DEBUG log; no error is raised (BC-2.15.001 EC-005).
    async fn hybrid_search(
        &self,
        scope: MemoryScope,
        query: &str,
        top_k: usize,
    ) -> Result<Vec<MemoryEntry>, PregolyaError>;
}

/// Memory scope tier for isolation enforcement (BC-2.15.002).
///
/// Scope flows from the trait method parameter directly to the SQL `WHERE scope_key = ?`
/// predicate — never collapsed or merged (NE-12 tenancy partition analog;
/// BC-2.15.002 Invariant / PC6).
pub enum MemoryScope {
    /// Private to the named user across all of that user's sessions (BC-2.15.002 PC1).
    User(String),
    /// Shared across all callers within the same application deployment
    /// (BC-2.15.002 PC3/PC5).
    App(String),
    /// Private to the named session; eligible for cleanup via `memory_delete_session`
    /// (BC-2.15.002 PC2 / Invariant — standalone store fn, not a trait method).
    Session(String),
}

/// An entry returned by search operations (`memory_search`, `vector_search`,
/// `hybrid_search`).
///
/// Authority: BC-2.15.001 PC4–PC7 (search return payload),
///            BC-2.15.003 §Invariants (author_id required for GDPR erasure of
///            app-scoped entries attributed to a specific user).
pub struct MemoryEntry {
    /// The scope under which this entry was written (BC-2.15.002 tier model).
    pub scope: MemoryScope,
    /// The storage key.
    pub key: String,
    /// The stored value (`serde_json::Value`).
    pub value: Value,
    /// Author identity, required for GDPR erasure of app-scoped entries
    /// (BC-2.15.003 §Invariants: author_id tracking). `None` for entries
    /// lacking attribution or for non-app-scoped entries.
    pub author_id: Option<String>,
}
```

> **`MemoryScope`** — RESOLVED. Defined inline above; variants match BC-2.15.002 scope definitions: `User(user_id)`, `App(app_id)`, `Session(session_id)` (BC-2.15.002 Preconditions). (gate #31 RESOLVED)
>
> **`MemoryEntry`** — RESOLVED. Defined inline above; fields satisfy BC-2.15.001 PC4–PC7 search return requirements and BC-2.15.003 `author_id` tracking obligation. (gate #31 RESOLVED)
>
> **`query_embedding: Vec<f32>`** — RESOLVED. Standard float-32 embedding vector; dimensionality determined by the configured embedding backend. (gate #31 RESOLVED)

**BC anchor:** BC-2.15.001 PC1–PC7 (6-method surface — every method traces to a BC PC: `memory_set`=PC1, `memory_get`=PC3, `memory_delete`=PC3, `memory_search`=PC4, `vector_search`=PC5–PC6, `hybrid_search`=PC7) + BC-2.15.002 PC1–PC6 + INV (MemoryScope tier isolation; storage-layer enforcement; opt-in identity enforcement) + E-MEMORY-001 (`vector_search`; BC-2.15.001 EC-001) + E-MEMORY-002 (`memory_set`; BC-2.15.001 EC-004) + E-MEMORY-003 (`memory_set`; BC-2.15.002 Invariant) + E-MEMORY-004 (`memory_get`; BC-2.15.002 EC-001)

### StreamEvent

The complete streaming event taxonomy emitted by `pregolya-graph` during a run and
serialized to SSE by `pregolya-server`. **16 variants** (11 execution lifecycle + 1
guardrail observability + 2 per-tool-call approval [D23/ADR-018] + 1 compaction
[D23/ADR-019] + 1 error [F-P177-B01/ADR-023]). All variants carry `run_id` and
`parent_ids` (BC-2.06.002).

```rust
/// Streaming events emitted during graph execution.
/// All variants carry `run_id` (stable per-run UUID) and `parent_ids` (ancestry chain)
/// for event correlation (BC-2.06.002).
///
/// Wire format: JSON with `#[serde(tag = "event", rename_all = "snake_case")]`.
/// Example: `{"event": "guardrail_decision", "run_id": "...", ...}`.
///
/// Authority: BC-2.06.001 (variant enumeration + causal ordering), ADR-006 rev-3.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "event", rename_all = "snake_case")]
pub enum StreamEvent {
    // Run lifecycle — wire: run_start | run_stream | run_end
    RunStart   { run_id: RunId, parent_ids: Vec<RunId>, data: RunStartData },
    RunStream  { run_id: RunId, parent_ids: Vec<RunId>, data: ChunkData },
    RunEnd     { run_id: RunId, parent_ids: Vec<RunId>, data: RunEndData },
    // Super-step lifecycle — wire: step_start | step_end
    StepStart  { run_id: RunId, parent_ids: Vec<RunId>, step: u32 },
    StepEnd    { run_id: RunId, parent_ids: Vec<RunId>, step: u32 },
    // Node lifecycle — wire: node_start | node_stream | node_end
    NodeStart  { run_id: RunId, parent_ids: Vec<RunId>, node: String, data: NodeData },
    NodeStream { run_id: RunId, parent_ids: Vec<RunId>, node: String, data: ChunkData },
    NodeEnd    { run_id: RunId, parent_ids: Vec<RunId>, node: String, data: NodeData },
    // Tool lifecycle — wire: tool_start | tool_stream | tool_end
    // ToolEnd content semantics: `data` carries POST-guardrail content —
    // the content the model context receives, not the raw tool output.
    // Raw rejected payloads are absent from ToolEnd and all StreamEvents
    // (BC-2.11.005 INV-5 — zero bytes of rejected content in any stream payload).
    ToolStart  { run_id: RunId, parent_ids: Vec<RunId>, tool: String, data: ToolData },
    ToolStream { run_id: RunId, parent_ids: Vec<RunId>, tool: String, data: ChunkData },
    ToolEnd    { run_id: RunId, parent_ids: Vec<RunId>, tool: String, data: ToolData },
    // Guardrail observability — wire: guardrail_decision  (F-P99-01, 2026-07-17)
    // Emitted ONLY for Fail and Transform outcomes; Pass is never streamed.
    // Stream-observer notification only: NOT emitted in unary mode.
    // Underlying GuardrailHook::evaluate fires on both streaming and unary paths
    // per DI-012 — absence from unary output is not a DI-011 violation (BC-2.06.003).
    GuardrailDecision {
        run_id:       RunId,
        parent_ids:   Vec<RunId>,
        /// The ingress boundary at which this decision was made.
        boundary:     IngressBoundary,
        /// Fail or Transform. Pass decisions are not streamed.
        decision:     GuardrailDecisionKind,
        /// Rejection reason — Some for Fail; None for Transform.
        reason:       Option<String>,
        /// Rejection severity — Some for Fail; None for Transform.
        severity:     Option<GuardrailSeverityWire>,
        /// Correlates to the audit log entry (BC-2.11.005 PC3 `ingress_id`).
        ingress_id:   Uuid,
        /// Correlates to the enclosing ToolStart/ToolEnd; None for RagChunk/MemoryItem.
        tool_call_id: Option<String>,
    },
    // Per-tool-call approval request — wire: tool_approval_request  (D23/2026-07-22, ADR-018)
    // Emitted BEFORE interrupt() when pre_tool_dispatch hook returns PendingHumanApproval.
    // Fires inside the NodeStart/NodeEnd window, BEFORE any ToolStart for this tool call.
    // The run transitions to `interrupted` immediately after this event.
    // Causal ordering authority: BC-2.06.004.
    ToolApprovalRequest {
        run_id:      RunId,
        parent_ids:  Vec<RunId>,
        tool_name:   String,
        /// Serialized tool arguments as JSON.
        tool_args:   serde_json::Value,
        /// Risk tier declared via `action_risk` attribute on the tool; None if omitted.
        action_risk: Option<ActionRisk>,
        /// Human-readable approval request prompt for the approver; None when the hook
        /// does not supply a prompt (downstream consumer displays a default message).
        prompt:      Option<String>,
    },
    // Per-tool-call approval resolved — wire: tool_approval_resolved  (D23/2026-07-22, ADR-018)
    // Emitted AFTER interrupt is consumed by Command(resume=PreToolDecision),
    // BEFORE the approval decision is applied. Fires on run resume; correlates to
    // the preceding ToolApprovalRequest by tool_name.
    // Causal ordering authority: BC-2.06.005.
    ToolApprovalResolved {
        run_id:        RunId,
        parent_ids:    Vec<RunId>,
        tool_name:     String,
        /// The resolution: Approve | Edit(modified_args) | Deny.
        decision:      PreToolDecision,
        /// Optional rationale from the human approver.
        reason:        Option<String>,
        /// Modified tool arguments when decision is Edit; None for Approve/Deny.
        modified_args: Option<serde_json::Value>,
    },
    // Rolling compaction lifecycle event — wire: compaction_event  (D23/2026-07-22, ADR-019)
    // Emitted at step 6 of the 7-step compaction cycle (BC-2.10.006), AFTER the
    // compacted checkpoint is durably written. Fires between super-steps: after StepEnd
    // and before the next StepStart.
    // Causal ordering authority: BC-2.06.006.
    CompactionEvent {
        run_id:                 RunId,
        parent_ids:             Vec<RunId>,
        /// Which trigger condition fired (OnWatermark / OnMessageCount / OnTokenCount).
        trigger:                CompactionTrigger,
        /// First turn index replaced by the summary (inclusive start of compacted range).
        compacted_start:        usize,
        /// Last turn index replaced by the summary (inclusive end of compacted range).
        compacted_end:          usize,
        /// Token count of the generated summary text.
        summary_token_count:    u64,
        /// Tokens remaining in the budget window after compaction.
        /// Source: RunContext.budget_info.tokens_remaining: Option<i64>.
        /// None when no token ceiling is configured; negative i64 when accumulated > ceiling.
        tokens_remaining_after: Option<i64>,
    },
    // Run error event — wire: error  (F-P177-B01/ADR-023, burst-288; 16th variant)
    // Emitted when a node returns Err(PregolyaError) during execution.
    // Stream closes after this event; RunEnd is NOT emitted (BC-2.06.001 EC-005).
    // ADR-023 §Exempt Enums — StreamEvent is exhaustively matched by consumers;
    // this is the final variant in the taxonomy.
    // Causal ordering: replaces RunEnd on the failure path (no further events after Error).
    Error {
        run_id:        RunId,
        parent_ids:    Vec<RunId>,
        /// Error code from PregolyaError::code (e.g. "E-GRAPH-017").
        error_code:    String,
        /// Error message from PregolyaError::message.
        error_message: String,
    },
}

/// Causal ordering (BC-2.06.001 PC4 — updated D23/2026-07-22):
///
/// RunStart
///   → (StepStart
///       → (NodeStart
///           → GuardrailDecision[RagChunk|MemoryItem]*    // RAG/Memory: within Node window
///           → (ToolApprovalRequest                        // On PendingHumanApproval (0 or 1 per tool call)
///               → [run transitions to interrupted]
///               → [external Command(resume=PreToolDecision)]
///               → ToolApprovalResolved                    // On resume; BEFORE decision applied
///             )?
///           → (ToolStart                                  // Only if Approve or Edit decision
///               → GuardrailDecision[ToolResult]*          // ToolResult: before ToolEnd
///               → ToolEnd                                 // Always last in its window
///             )*
///           → NodeEnd
///         )*
///       → StepEnd
///       → CompactionEvent?                               // After StepEnd, before next StepStart (0 or 1)
///     )*
/// → RunEnd
///
/// GuardrailDecision* = 0..N — one per non-Pass ContentBlock/chunk/item.
/// A tool invocation producing N ContentBlocks with K failures emits K GuardrailDecision
/// events before one ToolEnd.
/// ToolApprovalRequest/Resolved: 0 or 1 per tool call attempt (only on PendingHumanApproval path).
/// CompactionEvent: 0 or 1 per super-step boundary (fires when compaction trigger threshold met).

/// The ingress boundary at which a GuardrailDecision was produced.
/// Maps to IngressContent variants in GuardrailHook (§GuardrailHook above).
/// Also the type of `GuardrailEntry.boundary` (checkpoint-backed journal ops).
/// BC authority: BC-2.11.001–BC-2.11.004 (three boundary types).
#[non_exhaustive]
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum IngressBoundary { ToolResult, RagChunk, MemoryItem }

/// The non-trivial outcome streamed to observers. Pass is never streamed.
/// BC authority: BC-2.11.002 PC3 (Fail), BC-2.11.002 PC4 (Transform).
pub enum GuardrailDecisionKind { Fail, Transform }

/// Wire-serializable severity mirroring GuardrailSeverity for stream consumers.
/// BC authority: BC-2.11.002 INV-3, BC-2.11.005 PC4/PC5.
pub enum GuardrailSeverityWire { Critical, High, Medium, Low }
```

**BC anchor:**
BC-2.06.001 PC2 (variant enumeration + ToolEnd output semantics — updated D23 15 variants; updated F-P177-B01/ADR-023 16 variants),
BC-2.06.001 PC4 (causal ordering — updated D23/2026-07-22),
BC-2.06.002 (run_id + parent_ids on every variant),
BC-2.06.003 (streaming/unary execution equivalence; GuardrailDecision stream-only notification),
BC-2.06.004 (ToolApprovalRequest — event 13; emitted before interrupt on PendingHumanApproval),
BC-2.06.005 (ToolApprovalResolved — event 14; emitted on Command(resume=…) delivery),
BC-2.06.006 (CompactionEvent — event 15; emitted after compacted checkpoint durably written),
BC-2.11.002 PC3/PC4 (GuardrailDecision emitted on Fail/Transform for ToolResult boundary), BC-2.11.003 PC3/PC4 (GuardrailDecision emitted on Fail/Transform for RagChunk boundary), BC-2.11.004 PC3/PC4 (GuardrailDecision emitted on Fail/Transform for MemoryItem boundary),
BC-2.11.005 PC1/INV (ToolEnd post-guardrail content; zero rejected bytes in any StreamEvent),
ADR-006 rev-3 (guardrail design authority), ADR-018 (per-tool-call approval hook design authority), ADR-019 (rolling compaction design authority).

### PreToolCallHook

**Source:** ADR-020 Decision 1 (ActionRisk relocation to pregolya-core: core::action_risk — defines ToolCallPreview.action_risk type placement; pregolya-tools as cross-crate compile-time ActionRisk consumer motivates dependency-inversion pattern; sole authority for the ActionRisk element of the trait signature); ADR-018 Decision 2 (trait shape) + Decision 3 (dispatch ordering; step 4 = fail-closed Deny — tool is NEVER invoked on Deny; VP-011 Kani P0) + Decision 5 (streaming events) + Decision 6 (action_risk attribute — ADR-008 Decision 2); pregolya-core: core::action_risk (ActionRisk enum — F-P170-06 adjudication: relocated from graph::hitl); pregolya-graph: graph::hitl (PreToolCallHook trait + ToolCallPreview + PreToolDecision — re-exports ActionRisk from pregolya-core).

BC anchor: BC-2.05.007 (PreToolCallHook trait — pre_invoke contract; ToolCallPreview shape; PreToolDecision variants Approve/Deny/Edit/PendingHumanApproval; AlwaysApprovePolicy default; fail-closed Deny; hook failure = Deny; VP-011 Kani P0 seed), BC-2.05.004 (Command(resume=PreToolDecision) resume-API: delivers PreToolDecision to engine when PendingHumanApproval interrupt is resolved), BC-2.06.004 (ToolApprovalRequest event), BC-2.06.005 (ToolApprovalResolved event), BC-2.08.010 PC1 (action_risk() method on Tool), BC-2.16.001 Invariant (retry-approval dispatch ordering).

```rust
// pregolya-core: core::action_risk
// NOTE: ActionRisk relocated from pregolya-graph::hitl to pregolya-core per F-P170-06
// adjudication (BudgetPolicy/ADR-009, GuardrailHook+BoundaryType/ADR-014, MemoryWriteGuard/ADR-012
// type-in-core precedent). pregolya-graph::hitl re-exports ActionRisk for graph-layer consumers.

/// Risk tier declared by a tool via the `action_risk` attribute.
/// BashTool enforces a non-lowerable floor of `Medium`; `ReadOnly` and `Low` are
/// rejected at `ToolConfig::override_risk` call time (E-TOOLS-007 — the builder-consuming
/// validator returns Err immediately; the registry never receives an invalid ToolConfig).
/// BC anchor: BC-2.05.006 (risk-tiered HITL interrupt classification), BC-2.23.005 PC-3 (BashTool risk floor via ToolConfig::override_risk), BC-2.08.010 PC-1 (action_risk() method — ADR-008 Decision 2 emitted-path).
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
#[non_exhaustive]
pub enum ActionRisk { ReadOnly, Low, Medium, High }
```

```rust
// pregolya-graph: graph::hitl
// (ActionRisk is defined in pregolya-core (core::action_risk) and re-exported here)

/// The tool call preview presented to the hook before invocation.
/// BC anchor: BC-2.05.007 PC3 (ToolCallPreview constructed read-only before pre_invoke call; action_risk populated from #[tool(action_risk = ...)] annotation).
#[derive(Debug, Clone)]
#[non_exhaustive]
pub struct ToolCallPreview {
    pub tool_name:   String,
    pub tool_args:   serde_json::Value,
    /// Risk tier from the tool's `action_risk` attribute; None if omitted.
    pub action_risk: Option<ActionRisk>,
}

/// Decision returned by the PreToolCallHook.
/// BC anchor: BC-2.05.007 PC1-PC5 (four PreToolDecision branches; fail-closed Deny; hook error = Deny).
#[derive(Debug, Clone)]
#[non_exhaustive]
pub enum PreToolDecision {
    /// Proceed with original args. (BC-2.05.007 PC1)
    Approve,
    /// Abort the tool call; return ToolOutput::Error(reason) without invoking the tool.
    /// Fail-closed: the tool is NEVER invoked on Deny under any code path (VP-011 Kani P0).
    /// BC anchor: BC-2.05.007 PC2 (Deny path — fail-closed; reason surfaced in ToolOutput::Error).
    Deny { reason: String },
    /// Proceed with modified args (override tool_args with modified_args value).
    /// Engine validates modified_args is a JSON object; falls back to Deny if not.
    /// BC anchor: BC-2.05.007 PC3 (Edit path; invalid modified_args → Deny fallback).
    Edit { modified_args: serde_json::Value },
    /// Suspend the run (interrupt()) and await human approval via Command(resume=PreToolDecision).
    /// ToolApprovalRequest StreamEvent is emitted before interrupt().
    /// BC anchor: BC-2.05.007 PC4 (PendingHumanApproval — reuses BC-2.05.001 interrupt machinery).
    PendingHumanApproval { prompt: Option<String> },
}

/// Per-tool-call approval hook invoked before each tool.invoke().
/// If not configured (GraphConfig.pre_tool_hook = None), AlwaysApprovePolicy semantics apply.
/// Fail-closed: if the hook panics or returns an error, the engine treats the result as
/// Deny { reason: "hook error: <detail>" } — tool is NOT invoked (BC-2.05.007 PC5).
/// BC anchor: BC-2.05.007 PC1-PC6 (full dispatch contract: Approve/Deny/Edit/PendingHumanApproval/
/// hook-error/no-hook paths; fail-closed invariant; VP-011 Kani P0 seed).
#[async_trait]
pub trait PreToolCallHook: Send + Sync {
    /// Called after circuit_breaker.check() passes and before tool.invoke().
    /// Dispatch ordering: circuit_breaker.check → pre_invoke (this method) → tool.invoke → retry.record()
    /// (ADR-018 Decision 6; BC-2.16.001 Invariant "Retry-Approval Ordering").
    /// Note: `pre_tool_dispatch` is the free function in graph::hitl that calls this method —
    /// do not confuse the dispatcher function with the trait method name.
    async fn pre_invoke(
        &self,
        preview: &ToolCallPreview,
        run_ctx: &RunContext,
    ) -> PreToolDecision;
}
```

### Compaction

**Source:** ADR-019 Decision 1 (type definitions in core::budget — CompactionTrigger, ConversationSnapshot, CompactionSummary, CompactionPolicy trait; all four types) + Decision 2 (BudgetConfig extensions: compaction_trigger and compaction_policy fields) + Decision 3 (7-step execution sequence in graph::budget; mid-run state mutation — applies immediately to current run's message window, not next-run; contrast: BC-2.15.006 frozen-snapshot = next-run per ADR-019 Decision 3 canonical definition) + Decision 4 (streaming event compaction_event) + Decision 5 (CAP-017 Wave Promotion Interaction — within-session vs cross-session additive design); pregolya-core: core::budget (type definitions — Decision 1); pregolya-graph: graph::budget (BudgetEngine execution — Decision 3).

BC anchor: BC-2.10.005 (CompactionTrigger evaluation — VP-012 Kani candidate for OnWatermark arithmetic), BC-2.10.006 (compaction execution — 7-step cycle, ConversationSnapshot assembly, mid-run state mutation per ADR-019 Decision 3, EvidenceJournal, streaming event, checkpoint immutability), BC-2.06.006 (CompactionEvent StreamEvent), BC-2.15.006 (frozen-snapshot — NEXT-run context mutation per ADR-019 Decision 3, explicitly distinct from BC-2.10.006 CURRENT-run mid-run state mutation).

```rust
// pregolya-core: core::budget
// NOTE: CompactionTrigger, ConversationSnapshot, CompactionSummary, CompactionPolicy are
// definitions-only types in pregolya-core (core::budget) (ADR-019 Decision 1 / ADR-009 Option 3).
// The execution engine (BudgetEngine, EvidenceJournal dispatch) lives in pregolya-graph (graph::budget).
// If BudgetConfig gains fields of these types (it does — Decision 2), core→graph dep is avoided because
// the type definitions live in core::budget, not in graph::budget.

/// Configures when the BudgetEngine triggers a compaction cycle.
/// BC anchor: BC-2.10.005 PC1-PC3 (trigger evaluation), BC-2.10.006 PC1 (precondition).
#[derive(Debug, Clone, Serialize, Deserialize)]
#[non_exhaustive]
pub enum CompactionTrigger {
    /// Compaction is disabled (default).
    Disabled,
    /// Compact when tokens_used / hard_limit >= fraction.
    /// VP-012 Kani seed: arithmetic correctness of the fraction comparison.
    /// BC anchor: BC-2.10.005 PC2 (OnWatermark evaluation rule).
    OnWatermark { fraction: f64 },
    /// Compact when the active message-window message count reaches or exceeds `count`.
    /// BC anchor: BC-2.10.005 PC3.
    OnMessageCount { count: usize },
    /// Compact when the active message-window estimated token count reaches or exceeds `tokens`.
    /// BC anchor: BC-2.10.005 PC4.
    OnTokenCount { tokens: u64 },
}

/// Snapshot of recent conversation turns assembled from checkpoint FTS (BC-2.04.008).
/// BC anchor: BC-2.10.006 Step 1 (snapshot assembly from `CheckpointSaver::fts_search` call).
#[derive(Debug, Clone)]
pub struct ConversationSnapshot {
    pub turns:           Vec<(usize, Message)>,
    pub token_estimate:  u64,
}

/// Summary produced by a CompactionPolicy.
/// BC anchor: BC-2.10.006 Step 2 (compact() return value).
#[derive(Debug, Clone)]
pub struct CompactionSummary {
    pub summary_text:    String,
    /// Inclusive range of turn indices to replace with the summary.
    pub compacted_start: usize,
    pub compacted_end:   usize,
}

/// Pluggable compaction strategy.
/// Default: DefaultSummarizationPolicy (calls the configured LLM).
/// BC anchor: BC-2.10.006 Step 2 (compact() contract — abort-on-Err, non-fatal).
#[async_trait]
pub trait CompactionPolicy: Send + Sync {
    /// Summarize the given snapshot. Return Err to abort the compaction cycle (non-fatal;
    /// run continues with pre-compaction window — BC-2.10.006 EC-001).
    async fn compact(
        &self,
        snapshot: &ConversationSnapshot,
        run_ctx:  &RunContext,
    ) -> Result<CompactionSummary, PregolyaError>;
}
```

### Tool

**Source:** ADR-020 Decision 1 dependency graph: `pregolya-core (Tool trait, ToolOutput, PregolyaError, ActionRisk)` — the `Tool` trait and `ToolOutput` enum are defined in `pregolya-core`, NOT in `pregolya-tools`. `pregolya-tools` depends on `pregolya-core` for this trait. BC-2.08.010 PC1 specifies the generated method set; BC-2.23.001–BC-2.23.006 are the first-party implementations.

**BC anchor:** BC-2.08.010 PC1 (method set: name/description/schema/action_risk/invoke); BC-2.23.001–BC-2.23.006 (first-party `Tool` implementations); BC-2.05.007 PC2 (`ToolOutput::Error` on Deny).

```rust
// pregolya-core: core::tool  (Tool trait, ToolOutput enum, ToolInput struct)

/// Framework contract every tool must satisfy.
/// Implemented via `#[pregolya::tool]` proc-macro (BC-2.08.010) or manually.
///
/// BC anchor: BC-2.08.010 PC1 (generated method set); BC-2.23.001–BC-2.23.006 (first-party impls).
pub trait Tool: Runnable<ToolInput, ToolOutput> + Send + Sync {
    /// Machine-readable tool name used in ToolCall serialization (stable public API surface per BC-2.08.009).
    fn name(&self) -> &str;

    /// Human-readable description surfaced to the model in tool listings.
    fn description(&self) -> &str;

    /// JSON Schema for the tool's argument struct.
    /// Source depends on how the tool was constructed: (a) `#[pregolya::tool]` macro-generated
    /// tools derive the schema via `schemars::schema_for!` at macro expansion time;
    /// (b) MCP-adapted tools (via `convert_mcp_tool`) carry the verbatim `schemars::Schema`
    /// wrapping the server-supplied `inputSchema` — no re-derivation; (c) `GraphAgentTool`
    /// instances carry the caller-supplied `input_schema: schemars::Schema` passed to
    /// `GraphAgentTool::from_graph`.
    /// BC anchor: BC-2.08.010 PC1 + BC-2.08.009 (schema naming stability snapshot obligation).
    fn schema(&self) -> schemars::Schema;

    /// Declared risk tier for HITL approval-hook integration; `None` if `action_risk` not annotated.
    /// When present, emitted as `::pregolya_core::action_risk::ActionRisk::<Variant>`
    /// (ADR-008 Decision 2 emitted-path contract — fully-qualified path in proc-macro expansion).
    /// BC anchor: BC-2.08.010 PC1 (action_risk attribute); BC-2.05.007 (ToolCallPreview.action_risk).
    fn action_risk(&self) -> Option<ActionRisk>;
}

/// Serialized JSON tool invocation arguments; proc-macro deserializes into the generated args struct.
/// BC anchor: BC-2.08.010 PC1 (Runnable<ToolInput, ToolOutput>).
pub struct ToolInput(pub serde_json::Value);

/// Tool execution result; returned from `Tool::invoke` (via Runnable).
/// BC anchor: BC-2.23.001–BC-2.23.006 (variant usage per first-party tool); BC-2.05.007 PC2 (Error on Deny).
/// `#[derive(Serialize)]` is required so the blanket `DynTool` impl can convert `ToolOutput`
/// to `serde_json::Value`. `ToolOutput::Error(String)` maps to `Err(PregolyaError)` in
/// the blanket impl — never `Ok(json)` — to prevent silent-error-swallow per DI-014.
#[non_exhaustive]
#[derive(Serialize)]
pub enum ToolOutput {
    /// Free-form text output (ReadFileTool, WriteFileTool, EditFileTool — BC-2.23.001/002/003).
    Text(String),
    /// Structured JSON output (BashTool, ListDirTool, GrepTool — BC-2.23.004/005/006).
    Json(serde_json::Value),
    /// Error string; surfaced when a tool call is denied by PreToolCallHook or fails internally.
    /// BC anchor: BC-2.05.007 PC2 (Deny { reason } → ToolOutput::Error; tool is NEVER invoked on Deny).
    Error(String),
}

/// Object-safe façade for heterogeneous tool dispatch.
/// Mirrors DynRunnable: `Arc<dyn DynTool>` is the concrete composition seam
/// wherever `Arc<dyn Tool>` was specified — `dyn Tool` is non-object-safe (E0038); migrated per ADR-005 §Adjacent Adjudications Wave C PO routing.
///
/// `Tool: Runnable<ToolInput, ToolOutput>` inherits `Runnable::stream()` (RPITIT
/// `impl Future` return — opaque, non-dyn-compatible) which makes `dyn Tool`
/// non-trivially non-object-safe (E0038).
/// `DynTool` exposes only the object-safe subset: `invoke_dyn` (async, no opaque returns),
/// plus the four metadata accessors.
///
/// A blanket impl auto-implements `DynTool` for every `T: Tool + Send + Sync + 'static`.
/// Callers perform JSON round-tripping at the `Arc<dyn DynTool>` boundary.
///
/// BC anchor: ADR-005 §Adjacent Trait Object-Safety Adjudications (Tool adjudication —
/// option b). Wave C PO routing: BC-2.09.001 Description+PC2 and BC-2.09.002 PC1 migrate
/// `Arc<dyn pregolya_core::Tool>` (non-object-safe E0038) → `Arc<dyn DynTool>`.
/// **Module:** `pregolya-core: core::tool` (alongside `Tool`).
#[async_trait]
pub trait DynTool: Send + Sync {
    /// Machine-readable tool name (stable public API surface per BC-2.08.009).
    fn name(&self) -> &str;

    /// Human-readable description surfaced to the model in tool listings.
    fn description(&self) -> &str;

    /// JSON Schema for the tool's argument struct.
    /// Source depends on how the underlying `Tool` was constructed: (a) `#[pregolya::tool]`
    /// macro-generated tools derive the schema via `schemars::schema_for!`; (b) MCP-adapted
    /// tools (via `convert_mcp_tool`) carry the verbatim `schemars::Schema` wrapping the
    /// server-supplied `inputSchema` — no re-derivation; (c) `GraphAgentTool` instances carry
    /// the caller-supplied `input_schema: schemars::Schema` passed to `from_graph`.
    /// BC anchor: BC-2.08.010 PC1 + BC-2.08.009 (schema naming stability snapshot obligation).
    fn schema(&self) -> schemars::Schema;

    /// Declared risk tier for HITL approval-hook integration; `None` if `action_risk` not annotated.
    /// BC anchor: BC-2.08.010 PC1 (action_risk attribute); BC-2.05.007 (ToolCallPreview.action_risk).
    fn action_risk(&self) -> Option<ActionRisk>;

    /// Object-safe invocation path; input/output are JSON Values (no opaque `impl Stream` return).
    /// Callers are responsible for JSON round-tripping at the `Arc<dyn DynTool>` boundary.
    async fn invoke_dyn(
        &self,
        input: serde_json::Value,
    ) -> Result<serde_json::Value, PregolyaError>;
}

// Blanket impl: any T: Tool + Send + Sync + 'static auto-implements DynTool.
// invoke_dyn maps ToolOutput variants: Text/Json → Ok(serde_json::Value);
// Error(String) → Err(PregolyaError::new(Component::Tools, Category::Tool,
//   RetryHint::Maybe, error_code, msg)) — never Ok(json) (DI-014 no-silent-empty).
// impl<T: Tool + Send + Sync + 'static> DynTool for T { ... }
```

### First-Party Tools

**Source:** ADR-020 (pregolya-tools crate); pregolya-tools crate. All file-access tools (ReadFileTool, WriteFileTool, EditFileTool, ListDirTool, GrepTool) use `PathGuard` for workspace confinement (E-TOOLS-001 on escape); BashTool is confined via the pregolya-sandbox backend (BC-2.23.005). All tools implement the `Tool` trait via `#[pregolya::tool]` proc-macro.

BC anchor: BC-2.23.001 (ReadFileTool — consumes BC-2.13.004 PathGuard), BC-2.23.002 (WriteFileTool — consumes BC-2.13.004 PathGuard), BC-2.23.003 (EditFileTool — consumes BC-2.13.004 PathGuard), BC-2.23.004 (ListDirTool — consumes BC-2.13.004 PathGuard), BC-2.23.005 (BashTool — ActionRisk::High default annotation; non-lowerable Medium floor via ToolConfig::override_risk; EC-005 timeout; EC-006 output truncation), BC-2.23.006 (GrepTool — match cap, E-TOOLS-006 capped flag; consumes BC-2.13.004 PathGuard), PathGuard ownership: BC-2.13.004 (pregolya-sandbox SS-13 VP-003 Kani P0), ToolConfig (BC-2.23.005 PC-3, BC-2.08.010 PC-1).

```rust
// pregolya-tools crate

// PathGuard is OWNED BY pregolya-sandbox (sandbox::path_guard, SS-13, BC-2.13.004,
// VP-003 Kani P0). It is NOT declared or owned by pregolya-tools.
//
// pregolya-tools CONSUMES PathGuard via the ADR-020 Decision 1 dependency edge
// (pregolya-tools → pregolya-sandbox). The five file-access tools call
// canonicalize_beneath_root on every path argument at access time (NE-02 invariant).
//
// Confinement entry points (pregolya-sandbox API surface):
//   /// Pure inner function: no I/O; takes already-resolved base + candidate path.
//   pub fn canonicalize_beneath_root_pure(base: &Path, path: &Path)
//       -> Result<PathBuf, PregolyaError>;
//   /// I/O-performing outer function: calls std::fs::canonicalize before delegating.
//   pub fn canonicalize_beneath_root(base: &Path, path: &Path)
//       -> Result<PathBuf, PregolyaError>;
//
// Error layer split:
//   - Escape detected inside pregolya-sandbox → Err(E-SBXD-001 WorkspaceEscape)
//   - pregolya-tools wraps/surfaces escape as Err(E-TOOLS-001 PathConfinementViolation)
//
// BC anchor (owner): BC-2.13.004 (PathGuard invariant, VP-003 Kani P0, SS-13)
// BC anchor (consumer, these tools): BC-2.23.001–005 share the confinement pre-condition

// pregolya-tools: tools::config (Gate #32 carrier-3 — crate placement: ADR-020 Decision 3)

/// Shared per-tool framework configuration.
/// DISTINCT from per-tool implementation config (e.g., `BashConfig` holds
/// `max_output_bytes`/`max_duration` for BashTool only).
/// `ToolConfig` is the framework-level config that applies to all first-party tools:
/// risk-tier override and future cross-cutting framework settings.
///
/// The private `minimum_risk: ActionRisk` field is set at tool construction time
/// and serves as the per-tool identity discriminator for `override_risk` validation.
/// Example: `BashTool` sets `minimum_risk = ActionRisk::Medium` (non-lowerable floor
/// per BC-2.23.005 PC-3); file-access tools set `minimum_risk = ActionRisk::ReadOnly`
/// (any tier accepted). This field is what makes VP-013 provable by Kani: for BashTool,
/// exhaustive case analysis over all 4 `ActionRisk` variants (D-25) shows that
/// `ReadOnly` and `Low` always satisfy `risk < minimum_risk` → `Err`.
///
/// BC anchor: BC-2.23.005 PC-3 (BashTool risk floor via override_risk),
/// BC-2.08.010 PC-1 (action_risk attribute emits fully-qualified ActionRisk path).
#[derive(Debug, Clone)]
#[non_exhaustive]
pub struct ToolConfig {
    // minimum_risk: ActionRisk  — private; set at tool construction; discriminates per-tool floor
    // (other framework-internal fields reserved under #[non_exhaustive])
}

impl ToolConfig {
    /// Builder-consuming validator for overriding the tool's declared risk tier.
    ///
    /// Takes `self` by value — validation occurs immediately at call time (D-27).
    /// The caller receives `Err` directly from this method; the registry only ever
    /// receives a successfully-built `ToolConfig` (it never performs risk validation itself).
    ///
    /// Validates `risk >= self.minimum_risk`. The `minimum_risk` field is set per tool:
    /// - `BashTool`: `minimum_risk = ActionRisk::Medium` — `ReadOnly` and `Low` are rejected.
    /// - File-access tools: `minimum_risk = ActionRisk::ReadOnly` — any tier accepted.
    ///
    /// # Errors
    /// `Err(E-TOOLS-007 BashRiskTierViolation)` when `risk < self.minimum_risk`
    /// (e.g., `ActionRisk::ReadOnly` or `ActionRisk::Low` on a BashTool where minimum is `Medium`).
    /// VP-013 (Kani P1 seed — D-30: tools::config is NOT gate-exempt): exhaustive proof that for
    /// any `ToolConfig` constructed by `BashTool`, all `ActionRisk` variants satisfying
    /// `risk < ActionRisk::Medium` produce `Err` with no reachable `Ok` code path.
    /// D-25 (4 variants only: ReadOnly/Low/Medium/High, #[non_exhaustive]) is the variant bound.
    /// D-26 signature preserved: `override_risk(self, risk: ActionRisk) -> Result<ToolConfig, PregolyaError>`.
    ///
    /// BC anchor: BC-2.23.005 PC-3 (risk floor check); VP-013 (Kani P1 seed: exhaustive proof).
    pub fn override_risk(self, risk: ActionRisk) -> Result<ToolConfig, PregolyaError>;
}

// ReadFileTool — BC-2.23.001
// Errors: E-TOOLS-001 (path confinement), E-TOOLS-002 (file exceeds max_bytes limit).
// #[pregolya::tool(name = "read_file", description = "...")]

// WriteFileTool — BC-2.23.002
// Errors: E-TOOLS-001 (path confinement). Creates parent dirs; overwrites atomically.
// #[pregolya::tool(name = "write_file", description = "...")]

// EditFileTool — BC-2.23.003
// Errors: E-TOOLS-001 (path confinement), E-TOOLS-003 (old_string not found).
// Performs exact-string replacement; requires unique match (fails on 0 or >1 matches).
// #[pregolya::tool(name = "edit_file", description = "...")]

// ListDirTool — BC-2.23.004
// Errors: E-TOOLS-001 (path confinement), E-TOOLS-008 (not a directory, permission denied). Returns directory entries (depth 1) as JSON array of DirEntry objects.
// #[pregolya::tool(name = "list_dir", description = "...")]

/// BashTool — BC-2.23.005.
/// action_risk default annotation: ActionRisk::High (declared via #[pregolya::tool(action_risk = ActionRisk::High)]).
/// Non-lowerable floor: ActionRisk::Medium — ToolConfig::override_risk returns Err(E-TOOLS-007)
/// if risk < Medium is requested at override_risk call time (see ToolConfig above).
/// Timeout: configurable max_duration (default 30s); E-TOOLS-004 on exceed.
/// Output cap: stdout+stderr combined truncated to max_output_bytes; BashOutput.truncated = true (E-TOOLS-005 payload field).
// #[pregolya::tool(name = "bash", description = "...", action_risk = ActionRisk::High)]

/// GrepTool — BC-2.23.006.
/// Match cap: max_matches (default 100); GrepResult.capped = true when exceeded (E-TOOLS-006 payload field).
/// Errors: E-TOOLS-001 (path confinement).
// #[pregolya::tool(name = "grep", description = "...")]
```

### Retriever Trait and GuardedDocuments

**Source:** ADR-014 Decision 2 (trait shape) + Decision 6 (GuardedDocuments); pregolya-core: core::retriever, core::documents. (Note: core::guardrail provides types referenced by rag_ingress — GuardrailHook, IngressContent, ProvenanceTag — but GuardedDocuments itself is defined in core::retriever per ADR-014 Decision 6.)

```rust
// pregolya-core: core::retriever
#[async_trait]
pub trait Retriever: Send + Sync {
    /// Returns documents relevant to `query`, ranked by relevance (implementation-defined).
    /// BC anchor: BC-2.20.001 PC2 (success/failure semantics, Result, DI-008 no .unwrap()),
    /// BC-2.20.001 PC4 (#[non_exhaustive] Document shape)
    async fn get_relevant_documents(
        &self,
        query: &str,
    ) -> Result<Vec<Document>, PregolyaError>;
}

// pregolya-core: core::documents
/// Pure data carrier for all retrieval output. No methods, no I/O.
/// BC anchor: BC-2.20.001 PC3 (field semantics: page_content non-empty for content docs,
/// metadata MAY be empty, id: Option<String>), BC-2.20.001 INV-3 (no methods/I/O/async)
#[derive(Debug, Clone, Serialize, Deserialize, schemars::JsonSchema)]
#[non_exhaustive]
pub struct Document {
    /// The retrieved text content. Non-empty for content-bearing documents.
    pub page_content: String,
    /// Arbitrary key/value metadata. May be empty `{}`.
    pub metadata: serde_json::Map<String, serde_json::Value>,
    /// Optional stable ID assigned by the backend. None when backend assigns no stable IDs.
    pub id: Option<String>,
}

// pregolya-core: core::retriever
// (GuardedDocuments is in core::retriever — it references types from core::guardrail such as
// GuardrailHook, IngressContent, and ProvenanceTag, but the struct and rag_ingress constructor
// are defined in core::retriever per ADR-014 Decision 6.)
/// Newtype wrapper produced by `rag_ingress`; the sole type accepted by graph nodes that
/// consume retrieved documents. Passing `Vec<Document>` directly to a node that expects
/// `&GuardedDocuments` is a compile-time type error (VP-2.20.002-A compile_fail gate).
/// BC anchor: BC-2.20.002 VP-2.20.002-A (compile_fail gate — Vec<Document> not accepted),
/// BC-2.20.002 PC1 (no page_content use before guardrail clearance)
pub struct GuardedDocuments(Vec<Document>);

impl GuardedDocuments {
    /// Evaluate each document through the guardrail hook before returning.
    /// Async, per-document evaluation. Fail behavior is severity-bifurcated (ADR-014 Decision 6 §GuardedDocuments):
    /// - `GuardrailSeverity::Critical` Fail → returns `Err(E-CORE-008 GuardrailCriticalRejection)`;
    ///   entire batch is aborted; no `GuardedDocuments` produced (DI-014 fail-closed).
    /// - Non-Critical Fail (High/Medium/Low) → error-entry Document substituted at the rejected
    ///   position (`page_content: "[GUARDRAIL BLOCKED: <reason>]"`, `metadata.pregolya.guardrail_blocked: true`);
    ///   batch continues; `GuardedDocuments` produced with the substitution.
    /// BC anchor: BC-2.20.002 PC2 (severity-bifurcated Fail; Critical → Err(E-CORE-008); non-critical → substitution),
    /// BC-2.20.002 PC3 (guardrail fires BEFORE any doc content is used),
    /// BC-2.20.002 PC4 (documents failing guardrail never enter prompt under any condition)
    pub async fn rag_ingress(
        docs: Vec<Document>,
        guardrail: &dyn GuardrailHook,
    ) -> Result<GuardedDocuments, PregolyaError> { ... }

    /// Access the guardrail-cleared documents.
    pub fn documents(&self) -> &[Document] { &self.0 }
}
```

**BC anchor:**
BC-2.20.001 (Retriever trait — async dyn-compat, Document carrier, Arc\<dyn Retriever\> graph seam),
BC-2.20.002 (DI-012 RAGRetrieval guardrail coverage — GuardedDocuments typed wrapper enforces guardrail boundary at compile time; Red Gate test),
BC-2.20.003 (VectorStoreRetriever — SearchType/k/fetch_k/lambda_mult; as_retriever() → Retriever).
ADR-014 Decision 1 (crate placement: Retriever + Document in pregolya-core), Decision 2 (trait shape, Document struct), Decision 6 (GuardedDocuments typed wrapper, rag_ingress async per-document evaluation).

---

### VectorStore Trait and VectorStoreFactory

**Source:** ADR-014 Decision 2; pregolya-vectorstores: vectorstores::store.

```rust
// pregolya-vectorstores: vectorstores::store
#[async_trait]
pub trait VectorStore: Send + Sync {
    /// Add documents to the store. Returns assigned document IDs.
    /// BC anchor: BC-2.21.001 PC1 (add_documents semantics), BC-2.21.002 PC2 (InMemoryVectorStore
    /// acquires write lock, embeds via Arc<dyn Embeddings>, stores Vec<f32>)
    async fn add_documents(
        &self,
        docs: Vec<Document>,
    ) -> Result<Vec<String>, PregolyaError>;

    /// Return the top-k documents most similar to `query`.
    /// BC anchor: BC-2.21.001 PC2, BC-2.21.002 PC3/PC4 (cosine similarity, RwLock read lock)
    async fn similarity_search(
        &self,
        query: &str,
        k: usize,
    ) -> Result<Vec<Document>, PregolyaError>;

    /// Return the top-k documents with their cosine similarity scores.
    /// BC anchor: BC-2.21.001 PC3
    async fn similarity_search_with_score(
        &self,
        query: &str,
        k: usize,
    ) -> Result<Vec<(Document, f32)>, PregolyaError>;

    /// Maximal Marginal Relevance search balancing relevance and diversity.
    /// BC anchor: BC-2.21.001 PC4, BC-2.20.003 PC3/INV-3 (SearchType::Mmr dispatch path)
    async fn max_marginal_relevance_search(
        &self,
        query: &str,
        k: usize,
        fetch_k: usize,
        lambda_mult: f32,
    ) -> Result<Vec<Document>, PregolyaError>;

    /// Delete documents by stable ID. Returns Ok(()) even if some IDs do not exist.
    /// BC anchor: BC-2.21.001 PC5
    async fn delete(&self, ids: &[&str]) -> Result<(), PregolyaError>;

    /// Construct a `VectorStoreRetriever` over this store.
    ///
    /// # Receiver
    /// `self: Arc<Self>` — dyn-compatible receiver; `Arc<dyn VectorStore>` can dispatch
    /// through it without E0038. The impl stores `self` as `Arc<dyn VectorStore>` in
    /// `VectorStoreRetriever.store`, giving the retriever a `'static` lifetime for
    /// `Arc<dyn Retriever + 'static>` coercion (required by graph nodes and `tokio::spawn`).
    ///
    /// # Errors
    /// `Err(E-VS-003, VAL, RetryHint::Never)` when config is invalid:
    /// - `lambda_mult` outside [0.0, 1.0]
    /// - `fetch_k < k` when `SearchType::Mmr`
    ///
    /// BC anchor: BC-2.20.003 INV-2 (E-VS-003 on invalid config), BC-2.20.003 TV-004/TV-005.
    fn as_retriever(self: Arc<Self>) -> Result<VectorStoreRetriever, PregolyaError>;

    /// Metadata-filter similarity search. Default returns `Err(E-VS-005 FilterUnsupported)` when
    /// `filter.filters` is non-empty — fail-safe (not lossy). An empty `MetadataFilter` (vacuously
    /// true, `filter.filters.is_empty()`) delegates to `similarity_search`.
    /// Implementations with native backend filter support MUST override this method.
    /// BC anchor: BC-2.21.004 PC5–PC6 (filter semantics; native pre-filter vs InMemoryVectorStore post-filter),
    /// BC-2.21.004 INV-3 (default fail-safe: Err(E-VS-005 FilterUnsupported) on non-empty filter)
    async fn similarity_search_with_filter(
        &self,
        query: &str,
        k: usize,
        filter: &MetadataFilter,
    ) -> Result<Vec<Document>, PregolyaError> {
        // Default: fail-safe on non-empty filter — returning unfiltered results would be lossy
        // and a potential cross-tenant-exposure hazard (ADR-014 Decision 2 §Metadata filter surface F-P131-07 adjudication).
        if !filter.filters.is_empty() {
            return Err(PregolyaError::new(
                Component::Vs,
                Category::Val,
                RetryHint::Never,
                "E-VS-005",
                "FilterUnsupported: this VectorStore backend does not support metadata filtering; \
                 override similarity_search_with_filter to provide native filter support",
            ));
        }
        self.similarity_search(query, k).await
    }
}

/// Factory trait for constructing a concrete VectorStore from raw texts.
/// Sized-bounded to preserve Arc<dyn VectorStore> dyn-safety (Sized is not object-safe).
/// BC anchor: BC-2.21.001 INV-2 (Sized-bounded factory separation rationale)
pub trait VectorStoreFactory: VectorStore + Sized {
    type Config: Default;

    /// Construct a new store by embedding `texts` using `embedding`.
    /// Not callable through Arc<dyn VectorStore> — use only at construction time.
    /// BC anchor: BC-2.21.002 PC1 (InMemoryVectorStore::from_texts_sync semantics and signature)
    fn from_texts_sync(
        texts: Vec<String>,
        embedding: Arc<dyn Embeddings>,
        config: Self::Config,
    ) -> impl std::future::Future<Output = Result<Self, PregolyaError>> + Send;
}

/// Adapter returned by `VectorStore::as_retriever()`. Implements `Retriever + 'static`.
///
/// Holds `Arc<dyn VectorStore>` rather than a borrowed reference — removing the
/// lifetime parameter that previously prevented coercion to `Arc<dyn Retriever + 'static>`.
/// Graph nodes and `tokio::spawn` require `'static`; the Arc clone in `as_retriever` is O(1).
///
/// BC anchor: BC-2.20.003 PC1–PC3 (SearchType dispatch: Similarity, SimilarityScoreThreshold, Mmr),
/// BC-2.20.003 INV-1 (#[non_exhaustive] on SearchType)
pub struct VectorStoreRetriever {
    store: Arc<dyn VectorStore>,
    search_type: SearchType,
    k: usize,
    fetch_k: usize,
    lambda_mult: f32,
}

/// Dispatch enum for VectorStoreRetriever search strategy.
/// BC anchor: BC-2.20.003 PC2–PC3 (variant semantics), BC-2.20.003 INV-1 (#[non_exhaustive])
#[derive(Debug, Clone, Default)]
#[non_exhaustive]
pub enum SearchType {
    #[default]
    Similarity,
    SimilarityScoreThreshold { score_threshold: f32 },
    Mmr,
}

/// Optional metadata filter for similarity_search_with_filter.
/// BC anchor: BC-2.21.004 PC1–PC4 (multi-clause AND conjunction),
/// BC-2.21.004 INV-1 (#[non_exhaustive] — future variants Gte/Lt/Contains permitted)
#[derive(Debug, Clone)]
#[non_exhaustive]
pub struct MetadataFilter {
    pub filters: Vec<FilterClause>,
}

/// Single filter predicate on document metadata.
/// All three variants use serde_json::Value::PartialEq for exact match (no type coercion).
/// BC anchor: BC-2.21.004 PC1 (Eq semantics), BC-2.21.004 PC2 (Ne semantics — absent key passes),
/// BC-2.21.004 PC3 (In semantics — absent key fails), BC-2.21.004 INV-5 (no type coercion)
#[derive(Debug, Clone)]
#[non_exhaustive]
pub enum FilterClause {
    Eq { key: String, value: serde_json::Value },
    Ne { key: String, value: serde_json::Value },
    In { key: String, values: Vec<serde_json::Value> },
}
```

**BC anchor:**
BC-2.21.001 (VectorStore trait surface, VectorStoreFactory Sized-bounded separation, Arc\<dyn VectorStore\> dyn-safety),
BC-2.21.002 (InMemoryVectorStore — Arc\<dyn Embeddings\> DI, RwLock interior mutability, Vec\<f32\> cosine, VectorStoreFactory constructor),
BC-2.21.003 (zero-norm vector guard → E-VS-001 before cosine division; VP-009 Kani candidate),
BC-2.21.004 (MetadataFilter — Eq/Ne/In FilterClause; additive similarity_search_with_filter; pre vs post filter; #[non_exhaustive]).
ADR-014 Decision 2 (all method signatures, VectorStoreRetriever, SearchType, MetadataFilter; §Hardening note = search-time zero-norm guard E-VS-001), ADR-014 Decision 5 (write-time zero-norm guard E-VS-004), ADR-017 Decision 4 (InMemoryVectorStore — Arc\<dyn Embeddings\> DI + RwLock\<Vec\<(Document, Vec\<f32\>)\>\> interior mutability; Arc-DI wiring at construction time; "no placeholder construction" invariant).

---

### Embeddings Trait

**Source:** ADR-017 Decision 2; pregolya-core: core::embeddings.

```rust
// pregolya-core: core::embeddings
#[async_trait]
pub trait Embeddings: Send + Sync {
    /// Embed a batch of texts. Output must satisfy: output.len() == texts.len() and all
    /// inner vectors have the same length. Violations → Err(E-EMBED-001).
    /// Partial provider failure → Err for entire call; no truncated partial result (DI-014).
    /// BC anchor: BC-2.22.001 PC2 (batch semantics, dimensionality contract → E-EMBED-001,
    /// DI-014 no partial result), BC-2.22.001 INV-1 (all valid impls must satisfy dimensionality)
    async fn embed_documents(
        &self,
        texts: Vec<String>,
    ) -> Result<Vec<Vec<f32>>, PregolyaError>;

    /// Embed a single query text. Returns one vector of the model's declared dimension.
    /// BC anchor: BC-2.22.001 PC3 (embed_query semantics, dimension consistent with embed_documents),
    /// BC-2.22.001 INV-2 (embed_query dimension matches embed_documents dimension for same model)
    async fn embed_query(
        &self,
        text: String,
    ) -> Result<Vec<f32>, PregolyaError>;
}
```

```rust
// pregolya-core: core::embeddings — production free function (NOT test-only)

/// Validates a batch of embedding vectors against the dimensionality contract.
/// All `Embeddings` implementations must call this before returning `Ok` from
/// `embed_documents`. This function is the PRODUCTION gate for the contract;
/// validation logic must not be embedded inside mock impls (self-proving mock defect class).
///
/// # Returns
/// - `Ok(())` — batch is dimensionally valid (or empty input, EC-001).
/// - `Err(E-EMBED-001)` — one of:
///   - `vecs.len() != texts.len()` (EC-003: count mismatch)
///   - any `vecs[i].len() == 0` (EC-004: zero-length embedding vector)
///   - inconsistent inner lengths across `vecs` (Invariant 2)
///
/// BC anchor: BC-2.22.001 PC-2 (batch dimensionality contract → E-EMBED-001),
/// BC-2.22.001 INV-2 (consistent inner length), EC-003 (count mismatch), EC-004
/// (zero-length vector). Error anchor: E-EMBED-001. VP anchor: VP-008 (proptest P1;
/// VP-008-A/B/C/D/E harnesses call this function directly — deletion or regression
/// causes all five harnesses to fail immediately).
pub fn validate_embedding_batch(
    texts: &[String],
    vecs: &[Vec<f32>],
) -> Result<(), PregolyaError>;
```

**BC anchor:**
BC-2.22.001 (Embeddings trait — embed_documents batch, embed_query, dimensionality contract → E-EMBED-001, batch partial-failure as Err, Arc\<dyn Embeddings\> dyn-safe; VP-008 proptest seed),
BC-2.22.002 (EmbeddingsOpenAI — text-embedding-3-small/large/ada-002-legacy; OpenAiApiKey DI-010 credential opacity; reqwest/rustls-tls/.timeout(30s); DI-009 per BC-2.14.004),
BC-2.22.003 (EmbeddingsOllama — no API key; /api/embed preferred; use_legacy_endpoint toggle; 30s unconditional per DI-009 / BC-2.14.004).
ADR-017 Decision 2 (Embeddings trait surface, dyn-safety via #[async_trait] + &self, dimensionality contract, E-EMBED-001 authority).
`validate_embedding_batch`: `pub` free function; visibility `pub` because `pregolya-openai::openai::embeddings` and `pregolya-ollama::ollama::embeddings` call it cross-crate. `#[non_exhaustive]` does not apply (free function, no associated types). Placement: `pregolya-core/src/embeddings.rs` (or `pregolya-core/src/embeddings/mod.rs` if the module splits past 500-line soft target).

---

### ChatPromptTemplate and PromptValue Surface

**Source:** ADR-015; pregolya-prompts: prompts::template.

```rust
// pregolya-prompts: prompts::template

/// Trust classification of a template variable at injection time.
/// Distinct from `ProvenanceTag` (SS-11 ingress boundary struct).
/// `None` trust_level in a TemplateVar is treated as `Trusted` by injection_guard.
///
/// SEVERITY ORDERING: Untrusted (highest) > UserInput > Trusted (lowest).
/// Use `severity()` for aggregate comparisons — `#[derive(Ord)]` MUST NOT be added:
/// Rust declaration order makes `Untrusted < Trusted` in derived `Ord`, which is the
/// INVERSE of security severity. Calling `Iterator::max()` on a mixed set silently
/// returns `Trusted` — a fail-open injection bypass (ADR-015 Decision 3 Amendment).
///
/// BC anchor: BC-2.18.004 PC2 (TrustLevel::Untrusted triggers E-TMPL-001),
/// BC-2.18.002 INV-2 (TrustLevel severity ordering: Untrusted > UserInput > Trusted)
#[non_exhaustive]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
#[cfg_attr(kani, derive(kani::Arbitrary))]
pub enum TrustLevel {
    /// Content from an untrusted external source (e.g., MCP tool result, RAG chunk without guardrail).
    Untrusted,
    /// Content from an end-user (e.g., user chat input) — less trusted than internal but not fully untrusted.
    UserInput,
    /// Content from a trusted source (e.g., hard-coded system prompt). Default when trust_level is None.
    Trusted,
}

impl TrustLevel {
    /// Returns true only for `TrustLevel::Untrusted`.
    /// BC anchor: BC-2.18.004 PC2 (injection_guard fail-closed predicate)
    pub fn is_untrusted(&self) -> bool {
        matches!(self, Self::Untrusted)
    }

    /// Numeric severity for aggregate trust computation.
    /// Untrusted = 2 (highest risk), UserInput = 1, Trusted = 0 (lowest risk).
    ///
    /// Use `.max_by_key(|t| t.severity())` — NEVER `Iterator::max()` or derived Ord.
    /// BC anchor: BC-2.18.002 INV-2 (severity ordering for highest_trust_level aggregation)
    pub fn severity(&self) -> u8 {
        match self {
            Self::Untrusted => 2,
            Self::UserInput => 1,
            Self::Trusted   => 0,
        }
    }
}

/// A template variable value with its trust classification.
/// `trust_level: None` is treated as `TrustLevel::Trusted` by `injection_guard`.
/// BC anchor: BC-2.18.004 PC2 (trust_level: Some(TrustLevel::Untrusted) triggers E-TMPL-001),
/// BC-2.18.002 PC1–PC2 (MessageProvenance.highest_trust_level = max trust_level across slot vars)
pub struct TemplateVar {
    /// The string value to substitute into the template.
    pub value: String,
    /// Trust classification. `None` is treated as `TrustLevel::Trusted`.
    pub trust_level: Option<TrustLevel>,
}

/// Unified input type for `ChatPromptTemplate::format_messages` and `injection_guard`.
/// Replaces the former `HashMap<String, TemplateVar>` parameter — that type could not
/// represent `MessagesPlaceholder` or `FewShotPromptTemplate` inputs with trust classification.
///
/// BC anchor: BC-2.18.002 PC1–PC2 (format_messages parameter type),
/// BC-2.18.003 PC5 (FewShot example inputs; both components carry trust classification),
/// BC-2.18.004 PC3–PC5 (injection_guard dispatches over all arms),
/// ADR-015 §Decision 3 Amendment — TemplateInput Enum Concretized
///
/// See also: VP-006 Kani harness (covers Scalar and Messages arms; formal invariant
/// updated to `HashMap<String, TemplateInput>`).
#[non_exhaustive]
pub enum TemplateInput {
    /// A scalar string substitution with optional trust classification.
    /// Used for: `HumanMessagePromptTemplate`, `AIMessagePromptTemplate`, `SystemMessagePromptTemplate`.
    Scalar(TemplateVar),
    /// A message-list expansion for `MessagesPlaceholder` slots.
    /// The `Vec<Message>` is expanded in-place at the placeholder position.
    /// Trust level applies uniformly to all expanded messages.
    Messages(MessageListVar),
    /// Few-shot example pairs for `FewShotPromptTemplate` slots.
    /// Both `(input, output)` components carry independent trust classifications.
    /// Injection guard checks both before calling inner `example_template` render.
    FewShotExamples(Vec<(TemplateVar, TemplateVar)>),
}

/// Controls whether a named template slot may receive untrusted input.
/// BC anchor: BC-2.18.002 PC4 (slot_trust_policy recorded in MessageProvenance per rendered slot),
/// BC-2.18.004 PC5 (injection_guard checks TrustLevel::Untrusted against TrustRequired slots → E-TMPL-001),
/// BC-2.18.005 PC1–PC5 (TrustAll on SystemMessage slot rejected at construction → E-TMPL-002; TrustAll on non-System slots accepted)
#[derive(Debug, Clone, PartialEq)]
pub enum SlotTrustPolicy {
    /// Slot accepts any TemplateVar, including untrusted provenance.
    TrustAll,
    /// Slot requires `TrustLevel::Trusted` or `None` (absent `trust_level` treated as Trusted).
    /// `trust_level: Some(TrustLevel::Untrusted)` → E-TMPL-001 (injection_guard fail-closed; VP-006 Kani candidate).
    TrustRequired,
}

impl ChatPromptTemplate {
    /// Construct from a list of (role, template_string, trust_policy) tuples.
    /// Raises E-TMPL-002 if TrustAll is specified for a SystemMessage role (prohibited).
    /// BC anchor: BC-2.18.002 PC1 (ChatPromptTemplate construction via from_messages, returns Result per DI-008),
    /// BC-2.18.005 PC1 (TrustAll on SystemMessage → E-TMPL-002 at construction time; fail-closed)
    pub fn from_messages(
        messages: Vec<(MessageRole, &str, SlotTrustPolicy)>,
    ) -> Result<Self, PregolyaError> { ... }

    /// Render the template with the provided variable bindings.
    /// Runs injection_guard on each slot. Raises E-TMPL-001 (fail-closed) if an untrusted
    /// var is bound to a TrustRequired slot. Raises E-TMPL-003 if a required slot has no binding.
    ///
    /// **Breaking change from prior sketch form:** parameter type is `HashMap<String, TemplateInput>`
    /// (not `HashMap<String, TemplateVar>`). Covers Scalar, Messages, and FewShotExamples arms.
    /// See ADR-015 §Decision 3 Amendment — TemplateInput Enum Concretized and VP-006 §Kani harness.
    ///
    /// BC anchor: BC-2.18.002 PC1–PC2 (format_messages multi-message rendering semantics, PromptValue output),
    /// BC-2.18.004 PC3–PC5 (injection_guard call site; fail-closed; TrustLevel drives decision),
    /// BC-2.18.001 PC2 (strict-undefined variable reference → E-TMPL-003)
    pub fn format_messages(
        &self,
        vars: HashMap<String, TemplateInput>,
    ) -> Result<PromptValue, PregolyaError> { ... }
}

/// The rendered output of `format_messages` (ChatPromptTemplate path) or `format` (PromptTemplate path).
/// Canonical shape authority: BC-2.18.002 INV-5.
/// The type is Send + Sync (inner variants are String and Vec<(Message, MessageProvenance)>; auto-trait applies).
/// BC anchor: BC-2.18.002 INV-5 (PromptValue enum — String variant for single-string render path,
/// Messages variant for multi-message render path with per-message provenance)
#[non_exhaustive]
pub enum PromptValue {
    /// Rendered as a single string (PromptTemplate / f-string path).
    String(String),
    /// Rendered as a message list with provenance (ChatPromptTemplate path).
    /// One entry per slot in declaration order; each carries MessageProvenance.
    Messages(Vec<(Message, MessageProvenance)>),
}

/// Provenance metadata attached to each rendered message.
/// BC anchor: BC-2.18.002 PC3–PC4 (highest_trust_level aggregation per slot; slot_trust_policy reflection),
/// BC-2.18.004 PC1 (TrustLevel::Untrusted in highest_trust_level drives injection_guard fail-closed decision)
#[non_exhaustive]
pub struct MessageProvenance {
    /// Highest-severity TrustLevel observed across all TemplateVar values substituted into this slot.
    /// `None` = all variables had `trust_level: None` (treated as Trusted by injection_guard).
    pub highest_trust_level: Option<TrustLevel>,
    pub slot_trust_policy: SlotTrustPolicy,
}
```

**BC anchor:**
BC-2.18.001 (PromptTemplate — f-string rendering, partial binding, variable detection, strict-undefined guard → E-TMPL-003; engine-neutral; single-message surface),
BC-2.18.002 (ChatPromptTemplate — from_messages construction, format_messages multi-message rendering, PromptValue output, per-slot MessageProvenance),
BC-2.18.003 (MessagesPlaceholder Vec<Message> in-place expansion; FewShotPromptTemplate few-shot composition),
BC-2.18.004 (injection_guard — TrustLevel::Untrusted on TrustRequired slot → E-TMPL-001 fail-closed; VP-006 Kani candidate),
BC-2.18.005 (SlotTrustPolicy::TrustAll on SystemMessage slot → E-TMPL-002 at construction time; fail-closed construction guard).
ADR-015 Decision 1 (ChatPromptTemplate surface), Decision 2 (SlotTrustPolicy enum), Decision 3 (injection_guard fail-closed semantics; TrustLevel enum), Decision 4 (engine-neutral E-TMPL-003 — both f-string and jinja2 raise on undefined variable).

---

### LcSerializable and Reviver Surface

**Source:** ADR-016; pregolya-core: core::serializable.

```rust
// pregolya-core: core::serializable

/// Implemented by types that participate in the lc-JSON serialization protocol.
/// Registration via inventory::submit! at link time (see BC-2.19.003).
/// BC anchor: BC-2.19.001 PC1–PC3 (round-trip contract via Serialized::Constructor),
/// BC-2.19.002 PC1–PC3 (lc_secrets exclusion from Constructor kwargs → Serialized::Secret)
pub trait LcSerializable: Send + Sync {
    /// The lc_id path (e.g., &["langchain", "schema", "document", "Document"]).
    /// Used as the registry key in Reviver's HashMap.
    /// BC anchor: BC-2.19.001 PC1 (lc_id is the allowlist key for revive dispatch)
    fn lc_id() -> &'static [&'static str] where Self: Sized;

    /// Secret field names — excluded from Serialized::Constructor kwargs.
    /// BC anchor: BC-2.19.002 PC1 (secrets produce Serialized::Secret, not Constructor)
    fn lc_secrets(&self) -> &'static [&'static str] { &[] }

    /// Non-secret serializable attributes. Default: empty map.
    /// BC anchor: BC-2.19.001 PC2 (Constructor::kwargs sourced from lc_attributes)
    fn lc_attributes(&self) -> serde_json::Map<String, serde_json::Value> {
        serde_json::Map::new()
    }

    /// True if this type participates in round-trip serialization.
    /// BC anchor: BC-2.19.001 INV-1 (types returning false produce Serialized::NotImplemented)
    fn is_lc_serializable() -> bool where Self: Sized { false }
}

/// Wire envelope produced by lc_serialize(). One of three variants.
/// BC anchor: BC-2.19.001 PC2 (Constructor variant shape — lc field, id, kwargs),
/// BC-2.19.002 PC2 (Secret variant shape — lc field, id; no kwargs),
/// BC-2.19.001 INV-1 (NotImplemented for types with is_lc_serializable() == false)
#[derive(Debug, Serialize, Deserialize)]
#[serde(tag = "type", rename_all = "snake_case")]
pub enum Serialized {
    Constructor {
        lc: u8,
        id: Vec<String>,
        kwargs: serde_json::Map<String, serde_json::Value>,
    },
    Secret {
        lc: u8,
        id: Vec<String>,
    },
    NotImplemented {
        lc: u8,
        id: Vec<String>,
        repr: Option<String>,
    },
}

/// Link-time registry entry. Submitted via inventory::submit! in each type's module.
/// BC anchor: BC-2.19.003 PC2 (LcEntry struct shape: lc_id + constructor fn),
/// BC-2.19.003 INV-1 (registry is append-only at link time; OnceLock safe)
pub struct LcEntry {
    pub lc_id: &'static [&'static str],
    /// Deserializes kwargs back into a boxed Any. Called by Reviver::revive.
    /// BC anchor: BC-2.19.005 PC2 (Reviver dispatches to this constructor fn)
    pub constructor: fn(
        serde_json::Map<String, serde_json::Value>,
    ) -> Result<Box<dyn Any + Send + Sync>, PregolyaError>,
}

inventory::collect!(LcEntry);

/// Reconstructs types from their Serialized representations.
/// Backed by a OnceLock<HashMap<Vec<String>, ConstructorFn>> initialized from
/// inventory::iter::<LcEntry>() at startup.
/// BC anchor: BC-2.19.003 PC3–PC4 (OnceLock singleton, thread-safe concurrent initialization),
/// BC-2.19.005 PC1–PC3 (allowlist containment — unregistered id → E-SRLZ-001 fail-closed; VP-010 Kani candidate),
/// BC-2.19.006 PC1–PC2 (langchain-monolith ids → E-SRLZ-002 structured error)
pub struct Reviver { /* OnceLock<HashMap<Vec<String>, ConstructorFn>> */ }

impl Reviver {
    /// Initialize or return the cached registry. Thread-safe via OnceLock.
    /// BC anchor: BC-2.19.003 PC2 (HashMap from inventory::iter), BC-2.19.003 PC3 (OnceLock idempotent)
    pub fn new() -> Self { ... }

    /// Reconstruct a value from a Serialized envelope.
    /// Raises E-SRLZ-001 if type id is not in the allowlist registry (fail-closed).
    /// Raises E-SRLZ-002 if id matches a known langchain-monolith type.
    /// BC anchor: BC-2.19.005 PC2–PC3 (fail-closed revive; allowlist check precedes dispatch),
    /// BC-2.19.006 PC2 (E-SRLZ-002 for monolith ids — structured error, not silent None)
    pub fn revive(
        &self,
        s: Serialized,
    ) -> Result<Box<dyn Any + Send + Sync>, PregolyaError> { ... }

    /// Return the count of registered entries. Used for CI smoke-test assertions.
    /// BC anchor: BC-2.19.003 PC5 (registry_size used in TV-001/TV-002 relational assertions)
    pub fn registry_size(&self) -> usize { ... }
}
```

**BC anchor:**
BC-2.19.001 (LcSerializable — round-trip via Serialized::Constructor; lc_id, lc_attributes, is_lc_serializable),
BC-2.19.002 (lc_secrets exclusion from Constructor kwargs → Serialized::Secret variant),
BC-2.19.003 (inventory-based type registry — LcEntry, link-time submit!, feature-gated partner entries, OnceLock, Reviver::registry_size smoke-test),
BC-2.19.004 (legacy namespace remapping — alias entries added to same registry at startup),
BC-2.19.005 (Reviver allowlist containment — unregistered id → E-SRLZ-001, fail-closed; VP-010 Kani candidate),
BC-2.19.006 (langchain-monolith type ids → E-SRLZ-002, structured error — not silent None or E-SRLZ-001).
ADR-016 Decision 1 (crate placement — pregolya-core module, no new crate), Decision 2 (LcSerializable trait, Serialized enum, LcEntry; inventory-backed OnceLock type registry), Decision 3 (lc_secrets exclusion, JSON-safe output, Reviver allowlist containment and E-SRLZ-002 — §Security Invariant Properties 1–5), Decision 4 (OLD_CORE_NAMESPACES_MAPPING legacy namespace remapping).

### GraphAgentTool (mcp::graph_tool; pregolya-mcp)

**Source:** ADR-029 (GraphAgentTool wrapping; `mcp::graph_tool` module; fail-closed interrupt policy;
E-MCP-010 `GraphAgentInterruptDenied`). **Module:** `pregolya-mcp: mcp::graph_tool`
(`pregolya-mcp/src/graph_tool.rs`). Depends on: `pregolya-mcp → pregolya-graph` dependency
edge (new per ADR-029 §Decision 1; `CompiledStateGraph` is defined in `pregolya-graph/src/types.rs` per BC-2.02.001 {PC-001}).

**BC-2.09.008** is the authoritative signature carrier per ADR-029 §Decision 1.
Interface definitions here and in BC-2.09.008 take precedence over ADR sketches for conflicts.

BC anchor: BC-2.09.008 (GraphAgentTool construction, inputSchema derivation, STATE-ISOLATION
invariant {INV-001}, interrupt policy, E-MCP-010), BC-2.09.006 (tools/list advertisement path —
GraphAgentTool registers in ToolRegistry; inputSchema advertised per BC-2.09.006 {PC-002}),
BC-2.09.007 (tools/call invocation path — invoke_dyn called by mcp::server dispatch loop;
schema validation {PC-005}, isError semantics {PC-002}/{PC-003}, credential redaction {INV-003}
all apply). ADR-029 §Decision 1 (module placement + new dep edge), ADR-029 §Decision 2 (inputSchema
derivation + validation pipeline), ADR-029 §Decision 3 (output STATE-ISOLATION), ADR-029 §Decision 4 (interrupt
policy), ADR-029 §Decision 5 (E-MCP-010 error code).

```rust
// pregolya-mcp/src/graph_tool.rs — mcp::graph_tool

/// Wraps a `CompiledStateGraph` as a `DynTool`, enabling registration in a
/// `ToolRegistry` and advertisement/invocation via BC-2.09.006 tools/list and
/// BC-2.09.007 tools/call. Enforces STATE-ISOLATION (only `extract_output(&final_state_value)`
/// result is returned to the external MCP client — BC-2.09.008 {INV-001}), fail-closed
/// interrupt policy (BC-2.09.008 {INV-002}), and mandatory credential redaction on all
/// error paths (BC-2.09.007 {INV-003}).
///
/// BC anchor: BC-2.09.008 {PC-001} (construction + inputSchema derivation).
pub struct GraphAgentTool {
    name: String,
    description: String,
    input_schema: schemars::Schema,
    runner: Arc<dyn GraphRunner>,
    approval_policy: GraphToolApprovalPolicy,
}

impl GraphAgentTool {
    /// Constructs a `GraphAgentTool` wrapping the given compiled graph.
    /// `input_schema` is the caller's responsibility — derived via
    /// `schemars::schema_for!(StateType)` before calling `from_graph`.
    /// `CompiledStateGraph` is non-generic (BC-2.02.001 {PC-001}) and has no schema
    /// introspection method; schema derivation must be done by the caller.
    /// The schema is stored for advertisement in `tools/list` responses
    /// (BC-2.09.006 {PC-002}) and for server-side argument validation (BC-2.09.007 {PC-005}).
    ///
    /// `extract_output` is the STATE-ISOLATION boundary (BC-2.09.008 {INV-001}): receives
    /// the final channel-composed state as `&serde_json::Value` (returned by
    /// `CompiledStateGraph::invoke`) and selects which fields are returned to the external
    /// MCP client. Fields not selected are structurally excluded — checkpoint IDs, run IDs,
    /// message history, and metadata are unreachable unless `extract_output` constructs
    /// a `Value` containing them.
    ///
    /// Default approval policy: `GraphToolApprovalPolicy::DenyInterrupts` (fail-closed).
    ///
    /// BC anchor: BC-2.09.008 {PC-001} (construction), {PRE-001} (Arc<CompiledStateGraph>),
    /// {PC-002} (ToolRegistry registration), {INV-001} (STATE-ISOLATION),
    /// {INV-002} (binary interrupt invariant).
    pub fn from_graph(
        name: impl Into<String>,
        description: impl Into<String>,
        graph: Arc<CompiledStateGraph>,
        input_schema: schemars::Schema,
        extract_output: impl Fn(&serde_json::Value) -> serde_json::Value + Send + Sync + 'static,
    ) -> Self;

    /// Overrides the default `DenyInterrupts` approval policy.
    /// Use `ForceApproveHooks` ONLY for graphs composed exclusively of read-only tools
    /// (`ActionRisk::ReadOnly` or `ActionRisk::Low`). See `GraphToolApprovalPolicy` doc.
    pub fn with_approval_policy(self, policy: GraphToolApprovalPolicy) -> Self;
}

/// Interrupt-handling policy for `GraphAgentTool` invocations via `tools/call`.
///
/// BC anchor: BC-2.09.008 {PC-005} (DenyInterrupts interrupt path),
/// {PC-006} (ForceApproveHooks override), {INV-002} (binary interrupt invariant),
/// {INV-004} (ForceApproveHooks safety restriction).
#[non_exhaustive]
pub enum GraphToolApprovalPolicy {
    /// **Default — fail-closed.**
    ///
    /// **Node-level `interrupt()` → `Err(E-MCP-010 GraphAgentInterruptDenied)`:**
    /// `GraphRunner::run` detects `RunStatus::Interrupted` and returns `Err(E-MCP-010)`.
    /// The interrupted run is NOT persisted to durable checkpoint.
    /// BC-2.09.008 {INV-002}: no `Ok` result is returned when `RunStatus::Interrupted`.
    ///
    /// **`PreToolDecision::PendingHumanApproval` → `BoundaryApprovalHook` converts to
    /// `Deny { reason: "HITL_NOT_SUPPORTED_AT_MCP_BOUNDARY" }` → tool NOT invoked; graph
    /// CONTINUES executing.** `E-MCP-010` is NOT raised on the `BoundaryApprovalHook::Deny`
    /// path. If the graph reaches a valid terminal state, BC-2.09.008 {PC-004} applies
    /// (`Ok(serde_json::Value from extract_output_result)`). If it reaches an error terminal,
    /// `GraphRunner::run` returns `Err` with the graph's OWN error — NOT `E-MCP-010`.
    DenyInterrupts,

    /// **Explicit opt-in — HITL-dialog suppressor only (SEC-007).**
    ///
    /// **SEC-006 — Runtime `ActionRisk` gate (FIXED/F-P2A165-01/CWE-862;
    /// BC-2.09.008 {PC-006}, {INV-004}):**
    /// `BoundaryApprovalHook` checks `preview.action_risk: Option<ActionRisk>`
    /// (BC-2.05.007 {PRE-003}) BEFORE invoking the inner hook — not only in the
    /// `PendingHumanApproval` arm. This ensures write-class tools are blocked
    /// regardless of whether the inner hook returns `Approve` (e.g., `AlwaysApprovePolicy`
    /// or no-hook default per BC-2.05.007 {PC-006}) or `PendingHumanApproval`:
    /// - `Some(r)` where `r < ActionRisk::Medium` → proceed to inner hook.
    /// - `None` (undeclared risk; fail-closed per BC-2.05.006 EC-004/{INV-002})
    ///   OR `Some(r)` where `r >= ActionRisk::Medium` → `Deny` +
    ///   `E-MCP-011 ForceApproveWriteBlocked` (ERROR-level (`tracing::error!`) structured log)
    ///   WITHOUT calling the inner hook. The tool is NOT invoked.
    ///
    /// **After the gate passes** (risk < Medium): inner hook is invoked.
    /// `PendingHumanApproval` → `Approve`. `Deny` and ALL other `PreToolDecision`
    /// values pass through UNCHANGED (SEC-007) — `ForceApproveHooks` is NOT a
    /// blanket security bypass.
    ///
    /// **Node-level `interrupt()` is NOT overridden:** graph parks →
    /// `Err(E-MCP-010 GraphAgentInterruptDenied)`. {INV-002} holds.
    ///
    /// **Suitable only for:** graphs composed exclusively of read-only tools with
    /// declared `ActionRisk < Medium` for every tool. The `ActionRisk` gate is
    /// unconditional (pre-hook), not a backstop; audit tool composition at registration.
    /// ADR-029 §Decision 4.
    ForceApproveHooks,
}

/// Type-erased runner — holds `Arc<CompiledStateGraph>` internally (non-generic, BC-2.02.001
/// {PC-001}); no generic parameter. Called by `GraphAgentTool::invoke_dyn`; enforces
/// STATE-ISOLATION by calling `extract_output(&final_state_value)` as the sole data-exit path,
/// where `final_state_value: serde_json::Value` is the channel-composed state returned by
/// `CompiledStateGraph::invoke`.
///
/// BC anchor: BC-2.09.008 {INV-001} (STATE-ISOLATION — only `extract_output` result returned),
/// {PC-004} (successful terminal path), {PC-005} (interrupt path → E-MCP-010).
#[async_trait]
pub(crate) trait GraphRunner: Send + Sync {
    async fn run(
        &self,
        input: serde_json::Value,
        approval_policy: &GraphToolApprovalPolicy,
    ) -> Result<serde_json::Value, PregolyaError>;
}
```

---

## pregolya-server HTTP API

### Base URL

All endpoints are relative to the server's configured base URL.
Default port: `7437` (configurable via `server.port` in `pregolya-server.toml`).

### Canonical Pagination Convention (F-P31-01, ADV-P1D-PASS-31)

All list and aggregate GET endpoints accept uniform pagination query parameters:

| Parameter | Type | Default | Max | Out-of-range |
|-----------|------|---------|-----|--------------|
| `limit` | integer | 10 | 100 | Values > 100 are **silently clamped** to 100 — no validation error (E-CORE) is returned. Decision: clamp (not reject). |
| `offset` | integer | 0 | — | No upper bound. |

Results are ordered by `created_at` **descending** (most-recently created first) unless a
specific endpoint declares a different ordering (e.g., `/history` is ordered newest
checkpoint first, which is also descending by creation sequence). Each list-endpoint
row below cites F-P31-01 where pagination applies. Any endpoint that deviates carries
an explicit documented exemption.

**BC anchors:** BC-2.12.001 PC8 (threads list), BC-2.12.001 PC17 (history), BC-2.12.002 PC21-PC23 (assistants list), BC-2.12.003 PC18 (runs list), BC-2.12.004 PC7 (schedule-runs aggregate).

### Threads

| Method | Path | Description | BC Anchor |
|--------|------|-------------|-----------|
| POST | `/threads` | Create a new thread | BC-2.12.001 |
| GET | `/threads/{thread_id}` | Get thread metadata | BC-2.12.001 |
| GET | `/threads` | List threads; canonical pagination (`?limit=N` default 10 max 100, `?offset=N`; `created_at` DESC) — F-P31-01 | BC-2.12.001 |
| DELETE | `/threads/{thread_id}` | Delete thread and all associated checkpoints | BC-2.12.001 |
| GET | `/threads/{thread_id}/state` | Latest checkpoint state: `{ values: GraphState, checkpoint: CheckpointId, next: [NodeId] }` | BC-2.12.001 |
| POST | `/threads/{thread_id}/state` | Apply state delta `{ values: Map<String,Value>, as_node?: NodeId }` → returns `{ checkpoint: CheckpointId }` | BC-2.12.001 |
| GET | `/threads/{thread_id}/history` | Checkpoint history list, newest-first; canonical pagination (`?limit=N` default 10 max 100, `?offset=N`; values > 100 clamped) — F-P31-01 | BC-2.12.001 |

### Assistants

| Method | Path | Description | BC Anchor |
|--------|------|-------------|-----------|
| POST | `/assistants` | Create an assistant (named agent config + graph reference) | BC-2.12.002 |
| GET | `/assistants/{assistant_id}` | Get assistant config (resolves via latest-version pointer) | BC-2.12.002 |
| GET | `/assistants` | List assistants; canonical pagination (`?limit=N` default 10 max 100, `?offset=N`; `created_at` DESC) — F-P31-01 | BC-2.12.002 |
| PATCH | `/assistants/{assistant_id}` | Sparse update (new immutable version created; previous accessible via /versions) | BC-2.12.002 |
| DELETE | `/assistants/{assistant_id}` | Delete assistant | BC-2.12.002 |
| GET | `/assistants/{assistant_id}/versions` | List all immutable version snapshots; canonical pagination (`?limit=N` default 10 max 100, `?offset=N`; values > 100 silently clamped); **ordering exemption**: results ordered `version` **ascending** (lowest version first) — version ASC is intentional for historical replay and deviates from the default `created_at` DESC canon; exemption declared per F-P32-03, BC-2.12.002 PC20 | BC-2.12.002 |
| POST | `/assistants/{assistant_id}/set_latest` | Update latest-version pointer to `{ version: N }` → HTTP 200 with Assistant at version N; 404 if N not found | BC-2.12.002 |

### Runs

| Method | Path | Description | BC Anchor |
|--------|------|-------------|-----------|
| POST | `/threads/{thread_id}/runs` | Create and start a run (async; returns 202 with `run_id`); run-supplied `config`/`metadata`/`context` deep-merge over the Assistant's stored values, run wins at leaf key (BC-2.12.003 §Invariants, F-P33-02) | BC-2.12.003 |
| GET | `/threads/{thread_id}/runs` | List runs for a thread; `?status=queued\|in_progress\|completed\|failed\|interrupted\|cancelled\|summary_halt` filter + canonical pagination (`?limit=N` default 10 max 100, `?offset=N`; `created_at` DESC) — F-P31-01 | BC-2.12.003 |
| GET | `/threads/{thread_id}/runs/{run_id}` | Get run status and result | BC-2.12.003 |
| GET | `/threads/{thread_id}/runs/{run_id}/stream` | Stream run output as server-sent events (SSE; happy path emits run_start, node_start/stream/end, run_end; **run_end is emitted on completion only** — interrupted runs terminate with interrupt envelope as terminal frame, failed runs terminate with error SSE event; neither emits run_end; BC-2.06.001 PC2+EC-005, BC-2.12.007 EC-001/EC-003). **Guardrail decisions (F-P99-01):** `guardrail_decision` events are emitted for non-Pass guardrail outcomes (Fail/Transform only — Pass not streamed); fire within the tool lifecycle window (before `tool_end`) for ToolResult boundary, and within the node lifecycle window for RAG/Memory boundaries; see §StreamEvent for complete taxonomy and ordering. **ToolEnd content semantics:** `tool_end.data` carries POST-guardrail content — raw rejected payloads are never emitted in any SSE event (BC-2.11.005 INV-5). BC-2.11.002/003/004 PC3/PC4 (per-boundary), ADR-006 rev-3. **Tool approval events (D23/ADR-018):** `tool_approval_request` is emitted BEFORE the run is suspended into `interrupted` state when `pre_tool_dispatch` returns `PreToolDecision::PendingHumanApproval`; it carries `run_id`, `tool_name`, `tool_args`, `action_risk`, and `prompt`. `tool_approval_resolved` is emitted AFTER the interrupt is consumed and BEFORE the decision is applied, on `Command(resume=PreToolDecision)` delivery; it carries `run_id`, `tool_name`, `decision`, `reason`, and `modified_args`. Both events fire within the NodeStart/NodeEnd window, before the ToolStart window for the same tool call; see §PreToolCallHook and BC-2.06.004/005. **Compaction event (D23/ADR-019):** `compaction_event` is emitted after a compaction cycle completes and the compacted checkpoint is durably written (step 6 of BC-2.10.006 7-step sequence); it carries `run_id`, `trigger`, `parent_ids`, `compacted_start`, `compacted_end`, `summary_token_count`, and `tokens_remaining_after`; fires after StepEnd and before the next StepStart; see §Compaction and BC-2.06.006. | BC-2.12.007 |
| POST | `/threads/{thread_id}/runs/{run_id}/resume` | Deliver resume value to interrupted run | BC-2.05.004 |
| POST | `/threads/{thread_id}/runs/{run_id}/cancel` | Cancel a queued or in_progress run (transitions to cancelled) | BC-2.12.003 |
| DELETE | `/threads/{thread_id}/runs/{run_id}` | Delete a terminal run record (completed/failed/cancelled/summary_halt; HTTP 409 if queued, in_progress, or interrupted — cancel or resume-to-complete/summary_halt first) | BC-2.12.003 |

### Cron Schedules

Schedules are **assistant-owned** (not thread-owned). Each firing creates a **fresh
`thread_id`** — no prior thread context is shared unless `RunnableConfig.thread_id`
is explicitly set by the operator (BC-2.12.004). Paths are flat (not thread-nested).

> **No list-all-schedules endpoint (OBS-P32-1, ADV-P1D-PASS-32):** No list-all-schedules
> endpoint in v1 — schedules are addressed individually by cron_id; the flat
> `GET /runs?schedule_id={cron_id}` aggregate is the only schedule-scoped listing surface
> (URL-scheme canon, ADV-P1D-PASS-23).

| Method | Path | Description | BC Anchor |
|--------|------|-------------|-----------|
| POST | `/schedules` | Create a cron schedule (assistant_id + cron expression + config) | BC-2.12.004 |
| GET | `/schedules/{cron_id}` | Get schedule (current `enabled` state, `last_fired_at`) | BC-2.12.004 |
| PATCH | `/schedules/{cron_id}` | Enable/disable schedule (`{ "enabled": false }`; in-flight Run continues) | BC-2.12.004 |
| DELETE | `/schedules/{cron_id}` | Delete schedule; halts all future firings (`204 No Content`) | BC-2.12.004 |

**Cross-thread aggregate query (flat, read-only):**

| Method | Path | Description | BC Anchor |
|--------|------|-------------|-----------|
| GET | `/runs?schedule_id={cron_id}` | List all Runs fired by a given schedule across all threads (read-only aggregate; canonical pagination: `?limit=N` default 10 max 100, `?offset=N`; `created_at` DESC — ordering canon declared in BC-2.12.004 PC7; F-P31-01) | BC-2.12.004 |

> **Note:** This is the only flat `/runs` endpoint. All other Run CRUD paths are
> thread-scoped (`/threads/{thread_id}/runs/...`). This endpoint exists because
> cron-fired Runs each have distinct `thread_id` values — a thread-scoped query
> cannot enumerate all Runs for a schedule. Decision source: F-P23-01.

### HTTP Status Codes

| Code | Meaning | Error Source |
|------|---------|-------------|
| 200 | Success with response body | — |
| 201 | Created (new resource; body contains created object) | — |
| 202 | Accepted (async run created; polling required) | — |
| 204 | No Content (delete success; no response body) | — |
| 400 | Validation error | E-CORE-001, E-CORE-002, E-CORE-003, E-CORE-005 (VAL — pregolya-core input validation), E-CRON-002 (InvalidCronExpression); E-PROV-005 (StructuredOutputParseError, VAL) and E-PROV-006 (ContextLengthExceeded, VAL) — categorical VAL→400; surfaced embedded in Run.error, not as direct HTTP response codes (OBS-3; BC-2.08.003, BC-2.08.004). **Note:** E-CORE-004 (INTERNAL) excluded — see E-CORE-004 omission note below (F-P69-01). |
| 401 | Authentication failure (categorical fallback) | E-PROV-004 (ProviderAuthFailed, AUTH) — categorical fallback only; no v1 server endpoint emits 401 as a direct terminal HTTP status; surfaced embedded in Run.error. Server-side authentication middleware is out of v1 scope (F-P26-05; F-P25-02: E-SERVER-004 recategorized AUTH→POLICY → 403) |
| 403 | Policy enforcement (debug route, role gate) | E-SERVER-004 (DebugRouteUnauthorized), E-GRAPH-013 (InsufficientApproverRole — SECURITY; direct HTTP 403 on `POST /threads/{thread_id}/runs/{run_id}/resume` when caller role is insufficient for the interrupt's risk tier; BC-2.05.006 PC3-PC4, EC-001; F-P27-04) — **NOTE (F-P66-03, ADV-P1D-PASS-66):** E-SERVER-005 (CorsRejected) REMOVED from this row; CORS denial is silent header-omission per BC-2.12.005 PC2/TV-001 and never produces a direct HTTP 403 error body; code retired unraised. |
| 404 | Resource not found | E-SERVER-002 (RunNotFound), E-SERVER-003 (ThreadNotFound), E-SERVER-006 (ScheduleNotFound), E-SERVER-009 (AssistantNotFound — direct resource lookup), E-SERVER-010 (AssistantVersionNotFound) |
| 409 | Conflict (duplicate resource or state conflict) | E-SERVER-007 (ThreadAlreadyExists), E-SERVER-008 (ThreadStateConflict — POLICY→409 per-endpoint override; BC-2.14.002 PC3; F-P26-01), E-SERVER-012 (ConcurrentRun), E-SERVER-015 (RunAlreadyExecuting) |
| 422 | Semantic validation failure (VAL-category on body content) and per-endpoint POLICY→422 overrides (request valid but current state makes processing impossible) | E-GRAPH-003 (UnknownRoutingTarget), E-GRAPH-004 (DuplicateBarrierWrite), E-GRAPH-007 (UnknownChannelKey), E-GRAPH-008 (UnreachableGraph), E-GRAPH-009 (DuplicateNodeName), E-GRAPH-010 (UnknownBarrierWriter), E-GRAPH-012 (UnmappedRouteKey), E-GRAPH-015 (NoParentGraph); E-SERVER-009 (AssistantNotFound in run body — invalid assistant_id reference at run creation; context-dependent: same code, 404 at direct lookup), E-SERVER-011 (GraphNotFound — graph_id in assistant body not registered); E-GRAPH-002 (NoActiveInterrupt — POLICY→422 per-endpoint override on resume endpoint: run exists and caller is authorized, but no interrupt slot is active; BC-2.14.002 PC3 9th override; F-P27-01). INTERNAL/DURABILITY E-GRAPH codes (E-GRAPH-006, E-GRAPH-011) and DURABILITY/INTERNAL E-CHKPT codes (E-CHKPT-001, -002, -003, -004, -006, -007) go to the 500 row; E-CHKPT-005 (TENANCY) is library-level embedded — see omission note below. (OBS-1; narrowed from E-GRAPH-*/E-CHKPT-* wildcards — F-P26-01; F-P27-01 adds E-GRAPH-002; F-P27-03 corrects E-CHKPT-* over-broad text) |
| 429 | Rate limited | E-PROV-001 |
| 500 | Internal error | E-GRAPH-006 (BspDeterminismViolation, INTERNAL), E-GRAPH-011 (ConditionalEdgePanic, INTERNAL); E-CHKPT-001 (CheckpointWriteFailed, DURABILITY), E-CHKPT-002 (MonotonicClockRegression, INTERNAL), E-CHKPT-003 (CheckpointReadFailed, DURABILITY), E-CHKPT-004 (EncryptionKeyRotationFailed, INTERNAL — F-P27-02/03: category corrected SECURITY→INTERNAL; added to 500 row), E-CHKPT-006 (SerializationFailed, INTERNAL), E-CHKPT-007 (CipherHeaderMissing, INTERNAL — unencrypted legacy blob read in encrypted store; BC-2.04.007 EC-004); E-SERVER-014 (RunStoreFailed) |
| 502 | Bad Gateway (provider transport failure) | E-PROV-003 (StreamInterrupted), E-PROV-008 (ProviderHttpError — generic provider HTTP 5xx / unparseable error body; BC-2.08.004 EC-004/EC-005) — categorical fallback only; no v1 endpoint emits 502 as a direct terminal HTTP status; surfaced embedded in Run.error |
| 503 | Service temporarily unavailable (retryable store/lock timeout) | E-SERVER-016 (IdempotencyLockTimeout); Retry-After header present; per-endpoint override over categorical Timeout→504 (F-P25-01; BC-2.12.006 EC-002; BC-2.14.002 PC3 carve-out) |
| 504 | Gateway Timeout (provider response timeout) | E-PROV-002 (ProviderTimeout) — categorical fallback only; no v1 endpoint emits 504 as a direct terminal HTTP status; surfaced embedded in Run.error |

**BC anchor:** BC-2.12.001 through BC-2.12.007

> **Async error intentional omissions (OBS-2, ADV-P1D-PASS-26):** E-CRON-001 (AssistantNotFoundAtFiring) and E-CRON-003 (ScheduleQueueFull) are async firing-time errors surfaced in schedule/run state, never as a direct HTTP response — intentionally omitted from this table.

> **Graph execution errors embedded in Run.error (F-P27-04, ADV-P1D-PASS-27; F-P49-02, ADV-P1D-PASS-49):** E-GRAPH-001 (InvalidUpdateError, CONCURRENCY — BC-2.03.002; concurrent BSP write failure surfaces as a run failure, embedded in Run.error.type), E-GRAPH-014 (InterruptApprovalTimeout, POLICY — BC-2.05.006 EC-005; timeout causes run transition to `failed`, embedded in Run.error), E-GRAPH-016 (InterruptWithoutCheckpointer, POLICY — BC-2.05.001 EC-001, BC-2.10.004; raised when interrupt() is called without a CheckpointSaver, surfaces as a run failure), and E-GRAPH-017 (GraphRecursionLimitExceeded, POLICY — BC-2.03.001 PC5; raised when the BSP super-step count for the current invocation segment exceeds `config.recursion_limit` (default 25); the run transitions to `failed`; primary infinite-loop guard for cyclic graphs) are graph execution errors that appear embedded in Run.error, never as direct terminal HTTP status codes. Categorical mappings: CONCURRENCY→409, POLICY→403 (apply only if ever surfaced directly — not in v1).

> **E-CHKPT-005 library-level omission (F-P27-03, ADV-P1D-PASS-27):** E-CHKPT-005 (SessionAddressCollision, TENANCY — BC-2.04.006) is a checkpoint library-level error enforcing the session triple-address uniqueness invariant (NE-12). TENANCY→409 is the categorical mapping. In v1 this error is raised within the checkpoint layer before any HTTP response is sent, surfacing as a run failure embedded in Run.error, not as a direct terminal HTTP 409 response. Intentionally omitted from the 409 row for the same reason as the E-PROV categorical-fallback codes.

> **E-PROV-007 embedded omission (OBS-P28-3, ADV-P1D-PASS-28):** E-PROV-007 (StructuredOutputRefused, POLICY — BC-2.08.003) is emitted when the OpenAI Responses API rejects a `json_schema` structured output request via a safety-filter refusal. POLICY→403 is the categorical mapping. In v1 this error surfaces as a run failure embedded in Run.error — the server cannot distinguish a refusal from a valid LLM response until the response body is deserialized post-stream. No v1 server endpoint emits HTTP 403 directly for this code. Intentionally omitted from the 403 row; the 403 row lists only codes that produce a direct terminal HTTP 403 response (E-SERVER-004, E-GRAPH-013). (E-SERVER-005 previously listed here — RETIRED F-P66-03, ADV-P1D-PASS-66.)

> **E-SERVER-013 startup-only omission (F-P55-01, ADV-P1D-PASS-55):** E-SERVER-013 (InvalidDebugRouteKey, VAL — BC-2.12.005 EC-005/TV-007) is raised during server configuration validation at startup (debug_route_key must be non-empty when debug routes are enabled). VAL→400 is the categorical mapping. In v1 this error halts startup before any HTTP listener is bound; it is never surfaced as a terminal HTTP response. Intentionally omitted from the 400 row; same treatment as E-CHKPT-005.

> **E-CORE-004 library-layer omission (F-P69-01, ADV-P1D-PASS-69):** E-CORE-004 (INTERNAL — BC-2.01.004 PC5) is raised when a type-erased `DynRunnable` pipeline detects a type boundary mismatch between adjacent stages at the first `invoke` call. INTERNAL→500 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError { category: INTERNAL, code: "E-CORE-004", .. })` return from the `RunnableSequence::invoke` call site in library code; it is never emitted as a terminal HTTP response by pregolya-server (if ever propagated to a server-side run, it would surface embedded in Run.error, not as a direct HTTP 500). Intentionally omitted from the HTTP status table; same treatment as E-CORE-006 and E-CORE-007.

> **E-CORE-006 library-layer omission (F-P56-01, ADV-P1D-PASS-56):** E-CORE-006 (RecursionLimitExceeded, INTERNAL — BC-2.01.003 PC5) is raised by the pregolya-core Runnable-layer when nested `invoke`/`stream` call depth exceeds `config.recursion_limit` (default 25). INTERNAL→500 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError)` return from the `invoke`/`stream` call site in library code; it is never emitted as a terminal HTTP response by pregolya-server (if it ever propagates to a server-side run, it would surface embedded in Run.error, not as a direct HTTP 500). Intentionally omitted from the HTTP status table; same treatment as E-MCP-*, E-SPLIT-*, and other library-layer errors.

> **E-CORE-007 library-layer omission (ADV-P1D-PASS-56-COMPLETION/2026-07-15):** E-CORE-007 (GuardrailHookPanic, INTERNAL — BC-2.11.002 / BC-2.11.003 / BC-2.11.004) is raised when a `GuardrailHook::evaluate` call panics at any content-ingress boundary (tool-result, RAG chunk, or memory item). INTERNAL→500 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError)` return from the guardrail ingress pipeline in library code; it is never emitted as a terminal HTTP response by pregolya-server (if ever propagated to a server-side run, it would surface embedded in Run.error). Fail-closed semantics: content that triggered the panic is treated as rejected and does not enter the model context. Intentionally omitted from the HTTP status table; same treatment as E-CORE-006.

> **E-CORE-008 library-layer omission (burst-226/F-P131-01/2026-07-21):** E-CORE-008 (GuardrailCriticalRejection, SECURITY — BC-2.20.002 PC2) is raised by `GuardedDocuments::rag_ingress` when any document receives `GuardrailResult::Fail { severity: GuardrailSeverity::Critical }`. SECURITY→403 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError)` return from `GuardedDocuments::rag_ingress` in library code; it is never emitted as a terminal HTTP response by pregolya-server (if ever propagated to a server-side run, it would surface embedded in Run.error, not as a direct HTTP 403). Fail-closed semantics: the entire batch is aborted; no `GuardedDocuments` is produced. Intentionally omitted from the HTTP status table; same treatment as E-CORE-007.

> **E-CHKPT-008 library-layer omission (D20 sub-burst 2; raise-timing corrected F-P82-02):** E-CHKPT-008 (FtsLimitZero, VAL) covers two distinct sub-cases with different raise times: **(1) `FtsSearchConfig.limit = 0`** — raised at **`FtsSearchConfig` construction time** (DI-008 construction-result contract; BC-2.04.008 PC6/EC-004); **(2) malformed FTS5 query string** — raised at **`fts_search` call time** when SQLite FTS5 fails to parse the query string passed as the standalone `query: &str` first parameter (SQLite FTS5 parse error propagation; BC-2.04.008 EC-002). Note: `query` is a standalone first parameter to `fts_search`, NOT a field of `FtsSearchConfig`. VAL→400 is the categorical mapping. In v1 both sub-cases surface as a direct `Err(PregolyaError)` return from library code; neither is emitted as a terminal HTTP response by pregolya-server (no FTS search endpoint in v1; if ever surfaced via server, it would appear embedded in Run.error). Intentionally omitted from the HTTP status table.

> **E-CHKPT-009 library-layer omission (D20 sub-burst 2):** E-CHKPT-009 (Fts5Unavailable, INTERNAL — BC-2.04.008 EC-006) is raised at `CheckpointSaver::new()` construction time when FTS is requested but the SQLite build does not include the FTS5 extension. INTERNAL→500 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError)` return from `CheckpointSaver::new()` in library code; it is never emitted as a terminal HTTP response by pregolya-server (server startup with a bad FTS5 config fails before any listener is bound). Intentionally omitted from the HTTP status table; same treatment as E-CHKPT-005 and E-SERVER-013 (startup-time library errors).

> **E-PROV-009 library-layer omission (D20 sub-burst 2):** E-PROV-009 (ToolCallDialectParseError, VAL — BC-2.08.013 PC8/PC9/EC-002) is raised when `ToolCallDialect::deserialize_tool_calls` fails to parse model-output content. VAL→400 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError)` return from the dialect dispatch layer in library code; it propagates as Run.error on the server side (same treatment as E-PROV-005, E-PROV-006). Never a direct HTTP terminal response. Intentionally omitted from the HTTP status table.

> **E-PROV-010 library-layer omission (D20 sub-burst 2):** E-PROV-010 (ProviderChainExhausted, POLICY — BC-2.08.014 PC5/EC-004) is raised when all providers in the `ProviderFallbackPolicy` chain have been tried and all failed. POLICY→403 is the categorical mapping. In v1 this error surfaces as a direct `Err(PregolyaError)` return from the provider dispatch layer in library code; it propagates as Run.error on the server side (same treatment as E-PROV-007 StructuredOutputRefused). Never a direct HTTP terminal response. Intentionally omitted from the HTTP status table.

> **Library/execution-layer codes — blanket omission (OBS-P29-1, ADV-P1D-PASS-29; F-P30-01, ADV-P1D-PASS-30; D21/2026-07-20; D23/2026-07-22):** All remaining library and execution-layer error codes — E-MCP-* (BC-2.09.x, TOOL/TRANSPORT/VAL), E-SBXD-* (BC-2.13.x, SECURITY/POLICY/INTERNAL), E-RETRY-* (BC-2.16.x, POLICY/VAL), E-BUDGET-* (BC-2.10.x, POLICY/DURABILITY), E-MEMORY-* (BC-2.15.x, VAL/POLICY/DURABILITY/SECURITY), E-SPLIT-* (BC-2.07.x, VAL), E-TMPL-* (BC-2.18.x, SECURITY/VAL), E-SRLZ-* (BC-2.19.x, VAL), E-VS-* (BC-2.20.x/BC-2.21.x, VAL), E-EMBED-* (BC-2.22.x, VAL), E-TOOLS-* (BC-2.23.x, SECURITY/VAL/TIMEOUT) — surface embedded in Run.error or as library `Err` return values. None has a direct HTTP row in this table. Categorical fallbacks apply if ever surfaced directly (TOOL→422, TRANSPORT→502, SECURITY→403, POLICY→403, DURABILITY→500, INTERNAL→500, VAL→400, TIMEOUT→503) but in v1 these codes are not emitted as terminal HTTP responses by any endpoint. Spot-checked: E-MCP-001 (BC-2.09.004 — embedded in run as tool failure), E-SBXD-001 (BC-2.13.005 — sandbox security violation embedded in run), E-MEMORY-001 (BC-2.15.001 — memory store validation error embedded in run); all confirmed library-layer only. **D21 additions confirmed library-layer only:** E-TMPL-001 (BC-2.18.004 — prompt injection guard, pregolya-prompts), E-SRLZ-001 (BC-2.19.005 — Reviver allowlist fail-closed, pregolya-core::serializable), E-VS-001 (BC-2.21.003 — zero-norm cosine guard, pregolya-vectorstores), E-EMBED-001 (BC-2.22.001 — dimensionality contract, pregolya-core::embeddings); all library-layer Err returns. **D23 additions confirmed library-layer only:** E-TOOLS-001 (BC-2.23.001–006 — PathGuard confinement SECURITY), E-TOOLS-002/003/007 (VAL construction/call-time), E-TOOLS-004 (BashTool timeout TIMEOUT/Never), E-TOOLS-005/006 (informational payload fields — not raised Err; included for census completeness); all pregolya-tools library-layer. **burst-233 additions confirmed library-layer only:** E-TOOLS-008 (BC-2.23.001–004/006 — OS-level I/O error TOOL/Maybe, wraps std::io::ErrorKind), E-TOOLS-009 (BC-2.23.006 — invalid regex pattern VAL/Never); both pregolya-tools library-layer. **burst-240 addition confirmed library-layer only:** E-MCP-006 (BC-2.09.002 — McpContentUnsupported VAL/Never; raised by _convert_mcp_content_to_block for unsupported content block types such as AudioContent; pregolya-mcp library-layer Err return; never direct HTTP terminal in v1). **GAP-01/BC-2.09.008 addition confirmed library-layer only:** E-MCP-010 (BC-2.09.008 — GraphAgentInterruptDenied EXEC/Never; raised by `GraphAgentTool` in `mcp::graph_tool` when graph invocation is interrupted at the MCP boundary under `DenyInterrupts` policy; pregolya-mcp library-layer Err return; never direct HTTP terminal in v1). **Round-5/BC-2.09.008 addition confirmed library-layer only:** E-MCP-011 (BC-2.09.008 — ForceApproveWriteBlocked EXEC/Never; emitted by `BoundaryApprovalHook` under `ForceApproveHooks` policy when `action_risk` is None or >= Medium; pregolya-mcp library-layer Err return; never direct HTTP terminal in v1). **Disposition census (round-5/2026-08-26): 50 HTTP + 25 individual + 62 blanket = 137.** (+2 blanket: E-MCP-* 9→11 codes.) Blanket group breakdown: E-MCP-* 11 + E-SBXD-* 10 + E-RETRY-* 4 + E-BUDGET-* 2 + E-MEMORY-* 10 + E-SPLIT-* 2 + E-TMPL-* 4 + E-SRLZ-* 2 + E-VS-* 5 + E-EMBED-* 1 + E-TOOLS-* 11 = 62. (Historical snapshot burst-240/2026-07-22: 43 HTTP + 17 individual + 48 blanket = 108.)

## Exit Code Semantics

pregolya is a library — process exit codes do not apply. The embedded `pregolya-server` uses standard HTTP status codes; see §HTTP Status Codes in the §pregolya-server HTTP API section above. Library errors propagate as `PregolyaError` values per the error taxonomy.

## JSON Output Schema

Canonical JSON output shapes for `pregolya-server` API responses. The primary response objects are defined in the sections below.

## Run Object Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "required": ["run_id", "thread_id", "assistant_id", "status", "created_at", "updated_at"],
  "properties": {
    "run_id": { "type": "string", "description": "Monotonic logical run identifier" },
    "thread_id": { "type": "string" },
    "assistant_id": { "type": "string" },
    "status": {
      "type": "string",
      "enum": ["queued", "in_progress", "interrupted", "completed", "failed", "cancelled", "summary_halt"],
      "description": "Run state machine: queued → in_progress → completed | failed | cancelled | summary_halt; in_progress ⇄ interrupted (resume via POST .../resume). summary_halt is a terminal state produced by the OnCeiling::Summarize budget path (BC-2.10.003 PC8(d)). Authority: BC-2.12.003 PC7-PC9 (v1.4). multitask_strategy='enqueue' creates the new run in 'queued' state; it transitions to 'in_progress' after the current run finishes. Use POST .../cancel to transition queued/in_progress→cancelled."
    },
    "created_at": { "type": "string", "format": "date-time" },
    "updated_at": { "type": "string", "format": "date-time", "description": "Set on every Run state mutation (status transition, output/error write). Always present. Authority: BC-2.12.003 PC13." },
    "completed_at": { "type": ["string", "null"], "format": "date-time", "description": "Set only on terminal transition (status → completed | failed | cancelled | summary_halt). Null in all non-terminal states (queued, in_progress, interrupted). Distinct from updated_at — terminal-timestamp semantics. Authority: F-P24-01, BC-2.12.003 PC13 v1.4." },
    "output": { "description": "Final graph state; present only when status=completed or status=summary_halt. For summary_halt, output carries the summarize model response (BC-2.10.003 PC8(c)). Null in all other states." },
    "error": {
      "type": ["object", "null"],
      "description": "RFC-7807 problem detail; present only when status=failed",
      "properties": {
        "type": { "type": "string", "format": "uri" },
        "title": { "type": "string" },
        "detail": { "type": "string" },
        "extensions": { "type": "object" }
      }
    },
    "interrupt": {
      "type": ["object", "null"],
      "description": "Present only when status=interrupted. Reconciled F-P25-06 to match BCs (authoritative): BC-2.05.001 (InterruptPayload { value, interrupt_id }), BC-2.05.006 (HitlInterruptPayload { action_risk, action, context }), entities-server.md §Interrupt (interrupt_id, node_name, scratchpad).",
      "properties": {
        "interrupt_id": {
          "type": "string",
          "description": "Stable identifier for this interrupt (hash of checkpoint namespace at interrupt time). Used in Command(resume={interrupt_id: value}) targeted delivery. Authority: BC-2.05.001 TV-001, entities-server.md §Interrupt."
        },
        "node_name": {
          "type": "string",
          "description": "Name of the node that raised this interrupt. Canonical field name: node_name (per entities-server.md §Interrupt). Was incorrectly 'node_id' — fixed F-P25-06."
        },
        "super_step": { "type": "integer", "description": "Super-step index at the time the interrupt was raised." },
        "value": {
          "description": "The interrupt value surfaced to the caller (any serializable type; msgpack round-trip required per BC-2.05.001 PC4 TV-001). Authority: BC-2.05.001 PC4."
        },
        "action_risk": {
          "type": ["string", "null"],
          "enum": ["ReadOnly", "Low", "Medium", "High", null],
          "description": "Typed action-risk tier for Domain A HITL interrupts (BC-2.05.006 HitlInterruptPayload). Null for non-risk-tiered interrupts. Canonical field name: action_risk. Was incorrectly 'risk_tier' — fixed F-P25-06."
        },
        "action": {
          "type": ["string", "null"],
          "description": "Human-readable description of the action awaiting authorization (Domain A HITL; HitlInterruptPayload.action). Null for non-HITL-tier interrupts."
        },
        "context": {
          "description": "Optional structured context for the approver (Domain A HITL; HitlInterruptPayload.context). Null for non-HITL-tier interrupts."
        },
        "scratchpad": { "description": "Per-task scratchpad state at interrupt time. Authority: entities-server.md §Interrupt." }
      }
    }
  }
}
```

## Resume Request Schema

```json
{
  "type": "object",
  "required": ["resume_value"],
  "properties": {
    "resume_value": { "description": "The value delivered to the interrupted node (Command(resume=value))" },
    "approver_id": { "type": ["string", "null"], "description": "Optional approver identity for audit trail" }
  }
}
```

> **REST resume is FIFO-only (OBS-P48-1, ADV-P1D-PASS-48 — adjudicated D17-Q2 HITL contract):** REST resume delivers to the single active interrupt slot in FIFO order; it does not accept an `interrupt_id` field and cannot target a specific concurrent interrupt. Targeted delivery to a specific `interrupt_id` is library-API only: `Command(resume={interrupt_id: value})` submitted via `graph.invoke` / `graph.stream` (BC-2.05.004 EC-002). This is an intentional v1 limitation consistent with the D17-Q2 committed FIFO-resume HITL contract.

**BC anchor:** BC-2.05.004

## pregolya-server Config File Schema

```toml
# pregolya-server.toml
[server]
port = 7437                    # default; must be > 1023 for non-root
host = "127.0.0.1"             # default: loopback only
workers = 4                    # Tokio worker threads; default: num_cpus

[security]
# SecurityConfig::default() denies CORS and gates debug routes (NE-14, BC-2.12.005)
cors_allow_origins = []        # empty = deny all cross-origin requests (SECURE DEFAULT)
# debug_route_key = "your-secret-here"  # absent = debug routes disabled (SECURE DEFAULT)
                                        # non-empty string enables /_debug; gate requires
                                        # Authorization: Bearer <key> (F-P26-04; BC-2.12.005 authoritative)
                                        # IMPORTANT: present-but-empty ("") = E-SERVER-013 startup failure
                                        # (ADR-021 Decision 1; BC-2.12.005 EC-005/TV-007)

[checkpoint]
backend = "sqlite"             # "sqlite" | "memory"; postgres = stretch target
sqlite_path = "./pregolya.db"

[sandbox]
backend = "wasm"               # "wasm" (default, enforcing) | "container" | "process"
                               # 'process' backend emits loud WARNING once per execute() invocation — NOT construction/startup (BC-2.13.002 PC2/EC-002)

[budget]
# Global budget policy (GraphConfig::budget_config default for all runs on this server).
# Per-run override: pass RunnableConfig { budget_config: Some(BudgetConfig { ... }), .. }
# to Runnable::invoke/stream. This is also the mechanism used by BudgetResume::Extend:
# the engine patches RunnableConfig::budget_config with the extended ceiling for only
# that resumed execution — GraphConfig is NOT mutated (BC-2.10.004 PC6, F-P92-02).
default_token_limit = null     # null = unlimited (operator must set a limit)
default_on_ceiling = "halt"    # "halt" | "escalate"
                               # "summarize" is config-API-only; requires a summarize_prompt
                               # payload and is not expressible as a bare-string default —
                               # use table form: [budget.on_ceiling] mode = "summarize"
                               #                 summarize_prompt = "Summarize your findings."
```

**BC anchor:** BC-2.12.005, BC-2.13.001, BC-2.13.002

## Trajectory Primitive

**Crates:** `pregolya-core` (core::trajectory — definitions-only), `pregolya-checkpoint` (checkpoint::trajectory — execution)
**Subsystem:** SS-04 (Checkpoint / State Persistence)
**ADR:** ADR-030 Decision 2

The trajectory primitive provides durable, append-only audit-grade recording of run-step events for research orchestrator loops and other iterative execution patterns. Type definitions live in `pregolya-core` (ADR-009 Option 3 pattern — definitions in core, execution in domain crate). Execution (SQLite/backend storage) lives in `checkpoint::trajectory`, isolated from the `CheckpointSaver` compaction path.

```rust
// pregolya-core (core::trajectory) — definitions only, no execution logic

#[non_exhaustive]
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TrajectoryRecord {
    pub run_id: Uuid,
    pub step_idx: u64,
    pub event_kind: String,
    pub payload: serde_json::Value,
}

impl TrajectoryRecord {
    /// Constructor required for cross-crate use: `#[non_exhaustive]` prevents struct-literal
    /// construction outside `pregolya-core` (e.g., `SqliteTrajectoryStore` in
    /// `pregolya-checkpoint`, test code, orchestrator callers).
    pub fn new(
        run_id: Uuid,
        step_idx: u64,
        event_kind: impl Into<String>,
        payload: serde_json::Value,
    ) -> Self {
        TrajectoryRecord { run_id, step_idx, event_kind: event_kind.into(), payload }
    }
}

#[async_trait]
pub trait TrajectoryWriter: Send + Sync {
    async fn put_record(&self, record: TrajectoryRecord) -> Result<(), PregolyaError>;
}

#[async_trait]
pub trait TrajectoryReader: Send + Sync {
    async fn replay(&self, run_id: Uuid) -> Result<Vec<TrajectoryRecord>, PregolyaError>;
}
```

### TrajectoryRecord Fields

| Field | Type | Description |
|-------|------|-------------|
| `run_id` | `Uuid` | Identifies the orchestrator run; groups all records for a single execution |
| `step_idx` | `u64` | Monotonically increasing within a run; enables replay ordering |
| `event_kind` | `String` | Semantic event label (e.g., `"hypothesis.proposed"`, `"experiment.result"`) |
| `payload` | `serde_json::Value` | Arbitrary structured event data; schema determined by orchestration layer |

### TrajectoryWriter::put_record

**Preconditions:** `record.run_id` is a valid non-nil UUID; `record.step_idx` is consistent with prior records for the same `run_id` (backend enforces monotonicity).

**Postcondition (BC-2.04.009 anchor):** After successful return, the record is durably persisted; a subsequent `TrajectoryReader::replay(record.run_id)` will include it in the returned sequence.

**Error:** `E-TRAJ-001 TrajectoryWriteFailed` on backend I/O error.

### TrajectoryReader::replay

**Postcondition (BC-2.04.010 anchor):** Returns all `TrajectoryRecord` values persisted for `run_id` in ascending `step_idx` order. Returns `Ok(vec![])` for an unknown `run_id` (not an error).

**Error:** `E-TRAJ-003 TrajectoryReadFailed` on backend I/O error.

### TrajectoryRetentionPolicy (core::trajectory)

```rust
// pregolya-core (core::trajectory) — definitions only (ADR-009 definitions-in-core pattern)

/// Specifies which records are eligible for removal vs. retained during compaction.
/// Defined in `core::trajectory`; `TrajectoryCompactor` lives in `checkpoint::trajectory`.
///
/// **Eligible** records: `step_idx < retention_frontier` AND NOT in `promoted` set.
/// **Retained** records: `step_idx >= retention_frontier` (including the frontier record
///   where `step_idx == retention_frontier`) OR in `promoted` set.
/// `retention_frontier` is an exclusive lower bound for eligibility: strictly less than
/// (`<`) means eligible; greater-than-or-equal (`>=`) means retained.
#[non_exhaustive]
pub struct TrajectoryRetentionPolicy {
    /// Records with `step_idx < retention_frontier` are eligible for removal.
    /// The frontier itself (`step_idx == retention_frontier`) is retained.
    pub retention_frontier: u64,
    /// Explicitly promoted step_idx values — always retained regardless of frontier.
    /// A step_idx listed here is retained even when `step_idx < retention_frontier`
    /// (e.g., a compacted-but-significant milestone record; BC-2.04.011 {PRE-002}).
    pub promoted: Vec<u64>,
}

impl TrajectoryRetentionPolicy {
    /// Constructor required for cross-crate use: `#[non_exhaustive]` prevents struct-literal
    /// construction outside `pregolya-core` (`TrajectoryCompactor` callers in
    /// `pregolya-checkpoint` must pass a policy to `compact()`).
    pub fn new(retention_frontier: u64, promoted: Vec<u64>) -> Self {
        TrajectoryRetentionPolicy { retention_frontier, promoted }
    }
}
```

**BC anchor:** BC-2.04.011 {PRE-002} (caller supplies `TrajectoryRetentionPolicy`). Eligible and retained sets are complements by construction — `retention_frontier` and `promoted` fully determine both; no external validation is required.

### TrajectoryCompactor

```rust
// pregolya-checkpoint (checkpoint::trajectory) — execution

/// Compacts an unbounded durable audit trajectory by atomically removing eligible records.
///
/// Compaction is crash-isolated per {INV-003}: issues a single `BEGIN IMMEDIATE` /
/// `DELETE FROM trajectory_records WHERE run_id = :run_id AND step_idx < :retention_frontier
/// AND step_idx NOT IN (:promoted_step_idxs)` / `COMMIT` transaction.  The DELETE is
/// scope-safe by construction — it touches only the caller-supplied `run_id`; no other
/// run's records are affected.  Concurrent `put_record` calls on the same or other runs
/// are serialized by SQLite WAL write-lock; no interleaving can corrupt any run's records.
/// A SIGKILL mid-compaction leaves uncommitted WAL frames that are discarded on the next
/// database open; the pre-compaction trajectory is fully recovered ({INV-003}).
/// Co-located in the same SQLite database file as `CheckpointSaver`, in a dedicated
/// `trajectory_records` table keyed `(run_id, step_idx)` (no FK joins to checkpoint
/// tables; WAL mode).
#[async_trait]
pub trait TrajectoryCompactor: Send + Sync {
    async fn compact(
        &self,
        run_id: Uuid,
        policy: TrajectoryRetentionPolicy,
    ) -> Result<(), PregolyaError>;
}
```

**Postcondition (BC-2.04.011 {PC-001}):** After `Ok(())`, every retained record appears in `replay(run_id)` unchanged. No retained record is lost or mutated.

**Errors:**
- `E-TRAJ-005 TrajectoryCompactionFailed (DURABILITY, Maybe-retry)` (minted; `BC-2.04.011 {PC-006}`): backend I/O failure during the DELETE transaction. Crash mid-compaction: uncommitted WAL frames are discarded on the next database open; the pre-compaction state is fully recovered ({INV-003}). On the next `compact` call, `Err(PregolyaError)` is returned and the caller retries.
- `E-TRAJ-006 TrajectoryIntegrityCheckFailed (DURABILITY, Never)` (pending PO mint; BC-2.04.009 {INV-001}): AES-GCM authentication-tag mismatch detected during decrypt-then-compare conflict detection on the `put_record` path. Signals that the stored ciphertext has been tampered with or corrupted. The record is not updated; the error surfaces to the caller for abort or escalation. Never retried (non-transient).

**BC anchor:** BC-2.04.009 (TrajectoryWriter::put_record durability), BC-2.04.010 (TrajectoryReader::replay ordering), BC-2.04.011 (Trajectory Compaction Isolation)

### Serializer

**Module:** `pregolya-core` (`core::serializer`)
**Implementors:** `EncryptedSerializer` (`pregolya-checkpoint`, `checkpoint::serializer`)
**ADR:** ADR-030 §Decision 2 (at-rest confidentiality), BC-2.04.007 {INV-003}, BC-2.04.009 {INV-002}

Object-safe abstraction for at-rest encryption of durable storage payloads. Accepted as
`Option<Arc<dyn Serializer + Send + Sync>>` at construction by both the
`checkpoint::trajectory` concrete implementation (ADR-030 §Decision 2) and
`CheckpointSaver` (BC-2.04.007 {INV-003}). When `Some(s)` is provided, payloads are
serialized (encrypted) before storage and deserialized (decrypted) after retrieval.
When `None`, storage is plaintext — this is the opt-in model; no fail-closed guard
applies for the no-serializer case (ADR-030 at-rest confidentiality decision).

```rust
// pregolya-core (core::serializer) — definitions only

/// Object-safe serializer abstraction for at-rest encryption of durable storage payloads.
///
/// Both methods take `&self` with no type parameters — `dyn Serializer` is valid;
/// `Arc<dyn Serializer + Send + Sync>` compiles on stable Rust.
///
/// **BC anchor:** BC-2.04.007 {INV-003} (CheckpointSaver encryption),
///   BC-2.04.009 {INV-002} (TrajectoryWriter encryption)
pub trait Serializer: Send + Sync {
    /// Serialize (encrypt) `plaintext` bytes for at-rest storage.
    ///
    /// # Errors
    /// Propagates as `Err(PregolyaError)` (SRLZ namespace) on encryption failure.
    fn serialize(&self, plaintext: &[u8]) -> Result<Vec<u8>, PregolyaError>;

    /// Deserialize (decrypt) `ciphertext` bytes retrieved from storage.
    ///
    /// # Errors
    /// Propagates as `Err(PregolyaError)` (SRLZ namespace) on decryption failure
    /// (corrupted ciphertext, wrong key, truncated payload, etc.).
    fn deserialize(&self, ciphertext: &[u8]) -> Result<Vec<u8>, PregolyaError>;
}

// pregolya-checkpoint (checkpoint::serializer) — execution

/// Concrete AES-256-GCM at-rest encryption implementation of `Serializer`.
///
/// Key material is never exposed through `Debug` (redacted newtype pattern — CLAUDE.md).
/// **BC anchor:** BC-2.04.007 {INV-003}, BC-2.04.009 {INV-002}
pub struct EncryptedSerializer { /* opaque; key stored in memory only */ }

impl EncryptedSerializer {
    /// Construct with a 256-bit AES-GCM key.
    pub fn new(key: &[u8; 32]) -> Self;
}
// impl Serializer for EncryptedSerializer
```

**Object-safety justification:** both `serialize` and `deserialize` are non-generic methods
that take `&self` and byte slices — no associated types, no generic parameters. `dyn Serializer`
is valid and `Arc<dyn Serializer + Send + Sync>` satisfies the Arc-DI wiring requirement
(CLAUDE.md §Arc-DI wiring per constructor).

**BC anchor:** BC-2.04.007 {INV-003} (EncryptedSerializer via CheckpointSaver), BC-2.04.009
{INV-002} (EncryptedSerializer via TrajectoryWriter at-rest encryption)

**Product-owner note:** BC-2.04.009 {INV-002} and BC-2.04.007 should both reference
`Arc<dyn Serializer + Send + Sync>` as the DI seam (not just `EncryptedSerializer` directly)
to permit alternative implementations without BC amendment.

---

## LedgerChannel

**Crate:** `pregolya-graph` (graph::channels)
**Subsystem:** SS-02 (Graph / Execution Engine)
**ADR:** ADR-030 Decision 3
**VP:** VP-017 (proptest P1, dedup-idempotent append, BC-2.02.007 anchor)

`LedgerChannel<T>` is a dedup-idempotent, append-only channel variant for accumulating evidence or results over iterative research loops. An entry is keyed by `entry_id()`; appending an entry whose `entry_id()` is already present is a no-op (idempotency). This enables safe retry of hypothesis/experiment steps without double-counting results.

`PromoteRetireChannel<T>` extends the ledger model with explicit lifecycle transitions: entries can be promoted (added to active set) or retired (removed by entry ID). This supports hypothesis qualification/disqualification workflows.

```rust
// pregolya-graph (graph::channels) — execution

/// Trait marking a type as a keyed ledger entry.
/// `entry_id()` returns the dedup key; equal `entry_id()` values are the same logical entry.
///
/// The `Serialize + DeserializeOwned` bounds are required for checkpoint resume: graph state
/// containing a `LedgerChannel<T>` accumulator is serialized by `CheckpointSaver::put_writes`
/// and deserialized on resume. `entry_id()` must produce the same value before and after a
/// serde round-trip (ADR-030 §Decision 3 serialization seam; F-P2A211-07).
pub trait LedgerEntry: Clone + Serialize + DeserializeOwned + Send + Sync + 'static {
    fn entry_id(&self) -> &str;
}

/// Dedup-idempotent append-only channel — **stateless pure reducer marker**.
///
/// `LedgerChannel<T>` carries no instance state. State lives in the `Vec<T>` channel
/// accumulator supplied by the `StateGraph` runtime. The reducer signature is:
///   `fn reduce(acc: Vec<T>, update: T) -> Vec<T>`  (pure function; no `Result`; no `Ok(())`)
///
/// Semantics:
/// - Reducing with an entry whose `entry_id()` is **novel** appends it: `new_len = old_len + 1`.
/// - Reducing with an entry whose `entry_id()` is **already present** is a no-op: `new_len = old_len`.
/// - First-appearance order of unique entries is preserved in the accumulated `Vec<T>` (BC-2.02.008).
///
/// Dedup implementation: **linear scan** of `acc` within `reduce` — no `indexmap` dependency.
/// For typical research accumulator sizes (tens to low hundreds of entries), O(n) per call is
/// adequate. Not persisted on the struct (consistent with the S-1.14 channel family:
/// `LastValue<T>`, `BinaryOperatorAggregate<T, Op>`, etc. are all stateless reducer markers).
///
/// Channel registration is **type-level** (via `StateGraph` schema annotation); the BSP engine
/// constructs instances internally. `Default` is a **manual bound-free impl** — `derive(Default)`
/// is intentionally absent because it would emit a spurious `T: Default` bound (rustc #26925),
/// violating the `Channel: Default` supertrait obligation for all `T: LedgerEntry`.
#[non_exhaustive]
pub struct LedgerChannel<T: LedgerEntry> {
    _inner: PhantomData<T>,
}

impl<T: LedgerEntry> Default for LedgerChannel<T> {
    fn default() -> Self { Self { _inner: PhantomData } }
}

/// Lifecycle operation on a PromoteRetireChannel.
///
/// `derive(Clone)` is safe: `LedgerEntry: Clone` (supertrait bundles `Clone`), so
/// `PromoteRetireOp<T>: Clone` holds for all `T: LedgerEntry` with no bound beyond the
/// supertrait, satisfying `Channel::Update: Clone`. Does NOT trigger rustc #26925 —
/// contrast with `Default` (not in the bundle), which forces manual bound-free impls on
/// the marker structs. `Debug` added conventionally for a data-bearing update enum;
/// conditional on `T: Debug` (not in the bundle) — acceptable, no declared bound
/// requires unconditional `Debug`.
#[non_exhaustive]
#[derive(Clone, Debug)]
pub enum PromoteRetireOp<T: LedgerEntry> {
    /// Add or re-activate an entry (dedup: if entry_id() already active, no-op).
    Promote(T),
    /// Remove an entry by entry_id; no-op if the entry_id is not present.
    Retire(String),
}

/// Channel that supports promote/retire lifecycle semantics for QD (Qualification/Disqualification)
/// allocation in research orchestrator loops (BC-2.02.009 anchor).
///
/// **Stateless reducer marker**: carries no instance state. State lives in the `Vec<T>` channel
/// accumulator (the current active set). Reducer signature:
///   `fn reduce(acc: Vec<T>, update: PromoteRetireOp<T>) -> Vec<T>`  (pure function; no `Result`)
///
/// Channel registration is **type-level** (via `StateGraph` schema annotation); the BSP engine
/// constructs instances internally. `Default` is a **manual bound-free impl** — `derive(Default)`
/// is intentionally absent (same reason as `LedgerChannel<T>`: rustc #26925 spurious `T: Default`
/// bound would violate `Channel: Default` for all `T: LedgerEntry`).
#[non_exhaustive]
pub struct PromoteRetireChannel<T: LedgerEntry> {
    _inner: PhantomData<T>,
}

impl<T: LedgerEntry> Default for PromoteRetireChannel<T> {
    fn default() -> Self { Self { _inner: PhantomData } }
}
```

### LedgerChannel Invariants

| Invariant | Description | BC / VP Anchor |
|-----------|-------------|----------------|
| Novel-reduce appends | `reduce(acc, e)` where `e.entry_id()` not present → returns `acc` with `e` appended; `len = old_len + 1` | BC-2.02.007 {PC-001} |
| Seen-reduce is no-op | `reduce(acc, e)` where `e.entry_id()` already in `acc` → returns `acc` unchanged; `len = old_len`; no `Result`, no `Ok(())` | BC-2.02.007 {PC-002} |
| First-appearance ordering | `reduce` preserves first-appearance order across all calls; accumulated `Vec<T>` is ordered by first insertion, not lexicographic | BC-2.02.008 |
| Dedup-idempotent reduce (formal) | proptest: ∀ entry sequence with duplicates, applying `LedgerChannel::reduce` to each entry yields the same `Vec<T>` as applying to the deduplicated prefix | VP-017 |

**BC anchor:** BC-2.02.007 (LedgerChannel dedup-idempotent append), BC-2.02.008 (first-appearance ordering), BC-2.02.009 (PromoteRetireChannel promote/retire lifecycle)

---

## Cargo Feature Flags

| Feature | Default | Description | BC Anchor |
|---------|---------|-------------|-----------|
| `checkpoint-sqlite` | on | SQLite checkpoint backend | BC-2.04.001 |
| `checkpoint-memory` | off | In-memory checkpoint backend (testing only; not crash-safe) | BC-2.04.002 |
| `checkpoint-postgres` | off | Postgres checkpoint backend (stretch target) | — |
| `sandbox-wasm` | on | WASM sandbox backend (enforcing; default) | BC-2.13.001 |
| `sandbox-container` | off | Container sandbox backend | BC-2.13.001 |
| `sandbox-process` | off | Process backend (NOT enforcing; no filesystem/network/memory isolation); compiles `ProcessBackend` but does NOT make it a default — accessible ONLY via `Sandbox::unsafe_process_no_isolation()`; `SandboxBackend::default()` returns `Err(E-SBXD-003)` when no enforcing backend is compiled (BC-2.13.001 PC3/PC4) | BC-2.13.001, BC-2.13.002 |
| `server` | off | pregolya-server HTTP server | BC-2.12.001 |
| `mcp` | off | pregolya-mcp adapter | BC-2.09.001 |
| `budget` | on | Budget governance policy primitive | BC-2.10.001 |
| `guardrail` | on | Content provenance + guardrail hook | BC-2.11.001 |

## Flag Interactions

| Flag A | Flag B | Interaction |
|--------|--------|-------------|
| `checkpoint-memory` | `checkpoint-sqlite` | Mutually exclusive in production; memory is testing-only |
| `sandbox-wasm` | `sandbox-container` | Pick one enforcing backend; wasm takes precedence if both enabled |
| `server` | any checkpoint feature | Server requires exactly one checkpoint backend to be active |
| `sandbox-wasm` + `sandbox-container` both off | (none) | `SandboxBackend::default()` returns `Err(E-SBXD-003 SandboxInitFailed { reason: "no enforcing backend compiled in" })`; NO silent process fallback (BC-2.13.001 PC4/EC-002, DI-006, NE-01); process backend reachable ONLY via explicit `Sandbox::unsafe_process_no_isolation()` (BC-2.13.001 PC3) |
