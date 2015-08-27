module Api
  module V1
    class DonorsController < ApiController
      def index
        @donors = Donor.fetch_all(donor_params)
        render json: @donors, root: 'data',
        meta: { total: @donors.size },
        each_serializer: DonorPreviewSerializer
      end
      def show
        @donor = Donor.find(params[:id])
        render json: @donor, include: ['donated_projects', 'offices']
      end

      def donor_params
        params.permit(:offset, :limit, sectors:[])
      end
    end
  end
end
