class AddDescriptionToTags < ActiveRecord::Migration
  def self.up
      add_column :tags, :description, :text
      add_column :tags, :created_at, :timestamp
      add_column :tags, :updated_at, :timestamp
      add_index :tags, :name
  end

  def self.down
      remove_index :tags, :name
      remove_column :tags, :description
      remove_column :tags, :created_at
      remove_column :tags, :updated_at
  end
end
