class GeolocationPreviewSerializer < ActiveModel::Serializer
  attributes :id, :uid, :name, :latitude, :longitude, :country_code, :country_name, :country_uid, :provider, :adm_level, :g0, :g1, :g2, :g3, :g4, :custom_geo_source
end
