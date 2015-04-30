# == Schema Information
#
# Table name: regions
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  level            :integer
#  country_id       :integer
#  parent_region_id :integer
#  center_lat       :float
#  center_lon       :float
#  path             :string(255)
#  the_geom         :string
#  gadm_id          :integer
#  wiki_url         :string(255)
#  wiki_description :text
#  code             :string(255)
#  the_geom_geojson :text
#  ia_name          :text
#

class Region < ActiveRecord::Base

  belongs_to :country
  belongs_to :region, :foreign_key => :parent_region_id, :class_name => 'Region'

  has_and_belongs_to_many :projects
end
