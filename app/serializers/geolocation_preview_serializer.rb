class GeolocationPreviewSerializer < ActiveModel::Serializer
    cache key: "main_api_geolocation_preview", expires_in: 3.hours
    attribute :name
    attribute :adm_level, key: :admin_level
    attribute :latitude, key: :center_latitude
    attribute :longitude, key: :center_longitude
    link :self do
        api_geolocation_path(object)
    end
end

