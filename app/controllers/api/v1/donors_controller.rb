module Api
  module V1
    class DonorsController < ApiController
      def show
        @donor = Donor.find(params[:id])
        render json: @donor, include: ['donated_projects', 'offices']
      end
    end
  end
end
