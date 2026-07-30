---
name: executing
description: >
  Harness, loop, and adversarial-verification rules — the scaffold and control flow that make an agent finish correctly.
  Trigger: When designing an agent loop, a verification gate, a multi-agent workflow, or deciding when a task is done.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Designing an agent loop, verification gate, or multi-agent workflow"
  dependencies:
    # - prompting  # companion skill: prompt and context engineering
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## When to Use

- Designing an agent loop or deciding its exit condition.
- Adding a verification gate, review agent, or test-driven check.
- Designing a multi-agent fan-out, or deciding not to.
- Deciding whether a task is actually done.
- Diagnosing an agent that loops forever, declares success falsely, or degrades with each retry.

For wording the reviewer prompt or the sub-agent brief, see [../prompting/SKILL.md](../prompting/SKILL.md).

---

## Agent = Model + Harness

The **harness** owns the non-token surfaces:

- Tools, and the shape of their **error messages** (the agent's primary feedback channel).
- Sandbox and permission boundaries.
- Hooks and deterministic interceptors.
- Observability: logs, traces, replayable trajectories.
- **Whether a verifier exists at all.**

The **loop** owns control flow: iterate, exit, escalate, budget, fan-out/fan-in.

### The Empirical Case

- The same model scored **45.9% vs 55.4%** on SWE-bench Pro under two different scaffolds.
- A 3×3 factorial (3 models × 3 harnesses) attributed **18.48 pp²** of variance to the harness vs **2.37 pp²** to the model — a **7.8×** gap — and model rankings **reversed in 6 of 9** pairwise comparisons depending on harness.

> A decent model with a great harness beats a great model with a bad harness.

Invest accordingly: when output is bad, audit the harness before swapping the model.

---

## Guides vs Sensors

| | Guides (feedforward) | Sensors (feedback) |
|---|---|---|
| Timing | Steer **before** generation | Observe **after** generation |
| Examples | Rules, constraints, boundaries, permissions, plans | Tests, linters, typecheckers, review agents |
| Failure if neglected | Enforces rules nobody verified | Repeats the same mistake forever |

Both are required. A guide with no sensor is a wish; a sensor with no guide is a smoke alarm in an empty house.

### Computational vs Inferential Controls

| Computational | Inferential |
|---|---|
| Tests, linters, typecheckers, schema validators, compilers | LLM judges, review agents |
| Deterministic, ms-to-seconds, free | Stochastic, slow, costly |
| Narrow criteria | Semantically richer |

**Prefer computational.** Reach for inferential controls only when the criterion is genuinely fuzzy (tone, design quality, requirement coverage) — and then apply the judge hygiene rules below.

---

## The Loop

```text
gather context -> act -> verify -> repeat until checkExit or budget exhausted
```

The design surface is exactly three things: **checkExit**, **the budget**, and **the loop body**. Everything else is plumbing.

### THE LOAD-BEARING RULE

> **Verification is code in the harness, never a question posed to the model.**

- **Never ask "are you done?"** Models are optimistic; they will say yes.
- **Never ask "are you sure?"** It causes sycophantic flipping of answers that were already correct (the FlipFlop effect). Re-checking must come from an external signal, not from doubt injected into the same context.

### Exit Conditions, Strongest to Weakest

1. **Test-defined** — all tests pass. Strongest.
2. **Diff-defined** — fixed point reached; another iteration produces no change.
3. **Count-defined** — the work queue drains.
4. **Judge-defined** — a rubric score clears a threshold. **Explicitly the weakest.**

**Always name which one is in use.** An unnamed exit condition is a judge-defined one wearing a disguise.

Add **stall detection** regardless: exit when consecutive iterations produce identical failure feedback. Identical feedback means the loop has no new information and will not acquire any.

### Escalation Ladder

Max **2-3 attempts per rung**, then climb:

1. **Retry with feedback appended** — the failure output goes back in.
2. **Retry with FRESH context** — summarize what was learned, discard the polluted transcript.
3. **Retry with a materially different strategy** — not the same plan more carefully.
4. **Escalate to a human** — file an issue, post the summary, stop.

**Prefer a fresh-context restart over a 4th in-context iteration.** By then the context is mostly failed approaches, and the model is conditioning on them.

### Three Simultaneous Budgets

Track **iterations**, **cost**, and **wall-clock** at once. Hitting any one triggers a **clean landing**, not a crash:

- Commit work in progress.
- Write a handoff note: what was done, what is broken, what to try next.
- Exit non-zero with a reason.

---

## Adversarial Patterns

Each pattern needs three things named explicitly: **roles**, **grounding**, **stopping condition**.

### A. Grounded Generator / Verifier — the workhorse

Generator produces; a **mechanical** verifier judges: compiler, typechecker, test suite, linter, schema validator, screenshot diff. Stop when the verifier passes or the iteration budget is hit.

This is where the measured gains live: Self-Refine reports **~20% absolute** improvement over **2-4 iterations**; Reflexion reports **91% vs 80% pass@1** on HumanEval. Both depend on grounding — the gain is in the external signal, not the reflection.

Default to this pattern. Reach for the others only when it does not apply.

### B. Fresh-Context Reviewer

A reviewer sees **only the diff plus explicit criteria** — never the reasoning that produced the work. Shared context imports the author's blind spots.

Prompt shape: name the work, name the plan to check it against, define what counts as a finding, and bound the scope.

```text
Review the diff in <diff> against the plan in <plan>.
A finding is: a requirement in the plan that the diff does not satisfy,
or a correctness defect (wrong output, crash, data loss) with a concrete
failure scenario.
Report gaps, not style preferences.
For each finding: file:line, what is wrong, the failing input.
If the diff satisfies the plan, say so and report nothing.
```

**Calibration warning (mandatory):** a reviewer told to find gaps will report some even when the work is sound. Chasing every finding produces over-engineering — extra abstraction, defensive code, tests for impossible cases. **Constrain findings to correctness or stated requirements; treat everything else as optional.**

### C. Fan-Out + Adversarial Verification

For each spawned agent, a **separate** agent verifies its output against a rubric. Motivated by real failure modes: agentic laziness (declaring partial work complete), self-preferential bias, goal drift over long horizons.

Costs many more tokens — set explicit per-agent budgets. **Most traditional coding tasks do not need a panel of 5 reviewers.** Use when the work fans out naturally and errors are expensive.

### D. Plan → Validate → Execute

For batch, destructive, or high-stakes work:

1. Agent emits a **structured plan file** (`changes.json`) — no side effects yet.
2. A **script** validates it: schema, referential integrity, blast radius.
3. Only then execute.
4. Then verify the result.

Make validators **verbose**: name the missing field **and** list the available fields. A validator that says `invalid key` costs an extra iteration; one that says `unknown key "titel"; available: title, body, tags` costs zero.

### E. Effort Scaling in the Orchestrator

Encode the sizing rule in the orchestrator prompt so it does not over- or under-spend:

| Task | Agents | Tool calls each |
|---|---|---|
| Simple fact-finding | 1 | 3-10 |
| Direct comparison | 2-4 | 10-15 |
| Complex research | 10+, responsibilities clearly divided | scoped per agent |

### F. Externalized State for Cheap Resumption

- Feature/task list as **JSON, not Markdown** — the model is less likely to inappropriately edit JSON.
- A progress file updated as work completes.
- Git commits as checkpoints.
- Plan files as the source of intent.
- **Prohibit removing or editing tests** in the agent's instructions and, where possible, in permissions.

Resumption then costs a file read, not a re-derivation.

---

## Verifier Integrity

Agents earn full marks by deleting failing tests, monkey-patching the verifier, or overfitting to the visible test set. Defend structurally:

- Make the verifier **unreachable from the agent's write surface** (separate directory, read-only mount, CI-side execution).
- **Hold out tests** the agent never sees.
- **Monitor the trajectory, not just the end state.** A green result reached by editing the assertions is a red result.

---

## Does Not Work — Prohibitions

- **Do not use intrinsic self-correction with no external grounding.** *LLMs Cannot Self-Correct Reasoning Yet* (ICLR 2024): attempts often make results **worse**.
- **Do not self-review in the same context.** Self-Correction Bench measured a **64.5% blind-spot rate** on the model's own errors, while the identical error was corrected when externally attributed.
- **Do not let a model judge its own output.** Measurable self-preference / familiarity bias.
- **Do not add multi-agent debate as a general accuracy booster.** At matched compute it rarely beats self-consistency and often fails to preserve answers that were already correct. Prefer **N samples + majority vote**, unless the debaters are genuinely heterogeneous models.
- **Do not build long refinement chains.** Gains concentrate in iterations **1-2** with roughly exponential decay; the **4th iteration consistently degrades** quality.
- **Do not use multi-agent architecture as a substitute for specification.** MAST attributes **~42%** of failures to bad specification / system design and **~21%** to weak verification — adding agents multiplies coordination failures without touching the specification deficit.

---

## LLM-as-Judge Hygiene

Only when the criteria are genuinely fuzzy:

- **Lock the rubric** before scoring. A rubric edited mid-run produces uncomparable numbers.
- **Measure Cohen's κ** against human labels. **κ < 0.5 means rework the rubric**, not the model.
- **Average both orderings** to control position bias — worth **10-15 pp** on close calls.
- **Length-normalize or penalize verbosity** — **15-30 pp** of inflated preference has been measured for longer answers.
- **Sanity-check against a different-vendor judge** before trusting a delta.

---

## Design Checklist

- [ ] Harness audited before the model was blamed.
- [ ] Tool error messages are actionable and name valid alternatives.
- [ ] At least one computational sensor exists on the critical path.
- [ ] Exit condition named, and it is not judge-defined unless it must be.
- [ ] Stall detection on identical consecutive feedback.
- [ ] Escalation ladder with a per-rung attempt cap.
- [ ] Iteration, cost, and wall-clock budgets all set; clean landing defined.
- [ ] Reviewer, if any, sees only the diff plus criteria.
- [ ] Reviewer findings constrained to correctness and stated requirements.
- [ ] Verifier not writable by the agent; some tests held out.
- [ ] No self-review, no self-judging, no chain past ~3 iterations.
- [ ] State externalized so a restart is cheap.

---

## Sources

- https://martinfowler.com/articles/harness-engineering.html
- https://addyosmani.com/blog/agent-harness-engineering
- https://www.anthropic.com/engineering/building-effective-agents
- https://www.anthropic.com/engineering/multi-agent-research-system
- https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents
- https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code
- https://code.claude.com/docs/en/best-practices
- https://developersdigest.tech/blog/loop-engineering-designing-agent-loops
- https://arxiv.org/abs/2310.01798 — LLMs Cannot Self-Correct Reasoning Yet
- https://arxiv.org/abs/2507.02778 — Self-Correction Bench
- https://arxiv.org/abs/2502.08788 — multi-agent debate at matched compute
- https://arxiv.org/abs/2503.13657 — MAST failure taxonomy
- https://arxiv.org/html/2605.23950v1
