---
name: eval
description: Eval-driven development for AI features. Triggers on /forge:eval or when any LLM-powered feature, prompt, or agent changes. Define pass/fail before implementing.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# forge:eval

## Workflow

| Phase | Action | Gate |
|-------|--------|------|
| DEFINE | Write eval spec before any code | **STOP: show user, wait for approval** |
| IMPLEMENT | Write code/prompts to pass the spec | n/a |
| GRADE | Run graders, measure pass@k | n/a |
| REPORT | Compare to baseline, flag regressions | Block on any regression |

## Eval spec format

```markdown
## EVAL: <feature-name>
### Capability
- [ ] <what must succeed>
### Regression
- [ ] <existing behavior that must not break>
### Metrics
- Capability: pass@3 > 90%
- Regression: pass^3 = 100%
```
Save at `.claude/evals/<feature-name>.md`.

## Grader types

| Output | Grader | Example |
|--------|--------|---------|
| Deterministic | Code (bash) | `npm test && echo PASS \|\| echo FAIL` |
| Open-ended | Model prompt | Rate 1-3: solves problem / correct format / handles edges |

## Metrics

| Metric | Meaning | Target |
|--------|---------|--------|
| pass@1 | First-attempt success | > 70% |
| pass@3 | At least 1 success in 3 | > 90% |
| pass^3 | All 3 succeed | 100% on critical paths |

## Report format

```
FORGE EVAL — <date>
Feature       Capability    Regression    Status
<name>        X/Y (N%)      X/Y (N%)      PASS|FAIL|REGRESSED
Baseline delta: <vs last run>
```
