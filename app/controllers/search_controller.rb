class SearchController < ApplicationController

  layout 'site_layout'

  def index
    @regions = Geolocation.all.select(:id, :name, :country_name)
    limit = 20
    @current_page = params[:page] ? params[:page].to_i : 1
    @clusters = @regions = @filtered_regions = @filtered_sectors = @filtered_clusters = @filtered_organizations = @filtered_donors = []
    @navigate_by_cluster = false

    p params[:regions]

    if params[:regions].present?
       @filtered_regions = Geolocation.find_by_sql("select g.id, g.name, g.country_name from geolocations as g
       where g.id in (#{params[:regions].join(",")})")
       filtered_regions_where = "where g.id not in (#{params[:regions].join(",")})"
    end

     if params[:sectors].present?
       @filtered_sectors = Sector.find_by_sql("select s.id, s.name as title from sectors as s where s.id in (#{params[:sectors].join(",")})")
       filtered_sectors_where = "where s.id not in (#{params[:sectors].join(",")})"
     end

    if params[:organizations].present?
      @filtered_organizations = Organization.find_by_sql("select o.id, o.name as title from organizations as o where o.id in (#{params[:organizations].join(",")})")
      filtered_organizations_where = "where o.id not in (#{params[:organizations].join(",")})"
    end

    if params[:donors].present?
      @filtered_donors = Donor.find_by_sql("select d.id, d.name from donors as d where d.id in (#{params[:donors].join(",")})")
      filtered_donors_where = "where d.id not in (#{params[:donors].join(",")})"
    end

    if params[:status].present? and params[:status] != 'Any'
      case params[:status]
        when 'Active'
          #then where << "(end_date is null OR end_date > now())"
        when 'Inactive'
          #then where << "end_date < now()"
      end
    end

    if params[:date]
      start_month = params[:date][:start_month]
      start_year  = params[:date][:start_year]
      end_month   = params[:date][:end_month]
      end_year    = params[:date][:end_year]

      if start_month.present? && start_year.present?
        start_month = start_month.sanitize_sql!.to_i
        start_year = start_year.sanitize_sql!.to_i
        @start_date = Date.new(start_year, start_month, 1)
        #where << "start_date >= '#{@start_date.strftime('%Y-%m-%d')}'"
      elsif start_month.blank? && start_year.present?
        start_year = start_year.sanitize_sql!.to_i
        @start_date = Date.new(start_year, 1, 1)
        #where << "start_date >= '#{@start_date.strftime('%Y-%m-%d')}'"
      end

      if end_month.present? && end_year.present?
        end_month = end_month.sanitize_sql!.to_i
        end_year = end_year.sanitize_sql!.to_i
        @end_date = Date.new(end_year, end_month, 1)
        #where << "end_date <= '#{@end_date.strftime('%Y-%m-%d')}'"
      elsif end_month.blank? && end_year.present?
        end_year = end_year.sanitize_sql!.to_i
        @end_date = Date.new(end_year, 12, 31)
        #where << "end_date <= '#{@end_date.strftime('%Y-%m-%d')}'"
      end
    end

    if params[:q].present?
      q = "%#{params[:q].sanitize_sql!}%"
      #where << "(project_name ilike '#{q}' OR
      #           project_description ilike '#{q}' OR
      #           organization_name ilike '#{q}' OR
      #           sectors ilike '#{q}' OR
      #           regions ilike '#{q}' )"
    end

    #where << "(end_date is null OR end_date >= now())"

    #where = where.present? ? "WHERE #{where.join(' AND ')}" : ''

    #sql = "select * from projects p
    #                 INNER JOIN projects_sectors ps ON (p.id = ps.project_id)
    #                 INNER JOIN projects_sites psi ON (psi.project_id = p.id)
    #                 LEFT OUTER JOIN sectors s ON (s.id = ps.sector_id)
    #                 LEFT OUTER JOIN donations dt ON (p.id = dt.project_id)
    #                 LEFT OUTER JOIN donors d ON (d.id = dt.donor_id)
    #                 INNER JOIN organizations o ON (p.primary_organization_id = o.id)
    #                 INNER JOIN geolocations_projects gp ON (p.id = gp.project_id)
    #                 INNER JOIN geolocations g ON (g.id = gp.geolocation_id)
    #          #{where}
    #          order by created_at DESC
    #          limit #{limit} offset #{limit * (@current_page - 1)}"

    @projects = Project.fetch_all(projects_params)

    #sql_count = "select count(*) as count from projects p
    #                 INNER JOIN projects_sectors ps ON (p.id = ps.project_id)
    #                 INNER JOIN projects_sites psi ON (psi.project_id = p.id)
    #                 LEFT OUTER JOIN sectors s ON (s.id = ps.sector_id)
    #                 LEFT OUTER JOIN donations dt ON (p.id = dt.project_id)
    #                 LEFT OUTER JOIN donors d ON (d.id = dt.donor_id)
    #                 INNER JOIN organizations o ON (p.primary_organization_id = o.id)
    #                 INNER JOIN geolocations_projects gp ON (p.id = gp.project_id)
    #                 INNER JOIN geolocations g ON (g.id = gp.geolocation_id)
    #
    #                  #{where}"
    @total_projects = @projects.count.length if @projects
    @total_pages = @projects.present? ? (@total_projects.to_f / limit.to_f).ceil : 0

    #TODO: I am not taking in consideration the search on organization and location when using the facets.

    respond_to do |format|
      format.html do
        q_filter = q.present?? "AND (p.name ilike '#{q}' OR p.description ilike '#{q}')" : ''
        # cluster / sector Facet
          sql = <<-SQL
            SELECT DISTINCT s.id,s.name AS title
            FROM sectors AS s
            INNER JOIN projects_sectors AS ps ON s.id=ps.sector_id
            INNER JOIN projects_sites AS psi ON psi.project_id=ps.project_id AND psi.site_id=#{@site.id}
            INNER JOIN projects AS p ON psi.project_id=p.id AND (p.end_date is NULL OR p.end_date > now()) #{q_filter}
            #{filtered_sectors_where}
          SQL
          @sectors = Sector.find_by_sql(sql)
        sql = <<-SQL
          SELECT DISTINCT
            r.id, r.name,r.country_name
          FROM geolocations AS r
          INNER JOIN geolocations_projects AS pr ON r.id=pr.geolocation_id
          INNER JOIN projects_sites AS ps ON pr.project_id=ps.project_id AND ps.site_id=#{@site.id}
          INNER JOIN projects AS p ON ps.project_id=p.id AND (p.end_date is NULL OR p.end_date > now()) #{q_filter}
          #{filtered_regions_where}
          ORDER BY r.country_name, r.name
        SQL
        @regions = Geolocation.find_by_sql(sql)

        sql = <<-SQL
          SELECT DISTINCT o.id, o.name AS title
          FROM organizations AS o
          INNER JOIN projects AS p ON (p.end_date is NULL OR p.end_date > now()) AND p.primary_organization_id = o.id #{q_filter}
          INNER JOIN projects_sites AS ps ON ps.project_id = p.id AND ps.site_id = #{@site.id}
          #{filtered_organizations_where}
          ORDER BY title
        SQL
        @organizations = Organization.find_by_sql(sql)

        sql = <<-SQL
          SELECT DISTINCT d.id, d.name
          FROM donors AS d
          INNER JOIN projects AS p ON (p.end_date is NULL OR p.end_date > now()) #{q_filter}
          INNER JOIN projects_sites AS ps ON ps.project_id = p.id AND ps.site_id = #{@site.id}
          INNER JOIN donations AS dn ON dn.donor_id = d.id AND dn.project_id = p.id
          #{filtered_donors_where}
          ORDER BY d.name
        SQL
        @donors = Donor.find_by_sql(sql)

      end
      format.js do
        render :update do |page|
          page << "$('#search_view_more').html('#{escape_javascript(render(:partial => 'search/pagination'))}');"
          page << "$('#search_results').html('#{escape_javascript(render(:partial => 'search/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
    end
  end

  def projects_params
    params.permit(:offset, :limit, :format, :geolocation, :level, :q, :status, organizations:[], sectors:[], donors:[], countries:[], regions:[])
  end

end
