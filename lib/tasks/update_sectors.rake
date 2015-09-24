namespace :iom do
  namespace :sectors do
    desc 'Update sectors for IATI'
    task :update => :environment do
      filename = File.expand_path(File.join(Rails.root, 'db', 'import', "transformed_sectors.csv"))
      CSV.foreach(filename, :headers => true, :col_sep => ',') do |row|
        sector = Sector.find_or_initialize_by(name: row['name'])
        sector.name =                  row['new_name']
        sector.oecd_dac_name =         row['oecd_dac_name']
        sector.oecd_dac_purpose_code = row['oecd_dac_purpose_code']
        sector.sector_vocab_code =     row['sector_vocab_code']
        sector.save!
      end
      if sector = Sector.find_by(name: 'Non-food relief items (NFIs)')
        sector.destroy!
      end
      puts 'Sectors updated.'
    end
  end
end