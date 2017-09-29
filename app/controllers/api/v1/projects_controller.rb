module Api
  module V1
    class ProjectsController < ApiController
      helper IatiActivityHelper
      before_action :set_digests, only: 'index'
      before_action :unscoped_count, only: 'index'
      def index
        respond_to do |format|
          format.json {
            @projects = Project.fetch_all(projects_params).order(:id)
            render json: @projects,
                meta: {
                    records_available: @total_projects,
                    records_returned: @projects.count,
                    current_offset: projects_params[:offset].to_i
                },
                include: [:donors, :prime_awardee, :geolocations, :sectors, :tags, :reporting_organization, :identifiers]
          }
          format.xml {
            if projects = $redis.get(@iati_projects_digest)
              if params[:download]=='true'
                send_data projects, filename: "iati_#{Time.now.in_time_zone}.xml", :type => 'text/xml; charset=utf-8'  and return
              else
                render text: projects and return
              end
            else
              expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
              @projects = Project.fetch_all(projects_params).order(:id)
              @reported_by_member = params[:reported_by_member] == 'true' ? true : false
              projects_xml = render_to_string(:template => 'api/v1/projects/index.xml.builder') do
                @projects
              end
              $redis.set(@iati_projects_digest, projects_xml)
              $redis.expire @iati_projects_digest, expire_time
              if params[:download]=='true'
                send_data projects_xml, filename: "iati_#{Time.now.in_time_zone}.xml", :type => 'text/xml; charset=utf-8'  and return
              else
                @projects
              end
            end
          }
        end
      end

      def show
        @project = Project.find(params[:id])
        respond_to do |format|
          format.json {
              render json: @project,
                include: [:donors, :prime_awardee, :geolocations, :sectors, :tags, :reporting_organization, :identifiers]
          }
          format.xml {@project}
        end
      end


      def projects_params
        # Limit all requests to 100 results, except for iati xml  
        params.merge!(limit: '100') unless params[:format].eql?('xml') && request.fullpath.include?('organizations')
        
        if request.fullpath.include?('organizations') && params[:organization_id].present?
          params.merge!(organizations: [params[:organization_id]])
        end
        params.permit(:site, :offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, :updated_since, :reported_by_member, organizations:[], sectors:[], donors:[], countries:[], tags:[])
      end

      def set_digests
        if params[:format].eql?('xml')
            begin
            timestamp = Project.fetch_all(projects_params).order('projects.updated_at desc').first.updated_at.to_s
            string = timestamp + projects_params.inspect
            @iati_projects_digest = "iati_projects_#{Digest::SHA1.hexdigest(string)}"
            rescue Exception => e
            string = '0' + projects_params.inspect
            @iati_projects_digest = "iati_projects_#{Digest::SHA1.hexdigest(string)}"
            end
        end
      end

      def unscoped_count
        if (request.format == 'xml' && !$redis.get(@iati_projects_digest)) || request.format == 'json'
          no_limit_params = projects_params.dup
          no_limit_params.delete(:offset)
          no_limit_params.delete(:limit)
          @total_projects = Project.fetch_all(no_limit_params).size
        end
      end
    end
  end
end
