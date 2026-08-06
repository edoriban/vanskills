# VanSkills - AI Agent Skills

> Skills are specialized instruction sets that teach AI assistants how to work with specific frameworks, libraries, and patterns.

## Available Skills

| Skill | Description | URL |
|-------|-------------|-----|
| `api-security-best-practices` | Implement secure API design patterns including authenticatio... | [SKILL.md](skills/api-security-best-practices/SKILL.md) |
| `efficientad` | Anomaly detection patterns using EfficientAD for industrial ... | [SKILL.md](skills/efficientad/SKILL.md) |
| `executing` | Harness, loop, and adversarial-verification rules — the scaf... | [SKILL.md](skills/executing/SKILL.md) |
| `fastapi` | FastAPI patterns for async APIs with Pydantic v2, dependency... | [SKILL.md](skills/fastapi/SKILL.md) |
| `frontend-design` | Create distinctive, production-grade frontend interfaces wit... | [SKILL.md](skills/frontend-design/SKILL.md) |
| `git-convention` | Conventional Commits patterns with detailed body. Trigger: W... | [SKILL.md](skills/git-convention/SKILL.md) |
| `github-project-setup` | Create GitHub Projects with issues, milestones, and link the... | [SKILL.md](skills/github-project-setup/SKILL.md) |
| `gqty-best-practices` | GQty GraphQL proxy client best practices for queries, mutati... | [SKILL.md](skills/gqty-best-practices/SKILL.md) |
| `marketing-psychology` | When the user wants to apply psychological principles, menta... | [SKILL.md](skills/marketing-psychology/SKILL.md) |
| `nextjs-16` | Next.js 16 App Router patterns. Trigger: When working in Nex... | [SKILL.md](skills/nextjs-16/SKILL.md) |
| `playwright` | Playwright E2E testing patterns. Trigger: When writing Playw... | [SKILL.md](skills/playwright/SKILL.md) |
| `project-standards` | Package (pnpm) and Python (conda) management patterns. Trigg... | [SKILL.md](skills/project-standards/SKILL.md) |
| `prompting` | Prompt engineering and context engineering rules — how to wo... | [SKILL.md](skills/prompting/SKILL.md) |
| `pytest` | Pytest testing patterns for Python. Trigger: When writing or... | [SKILL.md](skills/pytest/SKILL.md) |
| `python` | Python idiomatic patterns, type hinting, and best practices.... | [SKILL.md](skills/python/SKILL.md) |
| `react-19` | React 19 patterns with React Compiler. Trigger: When writing... | [SKILL.md](skills/react-19/SKILL.md) |
| `react-native-design` | Master React Native styling, navigation, animations, and app... | [SKILL.md](skills/react-native-design/SKILL.md) |
| `rust` | Expert Rust programming patterns, idiomatic practices, and m... | [SKILL.md](skills/rust/SKILL.md) |
| `sdd-apply` | Implement tasks from the change, writing actual code followi... | [SKILL.md](skills/sdd-apply/SKILL.md) |
| `sdd-archive` | Sync delta specs to main specs and archive a completed chang... | [SKILL.md](skills/sdd-archive/SKILL.md) |
| `sdd-design` | Create technical design document with architecture decisions... | [SKILL.md](skills/sdd-design/SKILL.md) |
| `sdd-explore` | Explore and investigate ideas before committing to a change.... | [SKILL.md](skills/sdd-explore/SKILL.md) |
| `sdd-init` | Initialize Spec-Driven Development context in any project. D... | [SKILL.md](skills/sdd-init/SKILL.md) |
| `sdd-orchestrator` | SDD Orchestrator — coordinates Spec-Driven Development phase... | [SKILL.md](skills/sdd-orchestrator/SKILL.md) |
| `sdd-propose` | Create a change proposal with intent, scope, and approach. T... | [SKILL.md](skills/sdd-propose/SKILL.md) |
| `sdd-spec` | Write specifications with requirements and scenarios (delta ... | [SKILL.md](skills/sdd-spec/SKILL.md) |
| `sdd-tasks` | Break down a change into an implementation task checklist. T... | [SKILL.md](skills/sdd-tasks/SKILL.md) |
| `sdd-verify` | Validate that implementation matches specs, design, and task... | [SKILL.md](skills/sdd-verify/SKILL.md) |
| `seo-audit` | When the user wants to audit, review, or diagnose SEO issues... | [SKILL.md](skills/seo-audit/SKILL.md) |
| `skill-creator` | Creates new AI agent skills following the VanSkills spec. Tr... | [SKILL.md](skills/skill-creator/SKILL.md) |
| `skill-sync` | Syncs skill metadata to AGENTS.md Auto-invoke sections. Trig... | [SKILL.md](skills/skill-sync/SKILL.md) |
| `supabase-postgres-best-practices` | Postgres performance optimization and best practices from Su... | [SKILL.md](skills/supabase-postgres-best-practices/SKILL.md) |
| `tailwind-4` | Tailwind CSS 4 patterns and best practices. Trigger: When st... | [SKILL.md](skills/tailwind-4/SKILL.md) |
| `tdd` | Test-driven development discipline: RED/GREEN/REFACTOR cycle... | [SKILL.md](skills/tdd/SKILL.md) |
| `threejs-best-practices` | A curated collection of Three.js foundational knowledge for ... | [SKILL.md](skills/threejs-best-practices/SKILL.md) |
| `typescript` | TypeScript strict patterns and best practices. Trigger: When... | [SKILL.md](skills/typescript/SKILL.md) |
| `ui-ux-pro-max` | UI/UX design intelligence with searchable database. Comprehe... | [SKILL.md](skills/ui-ux-pro-max/SKILL.md) |
| `vercel-react-best-practices` | React and Next.js performance optimization guidelines from V... | [SKILL.md](skills/vercel-react-best-practices/SKILL.md) |
| `vitest` | Vitest testing patterns for TypeScript/JavaScript (mocking, ... | [SKILL.md](skills/vitest/SKILL.md) |
| `workspace-setup` | Configura el espacio de trabajo de zellij de un proyecto (de... | [SKILL.md](skills/workspace-setup/SKILL.md) |
| `yolo` | Computer vision patterns for object detection, segmentation,... | [SKILL.md](skills/yolo/SKILL.md) |
| `zod-4` | Zod 4 schema validation patterns. Trigger: When creating or ... | [SKILL.md](skills/zod-4/SKILL.md) |
| `zustand-5` | Zustand 5 state management patterns. Trigger: When implement... | [SKILL.md](skills/zustand-5/SKILL.md) |

---

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| Designing or exposing an API endpoint (REST, GraphQL, WebSocket) | `api-security-best-practices` |
| Adding authentication or authorization to an API | `api-security-best-practices` |
| Reviewing an API for security issues | `api-security-best-practices` |
| Implementing anomaly detection models using EfficientAD | `efficientad` |
| Designing an agent loop, verification gate, or multi-agent workflow | `executing` |
| Writing FastAPI endpoints, dependencies, or API tests | `fastapi` |
| Building a web page, landing page, or dashboard UI | `frontend-design` |
| Styling or beautifying an existing web interface | `frontend-design` |
| Creating a git commit | `git-convention` |
| Creating GitHub Projects or bulk issues | `github-project-setup` |
| Writing GQty queries or mutations | `gqty-best-practices` |
| Configuring GQty caching, SSR, or code generation | `gqty-best-practices` |
| Writing marketing copy that has to persuade | `marketing-psychology` |
| Applying cognitive biases or behavioral science to a campaign | `marketing-psychology` |
| App Router / Server Actions | `nextjs-16` |
| Writing Playwright E2E tests | `playwright` |
| Managing project dependencies or environments | `project-standards` |
| Writing or revising a prompt, skill, CLAUDE.md, or sub-agent brief | `prompting` |
| Writing Python tests with pytest | `pytest` |
| Writing or refactoring Python code | `python` |
| Writing React components | `react-19` |
| Styling a React Native screen or component | `react-native-design` |
| Setting up React Navigation or Reanimated animations | `react-native-design` |
| Architecting a React Native app (native modules, EAS, offline-first) | `react-native-design` |
| Writing or refactoring Rust code | `rust` |
| Debugging a borrow checker, lifetime, or Cargo error | `rust` |
| Implementing the tasks of an SDD change (/sdd-apply) | `sdd-apply` |
| Archiving a completed SDD change (/sdd-archive) | `sdd-archive` |
| Writing the technical design of an SDD change (design phase) | `sdd-design` |
| Exploring an idea before an SDD change (/sdd-explore) | `sdd-explore` |
| Initializing SDD in a project (/sdd-init) | `sdd-init` |
| Starting structured planning for a substantial change (/sdd-new, /sdd-continue, /sdd-ff) | `sdd-orchestrator` |
| Writing the proposal of an SDD change (propose phase) | `sdd-propose` |
| Writing the specs of an SDD change (spec phase) | `sdd-spec` |
| Breaking an SDD change into tasks (tasks phase) | `sdd-tasks` |
| Verifying a completed SDD change (/sdd-verify) | `sdd-verify` |
| Auditing a site for SEO issues | `seo-audit` |
| Reviewing meta tags, headings, or site structure for search | `seo-audit` |
| Creating new skills | `skill-creator` |
| After creating/modifying a skill | `skill-sync` |
| Regenerate AGENTS.md Auto-invoke tables | `skill-sync` |
| Troubleshoot why a skill is missing from AGENTS.md | `skill-sync` |
| Writing or optimizing a Postgres query | `supabase-postgres-best-practices` |
| Designing a Postgres schema, index, or RLS policy | `supabase-postgres-best-practices` |
| Working with Tailwind classes | `tailwind-4` |
| Implementing code with tests, fixing bugs, or sdd-apply TDD mode | `tdd` |
| Creating a Three.js scene, lighting, or materials | `threejs-best-practices` |
| Loading GLTF models or writing shaders | `threejs-best-practices` |
| Optimizing Three.js performance | `threejs-best-practices` |
| Writing TypeScript types/interfaces | `typescript` |
| Choosing a design system, color palette, or font pairing | `ui-ux-pro-max` |
| Prototyping a new UI screen or flow | `ui-ux-pro-max` |
| Optimizing React or Next.js rendering performance | `vercel-react-best-practices` |
| Reviewing data fetching or bundle size in a Next.js app | `vercel-react-best-practices` |
| Writing JS/TS tests with Vitest | `vitest` |
| Agregar un proyecto al comando `work` | `workspace-setup` |
| Crear o modificar un layout de zellij (dev.kdl) | `workspace-setup` |
| Implementing computer vision models using YOLO | `yolo` |
| Creating Zod schemas | `zod-4` |
| Using Zustand stores | `zustand-5` |

---

## Installation

```bash
# Clone vanskills (if not already)
git clone https://github.com/edoriban/vanskills.git ~/vanskills

# Once, for every project: symlinks each skill into ~/.claude/skills
~/vanskills/bin/install --global

# Or per project, from the target directory
~/vanskills/bin/install
```

Undo the user-level install with `~/vanskills/bin/install --global-uninstall`.

## Creating New Skills

1. Copy template: `cp templates/SKILL_TEMPLATE.md skills/my-skill/SKILL.md`
2. Edit the skill with your patterns
3. Run `./bin/sync` to update AGENTS.md

---

Made with care by [edoriban](https://github.com/edoriban)

