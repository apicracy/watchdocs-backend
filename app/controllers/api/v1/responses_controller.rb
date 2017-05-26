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

      def update
        OverrideDraft.new(@response, update_response_params).call
        render_resource(@response)
      end

      def destroy
        @response.destroy
        render json: @response
      end

      private

      def create_response_params
        params.permit(
          :endpoint_id,
          :http_status_code
        ).merge(status: :up_to_date)
      end

      def update_response_params
        permitted = params.permit(:http_status_code)
        return permitted unless params[:body]
        permitted.merge(body: parsed_body_schema)
      end

      # This logic should be moved to before validate callback
      def parsed_body_schema
        JSON.parse(params[:body])
      rescue JSON::ParserError => _exception
        nil
      end
    end
  end
end
