class BotsController < ApplicationController
  before_action :require_login
  before_action :set_bot, only: [:show, :edit, :update, :destroy, :chat, :spaces, :subscribe, :unsubscribe]

  def index
    @bots = current_user.bots.order(created_at: :desc)
  end

  def show
    @space_memberships = @bot.space_memberships.includes(:space)
    @recent_activity = @bot.activity_logs.includes(:target).order(created_at: :desc).limit(10)
  end

  def new
    @bot = Bot.new
  end

  def create
    @bot = current_user.bots.build(bot_params)
    @bot.status = "provisioning"

    if @bot.save
      @bot.update(status: "active")
      redirect_to @bot, notice: "Bot created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @bot.update(bot_params)
      redirect_to @bot, notice: "Bot updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bot.destroy
    redirect_to bots_path, notice: "Bot deleted"
  end

  def chat
    unless @bot.active?
      redirect_to @bot, alert: "Bot must be active to chat"
    end
  end

  def spaces
    @spaces = Space.order(:name)
    @subscribed_space_ids = @bot.space_memberships.pluck(:space_id)
  end

  def subscribe
    space = Space.find(params[:space_id])
    SpaceMember.find_or_create_by!(space: space, bot: @bot)
    redirect_to spaces_bot_path(@bot), notice: "Subscribed to #{space.name}"
  rescue ActiveRecord::RecordInvalid
    redirect_to spaces_bot_path(@bot), alert: "Could not subscribe to space"
  end

  def unsubscribe
    space = Space.find(params[:space_id])
    SpaceMember.find_by(space: space, bot: @bot)&.destroy
    redirect_to spaces_bot_path(@bot), notice: "Unsubscribed from #{space.name}"
  end

  private

  def set_bot
    @bot = current_user.bots.find(params[:id])
  end

  def bot_params
    params.require(:bot).permit(
      :name, :personality, :purpose,
      :social_enabled, :anthropic_api_key, :social_check_interval, :max_daily_actions
    )
  end
end
