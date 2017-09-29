class IdentifierPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_identifier_preview", expires_in: 3.hours
  attribute :assigning_organization_name
  attribute :assigning_organization_id
  attribute :identifier
  
  def assigning_organization_name
      Organization.find(object.assigner_org_id).name
  end
  def assigning_organization_id
     object.assigner_org_id 
  end
end
