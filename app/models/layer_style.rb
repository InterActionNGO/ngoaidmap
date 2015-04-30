# == Schema Information
#
# Table name: layer_style
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  style       	  :text
#

class LayerStyle < ActiveRecord::Base
  has_many :site_layers
  has_many  :site, through: :site_layers
end