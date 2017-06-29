module Notifications
  class PushNotificationsCredential < ApplicationRecord
    has_one :channel, as: :notificable
    accepts_nested_attributes_for :channel

    validates :player_id, presence: true
  end
end
