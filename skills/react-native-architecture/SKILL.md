---
name: react-native-architecture
description: >
  Build production React Native apps with Expo, navigation, native modules, offline sync, and cross-platform patterns.
  Trigger: When developing mobile apps, implementing native integrations, or architecting React Native projects.
license: MIT
metadata:
  author: edoriban
  version: "1.0"
  scope: [root]
  auto_invoke: "Expo Router / Native modules / Offline-first mobile"
  dependencies:
    - typescript
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

# React Native Architecture

Comprehensive guide for building production-grade mobile applications using Expo and React Native.

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| Setup | Project structure, CLI commands, decision trees | `project-` |
| Navigation | Expo Router, Tab navigation, Deep linking | `expo-` |
| Auth | Authentication flows, SecureStore, protected routes | `auth-` |
| Data | React Query, offline persistence, optimistic UI | `data-` |
| Native | Native modules, EAS Build, high-performance lists | `native-` |

## How to Use This Skill Efficiently

This skill is modular. Identify the architectural area and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/react-native-architecture/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "router", "offline", "secure"):
`Grep(pattern="router", path="skills/react-native-architecture/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed code examples:
`Read(filePath="/root/vanskills/skills/react-native-architecture/rules/expo-router-navigation.md")`

## Core Principles

1. **Expo First**: Prefer Expo SDK and EAS for faster development and easier maintenance.
2. **File-based Routing**: Use Expo Router for intuitive and scalable navigation.
3. **Offline-First**: Architect data fetching with persistence and optimistic updates.
4. **Platform Native**: Use native thread for animations (Reanimated) and native modules for platform features.
5. **Typed Development**: Ensure strict TypeScript usage for navigation params and component props.
