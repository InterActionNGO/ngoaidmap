class TagSerializer < ActiveModel::Serializer
  cache key: "main_api_tag", expires_in: 3.hours
  attribute :name
  has_many :projects, serializer: ProjectPreviewSerializer
  link :self do
      api_tag_path(object)
  end
end