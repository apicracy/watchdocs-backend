module Api
  module V1
    class EndpointsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def show
        render json: @endpoint
      end

      def create
        endpoint = Endpoint.new(endpoint_params)
        authorize! :create, endpoint
        endpoint.save
        render_resource(endpoint)
      end

      private

      def endpoint_params
        params.permit(
          :project_id,
          :group_id,
          :url,
          :http_method,
          :title,
          :summary
        )
      end
    end
  end
end
