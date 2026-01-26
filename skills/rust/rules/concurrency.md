# Concurrency

> **Layer 1: Language Mechanics**

## Core Question

**Is this CPU-bound or I/O-bound, and what's the sharing model?**

Before choosing concurrency primitives:
- What's the workload type?
- What data needs to be shared?
- What's the thread safety requirement?

---

## Error → Design Question

| Error | Don't Just Say | Ask Instead |
|-------|----------------|-------------|
| E0277 Send | "Add Send bound" | Should this type cross threads? |
| E0277 Sync | "Wrap in Mutex" | Is shared access really needed? |
| Future not Send | "Use spawn_local" | Is async the right choice? |
| Deadlock | "Reorder locks" | Is the locking design correct? |

---

## Thinking Prompt

Before adding concurrency:

1. **What's the workload?**
   - CPU-bound → threads (std::thread, rayon)
   - I/O-bound → async (tokio, async-std)
   - Mixed → hybrid approach

2. **What's the sharing model?**
   - No sharing → message passing (channels)
   - Immutable sharing → Arc<T>
   - Mutable sharing → Arc<Mutex<T>> or Arc<RwLock<T>>

3. **What are the Send/Sync requirements?**
   - Cross-thread ownership → Send
   - Cross-thread references → Sync
   - Single-thread async → spawn_local

---

## Trace Up ↑ (MANDATORY)

**CRITICAL**: Don't just fix the error. Trace UP to find domain constraints.

### Domain Detection Table

| Context Keywords | Load Domain Skill | Key Constraint |
|-----------------|-------------------|----------------|
| Web API, HTTP, axum, actix, handler | **domain-web** | Handlers run on any thread |
| 交易, 支付, trading, payment | **domain-fintech** | Audit + thread safety |
| gRPC, kubernetes, microservice | **domain-cloud-native** | Distributed tracing |
| CLI, terminal, clap | **domain-cli** | Usually single-thread OK |

### Generic Trace

```
"Send not satisfied for my type"
    ↑ Ask: What domain is this? Load domain-* skill
    ↑ Ask: Does this type need to cross thread boundaries?
    ↑ Check: m09-domain (is the data model correct?)
```

---

## Trace Down ↓

From design to implementation:

```
"Need parallelism for CPU work"
    ↓ Use: std::thread or rayon

"Need concurrency for I/O"
    ↓ Use: async/await with tokio

"Need to share immutable data across threads"
    ↓ Use: Arc<T>

"Need to share mutable data across threads"
    ↓ Use: Arc<Mutex<T>> or Arc<RwLock<T>>
    ↓ Or: channels for message passing

"Need simple atomic operations"
    ↓ Use: AtomicBool, AtomicUsize, etc.
```

---

## Send/Sync Markers

| Marker | Meaning | Example |
|--------|---------|---------|
| `Send` | Can transfer ownership between threads | Most types |
| `Sync` | Can share references between threads | `Arc<T>` |
| `!Send` | Must stay on one thread | `Rc<T>` |
| `!Sync` | No shared refs across threads | `RefCell<T>` |

## Quick Reference

| Pattern | Thread-Safe | Blocking | Use When |
|---------|-------------|----------|----------|
| `std::thread` | Yes | Yes | CPU-bound parallelism |
| `async/await` | Yes | No | I/O-bound concurrency |
| `Mutex<T>` | Yes | Yes | Shared mutable state |
| `RwLock<T>` | Yes | Yes | Read-heavy shared state |
| `mpsc::channel` | Yes | Optional | Message passing |
| `Arc<Mutex<T>>` | Yes | Yes | Shared mutable across threads |

## Decision Flowchart

```
What type of work?
├─ CPU-bound → std::thread or rayon
├─ I/O-bound → async/await
└─ Mixed → hybrid (spawn_blocking)

Need to share data?
├─ No → message passing (channels)
├─ Immutable → Arc<T>
└─ Mutable →
   ├─ Read-heavy → Arc<RwLock<T>>
   └─ Write-heavy → Arc<Mutex<T>>
   └─ Simple counter → AtomicUsize

Async context?
├─ Type is Send → tokio::spawn
├─ Type is !Send → spawn_local
└─ Blocking code → spawn_blocking
```

---

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| E0277 `Send` not satisfied | Non-Send in async | Use Arc or spawn_local |
| E0277 `Sync` not satisfied | Non-Sync shared | Wrap with Mutex |
| Deadlock | Lock ordering | Consistent lock order |
| `future is not Send` | Non-Send across await | Drop before await |
| `MutexGuard` across await | Guard held during suspend | Scope guard properly |

---

## Anti-Patterns

| Anti-Pattern | Why Bad | Better |
|--------------|---------|--------|
| Arc<Mutex<T>> everywhere | Contention, complexity | Message passing |
| thread::sleep in async | Blocks executor | tokio::time::sleep |
| Holding locks across await | Blocks other tasks | Scope locks tightly |
| Ignoring deadlock risk | Hard to debug | Lock ordering, try_lock |

---

## Async-Specific Patterns

### Avoid MutexGuard Across Await

```rust
// Bad: guard held across await
let guard = mutex.lock().await;
do_async().await;  // guard still held!

// Good: scope the lock
{
    let guard = mutex.lock().await;
    // use guard
}  // guard dropped
do_async().await;
```
