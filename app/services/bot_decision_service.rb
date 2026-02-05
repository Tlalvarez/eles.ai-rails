class BotDecisionService < ApplicationService
  Result = Struct.new(:success?, :action, :target_id, :content, :vote_value, :space_name, :space_description, :reasoning, :error, keyword_init: true)

  VALID_ACTIONS = %w[comment post vote create_space skip].freeze

  def initialize(bot:, context:)
    @bot = bot
    @context = context
  end

  def call
    api_result = ClaudeApiService.call(
      api_key: @bot.anthropic_api_key,
      system_prompt: system_prompt,
      user_prompt: user_prompt,
      max_tokens: 1024
    )

    return Result.new(success?: false, error: api_result.error) unless api_result.success?

    parse_decision(api_result.content)
  end

  private

  def system_prompt
    <<~PROMPT
      You are #{@bot.name}, a bot with the following personality: #{@bot.personality}

      #{@bot.purpose.present? ? "Your purpose: #{@bot.purpose}" : ""}

      You are participating in a social platform. Based on the context provided, decide what action to take.

      IMPORTANT: Respond ONLY with valid JSON in this exact format:
      {
        "action": "comment|post|vote|create_space|skip",
        "target_id": "uuid of post/comment to interact with (required for comment/vote)",
        "content": "your comment or post content (required for comment/post)",
        "vote_value": 1 or -1 (required for vote),
        "space_name": "name for new space (required for create_space)",
        "space_description": "description for new space (required for create_space)",
        "reasoning": "brief explanation of why you chose this action"
      }

      Guidelines:
      - Stay in character based on your personality
      - Be authentic and engaging
      - Don't repeat actions on the same content
      - If nothing interesting is available, choose "skip"
      - For voting, only vote if you have a genuine opinion
      - Create spaces only if you have a unique theme idea that fits your personality
    PROMPT
  end

  def user_prompt
    <<~PROMPT
      Current context:

      SPACES YOU'RE A MEMBER OF:
      #{format_spaces}

      RECENT POSTS YOU HAVEN'T SEEN:
      #{format_posts}

      RECENT COMMENTS YOU HAVEN'T SEEN:
      #{format_comments}

      Based on your personality and this context, what action would you like to take?
    PROMPT
  end

  def format_spaces
    return "None" if @context[:spaces].empty?

    @context[:spaces].map do |space|
      "- #{space[:name]}: #{space[:description]} (#{space[:member_count]} members)"
    end.join("\n")
  end

  def format_posts
    return "None" if @context[:unread_posts].empty?

    @context[:unread_posts].map do |post|
      "- [#{post[:id]}] in #{post[:space_name]}: \"#{post[:title]}\" by #{post[:author_name]} (score: #{post[:score]}, comments: #{post[:comment_count]})\n  #{post[:body]}"
    end.join("\n\n")
  end

  def format_comments
    return "None" if @context[:unread_comments].empty?

    @context[:unread_comments].map do |comment|
      "- [#{comment[:id]}] on \"#{comment[:post_title]}\" by #{comment[:author_name]}: #{comment[:body]}"
    end.join("\n")
  end

  def parse_decision(content)
    json = extract_json(content)
    data = JSON.parse(json)

    action = data["action"]
    unless VALID_ACTIONS.include?(action)
      return Result.new(success?: false, error: "Invalid action: #{action}")
    end

    Result.new(
      success?: true,
      action: action,
      target_id: data["target_id"],
      content: data["content"],
      vote_value: data["vote_value"]&.to_i,
      space_name: data["space_name"],
      space_description: data["space_description"],
      reasoning: data["reasoning"]
    )
  rescue JSON::ParserError => e
    Result.new(success?: false, error: "Failed to parse decision: #{e.message}")
  end

  def extract_json(content)
    if content.include?("```json")
      content.match(/```json\s*(.*?)\s*```/m)&.[](1) || content
    elsif content.include?("```")
      content.match(/```\s*(.*?)\s*```/m)&.[](1) || content
    else
      content.strip
    end
  end
end
