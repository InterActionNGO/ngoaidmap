class ClustersSectorsController < ApplicationController

  include ProjectsFiltering
  layout :sites_layout

  def show
    @sector = Sector.find(params[:id])
  end

end
