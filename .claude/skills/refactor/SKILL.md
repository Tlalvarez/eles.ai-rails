---
name: refactor
description: Safe refactoring workflow with continuous verification
disable-model-invocation: true
---

# Refactor: $ARGUMENTS

Follow this safe refactoring process:

## Pre-Refactor Checklist
- [ ] Tests exist for the code being refactored
- [ ] All tests are currently passing
- [ ] You understand what the code does
- [ ] You have a clear goal for the refactor

## Refactoring Steps

### 1. Ensure Test Coverage
```bash
# Run existing tests first
[your-test-command]
```
If tests are missing, write them BEFORE refactoring.

### 2. Small, Incremental Changes
- Make ONE change at a time
- Run tests after EACH change
- Commit working states frequently

### 3. Common Refactoring Patterns
- Extract function/method
- Rename for clarity
- Remove duplication
- Simplify conditionals
- Break up large functions

### 4. Maintain Behavior
- No functional changes during refactoring
- Same inputs should produce same outputs
- Preserve public API signatures

### 5. Verify After Each Step
```bash
# After each change:
[your-test-command]
[your-lint-command]
[your-typecheck-command]
```

## Post-Refactor
- [ ] All tests still pass
- [ ] No new linting errors
- [ ] Code is more readable/maintainable
- [ ] No functionality was accidentally changed
- [ ] Commit with clear message explaining the refactor
