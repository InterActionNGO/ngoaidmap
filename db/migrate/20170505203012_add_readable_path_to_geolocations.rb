class AddReadablePathToGeolocations < ActiveRecord::Migration
  def self.up
      add_column :geolocations, :readable_path, :string
  end

  def self.down
      remove_column :geolocations, :readable_path
  end
end
