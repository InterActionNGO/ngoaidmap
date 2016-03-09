namespace :iom do
  desc "Populate locations projects relations"
  task update_sites: :environment do
    Site.published.each do |s|
      s.save!
    end
  end
end