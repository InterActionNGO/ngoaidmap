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
#  prime_awardee_id                        :integer
#  geographical_scope                      :string(255)      default("regional")
#

class Project < ActiveRecord::Base
  belongs_to :primary_organization, foreign_key: :primary_organization_id, class_name: 'Organization'
  belongs_to :prime_awardee, foreign_key: :prime_awardee_id, class_name: 'Organization'
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

  def active?
    self.end_date > Date.today
  end

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
    projects = projects.offset(options[:offset].to_i)                           if options[:offset]
    projects = projects.limit(options[:limit].to_i)                             if options[:limit]
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
    primary_organization 'organization' do |primary_organization| primary_organization.name end
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
    budget_currency
    budget_value_date
    implementing_organization 'international partners'
    partner_organizations 'local_partners'
    prime_awardee 'prime_awardee' do |prime_awardee| prime_awardee.try(:name) end
    target_project_reach
    actual_project_reach
    project_reach_unit
    target 'target_groups'
    geolocations 'location' do |g| readable_region_paths(g) end
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

  def readable_region_paths(r=nil)
    geolocations = r || self.geolocations
    geolocations = geolocations.map{ |g| g.name }.join('|')
    geolocations
  end

  def self.to_excel(options = {})
    all.to_xls(headers: self.export_headers(options[:headers_options]))
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

  # def self.report(params = {})
  #   # FORM Params
  #   start_date = Date.parse(params[:start_date]['day']+"-"+params[:start_date]['month']+"-"+params[:start_date]['year'])
  #   end_date = Date.parse(params[:end_date]['day']+"-"+params[:end_date]['month']+"-"+params[:end_date]['year'])
  #   countries = params[:country] if params[:country]
  #   donors = params[:donor] if params[:donor]
  #   sectors = params[:sector] if params[:sector]
  #   organizations = params[:organization] if params[:organization]
  #   form_query = "%" + params[:q].downcase.strip + "%" if params[:q]

  #   projects_select = <<-SQL
  #     SELECT  id, name, budget, start_date, end_date, primary_organization_id, end_date >= now() as active
  #     FROM projects
  #     WHERE ( (start_date <= '#{start_date}' AND end_date >='#{start_date}') OR (start_date>='#{start_date}' AND end_date <='#{end_date}') OR (start_date<='#{end_date}' AND end_date>='#{end_date}') )
  #       AND lower(trim(name)) like '%#{form_query}%'
  #      GROUP BY id
  #      ORDER BY name ASC
  #   SQL

  #   @projects = Project.where("start_date <= ?", end_date).where("end_date >= ?",start_date).where("lower(trim(projects.name)) like ?", form_query)

  #   # COUNTRIES (if not All of them selected)
  #   if ( params[:country] && !params[:country].include?('All') )
  #     if params[:country_include] === "include"
  #       @projects = @projects.where(geolocations: {country_name: countries}).uniq
  #     else
  #       @projects = @projects.where.not(geolocations: {country_name: countries}).uniq
  #     end
  #   end

  #   # ORGANIZATIONS (if not All of them selected)
  #   if ( params[:organization] && !params[:organization].include?('All') )
  #     if params[:organization_include] === "include"
  #       @projects = @projects.joins(:primary_organization).where(organizations: {name: organizations})
  #     else
  #       @projects = @projects.joins(:primary_organization).where.not(organizations: {name: organizations})
  #     end
  #   end

  #   # DONORS (if not All of them selected)
  #   if ( params[:donor] && !params[:donor].include?('All') )
  #     if params[:donor_include] === "include"
  #       @projects = @projects.donors_name_in(donors)
  #     else
  #       @projects = @projects.donors_name_not_in(donors)
  #     end
  #   end

  #   #SECTORS (if not All of them selected)
  #   if ( params[:sector] && !params[:sector].include?('All') )
  #     if params[:sector_include] === "include"
  #       @projects = @projects.sectors_name_in(sectors)
  #     else
  #       @projects = @projects.sectors_name_not_in(sectors)
  #     end
  #   end

  #   @projects = @projects.select(["projects.id","projects.name","projects.budget","projects.primary_organization_id", "projects.start_date","projects.end_date","(end_date >= current_date) as active"])

  #   @data ||= {}
  #   @totals ||= {}
  #   projects_ids = [0]

  #   # Projects IDs for IN clausules
  #   projects_str = @projects.map { |elem| elem.id }.join(',') || ""
  #   @data[:donors] =  projects_str.blank? ? {} : Project.report_donors(projects_str)
  #   @data[:organizations] = projects_str.blank? ? {} : Project.report_organizations(projects_str)
  #   @data[:countries] = projects_str.blank? ? {} : Project.report_countries(projects_str)
  #   @data[:sectors] = projects_str.blank? ? {}  : Project.report_sectors(projects_str)
  #   @data[:projects] = @projects
  #   @data
  # end

  # def self.report_donors(projects)
  #   donors = {}
  #   sql = <<-SQL
  #     SELECT d.name donorName, SUM(dn.amount) as sum, pr.estimated_people_reached as people
  #     FROM donors as d JOIN donations as dn ON dn.donor_id = d.id
  #     JOIN projects as pr ON dn.project_id = pr.id
  #     WHERE pr.id IN (#{projects})
  #     GROUP BY d.name, pr.estimated_people_reached, dn.amount
  #     ORDER BY dn.amount DESC
  #     SQL
  #   result = ActiveRecord::Base.connection.execute(sql)
  #   result.each do |r|
  #     if(donors.key?(r['donorname']))
  #       donors[r['donorname']][:budget] += r[:sum].to_i
  #     else
  #       donors[r['donorname']] = {:budget => r['sum'].to_i, :people => r['people'].to_i, :name => r['donorname']}
  #     end
  #   end
  #   donors.values.sort_by { |v| v[:budget]}.reverse
  # end

  # def self.report_organizations(projects)
  #   organizations = {}
  #   sql = <<-SQL
  #         SELECT o.name as orgName, SUM(p.budget) as sum
  #         FROM organizations as o JOIN projects AS p ON p.primary_organization_id = o.id
  #         JOIN donations as dn ON dn.project_id = p.id
  #         WHERE p.id IN (#{projects})
  #         GROUP BY o.name, dn.amount
  #         ORDER BY dn.amount DESC
  #   SQL
  #   result = ActiveRecord::Base.connection.execute(sql)
  #   result.each do |r|
  #     if(organizations.key?(r['orgname']))
  #       organizations[r['orgname']][:budget] += r[:sum].to_i
  #     else
  #       organizations[r['orgname']] = {:budget => r['sum'].to_i, :people => r['people'].to_i, :name => r['orgname']}
  #     end
  #   end
  #   organizations.values.sort_by { |v| v[:budget]}.reverse
  # end

  # def self.report_countries(projects)
  #   countries = {}
  #   sql = <<-SQL
  #     SELECT c.name, projects.budget as sum
  #     FROM geolocations
  #       JOIN geolocations_projects ON geolocations.id = geolocations_projects.geolocation_id
  #       JOIN projects ON geolocations_projects.project_id = projects.id
  #       JOIN donations ON projects.id = donations.project_id
  #       JOIN geolocations c ON c.uid = geolocations.country_uid
  #     WHERE projects.id IN (#{projects})
  #     GROUP BY c.name, projects.budget
  #     ORDER BY SUM DESC
  #   SQL
  #   result = ActiveRecord::Base.connection.execute(sql)
  #   result.each do |r|
  #     if(countries.key?(r['name']))
  #       countries[r['name']][:budget] += r['sum'].to_i
  #       countries[r['name']][:people] += r['people'].to_i
  #     else
  #       countries[r['name']] = {:name => r['name'], :people => r['people'].to_i, :budget => r['sum'].to_i}
  #     end
  #   end
  #   countries.values.sort_by { |v| v[:budget]}.reverse
  # end

  # def self.report_sectors(projects)
  #   sectors = {}
  #   sql = <<-SQL
  #     SELECT distinct(sectors.name), sectors.id as id, SUM(dn.amount) as sum FROM sectors
  #     LEFT JOIN projects_sectors ON sectors.id = projects_sectors.sector_id
  #       JOIN projects ON projects.id = projects_sectors.project_id
  #       JOIN donations as dn ON dn.project_id = projects.id
  #     WHERE projects.id IN (#{projects})
  #     GROUP BY sectors.name, sectors.id
  #     ORDER BY sum DESC
  #   SQL
  #   result = ActiveRecord::Base.connection.execute(sql)
  #   result.each do |r|
  #     if(sectors.key?(r['id'].to_i))
  #       sectors[r['id'].to_i][:budget] += r['sum'].to_i
  #     else
  #       sectors[r['id'].to_i] = {:name => r['name'], :people => r['people'].to_i, :budget => r['sum'].to_i}
  #     end
  #   end
  #   sectors.values.sort_by { |v| v[:budget]}.reverse
  # end

  ################################################
  ## REPORTING
  ################################################
  ##
  ##  Bar charting for DONORS, SECTORS, ORGANIZATIONS & COUNTRIES
  ##
  ## - A global select with global relations is performed first. It will be called the "base_select"
  ## - Over the "base_select" 3 sub-selects will be performed per entity (3 for donors, 3 for sectors, 3 for orgs and 3 for countries)
  ## - Grouped results by entity are then added to a dictionary, to be served as a json by the controler+view
  ##
  ################################################

  # def self.bar_chart_report(params = {})

  #   ###########################
  #   ## FILTERING >>
  #   ###########################

  #   start_date = Date.parse(params[:start_date]['day']+"-"+params[:start_date]['month']+"-"+params[:start_date]['year'])
  #   end_date = Date.parse(params[:end_date]['day']+"-"+params[:end_date]['month']+"-"+params[:end_date]['year'])
  #   countries = params[:country] if params[:country]
  #   donors = params[:donor] if params[:donor]
  #   sectors = params[:sector] if params[:sector]
  #   organizations = params[:organization] if params[:organization]
  #   form_query = params[:q].downcase.strip if params[:q]

  #   form_query_filter = "AND lower(p.name) LIKE '%" + form_query + "%'" if params[:q]

  #   if (donors && !donors.include?('All') )
  #     if params[:donor_include] === "include"
  #       donors_filter = "AND d.name IN (" + donors.map {|str| "'#{str}'"}.join(',') + ")"
  #     else
  #       donors_filter = "AND d.name NOT IN (" + donors.map {|str| "'#{str}'"}.join(',') + ")"
  #     end
  #   end

  #   if (sectors && !sectors.include?('All') )
  #     if params[:sector_include] === "include"
  #       sectors_filter = "AND s.name IN (" + sectors.map {|str| "'#{str}'"}.join(',') + ")"
  #     else
  #       sectors_filter = "AND s.name NOT IN (" + sectors.map {|str| "'#{str}'"}.join(',') + ")"
  #     end
  #   end

  #   if (countries && !countries.include?('All') )
  #     if params[:country_include] === "include"
  #       countries_filter = "AND g.country_name IN (" + countries.map {|str| "'#{str}'"}.join(',') + ")"
  #     else
  #       countries_filter = "AND g.country_name NOT IN (" + countries.map {|str| "'#{str}'"}.join(',') + ")"
  #     end
  #   end

  #  if (organizations && !organizations.include?('All') )
  #     if params[:organization_include] === "include"
  #       organizations_filter = "AND o.name IN (" + organizations.map {|str| "'#{str}'"}.join(',') + ")"
  #     else
  #       organizations_filter = "AND o.name NOT IN (" + organizations.map {|str| "'#{str}'"}.join(',') + ")"
  #     end
  #   end


    ###########################
    ## << FILTERING
    ###########################

   # active_projects = params[:active_projects] ? "AND p.end_date > now()" : "";

    # base_select = <<-SQL
    #   WITH t AS (
    #     SELECT p.id AS project_id,  p.name AS project_name, p.budget as project_budget,
    #            CASE WHEN d.id is null THEN '0' ELSE  d.id END donor_id,
    #            CASE WHEN d.id is null THEN 'UNKNOWN' ELSE d.name END donor_name,
    #            s.id AS sector_id,  s.name AS sector_name,
    #            g.id AS country_id, g.country_name AS country_name,
    #            o.id AS organization_id, o.name AS organization_name,
    #            g.center_lat AS lat, g.center_lon AS lon
    #     FROM projects p
    #            INNER JOIN projects_sectors ps ON (p.id = ps.project_id)
    #            LEFT OUTER JOIN sectors s ON (s.id = ps.sector_id)
    #            LEFT OUTER JOIN donations dt ON (p.id = dt.project_id)
    #            LEFT OUTER JOIN donors d ON (d.id = dt.donor_id)
    #            INNER JOIN organizations o ON (p.primary_organization_id = o.id)
    #            INNER JOIN geolocations_projects gp ON (p.id = gp.project_id)
    #            INNER JOIN geolocations g ON (g.id = gp.geolocation_id)
    #            INNER JOIN geolocations c ON (g.country_uid = c.uid)
    #     WHERE p.start_date <= '#{end_date}'::date
    #       AND p.end_date >= '#{start_date}'::date
    #       #{active_projects}
    #       #{form_query_filter} #{donors_filter} #{sectors_filter} #{countries_filter} #{organizations_filter}
    #     GROUP BY p.id, o.id, s.id, d.id, g.id

    #   )
    # SQL

    # @data = @data || {}
    # @data[:bar_chart] = {}
    # @data[:bar_chart][:donors] = Project.bar_chart_donors(base_select)
    # @data[:bar_chart][:organizations] = Project.bar_chart_organizations(base_select)
    # @data[:bar_chart][:countries] = Project.bar_chart_countries(base_select)
    # @data[:bar_chart][:sectors] = Project.bar_chart_sectors(base_select)

    # @data

 # end

  # COUNTRIES BY PROJECTS, ORGANIZATIONS, DONORS
  # def self.bar_chart_countries(base_select, limit=10)
  #   countries = {}
  #   countries[:bar_chart] = {}
  #   countries[:maps] = {}

  #   # ITERATE over the 3 criterias for grouping on Organizations scenario
  #   [["project_id","n_projects"], ["organization_id","n_organizations"], ["donor_id","n_donors"]].each do |criteria|

  #     # SELECTS FOR BAR CHARTS ON REPORTING
  #     concrete_select = <<-SQL
  #       SELECT country_uid, country_name,
  #              count(distinct(project_id)) AS n_projects,  count(distinct(organization_id)) AS n_organizations, sum(distinct(donor_id)) as n_donors
  #         FROM t
  #        WHERE country_uid IN
  #             (SELECT country_uid FROM
  #               (SELECT distinct(country_uid), count(#{criteria[0]}) AS total
  #                FROM t
  #                GROUP BY country_uid ORDER BY total DESC LIMIT #{limit}) max
  #             )
  #       GROUP BY country_uid, country_name
  #       ORDER BY #{criteria[1]} DESC
  #     SQL
  #     countries[:bar_chart]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + concrete_select)

  #     # SELECTS FOR MAPS ON REPORTING
  #     projects_map_select = <<-SQL
  #       SELECT DISTINCT(country_uid ||'|'|| country_name ||'|'|| lat||'|'||lon) AS country, count(#{criteria[0]}) AS n_projects
  #       FROM t
  #       WHERE country_uid IN
  #         (SELECT country_uid FROM
  #           (SELECT DISTINCT(country_uid), count(distinct(#{criteria[0]})) as total FROM t group by country_id ORDER BY total desc LIMIT  #{limit}) max
  #         )
  #       GROUP BY  country_uid, country_name, lat, lon
  #       ORDER BY n_projects desc
  #     SQL
  #     countries[:maps]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + projects_map_select)
  #   end
  #   countries

  # end

  # # ORGANIZATIONS BY PROJECTS, ORGANIZATIONS, TOTAL_BUDGET
  # def self.bar_chart_organizations(base_select, limit=10)

  #   organizations = {}
  #   organizations[:bar_chart] = {}
  #   organizations[:maps] = {}

  #   # ITERATE over the 3 criterias for grouping on Organizations scenario
  #   [["project_id","n_projects"], ["country_id","n_countries"], ["project_budget","total_budget"]].each do |criteria|

  #     # SELECTS FOR BAR CHARTS ON REPORTING
  #     concrete_select = <<-SQL
  #       SELECT organization_id, organization_name,
  #              count(distinct(project_id)) AS n_projects, count(country_id) AS n_countries, sum(distinct(project_budget)) as total_budget
  #         FROM t
  #        WHERE organization_id IN
  #             (SELECT organization_id FROM
  #               (SELECT distinct(organization_id), count(#{criteria[0]}) AS total
  #                FROM t
  #                GROUP BY organization_id ORDER BY total DESC LIMIT #{limit}) max
  #             )
  #       GROUP BY organization_id, organization_name
  #       ORDER BY #{criteria[1]} DESC
  #     SQL
  #     organizations[:bar_chart]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + concrete_select)
  #     p (base_select + concrete_select).gsub("\n", " ")

  #     # SELECTS FOR MAPS ON REPORTING
  #     projects_map_select = <<-SQL
  #       SELECT DISTINCT(country_uid ||'|'|| country_name ||'|'|| lat||'|'||lon) AS country, count(#{criteria[0]}) AS n_projects
  #       FROM t
  #       WHERE organization_id IN
  #         (SELECT organization_id FROM
  #           (SELECT DISTINCT(organization_id), count(distinct(#{criteria[0]})) as total
  #              FROM t group by organization_id
  #              ORDER BY total desc LIMIT  #{limit}) max
  #         )
  #       GROUP BY  country_uid, country_name, lat, lon
  #       ORDER BY n_projects desc
  #     SQL
  #     p (base_select + projects_map_select).gsub("\n", " ")
  #     organizations[:maps]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + projects_map_select)
  #   end
  #   organizations
  # end

  # # DONORS BY PROJECTS, ORGANIZATIONS, COUNTRIES
  # def self.bar_chart_donors(base_select, limit=10)

  #   donors = {}
  #   donors[:bar_chart] = {}
  #   donors[:maps] = {}

  #   # ITERATE over the 3 criterias for grouping on Donors scenario
  #   [["project_id","n_projects"], ["organization_id","n_organizations"], ["country_uid","n_countries"]].each do |criteria|

  #     # SELECTS FOR BAR CHARTS ON REPORTING
  #     concrete_select = <<-SQL
  #       SELECT donor_id, donor_name,
  #              count(distinct(project_id)) AS n_projects, count(distinct(organization_id)) AS n_organizations, count(distinct(country_uid)) AS n_countries
  #         FROM t
  #        WHERE donor_id IN
  #             (SELECT donor_id FROM
  #               (SELECT distinct(donor_id), count(#{criteria[0]}) AS total
  #                FROM t
  #                GROUP BY donor_id ORDER BY total DESC LIMIT #{limit}) max
  #             )
  #       GROUP BY donor_id, donor_name
  #       ORDER BY #{criteria[1]} DESC
  #     SQL
  #     donors[:bar_chart]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + concrete_select)

  #     # SELECTS FOR MAPS ON REPORTING
  #     projects_map_select = <<-SQL
  #       SELECT DISTINCT(country_uid ||'|'|| country_name ||'|'|| lat||'|'||lon) AS country, count(#{criteria[0]}) AS n_projects
  #       FROM t
  #       WHERE donor_id IN
  #         (SELECT donor_id FROM
  #           (SELECT DISTINCT(donor_id), count(distinct(#{criteria[0]})) as total FROM t group by donor_id ORDER BY total desc LIMIT  #{limit}) max
  #         )
  #       GROUP BY  country_uid, country_name, lat, lon
  #       ORDER BY n_projects desc
  #     SQL
  #     donors[:maps]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + projects_map_select)
  #   end
  #   donors
  # end

  # # SECTORS BY PROJECTS, ORGANIZATIONS, COUNTRIES
  # def self.bar_chart_sectors(base_select, limit=10)

  #   sectors = {}
  #   sectors[:bar_chart] = {}
  #   sectors[:maps] = {}

  #   # ITERATE over the 3 criterias for grouping on Organizations scenario
  #   [["project_id","n_projects"], ["organization_id","n_organizations"], ["donor_id","n_donors"]].each do |criteria|

  #     # SELECTS FOR BAR CHARTS ON REPORTING
  #     concrete_select = <<-SQL
  #       SELECT sector_id, sector_name,
  #              count(distinct(project_id)) AS n_projects,  count(distinct(organization_id)) AS n_organizations, sum(distinct(donor_id)) as n_donors
  #         FROM t
  #        WHERE sector_id IN
  #             (SELECT sector_id FROM
  #               (SELECT distinct(sector_id), count(#{criteria[0]}) AS total
  #                FROM t
  #                GROUP BY sector_id ORDER BY total DESC LIMIT #{limit}) max
  #             )
  #       GROUP BY sector_id, sector_name
  #       ORDER BY #{criteria[1]} DESC
  #     SQL
  #     sectors[:bar_chart]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + concrete_select)

  #     # SELECTS FOR MAPS ON REPORTING
  #     projects_map_select = <<-SQL
  #       SELECT DISTINCT(country_uid ||'|'|| country_name ||'|'|| lat||'|'||lon) AS country, count(#{criteria[0]}) AS n_projects
  #       FROM t
  #       WHERE sector_id IN
  #         (SELECT sector_id FROM
  #           (SELECT DISTINCT(sector_id), count(distinct(#{criteria[0]})) as total FROM t group by sector_id ORDER BY total desc LIMIT  #{limit}) max
  #         )
  #       GROUP BY  country_uid, country_name, lat, lon
  #       ORDER BY n_projects desc
  #     SQL
  #     sectors[:maps]["by_"+criteria[1]] = ActiveRecord::Base.connection.execute(base_select + projects_map_select)
  #   end
  #   sectors
  # end


  # def self.get_budgets(params={})
  #   start_date = Date.parse(params[:start_date]['day']+"-"+params[:start_date]['month']+"-"+params[:start_date]['year']) if params[:start_date]
  #   end_date = Date.parse(params[:end_date]['day']+"-"+params[:end_date]['month']+"-"+params[:end_date]['year']) if params[:end_date]
  #   countries = params[:country] if params[:country]
  #   donors = params[:donor] if params[:donor]
  #   sectors = params[:sector] if params[:sector]
  #   organizations = params[:organization] if params[:organization]
  #   form_query = params[:q].downcase.strip if params[:q]
  #   active = params[:active_projects]
  #   if params[:model]
  #     the_model = params[:model]
  #   else
  #     the_model='p'
  #   end
  #   if params[:limit]
  #     the_limit = params[:limit]
  #   else
  #     the_limit='NULL'
  #   end

  #   if start_date && end_date && !active
  #     date_filter = "AND p.start_date <= '#{end_date}'::date AND p.end_date >= '#{start_date}'::date"
  #   elsif active == 'yes'
  #     date_filter = "AND p.start_date <= '#{Time.now.to_date}'::date AND p.end_date >= '#{Time.now.to_date}'::date"
  #   end

  #   form_query_filter = "AND lower(p.name) LIKE '%" + form_query + "%'" if params[:q]

  #   if donors && !donors.include?('All')
  #     donors_filter = "AND d.name IN (" + donors.map {|str| "'#{str}'"}.join(',') + ")"
  #   end

  #   if sectors && !sectors.include?('All')
  #     sectors_filter = "AND s.name IN (" + sectors.map {|str| "'#{str}'"}.join(',') + ")"
  #   end

  #   if countries && !countries.include?('All')
  #     countries_filter = "AND g.country_name IN (" + countries.map {|str| "#{ActiveRecord::Base.connection.quote(str)}"}.join(',') + ")"
  #   end

  #   if organizations && !organizations.include?('All')
  #     organizations_filter = "AND org.name IN (" + organizations.map {|str| "#{ActiveRecord::Base.connection.quote(str)}"}.join(',') + ")"
  #     organizations_filter = organizations_filter.gsub(/&amp;/, '&')
  #   end

  #   sql = <<-SQL
  #     WITH budget_table AS (SELECT o.id AS o_id, o.name AS o_name, COALESCE(sum(p.budget), 0) as total_budget
  #         FROM organizations o
  #         INNER JOIN projects p ON (p.primary_organization_id = o.id)
  #         GROUP BY o_id, o_name),
  #     query_table AS (SELECT org.id as org_id
  #             FROM organizations org
  #                    INNER JOIN projects p ON (p.primary_organization_id = org.id)
  #                    INNER JOIN projects_sectors ps ON (p.id = ps.project_id)
  #                    LEFT OUTER JOIN sectors s ON (s.id = ps.sector_id)
  #                    LEFT OUTER JOIN donations dt ON (p.id = dt.project_id)
  #                    LEFT OUTER JOIN donors d ON (d.id = dt.donor_id)
  #                    INNER JOIN geolocations_projects gp ON (p.id = gp.project_id)
  #                    INNER JOIN geolocations g ON (g.id = gp.geolocation_id)
  #                    WHERE true
  #                    #{date_filter} #{form_query_filter} #{donors_filter} #{sectors_filter} #{countries_filter} #{organizations_filter}
  #                    )
  #     SELECT o_id, o_name, total_budget
  #     FROM budget_table
  #     INNER JOIN
  #     query_table
  #     on budget_table.o_id = query_table.org_id
  #     GROUP BY o_id, o_name, total_budget
  #     ORDER BY total_budget DESC
  #     LIMIT #{the_limit}
  #   SQL
  #   budgets = ActiveRecord::Base.connection.execute(sql)
  # end

  ############################################## REPORTS ##############################################


end
