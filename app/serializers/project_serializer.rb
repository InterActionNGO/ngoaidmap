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
#  prime_awardee_id                        :integer
#  budget_currency                         :string(255)
#  budget_value_date                       :date
#  target_project_reach                    :integer
#  actual_project_reach                    :integer
#  project_reach_unit                      :string(255)
#

class ProjectSerializer < ActiveModel::Serializer
  #cache key: "project_#{object.id}", expires_in: 3.hours
  attributes :type, :id, :name, :description
  has_one :organization, serializer: OrganizationPreviewSerializer
  has_many :sectors, serializer: SectorPreviewSerializer
  has_many :geolocations, serializer: GeolocationPreviewSerializer
  has_many :donors, serializer: DonorPreviewSerializer

  def organization
    object.primary_organization
  end
  def type
    'projects'
  end
end
