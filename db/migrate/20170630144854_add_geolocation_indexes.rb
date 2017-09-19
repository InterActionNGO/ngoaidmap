class AddGeolocationIndexes < ActiveRecord::Migration
  def self.up
      add_index :geolocations, :readable_path
  end

  def self.down
      remove_index :geolocations, :readable_path
  end
end
