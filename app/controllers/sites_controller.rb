class SitesController < ApplicationController

  layout :sites_layout

  def home
    m = ActiveModel::Serializer::ArraySerializer.new(Project.fetch_all(projects_params), each_serializer: ProjectSerializer)
    @map_data = ActiveModel::Serializer::Adapter::JsonApi.new(m, include: ['organization', 'sectors', 'donors', 'countries', 'regions']).to_json
    @map_data_max_count = 0;
<<<<<<< HEAD
    projects_count = Project.fetch_all(projects_params).length
    @projects = Project.fetch_all(projects_params).paginate(page: params[:page], per_page: 10, total_entries: projects_count)
=======
    @projects = Project.fetch_all(projects_params).page(params[:page]).per(10)
>>>>>>> b995fb8023f82d89e027bfb26b0899ea1cb8c633
  end

  def downloads
    respond_to do |format|
      format.csv do
        send_data Project.to_csv(@site, {}),
          :type => 'text/plain; charset=utf-8; application/download',
          :disposition => "attachment; filename=#{@site.id}_projects.csv"
      end
      format.xls do
        send_data Project.to_excel(@site, {}),
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{@site.id}_projects.xls"
      end
      format.kml do
        send_data Project.to_kml(@site, {}),
        # :type        => 'application/vnd.google-earth.kml+xml, application/vnd.google-earth.kmz',
          :disposition => "attachment; filename=#{@site.id}_projects.kml"
      end
      format.xml do
        @rss_items = Project.custom_find @site, :start_in_page => 0, :random => false, :per_page => 1000

        render :site_home
      end
    end
  end

  def about
  end

  def about_interaction
  end

  def contact
  end

  private
  def projects_params
    params.permit(organizations:[], countries:[], regions:[], sectors:[], donors:[], sectors:[])
  end


end
