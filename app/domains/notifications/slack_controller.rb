module Notifications
  class SlackController < ApplicationController
    before_action :authenticate_user!
    skip_authorization_check
    respond_to :json

    def callback
      ConnectSlack.new(user: current_user, code: params[:code]).call
      render :ok
    rescue SlackConnectError => e
      render json: {
        errors: [
          {
            status: '400',
            title: 'Bad Request',
            detail: e.message
          }
        ]
      }, status: :bad_request
    end
  end
end
