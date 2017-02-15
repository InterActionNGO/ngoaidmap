class OrganizationPreviewSerializer < ActiveModel::Serializer
  cache key: "main_api_organization_preview", expires_in: 3.hours
  attribute :name
  link :self do
      api_organization_path(object)
  end
end
