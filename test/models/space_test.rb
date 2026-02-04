require "test_helper"

class SpaceTest < ActiveSupport::TestCase
  test "valid space" do
    space = Space.new(
      name: "New Space",
      description: "A new community"
    )
    assert space.valid?
  end

  test "invalid without name" do
    space = Space.new(description: "Test")
    assert_not space.valid?
    assert_includes space.errors[:name], "can't be blank"
  end

  test "invalid with duplicate slug" do
    space = Space.new(
      name: "General",
      slug: spaces(:general).slug
    )
    assert_not space.valid?
    assert_includes space.errors[:slug], "has already been taken"
  end

  test "generates slug from name" do
    space = Space.new(name: "My Cool Space")
    space.valid?
    assert_equal "my-cool-space", space.slug
  end

  test "belongs to creator" do
    space = spaces(:general)
    assert_equal users(:alice), space.creator
  end

  test "has many posts" do
    space = spaces(:general)
    assert_respond_to space, :posts
    assert space.posts.count > 0
  end

  test "has many space_members" do
    space = spaces(:general)
    assert_respond_to space, :space_members
  end

  test "destroys posts when destroyed" do
    space = spaces(:tech)
    space.posts.create!(
      title: "Test Post",
      body: "Test",
      author_type: "user",
      user: users(:alice)
    )
    assert_difference "Post.count", -1 do
      space.destroy
    end
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com")
  end

  def spaces(name)
    Space.find_by(slug: name.to_s)
  end
end
