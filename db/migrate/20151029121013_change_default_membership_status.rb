class ChangeDefaultMembershipStatus < ActiveRecord::Migration
  def self.up
    change_column :organizations, :membership_status, :string, :default => 'Non Member'
  end
end
