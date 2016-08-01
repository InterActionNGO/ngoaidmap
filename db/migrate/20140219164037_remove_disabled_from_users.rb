class RemoveDisabledFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :disabled
  end
  def self.down
    add_column :users, :disabled, :boolean, :default => false
  end
end
