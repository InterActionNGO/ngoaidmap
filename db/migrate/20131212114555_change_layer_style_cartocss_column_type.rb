class ChangeLayerStyleCartocssColumnType < ActiveRecord::Migration
  def self.up
  	remove_column :layer_styles, :cartocss
  	add_column :layer_styles, :cartocss, :text
  end

  def self.down
  	remove_column :layer_styles, :cartocss
  	add_column :layer_styles, :cartocss, :string
  end
end
