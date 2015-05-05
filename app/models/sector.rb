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
    Sector.joins(projects: :donors).select('donors.id', 'donors.name').where('sectors.id = ? and (projects.end_date is null OR projects.end_date > now()) and (projects.start_date < now())', self.id).group('donors.id', 'donors.name').order('total_projects DESC')
  end
  def self.counting_projects
    Sector.joins(:projects).select('sectors.id', 'sectors.name').group('sectors.id', 'sectors.name').order('sectors.name').where('(projects.end_date is null OR projects.end_date > now()) and (projects.start_date < now())').distinct.count('projects.id')
  end
end