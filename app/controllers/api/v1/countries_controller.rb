module Api
  module V1
    class CountriesController < ApiController
      def index
        if countries_params && countries_params[:summing] == 'projects'
          @countries = Geolocation.sum_projects(countries_params[:status])
          render json: @countries, root: 'data',
          meta: { total: @countries.size },
          each_serializer: CountriesSummingSerializer
        else
          @countries = Geolocation.where(adm_level: 0).order(:name).uniq
          render json: @countries, root: 'data',
          meta: { total: @countries.size },
          each_serializer: GeolocationPreviewSerializer
        end
      end
      def show
        @country = Geolocation.find_by(uid: params[:id], adm_level: 0)
          render json: @country, root: 'data',
          serializer: GeolocationPreviewSerializer
      end
      def countries_params
        params.permit(:id, :summing, :status)
      end
    end
  end
end