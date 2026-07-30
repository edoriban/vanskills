---
name: tdd
description: >
  Test-driven development discipline: RED/GREEN/REFACTOR cycle, test-pass as the only exit condition, and rules against weakening tests.
  Trigger: When implementing features or fixing bugs in a project with tests, or when sdd-apply activates TDD mode.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Implementing code with tests, fixing bugs, or sdd-apply TDD mode"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## When to Use

- Implementing a task in TDD mode (activated by `sdd-apply` Step 3a when this skill exists).
- Fixing a bug in a project that has a test suite.
- Any change where behavior can be expressed as a test.

---

## The Cycle: RED → GREEN → REFACTOR

Every behavior follows this cycle. No exceptions, no reordering.

```
1. RED      Write ONE failing test describing the expected behavior.
            Run it. Confirm it FAILS.
            If it passes immediately → the behavior already exists or the
            test is wrong. Stop and investigate before writing any code.
2. GREEN    Write the MINIMUM code to make the test pass. Nothing extra.
            Run it. Confirm it PASSES.
3. REFACTOR Clean up structure, naming, duplication. No behavior change.
            Run tests. Confirm they STILL PASS.
```

---

## Exit Condition

- A task is done when its tests PASS — never when you say it is done.
- Self-reported completion is not evidence. Test output is.
- See [../executing/SKILL.md](../executing/SKILL.md) for the general rule:
  exit conditions must be verified externally, not asserted by the agent.

---

## Test Rules

- One behavior per test. If a test needs "and" in its name, split it.
- Test the contract (inputs → observable outputs), not the implementation.
  Refactoring internals must never break a test.
- NEVER delete or weaken a failing test to make it pass. Fix the code.
  If the test itself is genuinely wrong, escalate — say so explicitly and
  explain why, before touching it.
- Do not add functionality the current failing test does not require.

---

## Stall Rule

Same test failing with IDENTICAL output twice in a row → STOP.

1. Reread the requirement / spec scenario.
2. Reread the failing assertion and the actual output.
3. Try a materially different approach — not a tweak of the last one.

Repeating the same fix a third time is looping, not progress.

---

## Framework Detection

Detect in this order — first hit wins:

```
1. Existing test config in the repo:
   vitest.config.* / vite.config.* with test → vitest
   jest.config.* / package.json "jest"      → jest
   pytest.ini / pyproject.toml [tool.pytest] → pytest
   Cargo.toml                                → cargo test
   go.mod                                    → go test ./...
2. Project convention (existing test files, package.json scripts.test)
3. Ask the user.
```

NEVER introduce a new test framework into a repo that already has one.

---

## Bug Fixes

1. Reproduce the bug with a failing test FIRST.
2. Confirm the test fails for the reported reason (not a setup error).
3. Only then touch the fix. The test passing proves the fix; it also
   becomes the regression guard.
