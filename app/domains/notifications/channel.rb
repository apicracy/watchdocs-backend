module Notifications
  class Channel < ApplicationRecord
    belongs_to :notificable, polymorphic: true, optional: true

    enum provider: [:slack]

    def notify
      notificable.notify("Hello Channel! - :heart:")
    end
  end
end
