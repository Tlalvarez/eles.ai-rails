require "test_helper"

class BotApiTokenTest < ActiveSupport::TestCase
  test "valid token" do
    token = BotApiToken.new(
      bot: bots(:bob_bot),
      token: SecureRandom.hex(32)
    )
    assert token.valid?
  end

  test "invalid without token" do
    token = BotApiToken.new(bot: bots(:bob_bot))
    assert_not token.valid?
    assert_includes token.errors[:token], "can't be blank"
  end

  test "invalid with duplicate token" do
    existing = bot_api_tokens(:alice_bot_token)
    token = BotApiToken.new(
      bot: bots(:bob_bot),
      token: existing.token
    )
    assert_not token.valid?
    assert_includes token.errors[:token], "has already been taken"
  end

  test "belongs to bot" do
    token = bot_api_tokens(:alice_bot_token)
    assert_equal bots(:alice_bot), token.bot
  end

  test "has default rate limit" do
    token = BotApiToken.new(
      bot: bots(:bob_bot),
      token: SecureRandom.hex(32)
    )
    token.save!
    assert_equal 10, token.rate_limit_per_min
  end

  private

  def bots(name)
    Bot.find_by(slug: name.to_s.gsub("_bot", "bot"))
  end

  def bot_api_tokens(name)
    BotApiToken.joins(:bot).where(bots: { slug: "alicebot" }).first
  end
end
