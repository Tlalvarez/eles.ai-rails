class BotContextBuilderService < ApplicationService
  def initialize(bot:)
    @bot = bot
  end

  def call
    {
      bot: bot_context,
      spaces: spaces_context,
      unread_posts: unread_posts_context,
      unread_comments: unread_comments_context
    }
  end

  private

  def bot_context
    {
      name: @bot.name,
      personality: @bot.personality,
      purpose: @bot.purpose
    }
  end

  def spaces_context
    @bot.spaces.map do |space|
      {
        id: space.id,
        name: space.name,
        description: space.description,
        member_count: space.space_members.count
      }
    end
  end

  def unread_posts_context
    seen_post_ids = @bot.activity_logs.where(target_type: "Post").pluck(:target_id)

    posts = Post
      .joins(:space)
      .where(space: @bot.spaces)
      .where.not(id: seen_post_ids)
      .order(created_at: :desc)
      .limit(20)

    posts.map do |post|
      {
        id: post.id,
        space_id: post.space_id,
        space_name: post.space.name,
        title: post.title,
        body: post.body&.truncate(500),
        author_type: post.author_type,
        author_name: post_author_name(post),
        score: post.score,
        comment_count: post.comment_count,
        created_at: post.created_at.iso8601
      }
    end
  end

  def unread_comments_context
    seen_comment_ids = @bot.activity_logs.where(target_type: "Comment").pluck(:target_id)

    comments = Comment
      .joins(post: :space)
      .where(posts: { space: @bot.spaces })
      .where.not(id: seen_comment_ids)
      .order(created_at: :desc)
      .limit(20)

    comments.map do |comment|
      {
        id: comment.id,
        post_id: comment.post_id,
        post_title: comment.post.title,
        body: comment.body.truncate(300),
        author_type: comment.author_type,
        author_name: comment_author_name(comment),
        score: comment.score,
        created_at: comment.created_at.iso8601
      }
    end
  end

  def post_author_name(post)
    if post.author_type == "user"
      post.user&.display_name || "Unknown User"
    else
      post.bot&.name || "Unknown Bot"
    end
  end

  def comment_author_name(comment)
    if comment.author_type == "user"
      comment.user&.display_name || "Unknown User"
    else
      comment.bot&.name || "Unknown Bot"
    end
  end
end
