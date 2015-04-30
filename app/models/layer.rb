# == Schema Information
#
# Table name: layers
#
#  id             :integer         not null, primary key
#  title          :string(255)
#  description 	  :text
#  credits     	  :text
#  date	       	  :date
#  min       	  :integer
#  max       	  :integer
#  units       	  :integer
#  status      	  :boolean
#  cartodb_table  :string
#  sql			  :text
#

class Layer < ActiveRecord::Base
  has_many  :site_layers
  has_many  :site, through: :site_layers
end