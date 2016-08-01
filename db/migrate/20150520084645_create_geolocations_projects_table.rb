class CreateGeolocationsProjectsTable < ActiveRecord::Migration
   def self.up
    create_table :geolocations_projects, :id => false do |t|
        t.references :geolocation
        t.references :project
    end
    add_index :geolocations_projects, [:geolocation_id, :project_id]
    add_index :geolocations_projects, :project_id
  end

  def self.down
    drop_table :geolocations_projects
  end
end
