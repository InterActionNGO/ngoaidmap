class SectorPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_sector_preview", expires_in: 3.hours
  attributes :name
  link :self do
      api_sector_path(object)
  end
end
