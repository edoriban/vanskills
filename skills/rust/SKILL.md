---
name: rust
description: >
  Expert Rust programming patterns, idiomatic practices, and memory safety guidelines.
  Covers ownership, borrowing, lifetimes, error handling, concurrency, and performance optimization.
  Trigger: When writing, refactoring, or debugging Rust code (.rs files), or when dealing with Cargo.toml.
license: MIT
metadata:
  author: edoriban
  version: "1.0.0"
  auto_invoke: "Writing or refactoring Rust code"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# Rust Idiomatic Patterns

A comprehensive guide to writing safe, concurrent, and fast Rust code, derived from the ActionBook Rust Skills library.

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| **Core** | Ownership, Borrowing, Lifetimes | `ownership-` |
| **Safety** | Error Handling (Result/Option), Unsafe Code | `error-handling-`, `unsafe-` |
| **Systems** | Concurrency (Async/Threads), Smart Pointers | `concurrency-`, `smart-pointers-` |
| **Quality** | Performance, Anti-patterns, Testing | `performance-`, `anti-patterns-` |

## How to Use This Skill

1. **Identify the Challenge**: determining if you are fighting the borrow checker, designing an API, or optimizing performance.
2. **Consult Rules**:
   - `ownership.md`: For E0382, E0597, and lifetime issues.
   - `error-handling.md`: For `Result`, `Option`, and error crate selection (anyhow vs thiserror).
   - `concurrency.md`: For `async`, `tokio`, and thread safety (`Send` + `Sync`).
   - `smart-pointers.md`: For `Box`, `Rc`, `Arc`, `RefCell`, `Cow`.
   - `unsafe.md`: Checklist before using `unsafe`.

## Core Principles

1.  **Ownership First**: Always ask "Who owns this data?" before writing code.
2.  **Type-Driven Design**: Use the type system to make invalid states unrepresentable.
3.  **Zero-Cost Abstractions**: Prefer iterators and high-level abstractions that compile down to optimized machine code.
4.  **Fail Fast**: Use `Result` for recoverable errors and `panic!` only for unrecoverable bugs.
5.  **Clippy is your Friend**: Adhere to `cargo clippy` suggestions.
