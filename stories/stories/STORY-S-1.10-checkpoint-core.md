---
document_type: story
level: ops
story_id: S-1.10
epic_id: E-05
version: "1.6"
status: draft
producer: story-writer
timestamp: 2026-09-10T00:00:00Z
phase: 2
inputs:
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.001.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.002.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.003.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.004.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.005.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.006.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.007.md
  - .factory/specs/architecture/module-decomposition.md
  - .factory/specs/architecture/dependency-graph.md
input-hash: "db34305"
traces_to: .factory/stories/STORY-INDEX.md
points: 13
depends_on: [S-1.04, S-1.02]
blocks: [S-1.11, S-1.16, S-1.18, S-1.20, S-1.25, S-1.26, S-6.01]
behavioral_contracts: [BC-2.04.001, BC-2.04.002, BC-2.04.003, BC-2.04.004, BC-2.04.005, BC-2.04.006, BC-2.04.007]
verification_properties: [VP-002]
priority: P0
cycle: v1.0.0-greenfield
wave: 1
target_module: pregolya-checkpoint
subsystems: [SS-04]
estimated_days: 5
assumption_validations: []
risk_mitigations: []
tdd_mode: strict
---

# S-1.10: Checkpoint Core — put_writes, Durability Tiers, Monotonic Clock, Fork, Crash Recovery, Encryption

## Narrative

- **As a** pregolya library user orchestrating stateful graph executions
- **I want to** have a `CheckpointSaver` implementation that persists per-task writes before super-step boundaries, enforces monotonic checkpoint IDs, supports fork-via-pointer (no state copy), recovers cleanly from crashes, and encrypts all written data at rest
- **So that** long-running graph executions are crash-safe at sub-step granularity, concurrent threads cannot collide on storage addresses, forks are cheap (no state duplication), and all persisted state is encrypted without caller intervention

## Behavioral Contracts

| BC | Title | Covered ACs |
|----|-------|------------|
| BC-2.04.001 | Per-Task put_writes Completes Before Next Super-Step Begins | AC-001..AC-004, AC-023 |
| BC-2.04.002 | Sync Durability Tier Is Default; Async and Exit Are Explicit Opt-In | AC-005..AC-007 |
| BC-2.04.003 | Monotonic Logical-Clock Checkpoint IDs — Wall-Clock UUIDs Rejected | AC-008..AC-010 |
| BC-2.04.004 | Fork Lineage via parent_checkpoint_id Pointers; No State Copy on Fork | AC-011..AC-012 |
| BC-2.04.005 | Crash Recovery — Completed Tasks Not Re-Executed After Process Restart | AC-013..AC-015, AC-024 |
| BC-2.04.006 | Session Triple-Address Uniqueness (thread_id, checkpoint_ns, checkpoint_id) — Kani VP Seed | AC-016..AC-019 |
| BC-2.04.007 | Encryption at Rest Covers Both State AND Event Payloads; Rotation Errors Propagate | AC-020..AC-022 |

## VP-002 ANCHOR (Kani P0)

This story builds `pregolya-checkpoint/src/session_index.rs` containing `SessionKey`, `storage_address`, and the session triple-address logic. The `storage_address` pure function is the proof vehicle for the VP-002 Kani harness (Phase 6 formal hardening). The Kani harness stub `session_tenancy_harness` lives in `crates/pregolya-checkpoint/src/proofs/session_tenancy.rs` — authored (as `todo!()`) in this story, completed in S-6.01. Per VP-002, the harness verifies injectivity of `storage_address` over the bounded input space.

**Subsystem anchor justification:** SS-04 owns this story's scope because SS-04 is the Checkpoint subsystem (pregolya-checkpoint crate) per ARCH-INDEX Subsystem Registry.

**Dependency anchor justification:** S-1.10 depends on S-1.04 because the `Runnable` trait and `PregolyaError` infrastructure (S-1.04) define the trait-based execution model that `CheckpointSaver` extends. S-1.10 depends on S-1.02 because error-policy enforcement (S-1.02) governs how `E-CHKPT-*` errors propagate through the graph runtime.

## Acceptance Criteria

### AC-001 (traces to BC-2.04.001 PC-001)
For each completed `PregelTask`, `put_writes(config, writes, task_id)` is called and submitted to the backend BEFORE `apply_writes` is invoked for the current super-step. This ordering is verified by querying the `pending_writes` table before `apply_writes` executes. Verified by `test_BC_2_04_001_put_writes_precedes_apply_writes()`.

### AC-002 (traces to BC-2.04.001 PC-005)
Special-channel writes use negative write indices: `ERROR=-1`, `SCHEDULED=-2`, `INTERRUPT=-3`, `RESUME=-4`. These never collide with regular writes (non-negative indices). Dedup is last-write-wins for special channels. Verified by `test_BC_2_04_001_special_channel_negative_indices()`.

### AC-003 (traces to BC-2.04.001 INV-001)
`put_writes` is called as each task finishes, not batched at super-step end. A 3-task super-step produces 3 `put_writes` calls in task-completion order, not 1 batched call. Verified by `test_BC_2_04_001_put_writes_per_task_not_batched()`.

### AC-004 (traces to BC-2.04.001 EC-002)
If `put_writes` storage backend returns an error, the error surfaces as `Err(PregolyaError { category: DURABILITY, code: "E-CHKPT-001", message: "CheckpointWriteFailed: put_writes for task '<task_id>' failed — backend error: <backend_error>", .. })` and `apply_writes` is NOT called. The run transitions to `failed`. Verified by `test_BC_2_04_001_put_writes_storage_failure_halts_run()`.

### AC-005 (traces to BC-2.04.002 PC-001)
`DurabilityTier::Sync` is the default when constructing a `CheckpointSaver` without explicit tier configuration. With `Sync`, all `put_writes` futures are fully resolved (storage confirmed) before the super-step boundary. Verified by `test_BC_2_04_002_sync_is_default_tier()`.

### AC-006 (traces to BC-2.04.002 PC-003)
With `DurabilityTier::Async`, `put_writes` futures are submitted (queued) before the next super-step begins and joined before the run exits. The super-step boundary does NOT wait for storage confirmation. Verified by `test_BC_2_04_002_async_tier_futures_joined_on_exit()`.

### AC-007 (traces to BC-2.04.002 EC-003)
Constructing a `CheckpointSaver` with an unknown/invalid durability tier string returns `Err(PregolyaError { category: VAL, code: "E-CORE-005", message: "Validation failed for 'durability': unknown tier \"<value>\"", .. })`. Verified by `test_BC_2_04_002_unknown_tier_validation_error()`.

### AC-008 (traces to BC-2.04.003 PC-001)
`get_next_version(current, channel)` returns a `CheckpointId` that is strictly greater than `current`. The implementation uses a monotonic logical clock (NOT `Uuid::new_v4()` or any wall-clock UUID). Verified by `test_BC_2_04_003_get_next_version_monotonic()`.

### AC-009 (traces to BC-2.04.003 PC-003)
If a `CheckpointId` derived from a random UUID (wall-clock or v4) is presented as `current`, `get_next_version` rejects it with `Err(PregolyaError { code: "E-CHKPT-002", message: "MonotonicClockRegression: checkpoint_id must be monotonic: random UUID rejected", .. })`. Verified by `test_BC_2_04_003_random_uuid_rejected()`.

### AC-010 (traces to BC-2.04.003 INV-001)
After a process restart, `get_next_version` sources `current` from the persisted maximum `CheckpointId` in the storage backend (ADR-005 rev-2 cross-restart monotonicity). Post-restart IDs are always strictly greater than any pre-restart ID for the same `(thread_id, checkpoint_ns)`. Verified by `test_BC_2_04_003_cross_restart_monotonicity()`.

### AC-011 (traces to BC-2.04.004 PC-002)
`CheckpointSaver::fork(parent_checkpoint_id)` creates a new fork checkpoint with `metadata.parents[checkpoint_ns] == parent_checkpoint_id` — no state is copied. The fork checkpoint contains only the parent pointer. Verified by `test_BC_2_04_004_fork_via_parent_pointer_no_copy()`.

### AC-012 (traces to BC-2.04.004 PC-001)
The fork checkpoint's `checkpoint_id` is obtained via `get_next_version`, ensuring it is monotonically greater than the parent's ID. No two fork siblings share the same `checkpoint_id`. Verified by `test_BC_2_04_004_fork_checkpoint_id_from_get_next_version()`.

### AC-013 (traces to BC-2.04.005 PC-001)
On resume after crash, tasks that were fully committed (their `put_writes` was confirmed in storage) are NOT re-executed. The recovery mechanism reads the `pending_writes` table to determine which tasks completed before the crash. Verified by `test_BC_2_04_005_committed_tasks_not_re_executed()`.

### AC-014 (traces to BC-2.04.005 INV-003)
The skip-on-reapply set is: `ERROR`, `ERROR_SOURCE_NODE`, `INTERRUPT`, `RESUME`. `SCHEDULED` is NOT in the skip-on-reapply set — it is re-executed on resume. Verified by `test_BC_2_04_005_skip_on_reapply_set_excludes_scheduled()`.

### AC-015 (traces to BC-2.04.005 EC-006)
If `get_tuple` returns an error during recovery, the error surfaces as `Err(PregolyaError { code: "E-CHKPT-003", message: "CheckpointReadFailed: cannot restore state for thread '<thread_id>' checkpoint '<checkpoint_id>': <reason>", .. })`. Verified by `test_BC_2_04_005_get_tuple_failure_propagates()`.

### AC-016 (traces to BC-2.04.006 PC-001)
`pregolya-checkpoint/src/session_index.rs` exports `pub fn storage_address(key: &SessionKey) -> StorageAddress` as a pure function (no database I/O). `SessionKey` is a struct with `thread_id: String`, `checkpoint_ns: String`, `checkpoint_id: CheckpointId`. `StorageAddress` implements `PartialEq`. The `#[cfg(kani)]` proof harness `session_tenancy_harness` lives in `crates/pregolya-checkpoint/src/proofs/session_tenancy.rs` (stub authored in this story; completed in S-6.01). Verified by `test_BC_2_04_006_session_key_and_storage_address_types_exist()`.

### AC-017 (traces to BC-2.04.006 PRE-002)
`thread_id` is accessed from `config.configurable` via `config.configurable.as_ref().and_then(|m| m.get("thread_id"))`. A missing `thread_id` key returns `Err(PregolyaError { code: "E-CORE-005", message: "Validation failed for 'thread_id': missing from configurable", .. })`. Verified by `test_BC_2_04_006_missing_thread_id_validation_error()`.

### AC-018 (traces to BC-2.04.006 INV-003)
No backend implementation may use bare `thread_id` as a sole primary key. Every storage operation includes the full `(thread_id, checkpoint_ns, checkpoint_id)` triple. Verified by `test_BC_2_04_006_full_triple_used_in_storage_key()` (inspects generated SQL or storage key construction).

### AC-019 (traces to BC-2.04.006 EC-005)
If a storage collision occurs (two `SessionKey` triples map to the same address), the error surfaces as `Err(PregolyaError { code: "E-CHKPT-005", message: "SessionAddressCollision: ...", .. })`. In practice this is prevented by the monotonic clock (AC-008/AC-010) but the error code must exist and be returned if a collision is detected. Verified by `test_BC_2_04_006_session_address_collision_error()`.

### AC-020 (traces to BC-2.04.007 INV-001)
`EncryptedSerializer` wraps `CheckpointSaver` and encrypts BOTH `put` AND `put_writes` paths. There is no unencrypted write path when `EncryptedSerializer` is in the chain. Verified by `test_BC_2_04_007_encrypted_serializer_covers_both_paths()`.

### ~~AC-021~~ — RETIRED DC-64/F-PDC64-01: BC-2.04.007 EC-003 retired. `EncryptedSerializer::new(key: &[u8; 32])` is infallible — fixed-size array parameter enforces key length at compile time; an empty or wrong-length key cannot reach `new()`. This acceptance criterion tested an unreachable runtime path and is retired alongside EC-003. (Prior trace: BC-2.04.007 EC-003)
~~Constructing `EncryptedSerializer` with empty key material returns `Err(PregolyaError { code: "E-CORE-005", message: "Validation failed for 'encryption_key': key material must not be empty", .. })`. Verified by `test_BC_2_04_007_empty_key_rejected()`.~~

### AC-022 (traces to BC-2.04.007 EC-002)
Attempting to rotate an encryption key returns `Err(PregolyaError { code: "E-CHKPT-004", message: "EncryptionKeyRotationFailed: ...", .. })` classified as INTERNAL severity. Reading data written with a different key (cipher header mismatch) returns `Err(PregolyaError { code: "E-CHKPT-007", message: "CipherHeaderMissing: ...", .. })`. Verified by `test_BC_2_04_007_key_rotation_error()` and `test_BC_2_04_007_cipher_header_missing_error()`.

### AC-023 (traces to BC-2.04.001 EC-005 — async put_writes join-failure at run exit)
With `DurabilityTier::Async`, when all super-steps complete but the run-exit `join_all(put_writes_futures)` returns `Err` for one or more tasks, the run transitions to `failed` with `Err(PregolyaError { category: DURABILITY, code: "E-CHKPT-001", message: "CheckpointWriteFailed: put_writes for task '<task_id>' failed — backend error: <backend_error>", .. })`. The graph in-memory output is NOT returned to the caller; the run record status is `failed`. This is distinct from AC-004 ({EC-002}) which covers synchronous mid-run `put_writes` failures; EC-005 covers the deferred join-failure that surfaces only at run exit. Verified by `test_BC_2_04_001_async_put_writes_join_failure_at_run_exit()`.

### AC-024 (traces to BC-2.04.005 EC-007 — pending_writes reapply read/deserialize failure)
During `_reapply_writes_to_succeeded_nodes` crash recovery, if the storage query for `pending_writes` entries returns an I/O error (sub-case a) OR a retrieved entry's write value cannot be deserialized to the channel type (sub-case b — data corruption or schema-evolution incompatibility), recovery halts immediately with `Err(PregolyaError { component: CHKPT, category: DURABILITY, code: "E-CHKPT-003", message: "CheckpointReadFailed: cannot restore state for thread '<thread_id>' checkpoint '<checkpoint_id>': <reason>", .. })`. No task writes are re-applied; no node bodies execute. This reuses the E-CHKPT-003 code from AC-015 ({EC-006}) on a distinct code path. Verified by `test_BC_2_04_005_pending_writes_reapply_read_failure()` and `test_BC_2_04_005_pending_writes_reapply_deserialize_failure()`.

## Architecture Mapping

| Component | Module | Crate | Pure/Effectful |
|-----------|--------|-------|---------------|
| `storage_address(key: &SessionKey) -> StorageAddress` | `pregolya_checkpoint::session_index` | pregolya-checkpoint | Pure (deterministic bijection; VP-002 Kani proof vehicle `session_tenancy_harness`) |
| `SessionKey`, `StorageAddress` | `pregolya_checkpoint::session_index` | pregolya-checkpoint | Pure (data types; no I/O) |
| `CheckpointSaver` trait | `pregolya_checkpoint::saver` | pregolya-checkpoint | Pure (trait definition only; no I/O; `lib.rs` re-exports via `pub use`) |
| `CheckpointTuple`, `DurabilityTier` | `pregolya_checkpoint` (`lib.rs`) | pregolya-checkpoint | Pure (data types and enum definitions; no I/O) |
| `SqliteCheckpointSaver` (`put`, `put_writes`, `get_tuple`, `list`) | `pregolya_checkpoint::sqlite` | pregolya-checkpoint | Effectful Shell (SQLite reads and writes via `rusqlite`) |
| `MonotonicClock::get_next_version` | `pregolya_checkpoint::clock` | pregolya-checkpoint | Effectful Shell (reads persisted-max `CheckpointId` from SQLite; ADR-005 rev-2 cross-restart monotonicity) |
| `fork` | `pregolya_checkpoint::fork` | pregolya-checkpoint | Effectful Shell (writes parent-pointer checkpoint row to SQLite; no state payload copied) |
| `recovery` module | `pregolya_checkpoint::recovery` | pregolya-checkpoint | Effectful Shell (reads `pending_writes` table from SQLite to build committed-task set) |
| `EncryptedSerializer` | `pregolya_checkpoint::serializer` | pregolya-checkpoint | Effectful Shell (wraps `put` and `put_writes` with AES-256-GCM; no unencrypted write path) |
| `session_tenancy_harness` (VP-002 Kani stub) | `pregolya_checkpoint::proofs::session_tenancy` | pregolya-checkpoint | Pure (`#[cfg(kani)]`; stub body `todo!()` for Phase 6; proof vehicle for VP-002) |

**Subsystem anchor:** SS-04 owns this story's scope because SS-04 is the Checkpoint subsystem (pregolya-checkpoint crate) per ARCH-INDEX Subsystem Registry. Pure-core / effectful-shell boundary: `storage_address` and data types are the pure core; `SqliteCheckpointSaver`, `MonotonicClock`, `fork`, `recovery`, and `EncryptedSerializer` are effectful shells. The VP-002 Kani harness stub lives at `crates/pregolya-checkpoint/src/proofs/session_tenancy.rs`.

## Purity Classification

| Function / Type | Pure or Effectful | Reason |
|----------------|-------------------|--------|
| `storage_address(key: &SessionKey) -> StorageAddress` (`pregolya_checkpoint::session_index`) | Pure | Deterministic bijection; no database I/O; VP-002 Kani harness vehicle (`session_tenancy_harness`) |
| `SessionKey`, `StorageAddress`, `CheckpointId`, `DurabilityTier` | Pure | Data types and enum definitions; no I/O |
| `CheckpointSaver` trait | Pure | Trait definition only; no I/O side effects in the trait itself |
| `SqliteCheckpointSaver::put_writes` / `put` / `get_tuple` / `list` (`pregolya_checkpoint::sqlite`) | Effectful Shell | Reads and writes to SQLite via `rusqlite` |
| `MonotonicClock::get_next_version` (`pregolya_checkpoint::clock`) | Effectful Shell | Reads persisted-max `CheckpointId` from SQLite; ADR-005 rev-2 cross-restart monotonicity |
| `fork` (`pregolya_checkpoint::fork`) | Effectful Shell | Writes parent-pointer checkpoint row to SQLite; no state payload copied |
| `recovery` module (`pregolya_checkpoint::recovery`) | Effectful Shell | Reads `pending_writes` table from SQLite to build committed-task set |
| `EncryptedSerializer` (`pregolya_checkpoint::serializer`) | Effectful Shell | Applies AES-256-GCM to `put` and `put_writes`; no unencrypted write path |

## Token Budget Estimate

| Component | Estimated Tokens |
|-----------|-----------------|
| Story spec (this file) | ~7,000 |
| BC files (7 BCs: BC-2.04.001..007) | ~12,000 |
| VP-002 file | ~2,000 |
| ADR-005 (logical clock ordering) | ~1,500 |
| Architecture module-decomposition.md (SS-04 section) | ~1,200 |
| pregolya-checkpoint crate skeleton | ~4,000 |
| Test files | ~5,000 |
| **Total** | **~32,700** |

Exceeds the single-load threshold. Implementer strategy: load BCs in groups (BC-2.04.001/002 together for put_writes+durability; BC-2.04.003/004 for clock+fork; BC-2.04.005/006 for recovery+session-index; BC-2.04.007 standalone for encryption). Load only the group relevant to the current failing test.

## Tasks

- [ ] Create `pregolya-checkpoint/Cargo.toml`
- [ ] Create `pregolya-checkpoint/src/lib.rs` — `CheckpointTuple`, `DurabilityTier` enum; re-exports `CheckpointSaver` from `saver` via `pub use crate::saver::CheckpointSaver`
- [ ] Create `pregolya-checkpoint/src/session_index.rs` — `SessionKey`, `StorageAddress`, `storage_address` pure fn
- [ ] Create `pregolya-checkpoint/src/saver.rs` — DEFINE the `CheckpointSaver` TRAIT (method signatures for `put`, `put_writes`, `get_tuple`, `list`; journal-op signatures added later per S-1.29 Task 3); `lib.rs` re-exports from `saver`
- [ ] Create `pregolya-checkpoint/src/sqlite.rs` — `struct SqliteCheckpointSaver` (opaque fields) + `impl CheckpointSaver for SqliteCheckpointSaver` implementing `put_writes`, `put`, `get_tuple`, `list` (default Cargo feature `checkpoint-sqlite`); constructor `SqliteCheckpointSaver::new(path, Option<Arc<dyn Serializer + Send + Sync>>)` per BC-2.04.007 PRE-001/INV-005 DI seam
- [ ] Create `pregolya-checkpoint/src/clock.rs` — `MonotonicClock` implementing `get_next_version`, cross-restart persistence via persisted-max seeding (ADR-005 rev-2)
- [ ] Create `pregolya-checkpoint/src/fork.rs` — `fork` method producing parent-pointer checkpoint with no state copy
- [ ] Create `pregolya-checkpoint/src/recovery.rs` — crash recovery logic: read pending_writes, skip-on-reapply set enforcement
- [ ] Create `pregolya-checkpoint/src/encryption.rs` — `EncryptedSerializer` wrapping `CheckpointSaver`; symmetric coverage; E-CHKPT-004/007
- [ ] Write unit tests for all 24 ACs (`test_BC_2_04_001_async_put_writes_join_failure_at_run_exit`, `test_BC_2_04_005_pending_writes_reapply_read_failure`, `test_BC_2_04_005_pending_writes_reapply_deserialize_failure` for new ACs)
- [ ] Create `crates/pregolya-checkpoint/src/proofs/session_tenancy.rs` — `#[cfg(kani)]` `session_tenancy_harness` stub (body `todo!()` for Phase 6 formal hardening; VP-002)
- [ ] Add `pregolya-checkpoint` to workspace `Cargo.toml` members
- [ ] Run `just iter pregolya-checkpoint` — all tests green

## Previous Story Intelligence

- S-1.04 (Runnable Trait and Pipe) established the `Runnable` trait surface and `PregolyaError` used throughout. `CheckpointSaver` extends the same async-first, Arc-DI wiring pattern.
- S-1.02 (Error Policy Enforcement) established the `ErrorPolicy` propagation chain. `E-CHKPT-*` errors with `broken` severity halt execution per that policy.
- N/A for previous checkpoint stories — this is the first checkpoint story.

## Architecture Compliance Rules

Derived from `architecture/module-decomposition.md §pregolya-checkpoint` and ADR-005:

1. `storage_address` in `session_index.rs` MUST be a pure function (no database I/O, no async). This is required for Kani provability (VP-002). The function maps `SessionKey → StorageAddress` deterministically.
2. `CheckpointId` is `u64` (ADR-005 rev-2) — NOT a UUID type. `get_next_version` returns `u64` values monotonically greater than the current maximum.
3. `DurabilityTier::Sync` is the default — any constructor that does not explicitly specify the tier MUST default to `Sync`.
4. `put_writes` and `put` MUST both be encrypted when `EncryptedSerializer` is in the chain. There must be no code path that bypasses encryption.
5. Skip-on-reapply set: `{ERROR, ERROR_SOURCE_NODE, INTERRUPT, RESUME}`. `SCHEDULED` is NOT in this set. This must be enforced as a named const or enum discriminant set in the implementation.
6. Fork creates a checkpoint with `metadata.parents[checkpoint_ns] = parent_checkpoint_id` and NO state payload copy. The fork storage operation writes only the parent pointer, not all prior state.
7. All checkpoint records are append-only (BC-2.04.001 INV-005): no `UPDATE` or `DELETE` operations on checkpoint rows.
8. All constructors return `Result` per DI-008 (Library Constructor Result Contract). No panics in constructors.
9. `event_type` values used in this story that must be registered in the Canonical Structured Event Catalog: none mandatory for this story's core path (checkpoint operations are storage events, not agent-visible events). If tracing is added for observability, those event types must be registered.

## Library & Framework Requirements

Derived from `architecture/dependency-graph.md` external dependency table:

| Library | Version | Usage |
|---------|---------|-------|
| `rusqlite` | 0.31.x | SQLite backend for `SqliteCheckpointSaver` and `pending_writes` table |
| `serde` | workspace pin | Serialization of checkpoint payloads |
| `serde_json` | workspace pin | JSON encoding of checkpoint state |
| `aes-gcm` | 0.10.x | Symmetric encryption for `EncryptedSerializer` (AES-256-GCM) |
| `tokio` | workspace pin | Async runtime for async `CheckpointSaver` methods |
| `tracing` | workspace pin | Structured event logging |
| `pregolya-core` | workspace path | `PregolyaError`, `Runnable` |

**Forbidden Dependencies:** `pregolya-checkpoint` MUST NOT depend on `pregolya-graph` (checkpoint is a primitive that graph depends on, not the other way around). Build fails if this dependency appears.

## File Structure Requirements

Files to CREATE:
- `/pregolya-checkpoint/Cargo.toml`
- `/pregolya-checkpoint/src/lib.rs`
- `/pregolya-checkpoint/src/session_index.rs` — `SessionKey`, `StorageAddress`, `storage_address` pure fn
- `/pregolya-checkpoint/src/proofs/session_tenancy.rs` — VP-002 Kani harness stub (`session_tenancy_harness`; body `todo!()` for Phase 6)
- `/pregolya-checkpoint/src/saver.rs` — `CheckpointSaver` trait definition only (no concrete struct/impl)
- `/pregolya-checkpoint/src/sqlite.rs` — `struct SqliteCheckpointSaver` + `impl CheckpointSaver for SqliteCheckpointSaver` (default Cargo feature `checkpoint-sqlite`)
- `/pregolya-checkpoint/src/clock.rs`
- `/pregolya-checkpoint/src/fork.rs`
- `/pregolya-checkpoint/src/recovery.rs`
- `/pregolya-checkpoint/src/encryption.rs`
- `/pregolya-checkpoint/tests/put_writes_tests.rs`
- `/pregolya-checkpoint/tests/durability_tier_tests.rs`
- `/pregolya-checkpoint/tests/clock_tests.rs`
- `/pregolya-checkpoint/tests/fork_tests.rs`
- `/pregolya-checkpoint/tests/recovery_tests.rs`
- `/pregolya-checkpoint/tests/session_index_tests.rs`
- `/pregolya-checkpoint/tests/encryption_tests.rs`

Files to MODIFY:
- `/Cargo.toml` — add `"pregolya-checkpoint"` to `[workspace] members`

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Task produces zero writes (zero-output node) | `put_writes(config, [], task_id)` is called; task recorded committed; super-step proceeds normally |
| EC-002 | `DurabilityTier::Exit` — no put_writes mid-run | Zero `put_writes` calls during run; all writes submitted as one `put` at graph exit; crash loses in-progress run |
| EC-003 | Fork then resume from fork checkpoint | Fork checkpoint's parent pointer enables traversal back to parent state; no data duplication |
| EC-004 | Encrypted saver + wrong key on read | `Err(E-CHKPT-007 CipherHeaderMissing)` — classified INTERNAL; caller cannot decrypt without the original key |
| EC-005 | `SCHEDULED` channel task on crash-resume | `SCHEDULED` is NOT in skip-on-reapply set; it is re-enqueued and executed on resume |
| EC-006 | `DurabilityTier::Async`; all tasks complete; run exits; `join_all(put_writes_futures)` returns `Err` for one task | Run transitions to `failed`; `Err(E-CHKPT-001 CheckpointWriteFailed)`; graph output NOT returned to caller (AC-023) |
| EC-007 | Crash recovery: `get_tuple` succeeds; `pending_writes` query returns I/O error OR a pending_writes entry fails to deserialize | `Err(E-CHKPT-003 CheckpointReadFailed)`; recovery halts; no task writes re-applied; no node bodies execute (AC-024) |

## Changelog

| Version | Date | Change | Source |
|---------|------|--------|--------|
| 1.6 | 2026-09-10 | DC-66/F-PDC66-02: saver/sqlite module split — `CheckpointSaver` trait definition moved to `pregolya_checkpoint::saver` (`saver.rs`); `lib.rs` re-exports trait via `pub use`. Concrete `struct SqliteCheckpointSaver` + `impl CheckpointSaver` placed in `pregolya_checkpoint::sqlite` (`sqlite.rs`; default Cargo feature `checkpoint-sqlite`). Architecture Mapping and Purity Classification updated (SqliteCheckpointSaver module `saver` → `sqlite`; CheckpointSaver trait row split from `lib.rs` to `saver`). Tasks and File Structure updated: lib.rs task scoped to CheckpointTuple/DurabilityTier + re-export; saver.rs task now trait-only; new sqlite.rs task added; sqlite.rs CREATE row added. | DC-66 F-PDC66-02 |
| 1.5 | 2026-09-10 | DC-64/F-PDC64-01: BC-2.04.007 EC-003 retired → AC-021 retired via strikethrough; no coverage gap — retired EC tested unreachable runtime empty-key path now compile-guaranteed by `EncryptedSerializer::new(&[u8;32])`. DC-65/F-PDC65-02: module path `pregolya_checkpoint::encryption` → `pregolya_checkpoint::serializer` in Architecture Mapping and Purity Classification tables. | DC-64 F-PDC64-01, DC-65 F-PDC65-02 |
| 1.4 | 2026-09-02 | round-79/F-P2A251-02: BC table title cells corrected to verbatim canonical H1 per POL-7/F-P2A251-02. | round-79 F-P2A251-02 |
| 1.3 | 2026-08-26 | SW-2/bc-completeness-hardening: BC-2.04.001 → AC-023 (EC-005 async join-failure at run exit → run failed, E-CHKPT-001; graph output NOT returned); BC-2.04.005 → AC-024 (EC-007 pending_writes reapply read/deserialize failure → E-CHKPT-003). EC-006/EC-007 added. | SW-2 |
| 1.2 | 2026-08-24 | P2A-043 F-05: prose ordinal cross-refs converted to stable tags | P2A-043 F-05 |
| 1.1 | 2026-08-24 | ADR-027 M3: AC traces re-cited to stable clause anchors | M3/ADR-027 |
| 1.0 | 2026-08-18 | Initial authoring | story-writer |
