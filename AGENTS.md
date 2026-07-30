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
| `git-convention` | Conventional Commits patterns with detailed body. | [SKILL.md](skills/git-convention/SKILL.md) |
| `github-project-setup` | Create GitHub Projects with issues, milestones, and link the... | [SKILL.md](skills/github-project-setup/SKILL.md) |
| `gqty-best-practices` | GQty GraphQL proxy client best practices for queries, mutati... | [SKILL.md](skills/gqty-best-practices/SKILL.md) |
| `marketing-psychology` | When the user wants to apply psychological principles, menta... | [SKILL.md](skills/marketing-psychology/SKILL.md) |
| `nextjs-16` | Next.js 16 App Router patterns. Trigger: When working in Nex... | [SKILL.md](skills/nextjs-16/SKILL.md) |
| `playwright` | Playwright E2E testing patterns. Trigger: When writing Playw... | [SKILL.md](skills/playwright/SKILL.md) |
| `project-standards` | Package (pnpm) and Python (conda) management patterns. | [SKILL.md](skills/project-standards/SKILL.md) |
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
| `yolo` | Computer vision patterns for object detection, segmentation,... | [SKILL.md](skills/yolo/SKILL.md) |
| `zod-4` | Zod 4 schema validation patterns. Trigger: When creating or ... | [SKILL.md](skills/zod-4/SKILL.md) |
| `zustand-5` | Zustand 5 state management patterns. Trigger: When implement... | [SKILL.md](skills/zustand-5/SKILL.md) |

---

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| API Security / Authentication | `api-security-best-practices` |
| Implementing anomaly detection models using EfficientAD | `efficientad` |
| Designing an agent loop, verification gate, or multi-agent workflow | `executing` |
| Writing FastAPI endpoints, dependencies, or API tests | `fastapi` |
| UI design / Web beautification / Frontend layout | `frontend-design` |
| Creating a git commit | `git-convention` |
| Creating GitHub Projects or bulk issues | `github-project-setup` |
| GQty / GraphQL proxy client | `gqty-best-practices` |
| Marketing psychology / Behavioral science | `marketing-psychology` |
| App Router / Server Actions | `nextjs-16` |
| Writing Playwright E2E tests | `playwright` |
| Managing project dependencies or environments | `project-standards` |
| Writing or revising a prompt, skill, CLAUDE.md, or sub-agent brief | `prompting` |
| Writing Python tests with pytest | `pytest` |
| Writing or refactoring Python code | `python` |
| Writing React components | `react-19` |
| React Native styling / React Navigation / Reanimated animations / Native modules / EAS / Offline-first mobile / RN architecture | `react-native-design` |
| Writing or refactoring Rust code | `rust` |
| SDD implementation and code writing | `sdd-apply` |
| SDD archival and spec merging | `sdd-archive` |
| SDD technical design creation | `sdd-design` |
| SDD exploration and codebase investigation | `sdd-explore` |
| SDD initialization and project setup | `sdd-init` |
| SDD orchestration and structured development workflow | `sdd-orchestrator` |
| SDD change proposal creation | `sdd-propose` |
| SDD specification writing | `sdd-spec` |
| SDD task breakdown creation | `sdd-tasks` |
| SDD verification and quality gate | `sdd-verify` |
| SEO audit / Technical SEO review | `seo-audit` |
| Creating new skills | `skill-creator` |
| After creating/modifying a skill | `skill-sync` |
| Regenerate AGENTS.md Auto-invoke tables | `skill-sync` |
| Troubleshoot why a skill is missing from AGENTS.md | `skill-sync` |
| Postgres performance / Supabase | `supabase-postgres-best-practices` |
| Working with Tailwind classes | `tailwind-4` |
| Implementing code with tests, fixing bugs, or sdd-apply TDD mode | `tdd` |
| Three.js scene / 3D development / WebGL | `threejs-best-practices` |
| Writing TypeScript types/interfaces | `typescript` |
| UI/UX design / Design System / Prototyping | `ui-ux-pro-max` |
| React performance / Next.js optimization | `vercel-react-best-practices` |
| Writing JS/TS tests with Vitest | `vitest` |
| Implementing computer vision models using YOLO | `yolo` |
| Creating Zod schemas | `zod-4` |
| Using Zustand stores | `zustand-5` |

---

## Installation

To install these skills in any project:

```bash
# Clone vanskills (if not already)
git clone https://github.com/edoriban/vanskills.git ~/vanskills

# Run install script from target project
~/vanskills/bin/install
```

## Creating New Skills

1. Copy template: `cp templates/SKILL_TEMPLATE.md skills/my-skill/SKILL.md`
2. Edit the skill with your patterns
3. Run `./bin/sync` to update AGENTS.md

---

Made with care by [edoriban](https://github.com/edoriban)

