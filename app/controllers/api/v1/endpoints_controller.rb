module Api
  module V1
    class EndpointsController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource

      def show
        render json: @endpoint
      end
    end
  end
end
