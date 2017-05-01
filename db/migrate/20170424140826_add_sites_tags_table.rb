class AddSitesTagsTable < ActiveRecord::Migration
  def self.up
    create_table :sites_tags, :id => false do |t|
      t.integer :site_id
      t.integer :tag_id
    end
    add_index :sites_tags, :site_id
    add_index :sites_tags, :tag_id
  end

  def self.down
    drop_table :sites_tags
  end
end
