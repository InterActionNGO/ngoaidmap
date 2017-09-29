class AddInterActionIdsToIdentifiers < ActiveRecord::Migration
  def self.up
      # Prime each projects Identifiers with the interaction_intervention_id
      ia_id = Organization.where(:name => 'InterAction').first.id
      Project.find_each do |p|
         unless p.intervention_id.nil?
            if Identifier.where({:identifiable_type => 'Project', :identifiable_id => p.id, :identifier => p.intervention_id, :assigner_org_id => ia_id }).empty?
                Identifier.create!({
                    :identifier => p.intervention_id,
                    :assigner_org_id => ia_id,
                    :identifiable_id => p.id,
                    :identifiable_type => 'Project'
                })
                puts "Added #{p.intervention_id} to Identifiers"
            end
         end
      end
      puts "Finished!"
  end

  def self.down
  end
end
