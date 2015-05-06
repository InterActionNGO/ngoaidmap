class SectorSerializer < ActiveModel::Serializer
  attributes :type, :id, :name, :donors
  has_many :projects, serializer: ProjectWithoutSectorsSerializer
  def type
    'sectors'
  end
  def donors
    object.donors
  end
end
