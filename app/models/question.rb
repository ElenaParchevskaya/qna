class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true
end
