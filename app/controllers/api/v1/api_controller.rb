module Api
  module V1
    class ApiController < ApplicationController
      skip_before_action :set_site
      skip_before_action :get_menu_items
      rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

      private
      def record_not_found
        render json: {errors: [{ status: '404', title: 'Record not found' }] } ,  status: 404
      end
    end
  end
end