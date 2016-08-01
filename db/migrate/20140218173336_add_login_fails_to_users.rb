class AddLoginFailsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :login_fails, :integer, :default => 0
  end

  def self.down
    remove_column :users, :login_fails
  end
end
