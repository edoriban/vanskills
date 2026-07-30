---
title: Enable Normalized Caching with Proper Identity Functions
impact: CRITICAL
impactDescription: Prevents stale UI, duplicate entities, and inconsistent data across components
tags: cache, normalization, identity, stale-while-revalidate, persistence, cache-policy
---

## Enable Normalized Caching with Proper Identity Functions

GQty's cache normalization stores entities by identity (typically `__typename` + `id`) so that an update to an entity in one query is automatically reflected everywhere that entity appears. Without normalization, the same user object fetched from two different queries can show different values simultaneously.

### Cache Policy Overview

| Policy | Behavior | Use When |
|--------|----------|----------|
| `default` | Use cache if available, fetch if missing | Most read operations |
| `force-cache` | Always use cache, never fetch | Offline-first, static data |
| `no-cache` | Always fetch, skip cache entirely | Real-time data, after mutations |
| `no-store` | Fetch and do not cache the result | Sensitive data, one-time reads |
| `stale-while-revalidate` | Return cache immediately, refetch in background | Dashboard data, lists |

### Normalization Setup

Provide identity functions in the client configuration so GQty knows how to deduplicate entities.

**Incorrect (no normalization — duplicate entities):**

```typescript
// src/gqty/index.ts
export const client = createClient<GeneratedSchema>({
  url: "/graphql",
  // No normalization configured
  // Two queries returning the same user will store separate copies
  // Updating one does NOT update the other
});
```

**Correct (normalized cache with identity functions):**

```typescript
// src/gqty/index.ts
import { Cache } from "@gqty/cache";

export const client = createClient<GeneratedSchema>({
  url: "/graphql",
  cache: new Cache(undefined, {
    maxAge: 5 * 60 * 1000, // 5 minutes default TTL
    staleWhileRevalidate: 30 * 1000, // serve stale for 30s while refetching
    normalization: {
      identity(obj) {
        // Return a unique key for each entity
        if ("id" in obj && "__typename" in obj) {
          return `${obj.__typename}:${obj.id}`;
        }
        return undefined; // Skip normalization for objects without identity
      },
    },
  }),
});
```

### SWR (Stale-While-Revalidate) Configuration

SWR returns cached data instantly while fetching fresh data in the background, providing a snappy user experience without showing stale data for long.

```typescript
const cache = new Cache(undefined, {
  maxAge: 60_000,                // Data is "fresh" for 1 minute
  staleWhileRevalidate: 30_000,  // After maxAge, serve stale for 30s
  // After maxAge + staleWhileRevalidate (90s total), cache entry is evicted
});
```

| Scenario | Age < maxAge | maxAge < Age < maxAge + SWR | Age > maxAge + SWR |
|----------|-------------|---------------------------|-------------------|
| Behavior | Serve from cache | Serve stale, refetch in background | Evict, fetch fresh |

### When to Disable Normalization

Normalization adds overhead and can cause issues with certain data shapes.

```
Should normalization be enabled?
├── Entities have stable IDs (id + __typename)? → Yes, enable
├── Virtualized / infinite lists with thousands of items? → Consider disabling
├── Data is map-like or has dynamic keys? → Disable for those types
└── Data is ephemeral (notifications, logs)? → Disable for those types
```

To skip normalization for specific types, return `undefined` from the identity function:

```typescript
normalization: {
  identity(obj) {
    // Skip normalization for log entries and notifications
    if (obj.__typename === "LogEntry" || obj.__typename === "Notification") {
      return undefined;
    }
    if ("id" in obj && "__typename" in obj) {
      return `${obj.__typename}:${obj.id}`;
    }
    return undefined;
  },
},
```

### Cache Persistence

When persisting the cache to localStorage or IndexedDB, only persist the `query` key. Persisting mutation or subscription state leads to stale side-effect data on reload.

**Incorrect (persisting entire cache):**

```typescript
// Persists mutation results and subscriptions — causes stale actions on reload
localStorage.setItem("gqty-cache", JSON.stringify(cache.toJSON()));
```

**Correct (persisting only query cache):**

```typescript
// Only persist read data
const serialized = cache.toJSON();
localStorage.setItem("gqty-cache", JSON.stringify(serialized.query));

// Restore on startup
const persisted = JSON.parse(localStorage.getItem("gqty-cache") ?? "{}");
const cache = new Cache({ query: persisted });
```

### Verification Checklist

- [ ] Normalization is enabled with an `identity` function that uses `__typename` + `id`
- [ ] Entities without stable IDs return `undefined` from the identity function
- [ ] `maxAge` and `staleWhileRevalidate` are set to appropriate values for your use case
- [ ] Cache persistence only serializes the `query` portion of the cache
- [ ] High-volume or ephemeral types are excluded from normalization

Reference: [GQty Cache Docs](https://gqty.dev/docs/cache)
