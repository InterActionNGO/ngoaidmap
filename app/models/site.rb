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

  #has_many :resources, :conditions => 'resources.element_type = #{Iom::ActsAsResource::SITE_TYPE}', :foreign_key => :element_id, :dependent => :destroy
  #has_many :media_resources, :conditions => 'media_resources.element_type = #{Iom::ActsAsResource::SITE_TYPE}', :foreign_key => :element_id, :dependent => :destroy, :order => 'position ASC'
  belongs_to  :theme
  belongs_to  :geographic_context_country, :class_name => 'Country'
  belongs_to :geographic_context_region, :class_name => 'Region'
  has_many :partners, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_and_belongs_to_many :projects
  #has_many :cached_projects, :class_name => 'Project'#, :finder_sql => 'select projects.* from projects, projects_sites where projects_sites.site_id = #{id} and projects_sites.project_id = projects.id'
  has_many :stats, :dependent => :destroy

  has_many :site_layers
  has_many :layer, :through => :site_layers

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
end
