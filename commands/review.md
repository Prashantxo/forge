---
name: forge:review
description: "Forge code review: local uncommitted changes or PR (pass PR number/URL)"
argument-hint: [pr-number | pr-url | blank for local]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(gh pr:*)
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS

---

## Mode

If $ARGUMENTS contains PR number, URL, or `--pr` → **PR Mode** (see below).
Else → **Local Mode**.

---

## Local Mode

### Phase 1: GATHER
```bash
git diff --name-only HEAD
git diff HEAD
```
No changed files → stop: "Nothing to review."

### Phase 2: CONTEXT
Read `CLAUDE.md` and `AGENTS.md` for project conventions.
Read each changed file in full, not just diff hunks.

### Phase 3: REVIEW
Apply `forge:review` and `forge:secure` skills.

| Category | Checks |
|----------|--------|
| Correctness | Logic errors, off-by-one, null handling, race conditions |
| Security | Hardcoded secrets, injection, auth gaps, XSS, SSRF |
| Performance | N+1, unbounded loops, blocking I/O, memory leaks |
| Type safety | `any`, unsafe casts, missing types |
| Tests | Missing coverage for new logic, mocks hiding real behavior |
| Standards | Matches project conventions in CLAUDE.md |

### Phase 4: VALIDATE
Detect project type from config files, run available checks:
```bash
# Node/TS
npm run typecheck 2>/dev/null; npm run lint 2>/dev/null; npm test 2>/dev/null
# Go
go vet ./... 2>/dev/null; go test ./... 2>/dev/null
# Python
pytest 2>/dev/null
# Rust
cargo clippy 2>/dev/null; cargo test 2>/dev/null
```

### Phase 5: REPORT

```
FORGE REVIEW — <date>
=====================
Decision: BLOCK | REQUEST CHANGES | APPROVE WITH NOTES | APPROVE

CRITICAL: N  HIGH: N  MEDIUM: N  LOW: N

[SEVERITY] file:line - Title
Problem: ...
Fix: ...

Validation: typecheck=PASS|FAIL  lint=PASS|FAIL  tests=PASS|FAIL
```

---

## PR Mode

### Phase 1: FETCH
```bash
gh pr view <NUMBER> --json number,title,body,author,baseRefName,headRefName
gh pr diff <NUMBER>
```

### Phase 2: CONTEXT
Read CLAUDE.md, AGENTS.md, and PR description for intent.

### Phase 3: REVIEW
Same 6-category checklist as local mode.
Read full file contents at PR head, not just diff hunks.

### Phase 4: VALIDATE
Run same project-type detection and validation commands.

### Phase 5: DECIDE
| Condition | Decision |
|-----------|----------|
| No CRITICAL/HIGH, validation passes | APPROVE |
| Only MEDIUM/LOW, validation passes | APPROVE WITH NOTES |
| Any HIGH or validation fail | REQUEST CHANGES |
| Any CRITICAL | BLOCK |
| Draft PR | COMMENT only |

### Phase 6: PUBLISH
```bash
gh pr review <NUMBER> --approve|--request-changes|--comment --body "<summary>"
```

### Phase 7: ARTIFACT
Save to `.claude/reviews/pr-<NUMBER>-review.md`.

---

## Severity

| Level | Meaning |
|-------|---------|
| CRITICAL | Security vuln or data loss. Must fix. |
| HIGH | Bug likely to cause issues. Should fix. |
| MEDIUM | Quality issue, recommended |
| LOW | Style nit, optional |
