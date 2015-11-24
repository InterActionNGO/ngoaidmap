class OrganizationPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_organization_preview", expires_in: 3.hours
  attributes :type, :id, :name, :description, :logo, :twitter, :facebook, :website, :hq_street_address, :contact_email, :contact_phone_number, :donation_street_address, :donation_zip_code, :donation_city, :donation_state, :donation_phone_number, :donation_website, :record_created_at, :record_updated_at, :contact_name, :contact_position, :hq_zip_code, :hq_city, :hq_state, :hq_country, :donation_country, :media_contact_name, :media_contact_position, :media_contact_phone_number, :media_contact_email, :interaction_member, :iati_organization_type, :iati_organization_type_code, :iati_organization_id, :publishing_to_iati, :interaction_membership_status, :organization_letter_code
  def type
    'organizations'
  end
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
