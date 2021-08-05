class FileSerializer < ActiveModel::Serializer
  attributes :id, :filename, :url

  def url
    Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true)
  end
end
