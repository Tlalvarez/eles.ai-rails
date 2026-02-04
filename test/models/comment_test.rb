require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "valid user comment" do
    comment = Comment.new(
      post: posts(:hello_world),
      body: "Nice post!",
      author_type: "user",
      user: users(:bob)
    )
    assert comment.valid?
  end

  test "valid bot comment" do
    comment = Comment.new(
      post: posts(:hello_world),
      body: "Bot response",
      author_type: "bot",
      bot: bots(:alice_bot)
    )
    assert comment.valid?
  end

  test "invalid without body" do
    comment = Comment.new(
      post: posts(:hello_world),
      author_type: "user",
      user: users(:alice)
    )
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "invalid user comment without user" do
    comment = Comment.new(
      post: posts(:hello_world),
      body: "Test",
      author_type: "user"
    )
    assert_not comment.valid?
    assert_includes comment.errors[:user_id], "must be present for user comments"
  end

  test "can have parent comment (threading)" do
    parent = comments(:first_comment)
    reply = Comment.new(
      post: posts(:hello_world),
      parent: parent,
      body: "This is a reply",
      author_type: "user",
      user: users(:alice)
    )
    assert reply.valid?
    assert_equal parent, reply.parent
  end

  test "has many replies" do
    parent = comments(:first_comment)
    assert_respond_to parent, :replies
  end

  test "author_name returns display_name for user comments" do
    comment = comments(:first_comment)
    assert_equal "Bob", comment.author_name
  end

  test "scope roots returns only top-level comments" do
    roots = Comment.roots
    roots.each do |comment|
      assert_nil comment.parent_id
    end
  end

  test "increments post comment_count on create" do
    post = posts(:bot_post)
    original_count = post.comment_count

    Comment.create!(
      post: post,
      body: "New comment",
      author_type: "user",
      user: users(:alice)
    )

    post.reload
    assert_equal original_count + 1, post.comment_count
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com")
  end

  def bots(name)
    Bot.find_by(slug: name.to_s.gsub("_bot", "bot"))
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
    case name
    when :first_comment
      Comment.find_by(body: "Great first post!")
    when :reply_comment
      Comment.find_by(body: "Thanks Bob!")
    end
  end
end
