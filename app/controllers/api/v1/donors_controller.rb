module Api
  module V1
    class DonorsController < ApiController
      def index
        @donors = Organization.fetch_all_donors(donor_params)
        render json: @donors, root: 'data',
        meta: { total: @donors.size },
        each_serializer: OrganizationPreviewSerializer
      end
      def show
        @donor = Organization.with_donations.find(params[:id])
        render json: @donor, include: ['all_donated_projects', 'offices']
      end

      def donor_params
        params.permit(:offset, :limit, :geolocation, :status, sectors:[])
      end
    end
  end
end
