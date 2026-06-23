# Security Policy

## Supported Versions

| Version | Supported |
|---------|-----------|
| 1.x     | Yes       |

## Reporting a Vulnerability

**Do not open a public issue for security vulnerabilities.**

Report vulnerabilities privately via GitHub Security Advisories:
1. Go to `https://github.com/Prashantxo/forge/security/advisories`
2. Click **New draft security advisory**
3. Describe the vulnerability, steps to reproduce, and impact

You will receive a response within 48 hours. If confirmed, a fix will be released within 7 days for critical issues.

## Scope

- Prompt injection via skill or command files
- Hook bypass patterns that allow destructive commands to execute
- Secret leakage via hook scripts or plugin config
- MCP server configuration that exposes sensitive file paths

## Out of Scope

- The AI model's own behavior (report to Anthropic)
- Issues in third-party MCP servers (`@modelcontextprotocol/*`)
