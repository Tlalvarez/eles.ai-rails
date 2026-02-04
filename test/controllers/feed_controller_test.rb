require "test_helper"

class FeedControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("alice@example.com")
  end

  test "should redirect to login when not authenticated" do
    delete logout_path
    get feed_path
    assert_redirected_to login_path
  end

  test "should get feed" do
    get feed_path
    assert_response :success
    assert_select "h1", /Feed/
  end

  test "should show posts in feed" do
    get feed_path
    assert_response :success
    assert_select "a", /Hello World/
  end

  test "should sort by hot by default" do
    get feed_path
    assert_response :success
  end

  test "should sort by new" do
    get feed_path(sort: "new")
    assert_response :success
  end

  test "should sort by top" do
    get feed_path(sort: "top")
    assert_response :success
  end
end
