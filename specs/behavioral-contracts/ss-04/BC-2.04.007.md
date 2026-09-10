---
document_type: behavioral-contract
level: L3
bc_id: BC-2.04.007
version: "1.15"
status: active
producer: product-owner
timestamp: 2026-09-10T00:00:00Z
phase: 1a
inputs:
  - .factory/specs/domain-spec/L2-INDEX.md
  - .factory/specs/domain-spec/capabilities-p0.md
  - .factory/semport/graph/behavioral-intent.md
input-hash: "01b5f65"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
traces_to: domain-spec/L2-INDEX.md
origin: greenfield
subsystem: SS-04
capability: CAP-005
lifecycle_status: active
introduced: v1.0.0-greenfield
changelog:
  - "1.2 (ADV-P1D-PASS-27): F-P27-02 add E-CHKPT-004 EncryptionKeyRotationFailed code name throughout BC body (description, PC4, PC5, EC-001, EC-002, test vector 3) — reverse-anchor fix; error-taxonomy.md corrected SECURITY→INTERNAL per this BC's authoritative category."
  - "1.3 (ADV-P1D-PASS-56-COMPLETION): Gate #30 second-pass census — EC-003 (empty key material), EC-004 (missing cipher header in legacy blob), and the empty-key TV row all had PregolyaError constructions without code fields. Added: code: E-CORE-005 (ValidationFailed) to EC-003 and TV empty-key row; code: E-CHKPT-007 (CipherHeaderMissing) minted this burst for EC-004 — unencrypted legacy blob in encrypted store is a distinct INTERNAL invariant violation from E-CHKPT-004 (key rotation failure)."
  - "1.4 (2026-07-15, F-P78-SWEEP/D18-P78-A): Four message-prefix corrections across two error codes. (1) E-CHKPT-004 PC5: added 'EncryptionKeyRotationFailed:' prefix to message string. (2) E-CHKPT-004 EC-002: same correction. (3) E-CHKPT-004 test vector (key-v2 rotation row): added 'EncryptionKeyRotationFailed:' prefix. (4) E-CHKPT-007 EC-004: added 'CipherHeaderMissing:' prefix to message string. Taxonomy E-CHKPT-004 corrected from wrapper format 'checkpoint state encryption key rotation error: <reason>' to direct '<reason>' (BC wins; no wrapper). Taxonomy E-CHKPT-007 corrected from elaborate key/path format to 'CipherHeaderMissing: missing cipher header: blob may be unencrypted' (BC wins on content)."
  - "1.5 (F-P108-02, 2026-07-18): PC4 struct field name corrected from `source` to `message` for intra-BC consistency. PC4 used `{ source: <reason> }` while PC5, EC-002, and the key-v2 TV all use `{ message: \"EncryptionKeyRotationFailed: ...<detail>...\" }`. Root cause: v1.4 (F-P78-SWEEP) added the 'EncryptionKeyRotationFailed:' prefix to 4 sites but missed PC4 — the struct in PC4 still used the old `source` field name from the pre-v1.4 era. Fix: PC4 now reads `{ message: \"EncryptionKeyRotationFailed: <reason>\" }` consistent with all other struct sites in this BC and with the taxonomy 'EncryptionKeyRotationFailed: <reason>' message format."
  - "1.6 (F-P112-02, 2026-07-18): E-CORE-005 message canonicalization. EC-003 message reworded from 'EncryptedSerializer: key material must be non-empty' to 'Validation failed for 'key_material': must be non-empty' to conform to canonical E-CORE-005 taxonomy format (Validation failed for '<field>': <reason>). TV bare form unchanged — PASS-ABBREV via EC-003."
  - "1.7 (2026-07-19, F-P114-01 anchor-class sweep, burst 117): Architecture Anchors updated from nonexistent 'architecture/pregolya-checkpoint.md' to 'architecture/module-decomposition.md §pregolya-checkpoint' — checkpoint::encryption row (at-rest encryption covering state AND event payloads; rotation error propagation). No BC body content changed."
  - "1.8 (notation-sweep-wave-b-ss04/2026-07-29): Class 3 error-construction notation sweep (Wave B batch B4). Added `..` rest-pattern marker to 8 PregolyaError observations with elided fields: Description inline (E-CHKPT-004 cite), PC4 inline, PC5 inline, EC-001 table cell, EC-002 table cell, EC-003 table cell, EC-004 table cell, and test-vector empty-key row (ADR-010 §Error-Construction Notation Canon, Class 3)."
  - "1.9 (M1/ADR-027/2026-08-23): stable clause anchors {PC/INV/PRE-NNN} added; purely additive, no content change."
  - "1.10 (F-P2A123-01/2026-08-28): §Story Anchor backfilled to S-1.10; §Architecture Module confirmed as pregolya-checkpoint — from STORY-INDEX forward map (SS-04 coverage map) and self §Architecture Anchors (module-decomposition.md §pregolya-checkpoint). No behavioral change."
  - "1.11 (round-52/F-P2A216-02/2026-08-31): DI seam applied to {PRE-001} and {INV-005} — `CheckpointSaver` accepts `Option<Arc<dyn Serializer + Send + Sync>>` at construction (the `core::serializer::Serializer` trait from `pregolya-core`); `EncryptedSerializer` (`checkpoint::serializer`, `pregolya-checkpoint`) is the canonical concrete implementor. No behavioral change — encryption coverage and error propagation semantics are unchanged."
  - "1.12 (F-PDC62-03/DC-62/2026-09-10, product-owner): {INV-006} added — encryption at rest covers ALL CheckpointSaver write ops: put, put_writes, init_guardrail_journal, and append_guardrail_entry all encrypt payload bytes before reaching SQLite backend when EncryptedSerializer is active; no CheckpointSaver write method may bypass the EncryptedSerializer (F-PDC62-03/DC-62). §Related BCs: BC-2.11.007 entry added (extends to guardrail journal write ops). input-hash refreshed (input drift resolved at burst F-PDC62-03)."
  - "1.13 (DC-64/F-PDC64-01/2026-09-10, product-owner): EC-003 retired — architect adjudication (DC-64): `EncryptedSerializer::new(key: &[u8; 32])` accepts a fixed-size array; the compiler enforces key length at compile time; an empty or wrong-length key cannot reach `new()`. EC-003 documented a runtime construction error that is UNREACHABLE under the `&[u8; 32]` parameter type. Empty-key TV row retired (it tested the EC-003 path). E-CORE-005 is NOT retired from error-taxonomy.md — it is a general-purpose validation code with primary taxonomy anchor BC-2.14.006 and is used by many other BCs; the error-taxonomy.md entry is unchanged. Census delta: BC-2.04.007 active EC count 4→3 (EC-003 retired); active TV count 4→3 (empty-key TV retired); global active EC count 147→146."
  - "1.14 (DC-65/F-PDC65-02/2026-09-10, product-owner): §Architecture Anchors stale module-name corrected — checkpoint::encryption → checkpoint::serializer (canonical per module-decomposition.md §checkpoint::serializer row renamed at DC-64; intra-BC consistency with {PRE-001}/{INV-005} which already cite checkpoint::serializer). No behavioral change."
  - "1.15 (DC-68/F-PDC68-mirror/2026-09-10, product-owner): §VP Anchors — VP-2.11.007-B added as co-anchor for {INV-006} (at-rest encryption covers all CheckpointSaver write ops including GuardrailJournal ops; module checkpoint::serializer; integration, P1). Mirror-audit fix: BC-INDEX row lists VP-2.11.007-B (added DC-68 by state-manager) and BC-2.11.007 §VP Anchors lists it, but BC-2.04.007 §VP Anchors omitted it; body now consistent with BC-INDEX and VP-INDEX. No behavioral change."
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
priority: P0
wave: 1
---

# BC-2.04.007: Encryption at Rest Covers Both State AND Event Payloads; Rotation Errors Propagate

## Description

When an `EncryptedSerializer` (or equivalent encryption layer) is configured on a
`CheckpointSaver`, both full checkpoint state blobs (written via `put`) and per-task
intermediate write payloads (written via `put_writes`) are encrypted before reaching
persistent storage. There is no code path where `put` encrypts but `put_writes` does not.
Key rotation failures surface as `Err(E-CHKPT-004 EncryptionKeyRotationFailed)` (i.e.,
`PregolyaError { category: INTERNAL, code: "E-CHKPT-004", .. }`) and are never silently
swallowed or logged-only. This satisfies NE-11.

## Preconditions

1. {PRE-001} A `CheckpointSaver` is instantiated with an `Option<Arc<dyn Serializer + Send + Sync>>`
   at construction (the `core::serializer::Serializer` trait from `pregolya-core`); `EncryptedSerializer`
   (`checkpoint::serializer`, `pregolya-checkpoint`) is the canonical concrete implementor. At least one
   active encryption key is configured in the provided serializer.
2. {PRE-002} The cipher and key material are validated at construction time (not lazily at first write)
3. {PRE-003} The graph is running under any durability tier that calls `put_writes` mid-run
   (`Sync` or `Async`)

## Postconditions

1. {PC-001} The serialized bytes stored by `put` (the full checkpoint state blob) are encrypted
   using the configured cipher and active key
2. {PC-002} The serialized bytes stored by `put_writes` (per-task write payloads) are also encrypted
   using the same cipher and active key — the same encryption path applies to both methods
3. {PC-003} Decryption on read (`get_tuple`, `list`) produces bytes identical to the original
   unencrypted serialization
4. {PC-004} If key rotation fails (new key is invalid, or old key is invalidated before rotation
   completes), `Err(E-CHKPT-004 EncryptionKeyRotationFailed { message: "EncryptionKeyRotationFailed: <reason>" })`
   (i.e., `PregolyaError { category: INTERNAL, code: "E-CHKPT-004", .. }`) is returned
   from the failing `put` or `put_writes` call; the write is NOT committed
5. {PC-005} Decrypting with a key that is no longer in the active keyring returns
   `Err(E-CHKPT-004 EncryptionKeyRotationFailed { message: "EncryptionKeyRotationFailed: key not found: <key_id>" })`
   (i.e., `PregolyaError { category: INTERNAL, code: "E-CHKPT-004", .. }`)

## Invariants

1. {INV-001} There is no code path where `put` encrypts but `put_writes` does not (symmetric coverage)
2. {INV-002} There is no code path where `put_writes` encrypts but `put` does not
3. {INV-003} Plaintext of any state blob or per-task write payload is never written to any storage
   medium or flushed to disk, even temporarily
4. {INV-004} Encryption failures propagate as `Err` and are never silently discarded or downgraded to
   a log warning
5. {INV-005} The `CheckpointSaver` accepts `Option<Arc<dyn Serializer + Send + Sync>>` at construction
   (DI seam; the `core::serializer::Serializer` trait from `pregolya-core`); `EncryptedSerializer`
   (`checkpoint::serializer`, `pregolya-checkpoint`) is the canonical concrete implementor. Wiring the
   encryption layer does not require changes to the `CheckpointSaver` trait interface.
6. {INV-006} **Encryption at rest covers ALL CheckpointSaver write ops:** When `EncryptedSerializer`
   is active, EVERY write operation on the `CheckpointSaver` — `put`, `put_writes`,
   `init_guardrail_journal`, and `append_guardrail_entry` — encrypts its payload bytes before writing
   to the SQLite backend. No `CheckpointSaver` write method may bypass the `EncryptedSerializer`
   (F-PDC62-03/DC-62).

## Edge Cases

| ID | Description | Expected Behavior |
|----|-------------|-------------------|
| EC-001 | Key rotation mid-run: old key invalidated before new key is propagated to all active write paths | `put_writes` calls that acquire the old key after invalidation return `Err(E-CHKPT-004 EncryptionKeyRotationFailed)` (`PregolyaError { category: INTERNAL, .. }`); the graph surfaces this to the caller; no partial plaintext write occurs |
| EC-002 | Read of a blob encrypted with a retired key that is no longer in the keyring | `Err(E-CHKPT-004 EncryptionKeyRotationFailed { message: "EncryptionKeyRotationFailed: key not found: <key_id>" })` (`PregolyaError { category: INTERNAL, .. }`) returned from `get_tuple`; no partial decryption |
| ~~EC-003~~ | ~~`EncryptedSerializer` constructed with null or zero-length key material~~ | **RETIRED (DC-64/F-PDC64-01):** `EncryptedSerializer::new(key: &[u8; 32])` accepts a fixed-size array enforced at compile time; an empty or wrong-length key cannot reach `new()`; this runtime path is unreachable. ~~`Err(PregolyaError { category: VAL, code: E-CORE-005, message: "Validation failed for 'key_material': must be non-empty", .. })` at construction time; no writes proceed.~~ |
| EC-004 | Backend storage contains a mix of encrypted and unencrypted blobs (migration scenario) | Unencrypted blobs that lack the cipher header return `Err(PregolyaError { category: INTERNAL, code: E-CHKPT-007, message: "CipherHeaderMissing: missing cipher header: blob may be unencrypted", .. })`; reads of unencrypted legacy data do not silently succeed |

## Canonical Test Vectors

| Input | Expected Output | Category |
|-------|----------------|----------|
| Write a checkpoint via `put` with `EncryptedSerializer`; read raw bytes from storage backend | Raw bytes are NOT valid msgpack plaintext; after decryption with the active key, bytes are valid msgpack and deserialize to the original state | happy-path |
| Write per-task writes via `put_writes` with `EncryptedSerializer`; read raw bytes from storage | Raw bytes are ciphertext; after decryption, writes match the original task write payloads exactly | happy-path |
| Key rotation: active key set to `key-v2`; `put_writes` called; then `key-v2` is invalidated and `get_tuple` called | `get_tuple` returns `Err(E-CHKPT-004 EncryptionKeyRotationFailed { message: "EncryptionKeyRotationFailed: key not found: key-v2" })`; no partial data returned | error |
| ~~`EncryptedSerializer::new(key: &[])` with empty key~~ | **RETIRED (DC-64/F-PDC64-01):** tests EC-003 path — unreachable under `&[u8; 32]` compile-time enforcement. ~~`Err(PregolyaError { category: VAL, code: E-CORE-005, .. })` at construction time; no serializer created.~~ | ~~error~~ |

## Verification Properties

| VP-ID | Property | Proof Method |
|-------|----------|-------------|
| VP-2.04.007-A | No call to `put` or `put_writes` results in plaintext bytes reaching the storage backend when EncryptedSerializer is active | integration test (inspect raw storage bytes) |
| VP-2.04.007-B | Encryption coverage is symmetric: if `put` encrypts, `put_writes` encrypts; no asymmetry permitted | code review + unit test |
| VP-2.04.007-C | Encryption errors propagate as Err; no catch-and-log path exists | static analysis / silent-failure-hunter agent |

## Traceability

| Field | Value |
|-------|-------|
| L2 Capability | CAP-005 |
| Capability Anchor Justification | CAP-005 ("Durable Three-Tier Checkpointing (Sync Default; Per-Task put_writes)") per capabilities-p0.md §CAP-005 |
| L2 Domain Invariants | (none — NE-11 is an operational safety requirement, not a named domain invariant) |
| Source Analysis | semport/graph/behavioral-intent.md §2.3 (EncryptedSerializer wraps with a cipher; LANGGRAPH_STRICT_MSGPACK security gate); §2.4 (put_writes per-task — encryption must cover both put paths) |
| NE anchor | NE-11: encryption at rest must cover both state AND event payloads; rotation errors must propagate |
| Architecture Module | pregolya-checkpoint |
| Stories | S-1.10 |

## Related BCs

- BC-2.04.001 — composes with: put_writes is one of the two methods that must be encrypted
- BC-2.04.002 — composes with: all durability tiers that call put_writes mid-run require encryption coverage
- BC-2.11.007 — extends to: guardrail journal write ops (init_guardrail_journal, append_guardrail_entry) are in scope for BC-2.04.007 {INV-003}/{INV-006} at-rest encryption; F-PDC62-03/DC-62

## Architecture Anchors

- `architecture/module-decomposition.md §pregolya-checkpoint` — `checkpoint::serializer` row: at-rest encryption covering state AND event payloads; rotation error propagation (SS-04)

## Story Anchor

S-1.10 — Encryption at rest

## VP Anchors

- VP-2.04.007-A — no plaintext in storage (integration test)
- VP-2.04.007-B — symmetric encryption coverage (unit test)
- VP-2.04.007-C — error propagation (static analysis)
- VP-2.11.007-B — at-rest encryption for GuardrailJournal write ops; co-anchors this BC's {INV-006} (all-CheckpointSaver-write-ops encryption); module checkpoint::serializer; integration, P1; registered in VP-INDEX
