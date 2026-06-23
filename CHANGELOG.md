# Changelog

All notable changes follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versions follow [Semantic Versioning](https://semver.org/).

## [1.0.0] - 2026-06-24

### Added
- 8 slash commands: `/forge:review`, `/forge:secure`, `/forge:arch`, `/forge:tdd`, `/forge:docs`, `/forge:refine`, `/forge:eval`, `/forge:standards`
- 9 skills: `review`, `secure`, `arch`, `tdd`, `agentic`, `docs`, `refine`, `eval`, `standards`
- 3 agents: `forge-reviewer`, `forge-architect`, `forge-analyst`
- Model-adaptive tier routing via `rules/model-adapter.md`: MAX / STANDARD / FAST
- `FORGE_TIER` env var override
- Cross-platform support: Claude Code, Codex, Gemini CLI, Cursor, Windsurf, Zed, Kiro, Cline, Aider
- Hooks: destructive-command blocker, post-write secret scanner
- MCP config: GitHub + filesystem
- Each skill includes `agents/openai.yaml` for Codex cross-platform use
- CI pipeline: 6-job workflow validating all 9 platforms, structural tests, security scan, final gate
- 101-check test suite (`tests/validate-structure.sh`)
