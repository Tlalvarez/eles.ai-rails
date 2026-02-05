class BotActionExecutorService < ApplicationService
  Result = Struct.new(:success?, :action, :result, :error, keyword_init: true)

  def initialize(bot:, decision:)
    @bot = bot
    @decision = decision
  end

  def call
    case @decision.action
    when "comment"
      execute_comment
    when "post"
      execute_post
    when "vote"
      execute_vote
    when "create_space"
      execute_create_space
    when "skip"
      Result.new(success?: true, action: "skip", result: nil)
    else
      Result.new(success?: false, error: "Unknown action: #{@decision.action}")
    end
  end

  private

  def execute_comment
    post = find_target_post
    return Result.new(success?: false, error: "Post not found") unless post

    comment = Comment.create!(
      post: post,
      bot: @bot,
      author_type: "bot",
      body: @decision.content
    )

    @bot.log_activity(type: "commented", target: comment, metadata: { post_id: post.id })
    @bot.log_activity(type: "viewed_post", target: post)

    Result.new(success?: true, action: "comment", result: comment)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success?: false, error: "Failed to create comment: #{e.message}")
  end

  def execute_post
    space = find_space_for_post
    return Result.new(success?: false, error: "No space available for posting") unless space

    post = Post.create!(
      space: space,
      bot: @bot,
      author_type: "bot",
      title: extract_title(@decision.content),
      body: extract_body(@decision.content)
    )

    @bot.log_activity(type: "posted", target: post, metadata: { space_id: space.id })

    Result.new(success?: true, action: "post", result: post)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success?: false, error: "Failed to create post: #{e.message}")
  end

  def execute_vote
    target = find_vote_target
    return Result.new(success?: false, error: "Vote target not found") unless target

    vote_attrs = {
      bot: @bot,
      value: @decision.vote_value
    }

    if target.is_a?(Post)
      vote_attrs[:post] = target
      existing = Vote.find_by(bot: @bot, post: target)
    else
      vote_attrs[:comment] = target
      existing = Vote.find_by(bot: @bot, comment: target)
    end

    if existing
      existing.update!(value: @decision.vote_value)
      vote = existing
    else
      vote = Vote.create!(vote_attrs)
    end

    @bot.log_activity(type: "voted", target: target, metadata: { value: @decision.vote_value })

    Result.new(success?: true, action: "vote", result: vote)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success?: false, error: "Failed to vote: #{e.message}")
  end

  def execute_create_space
    space = Space.create!(
      name: @decision.space_name,
      description: @decision.space_description,
      created_by_bot: @bot
    )

    SpaceMember.create!(space: space, bot: @bot)

    @bot.log_activity(type: "created_space", target: space)

    Result.new(success?: true, action: "create_space", result: space)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success?: false, error: "Failed to create space: #{e.message}")
  end

  def find_target_post
    return nil unless @decision.target_id

    post = Post.find_by(id: @decision.target_id)
    return post if post

    comment = Comment.find_by(id: @decision.target_id)
    comment&.post
  end

  def find_space_for_post
    if @decision.target_id
      Space.find_by(id: @decision.target_id)
    else
      @bot.spaces.first
    end
  end

  def find_vote_target
    return nil unless @decision.target_id

    Post.find_by(id: @decision.target_id) || Comment.find_by(id: @decision.target_id)
  end

  def extract_title(content)
    return "" if content.blank?

    lines = content.strip.split("\n")
    first_line = lines.first&.strip || ""

    if first_line.length <= 100
      first_line
    else
      first_line.truncate(100)
    end
  end

  def extract_body(content)
    return "" if content.blank?

    lines = content.strip.split("\n")
    if lines.length > 1
      lines[1..].join("\n").strip
    else
      ""
    end
  end
end
