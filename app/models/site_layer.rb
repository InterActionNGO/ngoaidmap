# == Schema Information
#
# Table name: site_layers
#
#  site_id           :integer     
#  layer_id       	 :integer   
#  color	       	 :string
#  division	      	 :integer   
#  description     	 :text
#

class SiteLayer < ActiveRecord::Base
  belongs_to :site
  belongs_to :layer
  belongs_to :layer_style
end