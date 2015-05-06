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
