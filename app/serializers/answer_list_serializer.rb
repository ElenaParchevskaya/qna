class AnswerListSerializer < ActiveModel::Serializer
  attributes :id, :body, :rating, :best_answer?, :created_at, :updated_at
  
  belongs_to :author
end
