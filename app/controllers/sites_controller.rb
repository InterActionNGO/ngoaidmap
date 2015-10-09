class SitesController < ApplicationController
  layout :sites_layout
  include PreloadVars
  include ProjectsFiltering

  def home
    unless Project.site_name=='global'
      @footer_sites = @site.sites_for_footer
      @overview_map_chco = @site.theme.data[:overview_map_chco]
      @overview_map_chf = @site.theme.data[:overview_map_chf]
      @overview_map_marker_source = @site.theme.data[:overview_map_marker_source]
    end
  end

  def about
  end

  def about_interaction
  end

  def contact
  end




end
