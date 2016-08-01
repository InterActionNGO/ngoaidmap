class AddFeaturedFlagToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :featured, :boolean, :default => false
  end

  def self.down
    remove_column :sites, :featured
  end
end
