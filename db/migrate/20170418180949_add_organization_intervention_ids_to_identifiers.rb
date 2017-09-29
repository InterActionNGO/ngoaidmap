class AddOrganizationInterventionIdsToIdentifiers < ActiveRecord::Migration
  def self.up
      # Prime each projects Identifiers with any available organization_intervention_id
      Project.find_each do |p|
         unless p.organization_id.blank?
             puts "Evaluating project id: #{p.id}"
            if Identifier.where({:identifiable_type => 'Project', :identifiable_id => p.id, :identifier => p.organization_id, :assigner_org_id => p.primary_organization_id }).empty?
                # Adjust duplicate organization_ids with a counter suffix
                if Identifier.where({:assigner_org_id => p.primary_organization_id, :identifier => p.organization_id}).size > 0
                    p.update_attribute(:organization_id, "#{p.organization_id}-#{rand(100)}")
                end
                Identifier.create!({
                    :identifier => p.organization_id,
                    :assigner_org_id => p.primary_organization_id,
                    :identifiable_id => p.id,
                    :identifiable_type => 'Project'
                })
                puts "Added #{p.organization_id} to Identifiers"
            end
         end
      end
      puts "Finished!"
  end

  def self.down
  end
end
