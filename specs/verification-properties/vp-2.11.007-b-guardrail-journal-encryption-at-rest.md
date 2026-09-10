---
document_type: verification-property
level: L4
id: VP-2.11.007-B
title: "GuardrailJournal Encryption at Rest — Raw Bytes in guardrail_journal Table Are Not Valid Plaintext GuardrailEntry"
version: "1.2"
status: draft
producer: architect
timestamp: 2026-09-10T00:00:00Z
phase: 3
inputs:
  - .factory/specs/behavioral-contracts/ss-11/BC-2.11.007.md
  - .factory/specs/behavioral-contracts/ss-04/BC-2.04.007.md
input-hash: "1eba69d"
traces_to: VP-INDEX.md
source_bc: BC-2.11.007
module: checkpoint::serializer
proof_method: integration
feasibility: feasible
verification_lock: false
proof_completed_date: null
proof_file_hash: null
# Lifecycle fields (DF-030)
lifecycle_status: active
introduced: DC-62
modified: [DC-63, DC-64]
deprecated: null
deprecated_by: null
replacement: null
retired: null
withdrawn: null
withdrawal_reason: null
removed: null
removal_reason: null
# VP catalog fields
bc_anchor: "BC-2.11.007 {INV-005} + BC-2.04.007 {INV-006}"
di_anchor: DI-012
crate: pregolya-checkpoint
tool: integration
priority: P1
harness_fn: "n/a (integration test)"
file: vp-2.11.007-b-guardrail-journal-encryption-at-rest.md
changelog:
  - "1.2 (DC-64/F-PDC64-01/F-PDC64-02/F-PDC64-03/F-PDC64-04/2026-09-10, architect): ROOT-CAUSE FIX — all four DC-64 compile-blocking findings closed by rewriting §Proof Harness to the abstract CheckpointTestFixture pattern (mirrors VP-2.11.007-A §GraphTestFixture). F-PDC64-04 (HIGH): Remove concrete CheckpointSaverSqlite::new(...) calls from harness; replace with CheckpointTestFixture::with_encryption(KEY).await and CheckpointTestFixture::without_encryption().await — fixture abstracts saver construction via DI seams (Phase 3 implementer obligation per CLAUDE.md §Arc-DI wiring). F-PDC64-01 (HIGH): Remove EncryptedSerializer::new(...).expect(...) — EncryptedSerializer::new(key: &[u8; 32]) -> Self is INFALLIBLE; .expect() on Self does not compile; compile-time key-length enforcement via &[u8; 32] eliminates runtime empty-key path; fixture now handles construction internally; see interface-definitions.md §Serializer adjudication (DC-64). F-PDC64-02 (MED): Replace phantom enc_ser_ref.decrypt(&raw_bytes) with canonical Serializer trait method fixture.serializer.deserialize(&raw_bytes) -> Result<Vec<u8>, PregolyaError> (interface-definitions.md §Serializer; NO decrypt method exists on Serializer or EncryptedSerializer); same fix applied to §Formal Invariant pseudocode; drop 'EncryptedSerializer exposes decrypt()' Proof Obligation row. F-PDC64-03 (MED): module checkpoint::encryption -> checkpoint::serializer throughout (frontmatter module:, §Property Statement, §Formal Invariant, §BC Traceability Architecture Module row, §Proof Harness SCOPE NOTE) — interface-definitions.md §Serializer §Implementors line is Source-of-Truth (CLAUDE.md precedence rule #3); three architecture registries swept in same burst: module-decomposition.md §pregolya-checkpoint (SS-04), purity-boundary-map.md §Effectful Shell, module-criticality.md §Module Classification. BC-2.04.007 EC-003 adjudication: EncryptedSerializer::new is infallible; EC-003 empty-key path is invalidated; product-owner routing documented in §BC Contradictions Flagged. input-hash refreshed (BC inputs edited in parallel PO burst)."
  - "1.1 (DC-63/F-PDC63-02/2026-09-10, architect): F-PDC63-02 [HIGH] Rewrite §Proof Harness Skeleton to use canonical constructors — fixes two Red Gate compile errors + two additional defects found in full compile audit. (1) E0639: both test functions constructed GuardrailEntry via struct literal; #[non_exhaustive] forbids this outside the defining crate (pregolya-core). Replaced with GuardrailEntry::new(boundary, result, provenance, timestamp_ms) — canonical constructor added to interface-definitions.md §GuardrailHook in this same burst. (2) E0599: both test functions called ProvenanceTag::default(); ProvenanceTag derives Debug/Clone/PartialEq/Serialize/Deserialize only — no Default. Replaced with ProvenanceTag::new(BoundaryType::ToolResult, uuid::Uuid::nil(), 0) — canonical constructor added in same burst. (3) E0308 (hidden by E0639 — would surface after fixing 1+2): entry.clone() passed where &GuardrailEntry expected by append_guardrail_entry trait signature; replaced with &entry. (4) E0433 (corpus-gap, compile-audit follow-up per coordinator DC-63): both test functions used pregolya_core::RunId::new_v4() for the run_id: Uuid argument — RunId has NO canonical type definition in the spec corpus (corpus-wide grep returned nothing; Gate #31 note in interface-definitions.md confirms RunId is a StreamEvent wire field distinct from the Uuid used in CheckpointSaver ops); replaced with uuid::Uuid::new_v4() to match the canonical run_id: Uuid trait signature. BoundaryType added to use import. GuardrailResult::Fail{reason: sentinel, severity: High} sentinel preserved in both tests — non-vacuous assertion intact (TD-VSDD-059)."
  - "1.0 (DC-62/2026-09-10, architect): Minted. GuardrailJournal encryption-at-rest integration P1. BC-2.11.007 {INV-005} + BC-2.04.007 {INV-006}; DI-012; checkpoint::encryption; pregolya-checkpoint; Phase 3. Raw bytes written to guardrail_journal table by init_guardrail_journal + append_guardrail_entry under EncryptedSerializer are NOT valid plaintext GuardrailEntry; after decryption with the active key they round-trip to the original GuardrailEntry values. Pattern: mirror BC-2.04.007 inspector-reads-raw-storage. Census 42→43; integration 13→14; P1 35→36."
---

# VP-2.11.007-B: GuardrailJournal Encryption at Rest — Raw Bytes in guardrail_journal Table Are Not Valid Plaintext GuardrailEntry

## Property Statement

When `EncryptedSerializer` is active on `CheckpointSaverSqlite`, the raw bytes written
to the `guardrail_journal` SQLite table by `init_guardrail_journal` and
`append_guardrail_entry` are **not** valid plaintext-deserialized `GuardrailEntry` values.
After decryption with the active key, those bytes are valid msgpack and deserialize to
the original `GuardrailEntry` values (boundary, result, provenance, timestamp_ms).
The encryption invariant covers the storage layer (`checkpoint::serializer`), not the
application layer; the `GuardrailJournal` API surface is unchanged from the caller
perspective. NOTE: `transform_applied` is not a field on `GuardrailEntry` (O-PDC34-A).
NOTE: `EncryptedSerializer` is the canonical concrete implementor of
`core::serializer::Serializer`; it is wired via `Option<Arc<dyn Serializer + Send + Sync>>`
at `CheckpointSaverSqlite` construction (BC-2.04.007 {INV-005} DI seam).

## Source Contract

- BC-2.11.007 {INV-005}: When `EncryptedSerializer` is wired into `CheckpointSaverSqlite`,
  all bytes written to the `guardrail_journal` table are encrypted at rest; raw table bytes
  must not be valid plaintext `GuardrailEntry` values.
- BC-2.04.007 {INV-006}: The encryption-at-rest guarantee extends to the `guardrail_journal`
  table in addition to state and event payloads; `EncryptedSerializer` covers all checkpoint
  tables written by `CheckpointSaverSqlite`.
- BC-2.04.007 {INV-005}: `CheckpointSaverSqlite` accepts `Option<Arc<dyn Serializer + Send + Sync>>`;
  `EncryptedSerializer` is the canonical concrete implementor providing AES-GCM
  (or equivalent) encryption; when `Some(enc_ser)` is supplied, all bytes written to SQLite
  are encrypted.
- DI-012: "Guardrail Coverage at Ingress Boundaries" — guardrail journal records must be
  durable and tamper-proof; encryption at rest is part of the audit integrity guarantee
  (CAP-047; security-audit log must not be readable from raw storage).

## Proof Method

| Method | Tool | Bounded? | Coverage |
|--------|------|----------|----------|
| Integration test (inspector-reads-raw-storage) | integration (pregolya-checkpoint test harness) | Yes — 1 GuardrailEntry with fixed sentinel string; direct SQLite query | Storage-layer encryption: raw bytes NOT valid plaintext; decrypted bytes ARE valid GuardrailEntry. Plus a baseline-without-encryption case confirming the plaintext assertion is not a false negative. |

## Formal Invariant

```
∀ run_id: RunId, entry: GuardrailEntry,
  // Abstract fixture pattern (F-PDC64-04): concrete saver wiring is a Phase 3 obligation
  let fixture = CheckpointTestFixture::with_encryption(key),
  let () = fixture.saver.init_guardrail_journal(run_id),
  let () = fixture.saver.append_guardrail_entry(run_id, &entry),
  let raw = sqlite_select_guardrail_journal_raw_bytes(fixture.db_path, run_id, seq=0):

  // BC-2.11.007 {INV-005} / BC-2.04.007 {INV-006}
  rmp_serde::from_slice::<GuardrailEntry>(&raw).is_err()
  ∧ ∀ sentinel ∈ legible_plaintext_fields(entry):
      ¬contains(&raw, sentinel)
  // Decryption round-trip via Serializer::deserialize (canonical trait method — F-PDC64-02;
  // there is NO decrypt method on Serializer or EncryptedSerializer)
  ∧ let dec = fixture.serializer.deserialize(&raw): dec.is_ok()
  ∧ rmp_serde::from_slice::<GuardrailEntry>(&dec.unwrap()).is_ok()
  ∧ rmp_serde::from_slice::<GuardrailEntry>(&dec.unwrap()).unwrap()
      == entry

// NOTE: transform_applied field absent (O-PDC34-A)
// NOTE: no-encryption baseline: same pipeline with CheckpointTestFixture::without_encryption()
//       → raw bytes ARE valid plaintext GuardrailEntry (baseline confirms assertion is non-vacuous)
```

(BC-2.11.007 {INV-005} + BC-2.04.007 {INV-006}; DI-012 Guardrail Coverage at Ingress Boundaries)

## Proof Harness Skeleton

```rust
// File: crates/pregolya-checkpoint/tests/guardrail_journal_encryption_at_rest.rs
// Phase 3 integration test — storage-layer encryption for guardrail_journal table
// VP module: checkpoint::serializer (pregolya-checkpoint)
// VP anchor: BC-2.11.007 {INV-005} + BC-2.04.007 {INV-006} — at-rest encryption
//
// Pattern: mirror BC-2.04.007 "inspector-reads-raw-storage"
// Inspector pattern: write through the API, then read raw SQLite bytes directly
// (bypassing the API), assert bytes are NOT plaintext-deserializable, then
// deserialize (decrypt) via Serializer::deserialize and assert they ARE
// deserializable with the expected field values.
//
// SCOPE NOTE:
//   checkpoint::serializer hosts EncryptedSerializer — the canonical implementor of
//   core::serializer::Serializer (interface-definitions.md §Serializer) that encrypts
//   all bytes before SQLite write.
//   CheckpointSaver accepts Option<Arc<dyn Serializer + Send + Sync>> at construction;
//   Some(enc_ser) activates at-rest encryption for ALL checkpoint tables including
//   guardrail_journal (BC-2.04.007 {INV-005}/{INV-006}).
//   This VP tests the storage layer only; the GuardrailJournal API surface
//   (graph::provenance → checkpoint_store.append_guardrail_entry) is tested by
//   VP-2.11.007-A (crates/pregolya-graph/tests/).
//
// ABSTRACT FIXTURE PATTERN (F-PDC64-04):
//   CheckpointTestFixture wires CheckpointSaverSqlite with optional EncryptedSerializer
//   via the CheckpointSaver + Serializer DI seams — analogous to GraphTestFixture in
//   VP-2.11.007-A. Exposes:
//     fixture.saver: Arc<dyn CheckpointSaver> — the initialized saver
//     fixture.db_path: std::path::PathBuf   — path for raw SQLite inspector access
//     fixture.serializer: Arc<dyn Serializer + Send + Sync>
//                                            — active serializer (with_encryption only)
//   Phase 3 obligation: CheckpointTestFixture infrastructure (implementer).
//   EncryptedSerializer::new(key: &[u8; 32]) -> Self is INFALLIBLE — fixture calls it
//   without .expect(); see interface-definitions.md §Serializer v3.20 adjudication.
//
// IMPORT NOTE: all types use qualified paths; no glob imports.
// GuardrailEntry fields: boundary: IngressBoundary, result: GuardrailResult,
//   provenance: ProvenanceTag, timestamp_ms: u64  (NO transform_applied — O-PDC34-A).
// GuardrailResult::Fail is a struct variant: Fail { reason: String, severity: GuardrailSeverity }

use pregolya_core::guardrail::{
    BoundaryType, GuardrailEntry, GuardrailResult, GuardrailSeverity,
    IngressBoundary, ProvenanceTag,
};

/// Encryption-at-rest property:
/// raw bytes in guardrail_journal table must NOT be valid plaintext GuardrailEntry.
/// After deserialization (decryption) via Serializer::deserialize they MUST round-trip
/// to the original entry values.
#[tokio::test]
async fn guardrail_journal_entries_are_encrypted_at_rest() {
    // BC-2.11.007 {INV-005} / BC-2.04.007 {INV-006}:
    // raw bytes must NOT be valid plaintext GuardrailEntry.
    const KEY: &[u8; 32] = b"test-encryption-key-32bytes-pad!";
    // CheckpointTestFixture::with_encryption wires EncryptedSerializer (infallible new)
    // and CheckpointSaverSqlite via the DI seams — no concrete saver type named in harness
    // (F-PDC64-04 abstract-fixture discipline, matching VP-2.11.007-A §GraphTestFixture).
    let fixture = CheckpointTestFixture::with_encryption(KEY).await;

    // uuid::Uuid::new_v4() — CheckpointSaver methods take run_id: Uuid directly;
    // RunId is a StreamEvent wire field; Gate #31 note: "RunId is distinct from the
    // Uuid used in checkpoint store ops" — Uuid matches the canonical trait signature.
    let run_id = uuid::Uuid::new_v4();
    fixture.saver.init_guardrail_journal(run_id).await
        .expect("init_guardrail_journal must succeed");

    // Sentinel string must appear in plaintext but not in encrypted bytes
    let sentinel = "test-plaintext-sentinel";
    // GuardrailEntry::new + ProvenanceTag::new — canonical cross-crate constructors
    // (struct literal forbidden outside pregolya-core per #[non_exhaustive]).
    // GuardrailResult::Fail{reason: sentinel} preserves the non-vacuous plaintext-absence
    // assertion: Pass unit-variant carries no legible string; only Fail{reason} does
    // (TD-VSDD-059).
    // BoundaryType::ToolResult in ProvenanceTag is the audit-vocabulary name for the
    // ToolResult ingress boundary (distinct from IngressBoundary::ToolResult wire name;
    // OBS-2 in entities-server.md §GuardrailJournal).
    // uuid::Uuid::nil() is a fixed all-zeros test sentinel — no Default needed.
    let entry = GuardrailEntry::new(
        IngressBoundary::ToolResult,
        GuardrailResult::Fail {
            reason: sentinel.to_string(),
            severity: GuardrailSeverity::High,
        },
        ProvenanceTag::new(BoundaryType::ToolResult, uuid::Uuid::nil(), 0),
        1_700_000_000_000_u64,
    );
    fixture.saver.append_guardrail_entry(run_id, &entry).await
        .expect("append_guardrail_entry must succeed");

    // Inspector: read raw bytes from SQLite directly via fixture.db_path (bypassing API)
    let pool = sqlx::SqlitePool::connect(
        &format!("sqlite:{}", fixture.db_path.display())
    ).await.expect("direct SQLite connection must succeed");
    let row: (Vec<u8>,) = sqlx::query_as(
        "SELECT data FROM guardrail_journal WHERE run_id = ? ORDER BY seq ASC LIMIT 1"
    )
    .bind(run_id.to_string())
    .fetch_one(&pool)
    .await
    .expect("guardrail_journal row must exist after append_guardrail_entry");
    let raw_bytes = row.0;

    // BC-2.11.007 {INV-005} / BC-2.04.007 {INV-006}: raw bytes must NOT be plaintext
    let plaintext_attempt = rmp_serde::from_slice::<
        pregolya_core::guardrail::GuardrailEntry
    >(&raw_bytes);
    assert!(
        plaintext_attempt.is_err(),
        "raw guardrail_journal bytes must NOT deserialize as plaintext GuardrailEntry"
    );
    assert!(
        !raw_bytes
            .windows(sentinel.len())
            .any(|w| w == sentinel.as_bytes()),
        "raw bytes must not contain plaintext sentinel string"
    );

    // Deserialize (decrypt) via canonical Serializer trait method `deserialize`
    // (interface-definitions.md §Serializer: fn deserialize(&self, ciphertext: &[u8])
    //  -> Result<Vec<u8>, PregolyaError>; there is NO separate `decrypt` method —
    //  F-PDC64-02 correction).
    // fixture.serializer is Arc<dyn Serializer + Send + Sync> configured with KEY.
    let decrypted = fixture.serializer.deserialize(&raw_bytes)
        .expect("deserialization (decryption) with the active key must succeed");
    let decoded: pregolya_core::guardrail::GuardrailEntry =
        rmp_serde::from_slice(&decrypted)
            .expect("decrypted bytes must deserialize to GuardrailEntry");

    assert_eq!(
        decoded.boundary,
        pregolya_core::guardrail::IngressBoundary::ToolResult
    );
    assert!(
        matches!(
            &decoded.result,
            pregolya_core::guardrail::GuardrailResult::Fail { reason, .. }
            if reason == sentinel
        ),
        "decoded result must be Fail with original sentinel reason"
    );
    assert_eq!(decoded.timestamp_ms, 1_700_000_000_000_u64);

    pool.close().await;
}

/// Baseline (non-encrypted):
/// without EncryptedSerializer, raw bytes ARE valid plaintext GuardrailEntry.
/// This confirms that the encrypted-path assertion above is non-vacuous.
#[tokio::test]
async fn guardrail_journal_baseline_no_encryption_is_plaintext() {
    // CheckpointTestFixture::without_encryption wires None serializer — plaintext path.
    // No concrete CheckpointSaverSqlite::new in harness (F-PDC64-04 abstract-fixture).
    let fixture = CheckpointTestFixture::without_encryption().await;

    let run_id = uuid::Uuid::new_v4();
    fixture.saver.init_guardrail_journal(run_id).await
        .expect("init_guardrail_journal must succeed");

    let sentinel = "baseline-sentinel-plaintext";
    // Same canonical constructors — struct literal forbidden outside pregolya-core
    // per #[non_exhaustive].
    let entry = GuardrailEntry::new(
        IngressBoundary::ToolResult,
        GuardrailResult::Fail {
            reason: sentinel.to_string(),
            severity: GuardrailSeverity::High,
        },
        ProvenanceTag::new(BoundaryType::ToolResult, uuid::Uuid::nil(), 0),
        1_700_000_001_000_u64,
    );
    fixture.saver.append_guardrail_entry(run_id, &entry).await
        .expect("append_guardrail_entry must succeed");

    let pool = sqlx::SqlitePool::connect(
        &format!("sqlite:{}", fixture.db_path.display())
    ).await.expect("direct SQLite connection must succeed");
    let row: (Vec<u8>,) = sqlx::query_as(
        "SELECT data FROM guardrail_journal WHERE run_id = ? ORDER BY seq ASC LIMIT 1"
    )
    .bind(run_id.to_string())
    .fetch_one(&pool)
    .await
    .expect("guardrail_journal row must exist");
    let raw_bytes = row.0;

    // Without encryption, raw bytes ARE valid plaintext (baseline confirms non-vacuous)
    let plaintext_result = rmp_serde::from_slice::<
        pregolya_core::guardrail::GuardrailEntry
    >(&raw_bytes);
    assert!(
        plaintext_result.is_ok(),
        "without EncryptedSerializer, raw bytes MUST deserialize as plaintext GuardrailEntry"
    );

    pool.close().await;
}
```

Note: `CheckpointTestFixture::with_encryption(key)` wires `EncryptedSerializer`
(infallible `new(key: &[u8; 32]) -> Self`; interface-definitions.md §Serializer v3.20
adjudication — no `.expect()` needed) and `CheckpointSaverSqlite` via the
`Option<Arc<dyn Serializer + Send + Sync>>` DI seam (BC-2.04.007 {INV-005}).
`fixture.db_path` exposes the SQLite file for the inspector — `sqlx::SqlitePool`
reads the `data` column of `guardrail_journal` directly, bypassing the checkpoint API.
`fixture.serializer.deserialize(&raw_bytes)` calls the canonical `Serializer::deserialize`
method (interface-definitions.md §Serializer: `fn deserialize(&self, ciphertext: &[u8])
-> Result<Vec<u8>, PregolyaError>`; there is NO `decrypt` method — F-PDC64-02);
`fixture.serializer` is `Arc<dyn Serializer + Send + Sync>` configured with the active key.
The sentinel string `"test-plaintext-sentinel"` must be absent from raw bytes under
encryption and present under the plaintext baseline — non-vacuous assertion (TD-VSDD-059).
`GuardrailResult::Fail` is a struct variant requiring `{ reason: String, severity: GuardrailSeverity }`
construction (DC-57 struct-variant discipline). `transform_applied` is not a field (O-PDC34-A).

## BC Traceability

| Source | BC / Invariant |
|--------|---------------|
| Primary BC | BC-2.11.007 {INV-005} — when EncryptedSerializer is active, guardrail_journal raw bytes must not be valid plaintext GuardrailEntry (PO adding {INV-005} in DC-62 parallel burst) |
| Co-BC | BC-2.04.007 {INV-006} — encryption-at-rest coverage extends to guardrail_journal table; all tables written by CheckpointSaverSqlite are covered (PO adding {INV-006} in DC-62 parallel burst) |
| DI Anchor | DI-012 — Guardrail Coverage at Ingress Boundaries; durable audit log must not be readable from raw storage |
| Encryption seam | BC-2.04.007 {INV-005} — CheckpointSaverSqlite DI seam for Option<Arc<dyn Serializer + Send + Sync>> |
| Architecture Module | checkpoint::serializer (pregolya-checkpoint) — EncryptedSerializer lives here; CRITICAL tier per module-criticality.md |
| Subsystem | SS-04 (Checkpoint & Persistence) / SS-11 (Guardrails) |

## BC Contradictions Flagged

**BC-2.04.007 EC-003 — EncryptedSerializer::new fallibility contradiction (DC-64
adjudication; routed to product-owner via orchestrator per CLAUDE.md Companion Principle):**
`interface-definitions.md §Serializer` canonicalizes `pub fn new(key: &[u8; 32]) -> Self`
(infallible). BC-2.04.007 EC-003 implies a fallible constructor accepting `&[u8]` with
`E-CORE-005 EmptyEncryptionKey` raised at construction (runtime empty-key path).

**Architect adjudication:** The `&[u8; 32]` typed form is canonical (production-grade choice):
the fixed-size array type provides compile-time key-length enforcement; the Rust type system
rejects keys of any length other than 32 bytes before runtime. The runtime empty-key path
(E-CORE-005 at construction) is UNREACHABLE when `new` accepts `&[u8; 32]`.

**Product-owner action required:** (1) Retire or update BC-2.04.007 EC-003 — the `E-CORE-005
EmptyEncryptionKey` construction path is invalidated by the `&[u8; 32]` type; (2) If
`E-CORE-005` is not needed elsewhere in the error taxonomy, retire it; (3) If key-validity
errors are still needed at a different boundary (e.g., key rotation), document the correct
error site. See `interface-definitions.md §Serializer v3.20` for the canonical infallibility
rationale. Architect cannot edit BC files per CLAUDE.md Companion Principle §Routing.

VP-2.11.007-A covers the write-completeness property (graph::provenance, pregolya-graph) and
does not overlap with this VP's storage-layer encryption concern (checkpoint::serializer,
pregolya-checkpoint). The two VPs are complementary, not contradictory.

## Feasibility Assessment

| Factor | Assessment | Notes |
|--------|-----------|-------|
| Side effects | Yes — SQLite on-disk write required for raw-byte inspection | Integration test required; in-process tempfile; no external service |
| Fixtures | tempfile::tempdir() + sqlx::SqlitePool direct inspector query | No GraphTestFixture needed; storage-layer concern only |
| Baseline case | Non-encrypted path included in same test file | Confirms encryption assertion is non-vacuous (production-grade default) |
| Runtime availability | pregolya-checkpoint in-process; tempfile SQLite | Ships with SS-04 wave |
| Reference pattern | BC-2.04.007 inspector-reads-raw-storage pattern | EncryptedSerializer already tests state/event payload encryption; guardrail_journal extends same coverage |
| Estimated CI time | ~2 min per run | In-process tempfile only; no network; no external service |
| Confidence | HIGH | Property is a boolean membership check on raw bytes; direct SQLite inspector is definitive |

## Proof Obligations

| Obligation | Status | Notes |
|------------|--------|-------|
| BC-2.11.007 {INV-005} active | Phase 3 obligation | PO minting in DC-62 parallel burst |
| BC-2.04.007 {INV-006} active | Phase 3 obligation | PO minting in DC-62 parallel burst |
| CheckpointTestFixture wires CheckpointSaverSqlite + optional EncryptedSerializer via DI seams | Phase 3 obligation | Implementer; Arc<dyn CheckpointSaver> + Arc<dyn Serializer + Send + Sync> exposed on fixture |
| CheckpointSaver implementor calls Serializer::serialize on all guardrail_journal write ops | Phase 3 obligation | Implementer; interface-definitions.md §CheckpointSaver encryption note |
| Test compiles against live checkpoint::serializer API | Phase 3 Red Gate | Pre-delivery |

## Lifecycle

| Phase | Action |
|-------|--------|
| Phase 1b | VP minted (draft); BC-2.11.007 {INV-005} and BC-2.04.007 {INV-006} authored by PO |
| Phase 3 (SS-04 wave) | Failing test written (Red Gate); implementation drives green |
| Phase 3 (SS-04 delivery) | VP status → active; merge gates VP-2.11.007-B green |
| Phase 6 | VP status reviewed; encryption correctness already covered by at-rest integration test |
