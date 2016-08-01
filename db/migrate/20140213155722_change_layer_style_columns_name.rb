class ChangeLayerStyleColumnsName < ActiveRecord::Migration
  def self.up
  	rename_column :layer_styles, :name, :title
  	rename_column :layer_styles, :thumbnail, :name
  end

  def self.down
  	rename_column :layer_styles, :title, :name
  	rename_column :layer_styles, :name, :thumbnail  	
  end
end
