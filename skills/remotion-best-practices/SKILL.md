---
name: remotion-best-practices
description: >
  Best practices for Remotion - Video creation in React.
  Trigger: When building video compositions, animations, or working with Remotion components and hooks.
license: MIT
metadata:
  author: remotion-dev
  version: "1.0.0"
  auto_invoke: "Remotion video creation / React animations"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# Remotion Best Practices

Guide for video creation in React using Remotion. This skill provides domain-specific knowledge for animations, compositions, assets, and more.

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| Animations | Fundamental animation skills, timing, easing, springs | `animations-`, `timing-` |
| Compositions | Defining compositions, stills, folders, metadata | `compositions-`, `calculate-metadata` |
| Assets | Importing/Handling images, videos, audio, fonts, Lottie | `assets-`, `images-`, `videos-`, `audio-`, `fonts-`, `lottie-` |
| Captions | Displaying, transcribing, and importing subtitles | `display-captions-`, `transcribe-captions-`, `import-srt-` |
| Layout | Tailwind, measuring text, measuring DOM nodes | `tailwind-`, `measuring-` |
| Sequencing | Delay, trim, transitions | `sequencing-`, `transitions-`, `trimming-` |

## How to Use This Skill Efficiently

This skill is modular. Instead of reading everything, identify the relevant category and read the specific rule file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/remotion-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "spring", "audio", "metadata"):
`Grep(pattern="spring", path="skills/remotion-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed code examples:
`Read(filePath="/root/vanskills/skills/remotion-best-practices/rules/animations.md")`

## Core Principles

1. **Deterministic Rendering**: Ensure your React code is deterministic. Avoid `Math.random()` or `new Date()` without seeding or using Remotion hooks.
2. **Timing Hooks**: Use `useCurrentFrame()` and `useVideoConfig()` to build components that respond to the timeline.
3. **Interpolation**: Use `interpolate()` to map frames to values like opacity, position, or scale.
4. **Sequencing**: Use `<Series>` and `<Sequence>` to organize the timeline of your video.
5. **Dynamic Metadata**: Use `calculateMetadata` for compositions that need to adjust duration or dimensions based on props.
