class CreateGeolocations < ActiveRecord::Migration
  def self.up
    create_table :geolocations do |t|
      t.integer :uid
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :fclass
      t.string :fcode
      t.string :country_code
      t.string :country_name
      t.integer :country_uid
      t.string :cc2
      t.string :g1
      t.string :g2
      t.string :g3
      t.string :g4
      t.string :provider, :default => 'Geonames'
      t.integer :adm_level
      t.string :custom_geo_source, :string

      t.timestamps :null => false
    end
    add_index :geolocations, :uid
    add_index :geolocations, :g1
    add_index :geolocations, :g2
    add_index :geolocations, :g3
    add_index :geolocations, :g4
  end
end
