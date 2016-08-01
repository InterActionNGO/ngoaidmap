class AddSqlToLayers < ActiveRecord::Migration
  def self.up
    add_column :layers, :sql, :text
  end

  def self.down
    remove_column :layers, :sql
  end
end
