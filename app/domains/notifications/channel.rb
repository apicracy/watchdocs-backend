module Notifications
  class Channel < ApplicationRecord
    belongs_to :notificable, polymorphic: true, optional: true

    enum provider: [:slack, :push_notification]
  end
end
