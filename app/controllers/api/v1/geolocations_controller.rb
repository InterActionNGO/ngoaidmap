module Api
  module V1
    class GeolocationsController < ApiController
      def index
        if geolocations_params && geolocations_params[:get_hierarchy] == 'true'
          @countries = Geolocation.sum_projects
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
        @geolocation = Geolocation.find(params[:id])
        if geolocations_params && geolocations_params[:get_hierarchy] == 'true'
          geolocation = Geolocation.find(params[:id])
          gs = [@geolocation.g0, @geolocation.g1, @geolocation.g2, @geolocation.g3, @geolocation.g4].reject!(&:blank?)
          @geolocations = Geolocation.where(uid: gs).where.not(id: @geolocation.id).order('adm_level ASC')
          render json: @geolocation,
          serializer: GeolocationPreviewSerializer,
          meta: @geolocations.select(:id, :uid, :name, :adm_level)
        else
          render json: @geolocation,
          serializer: GeolocationPreviewSerializer
        end
      end
      def geolocations_params
        params.permit(:id, :get_hierarchy)
      end
    end
  end
end