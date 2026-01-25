---
name: threejs-best-practices
description: >
  A curated collection of Three.js foundational knowledge for creating 3D elements and interactive experiences. Includes geometry, materials, lighting, animation, and shaders.
  Trigger: When asking to create a 3D scene, add lighting, load models (GLTF), use shaders, or optimize Three.js performance.
license: MIT
metadata:
  author: pinkforest
  version: "1.0.0"
  auto_invoke: "Three.js scene / 3D development / WebGL"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Task
---

# Three.js Best Practices

Accurate API references, working code examples, and performance optimization tips for Three.js (r160+).

## Quick Reference Table

| Category | Description | Prefix |
|----------|-------------|--------|
| Core | Scene setup, cameras, renderer, hierarchy | `fundamentals-` |
| Objects | Geometry types, materials (PBR/Standard), textures | `geometry-`, `materials-`, `textures-` |
| Environment | Lighting types, shadows, helpers | `lighting-` |
| Dynamic | Keyframe animation, interaction (raycasting) | `animation-`, `interaction-` |
| Assets | Loaders (GLTF/GLB), texture loading | `loaders-` |
| Advanced | Shaders (GLSL), post-processing effects | `shaders-`, `postprocessing-` |

## How to Use This Skill Efficiently

This skill is modular. Identify the relevant topic and read the specific rule file in the `rules/` directory.

### Step 1: Find Relevant Rules
Use `Glob` to list available rules:
`Glob(pattern="skills/threejs-best-practices/rules/*.md")`

### Step 2: Search for Keywords
Use `Grep` to find rules related to your task (e.g., "shadow", "gltf", "shader"):
`Grep(pattern="shadow", path="skills/threejs-best-practices/rules")`

### Step 3: Read Specific Rule
Once identified, read the full rule for detailed API usage:
`Read(filePath="/root/vanskills/skills/threejs-best-practices/rules/lighting.md")`

## Core Principles

1. **Hierarchy**: Use `THREE.Group` to organize objects and `scene.add()` to assemble the world.
2. **Animation Loop**: Use `requestAnimationFrame` and `THREE.Clock` for smooth, framerate-independent animation.
3. **Responsive**: Always handle window resize events to update camera aspect and renderer size.
4. **Performance**: Reuse geometries and materials; use `instancing` for many similar objects.
5. **Modern Syntax**: Use ES modules (`import * as THREE from 'three'`) and modern JS features.
