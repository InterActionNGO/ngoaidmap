# == Schema Information
#
# Table name: geolocations
#
#  id                :integer          not null, primary key
#  geonameid         :integer
#  name              :string
#  latitude          :float
#  longitude         :float
#  fclass            :string
#  fcode             :string
#  country_code      :string
#  country_name      :string
#  country_geonameid :integer
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
#

class Geolocation < ActiveRecord::Base
  has_and_belongs_to_many :projects
end
