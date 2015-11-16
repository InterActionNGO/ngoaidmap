# == Schema Information
#
# Table name: donors
#
#  id                        :integer          not null, primary key
#  name                      :string(2000)
#  description               :text
#  website                   :string(255)
#  twitter                   :string(255)
#  facebook                  :string(255)
#  contact_person_name       :string(255)
#  contact_company           :string(255)
#  contact_person_position   :string(255)
#  contact_email             :string(255)
#  contact_phone_number      :string(255)
#  logo_file_name            :string(255)
#  logo_content_type         :string(255)
#  logo_file_size            :integer
#  logo_updated_at           :datetime
#  site_specific_information :text
#  created_at                :datetime
#  updated_at                :datetime
#  iati_organizationid       :string(255)
#  organization_type         :string(255)
#  organization_type_code    :integer
#

class Donor < ActiveRecord::Base

  #has_many :resources, :conditions => 'resources.element_type = #{Iom::ActsAsResource::DONOR_TYPE}', :foreign_key => :element_id, :dependent => :destroy
  #has_many :media_resources, :conditions => 'media_resources.element_type = #{Iom::ActsAsResource::DONOR_TYPE}', :foreign_key => :element_id, :dependent => :destroy, :order => 'position ASC'
  has_many :donations, dependent: :destroy
  has_many :donated_projects, -> {where("(projects.end_date is null or projects.end_date > now())")}, through: :donations, source: :project
  #has_many :all_donated_projects, through: :donations, source: :project
  has_many :projects, through: :donations, source: :project
  has_many :offices, dependent: :destroy

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
  scope :active, -> {joins([donations: :project]).where("projects.end_date is null or (projects.end_date > ? AND projects.start_date < ?)", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :sectors, -> (sectors) {joins([donations: [project: :sectors]]).where(sectors: {id: sectors})}
  scope :site, -> (site) {joins([donations: [project: :sites]]).where(sites: {id: site})}
  scope :geolocation, -> (geolocation,level=0){joins(donations: [project: :geolocations]).where("g#{level}=?", geolocation).where('adm_level >= ?', level)}
  scope :projects, -> (projects){joins(donations: :project).where(projects: {id: projects})}
  scope :countries, -> (countries){joins(donations: [project: :geolocations]).where(geolocations: {country_uid: countries})}
  scope :organizations, -> (orgs){joins(donations: :project).joins('join organizations on projects.primary_organization_id = organizations.id').where(organizations: {id: orgs})}
  def self.fetch_all(options={})
    level = Geolocation.find_by(uid: options[:geolocation]).adm_level if options[:geolocation]
    donors = Donor.all
    donors = donors.active                                                    if options[:status] && options[:status] == 'active'
    donors = donors.site(options[:site])                                      if options[:site]
    donors = donors.sectors(options[:sectors])                                if options[:sectors]
    donors = donors.geolocation(options[:geolocation], level)                 if options[:geolocation]
    donors = donors.countries(options[:countries])                            if options[:countries]
    donors = donors.organizations(options[:organizations])                    if options[:organizations]
    donors = donors.projects(options[:projects])                              if options[:projects]
    donors = donors.uniq
    donors = donors.order(:name)
    donors
  end
end
