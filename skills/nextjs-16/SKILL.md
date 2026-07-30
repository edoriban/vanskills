---
name: nextjs-16
description: >
  Next.js 16 App Router patterns.
  Trigger: When working in Next.js App Router (app/), Server Components vs Client Components, Server Actions, Route Handlers, caching/revalidation (Cache Components, "use cache"), proxy.ts, and streaming/Suspense.
license: MIT
metadata:
  author: edoriban
  version: "2.0"
  scope: [root]
  auto_invoke: "App Router / Server Actions"
  dependencies:
    - react-19
    - typescript
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Next.js 16 Baseline

- Turbopack is the default bundler for `next dev` and `next build`. No `--turbopack` flag needed; opt out with `--webpack`. Turbopack config lives at top-level `turbopack` in next.config, NOT `experimental.turbopack`.
- Node.js 20.9+, TypeScript 5.1+, React 19.2 required.
- `next lint` is removed — run ESLint/Biome directly; `next build` no longer lints.
- AMP, `serverRuntimeConfig`/`publicRuntimeConfig` removed. Use env vars (`NEXT_PUBLIC_` for client).
- Parallel route slots (`@slot`) REQUIRE explicit `default.tsx` files — builds fail without them. Return `null` or call `notFound()`.
- `next dev` outputs to `.next/dev` (separate from build); dev and build can run concurrently.

## App Router File Conventions

```
app/
├── layout.tsx          # Root layout (required)
├── page.tsx            # Home page (/)
├── loading.tsx         # Loading UI (Suspense)
├── error.tsx           # Error boundary
├── not-found.tsx       # 404 page
├── (auth)/             # Route group (no URL impact)
├── @modal/default.tsx  # REQUIRED for every parallel route slot
├── api/route.ts        # API handler
└── _components/        # Private folder (not routed)
proxy.ts                # Request interception (root level, NOT middleware.ts)
```

## Async Request APIs (No Sync Fallback)

Sync access to `params`, `searchParams`, `cookies()`, `headers()`, `draftMode()` is fully removed. Always `await`.

```typescript
export default async function Page(props: PageProps<'/blog/[slug]'>) {
  const { slug } = await props.params;
  const query = await props.searchParams;
  const cookieStore = await cookies();
}
```

- Run `npx next typegen` to generate the `PageProps`, `LayoutProps`, `RouteContext` type helpers — use them instead of hand-written prop types.
- Metadata image routes (`opengraph-image`, `icon`, etc.): `params` and `id` are Promises in the image function. `sitemap({ id })`: `id` is a Promise too.

## Server Components (Default)

```typescript
// No directive needed - async by default, dynamic at request time by default
export default async function Page() {
  const data = await db.query();
  return <Component data={data} />;
}
```

Caching is opt-in in 16 — do not assume fetch results or routes are cached implicitly.

## Caching: Cache Components

Enable with `cacheComponents: true` in next.config (replaces `experimental.ppr`, `experimental.dynamicIO`, `experimental.useCache`). Then cache explicitly with `"use cache"`:

```typescript
async function getPosts() {
  "use cache";
  cacheTag("posts");
  cacheLife("hours");
  return db.posts.findMany();
}
```

- `cacheLife` and `cacheTag` are stable — import from `next/cache` without `unstable_` prefix.
- `revalidateTag(tag)` single-argument form is deprecated: pass a cacheLife profile — `revalidateTag("posts", "max")` — for stale-while-revalidate.
- `updateTag(tag)` (Server Actions only): read-your-writes — expires and refreshes in the same request. Use for forms/settings where the user must see their change immediately.
- `refresh()` (Server Actions only): refresh uncached data without touching the cache (server-side counterpart to `router.refresh()`).

## Server Actions

```typescript
// app/actions.ts
"use server";

import { updateTag } from "next/cache";
import { redirect } from "next/navigation";

export async function createUser(formData: FormData) {
  const name = formData.get("name") as string;
  await db.users.create({ data: { name } });

  updateTag("users"); // user sees the change immediately
  redirect("/users");
}

// Usage
<form action={createUser}>
  <input name="name" required />
  <button type="submit">Create</button>
</form>
```

## Data Fetching

```typescript
// Parallel
const [users, posts] = await Promise.all([getUsers(), getPosts()]);

// Streaming with Suspense
<Suspense fallback={<Loading />}>
  <SlowComponent />
</Suspense>
```

## Route Handlers (API)

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  return NextResponse.json(await db.users.findMany());
}

export async function POST(request: NextRequest) {
  const body = await request.json();
  const user = await db.users.create({ data: body });
  return NextResponse.json(user, { status: 201 });
}
```

## Proxy (formerly Middleware)

`middleware.ts` is deprecated — use `proxy.ts` at root. Runs on Node.js runtime (edge not supported in proxy; keep `middleware.ts` only if you need edge). Config flags renamed too (e.g. `skipProxyUrlNormalize`).

```typescript
// proxy.ts (root level)
import { NextResponse, type NextRequest } from "next/server";

export function proxy(request: NextRequest) {
  const token = request.cookies.get("token");
  if (!token && request.nextUrl.pathname.startsWith("/dashboard")) {
    return NextResponse.redirect(new URL("/login", request.url));
  }
  return NextResponse.next();
}

export const config = { matcher: ["/dashboard/:path*"] };
```

## Metadata

```typescript
// Static
export const metadata = { title: "My App", description: "Description" };

// Dynamic - params is a Promise
export async function generateMetadata({ params }) {
  const { id } = await params;
  const product = await getProduct(id);
  return { title: product.name };
}
```

## next/image Gotchas (16 defaults)

- Local src with query strings requires `images.localPatterns` config.
- `images.qualities` defaults to `[75]`; other `quality` props are coerced to the closest allowed value.
- `minimumCacheTTL` default is 4 hours (was 60s); local IP optimization blocked by default; max 3 redirects.
- `images.domains` deprecated — use `images.remotePatterns`.

## server-only Package

```typescript
import "server-only";

// This will error if imported in client component
export async function getSecretData() {
  return db.secrets.findMany();
}
```
