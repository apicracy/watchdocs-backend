module Api
  module V1
    class RequestsController < ApplicationController
      before_action :authenticate_user!

      def show
        @request = endpoint.request
        authorize! :read, @request
        render json: @request
      end

      def update
        if @request.update(request_params)
          render json: @request
        else
          record_error(@request)
        end
      end

      private

      def endpoint
        Endpoint.find(params[:endpoint_id])
      end

      def request_params
        params.permit(:body)
      end
    end
  end
end
