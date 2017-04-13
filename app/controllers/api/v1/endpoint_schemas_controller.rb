module Api
  module V1
    class EndpointSchemasController < ApplicationController
      include ActionController::HttpAuthentication::Basic::ControllerMethods
      http_basic_authenticate_with name: ENV['HTTP_AUTH_NAME'],
                                   password: ENV['HTTP_AUTH_PASSWORD']

      def create
        ProcessExternalEndpointSchemas.new(endpoint_schema_params).call
        render :ok
      rescue ProjectNotFound => exception
        record_not_found(exception)
      end

      private

      def endpoint_schema_params
        @params ||= ActiveModelSerializers::Deserialization.jsonapi_parse(
          params,
          only: [
            :project_id,
            :endpoint,
            :request,
            :response
          ],
          key_transform: :unaltered
        )
      end
    end
  end
end
