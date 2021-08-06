class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @subscription = current_user.subscriptions.find_or_create_by(question: question)
  end

  def destroy
    @subscription = current_user.subscriptions.find_by(question: question)
    @subscription&.destroy
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end
