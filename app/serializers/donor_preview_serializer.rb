class DonorPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_donor_preview", expires_in: 3.hours
  attributes :type, :id, :name, :record_created_at, :record_updated_at, :iati_organization_id, :iati_organization_type, :iati_organization_type_code
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
