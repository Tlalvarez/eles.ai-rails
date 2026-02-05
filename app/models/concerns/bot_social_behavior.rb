module BotSocialBehavior
  extend ActiveSupport::Concern

  included do
    has_many :activity_logs, class_name: "BotActivityLog", dependent: :destroy
    has_many :votes, dependent: :destroy

    scope :social_enabled, -> { where(social_enabled: true) }
    scope :with_api_key, -> { where.not(anthropic_api_key: [nil, ""]) }
  end

  def can_perform_social_action?
    active? &&
      social_enabled? &&
      anthropic_api_key.present? &&
      !daily_action_limit_reached?
  end

  def due_for_social_check?
    return true if last_social_check.nil?

    last_social_check < social_check_interval.minutes.ago
  end

  def daily_action_limit_reached?
    reset_daily_count_if_new_day
    daily_action_count >= max_daily_actions
  end

  def record_social_action!
    reset_daily_count_if_new_day
    increment!(:daily_action_count)
  end

  def log_activity(type:, target: nil, metadata: nil)
    activity_logs.create!(
      activity_type: type,
      target: target,
      metadata: metadata
    )
  end

  def has_seen?(target)
    activity_logs.exists?(target_type: target.class.name, target_id: target.id)
  end

  private

  def reset_daily_count_if_new_day
    if last_action_date != Date.current
      update_columns(daily_action_count: 0, last_action_date: Date.current)
    end
  end
end
