class AddLayerLongTitle < ActiveRecord::Migration
  def self.up
  	change_column :layers, :units, :string
  	add_column :layers, :long_title, :string
  end

  def self.down
  	change_column :layers, :units, :integer
  	remove_column :layers, :long_title, :string
  end
end
