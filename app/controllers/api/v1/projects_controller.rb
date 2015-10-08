module Api
  module V1
    class ProjectsController < ApiController
      def index
        @projects = Project.fetch_all(projects_params)
        respond_to do |format|
          format.json {render json: @projects, root: 'data', include: ['organization', 'sectors', 'donors']}
          format.xml {
            no_limit_params = projects_params.dup
            no_limit_params.delete(:offset)
            no_limit_params.delete(:limit)
            @total_projects = Project.fetch_all(no_limit_params).size
            @projects
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
        if request.fullpath.include?('iati') && ((!params[:limit].present? && !params[:organizations].present? && !params[:sectors].present? && !params[:donors].present? && !params[:countries].present?) or params[:limit].to_i > 100)
          params.merge!(limit: '100')
        end
        params.permit(:offset, :limit, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[])
      end
    end
  end
end
