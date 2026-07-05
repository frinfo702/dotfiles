---
name: no-inline-imports
description: Keep imports at the top of the module and avoid inline imports in function bodies, type annotations, or interface fields. Apply as a general coding standard.
---

# No inline imports

Always place imports at the top of the module. Avoid inline imports in function bodies, type annotations, or interface fields unless there is a strict circular-dependency reason and it is documented.

> Originally a **rule** in the Cursor Team Kit (`rules/no-inline-imports.mdc`, `alwaysApply: true`). Converted to a Cline skill. To make this rule always-on in Cline, add the text above to your project's `.clinerules` file.
