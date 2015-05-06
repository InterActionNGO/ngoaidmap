class OrganizationSerializer < ActiveModel::Serializer
  attributes :type, :id, :name, :description, :sectors, :logo
  has_many :projects, serializer: ProjectWithoutOrganizationSerializer
  def type
    'organizations'
  end
  def sectors
    sectors = []
    object.projects.each do |project|
      project.sectors.each do |sector|
        sectors << { id: sector.id, name: sector.name }
      end
    end
    sectors
  end
  def logo
    object.logo(:medium)
  end
end
