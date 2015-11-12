class ProjectsController < ApplicationController

  include PreloadVars
  include ProjectsFiltering
  layout 'site_layout'
  #caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }

  def show
    @project = Project.includes(:prime_awardee).find(params[:id])
  end
  def resource
    Project
  end

end
