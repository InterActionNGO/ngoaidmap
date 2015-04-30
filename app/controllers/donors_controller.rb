class DonorsController < ApplicationController

  include DonorsHelper

  respond_to :html, :kml, :js, :xls, :csv
  layout :sites_layout
  caches_action :show, :expires_in => 300, :cache_path => Proc.new { |c| c.params }


  def show
    @donor = Donor.find(params[:id])
    @donor.attributes = @donor.attributes_for_site(@site)

    @filter_by_category = if params[:category_id].present?
                            params[:category_id].to_i
                          else
                            nil
                          end
    @filter_by_location = if params[:location_id].present?
                            case params[:location_id]
                            when String
                              params[:location_id].split('/').map(&:to_i)
                            else
                              params[:location_id].map(&:to_i)
                            end
                          else
                            nil
                          end
    organization_condition = if params[:organization_id].present?
                                # params[:organization_id].to_i
                                "WHERE prj.primary_organization_id=#{params[:organization_id].to_i}"
                              else
                                nil
                              end

    @filter_by_organization = if params[:organization_id].present?
                                params[:organization_id].to_i
                              else
                                nil
                              end

    @carry_on_filters = {}
    @carry_on_filters[:category_id] = params[:category_id] if params[:category_id].present?
    @carry_on_filters[:location_id] = params[:location_id] if params[:location_id].present?
    @carry_on_filters[:organization_id] = params[:organization_id] if params[:organization_id].present?

    @donor_projects_by_location = if @site.navigate_by_country?
      @donor.projects_countries(@site, @filter_by_category, @filter_by_organization, @filter_by_location)
    else
      @donor.projects_regions(@site, @filter_by_category, @filter_by_organization, @filter_by_location)
    end

    # if @filter_by_location
    #   @location_name = if @filter_by_location.size == 1
    #     "#{Country.where(:id => @filter_by_location.first).first.name}"
    #   else
    #     region = Region.where(:id => @filter_by_location.last).first
    #     "#{region.country.name}/#{region.name}" rescue ''
    #   end
    # end

    projects_options = {
      :donor_id => @donor.id,
      :per_page => 10,
      :page => params[:page],
      :order => 'created_at DESC',
      :start_in_page => params[:start_in_page],
      :organization_filter => params[:organization_id],
      :category_id => params[:category_id]
    }

    if @filter_by_location.present?
      if @filter_by_location.size > 1
        projects_options[:organization_region_id] = @filter_by_location.last
      else
        projects_options[:organization_country_id] = @filter_by_location.first
      end
    end
    @projects = Project.custom_find @site, projects_options
    @organizations = {}
    @projects.each do |pr|
      if @organizations.key?(pr['organization_id'])
        @organizations[pr['organization_id']][:count] += 1
      else
        @organizations[pr['organization_id']] = {:count => 1, :name => pr['organization_name'], :id => pr['organization_id'] }
      end
    end

    @organizations = @organizations.sort_by { |k, v| v[:name] }
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]

    ################### Pageless organizations ######################

      pageless_options = {
        :donor_id => @donor.id,
        :per_page => Project.all.size,
        :order => 'created_at DESC',
        :organization_filter => params[:organization_id],
        :category_id => params[:category_id]
      }
      if @filter_by_location.present?
        if @filter_by_location.size > 1
          pageless_options[:organization_region_id] = @filter_by_location.last
        else
          pageless_options[:organization_country_id] = @filter_by_location.first
        end
      end
      @projects_all = Project.custom_find @site, pageless_options
      @pageless_organizations= {}
      @projects_all.each do |pr|
        if @pageless_organizations.key?(pr['organization_id'])
          @pageless_organizations[pr['organization_id']][:count] += 1
        else
          @pageless_organizations[pr['organization_id']] = {:count => 1, :name => pr['organization_name'], :id => pr['organization_id'] }
        end
      end
      @pageless_organizations = @pageless_organizations.sort_by { |k, v| v[:name] }

    ################### Pageless organizations end ######################


    @map_data = []
    @organizations_data = []


    options_export = {
      :donor      => @donor.id,
      :per_page      => 10,
      :page          => params[:page],
      :order         => 'created_at DESC',
      :start_in_page => params[:start_in_page]
    }


    if params[:location_id]
      @projects_count = @projects.count
    elsif params[:category_id]
      @projects_count = @projects.total_entries
    else
      @projects_count = @donor.donated_projects_count(@site, params)
    end

    @donor_projects_clusters_sectors = @donor.projects_clusters_sectors(@site, @filter_by_location)

    @filter_name = ''

    if @filter_by_category
      @category_name =  "#{(@site.navigate_by_sector?? Sector : Cluster).where(:id => @filter_by_category).first.name}"
    end
    if @filter_by_category && @filter_by_location
      @category_name =  "#{(@site.navigate_by_sector?? Sector : Cluster).where(:id => @filter_by_category).first.name}"
      @location_name = if @filter_by_location.size == 1
        "#{Country.where(:id => @filter_by_location.first).first.name}"
      else
        region = Region.where(:id => @filter_by_location.last).first
        "#{region.country.name}/#{region.name}" rescue ''
      end
      @filter_name =  "#{@projects_count}  #{@category_name} projects in #{@location_name}"
    elsif @filter_by_location
      @location_name = if @filter_by_location.size == 1
        "#{Country.where(:id => @filter_by_location.first).first.name}"
      else
        region = Region.where(:id => @filter_by_location.last).first
        "#{region.country.name}/#{region.name}" rescue ''
      end
      @filter_name = "#{@projects_count} projects in #{@location_name}"
    # elsif @donor.filter_by_category_valid?
    #   @category_name = (@site.navigate_by_sector?? Sector : Cluster).where(:id => @filter_by_category).first.name
    #   @filter_name =  "#{@category_name} projects"
    elsif @filter_by_category
      @filter_name = "#{@projects_count} projects in " + (@site.navigate_by_sector?? Sector : Cluster).where(:id => @filter_by_category).first.name
    end

    if @filter_by_location.present?
      if @filter_by_location.size > 1
        options_export[:region] = @filter_by_location.last
        options_export[:region_category_id] = params[:category_id] if params[:category_id].present?
      else
        options_export[:country] = @filter_by_location.first
        options_export[:country_category_id] = params[:category_id] if params[:category_id].present?
      end
    end
    options_export[:organization] = params[:organization_id] if params[:organization_id].present?
    options_export[:category] = params[:category_id] if params[:category_id].present? && !@filter_by_location.present?
    options_export[:from_donors] = true

    if (@carry_on_filters.length == 0) || (@carry_on_filters.length == 1 && params[:location_id])
      location_url_param = '?location_id='
    else
      location_url_param = '&location_id='
    end

    #carry_on_url = donor_path(@donor, @carry_on_filters.merge(:location_id => ''))
    filters_for_url = @carry_on_filters.clone
    if params[:location_id]
      carry_on_url = donor_path(@donor, filters_for_url.except!(:location_id))
    else
      carry_on_url = donor_path(@donor, filters_for_url)
    end

    organization_location_condition = "AND p.primary_organization_id = #{params[:organization_id].sanitize_sql!.to_i}" if params[:organization_id]
    projects_organization_condition = "AND projects.primary_organization_id = #{params[:organization_id].sanitize_sql!.to_i}" if params[:organization_id]
    respond_to do |format|
      format.html do
        if @filter_by_category.present?
          if @site.navigate_by_cluster?
            category_join = "inner join clusters_projects as cp on cp.project_id = p.id and cp.cluster_id = #{@filter_by_category}"
            category_join = "inner join clusters_projects as cp on cp.project_id = projects.id and cp.cluster_id = #{@filter_by_category}"
          else
            projects_category_join = "inner join projects_sectors as pse on pse.project_id = p.id and pse.sector_id = #{@filter_by_category}"
            projects_category_join = "inner join projects_sectors as pse on pse.project_id = projects.id and pse.sector_id = #{@filter_by_category}"
          end
        end
        if @site.geographic_context_country_id
          location_filter = "and r.id = #{@filter_by_location.last}" if @filter_by_location
          sql = """ SELECT r.id, count(distinct projects_sites.project_id) as count,r.name,r.center_lon as lon,r.center_lat as lat,
                CASE WHEN count(distinct projects_sites.project_id) > 1 THEN
                    '#{carry_on_url}'|| '#{location_url_param}' || r.path
                ELSE
                    '/projects/'||(array_to_string(array_agg(distinct projects_sites.project_id),''))
                END as url
                ,r.code,
                (select count(*) from data_denormalization where regions_ids && ('{'||r.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
                FROM donations as dn JOIN projects ON dn.project_id = projects.id AND (projects.end_date IS NULL OR projects.end_date > NOW()) #{projects_organization_condition}
                JOIN projects_sites ON  projects_sites.project_id = projects.id
                JOIN projects_regions as pr ON pr.project_id = projects.id
                JOIN regions as r on r.id = pr.region_id and r.level=#{@site.level_for_region} #{location_filter}
                #{projects_category_join}
                WHERE projects_sites.site_id = #{@site.id} AND dn.donor_id = #{params[:id].sanitize_sql!.to_i}
                GROUP BY r.id, r.path, r.code, r.name, lon, lat """
        else
          if @filter_by_location
            sql = if @filter_by_location.size == 1
              <<-SQL
                SELECT r.id,
                  count(ps.project_id) AS count,
                  r.name,
                  r.center_lon AS lon,
                  r.center_lat AS lat,
                  CASE WHEN count(ps.project_id) > 1 THEN
                   '#{carry_on_url}' || '#{location_url_param}' || r.path
                  ELSE
                   '/projects/'||(array_to_string(array_agg(distinct ps.project_id),''))
                  END AS url,
                  r.code
                FROM projects_regions AS pr
                INNER JOIN projects_sites AS ps ON pr.project_id=ps.project_id AND ps.site_id=#{@site.id}
                INNER JOIN projects AS p ON pr.project_id=p.id AND (p.end_date is NULL OR p.end_date > now())
                INNER JOIN regions AS r ON pr.region_id=r.id AND r.level=#{@site.levels_for_region.min} AND r.country_id=#{@filter_by_location.first}
                INNER JOIN donations on donations.project_id = p.id
                #{category_join}
                WHERE donations.donor_id = #{params[:id].sanitize_sql!.to_i} #{organization_location_condition}
                GROUP BY r.id,r.name,lon,lat,r.name,r.path,r.code

                UNION
                SELECT c.id,
                count(distinct ps.project_id) AS count,
                  c.name as name,
                  c.center_lon AS lon,
                  c.center_lat AS lat,
                  null as url,
                  c.code
                FROM projects AS p
                INNER JOIN projects_sites AS ps ON ps.site_id=#{@site.id} and ps.project_id = p.id AND (p.end_date is NULL OR p.end_date > now())
                INNER JOIN donations on donations.project_id = p.id
                INNER JOIN countries as c ON c.id = #{params[:location_id]}
                INNER JOIN countries_projects as cp on cp.country_id = c.id AND cp.project_id = p.id
                #{category_join} #{organization_location_condition}
                WHERE donations.donor_id = #{params[:id].sanitize_sql!.to_i}
                GROUP BY c.id,c.name,lon,lat,c.code

              SQL
            else
                <<-SQL
                  SELECT r.id,
                         count(ps.project_id) AS count,
                         r.name,
                         r.center_lon AS lon,
                         r.center_lat AS lat,
                         r.name,
                         CASE WHEN count(ps.project_id) > 1 THEN
                           '#{carry_on_url}'|| '#{location_url_param}' || r.path
                         ELSE
                           '/projects/'||(array_to_string(array_agg(distinct ps.project_id),''))
                         END AS url,
                         r.code
                  FROM projects_regions AS pr
                  INNER JOIN projects_sites AS ps ON pr.project_id=ps.project_id AND ps.site_id=#{@site.id}
                  INNER JOIN projects AS p ON pr.project_id=p.id AND (p.end_date is NULL OR p.end_date > now())
                  INNER JOIN regions AS r ON pr.region_id=r.id AND r.level=#{@site.levels_for_region.min} AND r.country_id=#{@filter_by_location.shift} AND r.id IN (#{@filter_by_location.join(',')})
                  INNER JOIN donations on donations.project_id = p.id
                  #{category_join}
                  WHERE donations.donor_id = #{params[:id].sanitize_sql!.to_i} #{organization_location_condition}
                  GROUP BY r.id,r.name,lon,lat,r.name,r.path,r.code
                SQL
            end
          else
            sql="select c.id,count(distinct ps.project_id) as count,c.name,c.center_lon as lon,
                        c.center_lat as lat,c.name,
                        CASE WHEN count(distinct ps.project_id) > 1 THEN
                          '#{carry_on_url}' || '#{location_url_param}' || c.id
                        ELSE
                          '/projects/'||(array_to_string(array_agg(distinct ps.project_id),''))
                        END as url,
                        c.iso2_code as code,
                        (select count(*) from data_denormalization where countries_ids && ('{'||c.id||'}')::integer[] and (end_date is null OR end_date > now()) and site_id=#{@site.id}) as total_in_region
                  from ((((
                    projects as p inner join donations as dn on dn.project_id = p.id and dn.donor_id=#{params[:id].sanitize_sql!.to_i})
                    inner join projects_sites as ps on p.id=ps.project_id and ps.site_id=#{@site.id}) inner join countries_projects as cp on cp.project_id=p.id)
                    inner join projects as prj on ps.project_id=prj.id and (prj.end_date is null OR prj.end_date > now())
                    inner join countries as c on cp.country_id=c.id)
                    #{category_join}
                    #{organization_condition}
                  group by c.id,c.name,lon,lat,c.name,c.iso2_code"
          end
        end

        result=ActiveRecord::Base.connection.execute(sql)
        @count = result.count
        result.each do |r|
          if @count > 1 && params[:location_id]
            if r['code'].nil?
              @map_data << {:name => r['name'], :lon => r['lon'], :lat => r['lat'], :count => r['count'], :url => r['url'], :total_in_region => r['total_in_region']}
            end
          else
              @map_data << {:name => r['name'], :lon => r['lon'], :lat => r['lat'], :count => r['count'], :url => r['url'], :total_in_region => r['total_in_region']}
          end
        end
        @contact_data = {:name => @donor.contact_person_name, :position => @donor.contact_person_position, :email => @donor.contact_email, :phone_number => @donor.contact_phone_number,
          :show => (@donor.contact_person_name.present?   || @donor.contact_email.present?  || @donor.contact_phone_number.present?  )? true : false }

        @map_data_max_count = 0
        @map_data.each do |md|
          @map_data_max_count = md[:count].to_i if @map_data_max_count < md[:count].to_i
        end
        @map_data = @map_data.to_json
      end
      format.js do
        render :update do |page|
          page << "$('#projects_view_more').html('#{escape_javascript(render(:partial => 'donors/pagination'))}');"
          page << "$('#projects').append('#{escape_javascript(render(:partial => 'donors/projects'))}');"
          page << "IOM.ajax_pagination();"
          page << "resizeColumn();"
        end
      end
      format.csv do
        send_data Project.to_csv(@site, options_export),
          :type => 'text/plain; charset=utf-8; application/download',
          :disposition => "attachment; filename=#{@donor.name.gsub(/[^0-9A-Za-z]/, '')}_projects.csv"
      end
      format.xls do
        send_data Project.to_excel(@site, options_export),
          :type        => 'application/vnd.ms-excel',
          :disposition => "attachment; filename=#{@donor.name.gsub(/[^0-9A-Za-z]/, '')}_projects.xls"
      end
      format.kml do
        @projects_for_kml = Project.to_kml(@site, options_export)
      end
    end
  end

end
