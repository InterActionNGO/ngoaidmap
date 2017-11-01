namespace :iom do
    
   desc "Delete duplicate projects created by batch upload"
   task remove_duplicate_projects: :environment do
      Project.transaction do
          Project.where('id >= 21324 and id <= 21356 and primary_organization_id = 65').each do |p|
              puts p.destroy
          end
      end
   end
end