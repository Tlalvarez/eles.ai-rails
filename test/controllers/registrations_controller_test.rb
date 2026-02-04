require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get signup page" do
    get signup_path
    assert_response :success
    assert_select "form"
  end

  test "should create user with valid params" do
    assert_difference "User.count", 1 do
      post signup_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to dashboard_path
    assert_not_nil session[:user_id]
  end

  test "should not create user with invalid params" do
    assert_no_difference "User.count" do
      post signup_path, params: {
        user: {
          email: "",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with mismatched passwords" do
    assert_no_difference "User.count" do
      post signup_path, params: {
        user: {
          email: "newuser@example.com",
          password: "password123",
          password_confirmation: "different"
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should not create user with duplicate email" do
    assert_no_difference "User.count" do
      post signup_path, params: {
        user: {
          email: "alice@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
