namespace :iom do
  desc "Mark projects with 'Humanitarian Aid' sector as humanitarian"
  task migrate_humanitarian_projects: :environment do
    Project.find_each do |project|
      if project.sectors.any? { |s| s.id == 18 }
        project.update_attribute(:humanitarian, true)
      end
    end
  end

  desc "Import humanitarian scope types"
  task import_humanitarian_scope_types: :environment do
    HumanitarianScopeType.import("doc/schemas/humanitarian_scope_type.json") 
  end

  desc "Import humanitarian scope vocabularies"
  task import_humanitarian_scope_vocabularies: :environment do
    HumanitarianScopeVocabulary.import("doc/schemas/humanitarian_scope_vocabulary.json") 
  end
end
