# Forge Model Adapter

Every command sources this file and scales output to the active model's capability.
Works with any model: cloud (Claude, GPT, Gemini) or local (Gemma, Qwen, Kimi, Llama, Mistral, etc.).

## Tier detection

Forge does not identify models by name. Names change, new models appear.
Detect tier by capability signals instead:

| Signal | How to detect |
|--------|--------------|
| Context window | > 100k tokens → likely MAX or STANDARD |
| Reasoning depth | Can the model follow 5+ step chains reliably? → STANDARD or MAX |
| Speed / cost constraint | Explicitly set `FORGE_TIER=fast` in env → FAST |
| Explicit override | `FORGE_TIER=max|standard|fast` env var → use that |
| Unknown / local model | Default to STANDARD |

**Default when uncertain: STANDARD.**

## Tiers

| Tier | Capability class | When to use |
|------|-----------------|-------------|
| MAX | Frontier reasoning model | Deep analysis, complex architecture, long-form research |
| STANDARD | Mid-range model, strong reasoning | Daily dev work, default for all commands |
| FAST | Lightweight / constrained model | Quick checks, CI gates, low-latency use cases |

## Behavior per tier

### MAX
- Full phase sequence from the command
- Deep reasoning at each phase, exploring alternatives
- All optional checks included
- Verbose findings with root-cause analysis
- No token budget constraint

### STANDARD
- Full phase sequence
- One sentence of reasoning per finding
- Skip cosmetic/optional checks
- Structured output without elaboration
- Default for all Forge commands

### FAST
- Collapse to 3 phases: GATHER → ANALYZE → REPORT
- Bullet-only output, no prose
- CRITICAL and HIGH findings only
- Stay under 800 output tokens

## Quality guarantee

All tiers emit the same finding categories and severity labels.
FAST omits LOW/MEDIUM to stay within budget.
STANDARD omits verbose root-cause prose.
MAX produces the full report.

Output schema is identical across all tiers, so tooling can parse any tier's output.

## Local model notes

Local models (Gemma, Qwen, Kimi, Llama, Mistral, Phi, etc.) use STANDARD by default.
Set `FORGE_TIER=fast` if the model has a small context window or slow inference.
Forge commands are table-driven and low-prose, and work well on smaller models.
