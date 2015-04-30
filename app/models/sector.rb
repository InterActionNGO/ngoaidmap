# == Schema Information
#
# Table name: sectors
#
#  id   :integer         not null, primary key
#  name :string(255)
#

class Sector < ActiveRecord::Base
  has_and_belongs_to_many :projects
  def donors
    Sector.joins(projects: :donors).select('donors.id', 'donors.name', 'COUNT(DISTINCT(projects.id)) as total_projects').where('sectors.id = ? and (projects.end_date is null OR projects.end_date > now()) and (projects.start_date < now())', self.id).group('donors.id', 'donors.name').order('total_projects DESC')
  end
end
