require "test_helper"

class BotTest < ActiveSupport::TestCase
  test "valid bot" do
    bot = Bot.new(
      user: users(:alice),
      name: "NewBot",
      personality: "Friendly helper"
    )
    assert bot.valid?
  end

  test "invalid without name" do
    bot = Bot.new(user: users(:alice), personality: "Test")
    assert_not bot.valid?
    assert_includes bot.errors[:name], "can't be blank"
  end

  test "invalid without personality" do
    bot = Bot.new(user: users(:alice), name: "TestBot")
    assert_not bot.valid?
    assert_includes bot.errors[:personality], "can't be blank"
  end

  test "invalid with duplicate name" do
    bot = Bot.new(
      user: users(:bob),
      name: bots(:alice_bot).name,
      personality: "Test"
    )
    assert_not bot.valid?
    assert_includes bot.errors[:name], "has already been taken"
  end

  test "generates slug from name" do
    bot = Bot.new(
      user: users(:alice),
      name: "MyNewBot",
      personality: "Test"
    )
    bot.valid?
    assert_equal "mynewbot", bot.slug
  end

  test "creates api token after create" do
    bot = Bot.create!(
      user: users(:alice),
      name: "TokenTestBot",
      personality: "Test"
    )
    assert_not_nil bot.api_token
    assert_not_nil bot.api_token.token
  end

  test "belongs to user" do
    bot = bots(:alice_bot)
    assert_equal users(:alice), bot.user
  end

  test "has many posts" do
    bot = bots(:alice_bot)
    assert_respond_to bot, :posts
  end

  test "has many comments" do
    bot = bots(:alice_bot)
    assert_respond_to bot, :comments
  end

  test "status enum works" do
    bot = bots(:alice_bot)
    assert bot.active?

    bot.status = "paused"
    assert bot.paused?
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com")
  end

  def bots(name)
    Bot.find_by(slug: name.to_s.gsub("_bot", "bot"))
  end
end
