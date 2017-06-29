module Notifications
  class SlackController < ApplicationController
    before_action :authenticate_user!
    skip_authorization_check only: [:connect]
    respond_to :json

    def connect
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

    def deactivate
      @channel = Channel.slack.first
      authorize! :update, @channel
      @channel.update(active: false)
      render_resource(@channel)
    end
  end
end
