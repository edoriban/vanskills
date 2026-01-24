---
name: supabase-postgres-best-practices
description: >
  Postgres performance optimization and best practices from Supabase.
  Trigger: When writing, reviewing, or optimizing Postgres queries, schema designs, or database configurations.
license: MIT
metadata:
  author: supabase
  version: "1.0.0"
  auto_invoke: "Postgres performance / Supabase"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task, Supabase
---

# Supabase Postgres Best Practices

Comprehensive performance optimization guide for Postgres, maintained by Supabase.

## Quick Reference Table

| Priority | Category | Impact | Prefix |
|----------|----------|--------|--------|
| 1 | Query Performance | CRITICAL | `query-` |
| 2 | Connection Management | CRITICAL | `conn-` |
| 3 | Security & RLS | CRITICAL | `security-` |
| 4 | Schema Design | HIGH | `schema-` |
| 5 | Concurrency & Locking | MEDIUM-HIGH | `lock-` |
| 6 | Data Access Patterns | MEDIUM | `data-` |
| 7 | Monitoring & Diagnostics | LOW-MEDIUM | `monitor-` |
| 8 | Advanced Features | LOW | `advanced-` |

## How to Use This Skill Efficiently

This skill is modular. Instead of reading everything, identify the relevant rule category and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules if you aren't sure:
`Glob(pattern="skills/supabase-postgres-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "indexing", "RLS", "timeout"):
`Grep(pattern="indexing", path="skills/supabase-postgres-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed examples and performance metrics:
`Read(filePath="/root/vanskills/skills/supabase-postgres-best-practices/rules/query-missing-indexes.md")`

## Core Principles

1. **Index what you filter**: Always add indexes on `WHERE` and `JOIN` columns.
2. **Connection Pooling**: Never connect directly from serverless environments; use a pooler (e.g., PgBouncer).
3. **RLS Performance**: Wrap `auth.uid()` and other functions in `(SELECT ...)` to ensure they are cached per query.
4. **Data Types**: Choose the smallest appropriate type (e.g., `bigint` for IDs, `timestamptz` for dates).
5. **Atomic Operations**: Use `INSERT ... ON CONFLICT` (UPSERT) instead of separate check-then-insert.
