module Api
  module V1
    class ProjectsController < ApiController
      def index
        @projects = Project.fetch_all(projects_params)
        respond_to do |format|
         format.json {render json: @projects, root: 'data', include: ['organization', 'sectors', 'donors']}
         format.xml {@projects}
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
        if request.fullpath.include?('iati') && (!params[:limit] or params[:limit].to_i > 100)
          params.merge!(limit: '10')
        end
        params.permit(:offset, :limit, :format, :status, :geolocation, :starting_after, :ending_before, :q, :level, organizations:[], sectors:[], donors:[], countries:[])
      end
    end
  end
end
