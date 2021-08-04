module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, -> { order(:created_at).includes(:user) }, as: :commentable, dependent: :destroy
  end
end
