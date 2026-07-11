---
name: typescript-exhaustive-switch
description: >
  Require exhaustive switch handling for TypeScript unions and enums. Use when writing
  or reviewing switch statements over discriminated unions, string unions, or enums.
---

# typescript-exhaustive-switch

In switch statements over discriminated unions or enums, use a `never` check in the default case so newly added variants cause compile-time failures until handled.

## Pattern

```typescript
function assertNever(x: never): never {
  throw new Error(`Unexpected value: ${String(x)}`);
}

switch (value.kind) {
  case "a":
    return handleA(value);
  case "b":
    return handleB(value);
  default:
    return assertNever(value);
}
```

## Guardrails

- Prefer exhaustive switches over long if/else chains for union discrimination.
- Do not use a silent `default` that swallows unknown variants.
