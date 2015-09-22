class DownloadsController < ApplicationController
  before_action :set_format
  def index
    name = params[:name]
    respond_to do |format|
      format.csv {
      send_data Project.fetch_all(projects_params).to_comma,
        :type        => 'application/vnd.ms-excel',
        :disposition => "attachment; filename=#{name}.csv"
      }
      format.xls {
        send_data Project.fetch_all(projects_params).to_xls,
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{name}.xls"
      }
      # format.kml {
      #   send_data Project.fetch_all(projects_params).to_kml,
      #     :type        => 'application/vnd.google-earth.kml+xml',
      #     :disposition => "attachment; filename=#{name}.kml"
      # }
    end
  end
  def set_format
     request.format = 'csv' if params[:doc]=='csv'
     request.format = 'xls' if params[:doc]=='xls'
     #request.format = 'kml' if params[:doc]=='kml'
  end
  private
  def projects_params
    params.permit(:level, :ids, :id, :geolocation, :status, :q, :starting_after, :ending_before, organizations:[], countries:[], donors:[], sectors:[], projects:[])
  end
end
