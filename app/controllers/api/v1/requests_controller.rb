module Api
  module V1
    class RequestsController < ApplicationController
      before_action :authenticate_user!

      def show
        request = endpoint.request
        raise ActiveRecord::RecordNotFound unless request
        authorize! :read, request
        render json: request
      end

      def update
        request = endpoint.request
        authorize! :update, request
        request.update(body: body_schema_params, body_draft: nil)
        render_resource(request)
      end

      private

      def endpoint
        Endpoint.find(params[:endpoint_id])
      end

      def body_schema_params
        JSON.parse(params[:body])
      rescue JSON::ParserError => _exception
        nil
      end
    end
  end
end
