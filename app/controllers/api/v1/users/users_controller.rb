module Api
  module V1
    module Users
      class UsersController < ApplicationController
        before_action :authenticate_user!

        def me
          render json: current_user
        end
      end
    end
  end
end
