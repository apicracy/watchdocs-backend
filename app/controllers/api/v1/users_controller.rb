module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!

      def me
        authorize! :read, current_user
        render json: current_user
      end
    end
  end
end
