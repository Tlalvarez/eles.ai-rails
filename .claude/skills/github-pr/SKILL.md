---
name: github-pr
description: Create and manage GitHub Pull Requests with proper workflow
disable-model-invocation: true
---

# GitHub PR Workflow: $ARGUMENTS

## Creating a New PR

### 1. Prepare Your Branch
```bash
# Ensure you're on a feature branch (not main)
git branch

# Check for uncommitted changes
git status

# Ensure tests pass
bin/rails test
bundle exec rubocop
```

### 2. Push Your Branch
```bash
git push -u origin $(git branch --show-current)
```

### 3. Create the PR
```bash
gh pr create --title "Brief description" --body "$(cat <<'EOF'
## Summary
- What this PR does
- Why it's needed

## Changes
- List of main changes

## Test Plan
- [ ] Tests added/updated
- [ ] Manual testing performed
- [ ] Rubocop passes

## Screenshots (if UI changes)

Fixes #<issue-number>
EOF
)"
```

## PR Management Commands

```bash
# List your PRs
gh pr list --author @me

# View PR details
gh pr view <number>

# Check PR status and checks
gh pr checks <number>

# Add reviewers
gh pr edit <number> --add-reviewer <username>

# Add labels
gh pr edit <number> --add-label "ready for review"

# Request changes from review
gh pr review <number> --request-changes --body "Please fix..."

# Approve PR
gh pr review <number> --approve

# Merge PR (after approval)
gh pr merge <number> --squash --delete-branch
```

## Updating a PR

```bash
# Make changes locally
git add <files>
git commit -m "Address review feedback"
git push

# PR updates automatically
```

## Responding to Reviews

```bash
# View review comments
gh pr view <number> --comments

# Reply to a review
gh pr comment <number> --body "Response to feedback..."
```

## Linking Issues

In PR description or commits:
- `Fixes #123` - Closes issue when PR merges
- `Closes #123` - Same as Fixes
- `Resolves #123` - Same as Fixes
- `Ref #123` - References without closing

## Best Practices

1. **Keep PRs small and focused** - One feature/fix per PR
2. **Write descriptive titles** - What, not how
3. **Link related issues** - Use Fixes/Closes keywords
4. **Add context in description** - Why this change matters
5. **Request specific reviewers** - Those familiar with the code
6. **Respond to all comments** - Even if just acknowledging
7. **Squash when merging** - Keep history clean
