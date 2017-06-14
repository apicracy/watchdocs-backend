require 'slack'
module Notifications
  class SlackConnect
    def initialize(user:, code:)
      @user = user
      @code = code
    end

    def call
      return false if Notifications::Channel.where(user_id: @user).slack.exists?
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
      return false unless response['ok'] == true
      Notifications::SlackChannel.create(
        access_token: response['access_token'],
        webhook_url: response['incoming_webhook']['url'],
        channel_attributes: {user_id: @user.id, provider: 'slack'}
      )
    end
  end
end
