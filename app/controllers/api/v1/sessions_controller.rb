module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      private

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end
