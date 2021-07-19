class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :status, presence: true
  validates :user, uniqueness: { scope: %i[votable_type votable_id] }

  enum status: { like: 1, dislike: -1 }
end
