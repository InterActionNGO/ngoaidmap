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
        params.permit(:offset, :limit, :format, :status, :geolocation, :level, organizations:[], sectors:[], donors:[], countries:[])
      end
    end
  end
end
