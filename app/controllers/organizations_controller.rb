class OrganizationsController < ApplicationController
  #before_action :merge_params, on: :show
  layout :sites_layout
  include PreloadVars
  include ProjectsFiltering

  #caches_action :index, :expires_in => 300, :cache_path => Proc.new { |c| c.params }
  #caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }

  def index
    @organizations = @site.organizations
  end

  def show
    @organization = Organization.find(params[:id])
    # unless @organization = @site.organizations.select{ |org| org.id == params[:id].to_i }.first
    #   raise ActiveRecord::RecordNotFound
    # end

    respond_to do |format|
      format.html do
      end
      format.js do
        render :update do |page|
          page << "$('#projects_view_more').remove();"
          page << "$('#projects').html('#{escape_javascript(render(:partial => 'projects/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
    end
  end
  def resource
    Organization
  end
end
