module Api
  module V1
    class UrlParamsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource except: [:create]

      def create
        url_param = UrlParam.new(url_param_create.merge(status: :up_to_date))
        authorize! :create, url_param
        url_param.save
        render_resource(url_param)
      end

      def update
        @url_param.update(url_param_update)
        render_resource(@url_param)
      end

      def destroy
        @url_param.destroy
        render json: @url_param
      end

      private

      def url_param_create
        params.permit(
          :endpoint_id,
          :description,
          :is_part_of_url,
          :data_type,
          :name,
          :example,
          :required
        )
      end

      def url_param_update
        params.permit(
          :description,
          :is_part_of_url,
          :data_type,
          :name,
          :example,
          :required
        ).merge(required_draft: nil)
      end
    end
  end
end
