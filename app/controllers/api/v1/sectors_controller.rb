module Api
  module V1
    class SectorsController < ApiController
      def index
        @sectors = Sector.order(:name)
        render json: @sectors, root: 'data',
        meta: { total: @sectors.size },
        each_serializer: SectorPreviewSerializer
      end
      def show
        @caller = "sectors"
        @sector = Sector.eager_load([projects:[:donors, :primary_organization, :countries, :regions]]).find(params[:id])
        render json: @sector, root: 'data', include: ['projects']
      end
    end
  end
end