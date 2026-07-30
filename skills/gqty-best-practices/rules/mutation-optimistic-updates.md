---
title: Select Return Fields and Use Optimistic Updates for Responsive Mutations
impact: HIGH
impactDescription: 2-5x faster perceived UI updates and automatic cache consistency after mutations
tags: useMutation, optimistic, cache-update, return-fields, retry, mutations
---

## Select Return Fields and Use Optimistic Updates for Responsive Mutations

GQty tracks which fields a mutation returns to know what to update in the cache. If you call a mutation without accessing any return fields, GQty cannot propagate changes and the UI stays stale until the next refetch. Optimistic updates make the UI respond instantly while the server processes the request.

### Mutation Pattern Decision Tree

```
Does the mutation modify data visible in the current UI?
├── Yes → Access return fields so GQty updates the cache
│   ├── Need instant feedback? → Use optimistic update
│   └── Can wait for server? → Access return fields only
└── No (fire-and-forget, like analytics) → No return fields needed
```

### Examples

**Incorrect (no return fields selected — cache stays stale):**

```tsx
function UpdateName({ id }: { id: string }) {
  const [updateUser] = useMutation((mutation, name: string) => {
    mutation.updateUser({ id, input: { name } });
    // No fields accessed on the return value!
    // GQty does not know what changed, UI stays stale
  });

  return <button onClick={() => updateUser("Alice")}>Rename</button>;
}
```

**Correct (return fields selected — cache updates automatically):**

```tsx
function UpdateName({ id }: { id: string }) {
  const [updateUser] = useMutation((mutation, name: string) => {
    const user = mutation.updateUser({ id, input: { name } });
    // Access the fields you need — GQty uses these to update the cache
    user.id;
    user.name;
    user.updatedAt;
    return user;
  });

  return <button onClick={() => updateUser("Alice")}>Rename</button>;
}
```

### Optimistic Updates

Optimistic updates write to the cache before the server responds, then reconcile when the response arrives.

```tsx
function ToggleFavorite({ postId }: { postId: string }) {
  const [toggleFav] = useMutation(
    (mutation, isFav: boolean) => {
      const post = mutation.toggleFavorite({ postId, favorite: isFav });
      post.id;
      post.isFavorite;
      return post;
    },
    {
      optimisticResponse({ post }) {
        // Immediately reflect the new state in the UI
        return {
          toggleFavorite: {
            id: postId,
            isFavorite: !post.isFavorite,
            __typename: "Post",
          },
        };
      },
      onError(error) {
        // Optimistic update is automatically rolled back on error
        console.error("Toggle failed:", error);
      },
    }
  );

  return <HeartButton onClick={() => toggleFav(true)} />;
}
```

### Retry Safety

Mutations that have side effects (sending emails, charging payments) must not be blindly retried. Disable automatic retries for non-idempotent mutations.

**Incorrect (dangerous retry on side-effect mutation):**

```tsx
const [sendInvoice] = useMutation(
  (mutation, orderId: string) => {
    const result = mutation.sendInvoice({ orderId });
    result.success;
    return result;
  },
  {
    retry: true, // Will re-send the invoice on transient failure!
  }
);
```

**Correct (no retry for non-idempotent mutations):**

```tsx
const [sendInvoice] = useMutation(
  (mutation, orderId: string) => {
    const result = mutation.sendInvoice({ orderId });
    result.success;
    return result;
  },
  {
    retry: false,
    onError(error) {
      toast.error("Failed to send invoice. Please try again manually.");
    },
  }
);
```

### Refetching After Mutation

When the mutation response does not include all the data needed to update the UI, explicitly refetch the relevant queries.

```tsx
const [createPost] = useMutation(
  (mutation, input: PostInput) => {
    const post = mutation.createPost({ input });
    post.id;
    post.title;
    return post;
  },
  {
    onCompleted() {
      // Refetch the post list since the new item is not in the cache yet
      query.$refetch();
    },
  }
);
```

### Verification Checklist

- [ ] Every mutation that modifies visible data accesses at least one return field
- [ ] Optimistic updates include `__typename` and `id` for cache normalization
- [ ] Non-idempotent mutations (emails, payments, deletions) have `retry: false`
- [ ] `onError` callbacks handle optimistic rollback feedback (toast, alert)
- [ ] Queries are explicitly refetched when the mutation response is insufficient

Reference: [GQty React Mutations Docs](https://gqty.dev/docs/react/useMutation)
