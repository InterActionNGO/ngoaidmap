class OrganizationsController < ApplicationController
  #before_action :merge_params, on: :show
  layout :sites_layout
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
      format.csv do
        send_data Project.to_csv(@site, projects_custom_find_options),
          :type => 'text/plain; charset=utf-8; application/download',
          :disposition => "attachment; filename=#{@organization.name.gsub(/[^0-9A-Za-z]/, '')}_projects.csv"
      end
      format.xls do
        send_data Project.to_excel(@site, projects_custom_find_options),
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{@organization.name.gsub(/[^0-9A-Za-z]/, '')}_projects.xls"
      end
      format.kml do
        @projects_for_kml = Project.to_kml(@site, projects_custom_find_options)
      end
    end
  end

  private
  def filter_by_category_valid?
    @filter_by_category.present? && @filter_by_category.to_i > 0
  end
  def merge_params
    params.merge({organizations: [params[:id]]})
  end
end
