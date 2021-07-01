class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    @answer = question.answers.new(params_answer)
    if @answer.save
      render :show
    else
      render :new
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
