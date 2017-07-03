module Api
  module V1
    module Users
      class ResetPasswordTokensController < ApplicationController
        skip_authorization_check

        def create
          CreateResetPasswordToken.new(params[:email]).call
          head :no_content
        end
      end
    end
  end
end
