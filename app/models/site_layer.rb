# == Schema Information
#
# Table name: site_layers
#
#  site_id        :integer
#  layer_id       :integer
#  layer_style_id :integer
#

class SiteLayer < ActiveRecord::Base
  belongs_to :site
  belongs_to :layer
  belongs_to :layer_style
end
