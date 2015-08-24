# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  donor_id   :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Office < ActiveRecord::Base
  belongs_to :donor
  has_many :donations
  has_many :projects, through: :donations
  has_many :all_donated_projects, through: :donations, source: :project
end
