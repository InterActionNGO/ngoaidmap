module Api
  module V1
    class SectorsController < ApiController
      def index
        if params[:include].present? && params[:include] == 'projects_count'
          @sectors = Sector.counting_projects
          @sectors_hash = normalize @sectors
          render json: @sectors_hash, root: 'data',
          meta: { total: @sectors.size },
          each_serializer: SectorWithProjectsCountSerializer
        else
          @sectors = Sector.order(:name)
          render json: @sectors, root: 'data',
          meta: { total: @sectors.size },
          each_serializer: SectorPreviewSerializer
        end
      end
      def show
        @caller = "sectors"
        @sector = Sector.eager_load([projects:[:donors, :primary_organization, :countries, :regions]]).find(params[:id])
        render json: @sector, root: 'data', include: ['projects']
      end

      private
      def normalize(h)
        normalized_hash = []
        h.each do |k,v|
          normalized_hash.push(({id: k[0], name: k[1], projects_count: v}))
        end
        normalized_hash
      end
    end
  end
end