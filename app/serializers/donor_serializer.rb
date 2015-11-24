# == Schema Information
#
# Table name: donors
#
#  id                        :integer          not null, primary key
#  name                      :string(2000)
#  description               :text
#  website                   :string(255)
#  twitter                   :string(255)
#  facebook                  :string(255)
#  contact_person_name       :string(255)
#  contact_company           :string(255)
#  contact_person_position   :string(255)
#  contact_email             :string(255)
#  contact_phone_number      :string(255)
#  logo_file_name            :string(255)
#  logo_content_type         :string(255)
#  logo_file_size            :integer
#  logo_updated_at           :datetime
#  site_specific_information :text
#  created_at                :datetime
#  updated_at                :datetime
#  iati_organizationid       :string(255)
#  organization_type         :string(255)
#  organization_type_code    :integer
#

class DonorSerializer < ActiveModel::Serializer
  cache key: "main_api_donor", expires_in: 3.hours
  attributes :type, :id, :name, :record_created_at, :record_updated_at, :iati_organization_id, :iati_organization_type, :iati_organization_type_code
  has_many :donated_projects

  def donated_projects
    object.projects
  end

  def type
    'donor'
  end

  def record_created_at
    object.created_at
  end
  def record_updated_at
    object.updated_at
  end
  def iati_organization_id
    object.iati_organizationid
  end
  def iati_organization_type
    object.organization_type
  end
  def iati_organization_type_code
    object.organization_type_code
  end

end
