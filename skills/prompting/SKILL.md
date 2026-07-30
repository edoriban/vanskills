---
name: prompting
description: >
  Prompt engineering and context engineering rules — how to word an instruction and how to decide which tokens exist at inference time.
  Trigger: When writing or revising a prompt, a skill, a CLAUDE.md, or a sub-agent brief; when deciding what context to load or drop.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Writing or revising a prompt, skill, CLAUDE.md, or sub-agent brief"
  dependencies:
    # - executing  # companion skill: verification and loop design
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## When to Use

- Writing or revising a prompt, system prompt, skill file, or CLAUDE.md.
- Writing a sub-agent brief or delegating work.
- Deciding which files, tool results, or history belong in the window.
- Diagnosing an agent that ignores instructions, drifts, or degrades late in a session.

For verification, loop design, and reviewer scaffolding, see [../executing/SKILL.md](../executing/SKILL.md).

---

## The Nesting

```
harness  ⊃  context  ⊃  prompt
```

- **Prompt engineering** owns one turn's instruction text.
- **Context engineering** owns which tokens exist at each inference — system prompt, tools, history, retrieved files, compaction.
- **Harness engineering** owns the non-token surfaces (tools, sandbox, hooks, verifiers). Out of scope here.

Context engineering is the superset: it is iterative curation, re-decided every turn, because the useful set of tokens changes as state accumulates.

---

## Precondition — Do Not Tune Yet

Do not touch prompt wording without all three:

1. **Success criteria** defined in advance (what "good" means, measurably).
2. **An empirical test** you can run against those criteria.
3. **A first draft** to test.

Without these you are guessing. Write the draft, build the test, then iterate.

---

## Prompt Rules

- **Be explicit.** State the task, the audience, the constraints, and the output shape. Do not assume shared context.
- **State WHY a requirement exists.** The reason lets the model generalize to adjacent choices you did not enumerate. `Use tabs, because the linter rejects spaces` beats `Use tabs`.
- **Say what TO do, not what NOT to do.** `Respond in flowing prose` beats `Don't use markdown`.
- **Show, don't tell.** Examples outperform description. Curate 3-5 **canonical** examples covering the normal shape of the task. Do not dump edge cases — a pile of exceptions teaches the exception, not the rule.
- **Specify output shape** concretely: format, length, sections, schema. If you want JSON, show the JSON.
- **Grant permission to abstain.** Add: `If the data is insufficient to answer, say so rather than speculating.` Hallucination is often an artifact of a prompt that left no acceptable "no" available.
- **Prefill** the start of the response to lock format (open brace, opening tag, first header).
- **Chain prompts** instead of building one mega-prompt. One task per call, output of each feeding the next. Easier to test, easier to locate the failure.
- **Order matters** for long inputs: put long documents first, the question last.
- **Ask the model to think** before answering when the task is multi-step; give it a place to do so.

---

## Context Rules

Goal: **the smallest set of high-signal tokens that maximize the likelihood of the desired outcome.**

- **Attention is a finite budget.** Attention cost is n² in sequence length; every token added dilutes the rest. Treat context as a scarce resource with diminishing marginal return, not a bucket to fill.
- **Context rot is real, and it is a cliff, not a slope.** Chroma measured **30-50% accuracy drops** well before documented context limits across **18 frontier models**, degrading as sharp cliffs rather than gradual decay. It gets worse with **distractors** present and with **low semantic similarity** between the needle and the question. Corollary: a task that works at 20k tokens can fail at 100k with the same model and the same prompt. Shrink the window before blaming the model.
- **Retrieve just in time.** Hold lightweight identifiers — file paths, queries, links, IDs — and load the content only when needed. Progressive disclosure: the agent discovers what it needs, when it needs it.
- **Curate tool results.** Raw tool output is the largest source of low-signal tokens. Summarize, filter, or paginate before it enters history.

### System-Prompt Altitude

Aim for the middle band: **specific enough to guide behavior, flexible enough to act as a heuristic.**

| Too low | Right altitude | Too high |
|---------|----------------|----------|
| Hardcoded if-else logic for every case | Clear heuristics + stated reasons | Vague prose assuming shared context |
| Brittle, breaks on the case you missed | Generalizes | Produces no specific behavior |

Structure with Markdown headers or XML tags. One concern per section: role, tools, output format, constraints.

### Minimal Viable Tool Set

Ship the fewest tools that cover the work, each with a self-contained description and unambiguous parameters.

> If engineers cannot definitively say which tool applies in a given situation, agents cannot either.

Overlapping tools are a decision tax paid on every turn. Merge or delete them.

---

## Managing a Long Session

### Compaction

When approaching the limit, compress the transcript. **Preserve:** architectural decisions, unresolved bugs, implementation details that are still load-bearing. **Discard:** redundant tool output, superseded file reads, resolved detours.

Tune compaction by maximizing recall of critical information first, then trimming redundancy.

### Structured Note-Taking

Write persistent state to external files — progress notes, decision logs, task lists — outside the window. Read them back on demand. This survives compaction; the transcript does not.

### Sub-Agents as Context Isolation

Spawn a sub-agent to do exploration in its own window; it returns a **distilled ~1-2k token summary** while the tens of thousands of tokens of search remain in its context, not yours. Use for wide searches, multi-file analysis, and anything whose intermediate steps you will never need again.

### Code Execution as Compression

Let the agent write code that calls tools and processes results in the execution environment, returning only the answer. Exposing MCP servers as a filesystem-style code API took one measured workflow from **~150k tokens to ~2k tokens** — a ~98.7% reduction — by keeping intermediate data out of the model's context.

---

## Anti-Patterns

- **The kitchen-sink session** — loading everything up front "so the model has what it needs". Dilutes attention and triggers context rot.
- **Correcting over and over** — each failed attempt stays in context; the model now reasons over a transcript that is mostly wrong approaches. Restart with a fresh context and a summary of what was learned.
- **The over-specified CLAUDE.md** — important rules get lost in the noise. Fewer, sharper rules are followed; long ones are skimmed.
- **The infinite exploration** — the agent reads and reads without converging. Bound exploration explicitly, then force a decision.

---

## Sub-Agent Brief Contract

Every delegation states four things. Missing any one is the most common cause of a useless sub-agent result.

1. **Objective** — the specific question or deliverable, not a topic.
2. **Output format** — shape, sections, length budget.
3. **Tool guidance** — which tools/sources to use, and how much effort (see effort scaling in [../executing/SKILL.md](../executing/SKILL.md)).
4. **State** — where to read prior context from, where to write results to.

```text
Objective: Determine whether the auth middleware validates token expiry.
Read: src/middleware/, tests/auth/
Output: Yes/no + file:line evidence + gaps found. Max 300 words.
Tools: Grep and Read only. Budget ~10 calls.
Write: append findings to notes/auth-audit.md
If the code is ambiguous, say so rather than guessing.
```

Sub-agents have no memory. Anything they need, you pass in or tell them where to fetch.

---

## Checklist

- [ ] Success criteria and a test exist before tuning wording.
- [ ] Requirements state their reason.
- [ ] Output shape shown, not described.
- [ ] Instructions phrased positively.
- [ ] Examples are canonical, not edge cases.
- [ ] Abstention is permitted explicitly.
- [ ] Every token in the window justifies its attention cost.
- [ ] Identifiers held instead of contents where possible.
- [ ] Tool set has no ambiguous overlap.
- [ ] Long-session state lives in files, not only in the transcript.
- [ ] Sub-agent briefs specify objective, format, tools, and state.

---

## Sources

- https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
- https://claude.com/blog/best-practices-for-prompt-engineering
- https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview
- https://code.claude.com/docs/en/best-practices
- https://research.trychroma.com/context-rot
- https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
