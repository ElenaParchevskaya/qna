class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[destroy]

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(params_answer.merge(author: current_user))

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created.'
    else
      @question.reload
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
    else
      redirect_to question_path(@answer.question), notice: 'You must be the author to delete the answer.'
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
