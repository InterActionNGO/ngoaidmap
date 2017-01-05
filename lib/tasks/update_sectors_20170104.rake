namespace :nam do
    namespace :sectors do
        desc 'Update sectors for IATI - #2'
        task :update => :environment do
            filename = File.expand_path(File.join(Rails.root, 'db', 'import', "2017-01-04-sectors-iati.csv"))
            CSV.foreach(filename, :headers => true, :col_sep => ',') do |row|
                sector = Sector.find(row['id'])
                sector.oecd_dac_name = row['oecd_dac_name']
                sector.oecd_dac_purpose_code = row['oecd_dac_purpose_code']
                sector.sector_vocab_code = row['sector_vocab_code']
                sector.save!
            end
        end
    end
end
