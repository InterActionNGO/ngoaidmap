namespace :iom do
  desc "Add New Orgs"
  task :add_orgs => :environment do

    puts "Importing db/import/new-orgs-to-add-viget.csv ..."

    Organization.transaction do
      write_options = { :headers => ["name","id"], :write_headers => true }
      write_file    = File.expand_path("with_ids-new-orgs-to-add-viget.csv")

      CSV.open(write_file, "w", write_options) do |csv|
        read_options = { :headers => true, :return_headers => false }
        read_file    = File.expand_path("db/import/new-orgs-to-add-viget.csv")

        CSV.foreach(read_file, read_options) do |row|
          begin
            org = Organization.create(
              :name => row["name"],
              :international => (row["international"] == 't')
            )

            if org.persisted?
              csv << [org.name, org.id]
            else
              puts "#{row.to_hash.inspect} not saved"
            end
          rescue
            puts "#{row.to_hash.inspect} not saved"
          end
        end
      end

    end

    puts "Done!"
  end

  desc "Add New Partners"
  task :add_partners => :environment do

    puts "Importing db/import/new-partners-to-add-viget.csv ..."

    Partnership.transaction do
      read_options = { :headers => true, :return_headers => false }
      read_file    = File.expand_path("db/import/new-partners-to-add-viget.csv")

      CSV.foreach(read_file, read_options) do |row|
        begin
          partner = Partnership.create(
            :partner_id => row["partner_id"],
            :project_id => row["project_id"]
          )

          if !partner.persisted?
            puts "#{row.to_hash.inspect} not saved"
          end
        rescue
          puts "#{row.to_hash.inspect} not saved"
        end
      end
    end

    puts "Done!"
  end
end
