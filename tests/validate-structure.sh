#!/usr/bin/env bash
# Forge structural test suite
# Run from repo root: bash tests/validate-structure.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PASS=0
FAIL=0
ERRORS=()

pass() {
  PASS=$((PASS + 1))
  echo "  ✓  $1"
}

fail() {
  FAIL=$((FAIL + 1))
  ERRORS+=("$1")
  echo "  ✗  $1"
}

check_file() {
  if [ -f "$1" ]; then
    pass "$1"
  else
    fail "$1 — file missing"
  fi
}


header() {
  echo ""
  echo "── $1"
}

echo ""
echo "┌─────────────────────────────────┐"
echo "│   Forge Test Suite              │"
echo "└─────────────────────────────────┘"

# ── Platform files ──────────────────────────────────────────
header "Platform files"
check_file ".claude-plugin/plugin.json"
check_file ".codex-plugin/plugin.json"
check_file ".gemini/GEMINI.md"
check_file ".cursor/hooks.json"
check_file ".windsurfrules"
check_file ".windsurf/rules/forge.md"
check_file ".rules"
check_file ".kiro/steering/forge.md"
check_file ".clinerules/forge.md"
check_file ".aider.conf.yml"
check_file "AGENTS.md"
check_file "CLAUDE.md"

# ── Hooks ────────────────────────────────────────────────────
header "Hooks"
check_file "hooks/hooks.json"
check_file "hooks/scripts/bash-safety-check.sh"
check_file "hooks/scripts/post-write-validate.sh"
check_file ".kiro/hooks/pre-tool-use.sh"
check_file ".kiro/hooks/post-tool-use.sh"
check_file ".clinerules/hooks/PreToolUse"
check_file ".clinerules/hooks/PostToolUse"

# ── Commands ─────────────────────────────────────────────────
header "Commands (8 required)"
for cmd in review secure arch tdd docs refine eval standards; do
  check_file "commands/$cmd.md"
done

# ── Skills ───────────────────────────────────────────────────
header "Skills (9 required)"
for skill in review secure arch tdd agentic docs refine eval standards; do
  check_file "skills/$skill/SKILL.md"
  check_file "skills/$skill/agents/openai.yaml"
done

# ── Agents ───────────────────────────────────────────────────
header "Agents (3 required)"
for agent in forge-reviewer forge-architect forge-analyst; do
  check_file "agents/$agent.md"
done

# ── Repo governance files ────────────────────────────────────
header "Repo files"
check_file "README.md"
check_file "CONTRIBUTING.md"
check_file "CHANGELOG.md"
check_file "SECURITY.md"
check_file "LICENSE"
check_file "llms.txt"
check_file "rules/model-adapter.md"
check_file ".gitignore"
check_file ".gitattributes"
check_file ".github/workflows/ci.yml"
check_file ".github/ISSUE_TEMPLATE/bug_report.md"
check_file ".github/ISSUE_TEMPLATE/skill_request.md"
check_file ".github/PULL_REQUEST_TEMPLATE.md"

# ── JSON validity ─────────────────────────────────────────────
header "JSON validity"
# Find real Python (skip the Windows Store stub that prints an error and exits 9009)
PY=""
for _py in python3 python; do
  _bin=$(command -v "$_py" 2>/dev/null) || continue
  "$_bin" -c "import sys; sys.exit(0)" 2>/dev/null && PY="$_bin" && break
done
if [ -z "$PY" ]; then
  fail "python not found — skipping JSON validation"
else
  for f in \
    .claude-plugin/plugin.json \
    .codex-plugin/plugin.json \
    .mcp.json \
    hooks/hooks.json \
    .cursor/hooks.json; do
    if "$PY" -m json.tool "$f" > /dev/null 2>&1; then
      pass "$f is valid JSON"
    else
      fail "$f is invalid JSON"
    fi
  done
fi

# ── YAML validity ─────────────────────────────────────────────
header "YAML structure (interface + policy blocks)"
for skill in review secure arch tdd agentic docs refine eval standards; do
  f="skills/$skill/agents/openai.yaml"
  if grep -q "interface:" "$f" && grep -q "policy:" "$f"; then
    pass "skills/$skill/agents/openai.yaml"
  else
    fail "skills/$skill/agents/openai.yaml — missing interface: or policy: block"
  fi
done

# ── Skill frontmatter ─────────────────────────────────────────
header "Skill frontmatter (name, description, allowed-tools)"
for skill in review secure arch tdd agentic docs refine eval standards; do
  f="skills/$skill/SKILL.md"
  if grep -q "^name:" "$f" && grep -q "^description:" "$f" && grep -q "^allowed-tools:" "$f"; then
    pass "skills/$skill/SKILL.md"
  else
    fail "skills/$skill/SKILL.md — missing name/description/allowed-tools"
  fi
done

# ── Command frontmatter ───────────────────────────────────────
header "Command frontmatter (name, description, allowed-tools)"
for cmd in review secure arch tdd docs refine eval standards; do
  f="commands/$cmd.md"
  if grep -q "^name:" "$f" && grep -q "^description:" "$f" && grep -q "^allowed-tools:" "$f"; then
    pass "commands/$cmd.md"
  else
    fail "commands/$cmd.md — missing frontmatter fields"
  fi
done

# ── Hook shebangs ─────────────────────────────────────────────
header "Hook scripts have shebangs"
for f in \
  hooks/scripts/bash-safety-check.sh \
  hooks/scripts/post-write-validate.sh \
  .kiro/hooks/pre-tool-use.sh \
  .kiro/hooks/post-tool-use.sh; do
  if head -1 "$f" | grep -q "^#!"; then
    pass "$f"
  else
    fail "$f — missing shebang"
  fi
done

# ── No hardcoded secrets ──────────────────────────────────────
header "No hardcoded secrets"
if grep -rqE "(sk-[a-zA-Z0-9]{20,}|AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{10,})" \
  --include="*.json" --include="*.md" --include="*.sh" --include="*.yaml" --include="*.yml" \
  --exclude-dir=".git" --exclude-dir=".claude" . 2>/dev/null; then
  fail "Hardcoded secret pattern detected"
else
  pass "No hardcoded secrets"
fi

# ── Verdict enum consistency ──────────────────────────────────
header "Verdict enum consistency"
VERDICT="BLOCK | REQUEST CHANGES | APPROVE WITH NOTES | APPROVE"
for f in "skills/review/SKILL.md" "commands/review.md" "agents/forge-reviewer.md"; do
  if grep -q "$VERDICT" "$f"; then
    pass "$f verdict enum consistent"
  else
    fail "$f verdict enum mismatch or missing"
  fi
done

# ── No stale model-adapter lines in skills ────────────────────
header "No stale model-adapter lines in skill files"
STALE=0
for skill in review secure arch tdd agentic docs refine eval standards; do
  f="skills/$skill/SKILL.md"
  if grep -q "Source rules/model-adapter.md" "$f" 2>/dev/null; then
    fail "skills/$skill/SKILL.md — stale model-adapter line (should only be in agent files)"
    STALE=$((STALE + 1))
  fi
done
if [ $STALE -eq 0 ]; then
  pass "No stale model-adapter lines in skill files"
fi

# ── Summary ───────────────────────────────────────────────────
echo ""
echo "┌─────────────────────────────────┐"
printf  "│  ✓ %-5s passed   ✗ %-5s failed │\n" "$PASS" "$FAIL"
echo "└─────────────────────────────────┘"

if [ ${#ERRORS[@]} -gt 0 ]; then
  echo ""
  echo "Failures:"
  for e in "${ERRORS[@]}"; do
    echo "  - $e"
  done
  echo ""
  exit 1
fi

echo ""
echo "All tests passed."
exit 0
