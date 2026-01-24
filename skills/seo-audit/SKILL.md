---
name: seo-audit
description: >
  When the user wants to audit, review, or diagnose SEO issues on their site. 
  Trigger: When the user mentions "SEO audit", "technical SEO", "on-page SEO", "meta tags review", or asks why a site is not ranking.
license: MIT
metadata:
  author: coreyhaines31
  version: "1.0.0"
  auto_invoke: "SEO audit / Technical SEO review"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task, WebFetch
---

# SEO Audit framework

Comprehensive framework for identifying SEO issues and providing actionable recommendations to improve organic search performance.

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| Technical | Crawlability, indexation, speed (CWV), mobile-friendly | `technical-` |
| On-Page | Title tags, meta descriptions, headings, images, links | `on-page-` |
| Content | E-E-A-T signals, engagement, topical depth | `content-` |
| Reporting | Site-specific issues (SaaS, Ecom) and report format | `site-` |

## How to Use This Skill Efficiently

This skill is modular. Identify the audit area and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/seo-audit/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "Crawl", "EEAT", "metadata"):
`Grep(pattern="EEAT", path="skills/seo-audit/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed checklists:
`Read(filePath="/root/vanskills/skills/seo-audit/rules/technical-seo.md")`

## Core Principles

1. **Crawlability First**: If Google can't find it, nothing else matters.
2. **Intent Matching**: Content must answer what the user is actually searching for.
3. **E-E-A-T**: Establish Experience, Expertise, Authoritativeness, and Trustworthiness.
4. **Mobile-First**: Always audit with a mobile-first mindset.
5. **Speed as a Feature**: Core Web Vitals are both a ranking factor and a UX requirement.
