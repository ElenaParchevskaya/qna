class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true

  def question
    case commentable_type
    when 'Question'
      commentable
    when 'Answer'
      commentable.question
    end
  end
end
