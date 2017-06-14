module Notifications
  class Channel < ApplicationRecord
    belongs_to :notificable, polymorphic: true, optional: true

    enum provider: [:slack]

    def notify
      notificable.notify("Hello, Slack! - :heart:")
    end
  end
end
