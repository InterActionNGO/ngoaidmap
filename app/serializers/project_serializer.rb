# == Schema Information
#
# Table name: projects
#
#  id                                      :integer          not null, primary key
#  name                                    :string(2000)
#  description                             :text
#  primary_organization_id                 :integer
#  implementing_organization               :text
#  partner_organizations                   :text
#  cross_cutting_issues                    :text
#  start_date                              :date
#  end_date                                :date
#  budget                                  :float
#  target                                  :text
#  estimated_people_reached                :integer
#  contact_person                          :string(255)
#  contact_email                           :string(255)
#  contact_phone_number                    :string(255)
#  site_specific_information               :text
#  created_at                              :datetime
#  updated_at                              :datetime
#  the_geom                                :geometry
#  activities                              :text
#  intervention_id                         :string(255)
#  additional_information                  :text
#  awardee_type                            :string(255)
#  date_provided                           :date
#  date_updated                            :date
#  contact_position                        :string(255)
#  website                                 :string(255)
#  verbatim_location                       :text
#  calculation_of_number_of_people_reached :text
#  project_needs                           :text
#  idprefugee_camp                         :text
#  organization_id                         :string(255)
#  budget_currency                         :string(255)
#  budget_value_date                       :date
#  target_project_reach                    :float
#  actual_project_reach                    :float
#  project_reach_unit                      :string(255)
#  prime_awardee_id                        :integer
#  geographical_scope                      :string(255)      default("regional")
#

class ProjectSerializer < ActiveModel::Serializer
  cache key: "main_api_project", expires_in: 3.hours
  attributes :type, :id, :name, :description, :international_partners, :local_partners, :cross_cutting_issues, :start_date, :end_date, :budget, :target_groups, :contact_person, :contact_email, :contact_phone_number, :record_created_at, :record_updated_at, :activities, :interaction_project_id, :additional_information, :contact_position, :project_website, :budget_currency, :budget_value_date, :target_project_reach_value, :actual_project_reach_value, :project_reach_unit
  has_one :reporting_organization, serializer: OrganizationPreviewSerializer
  has_one :prime_awardee, serializer: OrganizationPreviewSerializer
  has_many :sectors, serializer: SectorPreviewSerializer
  has_many :geolocations, serializer: GeolocationPreviewSerializer
  has_many :donors, serializer: OrganizationPreviewSerializer

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
