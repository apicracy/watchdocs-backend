module Notifications
  class SlackNotifier < ApplicationRecord
    has_one :channel, as: :notificable
    accepts_nested_attributes_for :channel

    validates :access_token, presence: true
    validates :webhook_url, presence: true

    def notify(message)
      conn = Faraday.new(url: webhook_url)
      conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = { text: message }.to_json
      end
    end
  end
end
