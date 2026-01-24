---
name: git-convention
description: Conventional Commits patterns with detailed body.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Creating a git commit"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

# Git Convention - Conventional Commits

This skill defines the pattern for creating git commits following the Conventional Commits specification with a detailed body as requested.

## Structure (REQUIRED)

```text
<type>(<scope>): <short summary>

- <detailed bullet point 1>
- <detailed bullet point 2>
- ...
```

## Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files

## Guidelines
1. **Summary Line**: Use the imperative, present tense: "change" not "changed" nor "changes". No period at the end.
2. **Body**: Use bullet points starting with a capital letter to describe specific changes or improvements.
3. **Scope**: Use a concise noun describing the section of the codebase (e.g., ui, auth, db, api).

## Example
```text
feat(ui): add Material Design styling to TradeChart

- Add elevation-based dark theme with surface levels for visual depth
- Add micro copies: title, subtitle, stats cards, and empty state
- Add live connection indicator chip with animated pulse
- Add chart legend with symbol colors
- Implement contrast-based separation instead of borders
```

## Trigger
- When the user asks to create a git commit.
- When preparing a pull request.
