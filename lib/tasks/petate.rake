require 'csv'
namespace :db do
  desc "Populate locations projects relations"
  task petate: :environment do
    if Rails.env == "development" || Rails.env == "production" || Rails.env == "staging"
      errors = []
      ActiveRecord::Base.connection.execute("TRUNCATE geolocations_projects")
      puts 'old relations table dropped'
      filename = File.expand_path(File.join(Rails.root, 'db', 'import', "projects_geoids.csv"))
      CSV.foreach(filename, :headers => false, :col_sep => ',') do |geo_uid, p_id|
          puts geo_uid
          puts p_id
        if geolocation_id = Geolocation.find_by(uid: geo_uid).try(:id)
          ActiveRecord::Base.connection.execute("INSERT INTO geolocations_projects (geolocation_id, project_id) VALUES (#{geolocation_id}, #{p_id})")
        else
          errors << geo_uid
        end
      end
      puts "done with #{errors.size} errors"
      puts errors
    else
      puts 'Take it easy'
    end
  end
end