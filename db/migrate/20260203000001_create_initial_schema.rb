class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    # Users (profiles)
    create_table :profiles, id: :uuid do |t|
      t.string :email
      t.string :display_name
      t.string :password_digest
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :profiles, :email, unique: true

    # Bots
    create_table :bots, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: { to_table: :profiles }, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.text :personality, null: false
      t.text :purpose
      t.string :status, default: 'provisioning'
      t.integer :host_port
      t.string :gateway_token
      t.string :anthropic_api_key
      t.integer :daily_messages, default: 0
      t.date :last_message_date
      t.datetime :last_social_check
      t.boolean :chat_enabled, default: true, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :bots, :name, unique: true
    add_index :bots, :slug, unique: true

    # Spaces
    create_table :spaces, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.references :created_by, type: :uuid, foreign_key: { to_table: :profiles }
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :spaces, :slug, unique: true

    # Space members (polymorphic: user or bot)
    create_table :space_members, id: :uuid do |t|
      t.references :space, type: :uuid, foreign_key: true, null: false
      t.references :user, type: :uuid, foreign_key: { to_table: :profiles }
      t.references :bot, type: :uuid, foreign_key: true
      t.datetime :joined_at, default: -> { 'CURRENT_TIMESTAMP' }, null: false
    end
    add_index :space_members, [:space_id, :user_id], unique: true
    add_index :space_members, [:space_id, :bot_id], unique: true

    # Posts
    create_table :posts, id: :uuid do |t|
      t.references :space, type: :uuid, foreign_key: true, null: false
      t.string :author_type, null: false
      t.references :user, type: :uuid, foreign_key: { to_table: :profiles }
      t.references :bot, type: :uuid, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.integer :score, default: 0, null: false
      t.integer :comment_count, default: 0, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :posts, [:space_id, :created_at]
    add_index :posts, [:space_id, :score]

    # Comments
    create_table :comments, id: :uuid do |t|
      t.references :post, type: :uuid, foreign_key: true, null: false
      t.references :parent, type: :uuid, foreign_key: { to_table: :comments }
      t.string :author_type, null: false
      t.references :user, type: :uuid, foreign_key: { to_table: :profiles }
      t.references :bot, type: :uuid, foreign_key: true
      t.text :body, null: false
      t.integer :score, default: 0, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :comments, [:post_id, :created_at]

    # Votes
    create_table :votes, id: :uuid do |t|
      t.references :user, type: :uuid, foreign_key: { to_table: :profiles }, null: false
      t.references :post, type: :uuid, foreign_key: true
      t.references :comment, type: :uuid, foreign_key: true
      t.integer :value, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :votes, [:user_id, :post_id], unique: true
    add_index :votes, [:user_id, :comment_id], unique: true

    # Bot API tokens
    create_table :bot_api_tokens, id: :uuid do |t|
      t.references :bot, type: :uuid, foreign_key: true, null: false, index: { unique: true }
      t.string :token, null: false
      t.integer :rate_limit_per_min, default: 10, null: false
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end
    add_index :bot_api_tokens, :token, unique: true
  end
end
