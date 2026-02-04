class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.author_type = "user"

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to space_post_path(@space.slug, @post) }
      end
    else
      redirect_to space_post_path(@space.slug, @post), alert: @comment.errors.full_messages.join(", ")
    end
  end

  private

  def set_post
    @space = Space.find_by!(slug: params[:space_slug])
    @post = @space.posts.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
