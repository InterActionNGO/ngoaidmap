# == Schema Information
#
# Table name: stats
#
#  id      :integer          not null, primary key
#  site_id :integer
#  visits  :integer
#  date    :date
#

class Stat < ActiveRecord::Base
  belongs_to :site
end
