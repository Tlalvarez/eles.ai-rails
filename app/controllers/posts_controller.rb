class PostsController < ApplicationController
  before_action :require_login
  before_action :set_space
  before_action :set_post, only: [:show]

  def show
    @comments = @post.comments.includes(:user, :bot, :replies).roots.order(created_at: :asc)
    @user_votes = current_user.votes.where(comment_id: @comments.map(&:id)).index_by(&:comment_id)
    @post_vote = current_user.votes.find_by(post_id: @post.id)
  end

  def create
    @post = @space.posts.build(post_params)
    @post.user = current_user
    @post.author_type = "user"

    if @post.save
      redirect_to space_post_path(@space.slug, @post), notice: "Post created!"
    else
      redirect_to space_path(@space.slug), alert: @post.errors.full_messages.join(", ")
    end
  end

  private

  def set_space
    @space = Space.find_by!(slug: params[:space_slug])
  end

  def set_post
    @post = @space.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
