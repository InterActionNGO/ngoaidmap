namespace :iom do
  namespace :awardees do
    desc 'Asign prime awardees to projects'
    task :assign => :environment do
      filename = File.expand_path(File.join(Rails.root, 'db', 'import', "awardees_projects.csv"))
      CSV.foreach(filename, :headers => true, :col_sep => ';') do |aw|
        project = Project.find_by(id: aw['project_id'].to_i)
        organization = Organization.find_by(id: aw['prime_id'].to_i)
        if aw['prime_id'] != nil
          if project.present? && organization.present?
            project.prime_awardee_id = aw['prime_id'].to_i
            project.save!
          elsif organization.present?
            puts "Project #{aw['project_id']} not found"
          elsif project.present?
            puts "Organization #{aw['prime_id']} not found"
          else
            puts "Organization #{aw['prime_id']}  and project #{aw['project_id']} not found"
          end
        end
      end
      puts 'awardees assigned.'
    end
  end
end