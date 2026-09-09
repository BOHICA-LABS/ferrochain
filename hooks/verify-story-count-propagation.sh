#!/usr/bin/env bash
# verify-story-count-propagation.sh — STORY-INDEX aggregate-summary count-parity gate
#
# PURPOSE
# ───────
# Verifies that the STORY-INDEX aggregate summary representations agree with
# the ground-truth counts derived from the file itself and from STATE.md.
#
# GROUND TRUTH SOURCES
# ────────────────────
# Source A (story counts):  Count of actual `| S-*` data rows in the
#   ## Story Inventory section, segmented by wave prefix (S-1.* = Wave 1,
#   S-2.* = Wave 2, S-6.* = Wave 6, S-MAINT-* = Maintenance).
#
# Source B (BC count — from within STORY-INDEX):  Sum of per-SS BC-count
#   header values in the ## BC to Story Coverage Map section.
#   Header format: "### SS-NN Description (NNN BCs)" or
#                  "### SS-NN Description (NNN BCs — P2)" etc.
#   Sum across all SS headers must equal Source C.
#
# Source C (BC count — from STATE.md):  `total_bcs:` frontmatter field in
#   .factory/STATE.md.  Treated as the authoritative BC count; must agree
#   with Source B.
#
# VALIDATION TARGETS
# ──────────────────
# Target 1 — §Census table body:
#   Every countable row must agree with the ground-truth sources.
#   Checked rows:
#     | Total Story Files    | <n>       |  → Source A total
#     | Product Stories      | <n>       |  → Source A (total − maint)
#     | Wave 1 stories       | <n>       |  → Source A wave1
#     | Wave 2 stories       | <n>       |  → Source A wave2
#     | Wave 6 stories       | <n>       |  → Source A wave6
#     | Maintenance Stories  | <n>       |  → Source A maint
#     | BCs covered          | <n> / <n> |  → Source C (both values must equal total_bcs)
#   Rows NOT validated by this hook (require per-file scanning):
#     | Stories with VP anchor   | <n> |  → would need VP-to-Story Anchor Map + dedup
#     | Stories with Red Gate BCs | <n> |  → would need VP red_gate: field scan
#
# Target 2 — Opening header blockquote:
#   Lines matching:
#     "> **N stories total — W1 Wave 1 / W2 Wave 2 / W6 Wave 6 / M Maint"
#       → total = Source A total; W1 = wave1; W2 = wave2; W6 = wave6; M = maint
#     "> **Product-story census: P (W1 Wave 1 / W2 Wave 2 / W6 Wave 6)"
#       → product = Source A product; wave1/wave2/wave6 repeated
#     "> **BC coverage: N BCs"
#       → N = Source C
#
# Target 3 — §BC to Story Coverage Map intro:
#   Line matching: "> **All N BCs covered."
#     → N = Source C
#
# WHAT THIS CATCHES
# ─────────────────
# D-327 class: authoring burst adds stories to Story Inventory and updates
# per-subsystem BC-count headers, but leaves Census table, opening header
# blockquote, and BC-coverage-map intro showing stale pre-authoring values.
# Pre-D-327 values were 40/27/11/134/13/8; post-D-327 correct values are
# 42/28/12/140/15/10. Without this gate, three aggregate blocks stayed at
# stale values for the entire round-50 spec cycle.
#
# SELF-PROBES (POL-31)
# ─────────────────────
# Synthetic fixture pair exercised before live scan:
#   probe_neg_census_mismatch:   Inventory says 7 stories, Census table says 5 → FAIL
#   probe_neg_blockquote_mismatch: Inventory says 7 stories, blockquote says 5 → FAIL
#   probe_neg_coverage_intro_mismatch: SS headers sum to 10 BCs, intro says 8 → FAIL
#   probe_pos_all_agree:  All representations agree → zero FAIL lines
# POL-30: probe fixtures live in $TMPDIR, never under .factory/stories/.
#
# EXIT CONTRACT
# ─────────────
# Exit 1 if any FAIL lines are emitted (blocking gate).
# Exit 2 if any self-probe fails (script bug — a check is false-green or false-red).
# Exit 0 if FAIL == 0 and all self-probes pass.
#
# TD-VSDD-091: findings cite "§Census table :: row-key" or "§header-blockquote";
# no file:NNN line-number citations.
#
# Usage:  bash .factory/hooks/verify-story-count-propagation.sh
# Exit:   1 if FAIL > 0; 2 if self-probe fails; 0 otherwise.
# Integration: wired as BLOCKING in pre-commit-validators.sh.

set -uo pipefail

HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
FACTORY_DIR="$(cd "$HOOKS_DIR/.." && pwd)"
STORY_INDEX_FILE="$FACTORY_DIR/stories/STORY-INDEX.md"
STATE_MD_FILE="$FACTORY_DIR/STATE.md"

PASS=0
WARN=0
FAIL=0

emit() {
  local level="$1"
  local msg="$2"
  echo "[$level] $msg"
  case "$level" in
    PASS) PASS=$((PASS + 1)) ;;
    WARN) WARN=$((WARN + 1)) ;;
    FAIL) FAIL=$((FAIL + 1)) ;;
  esac
}

# ── Python3 STORY-INDEX parser ────────────────────────────────────────────────
# Arguments: <story_index_file>
# Output lines (key=value format):
#   INV_TOTAL <n>     total story rows in ## Story Inventory
#   INV_WAVE1 <n>     rows with ID prefix S-1.
#   INV_WAVE2 <n>     rows with ID prefix S-2.
#   INV_WAVE3 <n>     rows with ID prefix S-console-
#   INV_WAVE6 <n>     rows with ID prefix S-6.
#   INV_MAINT <n>     rows with ID prefix S-MAINT
#   INV_PRODUCT <n>   total - maint
#   SS_BC_SUM <n>     sum of BC counts from ### SS-NN headers in BC coverage map
#   CENSUS_TOTAL <n>  Census table "Total Story Files" cell
#   CENSUS_PRODUCT <n>  Census table "Product Stories" cell
#   CENSUS_WAVE1 <n>  Census table "Wave 1 stories" cell
#   CENSUS_WAVE2 <n>  Census table "Wave 2 stories" cell
#   CENSUS_WAVE6 <n>  Census table "Wave 6 stories" cell
#   CENSUS_MAINT <n>  Census table "Maintenance Stories" cell
#   CENSUS_BCS_A <n>  Census table "BCs covered" first number (NNN / MMM)
#   CENSUS_BCS_B <n>  Census table "BCs covered" second number
#   BQ_TOTAL <n>      Blockquote "N stories total" value
#   BQ_WAVE1 <n>      Blockquote "N Wave 1" value
#   BQ_WAVE2 <n>      Blockquote "N Wave 2" value
#   BQ_WAVE6 <n>      Blockquote "N Wave 6" value
#   BQ_MAINT <n>      Blockquote "N Maint" value
#   BQ_PRODUCT <n>    Blockquote "Product-story census: N" value
#   BQ_BC_TOTAL <n>   Blockquote "BC coverage: N BCs" value
#   INTRO_BC <n>      BC coverage map intro "All N BCs covered"
#   PARSE_ERROR <msg> if any required field could not be parsed
run_parser() {
  local story_index_file="$1"
  python3 - "$story_index_file" <<'PYEOF'
import sys, re

story_index_file = sys.argv[1]

try:
    with open(story_index_file, 'r', encoding='utf-8') as fh:
        lines = fh.readlines()
except OSError as e:
    print(f'PARSE_ERROR cannot read file: {e}')
    sys.exit(0)

# ── Section tracker ───────────────────────────────────────────────────────────
# Track which top-level ## section we are in.

IN_NONE           = 'none'
IN_STORY_INV      = 'story_inventory'
IN_CENSUS         = 'census'
IN_BC_COVERAGE    = 'bc_coverage'

current_section = IN_NONE

# ── Counters ──────────────────────────────────────────────────────────────────
inv_wave1 = 0
inv_wave2 = 0
inv_wave3 = 0
inv_wave6 = 0
inv_maint = 0

ss_bc_sum  = 0

# Census table parsed cells
census = {}

# Blockquote values (set when matching lines seen)
bq = {}

# BC coverage map intro
intro_bc = None

# ── Regex patterns ────────────────────────────────────────────────────────────

# Story Inventory data row: starts with "| S-" (ID column is first)
STORY_ROW_RE   = re.compile(r'^\|\s*(S-(\d+)\.|S-MAINT)')
WAVE1_ROW_RE   = re.compile(r'^\|\s*S-1\.')
WAVE2_ROW_RE   = re.compile(r'^\|\s*S-2\.')
WAVE3_ROW_RE   = re.compile(r'^\|\s*S-console-')
WAVE6_ROW_RE   = re.compile(r'^\|\s*S-6\.')
MAINT_ROW_RE   = re.compile(r'^\|\s*S-MAINT')

# Per-SS header in BC-coverage-map section: ### SS-NN ... (NNN BCs...)
SS_HEADER_BC_RE = re.compile(r'^###\s+SS-\d+\s+.*\((\d+)\s+BCs?')

# Census table row: | Key | Value |
CENSUS_ROW_RE  = re.compile(r'^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|')

# Separator row (header rule)
SEP_ROW_RE     = re.compile(r'^[|\-:\s]+$')

# Blockquote lines (start with ">")
BQ_LINE_RE     = re.compile(r'^>')

# "N stories total — W1 Wave 1 / W2 Wave 2 / W6 Wave 6 / M Maint"
BQ_TOTAL_RE    = re.compile(r'\*\*(\d+)\s+stories\s+total\s+[—–-]\s+(\d+)\s+Wave\s+1\s*/\s*(\d+)\s+Wave\s+2\s*/\s*(?:\d+\s+Wave\s+3\s*/\s*)?(\d+)\s+Wave\s+6\s*/\s*(\d+)\s+Maint')

# "Product-story census: P (W1 Wave 1 / W2 Wave 2 / W6 Wave 6)"
BQ_PRODUCT_RE  = re.compile(r'Product-story census:\s*(\d+)\s*\(\s*(\d+)\s+Wave\s+1\s*/\s*(\d+)\s+Wave\s+2\s*/\s*(?:\d+\s+Wave\s+3\s*/\s*)?(\d+)\s+Wave\s+6\s*\)')

# "BC coverage: N BCs"
BQ_BC_RE       = re.compile(r'BC\s+coverage:\s*(\d+)\s+BCs')

# BC coverage map intro: "> **All N BCs covered"
# Must be in ## BC to Story Coverage Map section, before first ### subsection
INTRO_BC_RE    = re.compile(r'All\s+(\d+)\s+BCs?\s+covered')

in_intro_zone  = False   # True once inside ## BC to Story Coverage Map, before first ###

# ── Line scan ─────────────────────────────────────────────────────────────────
for raw_line in lines:
    line = raw_line.rstrip('\n')
    stripped = line.strip()

    # Section header detection
    if stripped.startswith('## '):
        section_title = stripped[3:].strip()
        if section_title.startswith('Story Inventory'):
            current_section = IN_STORY_INV
            in_intro_zone   = False
        elif section_title.startswith('Census'):
            current_section = IN_CENSUS
            in_intro_zone   = False
        elif section_title.startswith('BC to Story Coverage Map'):
            current_section = IN_BC_COVERAGE
            in_intro_zone   = True  # intro zone starts at this ## heading
        else:
            current_section = IN_NONE
            in_intro_zone   = False
        continue

    # Subsection header (###) inside BC coverage map: closes intro zone
    if stripped.startswith('### ') and current_section == IN_BC_COVERAGE:
        in_intro_zone = False

    # ── Story Inventory section ───────────────────────────────────────────────
    if current_section == IN_STORY_INV:
        if WAVE1_ROW_RE.match(stripped):
            inv_wave1 += 1
        elif WAVE2_ROW_RE.match(stripped):
            inv_wave2 += 1
        elif WAVE3_ROW_RE.match(stripped):
            inv_wave3 += 1
        elif WAVE6_ROW_RE.match(stripped):
            inv_wave6 += 1
        elif MAINT_ROW_RE.match(stripped):
            inv_maint += 1

    # ── Census section ────────────────────────────────────────────────────────
    elif current_section == IN_CENSUS:
        if stripped.startswith('|') and not SEP_ROW_RE.match(stripped):
            m = CENSUS_ROW_RE.match(stripped)
            if m:
                key_raw = m.group(1).strip()
                val_raw = m.group(2).strip()
                # Skip header row (key = "Metric")
                if key_raw.lower() == 'metric':
                    continue
                census[key_raw] = val_raw

    # ── BC to Story Coverage Map section ─────────────────────────────────────
    elif current_section == IN_BC_COVERAGE:
        # Per-SS header BC count
        m = SS_HEADER_BC_RE.match(stripped)
        if m:
            ss_bc_sum += int(m.group(1))

        # Intro "All N BCs covered" line (only in intro zone)
        if in_intro_zone and BQ_LINE_RE.match(stripped):
            m_intro = INTRO_BC_RE.search(stripped)
            if m_intro and intro_bc is None:
                intro_bc = int(m_intro.group(1))

    # ── Blockquote lines (outside any section, or in header area) ─────────────
    # Blockquote lines before the ## Story Inventory section
    if BQ_LINE_RE.match(stripped):
        m_total = BQ_TOTAL_RE.search(stripped)
        if m_total:
            bq['total']  = int(m_total.group(1))
            bq['wave1']  = int(m_total.group(2))
            bq['wave2']  = int(m_total.group(3))
            bq['wave6']  = int(m_total.group(4))
            bq['maint']  = int(m_total.group(5))
        m_prod = BQ_PRODUCT_RE.search(stripped)
        if m_prod:
            bq['product']    = int(m_prod.group(1))
            bq['bq_prod_w1'] = int(m_prod.group(2))
            bq['bq_prod_w2'] = int(m_prod.group(3))
            bq['bq_prod_w6'] = int(m_prod.group(4))
        m_bc = BQ_BC_RE.search(stripped)
        if m_bc:
            bq['bc_total']   = int(m_bc.group(1))

# ── Emit results ──────────────────────────────────────────────────────────────
inv_total   = inv_wave1 + inv_wave2 + inv_wave3 + inv_wave6 + inv_maint
inv_product = inv_total - inv_maint

print(f'INV_TOTAL {inv_total}')
print(f'INV_WAVE1 {inv_wave1}')
print(f'INV_WAVE2 {inv_wave2}')
print(f'INV_WAVE3 {inv_wave3}')
print(f'INV_WAVE6 {inv_wave6}')
print(f'INV_MAINT {inv_maint}')
print(f'INV_PRODUCT {inv_product}')
print(f'SS_BC_SUM {ss_bc_sum}')

# Census table cells
def census_int(key):
    v = census.get(key)
    if v is None:
        return None
    m = re.match(r'(\d+)', v)
    return int(m.group(1)) if m else None

print(f'CENSUS_TOTAL {census_int("Total Story Files")}')
print(f'CENSUS_PRODUCT {census_int("Product Stories")}')
print(f'CENSUS_WAVE1 {census_int("Wave 1 stories")}')
print(f'CENSUS_WAVE2 {census_int("Wave 2 stories")}')
print(f'CENSUS_WAVE6 {census_int("Wave 6 stories")}')
print(f'CENSUS_MAINT {census_int("Maintenance Stories")}')

# BCs covered: "NNN / NNN" — emit both
bcs_raw = census.get('BCs covered', '')
bcs_match = re.match(r'(\d+)\s*/\s*(\d+)', bcs_raw)
if bcs_match:
    print(f'CENSUS_BCS_A {bcs_match.group(1)}')
    print(f'CENSUS_BCS_B {bcs_match.group(2)}')
else:
    print(f'CENSUS_BCS_A None')
    print(f'CENSUS_BCS_B None')

# Blockquote values
print(f'BQ_TOTAL {bq.get("total")}')
print(f'BQ_WAVE1 {bq.get("wave1")}')
print(f'BQ_WAVE2 {bq.get("wave2")}')
print(f'BQ_WAVE6 {bq.get("wave6")}')
print(f'BQ_MAINT {bq.get("maint")}')
print(f'BQ_PRODUCT {bq.get("product")}')
print(f'BQ_BC_TOTAL {bq.get("bc_total")}')

# BC coverage map intro
print(f'INTRO_BC {intro_bc}')
PYEOF
}

# ── STATE.md total_bcs extractor ──────────────────────────────────────────────
# Returns: integer from `total_bcs:` frontmatter field, or empty string on failure.
get_state_total_bcs() {
  local state_file="$1"
  python3 - "$state_file" <<'PYEOF'
import sys, re

state_file = sys.argv[1]

try:
    with open(state_file, 'r', encoding='utf-8') as fh:
        lines = fh.readlines()
except OSError as e:
    print('')
    sys.exit(0)

# Only look in YAML frontmatter (between first and second ---)
in_frontmatter = False
fence_count = 0
for line in lines:
    stripped = line.strip()
    if stripped == '---':
        fence_count += 1
        if fence_count == 1:
            in_frontmatter = True
        elif fence_count == 2:
            in_frontmatter = False
        continue
    if in_frontmatter:
        m = re.match(r'^total_bcs:\s*"?(\d+)"?', stripped)
        if m:
            print(m.group(1))
            sys.exit(0)

print('')  # not found
PYEOF
}

# ── Cross-validation helper ───────────────────────────────────────────────────
# Usage: check_value LOCATION FIELD_LABEL parsed_val expected_val
check_value() {
  local location="$1" label="$2" parsed="$3" expected="$4"

  if [ "$parsed" = "None" ] || [ -z "$parsed" ]; then
    emit FAIL "count-propagation: ${location} :: ${label} — could not parse value (expected ${expected})"
    return
  fi
  if [ "$parsed" -ne "$expected" ] 2>/dev/null; then
    emit FAIL "count-propagation: ${location} :: ${label} — found ${parsed}, expected ${expected} (delta $((parsed - expected)))"
  else
    emit PASS "count-propagation: ${location} :: ${label} = ${parsed} (matches ground truth)"
  fi
}

# ── Self-probe infrastructure ─────────────────────────────────────────────────
PROBE_TMP=""

init_probe_tmp() {
  PROBE_TMP="$(mktemp -d)"
}

clean_probe_tmp() {
  [ -n "$PROBE_TMP" ] && [ -d "$PROBE_TMP" ] && rm -rf "$PROBE_TMP"
  PROBE_TMP=""
}

# Write a minimal synthetic STORY-INDEX with given parameters.
# Arguments: output_file total wave1 wave2 wave6 maint bc_total
#   census_total census_wave1 census_wave2 census_wave6 census_maint census_bcs
#   bq_total bq_wave1 bq_wave2 intro_bc
write_probe_story_index() {
  local outfile="$1"
  local inv_w1="$2" inv_w2="$3" inv_w6="$4" inv_maint="$5" ss_bc_total="$6"
  local cen_total="$7" cen_wave1="$8" cen_wave2="$9" cen_wave6="${10}" cen_maint="${11}" cen_bcs="${12}"
  local bq_total="${13}" bq_wave1="${14}" bq_wave2="${15}" bq_bc="${16}"

  local inv_total=$(( inv_w1 + inv_w2 + inv_w6 + inv_maint ))
  local inv_product=$(( inv_total - inv_maint ))
  local ss_half=$(( ss_bc_total / 2 ))
  local ss_rest=$(( ss_bc_total - ss_half ))

  {
    echo "---"
    echo "document_type: story-index"
    echo "---"
    echo ""
    echo "> **${bq_total} stories total — ${bq_wave1} Wave 1 / ${bq_wave2} Wave 2 / 0 Wave 6 / 0 Maint (S-MAINT-001 housekeeping, out-of-wave)**"
    echo "> **Product-story census: ${inv_product} (${inv_w1} Wave 1 / ${inv_w2} Wave 2 / 0 Wave 6). S-MAINT-001 is maintenance, not a product feature.**"
    echo "> **BC coverage: ${bq_bc} BCs — all covered**"
    echo ""
    echo "## Census"
    echo ""
    echo "| Metric | Count |"
    echo "|--------|-------|"
    echo "| Total Story Files | ${cen_total} |"
    echo "| Product Stories | ${inv_product} |"
    echo "| Wave 1 stories | ${cen_wave1} |"
    echo "| Wave 2 stories | ${cen_wave2} |"
    echo "| Wave 6 stories | ${cen_wave6} |"
    echo "| Maintenance Stories | ${cen_maint} |"
    echo "| BCs covered | ${cen_bcs} / ${cen_bcs} |"
    echo ""
    echo "## Story Inventory"
    echo ""
    echo "### Wave 1"
    echo ""
    echo "| ID | Title |"
    echo "|----|-------|"
    for i in $(seq 1 "$inv_w1"); do
      echo "| S-1.$(printf '%02d' $i) | Story $i |"
    done
    echo ""
    echo "### Wave 2"
    echo ""
    echo "| ID | Title |"
    echo "|----|-------|"
    for i in $(seq 1 "$inv_w2"); do
      echo "| S-2.$(printf '%02d' $i) | Story 2.$i |"
    done
    if [ "$inv_maint" -gt 0 ]; then
      echo ""
      echo "### Maintenance"
      echo ""
      echo "| ID | Title |"
      echo "|----|-------|"
      echo "| S-MAINT-001 | Maintenance Story |"
    fi
    echo ""
    echo "## BC to Story Coverage Map"
    echo ""
    echo "> **All ${bq_bc} BCs covered. Zero silent gaps.**"
    echo ""
    echo "### SS-01 Core Primitives (${ss_half} BCs)"
    echo ""
    echo "### SS-02 Graph (${ss_rest} BCs)"
  } > "$outfile"
}

# Write minimal STATE.md with given total_bcs
write_probe_state_md() {
  local outfile="$1"
  local total_bcs="$2"
  {
    echo "---"
    echo "document_type: pipeline-state"
    echo "total_bcs: \"${total_bcs}\""
    echo "---"
    echo "# State"
  } > "$outfile"
}

# ── run_probe: parse a fixture and extract a named field ──────────────────────
run_probe_parse() {
  local fixture_file="$1"
  run_parser "$fixture_file"
}

# ── Self-probe 1: Census total mismatch (D-327 class) ─────────────────────────
probe_neg_census_mismatch() {
  init_probe_tmp
  local story_idx="$PROBE_TMP/story-index.md"
  local state_md="$PROBE_TMP/state.md"

  # Inventory has 7 stories (5 Wave 1 + 2 Wave 2), but Census says 5
  #                       inv_w1 inv_w2 inv_w6 inv_maint ss_bc_total
  #                       cen_total cen_wave1 cen_wave2 cen_wave6 cen_maint cen_bcs
  #                       bq_total bq_wave1 bq_wave2 bq_bc
  write_probe_story_index "$story_idx" \
    5 2 0 0 10 \
    5 5 2 0 0 10 \
    7 5 2 10
  # Note: intro_bc is set inside write_probe_story_index using bq_bc (last arg)
  # We need to override intro_bc to match - it uses bq_bc for intro too.
  # But we want census_total=5 while inventory has 5+2=7 stories.
  # The write function sets cen_total=$7=5 and inv_w1=5, inv_w2=2 → inv_total=7.
  write_probe_state_md "$state_md" 10

  local out
  out="$(run_parser "$story_idx")"

  local inv_total cen_total
  inv_total="$(echo "$out" | grep '^INV_TOTAL ' | awk '{print $2}')"
  cen_total="$(echo "$out" | grep '^CENSUS_TOTAL ' | awk '{print $2}')"

  # The probe MUST detect a mismatch (inv_total=7, cen_total=5)
  if [ "$inv_total" != "7" ]; then
    echo "[SELF-PROBE FAIL] probe_neg_census_mismatch: expected INV_TOTAL=7, got '${inv_total}'"
    clean_probe_tmp
    return 2
  fi
  if [ "$cen_total" != "5" ]; then
    echo "[SELF-PROBE FAIL] probe_neg_census_mismatch: expected CENSUS_TOTAL=5, got '${cen_total}'"
    clean_probe_tmp
    return 2
  fi
  # Verify that cross-validation would flag this
  if [ "$inv_total" -eq "$cen_total" ] 2>/dev/null; then
    echo "[SELF-PROBE FAIL] probe_neg_census_mismatch: mismatch NOT detected (inv_total=${inv_total} == cen_total=${cen_total})"
    clean_probe_tmp
    return 2
  fi
  echo "[SELF-PROBE PASS] probe_neg_census_mismatch: INV_TOTAL=${inv_total} != CENSUS_TOTAL=${cen_total} — mismatch correctly detectable"
  clean_probe_tmp
}

# ── Self-probe 2: Blockquote mismatch ─────────────────────────────────────────
probe_neg_blockquote_mismatch() {
  init_probe_tmp
  local story_idx="$PROBE_TMP/story-index.md"
  local state_md="$PROBE_TMP/state.md"

  # Inventory has 7 stories (5 Wave 1 + 2 Wave 2), Census correct at 7,
  # but blockquote says 5 total and Wave 1 = 3
  # write_probe_story_index sets bq_total and bq_wave1 from args 13,14
  write_probe_story_index "$story_idx" \
    5 2 0 0 10 \
    7 5 2 0 0 10 \
    5 3 2 10
  write_probe_state_md "$state_md" 10

  local out
  out="$(run_parser "$story_idx")"

  local inv_total bq_total
  inv_total="$(echo "$out" | grep '^INV_TOTAL ' | awk '{print $2}')"
  bq_total="$(echo "$out" | grep '^BQ_TOTAL ' | awk '{print $2}')"

  if [ "$inv_total" != "7" ]; then
    echo "[SELF-PROBE FAIL] probe_neg_blockquote_mismatch: expected INV_TOTAL=7, got '${inv_total}'"
    clean_probe_tmp
    return 2
  fi
  if [ "$bq_total" != "5" ]; then
    echo "[SELF-PROBE FAIL] probe_neg_blockquote_mismatch: expected BQ_TOTAL=5, got '${bq_total}'"
    clean_probe_tmp
    return 2
  fi
  if [ "$inv_total" -eq "$bq_total" ] 2>/dev/null; then
    echo "[SELF-PROBE FAIL] probe_neg_blockquote_mismatch: mismatch NOT detected (inv_total=${inv_total} == bq_total=${bq_total})"
    clean_probe_tmp
    return 2
  fi
  echo "[SELF-PROBE PASS] probe_neg_blockquote_mismatch: INV_TOTAL=${inv_total} != BQ_TOTAL=${bq_total} — mismatch correctly detectable"
  clean_probe_tmp
}

# ── Self-probe 3: BC-coverage-map intro mismatch ──────────────────────────────
probe_neg_coverage_intro_mismatch() {
  init_probe_tmp
  local story_idx="$PROBE_TMP/story-index.md"
  local state_md="$PROBE_TMP/state.md"

  # SS headers sum to 10 BCs, but intro says 8
  # bq_bc (arg 16) is used for BOTH the blockquote BC line AND the intro BC line
  # in write_probe_story_index. To create mismatch we need to write the file manually.
  cat > "$story_idx" <<'STOEOF'
---
document_type: story-index
---

> **5 stories total — 5 Wave 1 / 0 Wave 2 / 0 Wave 6 / 0 Maint**
> **Product-story census: 5 (5 Wave 1 / 0 Wave 2 / 0 Wave 6)**
> **BC coverage: 10 BCs — all covered**

## Census

| Metric | Count |
|--------|-------|
| Total Story Files | 5 |
| Product Stories | 5 |
| Wave 1 stories | 5 |
| Wave 2 stories | 0 |
| Wave 6 stories | 0 |
| Maintenance Stories | 0 |
| BCs covered | 10 / 10 |

## Story Inventory

### Wave 1

| ID | Title |
|----|-------|
| S-1.01 | Story 1 |
| S-1.02 | Story 2 |
| S-1.03 | Story 3 |
| S-1.04 | Story 4 |
| S-1.05 | Story 5 |

## BC to Story Coverage Map

> **All 8 BCs covered. Zero silent gaps.**

### SS-01 Core Primitives (6 BCs)

### SS-02 Graph (4 BCs)
STOEOF
  write_probe_state_md "$state_md" 10

  local out
  out="$(run_parser "$story_idx")"

  local ss_bc_sum intro_bc
  ss_bc_sum="$(echo "$out" | grep '^SS_BC_SUM ' | awk '{print $2}')"
  intro_bc="$(echo "$out" | grep '^INTRO_BC ' | awk '{print $2}')"

  if [ "$ss_bc_sum" != "10" ]; then
    echo "[SELF-PROBE FAIL] probe_neg_coverage_intro_mismatch: expected SS_BC_SUM=10, got '${ss_bc_sum}'"
    clean_probe_tmp
    return 2
  fi
  if [ "$intro_bc" != "8" ]; then
    echo "[SELF-PROBE FAIL] probe_neg_coverage_intro_mismatch: expected INTRO_BC=8, got '${intro_bc}'"
    clean_probe_tmp
    return 2
  fi
  if [ "$ss_bc_sum" -eq "$intro_bc" ] 2>/dev/null; then
    echo "[SELF-PROBE FAIL] probe_neg_coverage_intro_mismatch: mismatch NOT detected (ss_bc_sum=${ss_bc_sum} == intro_bc=${intro_bc})"
    clean_probe_tmp
    return 2
  fi
  echo "[SELF-PROBE PASS] probe_neg_coverage_intro_mismatch: SS_BC_SUM=${ss_bc_sum} != INTRO_BC=${intro_bc} — mismatch correctly detectable"
  clean_probe_tmp
}

# ── Self-probe 4: All representations agree (positive case) ───────────────────
probe_pos_all_agree() {
  init_probe_tmp
  local story_idx="$PROBE_TMP/story-index.md"
  local state_md="$PROBE_TMP/state.md"

  # Everything consistent: 7 stories (5+2), 10 BCs
  write_probe_story_index "$story_idx" \
    5 2 0 0 10 \
    7 5 2 0 0 10 \
    7 5 2 10
  write_probe_state_md "$state_md" 10

  local out
  out="$(run_parser "$story_idx")"
  local state_bcs
  state_bcs="$(get_state_total_bcs "$state_md")"

  # All key pairs should match
  local inv_total cen_total bq_total ss_bc_sum intro_bc
  inv_total="$(echo "$out" | grep '^INV_TOTAL ' | awk '{print $2}')"
  cen_total="$(echo "$out" | grep '^CENSUS_TOTAL ' | awk '{print $2}')"
  bq_total="$(echo "$out" | grep '^BQ_TOTAL ' | awk '{print $2}')"
  ss_bc_sum="$(echo "$out" | grep '^SS_BC_SUM ' | awk '{print $2}')"
  intro_bc="$(echo "$out" | grep '^INTRO_BC ' | awk '{print $2}')"

  local failed=0
  if [ "$inv_total" != "7" ] || [ "$cen_total" != "7" ] || [ "$bq_total" != "7" ]; then
    echo "[SELF-PROBE FAIL] probe_pos_all_agree: story count mismatch — INV=${inv_total} CEN=${cen_total} BQ=${bq_total} (all expected 7)"
    failed=1
  fi
  if [ "$ss_bc_sum" != "10" ] || [ "$intro_bc" != "10" ] || [ "$state_bcs" != "10" ]; then
    echo "[SELF-PROBE FAIL] probe_pos_all_agree: BC count mismatch — SS_SUM=${ss_bc_sum} INTRO=${intro_bc} STATE=${state_bcs} (all expected 10)"
    failed=1
  fi
  if [ "$failed" -eq 0 ]; then
    echo "[SELF-PROBE PASS] probe_pos_all_agree: all representations agree (stories=7, BCs=10)"
  fi
  clean_probe_tmp
  return "$failed"
}

# ── Run self-probes ───────────────────────────────────────────────────────────
echo "── count-propagation self-probes ───────────────────────────────────────"

PROBE_FAIL=0

probe_neg_census_mismatch     || PROBE_FAIL=$((PROBE_FAIL + 1))
probe_neg_blockquote_mismatch || PROBE_FAIL=$((PROBE_FAIL + 1))
probe_neg_coverage_intro_mismatch || PROBE_FAIL=$((PROBE_FAIL + 1))
probe_pos_all_agree           || PROBE_FAIL=$((PROBE_FAIL + 1))

if [ "$PROBE_FAIL" -gt 0 ]; then
  echo ""
  echo "[SELF-PROBE ABORT] ${PROBE_FAIL} self-probe(s) failed — script has a bug; aborting live scan"
  exit 2
fi

echo ""

# ── Live corpus scan ──────────────────────────────────────────────────────────
echo "── count-propagation live scan ─────────────────────────────────────────"

if [ ! -f "$STORY_INDEX_FILE" ]; then
  emit WARN "count-propagation: STORY-INDEX.md not found at ${STORY_INDEX_FILE} — skipping live scan"
  echo ""; echo "PASS=${PASS}  WARN=${WARN}  FAIL=${FAIL}"; exit 0
fi

if [ ! -f "$STATE_MD_FILE" ]; then
  emit WARN "count-propagation: STATE.md not found at ${STATE_MD_FILE} — BC cross-check skipped"
fi

# Parse STORY-INDEX
PARSE_OUT="$(run_parser "$STORY_INDEX_FILE")"

# Check for PARSE_ERROR
if echo "$PARSE_OUT" | grep -q '^PARSE_ERROR'; then
  err_msg="$(echo "$PARSE_OUT" | grep '^PARSE_ERROR' | sed 's/^PARSE_ERROR //')"
  emit FAIL "count-propagation: parser error — ${err_msg}"
  echo ""; echo "PASS=${PASS}  WARN=${WARN}  FAIL=${FAIL}"; exit 1
fi

# Extract parsed values
get_val() { echo "$PARSE_OUT" | grep "^$1 " | awk '{print $2}'; }

INV_TOTAL="$(get_val INV_TOTAL)"
INV_WAVE1="$(get_val INV_WAVE1)"
INV_WAVE2="$(get_val INV_WAVE2)"
INV_WAVE3="$(get_val INV_WAVE3)"
INV_WAVE6="$(get_val INV_WAVE6)"
INV_MAINT="$(get_val INV_MAINT)"
INV_PRODUCT="$(get_val INV_PRODUCT)"
SS_BC_SUM="$(get_val SS_BC_SUM)"

CENSUS_TOTAL="$(get_val CENSUS_TOTAL)"
CENSUS_PRODUCT="$(get_val CENSUS_PRODUCT)"
CENSUS_WAVE1="$(get_val CENSUS_WAVE1)"
CENSUS_WAVE2="$(get_val CENSUS_WAVE2)"
CENSUS_WAVE6="$(get_val CENSUS_WAVE6)"
CENSUS_MAINT="$(get_val CENSUS_MAINT)"
CENSUS_BCS_A="$(get_val CENSUS_BCS_A)"
CENSUS_BCS_B="$(get_val CENSUS_BCS_B)"

BQ_TOTAL="$(get_val BQ_TOTAL)"
BQ_WAVE1="$(get_val BQ_WAVE1)"
BQ_WAVE2="$(get_val BQ_WAVE2)"
BQ_WAVE6="$(get_val BQ_WAVE6)"
BQ_MAINT="$(get_val BQ_MAINT)"
BQ_PRODUCT="$(get_val BQ_PRODUCT)"
BQ_BC_TOTAL="$(get_val BQ_BC_TOTAL)"

INTRO_BC="$(get_val INTRO_BC)"

# Get STATE.md total_bcs (authoritative BC count)
STATE_BCS=""
if [ -f "$STATE_MD_FILE" ]; then
  STATE_BCS="$(get_state_total_bcs "$STATE_MD_FILE")"
fi

echo "  Ground truth (from Story Inventory rows):"
echo "    Total=${INV_TOTAL}  Wave1=${INV_WAVE1}  Wave2=${INV_WAVE2}  Wave3=${INV_WAVE3}  Wave6=${INV_WAVE6}  Maint=${INV_MAINT}  Product=${INV_PRODUCT}"
echo "  Ground truth (BC counts):"
echo "    SS-header-sum=${SS_BC_SUM}  STATE.md-total_bcs=${STATE_BCS}"
echo ""

# ── BC count consistency: STATE.md vs SS-header-sum ───────────────────────────
if [ -n "$STATE_BCS" ] && [ -n "$SS_BC_SUM" ] && [ "$SS_BC_SUM" != "None" ]; then
  if [ "$SS_BC_SUM" -ne "$STATE_BCS" ] 2>/dev/null; then
    emit FAIL "count-propagation: BC ground-truth disagreement — SS-header-sum=${SS_BC_SUM} != STATE.md-total_bcs=${STATE_BCS} (per-SS headers or STATE.md is stale)"
  else
    emit PASS "count-propagation: BC ground-truth consistent — SS-header-sum == STATE.md-total_bcs == ${STATE_BCS}"
  fi
fi

# Use SS_BC_SUM as the authoritative BC count for downstream checks (it is
# STORY-INDEX-internal; STATE.md is a cross-file corroboration).
# If they disagree, both checks below will fire on the correct mismatch.
AUTH_BC="${SS_BC_SUM}"
if [ -z "$AUTH_BC" ] || [ "$AUTH_BC" = "None" ] || [ "$AUTH_BC" = "0" ]; then
  # Fall back to STATE.md if SS headers weren't parsed
  AUTH_BC="${STATE_BCS}"
fi

echo "  §Census table:"
check_value "§Census table" "Total Story Files" "$CENSUS_TOTAL" "$INV_TOTAL"
check_value "§Census table" "Product Stories"   "$CENSUS_PRODUCT" "$INV_PRODUCT"
check_value "§Census table" "Wave 1 stories"    "$CENSUS_WAVE1" "$INV_WAVE1"
check_value "§Census table" "Wave 2 stories"    "$CENSUS_WAVE2" "$INV_WAVE2"
check_value "§Census table" "Wave 6 stories"    "$CENSUS_WAVE6" "$INV_WAVE6"
check_value "§Census table" "Maintenance Stories" "$CENSUS_MAINT" "$INV_MAINT"
if [ -n "$AUTH_BC" ] && [ "$AUTH_BC" != "None" ]; then
  check_value "§Census table" "BCs covered (first value)"  "$CENSUS_BCS_A" "$AUTH_BC"
  check_value "§Census table" "BCs covered (second value)" "$CENSUS_BCS_B" "$AUTH_BC"
fi

echo ""
echo "  §Opening header blockquote:"
check_value "§header-blockquote" "stories total" "$BQ_TOTAL" "$INV_TOTAL"
check_value "§header-blockquote" "Wave 1 count"  "$BQ_WAVE1" "$INV_WAVE1"
check_value "§header-blockquote" "Wave 2 count"  "$BQ_WAVE2" "$INV_WAVE2"
check_value "§header-blockquote" "Wave 6 count"  "$BQ_WAVE6" "$INV_WAVE6"
check_value "§header-blockquote" "Maint count"   "$BQ_MAINT" "$INV_MAINT"
check_value "§header-blockquote" "Product-story census" "$BQ_PRODUCT" "$INV_PRODUCT"
if [ -n "$AUTH_BC" ] && [ "$AUTH_BC" != "None" ]; then
  check_value "§header-blockquote" "BC coverage count" "$BQ_BC_TOTAL" "$AUTH_BC"
fi

echo ""
echo "  §BC-coverage-map intro:"
if [ -n "$AUTH_BC" ] && [ "$AUTH_BC" != "None" ]; then
  check_value "§BC-coverage-map-intro" "All N BCs covered" "$INTRO_BC" "$AUTH_BC"
fi

# ── Final summary ─────────────────────────────────────────────────────────────
echo ""
echo "  PASS=${PASS}  WARN=${WARN}  FAIL=${FAIL}"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo "GATE: FAIL — ${FAIL} count-propagation finding(s) — Census table / blockquote / BC-coverage intro are stale; update STORY-INDEX aggregate summary blocks."
  exit 1
fi

echo "GATE: PASS — all STORY-INDEX aggregate summary representations agree with ground truth."
exit 0
