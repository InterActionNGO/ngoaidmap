module Api
  module V1
    class GeolocationsController < ApiController
      def index
        @geolocations = Geolocation.offset(geolocations_params[:offset]).limit(geolocations_params[:limit]).order(geolocations_params[:order]).uniq
        render json: @geolocations, root: 'data',
        meta: { total: @geolocations.size },
        each_serializer: GeolocationPreviewSerializer
      end
      def show
        @geolocation = Geolocation.find_by(uid: params[:id])
        if geolocations_params && geolocations_params[:get_parents] == 'true'
          geolocation = Geolocation.find_by(uid: params[:id])
          gs = [@geolocation.g0, @geolocation.g1, @geolocation.g2, @geolocation.g3, @geolocation.g4].reject!(&:blank?)
          @geolocations = Geolocation.where(uid: gs).where.not(id: @geolocation.id).order('adm_level ASC')
          render json: @geolocation,
          serializer: GeolocationPreviewSerializer,
          meta: {parents: @geolocations.select(:id, :uid, :name, :adm_level)}
        else
          render json: @geolocation,
          serializer: GeolocationPreviewSerializer
        end
      end
      def geolocations_params
        params.reject!(:order) if params[:order] && !['name', 'id', 'uid', 'country_name'].include?(params[:order])
        params.permit(:id, :get_parents, :offset, :limit, :format, :order)
      end
    end
  end
end