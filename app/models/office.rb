# == Schema Information
#
# Table name: offices
#
#  id         :integer          not null, primary key
#  organization_id   :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Office < ActiveRecord::Base
  belongs_to :organization
  has_many :donations
  has_many :projects, through: :donations
end
