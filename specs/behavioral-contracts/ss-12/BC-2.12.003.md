---
document_type: behavioral-contract
level: L3
bc_id: BC-2.12.003
version: "1.22"
status: active
lifecycle_status: active
introduced: v1.0.0-greenfield
origin: greenfield
priority: P1
subsystem: SS-12
capability: CAP-014
wave: 1
phase: 1a
red_gate: false
producer: product-owner
timestamp: 2026-08-24T01:00:00Z
traces_to:
  - domain-spec/capabilities-p1-p2.md#CAP-014
inputs:
  - .factory/specs/prd.md
  - .factory/specs/domain-spec/capabilities-p1-p2.md
  - .factory/semport/platform/behavioral-intent.md
input-hash: "faac9bb"
changelog:
  - "1.1 (ADV-P1D-PASS-31): F-P31-01 PC18 list-runs endpoint — add limit (default 10, max 100; values > 100 clamped) and offset pagination params + declare created_at DESC ordering (pagination coherence canon)."
  - "1.2 (ADV-P1D-PASS-33): F-P33-02 add Run-Config Merge Precedence invariant — run-supplied config/metadata/context deep-merge over Assistant's stored values, run wins at leaf key. Upstream-check result: no contradicting semantics in BC-2.01.003 or semport behavioral-intent §2.3; leaf-level deep-merge adopted as spec canon."
  - "1.3 (F-P96-01, 2026-07-17): Module field resolved from placeholder to pregolya-server per module-decomposition.md v1.10."
  - "1.4 (F-P117-01, fix burst 120, 2026-07-19): summary_halt promoted to first-class terminal Run status throughout (Option 1 adjudication: BC-2.10.003 PC8(d) explicitly asserts the Run status IS summary_halt '(not failed)'; entities-server.md §91 agrees). H1 title and Description: add summary_halt to state machine enumeration. PC7: add in_progress → summary_halt arc (OnCeiling::Summarize path per BC-2.10.003 PC8(c)(d)). PC8: terminal set {completed, failed, cancelled} → {completed, failed, cancelled, summary_halt}. PC13: completed_at terminal set gains summary_halt. PC18: status filter enum gains 'summary_halt'. PC19: deletable terminal states gain summary_halt. Output invariant: output populated when status ∈ {completed, summary_halt} (summary_halt output = summarize model response per BC-2.10.003 PC8(c)); null in all other states. Traceability state machine description updated."
  - "1.5 (notation-sweep-B6/2026-07-29): B6 error-construction notation sweep. EC-003: replaced `PregolyaError { ... }` with `PregolyaError { .. }` — CLASS3_ASCII_ELLIPSIS_VIOLATION (three-dot ASCII form forbidden in prose/observation context; canonical elision marker is two dots per ADR-010 §Error-Construction Notation Canon)."
  - "1.6 (F-P177-B03, burst-288, 2026-08-15): Add `interrupted → cancelled` arc to PC7 (9th arc); extend PC10 to authorize cancellation of `interrupted` Runs. Resolves deadlock: PC19 directed callers to cancel an interrupted Run before deletion, but the arc was absent from PC7 and unauthorized by PC10, making interrupted Runs permanently undeletable."
  - "1.7 (story-anchor-backfill/2026-08-22): §Story Anchor backfilled to S-1.26 from STORY-INDEX forward map (CANONICAL PRINCIPLE Rule 6; no behavioral change)."
  - "1.8 (M1/ADR-027/2026-08-23): stable clause anchors {PC/INV/PRE-NNN} added; purely additive, no content change."
  - "1.9 (P2A-044 F-08/2026-08-24): Mint E-SERVER-018 RunStateConflict — PC-012 and PC-019 both mandated HTTP 409 for invalid-state-transition but named no error code, leaving the response body unspecified. PC-012 amended to cite E-SERVER-018 for the terminal-state cancel conflict. PC-019 amended to cite E-SERVER-018 for the non-terminal-state delete conflict. EC-006 added covering both scenarios. No arc transitions changed; amendment adds specification precision only."
  - "1.10 (P2A-044 F-06/2026-08-24): compressed-ordinal citations normalized to stable tags."
  - "1.11 (P2A-046 F-3/2026-08-24): same-BC self-ref compressed ordinals normalized to stable tags."
  - "1.12 (P2A-052 F-052-01/2026-08-25): ## VP Anchors section corrected from duplicated Story-Anchor story-ID to 'None' (BC has no Kani VP seed; see §Verification Properties)."
  - "1.13 (P2A-BC-scan-B/2026-08-26): ADR-028 D1-D3 multitask propagation — PC-004 expanded with full lifecycle semantics for multitask_strategy interrupt, rollback, and enqueue: pre-empted run terminal state (cancelled, not interrupted per ADR-028 D1); rollback target (latest_completed_checkpoint_id, delete rows with checkpoint_id > anchor per ADR-028 D2); enqueue FIFO order, max_queued_runs=10 configurable cap, queue-full → E-SERVER-019 RunQueueFull HTTP 429 per ADR-028 D3. EC-007 added for enqueue-queue-full path. TV-008/009/010 added for interrupt/rollback/enqueue strategies. ADR-028 anchor cited throughout new clauses."
  - "1.14 (round-42/F-P2A177-01/2026-08-29): F-P2A177-01 [HIGH, CWE-248/703] — Substantiate node-body panic recovery in EC-003 and mint {INV-007} panic-text-isolation invariant. EC-003 expanded to cover both Err and panic paths: node Err path is unchanged; node-body panic path now specifies `FutureExt::catch_unwind(AssertUnwindSafe(...))` mechanism — panic caught during `.await` polling → `Err(PregolyaError { code: \"E-GRAPH-019\", category: INTERNAL, message: \"NodePanic: graph node panicked during execution — see server error log for details\", retry_hint: Never, .. })`; run transitions `in_progress → failed`; raw panic text logged server-side at ERROR only; NEVER in `Run.error.message` per new {INV-007}; {INV-005} (no orphan runs) upheld — run MUST NOT remain `in_progress` after panic caught. SEC-008 note added to EC-003: `panic = \"unwind\"` required on pregolya-server release profile. {INV-007} added: panic-text-isolation — raw panic text MUST NOT appear in `Run.error.message`; E-GRAPH-019 STATIC message invariant. TV-011 minted: node-body-panic → failed + E-GRAPH-019 + static message + no orphan `in_progress` (TV count 10→11). Traceability Error Codes row added citing E-GRAPH-019."
  - "1.15 (round-43/F-P2A181-01-sibling/2026-08-30): F-P2A181-01 sibling — EC-003 SEC-008 clause and TV-011 Notes refined to workspace-root `[profile.release]` precision, aligning with ADR-029 §Decision 5 v2.16 and S-2.11 AC-037 v1.31. EC-003: 'on the `pregolya-server` release profile' → 'in the workspace-root `[profile.release]` governing the `pregolya-server` binary; a library-member `[profile.release] panic` override is silently ignored by Cargo and MUST NOT be relied upon'. TV-011 Notes: same workspace-root precision added. BC-2.09.008 EC-010 SEC-008 was the primary fix (F-P2A181-01); this sibling corrects residual release-profile framing for consistency."
  - "1.16 (round-47/F-P2A197-01+F-P2A197-02/2026-08-30): F-P2A197-01 [HIGH, CWE-209] — E-GRAPH-011 ConditionalEdgePanic panic text leaks at HTTP boundary. {INV-007} extended from E-GRAPH-019-only to ALL internal-panic codes: E-GRAPH-011 ConditionalEdgePanic STATIC message added ('ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details'); source_node topology and captured panic text suppressed; MCP-boundary uniform treatment parity (ADR-029 §Decision 5). EC-003 'node returns Err' path extended with Internal-panic Err sanitization clause: pregolya-server run-executor MUST static-replace E-GRAPH-011 message before writing to Run.error.message. TV-012 minted (E-GRAPH-011 → STATIC message, source_node suppressed; TV count 11→12). F-P2A197-02 [MED, CWE-209/CWE-532] — no redaction contract on Run.error.message HTTP surface. {INV-008} External-Boundary Error-Sanitization invariant added: mandatory 3-step pipeline (internal-panic static-replace → redact_credentials → sanitize_internal_ids) on Run.error.message before surfacing via {PC-013}/{PC-016}; mirrors BC-2.09.008 {INV-003}; closes DI-010 Credential Opacity gap on HTTP Run-status surface. TV-013 minted (credential redaction path; TV count 12→13). Traceability Error Codes updated to reference E-GRAPH-011 STATIC replacement obligation."
  - "1.17 (round-48/F-P2A201-02+F-P2A203-02/2026-08-30): F-P2A201-02 [MED, CWE-209/670] — {INV-008} step 3 falsely claimed 'checkpoint IDs' as UUID-shaped identifiers covered by `sanitize_internal_ids`. CheckpointId is a u64 newtype (ADR-005 / BC-2.04.003) — NOT UUID-shaped; the UUID regex cannot match it. 'checkpoint IDs' removed from the UUID-covered example list; u64-CheckpointId authoring-site-discipline carve-out added (mirrors BC-2.09.008 {INV-001} / ADR-029 SEC-BOUND-001 step 3). Canonical replacement token `<redacted-id>` confirmed. F-P2A203-02 propagation — {INV-008} step 2 updated from vague 'Bearer tokens, API key prefixes, and patterns matching the DI-010 credential opacity regex' to explicit four-pattern enumeration (BC-2.09.007 {INV-003}(b)): OpenAI sk-, Anthropic sk-ant-, generic 64+ alphanumeric, Bearer `Bearer\\s+[A-Za-z0-9._~+/=\\-]+`. Symmetry claim 'Symmetric with BC-2.09.008 {INV-003}' remains TRUE; BC-2.09.008 {INV-003} now also enumerates the four patterns. No new TVs minted in this BC (TV count unchanged at 13; TV-013 already tests credential redaction; Bearer coverage is tested via TV-010 in BC-2.09.007)."
  - "1.18 (round-49/F-P2A205-02-sibling/2026-08-31): F-P2A205-02 sibling sweep — {INV-008} step 2 canonical pattern set extended from 4 to 6 patterns: pattern 5 URL-embedded userinfo `[a-zA-Z][a-zA-Z0-9+.\\-]*://[^/\\s:@]+:[^/\\s:@]+@` → `<redacted>`; pattern 6 HTTP Basic auth `Basic\\s+[A-Za-z0-9+/=]+` → `<redacted>`. 'four-pattern set' → 'six-pattern set'. BC-2.09.007 {INV-003}(b) is the canonical authority. No new TVs minted (TV-013 already tests the credential-redaction path; URL-userinfo and Basic-auth coverage tested via TV-012/TV-013 in BC-2.09.007)."
  - "1.19 (D-356-fix/DC-03/2026-09-07, product-owner): {INV-009} added — config.configurable.checkpoint_id fork-start semantic: when set on Create-Run, executor initializes thread state from the specified checkpoint's stored ChannelValues rather than current_checkpoint (fork-from-checkpoint pattern; cited by BC-2.24.005 {PC-003}). EC-008 added for CheckpointNotFound path (E-CHKPT-002 minted; TODO: register in error-taxonomy.md by product-owner). TV-014 added for fork-from-checkpoint happy path (TV count 13→14). Delta note blockquote added. D-356 human-authorized reopening scope."
  - "1.20 (D-356-fix/DC-03/2026-09-07, state-manager): Code collision fix — 'E-CHKPT-002' (used in v1.19 for CheckpointNotFound) is already assigned to MonotonicClockRegression (BC-2.04.003, INTERNAL); per append-only-numbering policy IDs are never reused; E-CHKPT-011 is the next available CHKPT code. All occurrences of 'E-CHKPT-002' meaning CheckpointNotFound in {INV-009}, EC-008, delta-note, and Traceability corrected to 'E-CHKPT-011'. No normative behavior changed; only the code identifier updated."
  - "1.21 (D-356-fix/DC-16/2026-09-08, product-owner): F-PDC16-01: Reverse-anchor completeness — BC-2.24.005 {PC-003} (forward edge) consumes {INV-009} via S-console-07, but BC-2.12.003 had no reverse edge back. §Related BCs: BC-2.24.005 added as fork-from-checkpoint consumer. §Story Anchor: S-console-07 appended (roadmap, Wave 3 — consumes {INV-009} fork-start via BC-2.24.005 {PC-003}); S-1.26 remains primary. Mirrors the F-PDC12/DC-04 fix applied to BC-2.12.001."
  - "1.22 (D-356-fix/DC-24/2026-09-08, product-owner): F-PDC24-04: {PC-013} amended to project `evidence_journal?` on the run-read response — present when `status` is a terminal state (completed, failed, cancelled, summary_halt); null/omitted for active/queued runs. Adjudication: 1:1 entity field on Run (entities-server.md); optional projection on GET /threads/{thread_id}/runs/{run_id} is the cleanest mechanism (consistent with output?, error?, completed_at? pattern; no new sub-resource route needed). BC-2.24.007 {PC-003} now cites this field as its substrate."
extracted_from: null
modified: []
deprecated: null
deprecated_by: null
replacement: null
retired: null
removed: null
removal_reason: null
---

# BC-2.12.003: Run Creation and Execution Lifecycle (queued → in_progress → completed/failed/cancelled/summary_halt; interrupted is pausable/resumable)

> **D-356 adversary fix DC-24 (2026-09-08, product-owner).** F-PDC24-04: {PC-013} amended — `evidence_journal?` added to the run-read response shape (`GET /threads/{thread_id}/runs/{run_id}`), present only when `status` is a terminal state (completed/failed/cancelled/summary_halt); null/omitted for active/queued runs. This exposes the 1:1 Run entity field required by BC-2.24.007 {PC-003} (dev-console budget panel). api-surface.md line 258 defers response shape to BC-2.12.003 — no architect follow-up needed.

> **D-356 adversary fix DC-16 (2026-09-08, product-owner).** F-PDC16-01: Reverse-anchor completeness — BC-2.24.005 {PC-003} consumes {INV-009} (fork-from-checkpoint) via S-console-07, but this BC had no reverse edge. §Related BCs updated to include BC-2.24.005; §Story Anchor updated to append S-console-07 (roadmap, Wave 3 — consumes {INV-009} fork-start via BC-2.24.005 {PC-003}). Mirrors the F-PDC12/DC-04 pattern applied to BC-2.12.001.

> **D-356-fix DC-03 (2026-09-07, product-owner/state-manager).** {INV-009} added: `config.configurable.checkpoint_id` fork-start semantic on `POST /threads/{id}/runs` — used by BC-2.24.005 {PC-003} for developer-console fork-from-checkpoint. EC-008 and TV-014 added for the new path. E-CHKPT-011 CheckpointNotFound registered in error-taxonomy.md v1.73 (code collision fix: E-CHKPT-002 occupied by MonotonicClockRegression; E-CHKPT-011 is next available). No existing postconditions, invariants, or state-machine arcs changed. D-356 human-authorized reopening scope.

## Description

A Run is a single execution of a pregolya graph against a Thread, dispatched by
pregolya-server. This BC specifies the Run creation endpoint, its lifecycle state
machine (`queued → in_progress → completed | failed | cancelled | summary_halt`, with `interrupted` as a pausable/resumable state; `summary_halt` is a budget-summarize terminal state per BC-2.10.003 {PC-008}(d)), and the
failure modes including the `E-SERVER-002 RunNotFound` error. Runs are created synchronously
via `POST /threads/{thread_id}/runs`; execution begins asynchronously. Status can be
polled via `GET /threads/{thread_id}/runs/{run_id}`. No wire-compatibility with
LangGraph Platform (D13).

## Preconditions

1. {PRE-001} `pregolya-server` is running with configured `RunStore`, `CheckpointSaver`, and
   an executor connected to the `pregolya-graph` engine.
2. {PRE-002} A Thread identified by `thread_id` exists (see BC-2.12.001).
3. {PRE-003} The caller holds a valid authentication credential (or server is in dev mode).

## Postconditions

### Create Run (`POST /threads/{thread_id}/runs`)

1. {PC-001} Accepts body:
   ```
   {
     assistant_id: Uuid,
     input?: GraphInput,
     config?: RunnableConfig,
     metadata?: Map<String, Value>,
     multitask_strategy?: "reject" | "interrupt" | "rollback" | "enqueue"
   }
   ```
2. {PC-002} `thread_id` must exist; if not: HTTP 404 with `E-SERVER-003 ThreadNotFound`.
3. {PC-003} `assistant_id` must reference a registered Assistant; if not: HTTP 422.
4. {PC-004} `multitask_strategy` governs concurrent run handling on the same thread (default `"reject"`). Per ADR-028 Decisions 1–3:

   - `"reject"`: if another Run is already `queued` or `in_progress` on the thread → HTTP 409 `{ code: "E-SERVER-012", message: "ConcurrentRun: ..." }`.

   - `"interrupt"` (ADR-028 Decision 1): The pre-empted Run transitions to **`cancelled`** (NOT `interrupted`; `interrupted` is reserved for HITL-pause per BC-2.05.002 {PC-002}; sibling-preempted runs have no resume path). The new Run enters `queued` immediately; HTTP 202 is returned synchronously. The executor MUST NOT start the new Run concurrently with the pre-empted Run's shutdown — the new Run transitions to `in_progress` only AFTER the pre-empted Run's `cancelled` state is durably written to the RunStore. If the pre-empted Run is in `queued` state (not yet started), it transitions `queued → cancelled` without ever reaching `in_progress`. Error path: if the cancellation signal delivery fails (RunStore write error) → `Err(E-SERVER-014 RunStoreFailed)`; the new Run is NOT queued until the pre-empted Run's cancellation is durable.

   - `"rollback"` (ADR-028 Decision 2): The pre-empted Run transitions to `cancelled`. The thread's checkpoint state is reset to the **`latest_completed_checkpoint_id`** captured at the moment `POST .../runs` is processed (the last checkpoint written by the previous completed/failed/cancelled Run). Execution sequence: (1) look up `latest_completed_checkpoint_id`; (2) signal pre-empted Run to cancel; (3) await `cancelled` state (durable RunStore write); (4) delete all checkpoint rows with `checkpoint_id > latest_completed_checkpoint_id` for this thread (bounded delete using the logical-clock monotone property per ADR-005 §Decision); (5) advance thread's `current_checkpoint` pointer back to `latest_completed_checkpoint_id`; (6) start new Run against rolled-back state. If the thread has no prior checkpoint, the rollback target is the empty thread state. Error path: checkpoint discard failure → `Err(E-CHKPT-001 CheckpointWriteFailed)`; new Run NOT started until rollback is complete; partial rollback is not permitted.

   - `"enqueue"` (ADR-028 Decision 3): The new Run is added to the thread's FIFO run queue. Queue bound: `max_queued_runs` (default **10**; configurable per server-instance at startup; applies to the count of Runs in `queued` state on a single thread, excluding the currently `in_progress` Run). If the thread's queued Run count is already at capacity → HTTP 429 `{ code: "E-SERVER-019", message: "RunQueueFull: thread '<thread_id>' already has <queue_depth> queued run(s); max_queued_runs=<max_queued_runs>" }` (EC-007). Ordering: FIFO (`created_at` ascending); when the `in_progress` Run terminates (any terminal state), the executor selects the oldest `queued` Run on the thread and transitions it to `in_progress`.
5. {PC-005} Returns HTTP 202 with `Run { run_id, thread_id, assistant_id, status: "queued", created_at }`.
6. {PC-006} Execution is dispatched asynchronously to the graph executor.

### Run Lifecycle State Machine

7. {PC-007} Lifecycle states and valid transitions:
   ```
   queued      → in_progress   (executor picks up the run)
   in_progress → completed     (graph reaches END)
   in_progress → failed        (unhandled error in graph or executor)
   in_progress → interrupted   (HITL interrupt raised; graph paused, awaiting resume)
   in_progress → cancelled     (POST .../cancel called while run is active)
   in_progress → summary_halt  (OnCeiling::Summarize path: budget ceiling hit; one final summarize LLM call completes; model response returned as output — BC-2.10.003 {PC-008}(c)(d))
   queued      → cancelled     (POST .../cancel called before executor picks up the run)
   interrupted → in_progress   (caller posts resume value via POST .../runs/{run_id}/resume)
   interrupted → cancelled     (POST .../cancel called on an interrupted run)
   ```
8. {PC-008} Terminal states (no further transitions possible): `completed`, `failed`, `cancelled`, and `summary_halt`.
   `interrupted` is **not** terminal — it is a pausable/resumable state.
   `summary_halt` is terminal (no further transitions); it is not cancellable (already terminal when the cancel signal would arrive — HTTP 409 per {PC-012}). A `summary_halt` run IS directly deletable ({PC-019}) without needing a prior cancel step.
9. {PC-009} A Run that is `interrupted` can be resumed via
   `POST /threads/{thread_id}/runs/{run_id}/resume { resume_value }` (see BC-2.05.002
   for HITL contract); this transitions the Run back to `in_progress`.

### Cancel Run (`POST /threads/{thread_id}/runs/{run_id}/cancel`)

10. {PC-010} Cancels a `queued`, `in_progress`, or `interrupted` Run. Signals the executor to stop and transitions
    the Run to `cancelled` status.
11. {PC-011} Cancellation is best-effort: if the run completes naturally before the cancellation
    signal is processed, the status will be `completed` or `failed`, not `cancelled`.
12. {PC-012} Returns HTTP 202 on successful cancellation signal; HTTP 404 `{ code: "E-SERVER-002", message: "RunNotFound: ..." }` if run not found; HTTP 409 `{ code: "E-SERVER-018", message: "RunStateConflict: cannot perform 'cancel' on run '<run_id>' in state '<current_state>'" }` if run is already in a terminal state (EC-006).

### Read Run (`GET /threads/{thread_id}/runs/{run_id}`)

13. {PC-013} Returns `Run { run_id, thread_id, assistant_id, status, output?, error?, evidence_journal?, created_at, updated_at, completed_at? }`. The `evidence_journal?` field is present only when `status` is a terminal state (`completed`, `failed`, `cancelled`, `summary_halt`); it is null or omitted for active/queued runs. This field exposes the run's `EvidenceJournal` decision history (consumed by BC-2.24.007 {PC-003} dev-console budget panel).
    `updated_at` is set on every state mutation. `completed_at` is set only on terminal
    transition (status → `completed` | `failed` | `cancelled` | `summary_halt`); it is `null` in all
    non-terminal states (`queued`, `in_progress`, `interrupted`). Authority: F-P24-01.
14. {PC-014} Returns HTTP 404 with `{ code: "E-SERVER-002", message: "RunNotFound: run '<run_id>' does not exist in thread '<thread_id>'" }` if not found.
15. {PC-015} A completed Run carries `output: GraphOutput` (the final state values).
16. {PC-016} A failed Run carries `error: { code, message, component, category }` from the
    propagated `PregolyaError`.

### List Runs (`GET /threads/{thread_id}/runs`)

17. {PC-017} Returns `{ runs: [Run], total_count: u64 }` for all runs on the thread.
18. {PC-018} Accepts `status` filter query param (`"queued"`, `"in_progress"`, `"completed"`, `"failed"`, `"interrupted"`, `"cancelled"`, `"summary_halt"`) and canonical pagination params: `limit` (default 10, max 100; values > 100 clamped to 100) and `offset` (default 0); results ordered `created_at` descending (F-P31-01, ADV-P1D-PASS-31).

### Delete Run (`DELETE /threads/{thread_id}/runs/{run_id}`)

19. {PC-019} Deletes a Run record that is in a terminal state (`completed`, `failed`, `cancelled`, or `summary_halt`).
    Cannot delete a `queued`, `in_progress`, or `interrupted` Run — HTTP 409 `{ code: "E-SERVER-018", message: "RunStateConflict: cannot perform 'delete' on run '<run_id>' in state '<current_state>'" }` (EC-006).
    For `interrupted` Runs: either resume (POST .../resume) to complete/fail/cancel/summary_halt, or
    cancel first (POST .../cancel → `cancelled`), then delete once terminal.
    **Decision basis (F-02):** DELETE = record deletion only. Separation from cancellation
    follows langgraph-sdk semantics (`runs.cancel()` ≠ delete). Prevents accidental data
    loss on active runs.
20. {PC-020} Returns HTTP 204 on success; HTTP 404 if run not found.

## Invariants

- {INV-001} `run_id` is globally unique within the server instance.
- {INV-002} The executor MUST NOT start a Run that was created in a `queued` state on a different
  server instance without distributed coordination — in single-node deployment, all
  `queued` Runs on startup are retried.
- {INV-003} Run output (`output`) is populated when `status ∈ {"completed", "summary_halt"}`. For
  `summary_halt`, output carries the summarize model response (BC-2.10.003 {PC-008}(c)). It is
  `null` in all other states (`queued`, `in_progress`, `interrupted`, `failed`, `cancelled`).
- {INV-004} Run error (`error`) is populated ONLY when `status = "failed"`. It is `null` in all other states.
- {INV-005} A Run cannot be in `in_progress` state if no executor task is active for it (no orphan runs).
- {INV-006} **Run-Config Merge Precedence (F-P33-02):** When a Create-Run request body supplies `config`,
  `metadata`, or `context`, these values are **deep-merged** over the Assistant's stored values
  at the leaf-key level, with run-supplied keys winning over Assistant-stored keys on any
  collision. Fields absent from the run request body retain the Assistant's stored values
  unchanged. This applies to each of the three fields independently. Merge is applied at run
  creation time before the run is dispatched to the executor; the merged effective config is
  what the graph receives. **Upstream-check result:** BC-2.01.003 {PC-006} specifies that metadata
  "accumulates" down the run tree (consistent with merge; run wins), and semport behavioral-intent
  §2.3 declares no explicit merge rule for run-over-assistant config — no contradiction found.
  Leaf-level deep-merge is adopted as spec canon. Cross-ref: BC-2.12.002 §Description.

- {INV-007} **Panic-text-isolation:** Raw panic text from ANY internal-panic error code MUST NOT
  appear in `Run.error.message`. The `pregolya-server` run-executor applies STATIC message
  replacement for ALL internal-panic error codes before populating `Run.error.message`:
  - **E-GRAPH-019 NodePanic** (node-body panic, caught by
    `FutureExt::catch_unwind(AssertUnwindSafe(...))`): STATIC message:
    `"NodePanic: graph node panicked during execution — see server error log for details"`.
    Raw panic text is logged at ERROR severity server-side only.
  - **E-GRAPH-011 ConditionalEdgePanic** (conditional-edge `path_fn` panic, caught by the Pregel
    executor per BC-2.02.005 {PC-005}; surfaces as `Err(PregolyaError { code: "E-GRAPH-011", .. })`):
    STATIC message:
    `"ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details"`.
    The `source_node` field and any captured panic text in the error's `message` are suppressed at
    the HTTP boundary; the raw panic text is logged at ERROR severity server-side only.
  No dynamic content from any panic (backtrace, panic message, source location, source_node topology)
  is included in `Run.error.message` for any internal-panic code. This prevents information
  disclosure (CWE-209) and internal graph topology leakage via the Run status polling endpoint.
  Symmetric with the MCP boundary's uniform panic treatment (ADR-029 §Decision 5; BC-2.09.008 EC-003).

- {INV-008} **External-Boundary Error-Sanitization (DI-010 Credential Opacity; CWE-209/CWE-532):**
  `Run.error.message` MUST be processed through the following sanitization pipeline BEFORE it is
  returned to an external caller via {PC-013} (`GET /threads/{thread_id}/runs/{run_id}`) or stored
  as the `error` field on the Run record surfaced by {PC-016}:
  1. **Internal-panic static-replace** (per {INV-007}): if `error.code ∈ {"E-GRAPH-011", "E-GRAPH-019"}`,
     replace `error.message` with the corresponding STATIC message — no dynamic panic text, no
     `source_node` topology.
  2. **`redact_credentials`**: scan `error.message` for credential-shaped substrings matching the
     canonical six-pattern set (BC-2.09.007 {INV-003}(b)) and replace each match with `"<redacted>"`:
     (1) OpenAI key `sk-[A-Za-z0-9_\-]{20,}`, (2) Anthropic key `sk-ant-[A-Za-z0-9_\-]{32,}`,
     (3) generic long alphanumeric token `[A-Za-z0-9]{64,}`, (4) Bearer token
     `Bearer\s+[A-Za-z0-9._~+/=\-]+` (entire `Bearer <token>` span),
     (5) URL-embedded userinfo `[a-zA-Z][a-zA-Z0-9+.\-]*://[^/\s:@]+:[^/\s:@]+@`,
     (6) HTTP Basic auth `Basic\s+[A-Za-z0-9+/=]+`. Symmetric with BC-2.09.008 {INV-003}.
  3. **`sanitize_internal_ids`**: replace UUID-shaped internal identifiers that are opaque
     implementation details (internal trace IDs, node instance IDs, run IDs not already
     disclosed to the caller via the HTTP path or request body) with `"<redacted-id>"`.
     **`u64` CheckpointId carve-out:** `CheckpointId` is a `u64` newtype (ADR-005 /
     BC-2.04.003) — NOT UUID-shaped; the UUID regex cannot match it. `u64` checkpoint IDs
     are NOT covered by this pass; authoring-site discipline (BC-2.09.008 {INV-001}) is their
     sole framework guarantee — node implementations MUST NOT embed checkpoint IDs in
     externally surfaced error messages (mirrors BC-2.09.008 {INV-001} / ADR-029
     SEC-BOUND-001 step 3 verbatim).
  Pipeline order is mandatory: step 1 THEN step 2 THEN step 3. This matches the MCP boundary's
  uniform error-sanitization pipeline (ADR-029 §Decision 3 + ADR-029 §Decision 5; BC-2.09.008
  {INV-001}/{INV-003}). This invariant closes the DI-010 Credential Opacity gap on the HTTP
  Run-status surface.

- {INV-009} **Fork-Start Configurable Key (`config.configurable.checkpoint_id`):** When a Create-Run request body includes `config.configurable.checkpoint_id = <CheckpointId>`, the executor MUST initialize the run's starting thread state from the stored `ChannelValues` at that checkpoint (rather than from the thread's `current_checkpoint`). Prerequisites: (a) the value MUST be a valid `u64` `CheckpointId` (ADR-005 / BC-2.04.003) owned by the given `thread_id`; (b) if the checkpoint does not exist in the `CheckpointSaver` → HTTP 422 `{ code: "E-CHKPT-011", message: "CheckpointNotFound: checkpoint '<checkpoint_id>' does not exist on thread '<thread_id>'" }` (EC-008); no Run is created. Post-fork behavior: the new Run's subsequent checkpoints are written normally and become the new `current_checkpoint` after the run completes — the fork does NOT delete or roll back existing checkpoints (distinct from `multitask_strategy: "rollback"` which resets the checkpoint chain). The `config.configurable.checkpoint_id` key takes precedence over the thread's `current_checkpoint` as the run's initialization point. Source: D-356 fork-from-checkpoint developer-console use case (BC-2.24.005 {PC-003}); idiomatic LangGraph fork-start pattern.

## Edge Cases

### EC-001: Create Run on non-existent thread
**Scenario:** `POST /threads/ghost/runs { ... }`.
**Expected behavior:** HTTP 404 `{ code: "E-SERVER-003", message: "ThreadNotFound: thread 'ghost' does not exist" }`. No Run is created.

### EC-002: Concurrent run with multitask_strategy=reject (default)
**Scenario:** Thread "t1" has an `in_progress` Run; another `POST /threads/t1/runs` arrives with
default `multitask_strategy`.
**Expected behavior:** HTTP 409 `{ code: "E-SERVER-012", message: "ConcurrentRun: thread 't1' already has an active run; use multitask_strategy to override" }`.

### EC-003: Run fails due to unhandled graph error or node-body panic
**Scenario:** A graph node returns `Err(PregolyaError { .. })` or panics during execution.
**Expected behavior (node returns Err):** `GraphRunner` propagates `Err(PregolyaError { .. })`.
Run transitions `in_progress → failed` with `error` populated from the `PregolyaError`.
**Internal-panic Err sanitization:** if the propagated error carries code `"E-GRAPH-011"`
(ConditionalEdgePanic — conditional-edge `path_fn` panic caught by the Pregel executor per
BC-2.02.005 {PC-005}), the `pregolya-server` run-executor MUST static-replace the error's
`message` field BEFORE writing to `Run.error.message` (per {INV-007}). The STATIC replacement
is: `"ConditionalEdgePanic: conditional edge function panicked during execution — see server
error log for details"`. The original `message` (which contains captured panic text and may
contain `source_node` topology) is logged at ERROR severity server-side only and MUST NEVER
appear in `Run.error.message` (CWE-209). This static-replace applies uniformly for all
E-GRAPH-011 errors — it is not conditional on whether panic text is present in the message.
DI-014 ensures the error is not silently swallowed. The thread's checkpoint state reverts
to the last successful checkpoint before the failed Run.
**Expected behavior (node body PANICS):** The `pregolya-server` run-executor wraps graph
execution in `futures::future::FutureExt::catch_unwind(AssertUnwindSafe(...))`. A panic in
a node body during `.await` polling is caught; the executor converts it to:
`Err(PregolyaError { code: "E-GRAPH-019", category: INTERNAL,
message: "NodePanic: graph node panicked during execution — see server error log for details",
retry_hint: Never, .. })`.
Run transitions `in_progress → failed` with `error` populated from the E-GRAPH-019 STATIC
message. Raw panic text is logged server-side at ERROR severity only — it MUST NEVER appear
in `Run.error.message` (panic-text-isolation per {INV-007}). The run MUST NOT remain in
`in_progress` state after the panic is caught — {INV-005} (no orphan runs) is upheld.
The thread's checkpoint state reverts to the last successful checkpoint before the failed Run.
**Both paths:** DI-014 ensures neither error is silently swallowed.
**SEC-008:** This panic recovery requires `panic = "unwind"` in the workspace-root
`[profile.release]` governing the `pregolya-server` binary; a library-member
`[profile.release] panic` override is silently ignored by Cargo and MUST NOT be relied upon;
`panic = "abort"` at the workspace root voids the catch and causes process termination (CWE-248).

### EC-004: Get run with wrong thread_id
**Scenario:** `GET /threads/t2/runs/<run_id>` where the run belongs to thread `t1`.
**Expected behavior:** HTTP 404 `E-SERVER-002 RunNotFound`. The run exists but is
scoped to a different thread — cross-thread run access is not permitted.

### EC-005: Delete an active (in_progress) run
**Scenario:** `DELETE /threads/t1/runs/<run_id>` while `status = "in_progress"`.
**Expected behavior:** HTTP 409 `{ code: "E-SERVER-018", message: "RunStateConflict: cannot perform 'delete' on run '<run_id>' in state 'in_progress'" }`. Caller must cancel the run first (`POST /threads/t1/runs/<run_id>/cancel`), wait for terminal state, then delete.

### EC-006: Invalid state transition — operation on run in incompatible state (P2A-044 F-08)
**Scenario:** Any operation that the Run state machine does not permit in the Run's current state: (a) `POST .../cancel` on a Run in a terminal state (`completed`, `failed`, `cancelled`, `summary_halt`); (b) `DELETE .../runs/{run_id}` on a Run in a non-terminal state (`queued`, `in_progress`, `interrupted`). Distinct from EC-002 (ConcurrentRun / E-SERVER-012) which is about a second Run conflicting on the same Thread, not about an invalid transition on an existing Run.
**Expected behavior:** HTTP 409 `{ code: "E-SERVER-018", message: "RunStateConflict: cannot perform '<operation>' on run '<run_id>' in state '<current_state>'" }`. Three struct fields: `run_id` (String), `current_state` (String), `operation` (String, value `"cancel"` or `"delete"`). The run record is not mutated; no state change occurs. Caller must first bring the run to a compatible state before retrying (e.g., wait for natural completion, or use the correct endpoint). Error code: E-SERVER-018 RunStateConflict (POLICY; RetryHint: Never — the same operation on the same terminal/non-terminal run always fails while the state persists).

### EC-007: Enqueue queue full — max_queued_runs reached (ADR-028 Decision 3) {EC-007}
**Scenario:** Thread `"t1"` has one `in_progress` Run and 10 `queued` Runs (default `max_queued_runs=10`). A new `POST /threads/t1/runs { multitask_strategy: "enqueue" }` arrives.
**Expected behavior:** HTTP 429 `{ code: "E-SERVER-019", message: "RunQueueFull: thread 't1' already has 10 queued run(s); max_queued_runs=10" }`. No new Run is created. The caller should wait for the `in_progress` Run to reach a terminal state (freeing a queue slot) and then retry. RetryHint: Later (queue slot opens when the in_progress run completes — ADR-028 Decision 3).

### EC-008: Fork-from-checkpoint with non-existent checkpoint_id ({INV-009}) {EC-008}
**Scenario:** `POST /threads/t1/runs { assistant_id: "a1", config: { configurable: { checkpoint_id: 9999 } } }` where checkpoint `9999` does not exist on thread `t1`.
**Expected behavior:** HTTP 422 `{ code: "E-CHKPT-011", message: "CheckpointNotFound: checkpoint '9999' does not exist on thread 't1'" }`. No Run is created; the thread's current state is unchanged. The `CheckpointSaver` lookup fails to resolve `checkpoint_id=9999` for `thread_id=t1`. Error code: E-CHKPT-011 CheckpointNotFound (POLICY; HTTP 422; registered in error-taxonomy.md v1.73). Caller must use a valid `checkpoint_id` from the thread's checkpoint history (`GET /threads/t1/history` per BC-2.12.001).

## Canonical Test Vectors

| # | Input | Expected Output | Notes |
|---|-------|-----------------|-------|
| TV-001 | `POST /threads/t1/runs { assistant_id: "a1", input: { message: "hello" } }` | HTTP 202, `{ run_id, status: "queued" }` | Happy-path create |
| TV-002 | Poll `GET /threads/t1/runs/<run_id>` until status changes | `queued → in_progress → completed` with `output` populated | Lifecycle progression |
| TV-003 | `GET /threads/t1/runs/nonexistent` | HTTP 404 E-SERVER-002 | Run not found |
| TV-004 | `GET /threads/ghost/runs/<run_id>` (wrong thread) | HTTP 404 E-SERVER-002 | Thread scoping enforced |
| TV-005 | Graph node returns error → run status | `status: "failed"`, `error: { code: "E-GRAPH-...", ... }` | Error surfacing |
| TV-006 | Second run on same thread, default strategy | HTTP 409 E-SERVER-012 | Concurrent rejection |
| TV-007 | `GET /threads/t1/runs?status=completed` | Filtered list of completed runs | Status filter |
| TV-008 | Thread `t1` has active `in_progress` Run `r1`; `POST /threads/t1/runs { multitask_strategy: "interrupt" }` | HTTP 202, new Run `r2` in `queued`; `r1` transitions to `cancelled`; after `r1` cancelled durably, `r2` transitions to `in_progress` | multitask_strategy=interrupt |
| TV-009 | Thread `t1` has active Run `r1` (3 checkpoints written); `POST /threads/t1/runs { multitask_strategy: "rollback" }` | HTTP 202, new Run `r2`; `r1` transitions to `cancelled`; checkpoint rows from `r1` deleted (only rows up to `latest_completed_checkpoint_id` retained); `r2` starts against rolled-back state | multitask_strategy=rollback |
| TV-010 | Thread `t1` has active `in_progress` Run `r1` and 10 `queued` Runs (queue at capacity); `POST /threads/t1/runs { multitask_strategy: "enqueue" }` | HTTP 429 `E-SERVER-019 RunQueueFull` | multitask_strategy=enqueue queue-full |
| TV-011 | Run `r1` on thread `t1` is `in_progress`; a graph node body calls `panic!("unexpected node failure")`; poll `GET /threads/t1/runs/r1` | Run `r1` transitions to `status: "failed"` (NOT `in_progress`); `error.code == "E-GRAPH-019"`; `error.message == "NodePanic: graph node panicked during execution — see server error log for details"` (STATIC — literal string equality); `error.message` does NOT contain `"unexpected node failure"` or any other panic text; no run remains orphaned in `in_progress` state | Node-body panic → E-GRAPH-019 STATIC message; panic-text-isolation ({INV-007}); no orphan `in_progress` ({INV-005}); EC-003 node-body-panic path; SEC-008 requires `panic = "unwind"` in the workspace-root `[profile.release]` governing the `pregolya-server` binary; library-member `[profile.release] panic` overrides are silently ignored by Cargo (CWE-248) |
| TV-012 | Run `r1` on thread `t1` is `in_progress`; a conditional-edge `path_fn` panics with message `"unexpected routing failure"` and `source_node: "node_A"`; the Pregel executor catches it as `E-GRAPH-011 ConditionalEdgePanic`; poll `GET /threads/t1/runs/r1` | Run `r1` transitions to `status: "failed"` (NOT `in_progress`); `error.code == "E-GRAPH-011"`; `error.message == "ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details"` (STATIC — literal string equality); `error.message` does NOT contain `"unexpected routing failure"` or `"node_A"` or any other panic text or source_node topology; no run remains orphaned in `in_progress` state | Conditional-edge panic → E-GRAPH-011 STATIC message; source_node topology suppressed; panic-text-isolation ({INV-007}); no orphan `in_progress` ({INV-005}); EC-003 Internal-panic Err sanitization path; mirrors E-GRAPH-019/TV-011 pattern; closes F-P2A197-01 (CWE-209) |
| TV-013 | Run `r1` fails; a graph node returned `Err(PregolyaError { code: "E-GRAPH-003", message: "provider auth failed: Bearer sk-ant-api03-XXXXX-secretsuffix", .. })`; poll `GET /threads/t1/runs/r1` | `error.code == "E-GRAPH-003"`; `error.message` does NOT contain `"Bearer sk-ant"` or any credential token substring; credential-shaped substring replaced with `"<redacted>"` per {INV-008} step 2 | Credential-in-error-message redaction; External-Boundary Error-Sanitization ({INV-008}); DI-010 Credential Opacity; symmetric with BC-2.09.008 {INV-003}; closes F-P2A197-02 (CWE-209/CWE-532) |
| TV-014 | `POST /threads/t1/runs { assistant_id: "a1", config: { configurable: { checkpoint_id: 5 } } }` where checkpoint `step_idx=5` exists on thread `t1` | HTTP 202, new `run_id`; executor initializes run state from checkpoint `5` stored `ChannelValues`; run proceeds forward from that state; existing checkpoints beyond step 5 are NOT deleted; new run's checkpoints become the new `current_checkpoint` after completion | Fork-from-checkpoint happy path; {INV-009}; BC-2.24.005 {PC-003}; D-356 fork-start pattern |

## Verification Properties

_No Kani VP seed required. Integration tests against in-process pregolya-server and
pregolya-graph engine are sufficient._

## Related BCs

- BC-2.12.001 — depends on: Runs are executed against Threads; thread must exist before run creation
- BC-2.12.002 — depends on: Runs reference an Assistant config at creation time
- BC-2.05.002 — sibling: HITL interrupt resume contract covers the `interrupted` pausable state resume path (interrupted → in_progress transition)
- BC-2.24.005 — fork-from-checkpoint consumer ({INV-009} via {PC-003})

## Architecture Anchors

- `pregolya-server/src/api/runs.rs` — Run CRUD handlers
- `pregolya-server/src/executor.rs` — Async executor dispatching pending runs to graph engine
- `pregolya-server/src/store/run_store.rs` — `RunRecord` and lifecycle state persistence

## Story Anchor

S-1.26 (primary — Run CRUD and execution lifecycle)

S-console-07 (roadmap, Wave 3 — consumes {INV-009} fork-start via BC-2.24.005 {PC-003})

## VP Anchors

None

## Traceability

| Field | Value |
|-------|-------|
| Source L2 Capability | CAP-014 |
| Capability Anchor Justification | CAP-014 ("Durable-Run HTTP Server (Threads, Assistants, Runs, Crons)") per capabilities-p1-p2.md §CAP-014 — this BC implements the Run resource lifecycle, which is explicitly listed as the third of the four managed resources: "Run (single execution)". Canonical state machine: queued → in_progress → completed/failed/cancelled/summary_halt; interrupted is pausable/resumable ({PC-007}-{PC-009} are the authoritative source; see {PC-007} for transition arcs, {PC-008} for terminal-set definition, {PC-009} for interrupted→in_progress resume arc) |
| L2 Domain Invariants | — |
| DEC Reference | DEC-006 (Resume Value Injection with Empty Interrupt Queue — applies to the `interrupted` state resume path) |
| Risk Source | — |
| Priority | P1 |
| Wave | Wave 1 |
| Test Types | I (integration), E2E (end-to-end) |
| Module | pregolya-server |
| Error Codes | E-GRAPH-019 NodePanic (INTERNAL, broken, Never) — minted at this BC's EC-003 node-body-panic path ({INV-007} panic-text-isolation enforcer); STATIC message: "NodePanic: graph node panicked during execution — see server error log for details"; raised by pregolya-server run-executor when `FutureExt::catch_unwind` catches a node-body panic during `.await` polling; raw panic text suppressed at HTTP boundary (CWE-209). E-GRAPH-011 ConditionalEdgePanic (INTERNAL) — defined at BC-2.02.005 {PC-005} (Pregel executor catches conditional-edge `path_fn` panic); referenced here because pregolya-server run-executor applies {INV-007} STATIC message replacement for E-GRAPH-011 (`"ConditionalEdgePanic: conditional edge function panicked during execution — see server error log for details"`) before populating `Run.error.message`; captured panic text and `source_node` topology suppressed at HTTP boundary (CWE-209; F-P2A197-01). E-CHKPT-011 CheckpointNotFound (POLICY; HTTP 422; minted at this BC's EC-008 fork-start path; {INV-009} enforcer; registered in error-taxonomy.md v1.73) — raised when `config.configurable.checkpoint_id` is set on Create-Run but the specified checkpoint does not exist in the `CheckpointSaver` for the given thread. |
