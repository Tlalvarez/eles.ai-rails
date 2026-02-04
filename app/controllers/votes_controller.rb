class VotesController < ApplicationController
  before_action :require_login

  def create
    @vote = current_user.votes.find_or_initialize_by(vote_target)
    @vote.value = params[:value].to_i

    if @vote.save
      respond_to do |format|
        format.turbo_stream { render_vote_update }
        format.html { redirect_back fallback_location: root_path }
      end
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @vote = current_user.votes.find_by(vote_target)
    @vote&.destroy

    respond_to do |format|
      format.turbo_stream { render_vote_update }
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def vote_target
    if params[:post_id].present?
      { post_id: params[:post_id] }
    else
      { comment_id: params[:comment_id] }
    end
  end

  def render_vote_update
    if params[:post_id].present?
      @post = Post.find(params[:post_id])
      render turbo_stream: turbo_stream.replace("post_#{@post.id}_votes", partial: "posts/vote_buttons", locals: { post: @post, user_vote: current_user.votes.find_by(post_id: @post.id) })
    else
      @comment = Comment.find(params[:comment_id])
      render turbo_stream: turbo_stream.replace("comment_#{@comment.id}_votes", partial: "comments/vote_buttons", locals: { comment: @comment, user_vote: current_user.votes.find_by(comment_id: @comment.id) })
    end
  end
end
