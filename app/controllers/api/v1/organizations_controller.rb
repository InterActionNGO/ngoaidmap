module Api
  module V1
    class OrganizationsController < ApiController
      def index
        @organizations = Organization.fetch_all(organizations_params).uniq.order(:name)
        render json: @organizations, root: 'data',
        meta: { total: @organizations.size },
        each_serializer: OrganizationPreviewSerializer
      end
      def show
        @organization = Organization.eager_load([projects:[:donors, :sectors, :geolocations]]).find(params[:id])
        render json: @organization, root: 'data', include: ['projects']
      end
      def organizations_params
        params.permit(:status, :site, :geolocation, organizations:[], sectors:[], donors:[], countries:[])
      end
    end
  end
end