class SectorPreviewSerializer < ActiveModel::Serializer
  attributes :type, :id, :name
  def type
    'sectors'
  end
end
