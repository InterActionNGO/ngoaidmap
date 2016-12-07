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

    puts "Importing db/import/new-partner-relations-post-deploy-viget-2016-12-06.csv ..."

    Partnership.transaction do
      read_options = { :headers => true, :return_headers => false }
      read_file    = File.expand_path("db/import/new-partner-relations-post-deploy-viget-2016-12-06.csv")

      CSV.foreach(read_file, read_options) do |row|
        begin
          partner = Partnership.create(
            :partner_id => row["partner_id"],
            :project_id => row["project_id"]
          )

          if !partner.persisted?
            puts "#{row.to_hash.inspect} not saved with errors #{partner.errors.full_messages}"
          end
        rescue => e
          puts "#{row.to_hash.inspect} not saved because of error #{e.inspect} at #{e.backtrace[0]}"
        end
      end
    end

    puts "Done!"
  end

  desc "Flatten Duplicate orgs"
  task :flatten_dup_orgs => :environment do

    puts "Importing db/import/duplicates_for_merging.csv ..."

    read_options = { :headers => true, :return_headers => false }
    read_file    = File.expand_path("db/import/duplicates_for_merging.csv")

    CSV.foreach(read_file, read_options) do |row|
      begin
        keep_org = Organization.find(row['keep_id'])
        dup_org = Organization.find(row['merge_and_discard_id'])
        
        dup_org_donations = dup_org.donations_made.to_a
        dup_org.donations_made.update_all(donor_id: keep_org.id)

        keep_org_donations = keep_org.reload.donations_made(true)

        if dup_org_donations.all?{|org| keep_org_donations.include?(org) }
          dup_org.reload.donations_made(true)
          puts "Removing Org(#{dup_org.id}) and relations including donations #{dup_org.donations_made.map(&:id).inspect}"
          dup_org.destroy
        else
          puts "Not all donations moved for Org(#{dup_org.id})"
        end
      rescue => e
        puts "#{row.to_hash.inspect} had error #{e.inspect} at #{e.backtrace[0]}"
      end
    end

    puts "Done!"
  end

  desc "Remove Duplicate orgs"
  task :remove_dup_orgs => :environment do

    puts "Importing db/import/duplicate_orgs_with_no_relations_to_remove.csv ..."

    read_options = { :headers => true, :return_headers => false }
    read_file    = File.expand_path("db/import/duplicate_orgs_with_no_relations_to_remove.csv")

    ids = CSV.read(read_file, read_options)
    Organization.where(id: ids).destroy_all

    puts "Done!"
  end
end
