require 'httparty'

module Notifications
  class SendPushNotification
    attr_reader :client, :channels, :message, :success

    def initialize(channels:, message:)
      @channels = channels
      @message  = message
      @client   = OneSignal::Client.new(
        auth_token: ENV['ONESIGNAL_REST_API_KEY'],
        app_id:     ENV['ONESIGNAL_APP_ID']
      )
    end

    def call
      # Base on API documentation we can notify up to 2k players in single request
      filtered_channels.find_in_batches(batch_size: 2000) do |credentials|
        send_notifications_to(credentials.map(&:player_id))
      end
      success!
    rescue OneSignal::RequestError => e
      fail!
      JSON.parse(e.http_body)
    end

    def success?
      success
    end

    private

    def filtered_channels
      subquery = channels.push_notification.select(:notificable_id)
      ::Notifications::PushNotificationsCredential.where(id: subquery)
    end

    def send_notifications_to(players = [])
      client.notifications.create(params(players))
    end

    def params(players = [])
      {
        include_player_ids: players,
        contents: { en: message }
      }
    end

    def success!
      @success = true
    end

    def fail!
      @success = false
    end
  end
end
