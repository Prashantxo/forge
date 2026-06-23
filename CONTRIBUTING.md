# Contributing to Forge

## Ways to contribute

- New skill (`skills/<name>/`)
- New slash command (`commands/<name>.md`)
- Bug fix in existing skill
- Documentation improvement

## Setup

```bash
git clone https://github.com/Prashantxo/forge
cd forge
claude plugin validate
```

No dependencies to install. Forge is pure prompt instructions + JSON config.

## Adding a skill

**Required files:**

```
skills/<name>/SKILL.md
skills/<name>/agents/openai.yaml
```

**SKILL.md structure:**
```markdown
---
name: <name>
description: One sentence. Triggers on X. Does Y.
allowed-tools: Read, Grep, Glob
---

# forge:<name>

> Source rules/model-adapter.md for tier.

## Checklist
| Category | Checks |
...

## Output
...
```

**agents/openai.yaml structure:**
```yaml
interface:
  display_name: "Forge <Name>"
  short_description: "One sentence for Codex/OpenAI context."
  brand_color: "#RRGGBB"
  default_prompt: "Use $<name> to <action>."
policy:
  allow_implicit_invocation: true
```

## Adding a slash command

```
commands/<name>.md
```

Reference `rules/model-adapter.md` at the top. Define phases clearly. Use the severity table pattern from existing commands.

## PR checklist

- [ ] `claude plugin validate` passes
- [ ] New skill has both `SKILL.md` and `agents/openai.yaml`
- [ ] No hardcoded model names or API keys
- [ ] Output format uses severity labels: CRITICAL / HIGH / MEDIUM / LOW
- [ ] One skill or command per PR

## Coding standards

- Kebab-case file and directory names
- Table-first skill structure (checklist before prose)
- `> Source rules/model-adapter.md` at top of every skill
- No `any` types, no untyped returns (for any TypeScript tooling)
- Error messages: what failed, with what input, why

## Questions

Open an issue before building a large skill — saves time on direction mismatch.
