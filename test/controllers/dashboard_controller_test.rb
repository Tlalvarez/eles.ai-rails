require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to login when not authenticated" do
    get dashboard_path
    assert_redirected_to login_path
  end

  test "should show dashboard when authenticated" do
    sign_in_as("alice@example.com")
    get dashboard_path
    assert_response :success
  end

  test "should display user bots" do
    sign_in_as("alice@example.com")
    get dashboard_path
    assert_response :success
    assert_select "a", /AliceBot/
  end
end
