---
name: skill-sync
description: >
  Syncs skill metadata to AGENTS.md Auto-invoke sections.
  Trigger: When updating skill metadata (metadata.scope/metadata.auto_invoke), regenerating Auto-invoke tables, or running ./bin/sync.
license: MIT
metadata:
  author: vandev
  version: "1.0"
  scope: [root]
  auto_invoke:
    - "After creating/modifying a skill"
    - "Regenerate AGENTS.md Auto-invoke tables"
    - "Troubleshoot why a skill is missing from AGENTS.md"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash
---

## Purpose

Keeps AGENTS.md Auto-invoke sections in sync with skill metadata. When you create or modify a skill, run the sync script to automatically update AGENTS.md.

## Required Skill Metadata

Each skill that should appear in Auto-invoke sections needs these fields in `metadata`.

`auto_invoke` can be either a single string **or** a list of actions:

```yaml
metadata:
  author: vandev
  version: "1.0"
  scope: [root]                                   # Which AGENTS.md to update

  # Option A: single action
  auto_invoke: "Creating/modifying components"

  # Option B: multiple actions
  # auto_invoke:
  #   - "Creating/modifying components"
  #   - "Refactoring component folder placement"
```

### Scope Values

| Scope | Updates |
|-------|---------|
| `root` | `AGENTS.md` (repo root) |

You can define custom scopes in the sync script for project-specific AGENTS.md locations.

---

## Usage

### After Creating/Modifying a Skill

```bash
./bin/sync
```

### What It Does

1. Reads all `skills/*/SKILL.md` files
2. Extracts `metadata.scope` and `metadata.auto_invoke`
3. Generates Auto-invoke tables for AGENTS.md
4. Updates the `### Auto-invoke Skills` section

---

## Example

Given this skill metadata:

```yaml
# skills/react-19/SKILL.md
metadata:
  author: vandev
  version: "1.0"
  scope: [root]
  auto_invoke: "Writing React components"
```

The sync script generates in `AGENTS.md`:

```markdown
### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| Writing React components | `react-19` |
```

---

## Commands

```bash
# Sync AGENTS.md
./bin/sync

# Dry run (show what would change)
./bin/sync --dry-run
```

---

## Checklist After Modifying Skills

- [ ] Added `metadata.scope` to new/modified skill
- [ ] Added `metadata.auto_invoke` with action description
- [ ] Ran `./bin/sync`
- [ ] Verified AGENTS.md updated correctly
