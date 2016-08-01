class CreateLayerStylesTable < ActiveRecord::Migration
  def self.up
  	create_table :layer_styles do |t|
  		t.string	:cartocss
  		t.string	:name
  		t.string	:thumbnail
  	end
  end

  def self.down
  	drop_table	:layer_styles
  end
end
