---
name: debug
description: Systematic debugging workflow for tracking down issues
disable-model-invocation: true
---

# Debug Issue: $ARGUMENTS

Follow this systematic approach:

## 1. Reproduce the Issue
- Get exact steps to reproduce
- Note the expected vs actual behavior
- Identify any error messages or stack traces

## 2. Gather Information
- Check logs for relevant errors
- Review recent changes (git log, git diff)
- Check if issue is environment-specific

## 3. Form Hypotheses
- List 2-3 most likely causes
- Rank by probability

## 4. Test Hypotheses
For each hypothesis:
1. Add targeted logging/debugging
2. Make a small test change
3. Verify if it explains the behavior

## 5. Find Root Cause
- Don't fix symptoms, find the actual cause
- Understand WHY the bug happened
- Check for similar bugs elsewhere

## 6. Implement Fix
- Make the minimum change needed
- Write a test that would have caught this
- Ensure test fails without fix, passes with fix

## 7. Verify Fix
- Reproduce original issue (should be fixed)
- Run full test suite
- Check for regressions

## 8. Document
- Add comments if the fix isn't obvious
- Update any relevant documentation
- Consider if this warrants a post-mortem
