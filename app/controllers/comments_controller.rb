class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: :create

  def create
    @comment = current_user.comments.create(comment_params.merge(commentable: commentable))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return unless @comment.valid?

    comment_partial = ApplicationController.render(
      partial: 'comments/comment',
      locals: { comment: @comment }
    )

    data = {
      user_id: current_user.id,
      comment: comment_partial,
      commentable_type: @comment.commentable_type,
      commentable_id: @comment.commentable_id
    }

    QuestionChannel.broadcast_to(@comment.question, data)
  end

  def commentable
    @commentable ||= params[:commentable_type].classify.constantize.find(params[:commentable_id])
  end
end
