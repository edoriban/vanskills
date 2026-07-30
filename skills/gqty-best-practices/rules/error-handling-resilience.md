---
title: Handle Errors at Every Layer with Retry Policies
impact: HIGH
impactDescription: Prevents silent failures, unhandled promise rejections, and cascading error states
tags: error-handling, error-boundary, retry, suspense, resilience, onError
---

## Handle Errors at Every Layer with Retry Policies

GQty surfaces errors differently depending on whether you use Suspense, non-Suspense queries, mutations, or subscriptions. Missing error handling at any layer causes silent data loss, blank screens, or unhandled promise rejections. Retry policies add resilience for transient network failures.

### Error Handling Decision Tree

```
Which GQty hook are you using?
├── useQuery() without Suspense
│   └── Check query.$state.error after render
├── useQuery() with Suspense
│   └── Wrap in React Error Boundary
├── useMutation()
│   └── Use onError callback + try/catch on the mutate call
├── useSubscription()
│   └── Check subscription.$state.error + onError option
└── resolve() (SSR)
    └── try/catch the resolve() promise
```

### Error Handling Without Suspense

When not using Suspense, errors are available on `$state.error`. They do not throw — you must check explicitly.

**Incorrect (error silently ignored):**

```tsx
function UserProfile({ id }: { id: string }) {
  const query = useQuery({
    prepare({ query }) {
      query.user({ id }).name;
    },
  });
  const user = query.user({ id });

  // If the query fails, user.name is undefined
  // Component renders blank with no error feedback
  return <h1>{user.name}</h1>;
}
```

**Correct (error state handled):**

```tsx
function UserProfile({ id }: { id: string }) {
  const query = useQuery({
    prepare({ query }) {
      query.user({ id }).name;
    },
  });
  const user = query.user({ id });

  if (query.$state.error) {
    return <ErrorMessage error={query.$state.error} />;
  }
  if (query.$state.isLoading) {
    return <Skeleton />;
  }

  return <h1>{user.name}</h1>;
}
```

### Error Boundaries with Suspense

With Suspense enabled, query errors throw and must be caught by a React Error Boundary.

```tsx
import { ErrorBoundary } from "react-error-boundary";

function UserPage({ id }: { id: string }) {
  return (
    <ErrorBoundary
      fallbackRender={({ error, resetErrorBoundary }) => (
        <div>
          <p>Failed to load user: {error.message}</p>
          <button onClick={resetErrorBoundary}>Retry</button>
        </div>
      )}
    >
      <Suspense fallback={<Skeleton />}>
        <UserProfile id={id} />
      </Suspense>
    </ErrorBoundary>
  );
}
```

### Mutation Error Handling

Mutations should handle errors in both the `onError` callback and at the call site.

```tsx
function DeletePost({ id }: { id: string }) {
  const [deletePost, { isLoading }] = useMutation(
    (mutation) => {
      const result = mutation.deletePost({ id });
      result.success;
      return result;
    },
    {
      onError(error) {
        toast.error(`Delete failed: ${error.message}`);
      },
    }
  );

  const handleDelete = async () => {
    try {
      await deletePost();
    } catch (error) {
      // Catch here for flow control (e.g., do not navigate away)
      console.error("Delete aborted:", error);
    }
  };

  return (
    <button onClick={handleDelete} disabled={isLoading}>
      Delete
    </button>
  );
}
```

### Retry Policies

Configure retry behavior on the client or per-query to recover from transient failures.

```typescript
// Client-level retry configuration
export const client = createClient<GeneratedSchema>({
  url: "/graphql",
  retry: {
    maxRetries: 3,
    retryDelay: 1000, // 1 second base delay
    // Exponential backoff: 1s, 2s, 4s
    retryOn(error, retryCount) {
      // Only retry on network errors, not GraphQL validation errors
      if (error.graphQLErrors?.length) return false;
      return retryCount < 3;
    },
  },
});
```

Per-query retry override:

```tsx
const query = useQuery({
  retry: { maxRetries: 5 },
  prepare({ query }) {
    query.criticalDashboardData.revenue;
  },
});
```

### Subscription Error Handling

Subscriptions can fail silently if the WebSocket disconnects. Always monitor `$state.error`.

```tsx
function LiveNotifications() {
  const subscription = useSubscription();
  const notification = subscription.onNewNotification;

  if (subscription.$state.error) {
    return (
      <Banner type="warning">
        Live updates disconnected. <RetryButton />
      </Banner>
    );
  }

  return <NotificationToast message={notification?.message} />;
}
```

### Verification Checklist

- [ ] Every non-Suspense `useQuery()` checks `$state.error` before rendering data
- [ ] Every Suspense-enabled query is wrapped in an `<ErrorBoundary>`
- [ ] Mutations use `onError` callbacks and/or try/catch at the call site
- [ ] Retry policies exclude GraphQL validation errors (only retry network errors)
- [ ] Subscriptions monitor `$state.error` for disconnection handling
- [ ] `resolve()` calls in SSR are wrapped in try/catch

Reference: [GQty Error Handling](https://gqty.dev/docs/react/useQuery)
