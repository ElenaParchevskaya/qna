class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_one :award, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: proc { |attributes| attributes['name'].blank? }

  validates :title, :body, presence: true

  after_create :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user: author)
  end
end
