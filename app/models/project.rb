# == Schema Information
#
# Table name: projects
#
#  id                                      :integer          not null, primary key
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
#  estimated_people_reached                :integer
#  contact_person                          :string(255)
#  contact_email                           :string(255)
#  contact_phone_number                    :string(255)
#  site_specific_information               :text
#  created_at                              :datetime
#  updated_at                              :datetime
#  the_geom                                :geometry
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
#  organization_id                         :string(255)
#  budget_currency                         :string(255)
#  budget_value_date                       :date
#  target_project_reach                    :integer
#  actual_project_reach                    :integer
#  project_reach_unit                      :string(255)
#  project_reach_actual_start_date         :date
#  project_reach_target_start_date         :date
#  project_reach_actual_end_date           :date
#  project_reach_target_end_date           :date
#  project_reach_type                      :string(255)      default("Output")
#  project_reach_type_code                 :integer          default(1)
#  project_reach_measure                   :string(255)      default("Unit")
#  project_reach_measure_code              :integer          default(1)
#  project_reach_description               :text
#

class Project < ActiveRecord::Base
  belongs_to :primary_organization, foreign_key: :primary_organization_id, class_name: 'Organization'
  has_and_belongs_to_many :clusters
  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :regions
  #has_and_belongs_to_many :countries
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :geolocations
  has_many :resources, -> {where(element_type: 0)}, :foreign_key => :element_id, :dependent => :destroy
  has_many :media_resources, -> {where(element_type: 0).order('position ASC')}, :foreign_key => :element_id, :dependent => :destroy
  has_many :donations, :dependent => :destroy
  has_many :donors, :through => :donations
  has_and_belongs_to_many :sites #, :class_name => 'Site', :finder_sql => 'select sites.* from sites, projects_sites where projects_sites.project_id = #{id} and projects_sites.site_id = sites.id'
  # has_and_belongs_to_many :countries,  -> {joins('
  #                                                   RIGHT OUTER JOIN geolocations AS geos
  #                                                   on geolocations_projects.geolocation_id = geos.id
  #                                                   RIGHT OUTER JOIN geolocations as g
  #                                                   ON g.g0 = geos.uid
  #                                                 ').where('g.adm_level=?', 0).uniq}, class_name: 'Geolocation'

  scope :active, -> {where("end_date > ? AND start_date < ?", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :inactive, -> {where("end_date < ? OR start_date > ?", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :closed, -> {where("end_date < ?", Date.today.to_s(:db))}
  scope :with_no_country, -> {select('projects.*').
                          joins(:regions).
                          includes(:countries).
                          where('countries_projects.project_id IS NULL AND regions.id IS NOT NULL')}
  scope :organizations, -> (orgs){where(organizations: {id: orgs})}
  scope :projects, -> (projects){where(projects: {id: projects})}
  scope :sectors, -> (sectors){where(sectors: {id: sectors})}
  scope :donors, -> (donors){where(donors: {id: donors})}
  scope :geolocation, -> (geolocation,level=0){where("g#{level}=?", geolocation).where('adm_level >= ?', level)}
  scope :countries, -> (countries){where(geolocations: {country_uid: countries})}
  scope :text_query, -> (q){where('projects.name ilike ? OR projects.description ilike ?', "%%#{q}%%", "%%#{q}%%")}
  scope :starting_after, -> (date){where "start_date > ?", date}
  scope :ending_before, -> (date){where "end_date < ?", date}

  def countries
    Geolocation.where(uid: self.geolocations.pluck(:country_uid)).uniq
  end

  def self.fetch_all(options = {}, from_api = true)
    projects = Project.includes([:primary_organization]).eager_load(:geolocations, :sectors, :donors).references(:organizations)
    projects = projects.geolocation(options[:geolocation], options[:level])     if options[:geolocation]
    projects = projects.projects(options[:projects])                            if options[:projects]
    projects = projects.countries(options[:countries])                          if options[:countries]
    projects = projects.organizations(options[:organizations])                  if options[:organizations]
    projects = projects.sectors(options[:sectors])                              if options[:sectors]
    projects = projects.donors(options[:donors])                                if options[:donors]
    projects = projects.text_query(options[:q])                                 if options[:q]
    projects = projects.starting_after(options[:starting_after])                if options[:starting_after]
    projects = projects.ending_before(options[:ending_before])                  if options[:ending_before]
    projects = projects.offset(options[:offset])                                if options[:offset]
    projects = projects.limit(options[:limit])                                  if options[:limit]
    projects = projects.active                                                  if options[:status] && options[:status] == 'active'
    projects = projects.inactive                                                if options[:status] && options[:status] == 'inactive'
    #projects = projects.group('projects.id', 'projects.name', 'geolocations.id', 'geolocations.country_uid', 'sectors.id', 'donors.id', 'organizations.id', 'geolocations.g0', 'geolocations.g1', 'geolocations.g2', 'geolocations.g3', 'geolocations.g4')
    projects = projects.uniq
    if from_api
      projects
    else
      project_gs = projects.pluck(:g0, :g1, :g2, :g3, :g4).flatten.uniq
      region_groups = {}
      region_groups['regions'] = Geolocation.where("uid IN (?)", project_gs)
      [projects, region_groups]
    end
  end


  def related(site, limit = 2)
    if result = Project.where.not(id: self.id).joins(:geolocations, :primary_organization, :sites).where(primary_organization_id: self.primary_organization_id).where(sites: {id: site.id}).active.uniq.limit(limit)
      result
    elsif result = Project.where.not(id: self.id).joins(:geolocations, :primary_organization, :sites).where(sites: {id: site.id}).active.uniq.limit(limit)
      result
    else
      result = Project.where.not(id: self.id).uniq.limit(limit)
    end
  end

  def self.export_headers(options = {})
    options = {show_private_fields: false}.merge(options || {})

    if options[:show_private_fields]
      %w(organization interaction_intervention_id org_intervention_id project_tags project_name project_description additional_information start_date end_date clusters sectors cross_cutting_issues budget_numeric international_partners local_partners prime_awardee estimated_people_reached target_groups location verbatim_location idprefugee_camp project_contact_person project_contact_position project_contact_email project_contact_phone_number project_website date_provided date_updated status donors)
    else
      %w(organization interaction_intervention_id org_intervention_id project_tags project_name project_description additional_information start_date end_date clusters sectors cross_cutting_issues budget_numeric international_partners local_partners prime_awardee estimated_people_reached target_groups location project_contact_person project_contact_position project_contact_email project_contact_phone_number project_website date_provided date_updated status donors)
    end
  end

  comma do
    primary_organization 'primary_organization' do |primary_organization| primary_organization.name end
    intervention_id 'interaction_intervention_id'
    organization_id 'org_intervention_id'
    tags 'project_tags' do |s| s.map{ |se| se.name }.join('|') end
    name 'project_name'
    description 'project_description'
    activities
    additional_information
    start_date
    end_date
    sectors 'sectors' do |s| s.map{ |se| se.name }.join('|') end
    cross_cutting_issues
    budget 'budget_numeric'
    partner_organizations 'international_partners'
    #local_partners
    awardee_type 'prime_awardee'
    estimated_people_reached
    target 'target_groups'
    verbatim_location 'location'
    contact_person 'project_contact_person'
    contact_position 'project_contact_position'
    contact_email 'project_contact_email'
    contact_phone_number 'project_contact_phone_number'
    website 'project_website'
    date_provided
    date_updated
    activity_status 'status'
    donors 'donors' do |s| s.map{ |se| se.name }.join('|') end
  end

  def self.to_csv(options = {})
    projects = self.fetch_all(options)
    csv_headers = self.export_headers(options[:headers_options])
    csv_data = CSV.generate(:col_sep => ',') do |csv|
      csv << csv_headers
      projects.each do |project|
        line = []
        csv_headers.each do |field_name|
          v = project[field_name]
          line << if v.nil?
            ""
          else
            if %W{ start_date end_date date_provided date_updated }.include?(field_name)
              if v =~ /^00(\d\d\-.+)/
                "20#{$1}"
              else
                v
              end
            else
              v.to_s.text2array.join(',')
            end
          end
        end
        csv << line
      end
    end
    csv_data
  end

  def self.to_excel(options = {})
    all.to_xls(headers: self.export_headers(options[:headers_options]))
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

  def activity_scope_code
    geos = self.geolocations
    if geos.present?
      if geos.length == 1
        activity_scope_code = case geos.first.adm_level
                                when 0
                                  4 # Not clear if covers whole country, blank
                                when 1
                                  6
                                when 2
                                  7
                                else
                                  0 # blank
                                end
      elsif geos.pluck(:country_code).uniq.length > 1
         activity_scope_code = 3
      else
        activity_scope_code = 5
      end
    else
      activity_scope_code = 5
    end
    activity_scope_code
  end

  def iati_countries
    self.geolocations.pluck(:country_code).uniq
  end

  def iati_locations
    self.geolocations.where('adm_level > 0')
  end

end
