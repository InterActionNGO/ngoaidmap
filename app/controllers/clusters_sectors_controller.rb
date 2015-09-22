class ClustersSectorsController < ApplicationController

  include ProjectsFiltering
  include PreloadVars
  layout :sites_layout

  def show
    @sector = Sector.find(params[:id])
  end

  def resource
    Sector
  end
end
