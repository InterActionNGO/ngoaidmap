class DonorsController < ApplicationController

  include ProjectsFiltering
  include DonorsHelper
  include PreloadVars

  respond_to :html, :kml, :js, :xls, :csv
  layout :sites_layout

  def show
    @donor = Donor.find(params[:id])

  end

end
