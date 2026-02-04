require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get root_path
    assert_response :success
    assert_select "h1", /eles.ai/
  end

  test "should show signup and login links when not logged in" do
    get root_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
  end

  test "should redirect to dashboard when logged in" do
    sign_in_as("alice@example.com")
    get root_path
    assert_redirected_to dashboard_path
  end
end
