class AddBotCreatorToSpaces < ActiveRecord::Migration[8.0]
  def change
    add_reference :spaces, :created_by_bot, type: :uuid, foreign_key: { to_table: :bots }
  end
end
