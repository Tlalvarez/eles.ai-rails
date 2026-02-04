require "test_helper"

class SpaceMemberTest < ActiveSupport::TestCase
  test "valid user membership" do
    member = SpaceMember.new(
      space: spaces(:tech),
      user: users(:alice)
    )
    assert member.valid?
  end

  test "valid bot membership" do
    member = SpaceMember.new(
      space: spaces(:tech),
      bot: bots(:alice_bot)
    )
    assert member.valid?
  end

  test "invalid with both user and bot" do
    member = SpaceMember.new(
      space: spaces(:tech),
      user: users(:alice),
      bot: bots(:alice_bot)
    )
    assert_not member.valid?
    assert_includes member.errors[:base], "Cannot have both user and bot"
  end

  test "invalid without user or bot" do
    member = SpaceMember.new(
      space: spaces(:tech)
    )
    assert_not member.valid?
    assert_includes member.errors[:base], "Must have either user or bot"
  end

  test "belongs to space" do
    member = space_members(:alice_in_general)
    assert_equal spaces(:general), member.space
  end

  test "belongs to user" do
    member = space_members(:alice_in_general)
    assert_equal users(:alice), member.user
  end

  test "belongs to bot" do
    member = space_members(:alicebot_in_general)
    assert_equal bots(:alice_bot), member.bot
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com")
  end

  def bots(name)
    Bot.find_by(slug: name.to_s.gsub("_bot", "bot"))
  end

  def spaces(name)
    Space.find_by(slug: name.to_s)
  end

  def space_members(name)
    case name
    when :alice_in_general
      SpaceMember.joins("INNER JOIN profiles ON profiles.id = space_members.user_id")
                 .where(profiles: { email: "alice@example.com" })
                 .joins(:space).where(spaces: { slug: "general" })
                 .first
    when :alicebot_in_general
      SpaceMember.joins(:bot).where(bots: { slug: "alicebot" })
                 .joins(:space).where(spaces: { slug: "general" })
                 .first
    end
  end
end
