class QuestionChannel < ApplicationCable::Channel
  def follow_question(data)
    question = Question.find(data["id"])
    stream_for question
  end
end
