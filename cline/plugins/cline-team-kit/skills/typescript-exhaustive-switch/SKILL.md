---
name: typescript-exhaustive-switch
description: Use exhaustive switch handling for TypeScript unions and enums so newly added variants cause compile-time failures until handled. Apply as a general coding standard.
---

# TypeScript exhaustive switch

In switch statements over discriminated unions or enums, use a `never` check in the default case so newly added variants cause compile-time failures until handled.

> Originally a **rule** in the Cursor Team Kit (`rules/typescript-exhaustive-switch.mdc`, `alwaysApply: true`). Converted to a Cline skill. To make this rule always-on in Cline, add the text above to your project's `.clinerules` file.
