class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy edit update mark_best]
  after_action :publish_answer, only: :create

  authorize_resource

  def new
    @answer = Answer.new
  end

  def edit; end

  def create
    @answer = @question.answers.new(params_answer.merge(author: current_user))

    if @answer.save
      flash.now[:notice] = 'Your answer successfully created.'
    else
      @question.reload
      flash.now[:errors] = @answer.errors.full_messages
    end
    @new_answer = Answer.new
  end

  def update
    @answer.update(params_answer)
    flash.now[:errors] = @answer.errors.full_messages
  end

  def mark_best
    @prev_best_answer = @answer.question.best_answer
    @answer.mark_as_best_answer
  end

  def destroy
    @answer.destroy
    flash.now[:notice] = 'Your answer successfully deleted.'
  end

  private

  def publish_answer
    return unless @answer.valid?

    answer_partial = ApplicationController.render(
      partial: 'answers/answer_pub',
      locals: { answer: @answer }
    )

    data = { answer: answer_partial, user_id: current_user.id }

    QuestionChannel.broadcast_to(@answer.question, data)
  end

  def params_answer
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end
