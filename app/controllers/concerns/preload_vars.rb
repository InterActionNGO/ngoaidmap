module PreloadVars
  extend ActiveSupport::Concern
  included do
    before_action :get_menu_items
  end
  def get_menu_items
    @organizations = Organization.active.order(:name).uniq.pluck(:id, :name)
    @donors = Donor.active.order(:name).uniq.pluck(:id, :name)
    @countries = Geolocation.where(adm_level: 0).order(:name).uniq.pluck(:uid, :name)
    @sectors = Sector.counting_projects(:status => 'active')
  end
end
