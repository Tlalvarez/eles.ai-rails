---
name: parallel-session
description: Set up a parallel Claude session using git worktrees
disable-model-invocation: true
---

# Create Parallel Session: $ARGUMENTS

Set up a new git worktree for parallel development.

## Step 1: Create the Worktree

```bash
# For a new feature branch
git worktree add ../$(basename $(pwd))-$ARGUMENTS -b feature/$ARGUMENTS

# Or for an existing branch
git worktree add ../$(basename $(pwd))-$ARGUMENTS $ARGUMENTS
```

## Step 2: Provide Setup Instructions

Tell the user:

```
Parallel worktree created! To start working:

1. Open a new terminal window/tab
2. Navigate to the worktree:
   cd ../$(basename $(pwd))-$ARGUMENTS

3. Install dependencies:
   bundle install

4. Set up database (if needed):
   bin/rails db:create db:migrate

5. Start Claude:
   claude

You now have two independent sessions:
- Original: $(pwd)
- New: ../$(basename $(pwd))-$ARGUMENTS

Changes in one don't affect the other until you merge branches.
```

## Step 3: Track Active Worktrees

```bash
git worktree list
```

## Cleanup Instructions

When the parallel work is complete:

```bash
# From the main project directory
git worktree remove ../$(basename $(pwd))-$ARGUMENTS

# Or if you need to force removal
git worktree remove --force ../$(basename $(pwd))-$ARGUMENTS
```

## Best Practices

- Name worktrees descriptively: `project-auth-refactor`, `project-fix-123`
- Each worktree needs its own `bundle install`
- Don't forget to merge completed work back to main
- Clean up worktrees when done to avoid confusion
- Use `git worktree list` to see all active worktrees
