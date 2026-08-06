---
name: react-native-design
description: >
  Master React Native styling, navigation, animations, and app architecture (auth, native modules, offline-first) for cross-platform mobile development.
  Trigger: When building or architecting React Native apps, implementing navigation, native modules, offline sync, or performant animations.
license: MIT
metadata:
  author: edoriban
  version: "1.1"
  scope: [root]
  auto_invoke:
    - "Styling a React Native screen or component"
    - "Setting up React Navigation or Reanimated animations"
    - "Architecting a React Native app (native modules, EAS, offline-first)"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, WebFetch, WebSearch, Task
---

# React Native Design & Interaction

Comprehensive guide for mobile UI/UX development using React Native, Reanimated, and React Navigation.

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| Styling | StyleSheet, dynamic styles, platform selection | `styling-` |
| Layout | Flexbox, gap, centering, safe areas | `layout-` |
| Navigation | Stack, Tab, Drawer navigators (React Nav 6+) | `navigation-` |
| Animation | Reanimated 3, shared values, spring/timing | `animations-` |
| Gestures | Pan, Tap, Pinch gestures with Gesture Handler | `gestures-` |
| Setup | Project structure, CLI commands, decision trees | `project-` |
| Auth | Authentication flows, SecureStore, protected routes | `auth-` |
| Data | React Query, offline persistence, optimistic UI | `data-` |
| Native | Native modules, EAS Build, high-performance lists | `native-` |

## How to Use This Skill Efficiently

This skill is modular. Identify the design area and read the specific file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/react-native-design/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "flex", "spring", "stack"):
`Grep(pattern="spring", path="skills/react-native-design/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed code examples:
`Read(filePath="/root/vanskills/skills/react-native-design/rules/animations-gestures.md")`

## Core Principles

1. **Native Performance**: Run animations on the UI thread using Reanimated worklets.
2. **Platform Specifics**: Use `Platform.select` or `.ios/.android` extensions for platform-tailored UX.
3. **Consistent Styling**: Always use `StyleSheet.create` for performance and maintainability.
4. **Responsive Layouts**: Leverage Flexbox and `useWindowDimensions` for cross-device support.
5. **Stable Interactions**: Use `GestureDetector` for complex, high-performance touch interactions.
