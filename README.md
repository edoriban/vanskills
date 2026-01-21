# VanSkills

> AI Agent Skills by edoriban - Portable, reusable instruction sets for AI coding assistants.

Skills are specialized instruction sets that teach AI assistants (Claude Code, OpenCode, Gemini CLI, Codex, GitHub Copilot) how to work with specific frameworks, libraries, and patterns. They provide on-demand context so the AI writes code following best practices and conventions.

## Quick Start

### One-liner (Recommended)

From your project directory, run:

```bash
curl -fsSL https://raw.githubusercontent.com/edoriban/vanskills/main/install.sh | bash
```

This will:
1. Clone vanskills to `~/vanskills` (or update if exists)
2. Ask which AI assistants you use
3. Create symlinks to the skills
4. Copy the config files (CLAUDE.md, AGENTS.md, etc.)

### Non-interactive installation

```bash
# Install for Claude only
curl -fsSL https://raw.githubusercontent.com/edoriban/vanskills/main/install.sh | VANSKILLS_ASSISTANT=claude bash

# Install for all AI assistants
curl -fsSL https://raw.githubusercontent.com/edoriban/vanskills/main/install.sh | VANSKILLS_ASSISTANT=all bash

# Custom vanskills location
curl -fsSL https://raw.githubusercontent.com/edoriban/vanskills/main/install.sh | VANSKILLS_DIR=~/my-skills bash
```

### Manual installation

```bash
# Clone repository
git clone https://github.com/edoriban/vanskills.git ~/vanskills

# Install in your project
cd ~/your-project
~/vanskills/bin/install
```

## Available Skills

| Skill | Description |
|-------|-------------|
| `typescript` | TypeScript strict patterns, const types, utility types |
| `react-19` | React 19 patterns with React Compiler, no manual memoization |
| `nextjs-15` | Next.js 15 App Router, Server Actions, streaming |
| `tailwind-4` | Tailwind CSS 4 patterns, cn() utility, no var() in className |
| `pytest` | Python pytest patterns, fixtures, mocking, parametrize |
| `playwright` | E2E testing, Page Object Model, MCP workflow |
| `zod-4` | Zod 4 schema validation, v3->v4 migration |
| `zustand-5` | Zustand 5 state management, selectors, persist |
| `ai-sdk-5` | Vercel AI SDK 5, chat, streaming, tools |
| `django-drf` | Django REST Framework patterns |
| `skill-creator` | Create new skills following the VanSkills spec |
| `skill-sync` | Sync skill metadata to AGENTS.md |

## Commands

### Install skills to a project

```bash
# Interactive mode (current directory)
./bin/install

# Specify target directory
./bin/install --target ~/my-project

# Install for specific AI assistants
./bin/install --claude --codex

# Install for all AI assistants
./bin/install --all

# Copy files instead of symlinks
./bin/install --copy
```

### Sync AGENTS.md after modifying skills

```bash
./bin/sync

# Dry run (preview changes)
./bin/sync --dry-run
```

## Creating New Skills

1. **Copy the template:**
   ```bash
   cp templates/SKILL_TEMPLATE.md skills/my-skill/SKILL.md
   ```

2. **Edit your skill** with patterns, examples, and commands

3. **Add metadata** for auto-invoke:
   ```yaml
   metadata:
     author: edoriban
     version: "1.0"
     scope: [root]
     auto_invoke: "Action that triggers this skill"
   ```

4. **Sync to register:**
   ```bash
   ./bin/sync
   ```

## Skill Structure

```
skills/{skill-name}/
├── SKILL.md              # Required - main skill file
├── assets/               # Optional - templates, schemas
└── references/           # Optional - links to docs
```

## How It Works

### Symlink Magic

When you run `./bin/install`, it creates symlinks from your project to this repository:

```
your-project/
├── .claude/
│   └── skills -> ~/vanskills/skills  (symlink)
├── CLAUDE.md                          (copy of AGENTS.md)
└── ...
```

**Benefits:**
- Update a skill here, and ALL your projects get the update instantly
- No need to re-run install after updates
- Keep your skills in sync across all projects

### Auto-invoke

Each skill has an `auto_invoke` field that tells AI assistants when to load it:

```yaml
auto_invoke: "Writing React components"
```

When you ask the AI to write a React component, it automatically loads the `react-19` skill.

## AI Assistant Support

| Assistant | Config Dir | Config File |
|-----------|------------|-------------|
| Claude Code | `.claude/` | `CLAUDE.md` |
| OpenCode | `.codex/` | `AGENTS.md` |
| Gemini CLI | `.gemini/` | `GEMINI.md` |
| Codex (OpenAI) | `.codex/` | `AGENTS.md` |
| GitHub Copilot | `.github/` | `copilot-instructions.md` |

## License

MIT License - Use freely, contribute back!

---

Made with care by [edoriban](https://github.com/edoriban)
