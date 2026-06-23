---
name: forge:secure
description: "Forge security audit: OWASP Top 10 scan on changed files or a specified path"
argument-hint: [file-path | blank for changed files]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(npm audit:*), Bash(pip-audit:*)
---

> Read rules/model-adapter.md and select tier before starting.

**Input**: $ARGUMENTS (optional path to audit)

---

### Phase 1: SCOPE
```bash
# If $ARGUMENTS given: audit that path
# Else: audit changed files
git diff --name-only HEAD
```

### Phase 2: THREAT MODEL
State before scanning:
1. Assets at risk (data, auth, payments, infra)
2. Trust boundaries in the code
3. Likely attacker (external, insider, supply chain)

### Phase 3: SCAN
Apply `forge:secure` skill checklist:

| Class | What to check |
|-------|--------------|
| Secrets | Hardcoded keys, tokens, passwords (any pattern matching `sk-`, `AKIA`, `-----BEGIN`) |
| Injection | SQLi (string concat in queries), CMDi (exec with user input), SSTI, path traversal |
| Auth | Missing auth checks, JWT `alg:none`, no expiry, IDOR (object refs without ownership) |
| Crypto | MD5/SHA1 for passwords, ECB mode, reused IV, weak RNG for security values |
| Input | Missing validation at system boundaries, file upload without type+size check |
| Supply chain | Unpinned deps, `npm audit` / `pip-audit` results |
| Headers | Missing CSP, X-Frame-Options, HSTS |

Run dependency scanner:
```bash
npm audit --json 2>/dev/null | head -50
pip-audit 2>/dev/null | head -30
```

### Phase 4: REPORT

```
FORGE SECURE — <date>
=====================
Target: <files or path>
Threat model: <1-line summary>

[CRITICAL|HIGH|MEDIUM|LOW] Class - Title
File: path:line
Impact: what attacker achieves
Fix: concrete remediation

Dependency vulns: N critical, N high (run `npm audit fix` or update pinned versions)

Remediation order:
1. <highest impact fix first>
```

No CRITICAL/HIGH → `CLEAN: no high-severity issues found`.
