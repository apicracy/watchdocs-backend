module Notifications
  class SendSlackNotification
    attr_reader :client, :channels, :message

    def initialize(channels:, message:)
      @channels = channels
      @message  = message
    end

    def call
      @channels.find_each do |channel|
        send_notification(channel)
      end
    end

    private

    def send_notification(channel)
      conn = Faraday.new(url: channel.notificable.webhook_url)
      conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = { text: @message }.to_json
      end
    end
  end
end
