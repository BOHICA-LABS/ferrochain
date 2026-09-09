#!/usr/bin/env bash
# verify-ac-pc-trace.sh — pregolya factory-artifacts BLOCKING/ADVISORY validator
#
# PURPOSE
# ───────
# Mechanically checks AC→BC-postcondition trace citations in story files.
# For every acceptance criterion in .factory/stories/stories/*.md that cites
# a BC section, verifies that the cited tag exists in the referenced BC file.
# Catches the P2A-032 drift class (stories citing non-existent PC/INV/EC tags).
#
# M4 STRICT CITATION ENFORCEMENT (ADR-027 Decision-4)
# ─────────────────────────────────────────────────────
# Only stable-tag form is accepted:
#
#   REQUIRED stable-tag form:
#     ### AC-NNN (traces to BC-S.SS.NNN PC-NNN)
#     ### AC-NNN (traces to BC-S.SS.NNN INV-NNN)
#     ### AC-NNN (traces to BC-S.SS.NNN PRE-NNN)
#     ### AC-NNN (traces to BC-S.SS.NNN EC-NNN)
#
# CHECK 1 resolves by grepping the {PC-NNN}/{INV-NNN}/{PRE-NNN} token in the
# BC section, or EC-NNN in the ## Edge Cases section.
#
# BLOCKING DRIFT — mixed-form-anchor:
#   Old ordinal form (postcondition N / invariant N / precondition N) is now
#   forbidden.  Any AC header matching the old form emits DRIFT with
#   reason=mixed-form-anchor and exits 1.  Migration window (M2–M3) is closed.
#
# CHECKS IMPLEMENTED
# ──────────────────
# CHECK 1 — Existence check (highest value):
#   Stable-tag form only (M4): the cited {PC-NNN}/{INV-NNN}/{PRE-NNN} token
#   must be present in the relevant BC section; EC-NNN must appear in
#   ## Edge Cases headers or table rows.
#   reason=nonexistent in DRIFT output.
#   Old ordinal form detected → reason=mixed-form-anchor in DRIFT output.
#
# CHECK 2 — Error-code co-location check (ADVISORY — non-blocking):
#   If the AC text asserts an error code (E-XXX-NNN), verify that SAME code
#   appears in the text of the specifically-cited PC/INV/EC item in the BC.
#   A code that is absent from the cited item but present elsewhere in the BC
#   is a strong signal the trace number is wrong.
#   reason=code-absent in ADVISORY output (heuristic; error codes may appear
#   in ACs as examples, table-row contrasts, or inline illustrations without
#   implying the cited item must contain them).
#
# CHECK 3 — Keyword-overlap heuristic (ADVISORY hints only):
#   When the AC's key nouns/verbs have near-zero overlap with the cited
#   PC/INV/EC text, emit a low-confidence WARN with reason=low-overlap.
#   Threshold: AC has ≥4 content words but zero overlap with cited item text.
#
# SCOPE
# ─────
# All .factory/stories/stories/STORY-S-*.md files (39 stories).
# Self-scope exclusion: this file is in .factory/hooks/ and is never parsed.
#
# EXIT CONTRACT
# ─────────────
# CHECK 1 (existence: reason=nonexistent, reason=bc-file-missing) — BLOCKING.
#   Exits 1 when any CHECK-1 DRIFT > 0. Emits "DRIFT ..." lines.
# CHECK 2 (error-code co-location: reason=code-absent) — ADVISORY.
#   Never blocks. Emits "ADVISORY ..." lines (grep-separable from DRIFT).
#   Exits 0 even when advisory hints exist, provided CHECK-1 drift is 0.
# Summary reports:
#   "CHECK-1 (blocking) drift: N" and "CHECK-2 (advisory) hints: M"
# RESULT line: PASS when CHECK-1 drift == 0; FAIL when CHECK-1 drift > 0.
#
# POL-26: Edit/Write tools only for .factory/ mutations.
# POL-30: Self-scope exclusion — hooks dir excluded from lint scope.
# TD-VSDD-091: No file:NNN line citations in comments or output text.
#
# Usage:  bash .factory/hooks/verify-ac-pc-trace.sh
# Exit:   0 when DRIFT==0; 1 when DRIFT>0 (blocking mode)

set -euo pipefail

FACTORY_DIR="$(cd "$(dirname "$0")/.." && pwd)"
STORIES_DIR="$FACTORY_DIR/stories/stories"
BC_BASE_DIR="$FACTORY_DIR/specs/behavioral-contracts"

DRIFT=0
TOTAL_CITATIONS=0
STORIES_WITH_DRIFT=0

# ── Emit helpers ─────────────────────────────────────────────────────────────

emit_drift() {
  local story_id="$1"
  local ac_id="$2"
  local cited="$3"
  local reason="$4"
  local extra="$5"
  local bc_id="$6"
  echo "DRIFT $story_id $ac_id cited=$cited reason=$reason${extra:+ $extra} bc=$bc_id"
  DRIFT=$((DRIFT + 1))
}

# ── Python3 core logic ───────────────────────────────────────────────────────

PYTHON_OUTPUT="$(python3 - "$STORIES_DIR" "$BC_BASE_DIR" <<'PYEOF'
import sys
import os
import re

STORIES_DIR = sys.argv[1]
BC_BASE_DIR  = sys.argv[2]

# ── Citation regexes (M4 strict, ADR-027 Decision-4) ─────────────────────────
# REQUIRED stable-tag form: ### AC-NNN (traces to BC-S.SS.NNN PC-NNN)
# groups: (1)AC-id (2)BC-id (3)tag-prefix (4)tag-digits (5)trailing
NEW_CITE_RE = re.compile(
    r'###\s+(AC-\d+)\s+\(traces\s+to\s+'
    r'(BC-\d+\.\d+\.\d+)\s+'
    r'(PC|INV|PRE|EC)-(\d+)'
    r'([^)]*)\)',
    re.IGNORECASE
)

# FORBIDDEN old ordinal form: ### AC-NNN (traces to BC-S.SS.NNN postcondition N)
# Detected to emit DRIFT reason=mixed-form-anchor (M4 cutover — migration window closed).
# groups: (1)AC-id (2)BC-id (3)section-word (4)number-or-EC (5)trailing
OLD_CITE_RE = re.compile(
    r'###\s+(AC-\d+)\s+\(traces\s+to\s+'
    r'(BC-\d+\.\d+\.\d+)\s+'
    r'(postconditions?|invariant|precondition|edge\s+case)\s*'
    r'(EC-\d+|\d+(?:/\d+)*)?'
    r'([^)]*)\)',
    re.IGNORECASE
)

# Error code pattern anywhere in AC text
ERRCODE_RE = re.compile(r'\bE-[A-Z]+-\d+\b')

# ── Multi-clause trace extractor and parser ───────────────────────────────────
# Extracts the full content of a "(traces to ...)" parenthetical from an AC line.
_TRACE_CONTENT_RE = re.compile(r'\(traces\s+to\s+([^)]+)\)', re.IGNORECASE)

# Tokeniser for the content inside a trace parenthetical.
# Group 1: BC-id qualifier  (e.g. BC-2.12.003)
# Group 2: tag prefix       (e.g. PC)
# Group 3: tag number       (e.g. 006)
# Negative lookbehind/lookahead prevent matching {PC-NNN} stable-tag tokens
# that appear INSIDE BC source files (only story-file citation tokens wanted).
_TRACE_TOKEN_RE = re.compile(
    r'(BC-\d+\.\d+\.\d+)'
    r'|'
    r'(?<!\{)\b(PC|INV|PRE|EC)-(\d+)\b(?!\})',
    re.IGNORECASE
)


def parse_all_trace_clauses(trace_text):
    """
    Parse all (bc_id, tag_id) pairs from a trace-to clause string.

    Implements BC inheritance: a bare tag token that is not preceded by a
    BC qualifier on the same trace inherits the most recently seen BC-id.
    This handles shorthands like:
      "BC-2.12.004 PC-006, EC-001, EC-002, EC-004"  (3 bare tags inherit BC-2.12.004)
      "BC-2.12.003 INV-006, BC-2.12.002 EC-006"     (explicit re-qualification)
      "BC-2.18.004 PC-005 and BC-2.18.004 PRE-002"  (same BC repeated)

    Returns list of (bc_id, tag_id) tuples in appearance order.
    Tags that appear before any BC qualifier are silently skipped (malformed).
    """
    current_bc: str | None = None
    pairs: list = []
    for m in _TRACE_TOKEN_RE.finditer(trace_text):
        if m.group(1):
            # BC qualifier: update context
            current_bc = m.group(1)
        elif m.group(2) is not None and current_bc is not None:
            prefix = m.group(2).upper()
            num    = m.group(3).zfill(3)
            pairs.append((current_bc, f"{prefix}-{num}"))
    return pairs

# Stop-words for keyword overlap check (short or common words not useful)
STOPWORDS = {
    'the','a','an','is','are','was','were','be','been','being',
    'have','has','had','do','does','did','will','would','could',
    'should','may','might','shall','must','can','of','in','on',
    'at','to','for','with','by','from','as','or','and','not',
    'that','this','it','its','if','when','then','so','but','no',
    'any','all','each','per','via','ok','err','fn','pub','use',
    'let','mut','ref','type','impl','struct','enum','trait','mod',
    'true','false','none','some','result','option',
}

def keywords(text):
    """Extract meaningful words from text for overlap heuristic."""
    words = re.findall(r'[a-zA-Z][a-zA-Z0-9_]*', text.lower())
    return {w for w in words if len(w) >= 4 and w not in STOPWORDS}


def resolve_bc_path(bc_id):
    """BC-2.SS.NNN → .../ss-SS/BC-2.SS.NNN.md"""
    m = re.match(r'BC-(\d+)\.(\d+)\.(\d+)', bc_id)
    if not m:
        return None
    section = m.group(2).zfill(2)
    return os.path.join(BC_BASE_DIR, f"ss-{section}", f"{bc_id}.md")


def extract_section(content, section_header):
    """
    Extract text from a ## Section to the next ## heading (exclusive).
    Returns the text within that section, or '' if not found.
    """
    # Match ## Postconditions, ## Invariants, ## Preconditions, ## Edge Cases
    pattern = re.compile(
        r'^## ' + re.escape(section_header) + r'\s*$',
        re.MULTILINE | re.IGNORECASE
    )
    m = pattern.search(content)
    if not m:
        return ''
    start = m.end()
    # Find next ## heading
    next_heading = re.search(r'^## ', content[start:], re.MULTILINE)
    end = start + next_heading.start() if next_heading else len(content)
    return content[start:end]


def count_numbered_items(section_text):
    """Count top-level numbered list items (^\d+\.) in section text, fence-aware."""
    # Skip lines inside fenced code blocks — they must not be treated as item boundaries.
    items = []
    in_fence = False
    for line in section_text.split('\n'):
        if line.strip().startswith('```'):
            in_fence = not in_fence
            continue
        if in_fence:
            continue
        m = re.match(r'^(\d+)\.\s', line)
        if m:
            items.append(int(m.group(1)))
    return items  # list of found numbers


def count_bullet_items(section_text):
    """Count top-level bullet items (^-) in section text; return count."""
    count = 0
    for line in section_text.split('\n'):
        if re.match(r'^-\s', line):
            count += 1
    return count


def get_ec_ids(section_text):
    """Return set of EC-NNN IDs found in ### EC-NNN: headers or table rows.
    Handles both bare  | EC-NNN |  and stable-tag  | {EC-NNN} |  formats."""
    header_ids   = set(re.findall(r'###\s+(EC-\d+)\b', section_text))
    table_ids    = set(re.findall(r'^\|\s*(EC-\d+)\s*\|', section_text, re.MULTILINE))
    # SS-24 and other BCs that completed ADR-027 M1 labeling use {EC-NNN} in table rows
    stable_ids   = set(re.findall(r'^\|\s*\{(EC-\d+)\}\s*\|', section_text, re.MULTILINE))
    return header_ids | table_ids | stable_ids


def get_stable_tags(section_text, tag_prefix):
    """
    Return the set of stable tag IDs present in section_text for the given prefix.
    tag_prefix is 'PC', 'INV', or 'PRE'.
    Matches {PC-NNN} / {INV-NNN} / {PRE-NNN} tokens anywhere in the section.
    Returns a set of normalised strings like {'PC-001', 'PC-002', ...}.
    Added for ADR-027 M2 dual-mode.
    """
    pattern = re.compile(r'\{' + re.escape(tag_prefix) + r'-(\d+)\}', re.IGNORECASE)
    return {f"{tag_prefix.upper()}-{m.zfill(3)}" for m in pattern.findall(section_text)}


def get_item_text_by_tag(section_text, tag):
    """
    Extract the text of a clause identified by its stable tag token, e.g. 'PC-001'.
    Scans from the line containing {TAG} to the line before the next stable tag at a
    top-level list-item boundary (^\\d+\\. or ^- at column 0), or end of section.
    Fence-aware: lines inside ``` fences belong to the enclosing clause.
    Returns '' when the tag is not found.
    Added for ADR-027 M2 dual-mode; used for CHECK-2 on new-form citations.
    """
    tag_token   = '{' + tag.upper() + '}'
    next_tag_re = re.compile(r'\{(?:PC|INV|PRE)-\d+\}', re.IGNORECASE)

    lines     = section_text.split('\n')
    capturing = False
    item_lines: list = []
    in_fence  = False

    for line in lines:
        if line.strip().startswith('```'):
            in_fence = not in_fence
            if capturing:
                item_lines.append(line)
            continue
        if in_fence:
            if capturing:
                item_lines.append(line)
            continue

        if not capturing:
            if tag_token in line:
                capturing = True
                item_lines.append(line)
        else:
            # Stop when a NEW top-level list marker carries a different stable tag
            top_marker = re.match(r'^(?:\d+\.\s|-\s)', line)
            if top_marker and next_tag_re.search(line) and tag_token not in line:
                break
            item_lines.append(line)

    return '\n'.join(item_lines)


def get_item_text(section_text, section_type, number_or_ec):
    """
    Extract the text of a specific numbered item or EC from a section.
    Used for CHECK 2 (error-code co-location) and CHECK 3 (keyword overlap).
    Returns '' if not found.
    """
    if section_type in ('postcondition', 'precondition'):
        # Numbered item: lines from N. up to next top-level M. (fence-aware).
        # Lines inside a ``` fenced block belong to the enclosing item and must
        # not be treated as new item boundaries.
        n = number_or_ec
        lines = section_text.split('\n')
        capturing = False
        item_lines = []
        in_fence = False
        for line in lines:
            if line.strip().startswith('```'):
                in_fence = not in_fence
                if capturing:
                    item_lines.append(line)
                continue
            if in_fence:
                if capturing:
                    item_lines.append(line)
                continue
            m = re.match(r'^(\d+)\.\s', line)
            if m:
                if int(m.group(1)) == n:
                    capturing = True
                    item_lines.append(line)
                elif capturing:
                    break
            elif capturing:
                item_lines.append(line)
        return '\n'.join(item_lines)

    elif section_type == 'invariant':
        n = number_or_ec
        lines = section_text.split('\n')
        # Detect list style: numbered (^\d+\.) wins over bullet (^-)
        is_numbered = any(re.match(r'^\d+\.\s', l) for l in lines)
        if is_numbered:
            # Walk numbered items, match by label (N. text) like postcondition branch (fence-aware).
            capturing = False
            item_lines = []
            in_fence = False
            for line in lines:
                if line.strip().startswith('```'):
                    in_fence = not in_fence
                    if capturing:
                        item_lines.append(line)
                    continue
                if in_fence:
                    if capturing:
                        item_lines.append(line)
                    continue
                lm = re.match(r'^(\d+)\.\s', line)
                if lm:
                    if int(lm.group(1)) == n:
                        capturing = True
                        item_lines.append(line)
                    elif capturing:
                        break
                elif capturing:
                    item_lines.append(line)
            return '\n'.join(item_lines)
        else:
            # Bullet style: the N-th bullet item (ordinal)
            count = 0
            capturing = False
            item_lines = []
            for line in lines:
                if re.match(r'^-\s', line):
                    count += 1
                    if count == n:
                        capturing = True
                        item_lines.append(line)
                    elif capturing:
                        break
                elif capturing:
                    # continuation lines (indented)
                    if line.startswith('  ') or line.startswith('\t') or line == '':
                        item_lines.append(line)
                    else:
                        break
            return '\n'.join(item_lines)

    elif section_type == 'edge_case':
        ec_id = number_or_ec  # e.g. 'EC-001'
        # Detect table format: rows matching | EC-NNN | or | {EC-NNN} | (ADR-027 M1 stable-tag)
        if re.search(r'^\|\s*(?:\{)?EC-\d+(?:\})?\s*\|', section_text, re.MULTILINE):
            # Table format: return the full matching row so error codes are visible
            ec_id_esc = re.escape(ec_id)
            for row in section_text.split('\n'):
                if re.match(r'^\|\s*' + ec_id_esc + r'\s*\|', row):
                    return row
                if re.match(r'^\|\s*\{' + ec_id_esc + r'\}\s*\|', row):
                    return row
            return ''
        # Header-block format: ### EC-NNN: to next ### or ##
        pattern = re.compile(
            r'^###\s+' + re.escape(ec_id) + r'\b',
            re.MULTILINE
        )
        m = pattern.search(section_text)
        if not m:
            return ''
        start = m.start()
        # Search from m.end() so the current ### line is never re-matched
        rest = section_text[m.end():]
        next_h = re.search(r'^#{2,3} ', rest, re.MULTILINE)
        end = m.end() + next_h.start() if next_h else len(section_text)
        return section_text[start:end]

    return ''


# ── BC cache ─────────────────────────────────────────────────────────────────
_bc_cache = {}

def load_bc(bc_id):
    """Load and parse a BC file, return parsed dict or None if missing."""
    if bc_id in _bc_cache:
        return _bc_cache[bc_id]

    path = resolve_bc_path(bc_id)
    if path is None or not os.path.isfile(path):
        _bc_cache[bc_id] = None
        return None

    with open(path, encoding='utf-8') as f:
        content = f.read()

    pc_section  = extract_section(content, 'Postconditions')
    inv_section = extract_section(content, 'Invariants')
    pre_section = extract_section(content, 'Preconditions')
    ec_section  = extract_section(content, 'Edge Cases')

    parsed = {
        'content':       content,
        'pc_section':    pc_section,
        'inv_section':   inv_section,
        'pre_section':   pre_section,
        'ec_section':    ec_section,
        'pc_numbers':    count_numbered_items(pc_section),
        'pc_max':        max(count_numbered_items(pc_section), default=0),
        'inv_count':     max(len(count_numbered_items(inv_section)), count_bullet_items(inv_section)),
        'pre_numbers':   count_numbered_items(pre_section),
        'pre_max':       max(count_numbered_items(pre_section), default=0),
        'ec_ids':        get_ec_ids(ec_section),
        # Stable tag sets — populated for BCs that completed M1 labeling (ADR-027)
        'pc_tags':       get_stable_tags(pc_section, 'PC'),
        'inv_tags':      get_stable_tags(inv_section, 'INV'),
        'pre_tags':      get_stable_tags(pre_section, 'PRE'),
    }
    _bc_cache[bc_id] = parsed
    return parsed


# ── Story processing ─────────────────────────────────────────────────────────

findings = []     # list of dicts
total_citations   = 0
per_story_counts  = {}  # story_id -> (citations, drift)

story_files = sorted(
    f for f in os.listdir(STORIES_DIR)
    if f.startswith('STORY-S-') and f.endswith('.md')
)

for filename in story_files:
    filepath = os.path.join(STORIES_DIR, filename)

    # Extract story_id from frontmatter story_id field
    story_id = None
    with open(filepath, encoding='utf-8') as f:
        raw = f.read()
    m = re.search(r'^story_id:\s*(\S+)', raw, re.MULTILINE)
    if m:
        story_id = m.group(1).strip()
    if not story_id:
        # Fallback: derive from filename STORY-S-X.XX-...
        fm = re.match(r'STORY-(S-[\d.]+)-', filename)
        story_id = fm.group(1) if fm else filename

    story_citations = 0
    story_drift = 0
    story_advisory = 0

    # Pre-extract full AC block body for each citation header line.
    # CHECK 2 must scan the body text (not just the header) because error codes
    # asserted by an AC appear in the lines following the ### AC-NNN heading.
    raw_lines = raw.split('\n')
    _ac_body_cache = {}
    for _i, _rl in enumerate(raw_lines):
        if '### AC-' in _rl and 'traces to BC-' in _rl:
            _body = [_rl]
            _j = _i + 1
            while _j < len(raw_lines) and not re.match(r'^#{1,6} ', raw_lines[_j]):
                _body.append(raw_lines[_j])
                _j += 1
            _ac_body_cache[_rl] = '\n'.join(_body)

    for line in raw_lines:
        if 'traces to BC-' not in line:
            continue

        # ── Try NEW stable-tag form first (ADR-027 M2 dual-mode) ─────────────
        new_m = NEW_CITE_RE.search(line)
        if new_m:
            ac_id = new_m.group(1)                         # e.g. AC-001

            # Extract the full "(traces to ...)" content and resolve ALL clause
            # tokens.  Handles multi-clause shorthands:
            #   "BC-x TAG-a, TAG-b, TAG-c"   (BC inheritance)
            #   "BC-x TAG-a, BC-y TAG-b"     (explicit re-qualification)
            # Every (bc_id, tag_id) pair must resolve; trailing clauses that do
            # not resolve emit DRIFT with the same blocking semantics as the
            # first clause.  Preserves single-clause behavior unchanged.
            trace_m = _TRACE_CONTENT_RE.search(line)
            if trace_m:
                all_clauses = parse_all_trace_clauses(trace_m.group(1))
            else:
                all_clauses = []

            # Fallback: malformed or unparseable trace — reconstruct from regex
            if not all_clauses:
                tag_prefix0 = new_m.group(3).upper()
                tag_num0    = new_m.group(4).zfill(3)
                all_clauses = [(new_m.group(2), f"{tag_prefix0}-{tag_num0}")]

            total_citations += 1
            story_citations += 1

            ac_text_full = _ac_body_cache.get(line, line)

            # ── CHECK 1: resolve every (bc_id, tag_id) pair ──────────────────
            first_ok_bc  = None  # bc_id of first clause when CHECK 1 passes
            first_ok_tag = None  # tag_id of first clause when CHECK 1 passes
            first_ok_key = None  # section_key for CHECK 2

            for idx, (clause_bc_id, tag_id) in enumerate(all_clauses):
                tag_prefix = tag_id.split('-')[0]          # PC | INV | PRE | EC

                bc = load_bc(clause_bc_id)
                if bc is None:
                    print(f"DRIFT {story_id} {ac_id} cited={tag_id} "
                          f"reason=bc-file-missing bc={clause_bc_id}")
                    story_drift += 1
                    continue

                if tag_prefix == 'PC':
                    exists = tag_id in bc['pc_tags']
                    section_key = 'pc_section'
                elif tag_prefix == 'INV':
                    exists = tag_id in bc['inv_tags']
                    section_key = 'inv_section'
                elif tag_prefix == 'PRE':
                    exists = tag_id in bc['pre_tags']
                    section_key = 'pre_section'
                else:  # EC
                    exists = tag_id in bc['ec_ids']
                    section_key = 'ec_section'

                if not exists:
                    print(f"DRIFT {story_id} {ac_id} cited={tag_id} "
                          f"reason=nonexistent bc={clause_bc_id}")
                    story_drift += 1
                    continue

                if idx == 0:
                    first_ok_bc  = clause_bc_id
                    first_ok_tag = tag_id
                    first_ok_key = section_key

            # ── CHECK 2: error-code co-location on first clause (advisory) ───
            if first_ok_bc is not None:
                ac_codes = ERRCODE_RE.findall(ac_text_full)
                if ac_codes:
                    bc = load_bc(first_ok_bc)
                    if bc is not None:
                        first_ok_prefix = first_ok_tag.split('-')[0]
                        if first_ok_prefix in ('PC', 'INV', 'PRE'):
                            item_text = get_item_text_by_tag(bc[first_ok_key], first_ok_tag)
                        else:
                            item_text = get_item_text(bc['ec_section'], 'edge_case', first_ok_tag)
                        if item_text:
                            for code in ac_codes:
                                if code not in item_text:
                                    print(f"ADVISORY {story_id} {ac_id} cited={first_ok_tag} "
                                          f"reason=code-absent asserted-code={code} bc={first_ok_bc}")
                                    story_advisory += 1
                                    break  # one ADVISORY per AC

            continue  # new-form citation fully processed; do not fall through

        # ── M4 STRICT: old ordinal form → BLOCKING DRIFT (mixed-form-anchor) ───
        m = OLD_CITE_RE.search(line)
        if m:
            ac_id   = m.group(1)   # e.g. AC-001
            bc_id   = m.group(2)   # e.g. BC-2.08.006
            sec_raw = m.group(3).lower().replace(' ', '_')
            detail  = (m.group(4) or '').strip()
            cited_form = f"{sec_raw}_{detail}" if detail else sec_raw
            total_citations += 1
            story_citations += 1
            print(f"DRIFT {story_id} {ac_id} cited={cited_form} "
                  f"reason=mixed-form-anchor bc={bc_id}")
            story_drift += 1
            continue

    per_story_counts[story_id] = (story_citations, story_drift, story_advisory)
    if story_drift > 0:
        pass  # tally below

# ── Per-story summary ─────────────────────────────────────────────────────────
stories_with_drift = sum(1 for s, (c, d, a) in per_story_counts.items() if d > 0)
total_advisory = sum(a for s, (c, d, a) in per_story_counts.items())

print(f"SUMMARY total_citations={total_citations} stories_checked={len(per_story_counts)} stories_with_drift={stories_with_drift} total_advisory={total_advisory}")
for sid in sorted(per_story_counts):
    c, d, a = per_story_counts[sid]
    status = 'PASS' if d == 0 else 'FAIL'
    print(f"STORY_RESULT {sid} {status} citations={c} drift={d} advisory={a}")

PYEOF
)"

# ── Process Python3 output ────────────────────────────────────────────────────

TOTAL_CITATIONS=0
TOTAL_STORIES_CHECKED=0
STORIES_WITH_DRIFT=0
DRIFT=0
ADVISORY_COUNT=0

while IFS= read -r line; do
  case "$line" in
    DRIFT*)
      echo "$line"
      DRIFT=$((DRIFT + 1))
      ;;
    ADVISORY*)
      echo "$line"
      ADVISORY_COUNT=$((ADVISORY_COUNT + 1))
      ;;
    SUMMARY*)
      TOTAL_CITATIONS=$(echo "$line" | grep -oE 'total_citations=[0-9]+' | cut -d= -f2)
      TOTAL_STORIES_CHECKED=$(echo "$line" | grep -oE 'stories_checked=[0-9]+' | cut -d= -f2)
      STORIES_WITH_DRIFT=$(echo "$line" | grep -oE 'stories_with_drift=[0-9]+' | cut -d= -f2)
      ;;
    STORY_RESULT*)
      # e.g. STORY_RESULT S-1.01 PASS citations=10 drift=0
      story_id=$(echo "$line" | awk '{print $2}')
      status=$(echo "$line" | awk '{print $3}')
      details=$(echo "$line" | cut -d' ' -f4-)
      echo "  $status $story_id $details"
      ;;
  esac
done <<< "$PYTHON_OUTPUT"

# ── Summary ───────────────────────────────────────────────────────────────────

echo ""
echo "verify-ac-pc-trace: checked $TOTAL_CITATIONS citations across $TOTAL_STORIES_CHECKED stories"
echo ""
echo "M4 strict citation enforcement (ADR-027 Decision-4):"
echo "  REQUIRED stable-tag form: AC cites BC-S.SS.NNN PC-NNN / INV-NNN / PRE-NNN / EC-NNN"
echo "    CHECK 1 resolves by grepping {TAG} token in the BC section."
echo "  FORBIDDEN old ordinal form: postcondition N / invariant N / precondition N"
echo "    Old-form citations → DRIFT reason=mixed-form-anchor (migration window closed)."
echo ""
echo "Checks implemented:"
echo "  CHECK 1 (BLOCKING): Existence — cited PC/INV/EC/PRE tag must exist in the referenced BC"
echo "           reason=nonexistent | reason=bc-file-missing | reason=mixed-form-anchor -> DRIFT -> exits 1"
echo "  CHECK 2 (ADVISORY): Error-code co-location — E-XXX-NNN asserted in AC must appear in cited item"
echo "           reason=code-absent -> ADVISORY line -> does not block (heuristic; codes may appear"
echo "           in ACs as examples/table-rows/contrast without implying the cited item contains them)"
echo "  CHECK 3: Keyword-overlap heuristic (suppressed — reserved for future use)"
echo "           reason=low-overlap (not emitted)"
echo ""
echo "Per-story pass/fail above."
echo ""
echo "CHECK-1 (blocking) drift: $DRIFT"
echo "CHECK-2 (advisory) hints: $ADVISORY_COUNT"
echo ""
if [ "$DRIFT" -gt 0 ]; then
  echo "RESULT: FAIL ($DRIFT blocking drift citations across $STORIES_WITH_DRIFT stories)"
  exit 1
else
  echo "RESULT: PASS (CHECK-1 drift=0; CHECK-2 advisory hints=$ADVISORY_COUNT)"
  exit 0
fi
