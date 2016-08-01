class AddIatiFieldsToDonors < ActiveRecord::Migration
  def self.up
    add_column :donors, :iati_organizationid, :string
    add_column :donors, :organization_type, :string
    add_column :donors, :organization_type_code, :integer
  end

  def self.down
    remove_column :donors, :iati_organizationid
    remove_column :donors, :organization_type, :string
    remove_column :donors, :organization_type_code, :integer
  end
end
