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
#  target_project_reach                    :float
#  actual_project_reach                    :float
#  project_reach_unit                      :string(255)
#  prime_awardee_id                        :integer
#  geographical_scope                      :string(255)      default("regional")
#

class Project < ActiveRecord::Base
  belongs_to :primary_organization, foreign_key: :primary_organization_id, class_name: 'Organization'
  belongs_to :prime_awardee, foreign_key: :prime_awardee_id, class_name: 'Organization'
  has_and_belongs_to_many :clusters
  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :geolocations
  has_many :resources, -> {where(element_type: 0)}, :foreign_key => :element_id, :dependent => :destroy
  has_many :media_resources, -> {where(element_type: 0).order('position ASC')}, :foreign_key => :element_id, :dependent => :destroy
  has_many :donations, :dependent => :destroy
  has_many :donors, :through => :donations
  has_and_belongs_to_many :sites
  scope :active, -> {where("end_date > ? AND start_date <= ?", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :inactive, -> {where("end_date < ? OR start_date > ?", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :closed, -> {where("end_date < ?", Date.today.to_s(:db))}
  scope :with_no_country, -> {select('projects.*').
                          joins(:regions).
                          includes(:countries).
                          where('countries_projects.project_id IS NULL AND regions.id IS NOT NULL')}
  scope :organizations, -> (orgs){where(organizations: {id: orgs})}
  scope :site, -> (site){joins(:sites).where(sites: {id: site})}
  scope :projects, -> (projects){where(projects: {id: projects})}
  scope :sectors, -> (sectors){where(sectors: {id: sectors})}
  scope :donors, -> (donors){where(donors: {id: donors})}
  scope :geolocation, -> (geolocation,level=0){where("g#{level}=?", geolocation).where('adm_level >= ?', level)}
  scope :countries, -> (countries){where(geolocations: {country_uid: countries})}
  scope :text_query, -> (q){where('projects.name ilike ? OR projects.description ilike ?', "%%#{q}%%", "%%#{q}%%")}
  scope :starting_after, -> (date){where "start_date > ?", date}
  scope :ending_before, -> (date){where "end_date < ?", date}

  def self.custom_fields
    (columns.map{ |c| c.name }).map{ |c| "#{self.table_name}.#{c}" }
  end

  def active?
    self.end_date > Date.today
  end

  def countries
    Geolocation.where(uid: self.geolocations.pluck(:country_uid)).uniq
  end

  def self.fetch_all(options = {}, from_api = true)
    level = Geolocation.find_by(uid: options[:geolocation]).try(:adm_level) || 0 if options[:geolocation]

    projects = Project.includes([:primary_organization]).eager_load(:geolocations, :sectors, :donors).references(:organizations)
    projects = projects.site(options[:site])                                    if options[:site] && options[:site].to_i != 12
    projects = projects.geolocation(options[:geolocation], level)               if options[:geolocation]
    projects = projects.projects(options[:projects])                            if options[:projects]
    projects = projects.countries(options[:countries])                          if options[:countries]
    projects = projects.organizations(options[:organizations])                  if options[:organizations]
    projects = projects.sectors(options[:sectors])                              if options[:sectors]
    projects = projects.donors(options[:donors])                                if options[:donors]
    projects = projects.text_query(options[:q])                                 if options[:q]
    projects = projects.starting_after(options[:starting_after])                if options[:starting_after]
    projects = projects.ending_before(options[:ending_before])                  if options[:ending_before]
    projects = projects.offset(options[:offset].to_i)                           if options[:offset]
    projects = projects.limit(options[:limit].to_i)                             if options[:limit]
    projects = projects.active                                                  if options[:status] && options[:status] == 'active'
    projects = projects.inactive                                                if options[:status] && options[:status] == 'inactive'
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

  def self.get_projects_on_map(options={})
    sql_options_struct = Struct.new(:level, :join_strings, :conditions, :geolocation, :g_level)
    sql_options = sql_options_struct.new
    if options[:geolocation]
      sql_options.g_level = Geolocation.find_by(uid: options[:geolocation]).adm_level
      sql_options.geolocation = options[:geolocation]
    end
    sql_options.level = options[:level].to_i || 0
    sql_options.join_strings = ''
    sql_options.join_strings += %Q( inner join projects_sites on projects_sites.project_id = projects.id)                           if options[:site] && options[:site].to_i != 12
    sql_options.join_strings += %Q( left outer join projects_sectors on projects_sectors.project_id = projects.id)                  if options[:sectors]
    sql_options.join_strings += %Q( left outer join donations on donations.project_id = projects.id)                                if options[:donors]
    sql_options.conditions = ''
    sql_options.conditions += %Q( and projects.end_date > now() AND projects.start_date <= now() )                                        unless options[:projects]
    sql_options.conditions += %Q( and projects.primary_organization_id in #{'(' + options[:organizations].join(',') + ')'} )        if options[:organizations]
    sql_options.conditions += %Q( and projects_sectors.sector_id in #{'(' + options[:sectors].join(',') + ')'} )                    if options[:sectors]
    sql_options.conditions += %Q( and donations.donor_id in #{'(' + options[:donors].join(',') + ')'} )                             if options[:donors]
    sql_options.conditions += %Q( and geolocations.g0 in #{"('" + options[:countries].join("', '") + "')"} )                        if options[:countries]
    sql_options.conditions += %Q( and projects.id in #{"('" + options[:projects].join("', '") + "')"} )                             if options[:projects]
    sql_options.conditions += %Q( and projects_sites.site_id=#{options[:site].to_i} )                                               if options[:site] && options[:site].to_i != 12
    sql_options.conditions += %Q( and projects.name ilike '%%#{options[:q]}%%' OR projects.description ilike '%%#{options[:q]}%%' ) if options[:q]
    sql = SqlQuery.new(:get_projects_on_map, options: sql_options).sql
    projects = Project.find_by_sql(sql)
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

  comma :brief do
    primary_organization 'organization' do |primary_organization| primary_organization.name end
    intervention_id 'interaction_intervention_id'
    organization_id 'org_intervention_id'
    tags 'project_tags' do |s| s.map{ |se| se.name }.join('|') end
    name 'project_name'
    description 'project_description'
    activities 'activities'
    additional_information 'additional_information'
    start_date 'start_date'
    end_date 'end_date'
    sectors_for_export 'sectors'
    cross_cutting_issues 'cross_cutting_issues'
    budget 'budget_numeric'
    budget_currency 'budget_currency'
    budget_value_date 'budget_value_date'
    implementing_organization 'international partners'
    partner_organizations 'local_partners'
    prime_awardee 'prime_awardee' do |prime_awardee| prime_awardee.try(:name) end
    target_project_reach 'target_project_reach'
    actual_project_reach 'actual_project_reach'
    project_reach_unit 'project_reach_unit'
    target 'target_groups'
    geographical_scope 'geographic_scope'
    geolocations_for_export 'location'
    contact_person 'project_contact_person'
    contact_position 'project_contact_position'
    contact_email 'project_contact_email'
    contact_phone_number 'project_contact_phone_number'
    website 'project_website'
    date_provided 'date_provided'
    date_updated 'date_updated'
    activity_status_for_export 'status'
    donors_for_export 'donors'
  end
  comma do
    primary_organization 'organization' do |primary_organization| primary_organization.name end
    intervention_id 'interaction_intervention_id'
    organization_id 'org_intervention_id'
    tags 'project_tags' do |s| s.map{ |se| se.name }.join('|') end
    name 'project_name'
    description 'project_description'
    activities 'activities'
    additional_information 'additional_information'
    start_date 'start_date'
    end_date 'end_date'
    sectors_for_export 'sectors'
    cross_cutting_issues 'cross_cutting_issues'
    budget 'budget_numeric'
    budget_currency 'budget_currency'
    budget_value_date 'budget_value_date'
    implementing_organization 'international partners'
    partner_organizations 'local_partners'
    prime_awardee 'prime_awardee' do |prime_awardee| prime_awardee.try(:name) end
    target_project_reach 'target_project_reach'
    actual_project_reach 'actual_project_reach'
    project_reach_unit 'project_reach_unit'
    target 'target_groups'
    geographical_scope 'geographic_scope'
    geolocations_for_export 'location'
    contact_person 'project_contact_person'
    contact_position 'project_contact_position'
    contact_email 'project_contact_email'
    contact_phone_number 'project_contact_phone_number'
    website 'project_website'
    date_provided 'date_provided'
    date_updated 'date_updated'
    activity_status_for_export 'status'
    donors_for_export 'donors'
    verbatim_location 'verbatim_location'
    idprefugee_camp 'idprefugee_camp'
  end

  def self.to_excel(options = {})
    all.to_xls(headers: self.export_headers(options[:headers_options]))
  end

  def activity_status_for_export
    if self.start_date > Time.now.in_time_zone || self.end_date < Time.now.in_time_zone
      'closed'
    else
      'active'
    end
  end

  def sectors_for_export
    if self.sectors
      Sector.joins(:projects).where(projects: {id: self.id}).map{ |se| se.name }.join('|')
    end
  end

  def donors_for_export
    if self.donors
      Donor.joins(:projects).where(projects: {id: self.id}).map{ |se| se.name }.join('|')
    end
  end

  def geolocations_for_export
    if self.geolocations
      geos = Geolocation.joins(:projects).where(projects: {id: self.id})
      geos = geos.map{ |g| g.try(:readable_path) }.join('|')
      geos
    end
  end

  ############################################## IATI ##############################################
  def funding_orgs
    if self.prime_awardee.present? && self.prime_awardee == self.primary_organization
      self.donors
    elsif self.prime_awardee.present?
      [self.prime_awardee]
    else
      self.donors
    end
  end

  def provider_org
    if self.funding_orgs.size == 1
      self.funding_orgs.first
    else
      OpenStruct.new(id: '', name: '')
    end
  end

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

  def iati_locations
    self.geolocations.where('adm_level > 0').uniq
  end

  ############################################## REPORTS ##############################################

 def self.get_list(params={})
    start_date = Date.parse(params[:start_date]['day']+"-"+params[:start_date]['month']+"-"+params[:start_date]['year']) if params[:start_date]
    end_date = Date.parse(params[:end_date]['day']+"-"+params[:end_date]['month']+"-"+params[:end_date]['year']) if params[:end_date]
    countries = params[:country] if params[:country]
    donors = params[:donor] if params[:donor]
    sectors = params[:sector] if params[:sector]
    organizations = params[:organization] if params[:organization]
    form_query = params[:q].downcase.strip if params[:q]
    active = params[:active_projects]
    if params[:model]
      the_model = params[:model]
    else
      the_model='p'
    end
    if params[:limit]
      the_limit = params[:limit]
    else
      the_limit='NULL'
    end

    if start_date && end_date && !active
      date_filter = "AND p.start_date <= '#{end_date}'::date AND p.end_date >= '#{start_date}'::date"
    elsif active == 'yes'
      date_filter = "AND p.start_date <= '#{Time.now.to_date}'::date AND p.end_date > '#{Time.now.to_date}'::date"
    end

    form_query_filter = "AND lower(p.name) LIKE '%" + form_query + "%'" if params[:q]

    if donors && !donors.include?('All')
      donors_filter = "AND d.name IN (" + donors.map {|str| "'#{str}'"}.join(',') + ")"
    end

    if sectors && !sectors.include?('All')
      sectors_filter = "AND s.name IN (" + sectors.map {|str| "'#{str}'"}.join(',') + ")"
    end

    if countries && !countries.include?('All')
      countries_filter = "AND g.country_name IN (" + countries.map {|str| "#{ActiveRecord::Base.connection.quote(str)}"}.join(',') + ")"
    end

    if organizations && !organizations.include?('All')
      organizations_filter = "AND o.name IN (" + organizations.map {|str| "#{ActiveRecord::Base.connection.quote(str)}"}.join(',') + ")"
      organizations_filter = organizations_filter.gsub(/&amp;/, '&')
    end

    if the_model == 'o'
      budget_line = ", SUM(p.budget) AS budget"
    end
    if the_model == 'p'
      sql = <<-SQL
        SELECT p.id, p.name, p.budget, p.start_date, p.end_date, o.id AS primary_organization, o.name AS organization_name,
        COUNT(DISTINCT d.id) AS donors_count,
        COUNT(DISTINCT c.id) AS countries_count,
        COUNT(DISTINCT s.id) AS sectors_count
          FROM projects p
                 INNER JOIN projects_sectors ps ON (p.id = ps.project_id)
                 LEFT OUTER JOIN sectors s ON (s.id = ps.sector_id)
                 LEFT OUTER JOIN donations dt ON (p.id = dt.project_id)
                 LEFT OUTER JOIN donors d ON (d.id = dt.donor_id)
                 INNER JOIN organizations o ON (p.primary_organization_id = o.id)
                 INNER JOIN geolocations_projects gp ON (p.id = gp.project_id)
                 INNER JOIN geolocations g ON (g.id = gp.geolocation_id)
                 INNER JOIN geolocations c ON (g.country_uid = c.uid)
          WHERE true
         #{date_filter} #{form_query_filter} #{donors_filter} #{sectors_filter} #{countries_filter} #{organizations_filter}
          AND c.adm_level = 0
          GROUP BY p.id, p.name, o.id, o.name, p.budget, p.start_date, p.end_date
          ORDER BY p.name
          LIMIT #{the_limit}
      SQL
    else
      sql = <<-SQL
        SELECT #{the_model}.name, #{the_model}.id,
        COUNT(DISTINCT p.id) AS projects_count,
        COUNT(DISTINCT d.id) AS donors_count,
        COUNT(DISTINCT c.id) AS countries_count,
        COUNT(DISTINCT s.id) AS sectors_count,
        COUNT(DISTINCT o.id) AS organizations_count
        #{budget_line}
          FROM projects p
                 INNER JOIN projects_sectors ps ON (p.id = ps.project_id)
                 LEFT OUTER JOIN sectors s ON (s.id = ps.sector_id)
                 LEFT OUTER JOIN donations dt ON (p.id = dt.project_id)
                 LEFT OUTER JOIN donors d ON (d.id = dt.donor_id)
                 INNER JOIN organizations o ON (p.primary_organization_id = o.id)
                 INNER JOIN geolocations_projects gp ON (p.id = gp.project_id)
                 INNER JOIN geolocations g ON (g.id = gp.geolocation_id)
                 INNER JOIN geolocations c ON (g.country_uid = c.uid)
          WHERE true
         #{date_filter} #{form_query_filter} #{donors_filter} #{sectors_filter} #{countries_filter} #{organizations_filter}
          AND c.adm_level = 0
          GROUP BY #{the_model}.name, #{the_model}.id
          ORDER BY projects_count DESC
          LIMIT #{the_limit}
      SQL
    end
    list = ActiveRecord::Base.connection.execute(sql)
  end

  ############################################## REPORTS ##############################################


end
