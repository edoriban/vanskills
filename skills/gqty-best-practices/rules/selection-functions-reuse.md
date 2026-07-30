---
title: Extract Reusable Selection Functions for Consistent Data Access
impact: HIGH
impactDescription: Eliminates field drift between queries, mutations, and SSR selections
tags: selection-functions, fragments, reuse, composition, resolve, consistency
---

## Extract Reusable Selection Functions for Consistent Data Access

GQty does not have a built-in fragment syntax like traditional GraphQL clients. Instead, you extract plain TypeScript functions that access proxy fields, then call those functions from queries, mutations, and SSR `resolve()` calls. This prevents field drift — where a query selects `user.name` but a mutation forgets to select it, causing the cache to lose the value.

### Selection Function Pattern

```
Same fields needed in multiple places?
├── Yes → Extract a selection function
│   ├── Used in useQuery() → Call it with the query proxy
│   ├── Used in useMutation() → Call it with the mutation return value
│   └── Used in resolve() (SSR) → Call it with the resolve proxy
└── No  → Inline field access is fine
```

### Examples

**Incorrect (duplicated field access — prone to drift):**

```tsx
// In a query component
function UserCard({ id }: { id: string }) {
  const query = useQuery({ suspense: true });
  const user = query.user({ id });
  return <span>{user.name} ({user.email})</span>;
}

// In a mutation — forgot to select email, cache loses it
function UpdateUser({ id }: { id: string }) {
  const [update] = useMutation((mutation, name: string) => {
    const user = mutation.updateUser({ id, input: { name } });
    user.id;
    user.name;
    // user.email is missing — after mutation, email disappears from cache
  });
  return <button onClick={() => update("Alice")}>Rename</button>;
}
```

**Correct (shared selection function):**

```tsx
// src/gqty/selections.ts
import type { User } from "./generated";

export function selectUserCard(user: User) {
  user.id;
  user.name;
  user.email;
  user.avatar;
}

// In a query component
function UserCard({ id }: { id: string }) {
  const query = useQuery({
    suspense: true,
    prepare({ query }) {
      selectUserCard(query.user({ id }));
    },
  });
  const user = query.user({ id });
  return <span>{user.name} ({user.email})</span>;
}

// In a mutation — same fields, always in sync
function UpdateUser({ id }: { id: string }) {
  const [update] = useMutation((mutation, name: string) => {
    const user = mutation.updateUser({ id, input: { name } });
    selectUserCard(user);
  });
  return <button onClick={() => update("Alice")}>Rename</button>;
}
```

### Composing Selection Functions

Selection functions compose just like regular functions. Build larger selections from smaller ones.

```typescript
// Base selections
export function selectUserSummary(user: User) {
  user.id;
  user.name;
  user.avatar;
}

export function selectUserContact(user: User) {
  user.email;
  user.phone;
}

// Composed selection
export function selectUserFull(user: User) {
  selectUserSummary(user);
  selectUserContact(user);
  user.createdAt;
  user.role;
}
```

### Stable Inputs for resolve() Double-Invocation

GQty's `resolve()` function calls the selection function twice: once to discover fields, once to read data. Selection functions must be pure and produce the same field accesses on both invocations.

**Incorrect (non-deterministic selection):**

```typescript
const data = await resolve(({ query }) => {
  const items = query.items({ first: 10 });
  // Random access — different fields selected on each invocation
  if (Math.random() > 0.5) {
    items[0]?.title;
  }
  items[0]?.description;
});
```

**Correct (deterministic selection):**

```typescript
const data = await resolve(({ query }) => {
  const items = query.items({ first: 10 });
  // Always access the same fields on both invocations
  for (const item of items) {
    item.id;
    item.title;
    item.description;
  }
  return items;
});
```

### Verification Checklist

- [ ] Fields accessed in more than one query/mutation are extracted into a selection function
- [ ] Selection functions are imported from a shared module (e.g., `src/gqty/selections.ts`)
- [ ] Mutation handlers call the same selection functions used by the queries they affect
- [ ] Selection functions passed to `resolve()` are pure and deterministic
- [ ] Composed selections do not access conflicting or redundant fields

Reference: [GQty React Patterns](https://gqty.dev/docs/react/useQuery)
