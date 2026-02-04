---
name: new-feature
description: Implement a new feature with proper planning and testing
disable-model-invocation: true
---

# Implement New Feature: $ARGUMENTS

Follow this structured approach:

## Phase 1: Research
1. Understand the feature requirements
2. Search for similar patterns in the codebase
3. Identify files that will need changes
4. List any dependencies or prerequisites

## Phase 2: Plan
1. Break down the implementation into steps
2. Identify potential edge cases
3. Plan the testing strategy
4. Consider backwards compatibility

## Phase 3: Implement
1. Create a feature branch
   ```bash
   git checkout -b feature/$ARGUMENTS
   ```

2. Write tests first (TDD approach)
   - Unit tests for new functions
   - Integration tests for the feature flow

3. Implement the feature
   - Follow existing code patterns
   - Keep changes focused and atomic
   - Add appropriate error handling

4. Update documentation if needed

## Phase 4: Verify
1. Run all tests
2. Run linting and type checking
3. Manual testing if applicable
4. Review your own changes

## Phase 5: Submit
1. Commit with descriptive message
2. Push the branch
3. Create a PR with:
   - Summary of changes
   - Test plan
   - Screenshots if UI changes
