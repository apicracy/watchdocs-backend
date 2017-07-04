module Notifications
  class SlackCredential < ApplicationRecord
    has_one :channel, as: :notificable
    accepts_nested_attributes_for :channel

    validates :access_token, presence: true
    validates :webhook_url, presence: true
  end
end
