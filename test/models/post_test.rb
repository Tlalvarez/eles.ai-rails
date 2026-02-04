require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid user post" do
    post = Post.new(
      space: spaces(:general),
      title: "Test Post",
      body: "This is a test",
      author_type: "user",
      user: users(:alice)
    )
    assert post.valid?
  end

  test "valid bot post" do
    post = Post.new(
      space: spaces(:general),
      title: "Bot Post",
      body: "From a bot",
      author_type: "bot",
      bot: bots(:alice_bot)
    )
    assert post.valid?
  end

  test "invalid without title" do
    post = Post.new(
      space: spaces(:general),
      author_type: "user",
      user: users(:alice)
    )
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "invalid without author_type" do
    post = Post.new(
      space: spaces(:general),
      title: "Test",
      user: users(:alice)
    )
    assert_not post.valid?
    assert_includes post.errors[:author_type], "can't be blank"
  end

  test "invalid user post without user" do
    post = Post.new(
      space: spaces(:general),
      title: "Test",
      author_type: "user"
    )
    assert_not post.valid?
    assert_includes post.errors[:user_id], "must be present for user posts"
  end

  test "invalid bot post without bot" do
    post = Post.new(
      space: spaces(:general),
      title: "Test",
      author_type: "bot"
    )
    assert_not post.valid?
    assert_includes post.errors[:bot_id], "must be present for bot posts"
  end

  test "author returns user for user posts" do
    post = posts(:hello_world)
    assert_equal users(:alice), post.author
  end

  test "author returns bot for bot posts" do
    post = posts(:bot_post)
    assert_equal bots(:alice_bot), post.author
  end

  test "author_name returns display_name for user posts" do
    post = posts(:hello_world)
    assert_equal "Alice", post.author_name
  end

  test "author_name returns bot name for bot posts" do
    post = posts(:bot_post)
    assert_equal "AliceBot", post.author_name
  end

  test "has many comments" do
    post = posts(:hello_world)
    assert_respond_to post, :comments
    assert post.comments.count > 0
  end

  test "has many votes" do
    post = posts(:hello_world)
    assert_respond_to post, :votes
  end

  test "scope newest orders by created_at desc" do
    posts = Post.newest
    assert posts.first.created_at >= posts.last.created_at
  end

  test "scope top orders by score desc" do
    posts = Post.top
    assert posts.first.score >= posts.last.score
  end

  private

  def users(name)
    User.find_by(email: "#{name}@example.com")
  end

  def bots(name)
    Bot.find_by(slug: name.to_s.gsub("_bot", "bot"))
  end

  def spaces(name)
    Space.find_by(slug: name.to_s)
  end

  def posts(name)
    case name
    when :hello_world
      Post.find_by(title: "Hello World")
    when :bot_post
      Post.find_by(title: "Bot Generated Post")
    end
  end
end
