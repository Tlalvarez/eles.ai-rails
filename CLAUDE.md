# Project: eles.ai

> Keep this file under ~500 lines. Move reference material to skills.

## Quick Commands

```bash
# Server
bin/rails server
bin/rails console

# Test (single file - preferred for speed)
bin/rails test <file>
# or for RSpec:
bundle exec rspec <file>

# Test (full suite)
bin/rails test
# or for RSpec:
bundle exec rspec

# Lint
bundle exec rubocop
bundle exec rubocop -a  # auto-fix

# Database
bin/rails db:migrate
bin/rails db:rollback
bin/rails db:seed
bin/rails db:reset  # drop, create, migrate, seed

# Generators
bin/rails generate model <name> <attributes>
bin/rails generate controller <name> <actions>
bin/rails generate migration <name>

# Routes
bin/rails routes
bin/rails routes -g <pattern>  # grep routes
```

## Code Style (Rails)

- Follow Rails conventions (convention over configuration)
- Use snake_case for methods, variables, and file names
- Use CamelCase for classes and modules
- Use SCREAMING_SNAKE_CASE for constants
- Prefer `has_many :through` over `has_and_belongs_to_many`
- Use strong parameters in controllers
- Keep controllers thin, models fat (but use service objects for complex logic)
- Use concerns for shared model/controller behavior
- Prefer scopes over class methods for queries

## Architecture (Rails)

```
app/
├── controllers/    # Handle HTTP requests, delegate to models/services
├── models/         # Business logic, validations, associations
├── views/          # ERB/Haml templates, partials
├── helpers/        # View helpers
├── services/       # Complex business operations (app/services/)
├── jobs/           # Background jobs (Sidekiq/ActiveJob)
├── mailers/        # Email templates and logic
└── channels/       # ActionCable WebSocket channels

config/
├── routes.rb       # URL routing
├── database.yml    # Database configuration
└── environments/   # Environment-specific settings

db/
├── migrate/        # Database migrations (NEVER edit after committed)
├── schema.rb       # Current database schema (auto-generated)
└── seeds.rb        # Seed data
```

## Workflow Rules

- **ALWAYS run tests before committing** - No exceptions. Run `bin/rails test` (or `bundle exec rspec`) and ensure all tests pass before any commit.
- Run `bundle exec rubocop` before committing
- Write failing tests first, then implement the fix
- Keep commits atomic and focused
- NEVER edit migrations that have been committed/pushed - create new ones
- Always add database indexes for foreign keys and frequently queried columns

## Pre-Commit Checklist

Before every commit, run:
```bash
bin/rails test && bundle exec rubocop
```
Do NOT commit if tests fail. Fix the issue first.

## Parallel Sessions with Git Worktrees

Use git worktrees to run multiple Claude sessions simultaneously with complete code isolation. **Suggest parallel sessions when:**
- Working on independent features/fixes that don't overlap
- One task is blocked waiting for review/feedback
- Research can happen while implementation continues
- Running long test suites while working on something else

### Worktree Commands
```bash
# Create a new worktree with a new branch
git worktree add ../project-feature-name -b feature/feature-name

# Create worktree from existing branch
git worktree add ../project-bugfix bugfix/issue-123

# List all worktrees
git worktree list

# Remove worktree when done
git worktree remove ../project-feature-name
```

### Parallel Session Workflow
1. Create worktree: `git worktree add ../project-task-name -b feature/task-name`
2. Open new terminal, cd to worktree
3. Run `bundle install` (each worktree needs its own gems)
4. Start Claude: `claude`
5. Work independently - changes don't affect other worktrees
6. When done: merge branch, remove worktree

### When to Suggest Parallel Work
- "This feature is independent - consider using a worktree for parallel development"
- "While waiting for CI/review, you could start another task in a separate worktree"
- "This is a large task - we could split it: research in one session, implementation in another"

## Rails Conventions

- RESTful routes: index, show, new, create, edit, update, destroy
- Naming: Model (singular), Controller (plural), Table (plural)
- Use `before_action` for DRY controller code
- Use validations in models, not controllers
- Use callbacks sparingly (prefer service objects for complex logic)
- Use `find_by` instead of `where(...).first`
- Use `exists?` instead of `present?` for database checks

## Common Gotchas

- N+1 queries: Use `includes()` or `eager_load()` for associations
- Mass assignment: Always use strong parameters
- Migrations: NEVER edit after pushed, create new migration instead
- Time zones: Always use `Time.current` not `Time.now`
- Environment variables: Use `Rails.application.credentials` or ENV
- Assets: Run `bin/rails assets:precompile` for production

## GitHub Workflow

- Branch naming: `feature/`, `fix/`, `refactor/`, `chore/`
- Always create PRs using `gh pr create`
- Link issues in PR description: "Fixes #123"
- Request reviews with `gh pr edit --add-reviewer`
- Use `gh issue list` and `gh issue view` for context
- Commit messages: Use conventional commits (feat:, fix:, docs:, etc.)

## GitHub CLI Commands

```bash
# Issues
gh issue list
gh issue view <number>
gh issue create

# Pull Requests
gh pr create
gh pr list
gh pr view <number>
gh pr checkout <number>
gh pr merge

# Workflow
gh run list
gh run view <id>
```

## Compact Instructions

> These are preserved when context is compacted

- Always preserve the list of modified files
- Keep track of failing tests and their status
- Maintain awareness of the current git branch and uncommitted changes
- Remember any pending migrations or database changes
- Track GitHub issue/PR numbers being worked on

## Additional Resources

- @README.md for project overview
- @docs/ for detailed documentation
- @db/schema.rb for current database structure
- @config/routes.rb for available endpoints
