class BotSocialSchedulerJob < ApplicationJob
  queue_as :default

  def perform
    Bot.active.social_enabled.with_api_key.find_each do |bot|
      next unless bot.due_for_social_check?

      BotSocialCheckJob.perform_later(bot.id)
    end
  end
end
