# == Schema Information
#
# Table name: layer_styles
#
#  id    :integer          not null, primary key
#  title :string(255)
#  name  :string(255)
#

class LayerStyle < ActiveRecord::Base
  has_many :site_layers
  has_many  :site, through: :site_layers
end
