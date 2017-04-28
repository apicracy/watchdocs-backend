module Api
  module V1
    class HeadersController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def create
        header = Header.new(create_header_params)
        authorize! :create, header
        header.save
        render_resource(header)
      end

      def update
        @header.update(update_header_params)
        render_resource(@header)
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

      def update_header_params
        params.permit(
          :key,
          :description,
          :example_value,
          :required,
          :required_draft
        )
      end
    end
  end
end
