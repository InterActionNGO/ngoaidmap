class ProjectWithoutOrganizationSerializer < ActiveModel::Serializer
  cache key: "main_api_project_wo_organization", expires_in: 3.hours
  attributes :type, :id, :name, :description, :international_partners, :local_partners, :cross_cutting_issues, :start_date, :end_date, :budget, :target_groups, :contact_person, :contact_email, :contact_phone_number, :record_created_at, :record_updated_at, :activities, :interaction_project_id, :additional_information, :contact_position, :project_website, :budget_currency, :budget_value_date, :target_project_reach_value, :actual_project_reach_value, :project_reach_unit
  has_many :sectors, serializer: SectorPreviewSerializer
  has_many :countries, serializer: CountryPreviewSerializer
  has_many :regions, serializer: RegionPreviewSerializer

  def type
    'projects'
  end
  def reporting_organization
    object.primary_organization
  end
  def international_partners
    object.implementing_organization
  end
  def local_partners
    object.partner_organizations
  end
  def target_groups
    object.target
  end
  def record_created_at
    object.created_at
  end
  def record_updated_at
    object.updated_at
  end
  def interaction_project_id
    object.intervention_id
  end
  def project_website
    object.website
  end
  def target_project_reach_value
    object.target_project_reach
  end
  def actual_project_reach_value
    object.actual_project_reach
  end
end
