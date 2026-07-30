---
name: gqty-best-practices
description: >
  GQty GraphQL proxy client best practices for queries, mutations, caching, SSR, and code generation.
  Trigger: When building, reviewing, or optimizing applications using GQty as the GraphQL client.
license: MIT
metadata:
  author: vanskills
  version: "1.0.0"
  auto_invoke: "GQty / GraphQL proxy client"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# GQty Best Practices

Comprehensive best practices for GQty, the proxy-based GraphQL client for TypeScript. Covers configuration, queries, mutations, caching, pagination, error handling, and server-side rendering.

## Quick Reference Table

| Priority | Category | Impact | Rule File |
|----------|----------|--------|-----------|
| 1 | Configuration & Code Generation | CRITICAL | `config-codegen` |
| 2 | Query & Data Access Patterns | CRITICAL | `query-data-access` |
| 3 | Cache & Normalization | CRITICAL | `cache-normalization` |
| 4 | Mutations & Optimistic Updates | HIGH | `mutation-optimistic-updates` |
| 5 | Selection Functions & Reuse | HIGH | `selection-functions-reuse` |
| 6 | Pagination & Lists | HIGH | `pagination-lists` |
| 7 | Error Handling & Resilience | HIGH | `error-handling-resilience` |
| 8 | SSR & Server Rendering | MEDIUM | `ssr-server-rendering` |

## How to Use This Skill Efficiently

This skill is modular. Instead of reading everything, identify the relevant category and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules if you aren't sure:
`Glob(pattern="skills/gqty-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "useQuery"):
`Grep(pattern="useQuery", path="skills/gqty-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed guidance and examples:
`Read(filePath="/root/vanskills/skills/gqty-best-practices/rules/query-data-access.md")`

## Core Principles

1. **Trust the proxy**: Let GQty detect data requirements automatically — avoid manually constructing queries or over-selecting fields.
2. **Prepare what you access**: Use `prepare()` or `prepass()` to declare data needs upfront and avoid extra render cycles caused by lazy proxy access.
3. **Normalize by default**: Enable cache normalization with proper identity functions so updates propagate across all components referencing the same entity.
4. **Select on mutations**: Always access at least one return field after a mutation so GQty can track what to refetch and update in the cache.
5. **Reuse selection functions**: Extract shared field selections into standalone functions and reuse them across queries, mutations, and SSR to keep the data layer consistent.
