class CountryPreviewSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :center_lat, :center_lon
end
