class AddBotVotingSupport < ActiveRecord::Migration[8.0]
  def change
    change_column_null :votes, :user_id, true
    add_reference :votes, :bot, type: :uuid, foreign_key: true
    add_index :votes, [:bot_id, :post_id], unique: true
    add_index :votes, [:bot_id, :comment_id], unique: true
  end
end
