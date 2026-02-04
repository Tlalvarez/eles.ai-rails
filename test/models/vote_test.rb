require "test_helper"

class VoteTest < ActiveSupport::TestCase
  test "valid post upvote" do
    vote = Vote.new(
      user: users(:alice),
      post: posts(:hello_world),
      value: 1
    )
    assert vote.valid?
  end

  test "valid post downvote" do
    vote = Vote.new(
      user: users(:alice),
      post: posts(:hello_world),
      value: -1
    )
    assert vote.valid?
  end

  test "valid comment vote" do
    vote = Vote.new(
      user: users(:alice),
      comment: comments(:first_comment),
      value: 1
    )
    assert vote.valid?
  end

  test "invalid without value" do
    vote = Vote.new(
      user: users(:alice),
      post: posts(:hello_world)
    )
    assert_not vote.valid?
    assert_includes vote.errors[:value], "can't be blank"
  end

  test "invalid with value other than 1 or -1" do
    vote = Vote.new(
      user: users(:alice),
      post: posts(:hello_world),
      value: 2
    )
    assert_not vote.valid?
    assert_includes vote.errors[:value], "is not included in the list"
  end

  test "invalid with both post and comment" do
    vote = Vote.new(
      user: users(:alice),
      post: posts(:hello_world),
      comment: comments(:first_comment),
      value: 1
    )
    assert_not vote.valid?
    assert_includes vote.errors[:base], "Cannot vote on both post and comment"
  end

  test "invalid without post or comment" do
    vote = Vote.new(
      user: users(:alice),
      value: 1
    )
    assert_not vote.valid?
    assert_includes vote.errors[:base], "Must vote on either post or comment"
  end

  test "updates post score after save" do
    post = posts(:bot_post)
    # bot_post has 1 vote (alice_upvote with value 1)
    assert_equal 1, post.score

    Vote.create!(
      user: users(:bob),
      post: post,
      value: 1
    )

    post.reload
    # After adding bob's upvote, score should be 2
    assert_equal 2, post.score
  end

  test "updates post score after destroy" do
    vote = votes(:bob_upvote)
    post = vote.post
    # hello_world has 1 vote (bob_upvote with value 1)
    assert_equal 1, post.score

    vote.destroy

    post.reload
    # After removing the only vote, score should be 0
    assert_equal 0, post.score
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com")
  end

  def posts(name)
    case name
    when :hello_world
      Post.find_by(title: "Hello World")
    when :bot_post
      Post.find_by(title: "Bot Generated Post")
    end
  end

  def comments(name)
    Comment.find_by(body: "Great first post!")
  end

  def votes(name)
    case name
    when :bob_upvote
      Vote.joins("INNER JOIN profiles ON profiles.id = votes.user_id")
          .where(profiles: { email: "bob@example.com" })
          .joins("INNER JOIN posts ON posts.id = votes.post_id")
          .where(posts: { title: "Hello World" })
          .first
    end
  end
end
