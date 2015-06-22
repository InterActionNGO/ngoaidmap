class ProjectSerializer < ActiveModel::Serializer
  cache key: "project_#{object.id}", expires_in: 3.hours
  attributes :type, :id, :name, :description
  has_one :organization, serializer: OrganizationPreviewSerializer
  has_many :sectors, serializer: SectorPreviewSerializer
  has_many :countries, serializer: CountryPreviewSerializer
  has_many :regions, serializer: RegionPreviewSerializer

  def organization
    object.primary_organization
  end
  def type
    'projects'
  end
end
