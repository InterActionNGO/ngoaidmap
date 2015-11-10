# == Schema Information
#
# Table name: organizations
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  description                     :text
#  budget                          :float
#  website                         :string(255)
#  national_staff                  :integer
#  twitter                         :string(255)
#  facebook                        :string(255)
#  hq_address                      :string(255)
#  contact_email                   :string(255)
#  contact_phone_number            :string(255)
#  donation_address                :string(255)
#  zip_code                        :string(255)
#  city                            :string(255)
#  state                           :string(255)
#  donation_phone_number           :string(255)
#  donation_website                :string(255)
#  site_specific_information       :text
#  created_at                      :datetime
#  updated_at                      :datetime
#  logo_file_name                  :string(255)
#  logo_content_type               :string(255)
#  logo_file_size                  :integer
#  logo_updated_at                 :datetime
#  international_staff             :string(255)
#  contact_name                    :string(255)
#  contact_position                :string(255)
#  contact_zip                     :string(255)
#  contact_city                    :string(255)
#  contact_state                   :string(255)
#  contact_country                 :string(255)
#  donation_country                :string(255)
#  estimated_people_reached        :integer
#  private_funding                 :float
#  usg_funding                     :float
#  other_funding                   :float
#  private_funding_spent           :float
#  usg_funding_spent               :float
#  other_funding_spent             :float
#  spent_funding_on_relief         :float
#  spent_funding_on_reconstruction :float
#  percen_relief                   :integer
#  percen_reconstruction           :integer
#  media_contact_name              :string(255)
#  media_contact_position          :string(255)
#  media_contact_phone_number      :string(255)
#  media_contact_email             :string(255)
#  main_data_contact_name          :string(255)
#  main_data_contact_position      :string(255)
#  main_data_contact_phone_number  :string(255)
#  main_data_contact_email         :string(255)
#  main_data_contact_zip           :string(255)
#  main_data_contact_city          :string(255)
#  main_data_contact_state         :string(255)
#  main_data_contact_country       :string(255)
#  organization_id                 :string(255)
#  interaction_member              :boolean          default(FALSE)
#  organization_type               :string(255)
#  organization_type_code          :integer
#  iati_organizationid             :string(255)
#  publishing_to_iati              :boolean          default(FALSE)
#  membership_status               :string(255)      default("active")
#

class Organization < ActiveRecord::Base
  #has_many :resources, :conditions => 'resources.element_type = #{Iom::ActsAsResource::ORGANIZATION_TYPE}', :foreign_key => :element_id, :dependent => :destroy
  #has_many :media_resources, :conditions => 'media_resources.element_type = #{Iom::ActsAsResource::ORGANIZATION_TYPE}', :foreign_key => :element_id, :dependent => :destroy, :order => 'position ASC'
  has_many :projects, foreign_key: :primary_organization_id
  has_many :awarded_projects, foreign_key: :prime_awardee_id, class_name: 'Project'

  has_attached_file :logo, styles: {
                                      small: {
                                        geometry: "80x46>",
                                        format: 'jpg'
                                      },
                                      medium: {
                                        geometry: "200x150>",
                                        format: 'jpg'
                                      }
                                    },
                            url: "/system/:attachment/:id/:style.:extension"

  has_many :sites, foreign_key: :project_context_organization_id
  has_many :donations, through: :projects
  has_one :user
  scope :active, -> {joins(:projects).where("projects.end_date IS NULL OR (projects.end_date > ? AND projects.start_date <= ?)", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :organizations, -> (orgs){where(organizations: {id: orgs})}
  scope :site, -> (site){joins(projects: :sites).where(sites: {id: site})}
  scope :projects, -> (projects){joins(:projects).where(projects: {id: projects})}
  scope :sectors, -> (sectors){joins(:projects).joins('
    INNER JOIN projects_sectors ON (projects.id = projects_sectors.project_id)
    LEFT OUTER JOIN sectors ON (sectors.id = projects_sectors.sector_id)').where(sectors: {id: sectors})}
  scope :donors, -> (donors){joins(:projects).joins('
    LEFT OUTER JOIN donations ON (projects.id = donations.project_id)
    LEFT OUTER JOIN donors ON (donors.id = donations.donor_id)').where(donors: {id: donors})}
  scope :geolocation, -> (geolocation,level=0){joins(projects: :geolocations).where("g#{level}=?", geolocation).where('adm_level >= ?', level)}
  scope :countries, -> (countries){joins(projects: :geolocations).where(geolocations: {country_uid: countries})}
  def projects_count
    self.projects.active.size
  end
  def self.fetch_all(options={})
    level = Geolocation.find_by(uid: options[:geolocation]).adm_level if options[:geolocation]
    organizations = Organization.all
    organizations = organizations.site(options[:site])                                    if options[:site]
    organizations = organizations.active                                                  if options[:status] && options[:status] == 'active'
    organizations = organizations.geolocation(options[:geolocation], level)               if options[:geolocation]
    organizations = organizations.projects(options[:projects])                            if options[:projects]
    organizations = organizations.countries(options[:countries])                          if options[:countries]
    organizations = organizations.organizations(options[:organizations])                  if options[:organizations]
    organizations = organizations.sectors(options[:sectors])                              if options[:sectors]
    organizations = organizations.donors(options[:donors])                                if options[:donors]
    organizations
  end

  # IATI

  def iati_organization_id
    self.organization_id
  end
end
