# Section Definitions

This file defines the rule categories for GQty best practices. Each section maps to a rule file in this directory.

---

## 1. Configuration & Code Generation (config-codegen)
**Impact:** CRITICAL
**Description:** gqty.config.ts setup, custom scalar mapping, introspection auth, and code generation options. Misconfiguration causes type mismatches and runtime errors.

## 2. Query & Data Access Patterns (query-data-access)
**Impact:** CRITICAL
**Description:** useQuery(), Suspense integration, prepare()/prepass(), proxy-based data access, and auto-refetch. The most common source of GQty usage errors.

## 3. Cache & Normalization (cache-normalization)
**Impact:** CRITICAL
**Description:** Cache policies, normalized identity functions, stale-while-revalidate, persistence, and when to disable normalization. Incorrect caching causes stale UI and data inconsistency.

## 4. Mutations & Optimistic Updates (mutation-optimistic-updates)
**Impact:** HIGH
**Description:** useMutation() patterns, optimistic cache updates, return field selection, retry safety, and refetch on failure. Critical for responsive write operations.

## 5. Selection Functions & Reuse (selection-functions-reuse)
**Impact:** HIGH
**Description:** Reusable selection functions, fragment-like composition, stable inputs for resolve() double-invocation, and shared field access across queries, mutations, and SSR.

## 6. Pagination & Lists (pagination-lists)
**Impact:** HIGH
**Description:** usePaginatedQuery(), merge functions, array handling with and without Suspense, temporary keys for React reconciliation, and fetchMore() patterns.

## 7. Error Handling & Resilience (error-handling-resilience)
**Impact:** HIGH
**Description:** $state.error inspection, error boundaries with Suspense, mutation onError callbacks, retry policies, and subscription error handling.

## 8. SSR & Server Rendering (ssr-server-rendering)
**Impact:** MEDIUM
**Description:** resolve() for server-side data fetching, selection function reuse for SSR, cache serialization and client rehydration, and Next.js integration.
