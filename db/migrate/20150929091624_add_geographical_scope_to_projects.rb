class AddGeographicalScopeToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :geographical_scope, :string, :default => 'regional'
  end

  def self.down
    remove_column :projects, :geographical_scope
  end
end
