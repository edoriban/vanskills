---
name: git-convention
description: Conventional Commits patterns with detailed body.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Creating a git commit"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task, AskUserQuestion
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
4. **No Co-Authorship**: NEVER add `Co-Authored-By`, `Signed-off-by`, or similar trailers to commit messages.
5. **No Tool Attribution**: Do NOT include "Generated with Claude Code", "🧪 Generated with AI", or similar attribution messages in commit bodies or PR descriptions. The code speaks for itself.

## Example
```text
feat(ui): add Material Design styling to TradeChart

- Add elevation-based dark theme with surface levels for visual depth
- Add micro copies: title, subtitle, stats cards, and empty state
- Add live connection indicator chip with animated pulse
- Add chart legend with symbol colors
- Implement contrast-based separation instead of borders
```

## GitHub Issue Integration

### Starting work on an issue
When user says "start issue #X", "work on #X", "empecemos con #X", or similar:

1. Verify the issue exists and get details:
   ```bash
   gh issue view X --json number,title,body
   ```

2. Move issue to "In Progress" status in the GitHub Project:
   ```bash
   gh project item-list <project-id> --format json | jq '.items[] | select(.content.number == X)'
   gh project item-edit <project-id> --id <item-id> --field Status --value "In Progress"
   ```

3. Confirm to user:
   ```
   ✓ Trabajando en #X: [issue title]
   ```

4. All subsequent commits in this issue should reference it: `(#X)` in the commit message

### Referencing issues during development
Use GitHub's issue reference syntax in commit messages:

```text
feat(scope): add feature description (#X)

- Detail 1
- Detail 2
- Detail 3
```

The `(#X)` links the commit to the issue but does NOT close it.

### Closing issues (Flexible approach)
When user says "close issue", "finish", "cierra el issue", "complete", or similar:

1. Query all issues assigned to user in "In Progress" status:
   ```bash
   gh issue list --assignee @me --search "is:open" --json number,title
   ```

2a. **If exactly 1 In Progress**: Close it automatically
   ```bash
   git commit -m "feat(scope): complete implementation

   - Final detail
   - Summary

   closes #X"
   ```

2b. **If multiple In Progress**: Ask user which to close
   ```
   📋 You have multiple issues In Progress:
   - #3: Implement machine CRUD endpoints
   - #15: Fix critical bug in document upload

   Which one should we close?
   ```
   Once clarified, proceed with commit.

2c. **If user specifies explicitly** (e.g., "close issue #15"):
   ```bash
   git commit -m "feat(scope): complete implementation

   - Detail

   closes #15"
   ```

### Commit message format with issue closure
```text
<type>(<scope>): <summary> (#X)

- <detailed bullet point 1>
- <detailed bullet point 2>
- ...

closes #X
```

### Example workflow
```bash
# Start
You: "start issue 3"
Claude: ✓ Trabajando en #3: Implement machine CRUD endpoints

# Intermediate commits
git commit -m "feat(api): add machine model (#3)"
git commit -m "feat(api): add repository layer (#3)"

# Finish
You: "close issue"
Claude: [Only 1 In Progress, closes automatically]
git commit -m "feat(api): complete machine CRUD

- Add handlers
- Add service layer
- Complete API endpoints

closes #3"
```

### Handling interruptions
If you need to switch to another issue while one is In Progress:
```bash
You: "start issue 15 (urgent bug)"
Claude: ⚠️ #3 is still In Progress. Moving to Todo?
You: "yes" or "no, keep it"
Claude: ✓ Now working on #15
# #3 stays In Progress until explicitly closed
```

## Trigger
- When the user asks to create a git commit.
- When working on GitHub issues (start, reference, close).
- When preparing a pull request.
