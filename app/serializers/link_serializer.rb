class LinkSerializer < ActiveModel::Serializer
  attributes :id, :name, :url, :gist?, :created_at, :updated_at
end
