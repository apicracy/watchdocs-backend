module Api
  module V1
    class UrlParamsController < ApplicationController
      before_action :authenticate_user!

      def create
        @url_param = UrlParam.new(url_param_params.merge(status: :up_to_date))
        authorize! :create, @url_param
        if @url_param.save
          render json: @url_param
        else
          record_error(@url_param)
        end
      end

      private

      # HueHue :)
      def url_param_params
        params.permit(:endpoint_id, :description, :is_part_of_url, :data_type, :name, :example)
      end
    end
  end
end
