---
name: code-review
description: Comprehensive code review checklist for PRs and changes
---

# Code Review Checklist

When reviewing code, check for:

## Functionality
- [ ] Code does what it's supposed to do
- [ ] Edge cases are handled
- [ ] Error handling is appropriate
- [ ] No regressions introduced

## Code Quality
- [ ] Code is readable and self-documenting
- [ ] No unnecessary complexity
- [ ] DRY principles followed (no copy-paste)
- [ ] Functions are small and focused

## Security
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on user data
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Proper authentication/authorization checks

## Performance
- [ ] No N+1 queries
- [ ] Appropriate caching where needed
- [ ] No memory leaks
- [ ] Efficient algorithms used

## Testing
- [ ] Tests cover new functionality
- [ ] Edge cases are tested
- [ ] Tests are meaningful (not just coverage)
- [ ] All tests pass

## Documentation
- [ ] Complex logic is commented
- [ ] Public APIs are documented
- [ ] README updated if needed
