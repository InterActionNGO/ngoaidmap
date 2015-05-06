class RegionPreviewSerializer < ActiveModel::Serializer
  attributes :id, :name, :level, :the_geom, :center_lat, :center_lon
end
