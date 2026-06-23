---
name: forge:arch
description: Forge architecture review or design. Pass a description to design new system; blank to review existing.
argument-hint: [system description | blank to review existing]
allowed-tools: Read, Grep, Glob
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS

---

## Mode
$ARGUMENTS is blank → **Review** existing system.
$ARGUMENTS has text → **Design** new system from description.

---

## Review Mode

### Phase 1: READ
Read in order: entry points, config files, DB schema, API layer, service boundaries.
Use Glob patterns: `**/*.json`, `**/*.yaml`, `**/*.toml` (excluding node_modules).

### Phase 2: MAP
Produce ASCII component diagram:
```
[Client] → [API Layer] → [Service] → [DB]
                       ↘ [Cache]
                       ↘ [Queue] → [Worker]
```

### Phase 3: ANALYZE
| Dimension | What to assess |
|-----------|---------------|
| Scalability | Horizontal scale paths, stateless vs stateful, sharding |
| Reliability | SPOFs, retry logic, circuit breakers, graceful degradation |
| Consistency | CAP tradeoffs, distributed transaction boundaries, idempotency |
| Observability | Structured logs, distributed traces, RED metrics, SLO alerting |
| Security | Zero-trust posture, service auth, least-privilege IAM, secrets mgmt |
| Operations | Deployment complexity, blast radius, rollback strategy |

### Phase 4: ADRs
List decisions worth formalizing. Template:
```markdown
## ADR-NNN: <Title>
Status: Proposed
Context: <why this decision was forced>
Decision: <what was chosen>
Consequences: <what gets better/worse>
```

### Phase 5: VERDICT
`GREENLIGHT` | `PROCEED WITH CHANGES` | `REDESIGN REQUIRED`

---

## Design Mode

### Phase 1: REQUIREMENTS
Parse $ARGUMENTS. Extract:
- Core capabilities needed
- Scale targets (RPS, data volume, latency SLO)
- Consistency requirements
- Team constraints

### Phase 2: DESIGN
Propose architecture with ASCII diagram.
Show 2 alternatives for the highest-stakes decision with tradeoff table.

### Phase 3: OPEN QUESTIONS
List what must be decided before implementation.

### Phase 4: NEXT STEPS
Numbered implementation order with dependencies.
