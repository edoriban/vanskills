---
name: vitest
description: >
  Vitest testing patterns for TypeScript/JavaScript (mocking, fixtures, fake timers, coverage).
  Trigger: When writing or refactoring Vitest tests, configuring vitest.config, mocking modules, or setting up coverage.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Writing JS/TS tests with Vitest"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

> Note: `sdd-apply` probes for `vitest/SKILL.md` by name to enable TDD mode — keep this skill named exactly `vitest`. For the RED/GREEN/REFACTOR discipline itself, follow `skills/tdd`.

## Basic Test Structure

```ts
import { describe, expect, it } from 'vitest'

describe('userService', () => {
  it('creates a user', () => {
    const user = createUser({ name: 'John' })
    expect(user.name).toBe('John')
  })

  it('rejects invalid email', () => {
    expect(() => createUser({ email: 'bad' })).toThrow('Invalid email')
  })
})
```

- `toBe` for primitives/identity, `toEqual` for deep equality, `toMatchObject` for partial shape.
- Async errors: `await expect(fn()).rejects.toThrow('msg')`.
- Modifiers: `it.only`, `it.skip`, `it.todo`, `it.concurrent`, `it.each([...])` for parametrized tests.

## Mocking

```ts
import { expect, vi } from 'vitest'

// Mock functions
const fn = vi.fn((a: number) => a * 2)
fn.mockReturnValueOnce(1)
fn.mockResolvedValue({ data: true })
expect(fn).toHaveBeenCalledWith(2)

// Spy on object methods (restore with mockRestore or restoreMocks config)
const spy = vi.spyOn(cart, 'getTotal').mockReturnValue(200)

// Mock a module — factory is hoisted, keep real exports with importOriginal
vi.mock('./api', async (importOriginal) => ({
  ...(await importOriginal<typeof import('./api')>()),
  fetchUser: vi.fn().mockResolvedValue({ id: 1 }),
}))
```

- Reset state between tests: `mockClear` (calls), `mockReset` (calls + implementation), `mockRestore` (original). Prefer `restoreMocks: true` in config over manual `afterEach` cleanup.
- Variables used inside a `vi.mock` factory must come from `vi.hoisted(() => ...)`.

## Fake Timers & Dates

```ts
beforeEach(() => vi.useFakeTimers())
afterEach(() => vi.useRealTimers())

it('debounces', () => {
  vi.setSystemTime(new Date('2026-01-01'))
  start()
  vi.advanceTimersByTime(500)      // or vi.runAllTimers()
  expect(done).toBe(true)
})
```

## Hooks & Fixtures

```ts
import { test as baseTest } from 'vitest'

// Custom fixtures via test.extend — lazy, type-safe, composable
export const test = baseTest.extend<{ db: Db }>({
  db: async ({}, use) => {
    const db = await createTestDb()
    await use(db)          // test runs here
    await db.close()       // teardown
  },
})

test('saves record', async ({ db }) => {
  await db.insert({ id: 1 })
})
```

- Prefer fixtures over `beforeEach` + shared mutable variables: fixtures only initialize when a test uses them.
- Per-test cleanup inside a test body: `onTestFinished(fn)` from the test context.

## Config Essentials

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    environment: 'node',          // 'jsdom' | 'happy-dom' for DOM tests
    globals: false,               // prefer explicit imports from 'vitest'
    restoreMocks: true,
    coverage: { provider: 'v8', include: ['src/**'] },
  },
})
```

- Vitest reuses the project's Vite config, plugins, and aliases — do not duplicate them.
- Snapshots: prefer `toMatchInlineSnapshot()` for small values; review snapshot diffs, never blind-update.

## Commands

```bash
vitest                         # watch mode (dev)
vitest run                     # single run (CI)
vitest run --coverage          # with coverage
vitest run path/to/file.test.ts
vitest -t "creates a user"     # filter by test name
vitest run --changed           # only tests affected by changed files
```

## Sources

- Base imported via skills.sh (`npx skills use https://github.com/antfu/skills --skill vitest`), generated from vitest-dev/vitest by Anthony Fu.
- Condensed from its reference set (config, test API, mocking, fixtures, coverage) into a single file; cross-references `skills/tdd`.
