class SectorPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_sector_preview", expires_in: 3.hours
  attributes :type, :id, :name
  def type
    'sectors'
  end
end
