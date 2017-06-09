module PreloadVars
  extend ActiveSupport::Concern
  included do
    before_action :get_menu_items
  end
  def get_menu_items
    @organizations = Organization.site(@site.id).active.order(:name).uniq.pluck(:id, :name)
    @donors = Organization.with_donations.donated_projects_site(@site.id).active_donated_projects.uniq.order(:name).uniq.pluck(:id, :name)
    @countries = Geolocation.where(adm_level: 0).order(:name).uniq.pluck(:uid, :name)
    @sectors = Sector.counting_projects(status: 'active', site: @site.id)
    @partners = Organization.joins(:partner_projects).merge(Project.active).order(:name).uniq.pluck(:id, :name)
  end
end
