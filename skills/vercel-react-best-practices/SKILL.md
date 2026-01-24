---
name: vercel-react-best-practices
description: >
  React and Next.js performance optimization guidelines from Vercel Engineering.
  Trigger: When writing, reviewing, or refactoring React/Next.js code to ensure optimal performance patterns. Triggers on tasks involving React components, Next.js pages, data fetching, bundle optimization, or performance improvements.
license: MIT
metadata:
  author: vercel
  version: "1.0.0"
  auto_invoke: "React performance / Next.js optimization"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task, WebFetch
---

# Vercel React Best Practices

Comprehensive performance optimization guide for React and Next.js applications, maintained by Vercel.

## Quick Reference Table

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Eliminating Waterfalls | CRITICAL | `async-` |
| 2 | Bundle Size Optimization | CRITICAL | `bundle-` |
| 3 | Server-Side Performance | HIGH | `server-` |
| 4 | Client-Side Data Fetching | MEDIUM-HIGH | `client-` |
| 5 | Re-render Optimization | MEDIUM | `rerender-` |
| 6 | Rendering Performance | MEDIUM | `rendering-` |
| 7 | JavaScript Performance | LOW-MEDIUM | `js-` |
| 8 | Advanced Patterns | LOW | `advanced-` |

## How to Use This Skill Efficiently

This skill is modular. Instead of reading one giant file, identify the relevant category and read the specific rule in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/vercel-react-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "memo", "Suspense", "Server Actions"):
`Grep(pattern="memo", path="skills/vercel-react-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed code examples:
`Read(filePath="/root/vanskills/skills/vercel-react-best-practices/rules/rerender-memo.md")`

## Core Principles

1. **Eliminate Waterfalls**: Avoid sequential `await` calls; use `Promise.all()` or restructure components to parallelize data fetching.
2. **Bundle Optimization**: Avoid barrel imports (`import { X } from 'lib'`); use direct imports or `optimizePackageImports`.
3. **Server Security**: Always authenticate inside Server Actions; treat them like public API endpoints.
4. **Derived State**: Compute values during render; avoid redundant `useState` + `useEffect` for data that can be derived.
5. **Stable Callbacks**: Use functional updates `setCount(c => c + 1)` and `useEffectEvent` to maintain stable references.
