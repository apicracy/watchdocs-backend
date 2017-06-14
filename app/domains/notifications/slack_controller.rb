module Notifications
  class SlackController < ApplicationController
    skip_authorization_check
    respond_to :json

    def callback
      if SlackConnect.new(user: current_user || User.last, code: params[:code]).call
        render :ok
      else
        render json: {
          errors: [
            {
              status: '400',
              title: 'Bad Request',
            }
          ]
        }, status: :bad_request
      end
    end
  end
end
