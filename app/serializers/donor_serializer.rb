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
#

class DonorSerializer < ActiveModel::Serializer
  attributes :type, :id, :name, :description, :website, :twitter, :facebook,
    :contact_person_name, :contact_company, :contact_person_position,
    :contact_email, :contact_phone_number, :site_specific_information,
    :logo

  has_many :donated_projects
  has_many :offices

  def type
    'donor'
  end

  def logo
    object.logo(:medium)
  end

end
