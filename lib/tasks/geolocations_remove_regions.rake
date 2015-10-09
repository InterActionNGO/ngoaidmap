namespace :iom do
  namespace :geolocations do
    desc 'Update sectors for IATI'
    task :remove_regions => :environment do
      Geolocation.delete("adm_level > 1 AND country_name != 'Haiti'")
      puts 'Regions removed.'
    end
  end
end