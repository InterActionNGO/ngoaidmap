module Api
  module V1
    require 'digest/sha1'
    class ProjectsController < ApiController
      def index
        @projects = Project.fetch_all(projects_params)
        timestamp = @projects.order('projects.updated_at desc').first.try('projects.updated_at').to_s
        string = timestamp + projects_params.inspect
        digest = Digest::SHA1.hexdigest(string)
        m = ActiveModel::Serializer::ArraySerializer.new(@projects, each_serializer: ProjectSerializer)
        @map_data = Rails.cache.fetch("map_data_projects_#{digest}", :expires_in => 24.hours) {ActiveModel::Serializer::Adapter::JsonApi.new(m, include: ['organization', 'sectors', 'donors', 'geolocations']).to_json}
        respond_to do |format|
         format.json {render json: @map_data}
         format.xml {@projects}
        end
      end

      def show
        @project = Project.find(params[:id])
        respond_to do |format|
          format.json {render json: @project, root: 'data', include: ['organization', 'sectors', 'donors', 'countries', 'regions']}
          format.xml {@project}
        end
      end


      def projects_params
        params.permit(:offset, :limit, :format, :geolocation, :level, organizations:[], sectors:[], donors:[], countries:[])
      end
    end
  end
end
