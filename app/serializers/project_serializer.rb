class ProjectSerializer < ActiveModel::Serializer
    cache key: "main_api_project", expires_in: 3.hours
    attribute :reporting_organization_name do
        object.primary_organization.name
    end
    attribute :intervention_id, key: :interaction_intervention_id
    attribute :organization_id, key: :reporting_organization_project_id
    attribute :name
    attribute :description
    attribute :activities
    attribute :additional_information
    attribute :geographical_scope
    attribute :start_date
    attribute :end_date
    attribute :prime_awardee_name do
        if awardee = object.prime_awardee
            awardee.name
        else
            nil
        end
    end
    attribute :budget, key: :budget_value_original
    attribute :budget_usd, key: :budget_value_usd
    attribute :budget_currency, key: :budget_currency_original
    attribute :budget_value_date
    attribute :cross_cutting_issues
    attribute :target, key: :target_groups
    attribute :target_project_reach, key: :target_project_reach_value
    attribute :actual_project_reach, key: :actual_project_reach_value
    attribute :project_reach_unit
    attribute :website, key: :project_website
    attribute :contact_person
    attribute :contact_position
    attribute :contact_email
    attribute :contact_phone_number
    attribute :created_at, key: :record_created_at
    attribute :updated_at, key: :record_updated_at

    has_one :reporting_organization, serializer: OrganizationPreviewSerializer
    has_one :prime_awardee, serializer: OrganizationPreviewSerializer
    has_many :donors, serializer: OrganizationPreviewSerializer
    has_many :partners, serializer: OrganizationPreviewSerializer
    has_many :sectors, serializer: SectorPreviewSerializer
    has_many :tags, serializer: TagPreviewSerializer
    has_many :geolocations, serializer: GeolocationPreviewSerializer
    
    link :self do
        api_project_path(object)
    end
    
    def reporting_organization
        object.primary_organization
    end
  
end
