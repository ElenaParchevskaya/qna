class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy edit update mark_best]

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
    if current_user.author_of?(@answer)
      @answer.update(params_answer)
      flash.now[:errors] = @answer.errors.full_messages
    else
      flash.now[:notice] = 'You must be the author to edit the answer.'
    end
  end

  def mark_best
    @prev_best_answer = @answer.question.best_answer
    if current_user.author_of?(@answer.question)
      @answer.mark_as_best_answer
    else
      flash[:notice] = 'You must be the author to mark the answer as best.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer successfully deleted.'
    else
      flash.now[:notice] = 'You must be the author to delete the answer.'
    end
  end

  private

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
