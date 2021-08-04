class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :user, :created_at, :updated_at

  delegate :user, to: :object
end
