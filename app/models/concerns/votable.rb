module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def rating
    votes.like.count - votes.dislike.count
  end

  def vote_of(user)
    votes.find_by(user: user)
  end
end
