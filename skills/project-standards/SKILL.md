---
name: project-standards
description: Package (pnpm) and Python (conda) management patterns.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Managing project dependencies or environments"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

# Project Standards - Package & Environment Management

This skill defines the tools used for managing packages and environments in projects following this standard.

## Package Management (Node.js)
- **Tool:** `pnpm`
- **Usage:** Use `pnpm` for all dependency management tasks (installing, adding, removing, running scripts).
- **Avoid:** Do not use `npm` or `yarn` unless explicitly required by a specific tool or workflow.

### Common Commands
- `pnpm install`: Install dependencies.
- `pnpm add <package>`: Add a new package.
- `pnpm <script>`: Run a script defined in package.json.

## Python Environment Management
- **Tool:** `conda`
- **Usage:** Use `conda` to create and manage virtual environments for Python-based components.
- **Environment Name Strategy:** Prefer project-specific names (e.g., `vanfood-env`).

### Common Commands
- `conda create -n <env-name> python=3.10`: Create the environment.
- `conda activate <env-name>`: Activate the environment.
- `conda install <package>`: Install a package via conda.
- `pip install -r requirements.txt`: Use pip within the active conda environment for specific dependencies.

## Project Automation
- **Tool:** `make` (Makefile)
- **Usage:** Use a `Makefile` in the project root to automate common tasks like environment setup, starting the development server, running tests, and managing the database.
- **Goal:** Simplify the developer experience so that a new contributor can start with a single command.

### Recommended Targets
- `make setup`: Install dependencies (pnpm) and create/update conda environment.
- `make dev`: Start the development server and any required services (e.g., Docker).
- `make db-up`: Start database containers and run migrations.
- `make test`: Run the test suite.

## Trigger
- When adding Node.js dependencies.
- When setting up or working with Python components.
- When managing project environments.
- When automating project tasks or adding a Makefile.
