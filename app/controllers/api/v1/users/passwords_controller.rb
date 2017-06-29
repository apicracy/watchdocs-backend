module Api
  module V1
    module Users
      class PasswordsController < ApplicationController
        skip_authorization_check

        def update
          user = ResetPassword.new(update_password_params).call
          render_resource(user, no_content: true)
        end

        private

        def update_password_params
          params.permit(:password, :password_confirmation, :token)
        end
      end
    end
  end
end
