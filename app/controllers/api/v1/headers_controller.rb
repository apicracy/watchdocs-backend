module Api
  module V1
    class HeadersController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def create
        header = UrlParam.new(create_header_params)
        authorize! :create, header
        header.save
        render_resource(header)
      end

      private

      def create_header_params
        params.permit(
          :headerable_id,
          :headerable_type,
          :key,
          :description,
          :example_value,
          :required
        ).merge(status: :up_to_date)
      end
    end
  end
end
