class TagPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_tag_preview", expires_in: 3.hours
  attribute :name
  link :self do
      api_tag_path(object)
  end
end
