# == Schema Information
#
# Table name: sectors
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  iati_name         :string(255)
#  sector_vocab_code :string(255)
#  iati_code         :string(255)
#

class Sector < ActiveRecord::Base
  has_and_belongs_to_many :projects
  scope :active, -> {joins(:projects).where("projects.end_date > ? AND projects.start_date < ?", Date.today.to_s(:db), Date.today.to_s(:db)).uniq}
  def donors
    Project.active.joins([:sectors, :donors]).where(sectors: {id: self.id}).pluck('donors.id', 'donors.name').uniq
  end
  def self.counting_projects(options={})
    if options && options[:status] == 'active'
      Sector.joins(:projects).select('sectors.id', 'sectors.name').group('sectors.id', 'sectors.name').order('sectors.name').where('(projects.end_date is null OR projects.end_date > now()) and (projects.start_date < now())').distinct.count('distinct(projects.id)')
    else
      Sector.joins(:projects).select('sectors.id', 'sectors.name').group('sectors.id', 'sectors.name').order('sectors.name').distinct.count('distinct(projects.id)')
    end
  end
  def self.fetch_all(options={})
    sectors = Sector.all
    sectors = sectors.active if options && options[:status] && options[:status] == 'active'
    sectors
  end
end
