module Api
  module V1
    class ProjectsController < ApiController
      before_action :set_digests, only: 'index'
      before_action :unscoped_count, only: 'index'
      def index
        respond_to do |format|
          format.json {
            @projects = Project.fetch_all(projects_params)
            render json: @projects, root: 'data', include: ['organization', 'sectors', 'donors']
          }
          format.xml {
            if projects = $redis.get(@iati_projects_digest)
              render text: projects and return
            else
              expire_time = ((Time.now + 1.day).beginning_of_day - Time.now).ceil
              @projects = Project.fetch_all(projects_params)
              @projects_size = @projects.size
              projects_xml = render_to_string(:template => 'api/v1/projects/index.xml.erb', :layout => false) do
                @projects
              end
              $redis.set(@iati_projects_digest, projects_xml)
              $redis.expire @iati_projects_digest, expire_time
              @projects
            end
          }
        end
      end

      def show
        @project = Project.find(params[:id])
        respond_to do |format|
          format.json {render json: @project, root: 'data', include: ['organization', 'sectors', 'donors']}
          format.xml {@project}
        end
      end


      def projects_params
        if (request.fullpath.include?('iati') && !request.fullpath.include?('organizations')) && ((!params[:limit].present? && !params[:organizations].present? && !params[:sectors].present? && !params[:donors].present? && !params[:countries].present?) or params[:limit].to_i > 100)
          params.merge!(limit: '100')
        end
        if request.fullpath.include?('organizations') && params[:organization_id].present?
          params.merge!(organizations: [params[:organization_id]])
        end
        params.permit(:offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[])
      end

      def set_digests
        timestamp = Project.fetch_all(projects_params).order('projects.updated_at desc').first.updated_at.to_s
        string = timestamp + projects_params.inspect
        @iati_projects_digest = "iati_projects_#{Digest::SHA1.hexdigest(string)}"
      end

      def unscoped_count
        if request.format == 'xml' && !$redis.get(@iati_projects_digest)
          no_limit_params = projects_params.dup
          no_limit_params.delete(:offset)
          no_limit_params.delete(:limit)
          @total_projects = Project.fetch_all(no_limit_params).size
        end
      end
    end
  end
end
