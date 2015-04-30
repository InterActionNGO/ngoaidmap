class ProjectsController < ApplicationController

  layout 'site_layout'
  caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }

  def show
    id = if params[:id].sanitize_sql! =~ /^\d+$/
      params[:id].sanitize_sql!
    else
      raise ActiveRecord::RecordNotFound
    end
    sql = "select * from data_denormalization where site_id=#{@site.id} and
                                                    (end_date is null OR end_date >= now()) and
                                                    project_id=#{id}"

    @raw_project = Project.find_by_sql(sql).first
    raise ActiveRecord::RecordNotFound unless @raw_project
    @project = Project.find(@raw_project['project_id'])
    @empty_layer = true
    respond_to do |format|
      format.html do
        #Map data
        sql = <<-SQL
        SELECT r.id,
               r.center_lon AS lon,
               r.center_lat AS lat,
               r.name,
               r.code,
               r.country_id,
               c.name       AS country_name,
               r.level
        FROM   (projects AS p
                INNER JOIN projects_regions AS pr ON pr.project_id = p.id AND p.id = #{@project.id}
                INNER JOIN countries_projects as cp ON cp.project_id = p.id AND p.id = #{@project.id})
                INNER JOIN regions AS r   ON pr.region_id = r.id  AND r.level = 1
                INNER JOIN countries AS c ON r.country_id = c.id
        UNION
        SELECT c.id,
               c.center_lon AS lon,
               c.center_lat AS lat,
               null as name,
               c.code,
               c.id,
               c.name       AS country_name,
               null as level
        FROM   (projects AS p
                INNER JOIN countries_projects as cp ON cp.project_id = p.id AND p.id = #{@project.id})
                INNER JOIN countries AS c ON cp.country_id = c.id
        SQL

        @locations = ActiveRecord::Base.connection.execute(sql)
        if @locations.count == 0
          sql="select c.id,c.center_lon as lon,c.center_lat as lat,c.name,c.code
          from (projects as p inner join countries_projects as cp on cp.project_id=p.id and p.id=#{@project.id})
          inner join countries as c on cp.country_id=c.id"
          @locations = ActiveRecord::Base.connection.execute(sql)
        end

        @map_data  = @locations.to_json

        @overview_map_chco = @site.theme.data[:overview_map_chco]
        @overview_map_chf = @site.theme.data[:overview_map_chf]
        @overview_map_marker_source = @site.theme.data[:overview_map_marker_source]

        areas= []
        data = []
        @map_data_max_count=0
        @locations.each do |c|
          areas << c["code"]
          data  << 1
        end
        #@chld = areas.join("|")
        @chld = ""
        #@chd  = "t:"+data.join(",")
        @chd = ""
      end
      format.kml
      format.csv do
        send_data Project.to_csv(@site, :project => @project.id),
          :type => 'application/download; application/vnd.ms-excel; text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=#{@project.name.gsub(/[^0-9A-Za-z]/, '')}.csv"
      end
      format.xls do
        send_data Project.to_excel(@site, :project => @project.id),
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{@project.name.gsub(/[^0-9A-Za-z]/, '')}.xls"
      end
    end
  end

end
