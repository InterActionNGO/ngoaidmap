class CreateSiteLayersJoinTable < ActiveRecord::Migration
  def self.up
  	create_table :site_layers, :id => false do |t|
  		t.integer	:site_id
  		t.integer	:layer_id
  		t.integer	:layer_style_id
  	end
  	add_index	:site_layers, :site_id
    add_index :site_layers, :layer_id
  	add_index	:site_layers, :layer_style_id
  end

  def self.down
  	drop_table	:site_layers
  end
end
