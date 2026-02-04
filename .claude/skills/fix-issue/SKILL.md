---
name: fix-issue
description: Fix a GitHub issue end-to-end with Rails best practices
disable-model-invocation: true
---

# Fix GitHub Issue: $ARGUMENTS

Follow this workflow to fix the issue:

## 1. Get Issue Details
```bash
gh issue view $ARGUMENTS
gh issue view $ARGUMENTS --comments  # Check for additional context
```

## 2. Create a Feature Branch
```bash
git checkout -b fix/$ARGUMENTS-brief-description
```

## 3. Understand the Problem
- Read the issue description carefully
- Check for related issues: `gh issue list --search "related terms"`
- Check for related PRs: `gh pr list --search "related terms"`
- Identify acceptance criteria

## 4. Find Relevant Code
- Search the codebase for related files
- Check `app/models/`, `app/controllers/`, `app/services/`
- Review `config/routes.rb` if it's a routing issue
- Check `db/schema.rb` for data model context

## 5. Write a Failing Test
```bash
# Create test that reproduces the issue
# For model issues: test/models/ or spec/models/
# For controller issues: test/controllers/ or spec/requests/
# For integration: test/integration/ or spec/features/

# Run the specific test to confirm it fails
bin/rails test test/path/to_test.rb
# or
bundle exec rspec spec/path/to_spec.rb
```

## 6. Implement the Fix
- Make the minimum changes needed
- Follow Rails conventions
- Keep the fix focused
- Add appropriate validations/error handling

## 7. Verify the Fix
```bash
# Run the new test (should pass now)
bin/rails test test/path/to_test.rb

# Run full test suite
bin/rails test

# Run linting
bundle exec rubocop

# If database changes, test migration rollback
bin/rails db:rollback && bin/rails db:migrate
```

## 8. Commit and Push
```bash
git add -A
git commit -m "Fix #$ARGUMENTS: Brief description of the fix

- Detailed change 1
- Detailed change 2

Fixes #$ARGUMENTS"

git push -u origin fix/$ARGUMENTS-brief-description
```

## 9. Create PR
```bash
gh pr create --title "Fix #$ARGUMENTS: Brief description" --body "$(cat <<'EOF'
## Summary
Brief description of what was fixed and why.

## Changes
- Change 1
- Change 2

## Test Plan
- [ ] Added/updated tests
- [ ] All tests pass
- [ ] Rubocop passes
- [ ] Manually verified (if applicable)

Fixes #$ARGUMENTS
EOF
)"
```

## 10. Link and Update Issue
```bash
# The PR will auto-link due to "Fixes #$ARGUMENTS"
# Add any additional comments if needed
gh issue comment $ARGUMENTS --body "Fix submitted in PR #<pr-number>"
```
