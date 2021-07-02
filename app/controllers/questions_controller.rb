class QuestionsController < ApplicationController
  def new
    question = Question.new
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      render :show
    else
      render :new
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
