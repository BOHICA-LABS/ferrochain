---
document_type: behavioral-contract
level: L3
bc_id: BC-2.01.001
version: "1.9"
status: active
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P0
subsystem: SS-01
capability: CAP-001
wave: 0
phase: 1a
producer: product-owner
timestamp: 2026-09-09T00:00:00Z
changelog:
  - "1.1 (F-P96-01, 2026-07-17): Module field resolved from placeholder to pregolya-core per module-decomposition.md v1.10."
  - "1.2 (F-P111-01, 2026-07-18): Gate #33 Form 3 wrapper-form sweep. PC6 had `Err(PregolyaError { category: VAL, code: E-CORE-001 })` bare wrapper; E-CORE-001 has `<n>` (block position) and `<type>` (type tag) placeholders. Added inline `message:` template to PC6; added EC-006 with concrete placeholder values as the authoritative full-form site."
  - "1.3 (FIX-BURST-B5-WAVE-B/2026-07-29): Error-construction notation sweep (ADR-010 §Class 3). PC6 multiline span: added `, ..` before closing `})` on continuation line (fields category/code/message present; component and retry_hint absent — elision marker required). EC-006 multiline span: same correction on its continuation line."
  - "1.4 (story-anchor-backfill/2026-08-22): §Story Anchor backfilled to S-1.03 from STORY-INDEX forward map (CANONICAL PRINCIPLE Rule 6; no behavioral change)."
  - "1.5 (M1/ADR-027/2026-08-23): stable clause anchors {PC/INV/PRE-NNN} added; purely additive, no content change."
  - "1.6 (M3b/ADR-027-escalation-1/2026-08-24): Added {INV-005} — ContentBlock #[non_exhaustive] clause; authoring missing production-grade invariant per CLAUDE.md workspace-wide mandate (S-1.03 AC-005 escalation)."
  - "1.7 (P2-bc-completeness-burst-B/SS-01..03/2026-08-26): Gap BC-2.01.001 MED — named the strict-vs-lenient deserialization entry mechanism: added {PRE-004} identifying `ContentBlock::from_value_strict()` as the strict-mode entry point vs the `serde::Deserialize` impl as the lenient path; updated PC-006 and EC-006 to reference the selecting API by name (reusing existing E-CORE-001)."
  - "1.8 (DC-61/F-PDC61-ContentBlock/2026-09-09): {INV-005} expanded to pin full canonical derive set — Debug, Clone, PartialEq, Serialize, Deserialize — in addition to the existing #[non_exhaustive] annotation. Rationale: ContentBlock is the leaf type in the GuardrailEntry transitive closure (GuardrailResult::Transform{new_content: IngressContent} → IngressContent::ToolResult(ContentBlock)); the full derive set is required for checkpoint-backed persistence per D-357 GuardrailJournal cascade. Debug+Clone+PartialEq additionally required for harness assertion equality (VP-BC201001-01, VP-BC201001-02) and aggregation. Confirmed by architect DC-61 transitive-closure audit (interface-definitions.md §GuardrailHook). Records-only fix; no behavioral contract change."
  - "1.9 (DC-61/F-PDC61-payload-closure/2026-09-09): {INV-006} added — pins canonical derive set (Debug, Clone, PartialEq, Serialize, Deserialize + #[non_exhaustive]) for all 13 ContentBlock variant payload structs: TextContentBlock, ReasoningContentBlock, ToolCallContentBlock, ToolCallChunkContentBlock, InvalidToolCallContentBlock, ImageContentBlock, VideoContentBlock, AudioContentBlock, PlainTextContentBlock, FileContentBlock, ServerToolCallContentBlock, ServerToolCallChunkContentBlock, ServerToolResultContentBlock. Annotation element type resolved: TextContentBlock.annotations is Vec<BlockAnnotation> (enum derived from Python [Citation|NonStandard] annotation union per semport/core/behavioral-intent.md §2. Messages + Content Blocks); BlockAnnotation and CitationAnnotation both pinned with same derive set. Transitive serialization closure confirmed fully pinned within BC-2.01.001 — all non-primitive field types are either pinned here or self-terminating external types (serde_json::Value). No leaf type exits to other BC ownership. Records-only fix; no behavioral contract change."
traces_to:
  - domain-spec/capabilities-p0.md#CAP-001
  - domain-spec/invariants.md#DI-008
inputs:
  - .factory/specs/prd.md
  - .factory/specs/domain-spec/capabilities-p0.md
  - .factory/specs/domain-spec/invariants.md
  - .factory/semport/core/behavioral-intent.md
  - .factory/semport/core/rust-translation-strategy.md
input-hash: "a262bd8"
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.01.001: Typed ContentBlock Sequence Construction (No Raw Content Where Typed Expected)

## Description

pregolya-core must represent every message content value as a closed-variant typed `ContentBlock`
enum rather than an untyped `String` or `Map<String, Value>`. When a caller constructs a typed
message, the content sequence must be `Vec<ContentBlock>` and the compiler must prevent raw-string
content from satisfying a typed-content parameter. This contract encodes the LangChain v1
"content-block-native" design (semport/core/behavioral-intent.md §2) and enforces DI-008 at construction time.

## Preconditions

1. {PRE-001} The caller is constructing a message with one or more content blocks.
2. {PRE-002} The pregolya-core crate defines the `ContentBlock` enum with all standard variants
   (Text, Reasoning, ToolCall, ToolCallChunk, InvalidToolCall, Image, Video, Audio,
   PlainText, File, ServerToolCall, ServerToolCallChunk, ServerToolResult, NonStandard).
3. {PRE-003} The construction call is in non-test code.
4. {PRE-004} The caller selects the deserialization mode by choosing the entry point:
   - **Strict mode** — the caller invokes `ContentBlock::from_value_strict(value: serde_json::Value) -> Result<ContentBlock, PregolyaError>`. Unknown type tags return `Err(E-CORE-001)` immediately; no `NonStandard` passthrough.
   - **Lenient mode (default)** — the caller uses the `serde::Deserialize` implementation (e.g., via `serde_json::from_value::<ContentBlock>(v)` or `#[derive(Deserialize)]` field inference). Unknown type tags map to `ContentBlock::NonStandard` per INV-002.
   The two modes are distinct static entry points — there is no runtime boolean flag; the choice is enforced at the call site.

## Postconditions

1. {PC-001} Every message-content parameter in pregolya-core's public API that represents typed
   content accepts `Vec<ContentBlock>` (not `Vec<serde_json::Value>` or `Vec<String>`).
2. {PC-002} A `ContentBlock::Text(TextContentBlock { text, annotations })` construction compiles and
   carries the exact text passed.
3. {PC-003} A raw `String` value is NOT accepted where a `Vec<ContentBlock>` is required — the Rust
   type system prevents implicit coercion.
4. {PC-004} The `MessageContent` enum `{ Text(String), Blocks(Vec<ContentBlock>) }` allows either
   form, but callers requesting typed access receive `Vec<ContentBlock>` after normalization.
5. {PC-005} An unknown provider-specific block maps to `ContentBlock::NonStandard { value: serde_json::Value }`
   rather than causing a deserialization error.
6. {PC-006} When the caller uses `ContentBlock::from_value_strict(value)` (strict entry point per PRE-004):
   - Returns `Ok(ContentBlock)` when the type tag is in `KNOWN_BLOCK_TYPES`.
   - Returns `Err(PregolyaError { category: VAL, code: E-CORE-001,
     message: "StrictContentBlockValidation: block at position <n> has unrecognized type tag '<type>'; not in KNOWN_BLOCK_TYPES — use lenient deserialization for NonStandard passthrough", .. })`
     (where `<n>` is the block's 0-based position index; `<type>` is the unrecognized type tag string;
     both are available at the deserialization call site)
     when an unrecognized block type is encountered.
   The lenient path (default `serde::Deserialize` impl, PRE-004) never returns E-CORE-001 — it maps unknowns to `ContentBlock::NonStandard` per PC-005 and INV-002.

## Invariants

- {INV-001} **DI-008 (Library Constructor Result Contract):** All content block construction functions
  that can fail return `Result<T, PregolyaError>` — never panic.
- {INV-002} The `KNOWN_BLOCK_TYPES` set governs standard-vs-provider dispatch; a variant not in the set
  maps to `NonStandard` rather than being rejected.
- {INV-003} `ContentBlock` is a closed serde-tagged enum; serde deserialization from `{"type": "text", ...}`
  produces `ContentBlock::Text(...)`, not a `Map`.
- {INV-004} `MessageContent::Text(s)` and `MessageContent::Blocks(v)` are semantically equivalent views
  of the same information — transitioning from text to blocks via a normalization call must
  not lose content.
- {INV-005} `ContentBlock` carries the full canonical annotation and derive set:
  `#[non_exhaustive] #[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]`.
  - **`#[non_exhaustive]`** — required per workspace-wide mandate (CLAUDE.md §Code Conventions);
    external match arms must include a wildcard (`_ => {}`); applies to all public API surface enums.
  - **`Debug + Clone`** — required for harness assertions, aggregation patterns,
    and general-use inspect/copy semantics.
  - **`PartialEq`** — required for assert-equality in VP assertions (VP-BC201001-01,
    VP-BC201001-02) and test harness comparisons.
  - **`Serialize + Deserialize`** — required for round-trip checkpoint persistence.
    `ContentBlock` is reachable from `GuardrailEntry` via
    `GuardrailResult::Transform { new_content: IngressContent } → IngressContent::ToolResult(ContentBlock)`;
    the full `GuardrailEntry` transitive closure must serialize/deserialize for checkpoint
    durability (D-357 GuardrailJournal cascade). Confirmed by architect DC-61 transitive-closure
    audit (interface-definitions.md §GuardrailHook).
- {INV-006} **ContentBlock Payload Struct Derive Closure (Transitive Serialization Requirement):**
  Every named variant payload struct wrapped by `ContentBlock` carries the same canonical derive
  set as `ContentBlock` ({INV-005}):
  `#[non_exhaustive] #[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]`.

  The full set of payload structs subject to this invariant:
  - `TextContentBlock` — text block; has `text: String`, `annotations: Vec<BlockAnnotation>`,
    and `#[serde(flatten)] extras: serde_json::Map<String, serde_json::Value>`
  - `ReasoningContentBlock` — reasoning/thinking block; primitive fields only
  - `ToolCallContentBlock` — tool invocation block; `id: String`, `name: String`,
    `args: serde_json::Value`, plus extras
  - `ToolCallChunkContentBlock` — streaming tool-call fragment; includes `index: Option<u32>`,
    primitive/external fields only
  - `InvalidToolCallContentBlock` — malformed tool-call record; `Option<String>` fields only
  - `ImageContentBlock` — image data block (url or base64); primitive/external fields only
  - `VideoContentBlock` — video data block; primitive/external fields only
  - `AudioContentBlock` — audio data block; primitive/external fields only
  - `PlainTextContentBlock` — plain-text data block (serde tag "text-plain"); primitive fields only
  - `FileContentBlock` — file data block; primitive/external fields only
  - `ServerToolCallContentBlock` — server-side tool-call block; primitive/external fields only
  - `ServerToolCallChunkContentBlock` — server-side streaming tool-call fragment; primitive/external
    fields only
  - `ServerToolResultContentBlock` — server-side tool result block; primitive/external fields only

  **Rationale:** `ContentBlock` derives `Serialize + Deserialize` for checkpoint persistence
  (see {INV-005}). Serde requires every variant payload type to also implement `Serialize +
  Deserialize`; a payload struct missing those derives causes a compile error on `ContentBlock`'s
  own derives. `Debug + Clone + PartialEq` are additionally required for harness assertion equality
  and aggregation, consistent with `ContentBlock`'s requirements. `#[non_exhaustive]` applies to all
  13 structs per the workspace-wide public API surface mandate (CLAUDE.md §Code Conventions —
  callers outside `pregolya-core` must use constructor functions, not struct-literal initialization).

  **Annotation element type resolution:**
  `TextContentBlock.annotations` is `Vec<BlockAnnotation>`. The canonical Rust name is
  `BlockAnnotation` — derived from the Python `[Citation | NonStandard]` annotation union
  (semport/core/behavioral-intent.md §2. Messages + Content Blocks). `BlockAnnotation` is a serde-tagged enum
  in the content-block domain, owned by BC-2.01.001. It carries:
  `#[non_exhaustive] #[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]`.

  `BlockAnnotation` variants:
  - `Citation(CitationAnnotation)` — citation payload struct; see below
  - `NonStandard { value: serde_json::Value }` — provider-specific annotation (inline struct
    variant); `serde_json::Value` is an external type that unconditionally implements
    `Serialize + Deserialize` — no further pin required

  `CitationAnnotation` — a named payload struct carrying cited-text annotation metadata
  (e.g., cited text content, source identifier, document range bounds). All fields are primitive
  or standard-library types (`String`, `Option<String>`, numeric types); no named pregolya types
  appear in its field set. `CitationAnnotation` carries:
  `#[non_exhaustive] #[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]`.

  **Transitive closure terminus:** every non-primitive field type reachable from `ContentBlock`
  — the 13 payload structs, `BlockAnnotation`, and `CitationAnnotation` — is either:
  (a) explicitly pinned in this invariant ({INV-006}), or
  (b) a self-terminating external type (`serde_json::Value`, `serde_json::Map<String, Value>`),
      or
  (c) a std/primitive type (`String`, `Option<T>`, `Vec<T>`, `bool`, `u32`, `u64`, `f64`).
  The serialization closure is **fully pinned within BC-2.01.001**. No named pregolya type in
  the closure is owned by a different BC or artifact.

## Edge Cases

### EC-001: Unknown block type in provider response
**Scenario:** A provider returns a block with `"type": "provider_specific_block"` that is not
in the standard set.
**Expected behavior:** The block deserializes as `ContentBlock::NonStandard { value: {...} }`.
The message is valid; no error is returned. The caller may inspect the value field.
**Reference:** semport/core/behavioral-intent.md §2 (`KNOWN_BLOCK_TYPES` set).

### EC-002: Empty content sequence
**Scenario:** A caller constructs a message with `content: vec![]` (zero blocks).
**Expected behavior:** Construction succeeds. The message carries an empty content sequence.
Downstream operations that require at least one block (e.g. model invocation) may return
a separate validation error, but the construction itself does not fail.

### EC-003: Raw string content in blocks-typed parameter
**Scenario:** A caller attempts to pass a `String` directly to a parameter typed `Vec<ContentBlock>`.
**Expected behavior:** Compilation failure — no implicit coercion from `String` to `ContentBlock`.
The caller must wrap in `ContentBlock::Text(TextContentBlock { text: s, annotations: vec![] })`.

### EC-004: Mixed block types in single message
**Scenario:** A message contains `[ContentBlock::Text(...), ContentBlock::Image(...), ContentBlock::ToolCall(...)]`.
**Expected behavior:** All blocks are accepted in sequence; the resulting `Vec<ContentBlock>` preserves
insertion order. Each block is independently accessible by variant match.

### EC-006: Strict-mode deserialization with unrecognized block type
**Scenario:** A provider response contains a block with `"type": "provider_v2_block"` at position 2
(0-based) in a message. The caller uses `ContentBlock::from_value_strict(value)` (strict entry point
per PRE-004; `NonStandard` passthrough disabled).
**Expected behavior:** `Err(PregolyaError { category: VAL, code: E-CORE-001,
message: "StrictContentBlockValidation: block at position 2 has unrecognized type tag 'provider_v2_block'; not in KNOWN_BLOCK_TYPES — use lenient deserialization for NonStandard passthrough", .. })`.
Deserialization does not fall through to a `NonStandard` block; the error propagates to the caller.
The same value processed via `serde_json::from_value::<ContentBlock>(v)` (lenient path) would instead
produce `Ok(ContentBlock::NonStandard { value: {...} })`.

### EC-005: Serde round-trip with extras field
**Scenario:** A `TextContentBlock` with an `extras` field containing provider metadata is
serialized and deserialized.
**Expected behavior:** The `extras: Map<String, Value>` (or `#[serde(flatten)]` equivalent) round-trips
faithfully; no extras data is silently dropped.

## Canonical Test Vectors

| # | Input | Expected Output | Notes |
|---|-------|-----------------|-------|
| TV-001 | `ContentBlock::Text(TextContentBlock { text: "hello".into(), annotations: vec![] })` | Serializes as `{"type":"text","text":"hello"}` | Happy path — basic text block |
| TV-002 | `ContentBlock::Image(ImageContentBlock { url: "https://example.com/img.png".into(), ... })` | Serializes as `{"type":"image","url":"https://example.com/img.png",...}` | Multimodal block |
| TV-003 | Deserialize `{"type":"unknown_provider","data":{}}` into `ContentBlock` | `ContentBlock::NonStandard { value: {"type":"unknown_provider","data":{}} }` | Unknown type → NonStandard |
| TV-004 | `MessageContent::Text("hello".into())` → normalize to blocks | `vec![ContentBlock::Text(TextContentBlock { text: "hello", annotations: vec![] })]` | Text→Blocks normalization |
| TV-005 | Pass raw `String` to `fn accepts_blocks(v: Vec<ContentBlock>)` | Compile error | Type-system enforcement |

## Verification Properties

| VP ID | Description | Method | Phase |
|-------|-------------|--------|-------|
| VP-BC201001-01 | Round-trip: `ContentBlock::Text` serializes and deserializes to identical value | Unit test (serde round-trip) | Wave 0 |
| VP-BC201001-02 | Unknown block type always maps to NonStandard, never panics | Property test (arbitrary JSON objects with unknown type fields) | Wave 0 |

## Related BCs

- BC-2.01.002 — Message type-safety (depends on: typed content blocks are the content payload of typed messages)
- BC-2.01.003 — Runnable trait invocation (composes with: messages are the primary Input/Output types of chat model Runnables)
- BC-2.14.001 — PregolyaError 2D struct (depends on: construction errors propagate via PregolyaError)
- BC-2.14.003 — Constructor Result contract (depends on: content block construction must return Result, not panic)

## Architecture Anchors

- `pregolya-core/src/messages/content.rs` — `ContentBlock` enum definition (to be created)
- `pregolya-core/src/messages/base.rs` — `MessageContent` enum and normalization (to be created)

## Story Anchor

S-1.03

## VP Anchors

- VP-BC201001-01, VP-BC201001-02

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-001 |
| Capability Anchor Justification | CAP-001 ("Type-Safe Message and Content Primitive Construction") per capabilities-p0.md §CAP-001 — this BC enforces the "no raw untyped content where typed variant is expected" guarantee that CAP-001 mandates as its central invariant |
| L2 Domain Invariants | DI-008 (Library Constructor Result Contract) |
| NE References | — |
| Priority | P0 |
| Wave | Wave 0 |
| Test Types | U (unit), CT (compile-time type check), ST (serde round-trip) |
| Module | pregolya-core |
