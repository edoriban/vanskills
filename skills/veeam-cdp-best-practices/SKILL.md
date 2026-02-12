---
name: veeam-cdp-best-practices
description: >
  Veeam Backup & Replication and CDP infrastructure best practices for design, configuration, and disaster recovery.
  Trigger: When designing, configuring, or reviewing Veeam backup infrastructure, CDP policies, or DR plans.
license: MIT
metadata:
  author: sickn33
  version: "1.0.0"
  auto_invoke: "Veeam backup / CDP / Disaster Recovery planning"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# Veeam CDP Best Practices

Comprehensive guide for designing, configuring, and operating Veeam Backup & Replication infrastructure with Continuous Data Protection.

## Quick Reference Table

| Priority | Category | Impact | Rule File |
|----------|----------|--------|-----------|
| 1 | Architecture & 3-2-1-1-0 | CRITICAL | `architecture-321-rule.md` |
| 2 | Repository Design & Sizing | CRITICAL | `repository-design-sizing.md` |
| 3 | Proxy & Transport Optimization | HIGH | `proxy-transport-optimization.md` |
| 4 | Job Configuration & Retention | HIGH | `job-configuration-retention.md` |
| 5 | CDP Architecture & Policies | CRITICAL | `cdp-architecture-policies.md` |
| 6 | Failover & Orchestration (VRO) | HIGH | `failover-orchestration-vro.md` |
| 7 | Security Hardening & Compliance | CRITICAL | `security-hardening-compliance.md` |

## How to Use This Skill Efficiently

This skill is modular. Instead of reading everything, identify the relevant category and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules if you aren't sure:
`Glob(pattern="skills/veeam-cdp-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "immutable", "CDP", "failover"):
`Grep(pattern="immutable", path="skills/veeam-cdp-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed guidance and examples:
`Read(filePath="/root/vanskills/skills/veeam-cdp-best-practices/rules/architecture-321-rule.md")`

## Core Principles

1. **3-2-1-1-0 Rule**: Maintain 3 copies on 2 media types, 1 offsite, 1 immutable/air-gapped, 0 SureBackup verification errors.
2. **Right-Size Components**: Proxy cores, repository storage, and network bandwidth must be sized to meet backup windows.
3. **CDP for Tier 1 Only**: Reserve Continuous Data Protection for mission-critical VMs; use standard backup for the rest.
4. **Immutability Everywhere**: Every backup copy should land on immutable storage (Hardened Linux Repo, S3 Object Lock, or tape WORM).
5. **Test Recoverability**: A backup that has never been tested is not a backup. Automate SureBackup/SureReplica and DR drills at least twice per year.
