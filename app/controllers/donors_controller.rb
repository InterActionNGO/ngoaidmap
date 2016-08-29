class DonorsController < ApplicationController

  include ProjectsFiltering
  include DonorsHelper
  include PreloadVars

  layout :sites_layout

  def show
    @donor = Organization.with_donations.find(params[:id])
  end
  def resource
    Organization
  end
end
