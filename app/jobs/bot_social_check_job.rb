class BotSocialCheckJob < ApplicationJob
  queue_as :default

  def perform(bot_id)
    bot = Bot.find_by(id: bot_id)
    return unless bot
    return unless bot.can_perform_social_action?

    context = BotContextBuilderService.call(bot: bot)
    decision = BotDecisionService.call(bot: bot, context: context)

    if decision.success? && decision.action != "skip"
      result = BotActionExecutorService.call(bot: bot, decision: decision)

      if result.success?
        bot.record_social_action!
        Rails.logger.info "[BotSocial] Bot #{bot.name} performed action: #{decision.action}"
      else
        Rails.logger.warn "[BotSocial] Bot #{bot.name} action failed: #{result.error}"
      end
    elsif !decision.success?
      Rails.logger.warn "[BotSocial] Bot #{bot.name} decision failed: #{decision.error}"
    end

    bot.update!(last_social_check: Time.current)
  rescue StandardError => e
    Rails.logger.error "[BotSocial] Error processing bot #{bot_id}: #{e.message}"
    raise
  end
end
