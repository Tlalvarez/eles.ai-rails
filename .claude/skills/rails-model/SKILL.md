---
name: rails-model
description: Create Rails models with proper validations, associations, and tests
disable-model-invocation: true
---

# Create Rails Model: $ARGUMENTS

## Step 1: Generate the Model

```bash
bin/rails generate model <ModelName> <attribute>:<type> ...
```

### Common Types
- `string` - Short text (VARCHAR)
- `text` - Long text (TEXT)
- `integer` - Whole numbers
- `decimal` - Precise decimals (money)
- `float` - Floating point
- `boolean` - true/false
- `date` - Date only
- `datetime` - Date and time
- `references` - Foreign key (belongs_to)

### Example
```bash
bin/rails generate model Article title:string body:text published:boolean user:references
```

## Step 2: Review and Edit Migration

Check `db/migrate/TIMESTAMP_create_<table>.rb`:

```ruby
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :body
      t.boolean :published, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # Add indexes for frequently queried columns
    add_index :articles, :published
    add_index :articles, [:user_id, :created_at]
  end
end
```

## Step 3: Define Model

Edit `app/models/<model>.rb`:

```ruby
class Article < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true
  validates :published, inclusion: { in: [true, false] }

  # Scopes
  scope :published, -> { where(published: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }

  # Callbacks (use sparingly)
  before_validation :normalize_title
  after_create :notify_subscribers

  # Instance methods
  def publish!
    update!(published: true)
  end

  def excerpt(length = 100)
    body.truncate(length)
  end

  private

  def normalize_title
    self.title = title&.strip&.titleize
  end

  def notify_subscribers
    # notification logic
  end
end
```

## Step 4: Run Migration

```bash
bin/rails db:migrate
```

## Step 5: Write Tests

Create `test/models/<model>_test.rb` (or `spec/models/<model>_spec.rb`):

```ruby
require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  # Validations
  test "should require title" do
    article = Article.new(body: "content", user: users(:one))
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test "should require body" do
    article = Article.new(title: "Title", user: users(:one))
    assert_not article.valid?
  end

  # Associations
  test "should belong to user" do
    article = articles(:one)
    assert_respond_to article, :user
    assert_instance_of User, article.user
  end

  # Scopes
  test "published scope returns only published articles" do
    assert Article.published.all? { |a| a.published? }
  end

  # Methods
  test "publish! sets published to true" do
    article = articles(:draft)
    article.publish!
    assert article.published?
  end
end
```

## Step 6: Add Fixtures/Factories

`test/fixtures/articles.yml`:
```yaml
one:
  title: First Article
  body: This is the first article content
  published: true
  user: one

draft:
  title: Draft Article
  body: This is unpublished
  published: false
  user: one
```

## Step 7: Run Tests

```bash
bin/rails test test/models/article_test.rb
```

## Checklist

- [ ] Migration has proper null constraints
- [ ] Indexes added for foreign keys and queried columns
- [ ] Model has appropriate validations
- [ ] Associations are defined with dependent options
- [ ] Scopes created for common queries
- [ ] Tests cover validations, associations, and methods
- [ ] Fixtures/factories created for testing
