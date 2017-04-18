module Api
  module V1
    class RequestsController < ApplicationController
      before_action :authenticate_user!

      def show
        @request = endpoint.request
        authorize! :read, @request
        render json: @request
      end

      private

      def endpoint
        Endpoint.find(params[:endpoint_id])
      end
    end
  end
end
