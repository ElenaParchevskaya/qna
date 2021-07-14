class Answer < ApplicationRecord
  include Linkable

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'

  has_many_attached :files

  validates :body, presence: true

  before_destroy :clear_best_answer, if: :best_answer?

  def best_answer?
    question.best_answer_id == id
  end

  def mark_as_best_answer
    transaction do
      question.update(best_answer_id: id)
      question.award&.update(user: author)
    end
  end

  private

  def clear_best_answer
    question.update(best_answer: nil)
  end
end
