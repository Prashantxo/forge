---
name: forge:eval
description: "Forge eval-driven development: define evals before implementing AI features, track pass@k"
argument-hint: [feature name | blank to run existing evals]
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS (feature name, or blank to run existing evals)

---

## Mode
$ARGUMENTS is blank → **Run** existing evals in `.claude/evals/`.
$ARGUMENTS has text → **Define** new evals for that feature.

---

## Define Mode

### Phase 1: CRITERIA
Before any implementation, define:
```markdown
## EVAL: <feature-name>

### Capability Evals
- [ ] <what should succeed>
- [ ] <edge case>
- [ ] <failure mode that must be caught>

### Regression Evals
- [ ] <existing behavior that must not break>

### Metrics
- Capability target: pass@3 > 90%
- Regression target: pass^3 = 100%
```
Save to `.claude/evals/<feature-name>.md`.

**STOP. Show eval spec to user. Do not implement until approved.**

### Phase 2: GRADER SELECTION
| Output type | Grader |
|-------------|--------|
| Deterministic (file exists, test passes) | Code grader (bash) |
| Open-ended (quality, correctness) | Model grader (prompt below) |

Model grader prompt template:
```
Evaluate this output for <feature>:
1. Does it solve the stated problem? (yes/no)
2. Is the output format correct? (yes/no)
3. Are edge cases handled? (yes/no)
Score: N/3. Verdict: PASS|FAIL. Reason: [one sentence]
```

---

## Run Mode

### Phase 1: LOAD
Read all `.claude/evals/*.md` files.

### Phase 2: EXECUTE
Run code graders. For model graders, evaluate each against the template.

### Phase 3: REPORT

```
FORGE EVAL REPORT — <date>
===========================
Feature          Capability     Regression     Status
<name>           X/Y (N%)       X/Y (N%)       PASS|FAIL|REGRESSED

Baseline delta: <vs last run>
Action needed:
  - <any FAIL or REGRESSED items with owner>
```

Any regression → **block** the triggering change.
