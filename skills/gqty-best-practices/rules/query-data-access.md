---
title: Use Proxy-Based Queries with prepare() to Avoid Extra Renders
impact: CRITICAL
impactDescription: Eliminates wasted render cycles and loading flicker caused by lazy proxy detection
tags: useQuery, prepare, prepass, suspense, proxy, data-access, render-cycle
---

## Use Proxy-Based Queries with prepare() to Avoid Extra Renders

GQty detects data requirements by intercepting property access on proxy objects. Without `prepare()`, the first render accesses proxies, GQty discovers the needed fields, fetches them, and triggers a second render — doubling render cycles. Using `prepare()` or Suspense mode eliminates this overhead.

### Query Patterns Decision Tree

```
Using React Suspense?
├── Yes → useQuery() with suspense: true
│   ├── Data is available on first render (proxy access triggers Suspense boundary)
│   └── No need for prepare() — Suspense handles the loading state
└── No  → useQuery() with prepare()
    ├── prepare() declares data needs before the component renders
    ├── First render receives data immediately (no loading flicker)
    └── Handle $state.isLoading for initial load state
```

### Examples

**Incorrect (no prepare, no Suspense — double render):**

```tsx
function UserProfile({ id }: { id: string }) {
  const query = useQuery();
  const user = query.user({ id });

  // First render: user.name is undefined while GQty discovers the field
  // Second render: user.name has the value after fetch completes
  // This causes a loading flicker even for cached data
  return <h1>{user?.name}</h1>;
}
```

**Correct (prepare eliminates extra render):**

```tsx
function UserProfile({ id }: { id: string }) {
  const query = useQuery({
    prepare({ query }) {
      const user = query.user({ id });
      user.name;
      user.email;
      user.avatar;
    },
  });
  const user = query.user({ id });

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
      <img src={user.avatar} />
    </div>
  );
}
```

**Correct (Suspense mode — simplest approach):**

```tsx
function UserProfile({ id }: { id: string }) {
  const query = useQuery({ suspense: true });
  const user = query.user({ id });

  // With Suspense, data is guaranteed to be available here
  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
}

// Parent must provide a Suspense boundary
function UserPage({ id }: { id: string }) {
  return (
    <Suspense fallback={<Skeleton />}>
      <UserProfile id={id} />
    </Suspense>
  );
}
```

### Handling Undefined State Without Suspense

When not using Suspense, proxy values are `undefined` during the initial fetch. Always check `$state` to distinguish loading from missing data.

```tsx
function UserProfile({ id }: { id: string }) {
  const query = useQuery({
    prepare({ query }) {
      query.user({ id }).name;
    },
  });
  const user = query.user({ id });

  if (query.$state.isLoading) return <Skeleton />;
  if (query.$state.error) return <ErrorMessage error={query.$state.error} />;

  return <h1>{user.name}</h1>;
}
```

### Auto-Refetch Configuration

Control how GQty refetches data when components remount or variables change.

| Option | Default | Description |
|--------|---------|-------------|
| `refetchOnMount` | `false` | Refetch when the component mounts |
| `refetchOnReconnect` | `false` | Refetch when the browser regains network |
| `refetchOnWindowVisible` | `false` | Refetch when the tab becomes visible |
| `staleWhileRevalidate` | `false` | Show cached data immediately, refetch in background |

```tsx
const query = useQuery({
  refetchOnWindowVisible: true,
  staleWhileRevalidate: true,
  prepare({ query }) {
    query.currentUser.name;
    query.currentUser.unreadCount;
  },
});
```

### Verification Checklist

- [ ] Every `useQuery()` call either uses Suspense or provides a `prepare()` function
- [ ] All fields accessed in the render body are also accessed in `prepare()`
- [ ] `$state.isLoading` and `$state.error` are handled when not using Suspense
- [ ] A `<Suspense>` boundary wraps any component using `suspense: true`
- [ ] Auto-refetch options are configured deliberately, not left as implicit defaults

Reference: [GQty React Query Docs](https://gqty.dev/docs/react/useQuery)
