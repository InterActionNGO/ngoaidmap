# == Schema Information
#
# Table name: resources
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  url                       :string(255)
#  element_id                :integer
#  element_type              :integer
#  created_at                :datetime
#  updated_at                :datetime
#  site_specific_information :text
#

class Resource < ActiveRecord::Base

  #acts_as_resource

  serialize :site_specific_information

  def sites_ids=(value)
    update_attribute(:site_specific_information, value)
  end

  def sites_ids
    site_specific_information || []
  end

end
