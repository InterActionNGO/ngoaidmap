# == Schema Information
#
# Table name: organizations
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  description                     :text
#  budget                          :float
#  website                         :string(255)
#  twitter                         :string(255)
#  facebook                        :string(255)
#  hq_address                      :string(255)
#  contact_email                   :string(255)
#  contact_phone_number            :string(255)
#  donation_address                :string(255)
#  zip_code                        :string(255)
#  city                            :string(255)
#  state                           :string(255)
#  donation_phone_number           :string(255)
#  donation_website                :string(255)
#  site_specific_information       :text
#  created_at                      :datetime
#  updated_at                      :datetime
#  logo_file_name                  :string(255)
#  logo_content_type               :string(255)
#  logo_file_size                  :integer
#  logo_updated_at                 :datetime
#  contact_name                    :string(255)
#  contact_position                :string(255)
#  contact_zip                     :string(255)
#  contact_city                    :string(255)
#  contact_state                   :string(255)
#  contact_country                 :string(255)
#  donation_country                :string(255)
#  media_contact_name              :string(255)
#  media_contact_position          :string(255)
#  media_contact_phone_number      :string(255)
#  media_contact_email             :string(255)
#  main_data_contact_name          :string(255)
#  main_data_contact_position      :string(255)
#  main_data_contact_phone_number  :string(255)
#  main_data_contact_email         :string(255)
#  main_data_contact_zip           :string(255)
#  main_data_contact_city          :string(255)
#  main_data_contact_state         :string(255)
#  main_data_contact_country       :string(255)
#  organization_id                 :string(255)
#  organization_type               :string(255)
#  organization_type_code          :integer
#  iati_organizationid             :string(255)
#  publishing_to_iati              :boolean          default(FALSE)
#  membership_status               :string(255)      default("active")
#

class OrganizationSerializer < ActiveModel::Serializer
  cache key: "main_api_organization", expires_in: 3.hours
  attributes :type, :id, :name, :description, :logo, :twitter, :facebook, :website, :hq_street_address, :contact_email, :contact_phone_number, :donation_street_address, :donation_zip_code, :donation_city, :donation_state, :donation_phone_number, :donation_website, :record_created_at, :record_updated_at, :contact_name, :contact_position, :hq_zip_code, :hq_city, :hq_state, :hq_country, :donation_country, :media_contact_name, :media_contact_position, :media_contact_phone_number, :media_contact_email, :iati_organization_type, :iati_organization_type_code, :iati_organization_id, :publishing_to_iati, :interaction_membership_status, :organization_letter_code#, :sectors
  has_many :projects, serializer: ProjectWithoutOrganizationSerializer
  def type
    'organizations'
  end
  # def sectors
  #   sectors = []
  #   object.projects.each do |project|
  #     project.sectors.each do |sector|
  #       sectors << { id: sector.id, name: sector.name }
  #     end
  #   end
  #   sectors.uniq
  # end
  def logo
    object.logo(:medium)
  end
  def hq_street_address
    object.hq_address
  end
  def donation_street_address
    object.donation_address
  end
  def donation_zip_code
    object.zip_code
  end
  def donation_city
    object.city
  end
  def donation_state
    object.state
  end
  def record_created_at
    object.created_at
  end
  def record_updated_at
    object.updated_at
  end
  def hq_zip_code
    object.contact_zip
  end
  def hq_city
    object.contact_city
  end
  def hq_state
    object.contact_state
  end
  def hq_country
    object.contact_country
  end
  def iati_organization_type
    object.organization_type
  end
  def iati_organization_type_code
    object.organization_type_code
  end
  def iati_organization_id
    object.iati_organizationid
  end
  def interaction_membership_status
    object.membership_status
  end
  def organization_letter_code
    object.organization_id
  end
end
