module Api
  module V1
    class ProjectsController < ApiController
      def index
        @projects = Project.fetch_all(project_params)
        render json: @projects, root: 'data', meta: {total: @projects.size}, include: ['organization', 'sectors', 'donors', 'countries', 'regions']
      end

      def show
        @project = Project.find(params[:id])
        respond_to do |format|
          format.json {render json: @project, root: 'data', include: ['organization', 'sectors', 'donors', 'countries', 'regions']}
          format.xml {@project}
        end
      end


      def project_params
        params.permit(:format, organizations:[], sectors:[], donors:[], countries:[], regions:[])
      end
    end
  end
end
