module Api
  module V1
    class DonorsController < ApiController
      def index
        @donors = Donor.active.order(:name)
        render json: @donors, root: 'data',
        meta: { total: @donors.size },
        each_serializer: DonorPreviewSerializer
      end
      def show
        @donor = Donor.find(params[:id])
        render json: @donor, include: ['donated_projects', 'offices']
      end
    end
  end
end
