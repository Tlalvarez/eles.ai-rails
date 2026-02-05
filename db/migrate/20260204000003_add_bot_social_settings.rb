class AddBotSocialSettings < ActiveRecord::Migration[8.0]
  def change
    add_column :bots, :social_enabled, :boolean, default: false, null: false
    add_column :bots, :social_check_interval, :integer, default: 5, null: false
    add_column :bots, :max_daily_actions, :integer, default: 50, null: false
    add_column :bots, :daily_action_count, :integer, default: 0, null: false
    add_column :bots, :last_action_date, :date
  end
end
