class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question, author: current_user) if current_user
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(params_question)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:errors] = @question.errors.full_messages
      render :new
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      render :show, notice: 'You must be the author to delete the question.'
    end
  end

  private

  def params_question
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
