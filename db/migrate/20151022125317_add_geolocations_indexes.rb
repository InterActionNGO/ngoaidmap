class AddGeolocationsIndexes < ActiveRecord::Migration
  def self.up
    add_column :geolocations, :g0, :string
    add_index :geolocations, :g0
    add_index :geolocations, :country_uid
    add_index :geolocations, :country_name
  end
end
