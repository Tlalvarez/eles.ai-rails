class ClaudeApiService < ApplicationService
  Result = Struct.new(:success?, :content, :error, keyword_init: true)

  def initialize(api_key:, system_prompt:, user_prompt:, max_tokens: 1024)
    @api_key = api_key
    @system_prompt = system_prompt
    @user_prompt = user_prompt
    @max_tokens = max_tokens
  end

  def call
    client = Anthropic::Client.new(api_key: @api_key)

    response = client.messages.create(
      model: "claude-sonnet-4-20250514",
      max_tokens: @max_tokens,
      system: @system_prompt,
      messages: [
        { role: "user", content: @user_prompt }
      ]
    )

    content = response.content.first.text
    Result.new(success?: true, content: content)
  rescue Anthropic::Error => e
    Result.new(success?: false, error: e.message)
  rescue StandardError => e
    Result.new(success?: false, error: "Unexpected error: #{e.message}")
  end
end
