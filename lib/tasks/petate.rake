namespace :db do
  desc "Populate locations projects relations"
  task petate: :environment do
    if Rails.env == "development" || Rails.env == "production" || Rails.env == "staging"
      ActiveRecord::Base.connection.execute("TRUNCATE geolocations_projects")
      puts 'old relations table dropped'
      projects = Project.all
      geos = Geolocation.where('adm_level IS NOT NULL')
      g_size = geos.size
      p_size = projects.size
      projects.each do |p|
        t = 1+rand(2)
        t.times do
          g = rand(g_size)
          p.geolocations << geos[g]
        end
      end
      puts 'done!'
    else
      puts 'Take it easy'
    end
  end
end