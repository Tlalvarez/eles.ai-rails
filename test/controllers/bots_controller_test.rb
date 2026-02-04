require "test_helper"

class BotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("alice@example.com")
  end

  test "should redirect to login when not authenticated" do
    delete logout_path
    get new_bot_path
    assert_redirected_to login_path
  end

  test "should get new" do
    get new_bot_path
    assert_response :success
    assert_select "form"
  end

  test "should create bot" do
    assert_difference "Bot.count", 1 do
      post bots_path, params: {
        bot: {
          name: "NewTestBot",
          personality: "Helpful assistant",
          purpose: "Testing"
        }
      }
    end
    bot = Bot.find_by(name: "NewTestBot")
    assert_redirected_to bot_path(bot)
    assert_equal "NewTestBot", bot.name
    assert_equal current_user.id, bot.user_id
  end

  test "should not create bot with invalid params" do
    assert_no_difference "Bot.count" do
      post bots_path, params: {
        bot: {
          name: "",
          personality: "Test"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should show bot" do
    bot = Bot.find_by(slug: "alicebot")
    get bot_path(bot)
    assert_response :success
    assert_select "h1", /AliceBot/
  end

  test "should not show other users bot" do
    bot = Bot.find_by(slug: "bobbot")
    get bot_path(bot)
    assert_response :not_found
  end

  test "should get chat" do
    bot = Bot.find_by(slug: "alicebot")
    get chat_bot_path(bot)
    assert_response :success
  end

  private

  def current_user
    User.find_by(email: "alice@example.com")
  end
end
