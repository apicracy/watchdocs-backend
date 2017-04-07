module Api
  module V1
    class EndpointSchemasController < ApplicationController
      def create
        ProcessExternalEndpointSchemas.new(endpoint_schema_params).call
        render :ok
      rescue ProjectNotFound => e
        record_not_found(e)
      end

      private

      def endpoint_schema_params
        @params ||= ActiveModelSerializers::Deserialization.jsonapi_parse(
          params,
          only: [
            :project_id,
            :endpoint,
            :method,
            :status,
            :request,
            :response,
            :query_string_params,
            :response_headers,
            :request_headers
          ],
          key_transform: :unaltered
        )
      end
    end
  end
end
