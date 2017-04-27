module Api
  module V1
    class ResponsesController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource

      def show
        render json: @response
      end

      def update
        @response.update(update_response_params)
        render_resource(@response)
      end

      private

      def update_response_params
        params.permit(
          :body,
          :http_status_code
        )
      end
    end
  end
end
