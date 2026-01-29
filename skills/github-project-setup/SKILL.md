---
name: github-project-setup
description: >
  Create GitHub Projects with issues, milestones, and link them to repositories.
  Trigger: When setting up project planning, creating issues from a README or spec, or organizing a new repository with GitHub Projects.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Creating GitHub Projects or bulk issues"
allowed-tools: Read, Bash, AskUserQuestion, Task
---

## When to Use

- Setting up a new repository with project planning
- Creating bulk issues from a README, spec, or design document
- Creating a GitHub Project board for a repository
- Organizing existing issues into a Project

## Prerequisites

GitHub CLI must have project scopes. If not, run:

```bash
gh auth refresh -s project,read:project --hostname github.com
```

Verify with:

```bash
gh auth status
# Should include scopes: project, read:project
```

## Step 0: Determine Issue Source

Before creating anything, determine WHERE to get the issues from. Ask the user if not obvious.

### Mode A: From a document (README, spec, design doc)

User says: "lee el README y crea issues", "crea issues del spec", "organiza este proyecto"

1. Read the document the user specifies (or README.md by default)
2. Extract features, modules, endpoints, schemas, and tasks
3. Break them into granular, implementable issues
4. Present a summary to the user before creating

### Mode B: Gap analysis (document vs code)

User says: "analiza qué falta", "crea issues para lo pendiente", "revisa el código y dime qué falta"

1. Read the README/spec to understand the intended scope
2. Explore the codebase to identify what already exists
3. Compare: spec vs implementation → find gaps
4. Create issues ONLY for what is missing or incomplete
5. Present the gap analysis to the user before creating

### Mode C: From user description

User says: "necesito auth, CRUD de users, y un dashboard", "crea issues para estas features"

1. Listen to the user's verbal description
2. Break it into modules and granular tasks
3. Present the proposed issues before creating

### Decision flow

```
User asks to create issues/project
  │
  ├─ Mentions a document? ─────────────── Mode A
  ├─ Says "analyze" or "what's missing"?─ Mode B
  ├─ Describes features verbally? ──────── Mode C
  └─ Unclear? ─────────────────────────── ASK the user:
       "¿De dónde obtengo las tareas?
        A) Leer un documento (README, spec)
        B) Analizar el código y detectar lo faltante
        C) Tú me describes qué necesitas"
```

### Before creating issues: ALWAYS confirm

Present a summary table to the user before creating anything:

```
Voy a crear X issues organizados en Y milestones:

| Milestone                  | Issues | Descripción               |
|----------------------------|--------|---------------------------|
| M1: Infrastructure & Auth  | 8      | Setup, DB, JWT, errors    |
| M2: Machine Inventory      | 5      | Models, repo, svc, API    |
| M3: Document Management    | 6      | Storage, versioning, API  |
| ...                        | ...    | ...                       |

¿Procedo?
```

---

## Workflow

### Step 1: Create milestones

Group issues by milestone BEFORE creating them. Each milestone represents a deliverable phase.

```bash
gh api repos/<org>/<repo>/milestones \
  -f title="M1: Infrastructure & Auth" \
  -f description="Setup, database, environment, JWT auth, error handling"
```

After creating all milestones, assign issues to them during creation (Step 2) or after:

```bash
gh issue edit <number> --milestone "M1: Infrastructure & Auth"
```

Milestone naming convention: `M<number>: <Phase Name>`

Example milestone structure:

| Milestone | Scope | Includes tests? |
|-----------|-------|-----------------|
| M1: Infrastructure & Auth | Setup, DB, config, auth, error handling | No (infra) |
| M2: Feature Module A | Models, repo, service, handlers | Yes |
| M3: Feature Module B | Models, repo, service, handlers | Yes |
| M4: Frontend | UI setup, pages per module | No (separate) |

Each feature milestone should include its corresponding integration tests.

### Step 2: Create the GitHub Project

```bash
gh project create --owner <org-or-user> --title "<Project Name>" --format json
```

Save the returned `id` (e.g., `PVT_kwDO...`) and `number` for later steps.

### Step 3: Create issues grouped by milestone

Create issues organized by milestone. Complete one milestone group before moving to the next so issue numbers are sequential per phase.

Each issue MUST include:

- **Title**: Conventional format `<type>(<scope>): <description>`
- **Body**: Detailed description with bullet points, acceptance criteria, and file paths to modify
- **Assignee**: The developer responsible
- **Milestone**: The milestone this issue belongs to

```bash
gh issue create \
  --title "feat(api): implement machine CRUD endpoints" \
  --body "- GET /api/machines (list with filters)
- POST /api/machines (create)
- PUT /api/machines/:id (update)
- DELETE /api/machines/:id (soft delete)

Files: crates/api/src/handlers/, crates/api/src/routes/" \
  --assignee <username> \
  --milestone "M2: Machine Inventory"
```

### Step 4: Add all issues to the Project

```bash
for i in $(seq <first> <last>); do
  gh project item-add <project-number> --owner <org-or-user> \
    --url "https://github.com/<org>/<repo>/issues/$i"
done
```

### Step 5: Link Project to repository

This is REQUIRED for the Project to appear in the repository's Projects tab.

```bash
REPO_ID=$(gh api repos/<org>/<repo> --jq '.node_id')
PROJECT_ID="<project-node-id>"  # The "id" field from Step 1 (PVT_kwDO...)

gh api graphql -f query='
mutation($projectId: ID!, $repositoryId: ID!) {
  linkProjectV2ToRepository(input: {projectId: $projectId, repositoryId: $repositoryId}) {
    repository { name }
  }
}' -f projectId="$PROJECT_ID" -f repositoryId="$REPO_ID"
```

### Step 6: Verify

```bash
# Verify all issues are in the Project
gh project item-list <project-number> --owner <org-or-user> --limit 100 --format json --jq '.items | length'

# Verify Project is linked to repo
gh api repos/<org>/<repo>/projects --jq '.[].name' 2>/dev/null || echo "Check Projects tab in GitHub UI"
```

## Issue Organization Pattern

Group issues by module in creation order so issue numbers are sequential per area:

| Order | Module | Example range |
|-------|--------|---------------|
| 1 | Setup & Infrastructure | #1-#3 |
| 2 | Auth & Core API | #4-#8 |
| 3 | Feature Module A (models → repo → service → handlers) | #9-#12 |
| 4 | Feature Module B | #13-#17 |
| 5 | Feature Module C | #18-#22 |
| 6 | Frontend / UI | #23-#27 |
| 7 | Integration Tests | #28-#32 |

Within each module, follow the layered order:

1. `feat(shared)`: Models and DTOs
2. `feat(db)`: Schema and migrations
3. `feat(api)`: Repository → Service → Handlers
4. `feat(web)`: UI components and pages
5. `test`: Integration tests

## Issue Body Template

```markdown
- <What to implement, bullet by bullet>
- <Acceptance criteria or expected behavior>
- <Edge cases to handle>

Files: <paths to files that will be created or modified>
```

## Commands Reference

```bash
# Create milestone
gh api repos/<org>/<repo>/milestones -f title="M1: Phase Name" -f description="Description"

# Create project
gh project create --owner <org> --title "<name>" --format json

# Create issue (with milestone)
gh issue create --title "<title>" --body "<body>" --assignee <user> --milestone "M1: Phase Name"

# Assign milestone to existing issue
gh issue edit <number> --milestone "M1: Phase Name"

# Add issue to project
gh project item-add <number> --owner <org> --url <issue-url>

# Link project to repo (GraphQL)
gh api graphql -f query='mutation($p: ID!, $r: ID!) {
  linkProjectV2ToRepository(input: {projectId: $p, repositoryId: $r}) {
    repository { name }
  }
}' -f p="<PROJECT_ID>" -f r="<REPO_ID>"

# List project items
gh project item-list <number> --owner <org> --limit 100 --format json

# View project
gh project view <number> --owner <org>
```
