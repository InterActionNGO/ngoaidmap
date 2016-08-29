# == Schema Information
#
# Table name: sectors
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  oecd_dac_name         :string(255)
#  sector_vocab_code     :string(255)
#  oecd_dac_purpose_code :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#

class Sector < ActiveRecord::Base
  has_and_belongs_to_many :projects

  scope :active, -> {joins(:projects).where("projects.end_date > ? AND projects.start_date < ?", Date.today.to_s(:db), Date.today.to_s(:db)).uniq}
  scope :organizations, -> (orgs){joins(:projects).joins('join organizations on projects.primary_organization_id = organizations.id').where(organizations: {id: orgs})}
  scope :projects, -> (projects){joins(:projects).where(projects: {id: projects})}
  scope :sectors, -> (sectors){where(sectors: {id: sectors})}
  scope :donors, -> (donors){joins(projects: :donations).where(donations: {donor_id: donors})}
  scope :site, -> (site){joins(projects: :sites).where(sites: {id: site})}
  scope :geolocation, -> (geolocation,level=0){joins(projects: :geolocations).where("g#{level}=?", geolocation).where('adm_level >= ?', level)}
  scope :countries, -> (countries){joins(projects: :geolocations).where(geolocations: {country_uid: countries})}

  def self.counting_projects(options={})
    active = true if options && options[:status] == 'active'
    sql = SqlQuery.new(:sectors_count, active: active).sql
    Sector.find_by_sql(sql)
  end

  def self.fetch_all(options={})
    level = Geolocation.find_by(uid: options[:geolocation]).adm_level if options[:geolocation]
    sectors = Sector.all
    sectors = sectors.site(options[:site])                                    if options[:site]
    sectors = sectors.active                                                  if options[:status] && options[:status] == 'active'
    sectors = sectors.geolocation(options[:geolocation], level)               if options[:geolocation]
    sectors = sectors.projects(options[:projects])                            if options[:projects]
    sectors = sectors.countries(options[:countries])                          if options[:countries]
    sectors = sectors.organizations(options[:organizations])                  if options[:organizations]
    sectors = sectors.donors(options[:donors])                                if options[:donors]
    sectors.uniq
  end

  def donors
    Project.active.joins([:sectors, :donors]).where(sectors: {id: self.id}).pluck('organizations.id', 'organizations.name').uniq
  end

end
