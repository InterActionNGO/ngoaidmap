class ProjectWithoutOrganizationSerializer < ActiveModel::Serializer
  attributes :type, :id, :name, :description
  has_many :sectors, serializer: SectorPreviewSerializer
  has_many :countries, serializer: CountryPreviewSerializer
  has_many :regions, serializer: RegionPreviewSerializer

  def type
    'projects'
  end
end
