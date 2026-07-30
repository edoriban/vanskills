---
title: Implement Pagination with Merge Functions and Stable Keys
impact: HIGH
impactDescription: Prevents list duplication, flickering, and lost scroll position during paginated fetches
tags: pagination, usePaginatedQuery, fetchMore, merge, lists, reconciliation
---

## Implement Pagination with Merge Functions and Stable Keys

Paginated data in GQty requires explicit merge functions to combine pages, stable keys for React reconciliation, and careful handling of the proxy-based array access pattern. Without these, loading the next page can replace previous results, cause flicker, or break scroll position.

### Pagination Approach Decision Tree

```
What pagination style does the API use?
├── Cursor-based (after/before + edges/nodes)
│   └── Use usePaginatedQuery() with merge + fetchMore
├── Offset-based (offset + limit)
│   └── Use usePaginatedQuery() with merge + fetchMore
└── Simple numbered pages
    └── Use useQuery() with page variable, no merge needed
```

### Examples

**Incorrect (no merge — next page replaces previous):**

```tsx
function PostList() {
  const query = useQuery({ suspense: true });
  const posts = query.posts({ first: 10 });

  // When fetching page 2, page 1 results are replaced
  // User loses their scroll position and previously loaded items
  return (
    <ul>
      {posts.edges?.map((edge) => (
        <li key={edge.node.id}>{edge.node.title}</li>
      ))}
    </ul>
  );
}
```

**Correct (usePaginatedQuery with merge function):**

```tsx
function PostList() {
  const { data, fetchMore, isLoading } = usePaginatedQuery(
    (query, input: { after?: string }) => {
      const connection = query.posts({ first: 10, after: input.after });
      return {
        edges: connection.edges?.map((edge) => ({
          cursor: edge.cursor,
          node: {
            id: edge.node.id,
            title: edge.node.title,
            createdAt: edge.node.createdAt,
          },
        })),
        pageInfo: {
          hasNextPage: connection.pageInfo.hasNextPage,
          endCursor: connection.pageInfo.endCursor,
        },
      };
    },
    {
      merge(existing, incoming) {
        // Combine previous pages with the new page
        return {
          ...incoming,
          edges: [...(existing?.edges ?? []), ...(incoming?.edges ?? [])],
        };
      },
    }
  );

  return (
    <>
      <ul>
        {data?.edges?.map((edge) => (
          <li key={edge.node.id}>{edge.node.title}</li>
        ))}
      </ul>
      {data?.pageInfo.hasNextPage && (
        <button
          disabled={isLoading}
          onClick={() => fetchMore({ after: data.pageInfo.endCursor })}
        >
          Load More
        </button>
      )}
    </>
  );
}
```

### Array Handling Without Suspense

Without Suspense, array proxies return empty arrays during loading. Guard against this to avoid rendering empty states prematurely.

```tsx
function PostList() {
  const { data, fetchMore } = usePaginatedQuery(
    (query, input: { after?: string }) => {
      const connection = query.posts({ first: 10, after: input.after });
      return {
        edges: connection.edges?.map((edge) => ({
          cursor: edge.cursor,
          node: { id: edge.node.id, title: edge.node.title },
        })),
        pageInfo: {
          hasNextPage: connection.pageInfo.hasNextPage,
          endCursor: connection.pageInfo.endCursor,
        },
      };
    },
    {
      merge(existing, incoming) {
        return {
          ...incoming,
          edges: [...(existing?.edges ?? []), ...(incoming?.edges ?? [])],
        };
      },
      suspense: false,
    }
  );

  if (!data) return <Skeleton />;
  if (data.edges?.length === 0) return <EmptyState />;

  return (
    <ul>
      {data.edges?.map((edge) => (
        <li key={edge.node.id}>{edge.node.title}</li>
      ))}
    </ul>
  );
}
```

### Temporary Keys for React Reconciliation

When entities lack a stable `id` field (e.g., aggregation results), generate a temporary key to prevent React from mismatching list items.

```tsx
function TagCloud() {
  const query = useQuery({ suspense: true });
  const tags = query.popularTags({ limit: 50 });

  return (
    <div>
      {tags?.map((tag, index) => (
        // Use a composite key when no stable ID exists
        <Tag key={`${tag.name}-${index}`} name={tag.name} count={tag.count} />
      ))}
    </div>
  );
}
```

### Verification Checklist

- [ ] Paginated queries use a `merge` function that appends instead of replaces
- [ ] `fetchMore` passes the correct cursor or offset for the next page
- [ ] List items use a stable `key` prop (prefer entity `id` over array index)
- [ ] Without Suspense, empty arrays during loading are handled with a loading state
- [ ] `pageInfo.hasNextPage` is checked before showing "Load More"

Reference: [GQty Pagination Docs](https://gqty.dev/docs/react/usePaginatedQuery)
