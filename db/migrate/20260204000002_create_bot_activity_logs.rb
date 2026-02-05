class CreateBotActivityLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :bot_activity_logs, id: :uuid do |t|
      t.references :bot, type: :uuid, foreign_key: true, null: false
      t.string :activity_type, null: false
      t.string :target_type
      t.string :target_id
      t.json :metadata
      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :bot_activity_logs, [:bot_id, :activity_type]
    add_index :bot_activity_logs, [:bot_id, :target_type, :target_id]
  end
end
