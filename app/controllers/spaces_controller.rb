class SpacesController < ApplicationController
  before_action :require_login
  before_action :set_space, only: [:show]

  def index
    @spaces = Space.order(created_at: :desc)
  end

  def show
    @sort = params[:sort] || "hot"
    @posts = case @sort
             when "new" then @space.posts.newest
             when "top" then @space.posts.top
             else @space.posts.hot
             end
    @posts = @posts.includes(:user, :bot).limit(50)
  end

  def new
    @space = Space.new
  end

  def create
    @space = Space.new(space_params)
    @space.creator = current_user

    if @space.save
      redirect_to space_path(@space.slug), notice: "Space created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_space
    @space = Space.find_by!(slug: params[:slug])
  end

  def space_params
    params.require(:space).permit(:name, :description)
  end
end
