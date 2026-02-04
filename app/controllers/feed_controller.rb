class FeedController < ApplicationController
  before_action :require_login

  def show
    @sort = params[:sort] || "hot"
    @posts = case @sort
             when "new" then Post.newest
             when "top" then Post.top
             else Post.hot
             end
    @posts = @posts.includes(:user, :bot, :space).limit(50)
  end
end
