---
name: python
description: >
  Python idiomatic patterns, type hinting, and best practices.
  Trigger: When writing or refactoring Python code.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Writing or refactoring Python code"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

## When to Use

Use this skill when:
- Developing Python applications or scripts.
- Implementing backend logic, data processing, or CLI tools.
- Refactoring legacy Python code to modern standards (Python 3.10+).
- Ensuring type safety and code quality in Python projects.

---

## Critical Patterns

### Pattern 1: Type Hinting
Always use type hints for function signatures and complex variables. Use `typing` module or built-in generics (Python 3.9+).

```python
from typing import List, Optional

def get_user_names(user_ids: List[int]) -> List[str]:
    names: List[str] = []
    for uid in user_ids:
        name = fetch_name(uid)
        if name:
            names.append(name)
    return names
```

### Pattern 2: Context Managers
Use the `with` statement for resource management (files, network connections, locks) to ensure proper cleanup.

```python
def save_config(data: dict, file_path: str) -> None:
    with open(file_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4)
```

### Pattern 3: List Comprehensions & Generators
Prefer comprehensions for simple transformations, but use generators for large datasets to save memory.

```python
# List comprehension for small collections
squares = [x**2 for x in range(10)]

# Generator expression for memory efficiency
large_squares = (x**2 for x in range(1000000))
```

---

## Decision Tree

```
Multiple conditions for a value? -> Use 'match' statement (Python 3.10+)
Complex object creation?        -> Use @dataclass or Pydantic models
I/O bound task?                 -> Use asyncio (async/await)
CPU bound task?                 -> Use multiprocessing
```

---

## Code Examples

### Example 1: Modern Data Classes
Using `@dataclass` for clean data structures with type validation.

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass(frozen=True)
class User:
    id: int
    username: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)

    def display_name(self) -> str:
        return f"{self.username} ({self.id})"
```

### Example 2: Error Handling with Custom Exceptions
Defining and raising specific exceptions for better debugging.

```python
class ProcessingError(Exception):
    """Raised when data processing fails."""
    pass

def process_data(payload: dict) -> None:
    if "data" not in payload:
        raise ProcessingError("Payload missing 'data' field")
    # processing logic...
```

---

## Commands

```bash
python -m venv .venv          # Create virtual environment
source .venv/bin/activate     # Activate venv (Linux/macOS)
pip install -r requirements.txt # Install dependencies
pytest                        # Run tests
ruff check .                  # Lint code using Ruff
```

---

## Resources

- **Official Docs**: [Python 3 Documentation](https://docs.python.org/3/)
- **Style Guide**: [PEP 8](https://peps.python.org/pep-0008/)
- **Typing**: [Real Python Type Checking Guide](https://realpython.com/python-type-checking/)
