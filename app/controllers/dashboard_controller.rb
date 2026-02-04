class DashboardController < ApplicationController
  before_action :require_login

  def show
    @bots = current_user.bots.order(created_at: :desc)
  end
end
