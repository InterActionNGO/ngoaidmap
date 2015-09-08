# == Schema Information
#
# Table name: geolocations
#
#  id                :integer          not null, primary key
#  uid               :string
#  name              :string
#  latitude          :float
#  longitude         :float
#  fclass            :string
#  fcode             :string
#  country_code      :string
#  country_name      :string
#  country_uid       :string
#  cc2               :string
#  admin1            :string
#  admin2            :string
#  admin3            :string
#  admin4            :string
#  provider          :string           default("Geonames")
#  adm_level         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  g0                :string
#  g1                :string
#  g2                :string
#  g3                :string
#  g4                :string
#  custom_geo_source :string
#

class Geolocation < ActiveRecord::Base
  has_and_belongs_to_many :projects
  def self.sum_projects
    query = %{
        SELECT geolocations.g0, geolocations.country_name,
        COUNT(DISTINCT(projects.id)) as total_projects FROM geolocations
        INNER JOIN geolocations_projects
        ON geolocations_projects.geolocation_id = geolocations.id
        INNER JOIN projects
        ON projects.id = geolocations_projects.project_id
        WHERE projects.end_date > NOW()
        GROUP BY geolocations.g0, geolocations.country_name
        ORDER BY total_projects DESC
    }
    result = ActiveRecord::Base.connection.execute(query)
    result.map{|r| r}
  end
end
