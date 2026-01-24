---
name: api-security-best-practices
description: >
  Implement secure API design patterns including authentication, authorization, input validation, rate limiting, and protection against common API vulnerabilities.
  Trigger: When designing, securing, or reviewing API endpoints (REST, GraphQL, WebSocket).
license: MIT
metadata:
  author: sickn33
  version: "1.0.0"
  auto_invoke: "API Security / Authentication"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# API Security Best Practices

Comprehensive guide for building secure APIs, implementing authentication, authorization, input validation, and rate limiting.

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| Authentication | JWT, Refresh tokens, Middleware, Secure storage | `auth-` |
| Validation | Input sanitization, Zod schemas, SQLi prevention | `input-` |
| Protection | Rate limiting, DDoS, Helmet, Security headers | `rate-` |
| Audit | Checklists, OWASP Top 10, Common pitfalls | `security-` |

## How to Use This Skill Efficiently

This skill is modular. Identify the relevant security area and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/api-security-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "JWT", "SQL", "limit"):
`Grep(pattern="JWT", path="skills/api-security-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed code examples:
`Read(filePath="/root/vanskills/skills/api-security-best-practices/rules/auth-jwt-implementation.md")`

## Core Principles

1. **Least Privilege**: Grant minimum permissions required; never use superuser for apps.
2. **Never Trust Input**: Always validate and sanitize all data coming from the client.
3. **Defense in Depth**: Use multiple layers of security (WAF, rate limiting, RLS, encryption).
4. **Secure Defaults**: Use secure-by-default libraries and configurations.
5. **Continuous Audit**: Regularly test against OWASP Top 10 and update dependencies.
