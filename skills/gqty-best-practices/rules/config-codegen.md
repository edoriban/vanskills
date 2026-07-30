---
title: Configure Code Generation and Custom Scalars Correctly
impact: CRITICAL
impactDescription: Prevents type mismatches, runtime errors, and broken introspection across the entire project
tags: config, codegen, scalars, introspection, gqty-config
---

## Configure Code Generation and Custom Scalars Correctly

Incorrect gqty.config.ts setup causes type mismatches between your schema and generated client, leading to runtime errors that are difficult to trace. Scalar mapping and introspection auth are the most frequently misconfigured options.

### gqty.config.ts Structure

Every GQty project requires a `gqty.config.ts` (or `.cjs`/`.js`) at the project root. The generated client and its types depend entirely on this configuration.

```
Is gqty.config.ts present at project root?
├── Yes → Verify endpoint, scalars, and destination
│   ├── Custom scalars in schema? → Map them in scalarTypes
│   └── Auth required for introspection? → Add headers
└── No  → Create it before running code generation
```

### Examples

**Incorrect (missing scalar mapping):**

```typescript
// gqty.config.ts
const config = {
  react: true,
  enumStyle: "enum" as const,
  introspection: {
    endpoint: "./schema.graphql",
  },
  destination: "./src/gqty/index.ts",
};

export default config;
// Custom scalars like DateTime, JSON, or BigInt will be typed as `unknown`
// causing type errors everywhere they appear
```

**Correct (complete configuration with scalar mapping):**

```typescript
// gqty.config.ts
import type { GQtyConfig } from "@gqty/cli";

const config: GQtyConfig = {
  react: true,
  enumStyle: "enum" as const,
  scalarTypes: {
    DateTime: "string",
    JSON: "Record<string, unknown>",
    BigInt: "string",
    Upload: "File",
    UUID: "string",
  },
  introspection: {
    endpoint: "http://localhost:4000/graphql",
    headers: {
      Authorization: "Bearer ${process.env.INTROSPECTION_TOKEN}",
    },
  },
  destination: "./src/gqty/index.ts",
};

export default config;
```

### Introspection from a Local Schema File

When the GraphQL server is unavailable during CI or development, point introspection at a local schema file instead of a live endpoint.

**Correct (local schema file):**

```typescript
const config: GQtyConfig = {
  react: true,
  scalarTypes: {
    DateTime: "string",
  },
  introspection: {
    endpoint: "./schema.graphql",
  },
  destination: "./src/gqty/index.ts",
};
```

### Running Code Generation

Always regenerate the client after schema changes:

```bash
npx @gqty/cli generate
```

Add it to your workflow scripts:

```json
{
  "scripts": {
    "generate": "gqty generate",
    "dev": "npm run generate && next dev"
  }
}
```

### Enum Styles

| Style | Output | Use When |
|-------|--------|----------|
| `"enum"` | TypeScript `enum` | You need reverse mapping or iteration |
| `"union"` | `type Status = "ACTIVE" \| "INACTIVE"` | Tree-shaking is important, smaller bundle |

### Verification Checklist

- [ ] `gqty.config.ts` exists at the project root
- [ ] All custom scalars in the schema are mapped in `scalarTypes`
- [ ] `destination` points to the correct output path for the generated client
- [ ] Introspection endpoint is reachable (or schema file exists locally)
- [ ] Auth headers are provided if the introspection endpoint requires them
- [ ] `npx @gqty/cli generate` runs without errors after any schema change

Reference: [GQty Configuration Docs](https://gqty.dev/docs/getting-started)
