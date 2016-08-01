class RemoveCartocssFromLayerStyle < ActiveRecord::Migration
  def self.up
  	remove_column :layer_styles, :cartocss
  end

  def self.down
  	addcolumn :layer_styles, :cartocss, :text
  end
end
