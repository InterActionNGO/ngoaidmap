class ChangeLayersMinMaxDataType < ActiveRecord::Migration
  def self.up
  	change_column :layers, :min, :float
  	change_column :layers, :max, :float
  end

  def self.down
  	change_column :layers, :min, :integer
  	change_column :layers, :max, :integer  	
  end
end
