require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login page" do
    get login_path
    assert_response :success
    assert_select "form"
  end

  test "should login with valid credentials" do
    post login_path, params: {
      session: { email: "alice@example.com", password: "password123" }
    }
    assert_redirected_to dashboard_path
    assert_not_nil session[:user_id]
  end

  test "should not login with invalid credentials" do
    post login_path, params: {
      session: { email: "alice@example.com", password: "wrongpassword" }
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should not login with non-existent email" do
    post login_path, params: {
      session: { email: "nonexistent@example.com", password: "password123" }
    }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should logout" do
    # Login first
    post login_path, params: {
      session: { email: "alice@example.com", password: "password123" }
    }
    assert_not_nil session[:user_id]

    # Then logout
    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
