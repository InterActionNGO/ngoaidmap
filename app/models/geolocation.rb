# == Schema Information
#
# Table name: geolocations
#
#  id                :integer          not null, primary key
#  uid               :string
#  name              :string
#  latitude          :float
#  longitude         :float
#  fclass            :string
#  fcode             :string
#  country_code      :string
#  country_name      :string
#  country_uid       :string
#  cc2               :string
#  admin1            :string
#  admin2            :string
#  admin3            :string
#  admin4            :string
#  provider          :string           default("Geonames")
#  adm_level         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  g0                :string
#  g1                :string
#  g2                :string
#  g3                :string
#  g4                :string
#  custom_geo_source :string
#

class Geolocation < ActiveRecord::Base
  has_and_belongs_to_many :projects
  scope :active, -> {joins(:projects).where("projects.end_date is null or (projects.end_date > ? AND projects.start_date < ?)", Date.today.to_s(:db), Date.today.to_s(:db))}
  scope :sectors, -> (sectors) {joins(projects: :sectors).where(sectors: {id: sectors})}
  scope :site, -> (site) {joins(projects: :sites).where(sites: {id: site})}
  scope :countries, -> (countries) {where(geolocations: {country_uid: countries})}
  scope :projects, -> (projects){joins(:projects).where(projects: {id: projects})}
  scope :donors, -> (donors){joins(projects: :donors).where(donors: {id: donors})}
  scope :geolocation, -> (geolocation){where(geolocations: {uid: geolocation})}
  scope :organizations, -> (orgs){joins(:projects).joins('join organizations on projects.primary_organization_id = organizations.id').where(organizations: {id: orgs})}
  def self.sum_projects(options='')
    where=''
    if options && options == 'active'
        where= 'WHERE projects.end_date > NOW() AND projects.start_date < NOW()'
    end
    query = %{
        SELECT geolocations.g0, geolocations.country_name,
        COUNT(DISTINCT(projects.id)) as total_projects FROM geolocations
        INNER JOIN geolocations_projects
        ON geolocations_projects.geolocation_id = geolocations.id
        INNER JOIN projects
        ON projects.id = geolocations_projects.project_id
        #{where}
        GROUP BY geolocations.g0, geolocations.country_name
        ORDER BY total_projects DESC
    }
    result = ActiveRecord::Base.connection.execute(query)
    result.map{|r| r}
  end
  def self.fetch_all(options={})
    geolocations = Geolocation.all
    geolocations = geolocations.site(options[:site])                                    if options[:site]
    geolocations = geolocations.active                                                  if options[:status] && options[:status] == 'active'
    geolocations = geolocations.projects(options[:projects])                            if options[:projects]
    geolocations = geolocations.organizations(options[:organizations])                  if options[:organizations]
    geolocations = geolocations.sectors(options[:sectors])                              if options[:sectors]
    geolocations = geolocations.donors(options[:donors])                                if options[:donors]
    geolocations = geolocations.countries(options[:countries])                          if options[:countries]
    geolocations = geolocations.geolocation(options[:geolocation])                      if options[:geolocation]
    geolocations.uniq
  end
  def iati_uid
    uid = self.uid
    uid = uid.gsub('gn_','') if uid.include?('gn_')
    uid = uid.gsub('osm_','') if uid.include?('osm_')
    uid
    # gadm_ ne_ cust_
  end
  def iati_provider
    case self.provider
    when 'gn'
      'G1'
    when 'osm'
      'G2'
    else
      ''
    end
  end
  def readable_path
    [self.g0, self.g1, self.g2, self.g3, self.g4].compact.map{|g| Geolocation.find_by(uid: g).try(:name)}.join('>')
  end
end
