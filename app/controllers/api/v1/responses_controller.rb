module Api
  module V1
    class ResponsesController < ApplicationController
      before_action :authenticate_user!
      load_and_authorize_resource

      def show
        render json: @response
      end
    end
  end
end
