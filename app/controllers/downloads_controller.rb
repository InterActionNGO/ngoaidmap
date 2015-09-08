class DownloadsController < ApplicationController
  include ProjectsFiltering
  def show
    respond_to do |format|
      format.csv {
        send_data @projects.to_csv,
          :type => 'text/plain; charset=utf-8; application/download',
          :disposition => "attachment; filename=#{Time.now.in_time_zone}_projects.csv"
      }
      format.xls {
        send_data @projects.to_excel,
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{@site.id}_projects.xls"
      }
    end
  end
end
