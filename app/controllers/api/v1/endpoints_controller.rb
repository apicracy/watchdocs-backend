module Api
  module V1
    class EndpointsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def show
        render json: @endpoint
      end

      def create
        endpoint_creator = CreateEndpoint.new(create_endpoint_params)
        authorize! :create, endpoint_creator.endpoint
        endpoint = endpoint_creator.call
        render_resource(endpoint)
      end

      def update
        @endpoint.update(update_endpoint_params)
        render_resource(@endpoint)
      end

      def destroy
        @endpoint.destroy
        render json: @endpoint
      end

      private

      def create_endpoint_params
        params.permit(
          :project_id,
          :group_id,
          :url,
          :http_method,
          :title,
          :summary
        ).merge(status: :up_to_date)
      end

      def update_endpoint_params
        params.permit(
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
