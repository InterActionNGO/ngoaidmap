class ChangesOrganizationAttributes < ActiveRecord::Migration
  def self.up
    add_column :organizations, :organization_type, :string
    add_column :organizations, :organization_type_code, :integer
    add_column :organizations, :iati_organizationid, :string
    add_column :organizations, :publishing_to_iati, :boolean, :default => :false
    add_column :organizations, :membership_status, :string, :default => 'active'
  end

  def self.down
    remove_column :organizations, :organization_type
    remove_column :organizations, :organization_type_code
    remove_column :organizations, :iati_organizationid
    remove_column :organizations, :publishing_to_iati
    remove_column :organizations, :membership_status
  end
end
