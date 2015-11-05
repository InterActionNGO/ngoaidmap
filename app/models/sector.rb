# == Schema Information
#
# Table name: sectors
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  oecd_dac_name         :string(255)
#  sector_vocab_code     :string(255)
#  oecd_dac_purpose_code :string(255)
#

class Sector < ActiveRecord::Base
  has_and_belongs_to_many :projects
  scope :active, -> {joins(:projects).where("projects.end_date > ? AND projects.start_date < ?", Date.today.to_s(:db), Date.today.to_s(:db)).uniq}
  def donors
    Project.active.joins([:sectors, :donors]).where(sectors: {id: self.id}).pluck('donors.id', 'donors.name').uniq
  end
  def self.counting_projects(options={})
    active = true if options && options[:status] == 'active'
    sql = SqlQuery.new(:sectors_count, active: active).sql
    Sector.find_by_sql(sql)
  end
  def self.fetch_all(options={})
    sectors = Sector.all
    sectors = sectors.active if options && options[:status] && options[:status] == 'active'
    sectors
  end
end
