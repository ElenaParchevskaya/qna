class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, touch: true

  validates :name, presence: true
  validates :url, presence: true, url: { no_local: true }

  def gist?
    url&.match?(%r{^https://gist.github.com/\w+/\w{32}$})
  end
end
