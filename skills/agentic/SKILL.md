---
name: agentic
description: AI/LLM engineering patterns. Triggers when building agents, prompts, MCP servers, evals, or RAG. Model selection, caching, tool design, multi-agent orchestration.
allowed-tools: Read, Grep, Glob
---

# forge:agentic

## Model selection by capability

Don't pick by name. Pick by what the task needs. Names change; capabilities don't.

| Task | Capability needed | Why |
|------|-----------------|-----|
| Complex reasoning, code gen | MAX tier | Needs deep multi-step reasoning |
| High-volume classification, triage | FAST tier | Throughput over depth |
| Structured extraction | Any + tool use | Schema enforced by tool, not model |
| Long document analysis | STANDARD+ with large context | Context window is the constraint |
| Real-time / streaming response | FAST tier | Latency is the constraint |
| Adversarial verification | MAX tier | Needs strong self-critique |

For local models: start at STANDARD. Drop to FAST if context window < 32k or inference is slow.

## Prompt template (4 required fields)

```
## Role         specific grounded persona with domain expertise
## Task         exact outcome required, not vague instructions
## Constraints  hard limits, what NOT to do
## Output Format schema or example, never leave format ambiguous
```

Anti-patterns: "be helpful", "do your best", giant unstructured system prompts.

## MCP tool rules

| Rule | Detail |
|------|--------|
| Idempotent | Safe to retry without side effects |
| Schema first | description + JSON Schema on every tool |
| Structured errors | {error, code}, not raw stack traces |
| Minimal scope | Only permissions the tool actually needs |

## Cost optimization

| Technique | Saving |
|-----------|--------|
| Prompt caching on stable system prompts | ~90% on repeated calls |
| Batch API for non-real-time work | ~50% |
| Capability routing: FAST for triage, MAX for depth | 60-80% |
| Context compression on long sessions | Reduces input tokens |

## Multi-agent pattern

```
Orchestrator
├── Researcher  (read-only, Explore agent)
├── Implementer (write, isolated worktree)
└── Reviewer    (read-only, forge-reviewer)
```

Use `context: fork` for sub-agents that must not affect main context.
Use `isolation: worktree` for parallel file-writing agents.
