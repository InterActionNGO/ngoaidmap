# == Schema Information
#
# Table name: layers
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  credits       :text
#  date          :datetime
#  min           :float
#  max           :float
#  units         :string(255)
#  status        :boolean
#  cartodb_table :string(255)
#  sql           :text
#  long_title    :string(255)
#

class Layer < ActiveRecord::Base
  has_many  :site_layers
  has_many  :sites, through: :site_layers

end
