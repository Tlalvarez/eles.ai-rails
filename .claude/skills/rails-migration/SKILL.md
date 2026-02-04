---
name: rails-migration
description: Create and manage Rails database migrations safely
disable-model-invocation: true
---

# Rails Migration: $ARGUMENTS

Follow this safe migration workflow:

## Pre-Migration Checklist
- [ ] Understand current schema (@db/schema.rb)
- [ ] Check for existing migrations that might conflict
- [ ] Plan rollback strategy

## Creating a Migration

### Common Migration Types

**Add column:**
```bash
bin/rails generate migration Add<Column>To<Table> <column>:<type>
# Example: bin/rails generate migration AddEmailToUsers email:string
```

**Remove column:**
```bash
bin/rails generate migration Remove<Column>From<Table> <column>:<type>
```

**Create table:**
```bash
bin/rails generate migration Create<Table> <column>:<type> ...
```

**Add index:**
```bash
bin/rails generate migration AddIndexTo<Table> <column>:index
```

**Add foreign key:**
```bash
bin/rails generate migration Add<Model>RefTo<Table> <model>:references
```

## Migration Best Practices

1. **Always add indexes for:**
   - Foreign keys (`add_index :posts, :user_id`)
   - Columns used in WHERE clauses
   - Columns used in ORDER BY

2. **Use reversible migrations:**
   ```ruby
   def change
     # Rails can auto-reverse these
   end
   ```

3. **For complex migrations, use up/down:**
   ```ruby
   def up
     # forward migration
   end

   def down
     # rollback migration
   end
   ```

4. **Add null constraints and defaults:**
   ```ruby
   add_column :users, :status, :string, null: false, default: 'active'
   ```

## Running Migrations

```bash
# Run pending migrations
bin/rails db:migrate

# Rollback last migration
bin/rails db:rollback

# Rollback multiple migrations
bin/rails db:rollback STEP=3

# Check migration status
bin/rails db:migrate:status

# Run specific migration
bin/rails db:migrate:up VERSION=20240101000000
```

## CRITICAL RULES

- **NEVER edit a migration after it's been pushed/committed**
- Create a new migration to fix issues
- Always test rollback before pushing
- Back up data before destructive migrations
- Use `change_column_null` with care (check for existing nulls first)

## Post-Migration

1. Run the migration: `bin/rails db:migrate`
2. Verify schema.rb changes look correct
3. Run tests: `bin/rails test`
4. Test rollback: `bin/rails db:rollback && bin/rails db:migrate`
