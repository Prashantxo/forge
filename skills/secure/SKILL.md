---
name: secure
description: Security audit. Triggers on /forge:secure or code touching auth, inputs, APIs, payments, secrets. OWASP Top 10 plus supply chain.
allowed-tools: Read, Grep, Glob, Bash(npm audit:*), Bash(pip-audit:*)
---

# forge:secure

## Threat model (state before scanning)
1. Assets at risk  2. Trust boundaries  3. Likely attacker

## Scan checklist

| Class | Signal |
|-------|--------|
| Secrets | sk-, AKIA, BEGIN PRIVATE KEY, password= in source |
| SQLi | String concat in queries, raw db.query with user input |
| CMDi | exec( or subprocess with user input |
| Path traversal | ../ in file ops, unvalidated upload paths |
| Auth | IDOR no ownership check, JWT alg:none, insecure cookies |
| Crypto | MD5/SHA1 for passwords, ECB mode, Math.random for tokens |
| Input | No schema at API boundary, file upload no type+size check |
| Supply chain | Unpinned deps, open npm audit / pip-audit vulns |
| Headers | Missing CSP, HSTS, X-Frame-Options |

## Output

```
[CRITICAL|HIGH|MEDIUM|LOW] Class - Title
File: path:line
Impact: what attacker achieves
Fix: concrete remediation

Remediation order: 1. highest impact  2. ...
```
