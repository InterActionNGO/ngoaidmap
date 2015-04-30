# == Schema Information
#
# Table name: countries
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  code             :string(255)
#  center_lat       :float
#  center_lon       :float
#  the_geom         :string
#  wiki_url         :string(255)
#  wiki_description :text
#  iso2_code        :string(255)
#  iso3_code        :string(255)
#  the_geom_geojson :text
#

class Country < ActiveRecord::Base

  has_many :regions
  has_and_belongs_to_many :projects
  def self.custom_fields
    (columns.map{ |c| c.name } - ['the_geom']).map{ |c| "#{self.table_name}.#{c}" }
  end
end
