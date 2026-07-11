---
name: no-inline-imports
description: >
  Keep imports at module top-level. Use when writing or editing TypeScript/JavaScript
  modules, reviewing import style, or when inline/dynamic imports appear without a
  documented circular-dependency reason.
---

# No inline imports

Always place imports at the top of the module. Avoid inline imports in function bodies, type annotations, or interface fields unless there is a strict circular-dependency reason and it is documented.

## Guardrails

- Prefer static top-level imports for readability and consistent bundling/tree-shaking.
- If a lazy/dynamic import is required (code-splitting, optional native deps), document why next to the import.
- Do not introduce inline imports purely for type-only convenience when a top-level `import type` works.
