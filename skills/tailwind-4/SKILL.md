---
name: tailwind-4
description: >
  Tailwind CSS 4 patterns and best practices.
  Trigger: When styling with Tailwind (className, variants, cn()), especially when dynamic styling or CSS variables are involved (no var() in className).
license: MIT
metadata:
  author: vandev
  version: "1.0"
  scope: [root]
  auto_invoke: "Working with Tailwind classes"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## Styling Decision Tree

```
Tailwind class exists?  -> className="..."
Dynamic value?          -> style={{ width: `${x}%` }}
Conditional styles?     -> cn("base", condition && "variant")
Static only?            -> className="..." (no cn() needed)
Library can't use class?-> style prop with var() constants
```

## Critical Rules

### Never Use var() in className

```typescript
// NEVER: var() in className
<div className="bg-[var(--color-primary)]" />
<div className="text-[var(--text-color)]" />

// ALWAYS: Use Tailwind semantic classes
<div className="bg-primary" />
<div className="text-slate-400" />
```

### Never Use Hex Colors

```typescript
// NEVER: Hex colors in className
<p className="text-[#ffffff]" />
<div className="bg-[#1e293b]" />

// ALWAYS: Use Tailwind color classes
<p className="text-white" />
<div className="bg-slate-800" />
```

## The cn() Utility

```typescript
import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### When to Use cn()

```typescript
// Conditional classes
<div className={cn("base-class", isActive && "active-class")} />

// Merging with potential conflicts
<button className={cn("px-4 py-2", className)} />  // className might override

// Multiple conditions
<div className={cn(
  "rounded-lg border",
  variant === "primary" && "bg-blue-500 text-white",
  variant === "secondary" && "bg-gray-200 text-gray-800",
  disabled && "opacity-50 cursor-not-allowed"
)} />
```

### When NOT to Use cn()

```typescript
// Static classes - unnecessary wrapper
<div className={cn("flex items-center gap-2")} />

// Just use className directly
<div className="flex items-center gap-2" />
```

## Common Patterns

### Flexbox

```typescript
<div className="flex items-center justify-between gap-4" />
<div className="flex flex-col gap-2" />
<div className="inline-flex items-center" />
```

### Grid

```typescript
<div className="grid grid-cols-3 gap-4" />
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6" />
```

### Spacing

```typescript
// Padding
<div className="p-4" />           // All sides
<div className="px-4 py-2" />     // Horizontal, vertical
<div className="pt-4 pb-2" />     // Top, bottom

// Margin
<div className="m-4" />
<div className="mx-auto" />       // Center horizontally
<div className="mt-8 mb-4" />
```

### Typography

```typescript
<h1 className="text-2xl font-bold text-white" />
<p className="text-sm text-slate-400" />
<span className="text-xs font-medium uppercase tracking-wide" />
```

### States

```typescript
<button className="hover:bg-blue-600 focus:ring-2 active:scale-95" />
<input className="focus:border-blue-500 focus:outline-none" />
<div className="group-hover:opacity-100" />
```

### Responsive

```typescript
<div className="w-full md:w-1/2 lg:w-1/3" />
<div className="hidden md:block" />
<div className="text-sm md:text-base lg:text-lg" />
```

### Dark Mode

```typescript
<div className="bg-white dark:bg-slate-900" />
<p className="text-gray-900 dark:text-white" />
```
