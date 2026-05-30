---
name: threejs-motion-performance
description: >-
  Use this skill when adding, reviewing, or optimizing Three.js, WebGL, canvas, shaders, GPU-heavy motion, bundle impact, fallbacks, frame rate, or memory cleanup. Do not use for ordinary CSS animation, non-3D UI, or decorative effects that should be removed.
---


# threejs-motion-performance

Three.js and WebGL performance discipline. Bundle impact, mobile fallbacks, GPU budget, reduced motion, memory management.

## Purpose

Ship WebGL/3D content that's fast on real devices, has proper fallbacks, doesn't leak memory, and respects user preferences.

## When to use this

- Portfolio or landing page with 3D elements
- Any WebGL, canvas, or shader work
- Three.js scene optimization
- Evaluating whether 3D is worth the bundle cost for a given feature

## When NOT to use this

- Do not use for ordinary CSS animation, non-3D UI, or decorative effects that should be removed.

## Process

### 0. Read the UI rule reference first
Before UI work or review, read `rules/ui.md` and apply the project’s responsive, accessibility, component-state, and design-token expectations.

### 1. Bundle impact
Three.js is ~150kb gzipped. Import only what you use:
```js
import { Scene, PerspectiveCamera, WebGLRenderer } from 'three';
// NOT: import * as THREE from 'three';
```

### 2. Mobile fallback
Always provide a static fallback for devices without WebGL support or insufficient GPU power. Detect and downgrade:
```js
const gl = document.createElement('canvas').getContext('webgl');
if (!gl) { showStaticFallback(); return; }
```

### 3. GPU budget for mobile
- Draw calls: under 100
- Triangles: under 100k
- Use instanced rendering for repeated objects
- Dispose geometries, materials, textures on component unmount

### 4. Frame rate monitoring
If fps drops below 30 for 3+ seconds, automatically reduce quality (fewer particles, simpler shaders, lower resolution).

### 5. Reduced motion
For `prefers-reduced-motion: reduce`: stop all animation, show a static frame.

## Output format

```markdown
# WebGL/3D performance review — [scene/feature]

## Bundle: [kb gzipped, named imports? Y/N]
## Fallback: [present? what shows when WebGL unavailable]
## GPU budget: draw calls [n/100] · triangles [n/100k] · instancing [Y/N]
## Frame rate: [fps desktop / fps low-end mobile] · auto-downgrade [Y/N]
## Reduced motion: [respected? static frame shown?]
## Disposal: [geometries/materials/textures disposed on unmount? Y/N]
## Issues found: [list with file:line and fix]
```

## Hard rules

- Always dispose Three.js resources on unmount (memory leaks are silent killers)
- Always provide non-WebGL fallback
- Always test on a low-end mobile device or GPU-throttled DevTools
- Never ship a 3D scene without frame rate monitoring

## Connects to

- `animation-motion` — for non-WebGL motion guidelines
- `responsive-ui` — 3D scenes need responsive handling too
- `deploy-ready` — bundle size is part of deploy readiness

## Common failure modes

**Memory leaks** — Three.js doesn't garbage collect. Geometries, materials, textures need explicit `.dispose()` on unmount.

**Mobile GPU meltdown** — 60fps on MacBook, 5fps on iPhone SE. Always test low-end.

**Orphaned render loop** — `requestAnimationFrame` keeps running after the component unmounts because nobody called `cancelAnimationFrame`. The scene is invisible but still burns GPU and battery. Store the RAF id and cancel it in the cleanup function alongside `.dispose()`.
