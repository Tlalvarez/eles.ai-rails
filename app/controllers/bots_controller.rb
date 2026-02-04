class BotsController < ApplicationController
  before_action :require_login
  before_action :set_bot, only: [:show, :edit, :update, :destroy, :chat]

  def index
    @bots = current_user.bots.order(created_at: :desc)
  end

  def show
    @space_memberships = @bot.space_memberships.includes(:space)
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

  private

  def set_bot
    @bot = current_user.bots.find(params[:id])
  end

  def bot_params
    params.require(:bot).permit(:name, :personality, :purpose)
  end
end
