# Forge for Gemini CLI

Model-adaptive AI coding toolkit. Skills auto-load from `skills/`.

## Core workflow

1. Tests before code — use `forge:tdd`
2. Review before merge — use `forge:review`
3. Security scan before release — use `forge:secure`
4. Evals before any LLM feature change — use `forge:eval`

## Standards

- Strong typing. No `any`.
- Structured logging with trace IDs.
- No hardcoded secrets — use environment variables.
- Validate all user input at system boundaries.
