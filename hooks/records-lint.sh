#!/usr/bin/env bash
# records-lint.sh — pregolya factory records discipline lint
#
# Runs before every factory commit (.factory/ worktree). exit 0 = PASS, exit 1 = FAIL.
#
# CHECKS (by ID — violations route by ID):
#   L1 — Version/Changelog Parity: frontmatter version > "1.0" requires at least one
#        changelog entry (Form A: frontmatter `changelog:` key, or Form B: `## Changelog`
#        body section). Codifies lesson L-010 (Gate #28) as a mechanical gate.
#        Routing: state-manager (frontmatter fix) or spec owner (changelog authoring).
#
#   L7 — Changelog Monotonic Order: version entries in a `## Changelog` body section
#        must appear in non-increasing (newest-first) order. A version number found AFTER
#        a strictly lower version number is a violation.
#        Routing: spec owner (reorder changelog entries so newest appears first).
#
#   L9 — Line-Cite and Version-Pin Ban (D-50 + P2A-050 extended, 2026-08-25):
#        L9a (extended, P2A-050 2026-08-25 + DC-29/F-PDC29-03 2026-09-08):
#        newly-authored lines must not contain any of four volatile line-citation
#        forms. All four decay on the next diff and rot the trace (TD-VSDD-091 /
#        POL-12); all use addition-only git diff HEAD scoping (hooks excluded; no
#        separate date-boundary required):
#          (i)   file:NNN — line-number citations of the form `word.ext:digits`
#                (the original L9a form; e.g. `lib.rs:42`, `CLAUDE.md:156`)
#         (ii)   bare line references — `line ~N` or `line N` in normative prose
#                (e.g. `§Changelog line ~44`; caught by BARE_LINE_CITE_PATTERN)
#        (iii)   ID-anchored line pins — `DOCID:NNN` citations
#                (e.g. `BC-2.10.001:141`, `ADR-020:224`; caught by ID_LINE_PIN_PATTERN)
#         (iv)   prose file:line — `filename.ext line NNN` or `filename.ext lines NNN`
#                (e.g. `api-surface.md line 258`; caught by PROSE_LINE_CITE_PATTERN)
#                Anchoring on the `.ext` before `line NNN` avoids false-positives
#                from compound words ending in "line" (pipeline, baseline, guideline,
#                deadline, timeline, airline, etc.).
#                Closes hook-coverage gap F-PDC29-03 (DC-29, 2026-09-08).
#        L9b (D-50): newly-authored lines must not contain `<doc> vN.N` version pins
#        (e.g. `ADR-014 v1.2`, `BC-2.01.001 v1.0`, `error-taxonomy.md v1.31`).
#        L9a sub-checks use `git diff HEAD` restricted to `+` addition lines (not
#        deletions, not context). L9b uses a Python3 scanner (Bug 1 fix; avoids
#        VERSION_PIN_PATTERN alternation-precedence issues in embedded grep ERE).
#        .factory/hooks/** excluded from diff: hook scripts are code, not records.
#        Changelog entries and YAML frontmatter are IN SCOPE — D-50 targets version
#        pins wherever they live. The sole grandfathering mechanism for L9b is the
#        entry-date boundary: a + line whose YYYY-MM-DD date is before 2026-07-24 is
#        exempt (pre-D-50 text); no parseable date → in scope. This deliberately
#        disagrees with verify-no-version-pins.sh (full-corpus; changelog exempt).
#        L9a (all four forms) grandfathers pre-existing committed content via the
#        addition-only `git diff HEAD` scoping — no date-boundary needed.
#        Routing: finding author (replace file:NNN / bare line~N / DOCID:NNN /
#                 file.ext line NNN with symbol/anchor cite; replace doc vN.N with
#                 doc §Section-Anchor).
#
#   L10 — Hash-Digest Ban (ADVISORY): newly-authored changelog prose must not contain
#        standalone 7-hex-literal git SHA fragments (e.g. `5fc3abe → baaf36d`). These
#        are volatile pins of the TD-VSDD-091 family — they decay on the next refresh
#        with nothing to detect the stale reference. The compliant form names the upstream
#        artifact and section: `input-hash refreshed (ADR-014 §Decision 2 edited)`.
#        ADVISORY: non-blocking WARN in FIX-BURST-276 (Wave A). Promotion to blocking
#        after Wave B closes finding IDs P1D-173-L10-class in verification-properties/.
#        Exclusion: YAML hash-field assignments (HASH_FIELD_EXCLUSION); Rust numeric
#        literal type-suffix tokens (CE5/RUST_LITERAL_EXCL — e.g. `1e20f32` in VP prose
#        documents floating-point overflow behavior, not a content hash).
#        Routing: finding author (replace 7-hex SHA with artifact+section anchor cite).
#
#   L11 — Content-Hash Digest Ban (BLOCKING): newly-authored record/changelog/spec prose
#        must not contain standalone 8+ character lowercase hex digest literals. These are
#        the TD-VSDD-091 volatile-pin family at the content-hash level — citing a raw
#        hash value (SHA-1, SHA-256, MD5, or longer partial digest) as evidence of
#        input-file identity creates a reference that goes stale the moment the input
#        changes, with no behavioral anchor a future pass can verify against. Closes
#        F-P173-505 (FIX-BURST-276 Wave B). Existing text in HEAD is grandfathered via
#        the same `git diff HEAD` scoping as L9. Corpus-wide grandfathered count: ~75
#        lines across ~22 files; state-manager owns the cleanup schedule.
#        Exclusions (lines matching ANY of CE1–CE4 are exempt):
#          CE1 — YAML frontmatter hash-field assignments (`input-hash:`, `develop_head:`,
#                `frozen_head:`, etc.); the field VALUE is legitimate structured metadata.
#          CE2 — Frozen-HEAD citation lines (`**Frozen HEAD:**`, etc.); validated by
#                verify-sha-currency.sh — the only sanctioned prose SHA citations.
#          CE3 — `[live-state]` sentinel lines; ephemeral wrap-state markers replaced
#                each session, validated by verify-sha-currency.sh.
#          CE4 — Rust toolchain build-hash format `(HEX YYYY-MM-DD)` from `rustc -V`.
#        Known scope boundary: uppercase hex (`ABC123...`) is out of scope — all hash
#        outputs in this project are lowercase; uppercase appears only in Rust code
#        literals (`0xDEADBEEF`) where the `x` prefix prevents `\b` word-boundary match.
#        CE5/RUST_LITERAL_EXCL applies to L11 as well: Rust float literals (`1e200f64`,
#        `3e38f128`) and binary literals (`0b10101010`) that produce 8+ hex-looking char
#        sequences are excluded; they document numeric ranges in VP bodies, not hash pins.
#        Routing: finding author (replace hex digest literal with artifact+section anchor
#                 cite, e.g. `input-hash refreshed (ADR-014 §Decision 2 edited)`).
#
#   L12 — Dead-Brand-Token Recurrence Guard (BLOCKING): newly-authored additions in
#        specs/**/*.md must not contain ferrochain-era brand tokens:
#        `ferrochain`, `ferroctmp`, `ferrograph`, `FerrochainError` (case-insensitive).
#        Scoped to specs/ tree ONLY — planning/ is explicitly out of scope (legitimate
#        rename documentation, naming-decision-study, rename-sweep-manifest, and
#        decisions-archive all live there). Existing content in HEAD is grandfathered
#        via git diff HEAD scoping (covers ADR-010 lines 19/179 FerrochainError corrective
#        notes without needing explicit per-file allowlist entries).
#        Exclusions:
#          DE1 — Historical/clarifier qualifiers: lines where the dead brand token
#                appears adjacent to a rename/historical marker. Covers: "formerly
#                'ferrograph'", "renamed from ferrochain", "ferrochain-era",
#                "ferrochain→pregolya" (transition arrow), "not FerrochainError".
#          DE2 — Scoping: planning/ files are out of scope (diff restricted to specs/).
#        Routing: finding author (replace dead brand token with canonical pregolya-*
#                 equivalent: ferrochain→pregolya, ferrograph→pregolya-graph,
#                 ferroctmp→pregolya-checkpoint, FerrochainError→PregolyaError).
#
# SELF-PROBE: Each check self-probes against a synthetic violation before running on
#             the real corpus. A self-probe failure means the check would be false-green —
#             the script exits 2 immediately (script bug, not lint violation).
#             Disable with --skip-self-probe for CI environments where probe cost matters.
#
# Cross-applied from the CLIP email-notifications Stage-3 cascade
# (trend-gate #4 structural intervention + S3-39..S3-42 evidence), human-directed 2026-07-24.
#
# Usage: bash .factory/hooks/records-lint.sh [--skip-self-probe]
# Exit:  0 if no FAIL lines; 1 on lint violations; 2 on self-probe failure (script bug).

set -euo pipefail

SKIP_SELF_PROBE=false
for arg in "$@"; do
  case "$arg" in
    --skip-self-probe) SKIP_SELF_PROBE=true ;;
  esac
done

# ── Config ────────────────────────────────────────────────────────────────────
# Derived from .factory/artifact-path-registry.yaml artifact_types.
# Add new patterns here when new records-tier artifact types are registered.
# TODO(workspace-init): After workspace-init finalises artifact paths, verify
#   that all RECORDS_PATTERNS below match at least one file under FACTORY_DIR.

FACTORY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
HOOKS_DIR="${FACTORY_DIR}/hooks"

# Records-tier file glob patterns (relative to FACTORY_DIR).
# Covers all artifact types declared in artifact-path-registry.yaml.
RECORDS_PATTERNS=(
  "specs/behavioral-contracts/**/*.md"      # behavioral-contract, bc-index
  "specs/architecture/**/*.md"              # architecture-doc, adr, architecture-index, architecture-section
  "specs/prd-supplements/*.md"              # prd-supplement
  "specs/prd.md"                            # prd
  "specs/product-brief.md"                  # product-brief
  "specs/module-criticality.md"             # module-criticality
  "specs/domain-spec/*.md"                  # domain-spec
  "specs/verification-properties/*.md"      # verification-property, vp-index
  "cycles/*/cycle-manifest.md"              # cycle-manifest
  "cycles/*/burst-log.md"                   # burst-log
  "cycles/*/convergence-trajectory.md"      # convergence-trajectory
  "cycles/*/lessons.md"                     # lessons (records tier)
  "stories/*.md"                            # story
  "holdout-scenarios/*.md"                  # holdout-scenario
  # TODO: semport/**/*.md — semport analysis files; add once semport artifact
  #   type is registered in artifact-path-registry.yaml
  # TODO: planning/*.md — planning artifacts; add if/when registered in registry
)

# L9a line-citation patterns — three forms, all addition-only (git diff HEAD scoping).
# P2A-050 (2026-08-25) extended L9a to cover forms (ii) and (iii) in addition to
# the original form (i). All three are equally volatile per TD-VSDD-091 / POL-12.
#
# Form (i): file:NNN — word.ext:digits where ext is a known code/doc extension.
# Catches: lib.rs:42  CLAUDE.md:156  Cargo.toml:8  api-surface.md:23
# Does NOT catch: version strings (v1.2.3), URLs, colon-delimited identifiers
#   without a leading file extension.
LINE_CITE_PATTERN='\b[a-zA-Z0-9_.-]+\.(rs|md|toml|yaml|yml|ts|js|py|json|sh|txt):[0-9]{1,6}\b'

# Form (ii): bare line reference — `line ~N` or `line N` in normative prose.
# Catches: "line ~44", "line 224", "line ~36" (the P2A-050 live-violation shape:
#   "§Changelog line ~44" passed the old L9a gate; this closes the gap).
# Does NOT catch: "pipeline", "baseline", "online" (no word boundary before "line"),
#   or "line item 3" / "line number X" (space + non-digit breaks the match).
BARE_LINE_CITE_PATTERN='\bline[[:space:]]+~?[0-9]{1,6}\b'

# Form (iii): ID-anchored line pin — DOCID:NNN (doc identifier followed by colon+digits).
# Catches: "BC-2.10.001:141", "ADR-020:224", "VP-003:36", "CAP-001:12"
# These are doc-ID:line-number citations — equally volatile as file:NNN citations.
# Does NOT catch: "BC-2.10.001:" without trailing digits (YAML key syntax), or
#   bare doc IDs without a colon+digits suffix.
ID_LINE_PIN_PATTERN='\b(BC-2\.[0-9]{2}\.[0-9]{3}|ADR-[0-9]+|VP-[0-9]{3}|CAP-[0-9]{3}):[0-9]{1,6}\b'

# Form (iv): prose file:line — `filename.ext line NNN` or `filename.ext lines NNN`.
# Catches: "api-surface.md line 258", "lib.rs lines 42", "CLAUDE.md line 156"
# Anchored on a known code/doc file extension immediately before `lines?` + digits.
# The extension anchor prevents false-positives from compound words that END in "line":
#   "pipeline 5", "baseline 3", "guideline 12", "deadline 7", "timeline 8",
#   "airline 2", "hotline 1", "outline 9", "skyline 4", "mainline 6" — none of
#   these have a `.ext` token before the word "line", so they do NOT match.
# Does NOT match: "command line 3" (no dot-extension before "line").
# Closes hook-coverage gap F-PDC29-03 (DC-29, 2026-09-08).
PROSE_LINE_CITE_PATTERN='\b[a-zA-Z0-9_.-]+\.(rs|md|toml|yaml|yml|ts|js|py|json|sh|txt)[[:space:]]+lines?[[:space:]]+[0-9]{1,6}\b'

# L9 version-pin class pattern (D-50, ratified 2026-07-24).
#
# TD-VSDD-091 extended to `<doc> vN.N` version pins in text authored on or
# after 2026-07-24.  Examples of violations:
#   ADR-014 v1.2      BC-2.01.001 v1.0    VP-003 v1.1    CAP-001 v1.2
#   error-taxonomy.md v1.31               error-taxonomy.md (v1.31, D23)
#
# The 2026-07-24 date boundary is enforced via two mechanisms:
# (a) git diff HEAD: only `+` addition lines are checked (not deletions, context).
# (b) Entry-date extraction: `+` lines carrying a YYYY-MM-DD date before 2026-07-24
#     are grandfathered (pre-D-50 entries authored before the rule was ratified).
#     Lines with no parseable date are in scope.
#
# Scope note: changelog entries and YAML frontmatter are IN SCOPE for L9b. D-50
# specifically targets these regions because version pins live almost exclusively
# in changelog entries. The date boundary is meaningful precisely BECAUSE changelogs
# are in scope — it grandfathers pre-ratification text while catching newly-authored
# pins. This deliberately disagrees with verify-no-version-pins.sh (full-corpus
# scan; changelogs exempt) — the two rules have different scoping rationales.
#
# Pattern covers the same forms as verify-no-version-pins.sh PIN_RE (burst-288 parity):
#   1. ADR-NNN vX.Y       2. BC-2.SS.NNN vX.Y   3. VP-NNN vX.Y
#   4. CAP-NNN vX.Y       5. XXX-INDEX vX.Y (VP-INDEX, BC-INDEX, ARCH-INDEX, etc. — burst-288)
#   6. filename.md (vX.Y  7. filename.md vX.Y
VERSION_PIN_PATTERN='(ADR-[0-9]+|BC-2\.[0-9]{2}\.[0-9]{3}|VP-[0-9]{3}|CAP-[0-9]{3})[[:space:]]+v[0-9]+\.[0-9]+|[a-z0-9][a-z0-9_-]*\.md[[:space:]]+\(?v[0-9]+\.[0-9]+'

# L10 hash-digest pattern.
# Matches standalone 7-character lowercase-hex strings (git SHA fragments).
# Catches: `5fc3abe → baaf36d`, `c745d15 → c504e82`, etc. in changelog prose.
# Does NOT match lines that are YAML hash-field assignments like `input-hash: "abc1234"`.
HASH_DIGEST_PATTERN='\b[0-9a-f]{7}\b'
# YAML hash-field exclusion: lines of the form `  key: "7hex"` or `  key: 7hex`
# These are structured frontmatter fields, not prose — exempt from L10.
HASH_FIELD_EXCLUSION='^\+[[:space:]]*(input.hash|proof_file_hash|commit.hash|content.hash)[[:space:]]*:[[:space:]]*"?[0-9a-f]'

# L11 content-hash digest pattern.
# Matches standalone 8+ character lowercase-hex strings (content-hash digest literals).
# 8-char minimum is the complement of L10's 7-char scope: captures SHA-1 (40 chars),
# SHA-256 (64 chars), MD5 (32 chars), and any partial digest used as a content pin.
# Does NOT match inline code hex literals where the `0x` prefix or embedding in a
# longer word-char sequence prevents `\b` matching.
CONTENT_HASH_PATTERN='\b[0-9a-f]{8,}\b'

# L11 EXCLUSIONS — lines matching ANY of CE1-CE4 are exempt from L11.
#
# CE1: YAML frontmatter hash-field assignments. The field VALUE is legitimate structured
#      metadata; what is forbidden is restating that value as prose evidence. Covers all
#      hash-bearing YAML keys used in factory artifact frontmatter, including STATE.md
#      develop_head and adversarial-pass-record frozen_head fields.
CONTENT_HASH_CE1='^\+[[:space:]]*(input.hash|input_hash|proof_file_hash|commit.hash|content.hash|develop_head|frozen_head)[[:space:]]*:[[:space:]]*"?[0-9a-f]'

# CE2: Frozen-HEAD citation lines — sanctioned by verify-sha-currency.sh. These are the
#      only prose SHA citations the project allows; verify-sha-currency.sh validates each
#      one against the actual git ref. Covers: `**Frozen HEAD:** commit (...)`, `frozen
#      HEAD burst-NNN`, `Frozen HEAD (burst-NNN commit, SHA ...)`. Case-insensitive on
#      all letters via explicit character classes; accepts `-` or space as separator.
#      Note: "HEAD" in git parlance is always uppercase; "head" (lowercase) is less common.
#      The full `[Hh][Ee][Aa][Dd]` expansion covers both forms without requiring `-i` flag.
CONTENT_HASH_CE2='[Ff]rozen[-[:space:]][Hh][Ee][Aa][Dd]'

# CE3: [live-state] sentinel lines. These are ephemeral wrap-state markers that record
#      current git SHA during a session. They are replaced each session wrap and validated
#      by verify-sha-currency.sh. Matched as a literal string (brackets are not regex here).
# Note: grep -F is used for CE3 in check_l11 (literal bracket-string match).

# CE4: Rust toolchain build-hash format. `rustc -V` emits `X.Y.Z (NNNNNNNN YYYY-MM-DD)`;
#      this appears in preflight reports and toolchain verification tables. The
#      `(HEX YYYY-MM-DD)` parenthesized form is unambiguous toolchain identity metadata.
CONTENT_HASH_CE4='\([0-9a-f]{6,12}[[:space:]]+[0-9]{4}-[0-9]{2}-[0-9]{2}\)'

# CE5 / RUST_LITERAL_EXCL — Rust numeric literals that produce hex-shaped tokens.
# Applied to BOTH L10 and L11. Two sub-cases:
#
#   (a) Float literals with Rust type suffixes where all suffix chars are lowercase hex:
#       `f32`, `f64`, `f16`, `f128`. Examples: `1e20f32` (7 chars, L10 scope),
#       `1e200f64` (8 chars, L11 scope), `3e38f128` (8 chars, L11 scope).
#       Token must start with a digit (distinguishing from hash strings starting a-f).
#       These appear in VP changelogs documenting IEEE-754 overflow behavior — the HIGHEST
#       density co-location of legitimate Rust float literals AND potential hash digests.
#
#   (b) Binary integer literals: `0b[01]+` sequences. Binary digits (0 and 1) are
#       both valid hex chars, so `0b10101010` (10 chars) matches `[0-9a-f]{8,}`.
#       The `0b` prefix unambiguously identifies these as binary literals, not content pins.
#       Hex literals (`0x...`) do NOT need exclusion: the `x` char is not in `[0-9a-f]`,
#       so the `0x` prefix breaks the match before the hex digits begin.
#
# Trade-off: CE5 is applied at the LINE level. A line containing BOTH a Rust float literal
# AND a real hash digest would be skipped (false negative). This is an accepted trade-off:
# changelog entries mixing numeric Rust literals with hash citations should be split.
RUST_LITERAL_EXCL='\b[0-9][0-9a-f]*(f32|f64|f16|f128)\b|\b0b[01]+\b'

# L12 dead-brand-token pattern (case-insensitive ERE).
# Matches ferrochain-era brand tokens retired in the D-117 rename sweep.
# FerrochainError lowercases to ferrochainerror — grep -i matches it with this pattern.
DEAD_BRAND_PATTERN='ferrochain|ferroctmp|ferrograph|ferrochainerror'

# L12 historical/clarifier exclusion pattern (case-insensitive ERE).
# Lines where the dead brand token appears adjacent to a rename/historical marker
# are exempt — they document the rename, not a live usage of the old brand.
# Covers: "formerly 'ferrograph'", "renamed from ferrochain", "ferrochain-era",
# "ferrochain→pregolya" (Unicode right-arrow transition), "not FerrochainError".
# The → character is Unicode U+2192 (RIGHT ARROW) — used throughout the corpus.
DEAD_BRAND_HIST_EXCL='formerly|renamed[[:space:]]+from|ferrochain-era|ferrograph-era|ferroctmp-era|ferrochain[[:space:]]*→|ferroctmp[[:space:]]*→|ferrograph[[:space:]]*→|→[[:space:]]*pregolya|not[[:space:]]+ferrochainerror'

# ── Counters ─────────────────────────────────────────────────────────────────

PASS=0
WARN=0
FAIL=0
UNVERIFIED=0

emit() {
  local level="$1"
  local msg="$2"
  echo "[$level] $msg"
  case "$level" in
    PASS)       PASS=$((PASS + 1)) ;;
    WARN)       WARN=$((WARN + 1)) ;;
    FAIL)       FAIL=$((FAIL + 1)) ;;
    UNVERIFIED) UNVERIFIED=$((UNVERIFIED + 1)) ;;
  esac
}

# ── Self-probe helpers ────────────────────────────────────────────────────────

# probe_must_fail <check_id> <description>
# Call after a check function has been run against a synthetic violation.
# Expects the subshell exit code to be stored in PROBE_EXIT.
probe_must_fail() {
  local check_id="$1"
  local description="$2"
  if [ "${PROBE_EXIT:-0}" -eq 0 ]; then
    echo "[SELF-PROBE FAIL] $check_id self-probe is false-green: '$description' was NOT detected."
    echo "  This is a script bug — the check would silently pass on a real violation."
    exit 2
  fi
}

# probe_must_not_fail <check_id> <description>
# Verifies that a check did NOT flag a line that should be exempt.
# Expects PROBE_EXIT to be 0 (no violation detected).
probe_must_not_fail() {
  local check_id="$1"
  local description="$2"
  if [ "${PROBE_EXIT:-0}" -ne 0 ]; then
    echo "[SELF-PROBE FAIL] $check_id false-positive probe: '$description' FIRED but should be exempt."
    echo "  This is a script bug — the check would incorrectly flag a non-violation line."
    exit 2
  fi
}

# ── Self-probes ───────────────────────────────────────────────────────────────
# Each self-probe creates a synthetic violating artifact and verifies the
# corresponding check catches it. A passing self-probe = the check is not false-green.

run_self_probes() {
  PROBE_TMP="$(mktemp -d)"
  trap 'rm -rf "$PROBE_TMP"' EXIT

  # ── L1 self-probe: version > 1.0 with no changelog ───────────────────────
  # Synthetic violation: frontmatter version: "1.2" but no changelog entry.
  PROBE_L1="$PROBE_TMP/l1-violation.md"
  cat > "$PROBE_L1" <<'EOF'
---
document_type: behavioral-contract
version: "1.2"
status: active
---
# BC-9.99.001 Synthetic Violation

No changelog entry here.
EOF

  PROBE_EXIT=0
  # L1 check: version > 1.0 implies changelog (Form A or Form B)
  BUMPED_VER="$(grep -m1 '^version:' "$PROBE_L1" | grep -oE '"[0-9]+\.[0-9]+"' | tr -d '"' || echo "")"
  if [ -n "$BUMPED_VER" ]; then
    MAJOR="$(echo "$BUMPED_VER" | cut -d. -f1)"
    MINOR="$(echo "$BUMPED_VER" | cut -d. -f2)"
    if [ "$MAJOR" -gt 1 ] || { [ "$MAJOR" -eq 1 ] && [ "$MINOR" -gt 0 ]; }; then
      FORM_A="$(grep -c '^changelog:' "$PROBE_L1" || true)"
      FORM_B="$(grep -c '^## Changelog' "$PROBE_L1" || true)"
      if [ "$FORM_A" -eq 0 ] && [ "$FORM_B" -eq 0 ]; then
        PROBE_EXIT=1
      fi
    fi
  fi
  probe_must_fail "L1" "version 1.2 with no changelog"

  # ── L7 self-probe: changelog entries in wrong order ───────────────────────
  # Synthetic violation: older version appears before newer version.
  PROBE_L7="$PROBE_TMP/l7-violation.md"
  cat > "$PROBE_L7" <<'EOF'
---
document_type: behavioral-contract
version: "1.2"
---
# BC-9.99.002 Synthetic Violation

## Changelog

| Version | Change |
|---------|--------|
| 1.0     | Initial |
| 1.2     | Second (this is newer but listed after older — wrong) |
EOF

  PROBE_EXIT=0
  # L7 check: extract version numbers from changelog table rows (N.N pattern),
  # verify they are in non-increasing order (newest first).
  # Uses flag-based awk (not range pattern) to avoid early termination when the
  # end-pattern /^## [A-Z]/ also matches the ## Changelog start line.
  CHANGELOG_VERSIONS="$(awk '/## Changelog/{flag=1;next} /^## /{flag=0} flag' "$PROBE_L7" \
    | grep -oE '^\| [0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+' || echo "")"
  if [ -n "$CHANGELOG_VERSIONS" ]; then
    PREV_VER=""
    while IFS= read -r VER; do
      if [ -n "$PREV_VER" ]; then
        PREV_MAJ="$(echo "$PREV_VER" | cut -d. -f1)"
        PREV_MIN="$(echo "$PREV_VER" | cut -d. -f2)"
        CUR_MAJ="$(echo "$VER" | cut -d. -f1)"
        CUR_MIN="$(echo "$VER" | cut -d. -f2)"
        # If current is GREATER than prev, order is wrong (should be newest-first)
        if [ "$CUR_MAJ" -gt "$PREV_MAJ" ] || \
           { [ "$CUR_MAJ" -eq "$PREV_MAJ" ] && [ "$CUR_MIN" -gt "$PREV_MIN" ]; }; then
          PROBE_EXIT=1
          break
        fi
      fi
      PREV_VER="$VER"
    done <<< "$CHANGELOG_VERSIONS"
  fi
  probe_must_fail "L7" "changelog with version 1.0 before 1.2 (wrong order)"

  # ── L9 self-probe (file:NNN): line-cite pattern in a synthetic diff addition
  # Synthetic violation: a new line containing a file:NNN citation.
  PROBE_L9_DIFF="+The function is defined at src/lib.rs:42 in the build path."
  PROBE_EXIT=0
  if echo "$PROBE_L9_DIFF" | grep -qE "^\+[^+].*${LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_fail "L9-file-cite" "addition line containing src/lib.rs:42"

  # ── L9c self-probe: bare-line-reference pattern (P2A-050) ─────────────────
  # Synthetic violation: a new line containing a bare "line ~N" reference.
  # POL-31: must fire on this form so the gate is not false-green.
  # POL-30: hook file excluded from live scan via ':!hooks/**' diff pathspec.
  PROBE_L9C_DIFF="+The constraint was addressed; see §Changelog line ~44 for the original note."
  PROBE_EXIT=0
  if echo "$PROBE_L9C_DIFF" | grep -qE "^\+[^+].*${BARE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_fail "L9c-bare-line" "addition line containing 'line ~44'"

  # ── L9d self-probe: ID-anchored line pin pattern (P2A-050) ────────────────
  # Synthetic violation: a new line containing a doc-ID:NNN line-number pin.
  # POL-31: must fire on this form so the gate is not false-green.
  PROBE_L9D_DIFF="+The invariant is defined in BC-2.10.001:141 of the contract."
  PROBE_EXIT=0
  if echo "$PROBE_L9D_DIFF" | grep -qE "^\+[^+].*${ID_LINE_PIN_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_fail "L9d-id-pin" "addition line containing 'BC-2.10.001:141'"

  # ── L9e self-probe: prose file.ext line NNN pattern (DC-29/F-PDC29-03) ───────
  # Synthetic violation: a new line containing `filename.ext line NNN` prose form.
  # This is the shape DC-29 found: "api-surface.md line 258" escaped the old gate.
  PROBE_L9E_DIFF="+The response shape is defined in api-surface.md line 258 of the endpoint spec."
  PROBE_EXIT=0
  if echo "$PROBE_L9E_DIFF" | grep -qE "^\+[^+].*${PROSE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_fail "L9e-prose-cite" "addition line containing 'api-surface.md line 258'"

  # ── L9e plural self-probe: prose `file.ext lines NNN` form ───────────────────
  # Covers the plural form `lines NNN` which is equally volatile.
  PROBE_L9E_PLURAL_DIFF="+See error-taxonomy.md lines 42 through 47 for the error-code table."
  PROBE_EXIT=0
  if echo "$PROBE_L9E_PLURAL_DIFF" | grep -qE "^\+[^+].*${PROSE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_fail "L9e-prose-cite-plural" "addition line containing 'error-taxonomy.md lines 42'"

  # ── L9e false-positive probes: compound words ending in 'line' ───────────────
  # Verify PROSE_LINE_CITE_PATTERN does NOT fire on compound words that end in
  # "line" (e.g. "pipeline", "baseline", "guideline") when followed by a number.
  # None of these have a `.ext` token before "line", so they must NOT match.
  PROBE_L9E_FP1="+The pipeline 5 builds ran in parallel without contention."
  PROBE_EXIT=0
  if echo "$PROBE_L9E_FP1" | grep -qE "^\+[^+].*${PROSE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_not_fail "L9e-fp-pipeline" "'pipeline 5' does not false-positive as prose file:line citation"

  PROBE_L9E_FP2="+The baseline 3 measurement was taken before any optimization pass."
  PROBE_EXIT=0
  if echo "$PROBE_L9E_FP2" | grep -qE "^\+[^+].*${PROSE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_not_fail "L9e-fp-baseline" "'baseline 3' does not false-positive as prose file:line citation"

  PROBE_L9E_FP3="+The deadline 7 days from now is firm; no extensions."
  PROBE_EXIT=0
  if echo "$PROBE_L9E_FP3" | grep -qE "^\+[^+].*${PROSE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_not_fail "L9e-fp-deadline" "'deadline 7' does not false-positive as prose file:line citation"

  # ── L9c/L9d clean-pass probe (POL-31 negative case) ──────────────────────
  # Verify neither L9c nor L9d fires on a legitimate non-cite line.
  # Uses "command line tool" (has "line" but not followed by a digit) to verify
  # BARE_LINE_CITE_PATTERN does not over-match, and no doc-ID:NNN present.
  PROBE_L9CD_PASS="+The command line tool accepts a path argument and outputs the result."
  PROBE_EXIT=0
  if echo "$PROBE_L9CD_PASS" | grep -qE "^\+[^+].*${BARE_LINE_CITE_PATTERN}"; then
    PROBE_EXIT=1
  fi
  if [ "${PROBE_EXIT}" -eq 0 ] && echo "$PROBE_L9CD_PASS" | grep -qE "^\+[^+].*${ID_LINE_PIN_PATTERN}"; then
    PROBE_EXIT=1
  fi
  probe_must_not_fail "L9c-L9d-clean-pass" "legitimate non-cite addition line passes without false-positive"

  # ── L9b four-outcome proof (FIX-BURST-278 bug fixes) ──────────────────────
  # All four fixtures are frontmatter changelog entry format (YAML list items),
  # mirroring the real violation shape from api-surface.md/interface-definitions.md.
  #   Outcome A: frontmatter changelog entry, pin, date on/after 2026-07-24 FIRES
  #   Outcome B: frontmatter changelog entry, pin, date before 2026-07-24 DOES NOT FIRE
  #   Outcome C: same post-boundary pin on a - deletion line DOES NOT FIRE
  #   Outcome D: regression fixture — exact format of the live violation that was
  #              present in api-surface.md/interface-definitions.md (ADR-005 v1.9,
  #              date 2026-07-28); MUST FIRE (if it does not, the rule is broken)

  # Inline helper: apply single-line L9b logic (addition-only + date boundary).
  # No spec_region_utils call — changelog/frontmatter regions are in scope for L9b.
  _L9B_CHECK() {
    local diffline="$1" content match first_date
    case "$diffline" in
      "+++"*) echo 0; return ;;
      "+"*)   : ;;
      *)      echo 0; return ;;
    esac
    content="${diffline#"+"}"
    match="$(echo "$content" | grep -oE \
      '(ADR-[0-9]+|BC-2\.[0-9]{2}\.[0-9]{3}|VP-[0-9]{3}|CAP-[0-9]{3}|[A-Z][A-Z0-9]*-INDEX)[[:space:]]+v[0-9]+\.[0-9]+|[a-z0-9][a-z0-9_-]*\.md[[:space:]]+\(?v[0-9]+\.[0-9]+' \
      || true)"
    [ -z "$match" ] && echo 0 && return
    first_date="$(echo "$content" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1 || echo "")"
    if [[ -n "$first_date" && "$first_date" < "2026-07-24" ]]; then echo 0; return; fi
    echo 1
  }

  # Outcome A: frontmatter changelog entry, ADR pin, date 2026-07-28 FIRES
  PROBE_EXIT=$(_L9B_CHECK "+  - \"1.5 (burst-278/2026-07-28): Rationale in ADR-005 v1.9.\"")
  probe_must_fail "L9b-outcome-A" "frontmatter changelog entry with 2026-07-28 date and ADR pin fires"

  # Outcome B: frontmatter changelog entry, .md pin, date 2026-07-22 (pre-D-50) DOES NOT FIRE
  PROBE_EXIT=$(_L9B_CHECK "+  - \"1.3 (burst-240/2026-07-22): See error-taxonomy.md v1.34 same burst.\"")
  probe_must_not_fail "L9b-outcome-B" "frontmatter changelog entry with 2026-07-22 date (pre-D-50) is exempt"

  # Outcome C: same post-boundary pin on a - deletion line DOES NOT FIRE
  PROBE_EXIT=$(_L9B_CHECK "-  - \"1.9 (burst-278/2026-07-28): Rationale in ADR-005 v1.9.\"")
  probe_must_not_fail "L9b-outcome-C" "- deletion line with post-boundary date is not flagged"

  # Outcome D: regression — exact format of live violation in api-surface.md /
  # interface-definitions.md (ADR-005 v1.9, date 2026-07-28) MUST FIRE
  PROBE_EXIT=$(_L9B_CHECK "+  - \"2.62 (FIX-BURST-277-WAVE-B-errata/2026-07-28): Add §DynTool; ADR-005 v1.9 carries corrected Wave C list.\"")
  probe_must_fail "L9b-outcome-D" "regression: real-format frontmatter changelog entry with ADR-005 v1.9 dated 2026-07-28 fires"

  # Outcome E: INDEX-name version pin (burst-288 gap) — newly-authored INDEX entry MUST FIRE
  # INDEX-style pins (VP-INDEX v1.2, BC-INDEX v1.5, etc.) were missed by VP_RE1 before the
  # burst-288 fix; this probe proves the gap is now closed.
  PROBE_EXIT=$(_L9B_CHECK "+  - \"1.3 (burst-288/2026-08-15): See VP-INDEX v1.2 for traceability table.\"")
  probe_must_fail "L9b-outcome-E" "INDEX-name version pin 'VP-INDEX v1.2' with 2026-08-15 date fires"

  unset -f _L9B_CHECK

  # ── L10 self-probe: hash-digest pattern in a synthetic diff addition ───────
  # Synthetic violation: a changelog entry containing a 7-hex SHA transition.
  # The probe uses two forms that should both be caught:
  #   (a) The right-arrow form (the dominant violation shape in the corpus)
  #   (b) A bare 7-hex standalone word in changelog prose
  PROBE_L10_DIFF='  - "1.9 (burst-123/2026-07-01): Input-hash refreshed: 5fc3abe → baaf36d (ADR-017 bumped)"'
  PROBE_EXIT=0
  # Simulate: echo "+$PROBE_L10_DIFF" (prefixed with + as it would appear in git diff)
  PROBE_L10_LINE="+${PROBE_L10_DIFF}"
  # Check: not a hash-field exclusion line, and contains a 7-hex pattern
  if ! echo "$PROBE_L10_LINE" | grep -qE "${HASH_FIELD_EXCLUSION}"; then
    if echo "$PROBE_L10_LINE" | grep -qE "${HASH_DIGEST_PATTERN}"; then
      PROBE_EXIT=1
    fi
  fi
  probe_must_fail "L10" "changelog addition containing 7-hex SHA transition 5fc3abe → baaf36d"

  # ── L11 self-probe: 8+ char content-hash digest in a synthetic diff addition ──
  # Synthetic violation: a changelog entry citing a 40-char SHA-1 digest literal as
  # evidence of input-file identity. This line does NOT match CE1-CE4 exclusions:
  #   - Not a YAML hash-field assignment (CE1).
  #   - Does not contain "Frozen HEAD" or "frozen HEAD" (CE2).
  #   - Does not contain "[live-state]" (CE3).
  #   - Does not match Rust toolchain format `(HEX YYYY-MM-DD)` (CE4).
  PROBE_L11_DIFF='  - "1.5 (burst-999/2026-07-27): input-hash refreshed: 4bcef4e5790e7f8352c28d6ae3b3697572939ef3 (ADR-014 edited)"'
  PROBE_EXIT=0
  PROBE_L11_LINE="+${PROBE_L11_DIFF}"
  # Apply CE1 first (same two-condition structure as L10 self-probe)
  if ! echo "$PROBE_L11_LINE" | grep -qE "${CONTENT_HASH_CE1}"; then
    # Apply CE2
    if ! echo "$PROBE_L11_LINE" | grep -qE "${CONTENT_HASH_CE2}"; then
      # Apply CE3 (literal bracket match)
      if ! echo "$PROBE_L11_LINE" | grep -qF "[live-state]"; then
        # Apply CE4
        if ! echo "$PROBE_L11_LINE" | grep -qE "${CONTENT_HASH_CE4}"; then
          # Check for 8+ char hex pattern
          if echo "$PROBE_L11_LINE" | grep -qE "${CONTENT_HASH_PATTERN}"; then
            PROBE_EXIT=1
          fi
        fi
      fi
    fi
  fi
  probe_must_fail "L11" "addition line containing 40-char SHA-1 content-hash digest in changelog prose"

  # ── L12 self-probes: dead-brand-token recurrence guard ───────────────────────
  # Tests three outcomes:
  #   (a) Synthetic NEW spec-body line containing .ferroctmp_ → CAUGHT (positive detection)
  #   (b) Lines with historical-clarifier qualifiers → NOT caught (DE1 exemption)
  #   (c) planning/ line with ferrochain → NOT caught (DE2 scope exemption)
  #
  # The inline helper mirrors the check_l12 logic: path-scope check, then DE1
  # historical exclusion, then dead-brand detection. Uses config vars
  # DEAD_BRAND_HIST_EXCL and DEAD_BRAND_PATTERN (defined in Config section).

  _L12_CHECK() {
    local filepath="$1" diffline="$2"
    # DE2: scope check — specs/ paths only; planning/ and all other paths are out-of-scope
    case "$filepath" in
      specs/*) : ;;
      *) echo 0; return ;;
    esac
    # Only + additions (not +++ diff headers, not context or deletion lines)
    case "$diffline" in
      "+++"*) echo 0; return ;;
      "+"*)   : ;;
      *)      echo 0; return ;;
    esac
    # DE1: historical/clarifier exclusion (case-insensitive)
    if echo "$diffline" | grep -qiE "${DEAD_BRAND_HIST_EXCL}"; then
      echo 0; return
    fi
    # Dead brand detection (case-insensitive)
    if echo "$diffline" | grep -qiE "${DEAD_BRAND_PATTERN}"; then
      echo 1
    else
      echo 0
    fi
  }

  # Probe (a): synthetic NEW spec-body line with .ferroctmp_ is CAUGHT
  PROBE_EXIT=$(_L12_CHECK "specs/prd.md" "+The module registers .ferroctmp_ handles internally.")
  probe_must_fail "L12-probe-a" "specs/ addition line containing .ferroctmp_ is caught as dead-brand violation"

  # Probe (b1): "formerly 'ferrograph'" passes (historical-clarifier allowance)
  PROBE_EXIT=$(_L12_CHECK "specs/domain-spec/entities.md" "+See formerly 'ferrograph' — renamed to pregolya-graph (D-117).")
  probe_must_not_fail "L12-probe-b1" "line with 'formerly ferrograph' passes (historical-clarifier allowance)"

  # Probe (b2): "not FerrochainError" passes (historical-clarifier allowance)
  PROBE_EXIT=$(_L12_CHECK "specs/behavioral-contracts/bc-001.md" "+Note: not FerrochainError — use PregolyaError (D-117 rename).")
  probe_must_not_fail "L12-probe-b2" "line with 'not FerrochainError' passes (historical-clarifier allowance)"

  # Probe (c): planning/ line with ferrochain passes (out of scope — planning/ is exempt from L12)
  PROBE_EXIT=$(_L12_CHECK "planning/rename-sweep-manifest.md" "+ferrochain was the original project name before the D-117 rename.")
  probe_must_not_fail "L12-probe-c" "planning/ line with ferrochain passes (out of scope)"

  unset -f _L12_CHECK

  rm -rf "$PROBE_TMP"
  trap - EXIT
}

# ── Check L1 — Version/Changelog Parity ──────────────────────────────────────
# For every records-tier markdown file: if frontmatter version > "1.0", at least
# one changelog entry must be present (Form A: frontmatter `changelog:` key; OR
# Form B: `## Changelog` body section). Codifies lesson L-010 / Gate #28.

check_l1() {
  local found_violation=0

  for pattern in "${RECORDS_PATTERNS[@]}"; do
    # shellcheck disable=SC2086
    while IFS= read -r -d '' f; do
      # Extract frontmatter version field (first occurrence)
      VER="$(grep -m1 '^version:' "$f" | grep -oE '"[0-9]+\.[0-9]+"' | tr -d '"' || echo "")"
      [ -z "$VER" ] && continue

      MAJOR="$(echo "$VER" | cut -d. -f1)"
      MINOR="$(echo "$VER" | cut -d. -f2)"

      # Only check files with version > 1.0
      if [ "$MAJOR" -gt 1 ] || { [ "$MAJOR" -eq 1 ] && [ "$MINOR" -gt 0 ]; }; then
        FORM_A="$(grep -c '^changelog:' "$f" || true)"
        FORM_B="$(grep -c '^## Changelog' "$f" || true)"
        if [ "$FORM_A" -eq 0 ] && [ "$FORM_B" -eq 0 ]; then
          rel="${f#$FACTORY_DIR/}"
          emit FAIL "L1: $rel — version $VER but no changelog entry (add frontmatter changelog: or ## Changelog section)"
          found_violation=1
        fi
      fi
    done < <(find "$FACTORY_DIR" -path "$FACTORY_DIR/$pattern" -name "*.md" -print0 2>/dev/null || true)
  done

  if [ "$found_violation" -eq 0 ]; then
    emit PASS "L1: version/changelog parity — all versioned records carry changelog entries"
  fi
}

# ── Check L7 — Changelog Monotonic Order ─────────────────────────────────────
# For every records-tier file with a ## Changelog section: version entries in
# the table must appear in non-increasing (newest-first) order. An entry with a
# version greater than the preceding entry is a violation.

check_l7() {
  local found_violation=0

  for pattern in "${RECORDS_PATTERNS[@]}"; do
    # shellcheck disable=SC2086
    while IFS= read -r -d '' f; do
      # Extract version numbers from ## Changelog table rows (| N.N format).
      # Uses flag-based awk (not range pattern) to avoid early termination when
      # /^## [A-Z]/ also matches the ## Changelog start line itself.
      VERSIONS="$(awk '/## Changelog/{flag=1;next} /^## /{flag=0} flag' "$f" \
        | grep -oE '^\| [0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+' || echo "")"
      [ -z "$VERSIONS" ] && continue

      PREV_VER=""
      VIOLATION=""
      while IFS= read -r VER; do
        if [ -n "$PREV_VER" ]; then
          PREV_MAJ="$(echo "$PREV_VER" | cut -d. -f1)"
          PREV_MIN="$(echo "$PREV_VER" | cut -d. -f2)"
          CUR_MAJ="$(echo "$VER" | cut -d. -f1)"
          CUR_MIN="$(echo "$VER" | cut -d. -f2)"
          if [ "$CUR_MAJ" -gt "$PREV_MAJ" ] || \
             { [ "$CUR_MAJ" -eq "$PREV_MAJ" ] && [ "$CUR_MIN" -gt "$PREV_MIN" ]; }; then
            VIOLATION="version $VER appears after $PREV_VER (newest-first required)"
            break
          fi
        fi
        PREV_VER="$VER"
      done <<< "$VERSIONS"

      if [ -n "$VIOLATION" ]; then
        rel="${f#$FACTORY_DIR/}"
        emit FAIL "L7: $rel — changelog out of order: $VIOLATION"
        found_violation=1
      fi
    done < <(find "$FACTORY_DIR" -path "$FACTORY_DIR/$pattern" -name "*.md" -print0 2>/dev/null || true)
  done

  if [ "$found_violation" -eq 0 ]; then
    emit PASS "L7: changelog monotonic order — all changelog sections are newest-first"
  fi
}

# ── Check L9 — Line-Cite and Version-Pin Ban ─────────────────────────────────
# Newly-authored additions since HEAD must not contain:
#   L9a (extended, P2A-050 2026-08-25 + DC-29/F-PDC29-03 2026-09-08):
#     any of four volatile line-citation forms:
#     (i)   file:NNN — word.ext:digits line-number citations
#     (ii)  bare line references — `line ~N` or `line N` in normative prose
#     (iii) ID-anchored line pins — DOCID:NNN citations (e.g. BC-2.10.001:141)
#     (iv)  prose file:line — `filename.ext line NNN` / `filename.ext lines NNN`
#           (e.g. `api-surface.md line 258`; anchored on extension to avoid
#           false-positives from pipeline, baseline, guideline, etc.)
#   All L9a forms use addition-only git diff HEAD scoping (hooks excluded).
#   Pre-existing committed content is grandfathered by the addition-only scoping.
#   L9b: <doc> vN.N version pins (D-50, ratified 2026-07-24)
#
# The diff excludes .factory/hooks/** — hook scripts are code, not records;
# hook-authored fixture files live in $TMPDIR, never in .factory/hooks/.
#
# L9b uses a Python3 scanner (avoids VERSION_PIN_PATTERN alternation-precedence
# issues in embedded grep ERE — Bug 1 fix, FIX-BURST-278). Changelog entries
# and YAML frontmatter are deliberately IN SCOPE: D-50 targets version pins
# wherever they live, including in changelog entries. The sole grandfathering
# mechanism for L9b is the entry-date boundary — a + line whose embedded
# YYYY-MM-DD date is before 2026-07-24 is exempt; date >= 2026-07-24 or no
# parseable date → flag. This differs from verify-no-version-pins.sh, which
# exempts changelog regions on its full-corpus scan. The two rules deliberately
# disagree.

check_l9() {
  # hooks/** excluded: hook scripts are code, not records.
  DIFF_OUTPUT="$(git -C "$FACTORY_DIR" diff HEAD -- '*.md' ':!hooks/**' 2>/dev/null || true)"

  if [ -z "$DIFF_OUTPUT" ]; then
    emit UNVERIFIED "L9: no diff relative to HEAD — checks are UNVERIFIED on a clean tree (not checked, not passed)"
    return
  fi

  # Sub-check L9a — file:NNN line-cite ban (original form, pre-D-50)
  L9A_VIOLATIONS="$(echo "$DIFF_OUTPUT" \
    | grep -E '^\+[^+]' \
    | grep -oE "${LINE_CITE_PATTERN}" \
    || true)"

  # Sub-check L9c — bare "line ~N" / "line N" reference ban (P2A-050, 2026-08-25)
  # Uses addition-only scoping (same as L9a); pre-existing committed content
  # is grandfathered by git diff HEAD (no date-boundary needed).
  L9C_VIOLATIONS="$(echo "$DIFF_OUTPUT" \
    | grep -E '^\+[^+]' \
    | grep -oE "${BARE_LINE_CITE_PATTERN}" \
    || true)"

  # Sub-check L9d — doc-ID:NNN line-number pin ban (P2A-050, 2026-08-25)
  # Uses addition-only scoping (same as L9a); pre-existing committed content
  # is grandfathered by git diff HEAD (no date-boundary needed).
  L9D_VIOLATIONS="$(echo "$DIFF_OUTPUT" \
    | grep -E '^\+[^+]' \
    | grep -oE "${ID_LINE_PIN_PATTERN}" \
    || true)"

  # Sub-check L9e — prose `filename.ext line NNN` / `filename.ext lines NNN` ban
  # (DC-29/F-PDC29-03, 2026-09-08). Anchored on the file extension token immediately
  # before `lines? NNN` — avoids false-positives from compound words ending in "line"
  # (pipeline, baseline, guideline, etc.). Uses addition-only scoping (same as L9a);
  # pre-existing committed content is grandfathered by git diff HEAD.
  L9E_VIOLATIONS="$(echo "$DIFF_OUTPUT" \
    | grep -E '^\+[^+]' \
    | grep -oE "${PROSE_LINE_CITE_PATTERN}" \
    || true)"

  # Sub-check L9b — version-pin class ban (D-50, ratified 2026-07-24).
  # Python3 scanner: runs git diff internally (avoids pipe+heredoc stdin conflict);
  # avoids VERSION_PIN_PATTERN alternation-precedence issues in embedded grep ERE
  # (Bug 1 — FIX-BURST-278). Changelog and frontmatter regions are deliberately
  # IN SCOPE — D-50 specifically targets changelog entries where version pins live.
  # The sole grandfathering mechanism is the entry-date boundary (D-50 intent):
  # if a + line carries a YYYY-MM-DD date before 2026-07-24, it is exempt.
  L9B_VIOLATIONS="$(python3 - "$FACTORY_DIR" <<'PYEOF'
import sys, re, subprocess

factory_dir  = sys.argv[1]
D50_BOUNDARY = "2026-07-24"

VP_RE1  = re.compile(r'(?:ADR-\d+|BC-2\.\d{2}\.\d{3}|VP-\d{3}|CAP-\d{3}|[A-Z][A-Z0-9]*-INDEX)\s+v\d+\.\d+')
VP_RE2  = re.compile(r'[a-z0-9][a-z0-9_-]*\.md\s+\(?v\d+\.\d+')
DATE_RE = re.compile(r'\b(\d{4}-\d{2}-\d{2})\b')

result = subprocess.run(
    ['git', '-C', factory_dir, 'diff', 'HEAD', '--', '*.md', ':!hooks/**'],
    capture_output=True, text=True, errors='replace'
)

violations = []

for line in result.stdout.splitlines():
    if not line.startswith('+') or line.startswith('+++'):
        continue  # only + addition lines (Bug 1 fix: skip deletions, context, headers)
    content = line[1:]
    if not VP_RE1.search(content) and not VP_RE2.search(content):
        continue
    # Sole grandfathering: entry carries a YYYY-MM-DD date before the D-50 boundary.
    # Changelog and frontmatter regions are in scope — D-50 targets them explicitly.
    dates = DATE_RE.findall(content)
    if dates and dates[0] < D50_BOUNDARY:
        continue  # pre-D-50 entry re-emerging in diff; grandfathered by date
    violations.append(content[:120])

for v in violations:
    print(v)
PYEOF
)"

  if [ -n "$L9A_VIOLATIONS" ] || [ -n "$L9B_VIOLATIONS" ] || [ -n "$L9C_VIOLATIONS" ] || [ -n "$L9D_VIOLATIONS" ] || [ -n "$L9E_VIOLATIONS" ]; then
    if [ -n "$L9A_VIOLATIONS" ]; then
      emit FAIL "L9a: line-cite ban — newly-added text contains file:NNN citations (retire with symbol/anchor cites):"
      while IFS= read -r cite; do
        echo "       $cite"
      done <<< "$L9A_VIOLATIONS"
      echo ""
      echo "  Affected lines (L9a — file:NNN violations):"
      echo "$DIFF_OUTPUT" | grep -n -E "^\+[^+].*${LINE_CITE_PATTERN}" \
        | sed 's/^/       /' || true
    fi
    if [ -n "$L9C_VIOLATIONS" ]; then
      emit FAIL "L9a (P2A-050 extended): bare-line-ref ban — newly-added text contains 'line ~N' or 'line N' line-number references (retire with symbol/anchor cites):"
      while IFS= read -r cite; do
        echo "       $cite"
      done <<< "$L9C_VIOLATIONS"
      echo ""
      echo "  Affected lines (L9c — bare line reference violations):"
      echo "$DIFF_OUTPUT" | grep -n -E "^\+[^+].*${BARE_LINE_CITE_PATTERN}" \
        | sed 's/^/       /' || true
      echo "  P2A-050 grounding: TD-VSDD-091 / POL-12 — bare line-number refs decay on next diff."
      echo "  Replace 'line ~44' with the symbol/section anchor (e.g. '§Changelog entry for burst-NNN')."
    fi
    if [ -n "$L9D_VIOLATIONS" ]; then
      emit FAIL "L9a (P2A-050 extended): ID-line-pin ban — newly-added text contains DOCID:NNN line-number pins (retire with symbol/anchor cites):"
      while IFS= read -r cite; do
        echo "       $cite"
      done <<< "$L9D_VIOLATIONS"
      echo ""
      echo "  Affected lines (L9d — ID-anchored line pin violations):"
      echo "$DIFF_OUTPUT" | grep -n -E "^\+[^+].*${ID_LINE_PIN_PATTERN}" \
        | sed 's/^/       /' || true
      echo "  P2A-050 grounding: TD-VSDD-091 / POL-12 — DOCID:NNN pins decay on next diff."
      echo "  Replace 'BC-2.10.001:141' with the behavioral anchor (e.g. 'BC-2.10.001 §AC-3')."
    fi
    if [ -n "$L9E_VIOLATIONS" ]; then
      emit FAIL "L9a (DC-29/F-PDC29-03 extended): prose-file-line-pin ban — newly-added text contains 'filename.ext line NNN' or 'filename.ext lines NNN' prose citations (retire with symbol/anchor cites):"
      while IFS= read -r cite; do
        echo "       $cite"
      done <<< "$L9E_VIOLATIONS"
      echo ""
      echo "  Affected lines (L9e — prose file:line violations):"
      echo "$DIFF_OUTPUT" | grep -n -E "^\+[^+].*${PROSE_LINE_CITE_PATTERN}" \
        | sed 's/^/       /' || true
      echo "  DC-29/F-PDC29-03 grounding: TD-VSDD-091 / POL-12 — 'filename.ext line NNN' decays on next diff."
      echo "  Replace 'api-surface.md line 258' with the section anchor (e.g. 'api-surface.md §Section-Name')."
    fi
    if [ -n "$L9B_VIOLATIONS" ]; then
      L9B_COUNT=0
      L9B_REPORT=""
      while IFS= read -r pin; do
        [ -z "$pin" ] && continue
        L9B_COUNT=$((L9B_COUNT + 1))
        L9B_REPORT="${L9B_REPORT}
       ${pin}"
      done <<< "$L9B_VIOLATIONS"
      emit FAIL "L9b (D-50): version-pin ban — ${L9B_COUNT} newly-added line(s) contain <doc> vN.N version pins in normative body text (retire with symbol/section anchor cites):"
      echo "${L9B_REPORT}"
      echo "  D-50 grounding: TD-VSDD-091 extended to version-pin class, ratified 2026-07-24."
      echo "  Replace 'ADR-014 v1.2' with 'ADR-014 §Decision N' or equivalent section anchor."
    fi
  else
    emit PASS "L9 (D-50 + P2A-050 + DC-29 extended): line-cite and version-pin ban — no file:NNN, bare line~N, DOCID:NNN, file.ext line NNN, or <doc> vN.N pins in newly-authored additions"
  fi
}

# ── Check L10 — Hash-Digest Ban (ADVISORY) ───────────────────────────────────
# Newly-authored lines (additions since HEAD in .factory/) must not contain
# standalone 7-hex-literal hash values in changelog prose. These decay on the
# next refresh because they reference mutable intermediate SHA state.
# ADVISORY: emits WARN (not FAIL); exits 0 regardless of WARN count.
# Existing text in HEAD is grandfathered (same scoping as L9).
# Promotion to blocking: after Wave B closes P1D-173-L10-class findings.
#
# Exclusion: lines that are YAML hash-field assignments (input-hash:,
# proof_file_hash:, etc.) are exempt — those are structured fields, not prose.

check_l10() {
  DIFF_OUTPUT="$(git -C "$FACTORY_DIR" diff HEAD -- '*.md' 2>/dev/null || true)"

  if [ -z "$DIFF_OUTPUT" ]; then
    emit UNVERIFIED "L10 [ADVISORY]: no diff relative to HEAD — checks are UNVERIFIED on a clean tree (not checked, not passed)"
    return
  fi

  L10_COUNT=0
  L10_LINES=""

  while IFS= read -r diffline; do
    # Only check + additions (not +++ diff header, not -- removal)
    case "$diffline" in
      "+++"*) continue ;;
      "+"*)   : ;;
      *)      continue ;;
    esac

    # Exclude YAML hash-field assignment lines (structured fields, not prose)
    if echo "$diffline" | grep -qE "${HASH_FIELD_EXCLUSION}"; then
      continue
    fi

    # CE5: exclude lines containing Rust numeric literal type-suffix tokens (float literals
    # like `1e20f32`, `1e200f64` and binary literals like `0b10101010` produce hex-shaped
    # tokens that are not content-hash digests). Same exclusion applied to L10 and L11.
    if echo "$diffline" | grep -qE "${RUST_LITERAL_EXCL}"; then
      continue
    fi

    # Check for standalone 7-hex string
    if echo "$diffline" | grep -qE "${HASH_DIGEST_PATTERN}"; then
      L10_COUNT=$((L10_COUNT + 1))
      # Capture a short representation (first 120 chars) for the report
      L10_LINES="${L10_LINES}
       $(echo "$diffline" | cut -c1-120)"
    fi
  done <<< "$DIFF_OUTPUT"

  if [ "$L10_COUNT" -gt 0 ]; then
    emit WARN "L10 [ADVISORY]: hash-digest ban — $L10_COUNT newly-added line(s) contain standalone 7-hex SHA literals in changelog prose (ADVISORY: non-blocking in Wave A; promote to blocking after Wave B)"
    echo "  Replace 7-hex literals with artifact+section anchor cites, e.g. 'input-hash refreshed (ADR-014 §Decision 2 edited)'"
    echo "  Affected lines:${L10_LINES}"
  else
    emit PASS "L10 [ADVISORY]: hash-digest ban — no 7-hex SHA literals in newly-authored changelog prose"
  fi
}

# ── Check L11 — Content-Hash Digest Ban ──────────────────────────────────────
# Newly-authored lines (additions since HEAD in .factory/) must not contain
# standalone 8+ character lowercase hex digest literals in record/changelog prose.
# These are volatile content-pin identifiers in the TD-VSDD-091 family: they go
# stale the moment the referenced file changes, with nothing left to detect the
# stale reference. Closes F-P173-505 (FIX-BURST-276 Wave B).
# Existing text in HEAD is grandfathered (same scoping as L9/L10).
#
# Exclusions CE1-CE4 (see Config section above for full rationale):
#   CE1 — YAML frontmatter hash-field assignments
#   CE2 — Frozen-HEAD citation lines (validated by verify-sha-currency.sh)
#   CE3 — [live-state] sentinel lines (validated by verify-sha-currency.sh)
#   CE4 — Rust toolchain build-hash format `(HEX YYYY-MM-DD)`
#
# Known scope boundary: uppercase hex is out of scope (see Config section).

check_l11() {
  DIFF_OUTPUT="$(git -C "$FACTORY_DIR" diff HEAD -- '*.md' 2>/dev/null || true)"

  if [ -z "$DIFF_OUTPUT" ]; then
    emit UNVERIFIED "L11: no diff relative to HEAD — checks are UNVERIFIED on a clean tree (not checked, not passed)"
    return
  fi

  L11_COUNT=0
  L11_LINES=""

  while IFS= read -r diffline; do
    # Only check + additions (not +++ diff headers, not -- removals)
    case "$diffline" in
      "+++"*) continue ;;
      "+"*)   : ;;
      *)      continue ;;
    esac

    # CE1: exclude YAML frontmatter hash-field assignments
    if echo "$diffline" | grep -qE "${CONTENT_HASH_CE1}"; then
      continue
    fi

    # CE2: exclude frozen-HEAD citation lines (sanctioned by verify-sha-currency.sh)
    if echo "$diffline" | grep -qE "${CONTENT_HASH_CE2}"; then
      continue
    fi

    # CE3: exclude [live-state] sentinel lines (literal bracket-string match)
    if echo "$diffline" | grep -qF "[live-state]"; then
      continue
    fi

    # CE4: exclude Rust toolchain build-hash format `(HEX YYYY-MM-DD)`
    if echo "$diffline" | grep -qE "${CONTENT_HASH_CE4}"; then
      continue
    fi

    # CE5: exclude lines containing Rust numeric literal type-suffix tokens (same
    # exclusion as applied to L10; see RUST_LITERAL_EXCL in Config section for rationale)
    if echo "$diffline" | grep -qE "${RUST_LITERAL_EXCL}"; then
      continue
    fi

    # Check for standalone 8+ char lowercase hex sequence
    if echo "$diffline" | grep -qE "${CONTENT_HASH_PATTERN}"; then
      L11_COUNT=$((L11_COUNT + 1))
      # Capture a short representation (first 120 chars) for the report
      L11_LINES="${L11_LINES}
       $(echo "$diffline" | cut -c1-120)"
    fi
  done <<< "$DIFF_OUTPUT"

  if [ "$L11_COUNT" -gt 0 ]; then
    emit FAIL "L11: content-hash digest ban — $L11_COUNT newly-added line(s) contain standalone 8+ char hex digest literals in record/changelog prose"
    echo "  Replace hex digest literals with artifact+section anchor cites, e.g. 'input-hash refreshed (ADR-014 §Decision 2 edited)'"
    echo "  Affected lines:${L11_LINES}"
  else
    emit PASS "L11: content-hash digest ban — no 8+ char hex digest literals in newly-authored record/changelog prose"
  fi
}

# ── Check L12 — Dead-Brand-Token Recurrence Guard ────────────────────────────
# Newly-authored additions in specs/**/*.md must not contain ferrochain-era brand
# tokens: ferrochain, ferroctmp, ferrograph, FerrochainError (case-insensitive).
# Scoped to specs/ tree ONLY via git diff HEAD pathspec — planning/ is out of scope
# (legitimate rename documentation lives there). Existing content in HEAD is
# grandfathered via git diff HEAD scoping (covers ADR-010 lines 19/179).
#
# Exclusions:
#   DE1 — Historical/clarifier qualifiers (DEAD_BRAND_HIST_EXCL):
#          "formerly '...token'", "renamed from token", "token-era",
#          "token→pregolya" (transition arrow), "not FerrochainError".
#   DE2 — Scope: planning/ files excluded via diff pathspec ('specs/' only).
#
# Self-probes: see run_self_probes() L12 section.

check_l12() {
  DIFF_OUTPUT="$(git -C "$FACTORY_DIR" diff HEAD -- 'specs/' 2>/dev/null || true)"

  if [ -z "$DIFF_OUTPUT" ]; then
    emit UNVERIFIED "L12: no diff relative to HEAD in specs/ — dead-brand-token check is UNVERIFIED on a clean tree (not checked, not passed)"
    return
  fi

  L12_COUNT=0
  L12_LINES=""
  L12_CURRENT_MD=false  # track whether the current file in the diff is a .md file

  while IFS= read -r diffline; do
    # Track current file from diff header (+++ b/path/to/file.ext)
    case "$diffline" in
      "+++ b/"*)
        case "$diffline" in
          *".md") L12_CURRENT_MD=true ;;
          *)      L12_CURRENT_MD=false ;;
        esac
        continue
        ;;
    esac
    # Skip non-.md files
    [ "$L12_CURRENT_MD" = false ] && continue
    # Only check + additions (not +++ diff headers, not context or deletion lines)
    case "$diffline" in
      "+++"*) continue ;;
      "+"*)   : ;;
      *)      continue ;;
    esac
    # DE1: historical/clarifier qualifier exemption (case-insensitive)
    if echo "$diffline" | grep -qiE "${DEAD_BRAND_HIST_EXCL}"; then
      continue
    fi
    # Dead brand token detection (case-insensitive)
    if echo "$diffline" | grep -qiE "${DEAD_BRAND_PATTERN}"; then
      L12_COUNT=$((L12_COUNT + 1))
      L12_LINES="${L12_LINES}
       $(echo "$diffline" | cut -c1-120)"
    fi
  done <<< "$DIFF_OUTPUT"

  if [ "$L12_COUNT" -gt 0 ]; then
    emit FAIL "L12: dead-brand-token ban — $L12_COUNT newly-added line(s) in specs/ contain ferrochain-era brand tokens"
    echo "  Tokens: ferrochain / ferroctmp / ferrograph / FerrochainError (case-insensitive)"
    echo "  These brand tokens were retired in the ferrochain→pregolya rename (D-117)."
    echo "  Use canonical replacements: ferrochain→pregolya, ferrograph→pregolya-graph,"
    echo "  ferroctmp→pregolya-checkpoint, FerrochainError→PregolyaError."
    echo "  Exempt: historical-clarifier context (formerly, renamed from, *-era, →pregolya, not FerrochainError)."
    echo "  Exempt: planning/ files (out of scope — rename documentation lives there)."
    echo "  Affected lines:${L12_LINES}"
  else
    emit PASS "L12: dead-brand-token ban — no ferrochain-era tokens in newly-authored specs/ additions"
  fi
}

# ── Main ──────────────────────────────────────────────────────────────────────

echo "records-lint: pregolya factory records discipline"
echo "  FACTORY_DIR: $FACTORY_DIR"
echo ""

if [ "$SKIP_SELF_PROBE" = false ]; then
  echo "[SELF-PROBE] Verifying each check catches its synthetic violation..."
  run_self_probes
  echo "[SELF-PROBE] All self-probes passed — checks are not false-green."
  echo ""
fi

echo "--- L1: Version/Changelog Parity ---"
check_l1

echo ""
echo "--- L7: Changelog Monotonic Order ---"
check_l7

echo ""
echo "--- L9: Line-Cite Ban (newly-authored additions) ---"
check_l9

echo ""
echo "--- L10: Hash-Digest Ban (ADVISORY — newly-authored changelog prose) ---"
check_l10

echo ""
echo "--- L11: Content-Hash Digest Ban (newly-authored record/changelog/spec prose) ---"
check_l11

echo ""
echo "--- L12: Dead-Brand-Token Recurrence Guard (newly-authored specs/ additions) ---"
check_l12

echo ""
echo "records-lint: PASS=$PASS WARN=$WARN FAIL=$FAIL UNVERIFIED=$UNVERIFIED"

if [ "$FAIL" -gt 0 ]; then
  echo "RESULT: FAIL — resolve violations before committing"
  echo ""
  echo "Routing guide:"
  echo "  L1 violations → state-manager (frontmatter) or spec owner (changelog body)"
  echo "  L7 violations → spec owner (reorder changelog entries, newest first)"
  echo "  L9a violations → finding author (replace file:NNN / bare line~N / DOCID:NNN / file.ext line NNN with symbol/anchor cite) [P2A-050 + DC-29]"
  echo "  L9b violations → finding author (replace doc vN.N with doc §Section-Anchor) [D-50]"
  echo "  L10 violations → finding author (replace 7-hex SHA with artifact+section anchor cite) [ADVISORY]"
  echo "  L11 violations → finding author (replace 8+ char hex digest with artifact+section anchor cite)"
  echo "  L12 violations → finding author (replace dead brand token: ferrochain→pregolya,"
  echo "                   ferrograph→pregolya-graph, ferroctmp→pregolya-checkpoint, FerrochainError→PregolyaError)"
  exit 1
else
  echo "RESULT: PASS"
  exit 0
fi
