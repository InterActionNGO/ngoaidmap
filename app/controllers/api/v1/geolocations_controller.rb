module Api
  module V1
    class GeolocationsController < ApiController
      def index
        @geolocations = Geolocation.all
        @geolocations = @geolocations.offset(geolocations_params[:offset]) if geolocations_params[:offset]
        @geolocations = @geolocations.limit(geolocations_params[:limit]) if geolocations_params[:limit]
        @geolocations = @geolocations.order(geolocations_params[:order]) if geolocations_params[:order]
        puts @geolocations.to_json
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
        params.delete(:order) if params[:order] && !['name', 'id', 'uid', 'country_name'].include?(params[:order])
        params.permit(:id, :get_parents, :offset, :limit, :format, :order)
      end
    end
  end
end