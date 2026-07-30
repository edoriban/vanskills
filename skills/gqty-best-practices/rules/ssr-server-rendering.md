---
title: Use resolve() with Shared Selection Functions for SSR
impact: MEDIUM
impactDescription: Prevents hydration mismatches and redundant server-side fetches in SSR/Next.js apps
tags: ssr, resolve, next-js, server-components, hydration, server-rendering
---

## Use resolve() with Shared Selection Functions for SSR

GQty's `resolve()` function fetches data on the server by invoking a selection function twice — once to discover required fields, once to read the data. Reusing the same selection functions from your client components ensures the server pre-fetches exactly the right fields, preventing hydration mismatches where the client re-fetches data the server already had.

### SSR Decision Tree

```
What server rendering approach are you using?
├── Next.js Pages Router (getServerSideProps / getStaticProps)
│   └── Use resolve() in the data-fetching function
├── Next.js App Router (Server Components)
│   └── Use resolve() at the top of the Server Component
├── Other SSR framework (Remix, Astro, etc.)
│   └── Use resolve() in the server loader/data function
└── No SSR
    └── Skip this rule, use useQuery() on the client
```

### Basic resolve() Pattern

```typescript
import { resolve } from "../gqty";

// Server-side data fetching
export async function getServerSideProps() {
  const data = await resolve(({ query }) => {
    const user = query.currentUser;
    user.id;
    user.name;
    user.email;
    return { name: user.name, email: user.email };
  });

  return { props: { user: data } };
}
```

### Selection Function Reuse for SSR

Share selection functions between server resolve() and client useQuery() to guarantee field consistency.

**Incorrect (duplicated selections — hydration mismatch risk):**

```typescript
// Server
export async function getServerSideProps() {
  const data = await resolve(({ query }) => {
    const user = query.currentUser;
    user.name; // Only fetches name on server
    return { name: user.name };
  });
  return { props: { user: data } };
}

// Client — accesses email which was NOT prefetched on the server
function Profile() {
  const query = useQuery({ suspense: true });
  return <p>{query.currentUser.name} - {query.currentUser.email}</p>;
  // email triggers a client-side fetch, causing a flash of missing data
}
```

**Correct (shared selection function):**

```typescript
// src/gqty/selections.ts
import type { User } from "./generated";

export function selectUserProfile(user: User) {
  user.id;
  user.name;
  user.email;
  user.avatar;
}

// Server
export async function getServerSideProps() {
  const data = await resolve(({ query }) => {
    const user = query.currentUser;
    selectUserProfile(user);
    return {
      id: user.id,
      name: user.name,
      email: user.email,
      avatar: user.avatar,
    };
  });
  return { props: { user: data } };
}

// Client — same fields, no extra fetch needed
function Profile() {
  const query = useQuery({
    suspense: true,
    prepare({ query }) {
      selectUserProfile(query.currentUser);
    },
  });
  const user = query.currentUser;
  return <p>{user.name} - {user.email}</p>;
}
```

### Cache Serialization and Client Rehydration

After resolving data on the server, serialize the cache state and pass it to the client so the initial render does not re-fetch.

```typescript
// Server: serialize cache after resolve()
import { client } from "../gqty";

export async function getServerSideProps() {
  const data = await resolve(({ query }) => {
    selectUserProfile(query.currentUser);
    return query.currentUser;
  });

  const cacheSnapshot = client.cache.toJSON();

  return {
    props: {
      user: { name: data.name, email: data.email },
      cacheSnapshot: cacheSnapshot.query, // Only serialize query cache
    },
  };
}

// Client: rehydrate cache before rendering
function App({ cacheSnapshot, ...props }) {
  useEffect(() => {
    if (cacheSnapshot) {
      client.cache.restore({ query: cacheSnapshot });
    }
  }, []);

  return <Profile {...props} />;
}
```

### Next.js App Router (Server Components)

In the App Router, Server Components can call `resolve()` directly at the top level.

```typescript
// app/profile/page.tsx (Server Component)
import { resolve } from "@/gqty";
import { selectUserProfile } from "@/gqty/selections";

export default async function ProfilePage() {
  const user = await resolve(({ query }) => {
    const u = query.currentUser;
    selectUserProfile(u);
    return { name: u.name, email: u.email, avatar: u.avatar };
  });

  return (
    <div>
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
}
```

For Server Actions that perform mutations:

```typescript
// app/actions.ts
"use server";

import { resolve } from "@/gqty";

export async function updateUserName(id: string, name: string) {
  const result = await resolve(({ mutation }) => {
    const user = mutation.updateUser({ id, input: { name } });
    user.id;
    user.name;
    return { id: user.id, name: user.name };
  });
  return result;
}
```

### Verification Checklist

- [ ] `resolve()` calls use the same selection functions as client-side `useQuery()`
- [ ] Selection functions are pure and deterministic (same fields on every invocation)
- [ ] Cache serialization only includes the `query` portion (not mutations/subscriptions)
- [ ] Client rehydrates the cache before the first render to avoid redundant fetches
- [ ] Server Components use `resolve()` directly, not `useQuery()`
- [ ] Server Actions use `resolve()` with mutation proxies for write operations

Reference: [GQty SSR Docs](https://gqty.dev/docs/guides/ssr)
