# Forge

AI coding toolkit for Claude Code. Installable as a Claude Code plugin.

## Install

```bash
npx claudepluginhub install forge
claude plugin install <your-github-username>/forge
```

## Commands

| Command | What It Does |
|---------|-------------|
| `/forge:review` | Code + security review on current diff or PR |
| `/forge:secure` | OWASP Top 10 security audit |
| `/forge:arch` | Architecture review or design |
| `/forge:tdd` | TDD cycle: failing tests first |
| `/forge:docs` | Generate documentation |
| `/forge:refine` | Simplify changed code without behavior change |
| `/forge:eval` | Define or run evals for AI features |
| `/forge:standards` | Coding standards review |

## Skills

`review` `secure` `arch` `tdd` `agentic` `docs` `refine` `eval` `standards`

Each skill has `agents/openai.yaml` for Codex/OpenAI cross-platform use.

## Agents

`forge-reviewer` `forge-architect` `forge-analyst`

## Principles

1. Tests before code: no feature without a failing test first.
2. Evals before LLM changes: define pass/fail criteria before touching prompts.
3. Plan before implementation: no code without a design.
4. Prefer MCP over custom integrations.
5. Prefer agents over giant context windows.
6. Security review before every release.
7. Never hardcode secrets: use environment variables.
8. Observability built in: structured logs, trace IDs from day one.

## Workflow

```
DISCOVER → DESIGN → TEST (failing) → IMPLEMENT → EVAL → REVIEW → REFINE → DOCS → RELEASE
```

## Coding Standards

- Strong typing: no `any`, no untyped returns
- Kebab-case for files and directories
- One responsibility per module
- Structured logging with trace IDs
- Error messages carry context: what failed, with what input, why

## Plugin Development

```
skills/<name>/SKILL.md              # skill instructions
skills/<name>/agents/openai.yaml    # cross-platform metadata
agents/forge-<name>.md              # agent definition
commands/<name>.md                  # slash command
```

Validate: `claude plugin validate .`

## Environment Variables

| Variable | Used By | Purpose |
|----------|---------|---------|
| `GITHUB_TOKEN` | MCP github server | GitHub API access |
| `FORGE_TIER` | All commands | Override model tier: `max`, `standard`, `fast` |

---

## Local Development

### Running tests

```bash
bash tests/validate-structure.sh
```

Must pass 101/101 before any commit. Run from repo root.

### Validate plugin manifest

```bash
claude plugin validate .
```

Run before every release. The CI job for this is best-effort (CLI auth is
flaky in headless CI), local validation is authoritative.

### Git setup

- Working branch: `fresh-main`
- Remote: `https://github.com/Prashantxo/Forge.git`
- Push: `git push origin fresh-main:main`
- **All commits must use author `Prashant Tomar <mythd2000@gmail.com>`**
  ```bash
  git commit --author="Prashant Tomar <mythd2000@gmail.com>" -m "..."
  ```
  Never commit as Claude Code or any other author.

### Secrets / tokens

- `.claude/settings.local.json` is gitignored. It holds session-scoped
  tokens and must never be committed.
- GitHub tokens shared in chat should be revoked immediately after use.
- The `gh` CLI uses an OAuth token (`gho_`) that has `repo` + `workflow`
  scopes but not `contents:write`, so it cannot create GitHub releases.
  Create releases manually at https://github.com/Prashantxo/Forge/releases/new
  or refresh auth: `gh auth refresh -h github.com -s write:packages,contents`

### Release process

1. Update `CHANGELOG.md` with a new `## [x.y.z] - YYYY-MM-DD` section at the top.
2. Run `bash tests/validate-structure.sh`. Must be 0 failures.
3. Run `claude plugin validate .`. Must pass.
4. Commit with correct author.
5. Push: `git push origin fresh-main:main`
6. Tag: `git tag vX.Y.Z && git push origin vX.Y.Z`
7. Create release at https://github.com/Prashantxo/Forge/releases/new:
   - Tag: `vX.Y.Z` (already pushed)
   - Title: `vX.Y.Z - <one-line summary>`
   - Body: what changed, security fixes, upgrade instructions
8. Bump `version` in `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json`.

### Versioning

Follows [Semantic Versioning](https://semver.org/):
- `PATCH` (x.y.Z): bug fixes, CI fixes, doc corrections
- `MINOR` (x.Y.0): new skill, command, or agent; backward-compatible
- `MAJOR` (X.0.0): breaking change to plugin format or skill API

### CI pipeline structure

6 jobs in `.github/workflows/ci.yml`:

| Job | Depends on | Blocks merge |
|-----|-----------|-------------|
| `validate-json` | n/a | Yes |
| `security-check` | n/a | Yes |
| `test-structure` | `validate-json` | Yes |
| `validate-platforms` | `validate-json` | Yes |
| `validate-content` | `validate-json` | Yes |
| `validate-claude-plugin` | `validate-json` | No (best-effort) |
| `ci-gate` | all above except plugin | Yes, branch protection target |

For branch protection: require **`CI gate (all required checks)`** to pass.

### Platform files

Each AI editor reads different config. All must be kept in sync:

| Editor | Files |
|--------|-------|
| Claude Code | `.claude-plugin/plugin.json`, `CLAUDE.md`, `hooks/hooks.json` |
| OpenAI Codex | `.codex-plugin/plugin.json`, `AGENTS.md` |
| Gemini CLI | `.gemini/GEMINI.md` |
| Cursor | `.cursor/hooks.json` |
| Windsurf | `.windsurfrules`, `.windsurf/rules/forge.md` (needs `trigger:`) |
| Zed | `.rules` |
| Kiro | `.kiro/steering/forge.md` (needs `inclusion:`), `.kiro/hooks/` |
| Cline | `.clinerules/forge.md`, `.clinerules/hooks/PreToolUse` + `PostToolUse` |
| Aider | `.aider.conf.yml` |

`AGENTS.md` is the cross-platform fallback. Codex, Zed, Aider, and Cline
all read it. Keep it accurate.

### Security constraints for hook scripts

- All `.sh` files must have `#!/usr/bin/env bash` shebang.
- `post-write-validate.sh` must `exit 1` (not 0) when a secret is detected.
- Hook scripts must not be world-writable (checked by CI).
- Never interpolate user-controlled strings into `python3 -c "..."`. Pass
  file paths as arguments or via stdin.

### What the test suite checks (101 checks)

- All platform config files exist
- All 8 commands, 9 skills, 3 agents present
- All SKILL.md files have `name:`, `description:`, `allowed-tools:` frontmatter
- All `openai.yaml` files have `interface:` and `policy:` blocks
- All JSON files are valid
- All hook scripts have shebangs
- No hardcoded secrets (patterns: `sk-`, `AKIA`, `ghp_`)
- Verdict enum `BLOCK | REQUEST CHANGES | APPROVE WITH NOTES | APPROVE` consistent
  across `skills/review/SKILL.md`, `commands/review.md`, `agents/forge-reviewer.md`
- No stale `> Source rules/model-adapter.md` lines in skill files
