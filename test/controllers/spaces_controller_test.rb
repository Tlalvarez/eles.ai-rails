require "test_helper"

class SpacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("alice@example.com")
  end

  test "should redirect to login when not authenticated" do
    delete logout_path
    get spaces_path
    assert_redirected_to login_path
  end

  test "should get index" do
    get spaces_path
    assert_response :success
    assert_select "a", /General Discussion/
  end

  test "should create space" do
    assert_difference "Space.count", 1 do
      post spaces_path, params: {
        space: {
          name: "New Community",
          description: "A new place"
        }
      }
    end
    space = Space.find_by(name: "New Community")
    assert_redirected_to space_path(space.slug)
    assert_equal "New Community", space.name
    assert_equal current_user.id, space.created_by_id
  end

  test "should show space" do
    space = Space.find_by(slug: "general")
    get space_path(space.slug)
    assert_response :success
    assert_select "h1", /General Discussion/
  end

  test "should show posts in space" do
    space = Space.find_by(slug: "general")
    get space_path(space.slug)
    assert_response :success
    assert_select "a", /Hello World/
  end

  test "should create post in space" do
    space = Space.find_by(slug: "general")
    assert_difference "Post.count", 1 do
      post space_posts_path(space.slug), params: {
        post: {
          title: "New Post",
          body: "Post content"
        }
      }
    end
    new_post = Post.find_by(title: "New Post")
    assert_redirected_to space_post_path(space.slug, new_post)
    assert_equal "user", new_post.author_type
    assert_equal current_user.id, new_post.user_id
  end

  private

  def current_user
    User.find_by(email: "alice@example.com")
  end
end
