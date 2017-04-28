module Api
  module V1
    class ResponsesController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def show
        render json: @response
      end

      def create
        response = Response.new(create_response_params)
        authorize! :create, response
        response.save
        render_resource(response)
      end

      private

      def create_response_params
        params.permit(
          :endpoint_id,
          :http_status_code
        ).merge(status: :up_to_date)
      end
    end
  end
end
