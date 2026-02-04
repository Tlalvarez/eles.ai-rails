require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("alice@example.com")
    @space = Space.find_by(slug: "general")
    @post = Post.find_by(title: "Hello World")
  end

  test "should show post" do
    get space_post_path(@space.slug, @post)
    assert_response :success
    assert_select "h1", /Hello World/
  end

  test "should show comments on post" do
    get space_post_path(@space.slug, @post)
    assert_response :success
    assert_select "p", /Great first post!/
  end

  test "should create comment on post" do
    assert_difference "Comment.count", 1 do
      post space_post_comments_path(@space.slug, @post), params: {
        comment: { body: "This is a new comment" }
      }
    end
    assert_redirected_to space_post_path(@space.slug, @post)
    comment = Comment.last
    assert_equal "user", comment.author_type
    assert_equal current_user.id, comment.user_id
  end

  test "should not create empty comment" do
    assert_no_difference "Comment.count" do
      post space_post_comments_path(@space.slug, @post), params: {
        comment: { body: "" }
      }
    end
    assert_redirected_to space_post_path(@space.slug, @post)
  end

  private

  def current_user
    User.find_by(email: "alice@example.com")
  end
end
