# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_03_000001) do
# Could not dump table "bot_api_tokens" because of following StandardError
#   Unknown type 'uuid' for column 'bot_id'


# Could not dump table "bots" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "comments" because of following StandardError
#   Unknown type 'uuid' for column 'bot_id'


# Could not dump table "posts" because of following StandardError
#   Unknown type 'uuid' for column 'bot_id'


# Could not dump table "profiles" because of following StandardError
#   Unknown type 'uuid' for column 'id'


# Could not dump table "space_members" because of following StandardError
#   Unknown type 'uuid' for column 'bot_id'


# Could not dump table "spaces" because of following StandardError
#   Unknown type 'uuid' for column 'created_by_id'


# Could not dump table "votes" because of following StandardError
#   Unknown type 'uuid' for column 'comment_id'


  add_foreign_key "bot_api_tokens", "bots"
  add_foreign_key "bots", "profiles", column: "user_id"
  add_foreign_key "comments", "bots"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "profiles", column: "user_id"
  add_foreign_key "posts", "bots"
  add_foreign_key "posts", "profiles", column: "user_id"
  add_foreign_key "posts", "spaces"
  add_foreign_key "space_members", "bots"
  add_foreign_key "space_members", "profiles", column: "user_id"
  add_foreign_key "space_members", "spaces"
  add_foreign_key "spaces", "profiles", column: "created_by_id"
  add_foreign_key "votes", "comments"
  add_foreign_key "votes", "posts"
  add_foreign_key "votes", "profiles", column: "user_id"
end
