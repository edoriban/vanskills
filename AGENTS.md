# VanSkills - AI Agent Skills

> Skills are specialized instruction sets that teach AI assistants how to work with specific frameworks, libraries, and patterns.

## Available Skills

| Skill | Description | URL |
|-------|-------------|-----|
| `ai-sdk-5` | Vercel AI SDK 5 patterns. Trigger: When building AI features... | [SKILL.md](skills/ai-sdk-5/SKILL.md) |
| `django-drf` | Django REST Framework patterns. Trigger: When implementing g... | [SKILL.md](skills/django-drf/SKILL.md) |
| `nextjs-15` | Next.js 15 App Router patterns. Trigger: When working in Nex... | [SKILL.md](skills/nextjs-15/SKILL.md) |
| `playwright` | Playwright E2E testing patterns. Trigger: When writing Playw... | [SKILL.md](skills/playwright/SKILL.md) |
| `pytest` | Pytest testing patterns for Python. Trigger: When writing or... | [SKILL.md](skills/pytest/SKILL.md) |
| `react-19` | React 19 patterns with React Compiler. Trigger: When writing... | [SKILL.md](skills/react-19/SKILL.md) |
| `skill-creator` | Creates new AI agent skills following the VanSkills spec. Tr... | [SKILL.md](skills/skill-creator/SKILL.md) |
| `skill-sync` | Syncs skill metadata to AGENTS.md Auto-invoke sections. Trig... | [SKILL.md](skills/skill-sync/SKILL.md) |
| `tailwind-4` | Tailwind CSS 4 patterns and best practices. Trigger: When st... | [SKILL.md](skills/tailwind-4/SKILL.md) |
| `typescript` | TypeScript strict patterns and best practices. Trigger: When... | [SKILL.md](skills/typescript/SKILL.md) |
| `zod-4` | Zod 4 schema validation patterns. Trigger: When creating or ... | [SKILL.md](skills/zod-4/SKILL.md) |
| `zustand-5` | Zustand 5 state management patterns. Trigger: When implement... | [SKILL.md](skills/zustand-5/SKILL.md) |

---

### Auto-invoke Skills

When performing these actions, ALWAYS invoke the corresponding skill FIRST:

| Action | Skill |
|--------|-------|
| Building AI chat features | `ai-sdk-5` |
| Generic DRF patterns | `django-drf` |
| App Router / Server Actions | `nextjs-15` |
| Writing Playwright E2E tests | `playwright` |
| Writing Python tests with pytest | `pytest` |
| Writing React components | `react-19` |
| Creating new skills | `skill-creator` |
| After creating/modifying a skill | `skill-sync` |
| Regenerate AGENTS.md Auto-invoke tables | `skill-sync` |
| Troubleshoot why a skill is missing from AGENTS.md | `skill-sync` |
| Working with Tailwind classes | `tailwind-4` |
| Writing TypeScript types/interfaces | `typescript` |
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

