class DonorsController < ApplicationController

  include ProjectsFiltering
  include DonorsHelper
  include PreloadVars

  layout :sites_layout

  def show
    @donor = Donor.find(params[:id])
  end
  def resource
    Donor
  end
end
