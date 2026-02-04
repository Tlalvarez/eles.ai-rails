require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("alice@example.com")
    @post = Post.find_by(title: "Bot Generated Post")
    @comment = Comment.find_by(body: "Great first post!")
  end

  test "should redirect to login when not authenticated" do
    delete logout_path
    post votes_path, params: { post_id: @post.id, value: 1 }
    assert_redirected_to login_path
  end

  test "should create upvote on post" do
    # First remove any existing vote
    Vote.where(user: current_user, post: @post).destroy_all

    assert_difference "Vote.count", 1 do
      post votes_path, params: { post_id: @post.id, value: 1 }
    end
    assert_response :redirect
    vote = Vote.find_by(user: current_user, post: @post)
    assert_equal 1, vote.value
    assert_equal @post.id, vote.post_id
  end

  test "should create downvote on post" do
    # First remove any existing vote
    Vote.where(user: current_user, post: @post).destroy_all

    assert_difference "Vote.count", 1 do
      post votes_path, params: { post_id: @post.id, value: -1 }
    end
    vote = Vote.find_by(user: current_user, post: @post)
    assert_equal(-1, vote.value)
  end

  test "should update existing vote" do
    # Create initial vote
    Vote.where(user: current_user, post: @post).destroy_all
    Vote.create!(user: current_user, post: @post, value: 1)

    assert_no_difference "Vote.count" do
      post votes_path, params: { post_id: @post.id, value: -1 }
    end
    vote = Vote.find_by(user: current_user, post: @post)
    assert_equal(-1, vote.value)
  end

  test "should vote on comment" do
    Vote.where(user: current_user, comment: @comment).destroy_all

    assert_difference "Vote.count", 1 do
      post votes_path, params: { comment_id: @comment.id, value: 1 }
    end
    vote = Vote.find_by(user: current_user, comment: @comment)
    assert_equal @comment.id, vote.comment_id
  end

  private

  def current_user
    User.find_by(email: "alice@example.com")
  end
end
