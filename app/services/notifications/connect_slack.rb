require 'slack'
module Notifications
  class ConnectSlack
    def initialize(user:, code:)
      @user = user
      @code = code
    end

    def call
      if Notifications::Channel.where(user_id: @user).slack.exists?
        raise SlackConnectError, 'User already has conneced account'
      end
      response = authorize_slack
      connect_slack_account(response)
    end

    private

    def authorize_slack
      client = Slack::Client.new
      client.oauth_access(
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: @code,
        redirect_uri: ENV['SLACK_REDIRECT_URL']
      )
    end

    def connect_slack_account(response)
      raise SlackConnectError, "Slack Error: #{response['error']}" unless response['ok'] == true
      Notifications::SlackChannel.create(
        access_token: response['access_token'],
        webhook_url: response['incoming_webhook']['url'],
        channel_attributes: {user_id: @user.id, provider: 'slack'}
      )
    end
  end
end
