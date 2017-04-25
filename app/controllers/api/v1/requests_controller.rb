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
        @request = endpoint.request
        authorize! :update, @request
        if @request.update(body: body_schema_params)
          render json: @request
        else
          record_error(@request)
        end
      end

      private

      def endpoint
        Endpoint.find(params[:endpoint_id])
      end

      def body_schema_params
        # Require all json under body
        params.require(:body).permit!
      end
    end
  end
end
