class AddInteractionMemberToOrganizations < ActiveRecord::Migration
  def self.up
    add_column :organizations, :interaction_member, :boolean, :default => false
  end

  def self.down
    remove_column :organizations, :interaction_member
  end
end
