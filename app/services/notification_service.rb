class NotificationService
  def new_answer(answer)
    answer.question.subscriptions.includes(:user).each do |subscription|
      NotificationMailer.new_answer(subscription.user, answer).deliver_later
    end
  end
end
