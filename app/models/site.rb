# == Schema Information
#
# Table name: sites
#
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  short_description               :text
#  long_description                :text
#  contact_email                   :string(255)
#  contact_person                  :string(255)
#  url                             :string(255)
#  permalink                       :string(255)
#  google_analytics_id             :string(255)
#  logo_file_name                  :string(255)
#  logo_content_type               :string(255)
#  logo_file_size                  :integer
#  logo_updated_at                 :datetime
#  theme_id                        :integer
#  blog_url                        :string(255)
#  word_for_clusters               :string(255)
#  word_for_regions                :string(255)
#  show_global_donations_raises    :boolean          default(FALSE)
#  project_classification          :integer          default(0)
#  geographic_context_country_id   :integer
#  geographic_context_region_id    :integer
#  project_context_cluster_id      :integer
#  project_context_sector_id       :integer
#  project_context_organization_id :integer
#  project_context_tags            :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  geographic_context_geometry     :geometry
#  project_context_tags_ids        :string(255)
#  status                          :boolean          default(FALSE)
#  visits                          :float            default(0.0)
#  visits_last_week                :float            default(0.0)
#  aid_map_image_file_name         :string(255)
#  aid_map_image_content_type      :string(255)
#  aid_map_image_file_size         :integer
#  aid_map_image_updated_at        :datetime
#  navigate_by_country             :boolean          default(FALSE)
#  navigate_by_level1              :boolean          default(FALSE)
#  navigate_by_level2              :boolean          default(FALSE)
#  navigate_by_level3              :boolean          default(FALSE)
#  map_styles                      :text
#  overview_map_lat                :float
#  overview_map_lon                :float
#  overview_map_zoom               :integer
#  internal_description            :text
#  featured                        :boolean          default(FALSE)
#

class Site < ActiveRecord::Base

  @@main_domain = 'ngoaidmap.org'
  after_save :set_cached_projects
  after_destroy :remove_cached_projects

  #has_many :resources, :conditions => 'resources.element_type = #{Iom::ActsAsResource::SITE_TYPE}', :foreign_key => :element_id, :dependent => :destroy
  #has_many :media_resources, :conditions => 'media_resources.element_type = #{Iom::ActsAsResource::SITE_TYPE}', :foreign_key => :element_id, :dependent => :destroy, :order => 'position ASC'
  belongs_to  :theme
  belongs_to  :geographic_context_country, :class_name => 'Country'
  belongs_to :geographic_context_region, :class_name => 'Region'
  has_many :partners, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :projects
  #has_many :cached_projects, :class_name => 'Project'#, :finder_sql => 'select projects.* from projects, projects_sites where projects_sites.site_id = #{id} and projects_sites.project_id = projects.id'
  has_many :stats, :dependent => :destroy

  has_many :site_layers
  has_many :layers, :through => :site_layers

  has_attached_file :logo, :styles => {
                                      :small => {
                                        :geometry => "80x46>",
                                        :format => 'jpg'
                                      }
                                    },
                            :url => "/system/:attachment/:id/:style.:extension"

  has_attached_file :aid_map_image, :styles => {
                                      :small => {
                                        :geometry => "285x168#",
                                        :format => 'jpg'
                                      },
                                      :huge => {
                                        :geometry => "927x444#",
                                        :format => 'jpg'
                                      }
                                    },
                                    :convert_options => {
                                      :all => "-quality 90"
                                    },
                                    :url => "/system/:attachment/:id/:style.:extension",
                                    :default_url => "/images/no_aid_map_image_huge.jpg"

  scope :published, -> {where(:status => true)}
  scope :draft,     -> {where(:status => false)}

  def featured_sites
    Site.where(featured: true).where.not(id: self.id)
  end

  def regions_select
    Geolocation.where(country_uid: self.geographic_context_country_id).where('adm_level > 0').select(:name, :uid, :adm_level).uniq.order('name ASC')
  end

  def pages_by_parent(parent_permalink)
    unless parent_page = self.pages.where(:permalink => parent_permalink, :published => true).first
      []
    else
      self.pages.where(:parent_id => parent_page.id).to_a
    end
  end

  def projects_sql(options = {})
    default_options = { :limit => 10, :offset => 0 }
    options = default_options.merge(options)

    projects = Project.all
    # (1)
    # if project_context_cluster_id?
    #   from << "clusters_projects"
    #   where << "(clusters_projects.project_id = projects.id AND clusters_projects.cluster_id = #{project_context_cluster_id})"
    # end

    # (2)
    if project_context_sector_id?
      # from << "projects_sectors"
      # where << "(projects_sectors.project_id = projects.id AND projects_sectors.sector_id = #{project_context_sector_id})"
      projects = projects.joins(:sectors).where("sectors.id='#{self.project_context_sector_id}'")
    end

    # (3)
    if project_context_organization_id?
      # where << "projects.primary_organization_id = #{project_context_organization_id}"
      projects = projects.where('projects.primary_organization_id = #{project_context_organization_id}')
    end

    # (4)
#     if project_context_tags_ids?
      # from << "projects_tags"
      # where << "(projects_tags.project_id = projects.id AND projects_tags.tag_id IN (#{project_context_tags_ids}))"
#       projects = projects.joins(:tags).where("tags.id IN (#{project_context_tags_ids})")
#     end
    
    if tags.count > 0
       projects = projects.joins(:tags).where("tags.id in (#{tags.pluck(:id).join(',')})") 
    end

    # (5)
    if geographic_context_country_id? && geographic_context_region_id.blank?
      projects = projects.joins(:geolocations).where("geolocations.country_uid='#{self.geographic_context_country_id}'")
    end

    # (6)
    # if geographic_context_region_id?
    #   from << "projects_regions"
    #   where << "(projects_regions.project_id = projects.id AND projects_regions.region_id = #{geographic_context_region_id})"
    # end

    # (7)
    # if geographic_context_geometry?
    #   from  << 'sites'
    #   where << "ST_Intersects(sites.geographic_context_geometry,projects.the_geom)"
    # end

    # result = Project.select(select).from(from.join(',')).where(where.join(' AND ')).joins(joinning).group(Project.custom_fields.join(','))

    if options[:limit]
      projects = projects.limit(options[:limit])
      if options[:offset]
        projects = result.offset(options[:offset])
      end
    end
    projects
  end

  def set_cached_projects
    remove_cached_projects

    #Insert into the relation all the sites that belong to the site.
    sql="insert into projects_sites
    select distinct(subsql.id) as project_id, #{self.id} as site_id from (#{projects_sql({ :limit => nil, :offset => nil }).to_sql}) as subsql"
    ActiveRecord::Base.connection.execute(sql)
    #Rails.cache.clear
    $redis.flushall
  end

  def remove_cached_projects
    ActiveRecord::Base.connection.execute("DELETE FROM projects_sites WHERE site_id = #{self.id}")
  end
end
