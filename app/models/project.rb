# == Schema Information
#
# Table name: projects
#
#  id                                      :integer         not null, primary key
#  name                                    :string(2000)
#  description                             :text
#  primary_organization_id                 :integer
#  implementing_organization               :text
#  partner_organizations                   :text
#  cross_cutting_issues                    :text
#  start_date                              :date
#  end_date                                :date
#  budget                                  :float
#  target                                  :text
#  estimated_people_reached                :integer(8)
#  contact_person                          :string(255)
#  contact_email                           :string(255)
#  contact_phone_number                    :string(255)
#  site_specific_information               :text
#  created_at                              :datetime
#  updated_at                              :datetime
#  the_geom                                :string
#  activities                              :text
#  intervention_id                         :string(255)
#  additional_information                  :text
#  awardee_type                            :string(255)
#  date_provided                           :date
#  date_updated                            :date
#  contact_position                        :string(255)
#  website                                 :string(255)
#  verbatim_location                       :text
#  calculation_of_number_of_people_reached :text
#  project_needs                           :text
#  idprefugee_camp                         :text
#

class Project < ActiveRecord::Base
  belongs_to :primary_organization, foreign_key: :primary_organization_id, class_name: 'Organization'
  has_and_belongs_to_many :clusters
  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :geolocations
  #has_many :resources, :conditions => proc {"resources.element_type = #{Iom::ActsAsResource::PROJECT_TYPE}"}, :foreign_key => :element_id, :dependent => :destroy
  #has_many :media_resources, :conditions => proc {"media_resources.element_type = #{Iom::ActsAsResource::PROJECT_TYPE}"}, :foreign_key => :element_id, :dependent => :destroy, :order => 'position ASC'
  has_many :donations, :dependent => :destroy
  has_many :donors, :through => :donations
  has_many :cached_sites, :class_name => 'Site'#, :finder_sql => 'select sites.* from sites, projects_sites where projects_sites.project_id = #{id} and projects_sites.site_id = sites.id'

  scope :active, -> {where("end_date > ?", Date.today.to_s(:db))}
  scope :closed, -> {where("end_date < ?", Date.today.to_s(:db))}
  scope :with_no_country, -> {select('projects.*').
                          joins(:regions).
                          includes(:countries).
                          where('countries_projects.project_id IS NULL AND regions.id IS NOT NULL')}
  scope :organizations, -> (orgs){where(organizations: {id: orgs})}
  scope :sectors, -> (sectors){where(sectors: {id: sectors})}
  scope :donors, -> (donors){where(donors: {id: donors})}
  scope :countries, -> (countries){where(countries: {id: countries})}
  scope :regions, -> (regions){where(regions: {id: regions})}

  def self.fetch_all(options = {})
    projects = Project.includes([:primary_organization]).eager_load(:countries, :regions, :sectors, :donors)
    projects = projects.organizations(options[:organizations]) if options[:organizations]
    projects = projects.countries(options[:countries])         if options[:countries]
    projects = projects.regions(options[:regions])             if options[:regions]
    projects = projects.sectors(options[:sectors])             if options[:sectors]
    projects = projects.donors(options[:donors])               if options[:donors]
    projects = projects.active
    projects = projects.group('projects.id', 'countries.id', 'regions.id', 'sectors.id', 'donors.id', 'organizations.id')
    projects.uniq
  end
  ############################################## IATI ##############################################
  def activity_status
    if self.start_date > Time.now.in_time_zone
      1
    elsif self.end_date > Time.now.in_time_zone
      2
    else
      3
    end
  end
end
