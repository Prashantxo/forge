---
name: arch
description: Architecture review and design. Triggers on /forge:arch. Scalability, reliability, consistency, observability, security, ops.
allowed-tools: Read, Grep, Glob
---

# forge:arch

## Dimensions

| Dimension | Checks |
|-----------|--------|
| Scalability | Horizontal scale paths, stateless vs stateful, partitioning |
| Reliability | SPOFs, retry+backoff+jitter, circuit breakers |
| Consistency | CAP tradeoffs, distributed tx boundaries, idempotency |
| Observability | Structured logs, traces, RED metrics, SLO alerting |
| Security | Zero-trust, service auth, least-privilege IAM, secrets mgmt |
| Operations | Deploy complexity, blast radius, rollback, on-call burden |

## Output

```
System Summary: [1 paragraph]
Diagram: [ASCII components and data flows]
Findings: [SEVERITY] Dimension - Title
  Current / Problem / Recommendation / Tradeoff
ADRs: [decisions worth formalizing]
Verdict: GREENLIGHT | PROCEED WITH CHANGES | REDESIGN REQUIRED
```
