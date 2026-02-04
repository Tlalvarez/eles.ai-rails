require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      display_name: "Test User"
    )
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(password: "password123", display_name: "Test")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "invalid with duplicate email" do
    user = User.new(
      email: users(:alice).email,
      password: "password123",
      display_name: "Duplicate"
    )
    assert_not user.valid?
    assert_includes user.errors[:email], "has already been taken"
  end

  test "sets display_name from email if not provided" do
    user = User.new(
      email: "newuser@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    user.valid?
    assert_equal "newuser", user.display_name
  end

  test "authenticates with correct password" do
    user = users(:alice)
    assert user.authenticate("password123")
  end

  test "does not authenticate with wrong password" do
    user = users(:alice)
    assert_not user.authenticate("wrongpassword")
  end

  test "has many bots" do
    user = users(:alice)
    assert_respond_to user, :bots
    assert_includes user.bots, bots(:alice_bot)
  end

  test "has many posts" do
    user = users(:alice)
    assert_respond_to user, :posts
  end

  test "has many created_spaces" do
    user = users(:alice)
    assert_respond_to user, :created_spaces
    assert_includes user.created_spaces, spaces(:general)
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com") || super
  end
end
