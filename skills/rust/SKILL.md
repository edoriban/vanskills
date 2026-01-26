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
| **Core** | Ownership, Borrowing, Lifetimes, Mutability | `ownership-`, `mutability-`, `mental-models-` |
| **Safety** | Error Handling (Result/Option), Unsafe Code, Types | `error-handling-`, `unsafe-`, `type-driven-` |
| **Systems** | Concurrency, Smart Pointers, Zero-Cost | `concurrency-`, `smart-pointers-`, `zero-cost-` |
| **Design** | Domain Modeling, Domain Errors, Ecosystem | `domain-modeling-`, `domain-error-`, `ecosystem-` |
| **Quality** | Performance, Anti-patterns, Lifecycle | `performance-`, `anti-patterns-`, `lifecycle-` |

## How to Use This Skill

1. **Identify the Challenge**: determining if you are fighting the borrow checker, designing an API, or optimizing performance.
2. **Consult Rules**:
   - `ownership.md` / `mental-models.md`: For E0382, lifetimes, and "thinking in Rust".
   - `domain-modeling.md`: For Entity vs Value Object decisions.
   - `mutability.md`: For `Cell`, `RefCell`, `Mutex`, and interior mutability.
   - `type-driven.md`: For Newtype, Builder, and Type State patterns.
   - `error-handling.md`: For `Result`, `Option`, and error crate selection.
   - `concurrency.md`: For `async`, `tokio`, and thread safety.
   - `ecosystem.md`: For crate selection, Cargo features, and FFI.

## Core Principles

1.  **Ownership First**: Always ask "Who owns this data?" before writing code.
2.  **Type-Driven Design**: Use the type system to make invalid states unrepresentable.
3.  **Zero-Cost Abstractions**: Prefer iterators and high-level abstractions that compile down to optimized machine code.
4.  **Fail Fast**: Use `Result` for recoverable errors and `panic!` only for unrecoverable bugs.
5.  **Clippy is your Friend**: Adhere to `cargo clippy` suggestions.
