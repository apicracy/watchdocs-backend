module Notifications
  class Channel < ApplicationRecord
    belongs_to :notificable, polymorphic: true, optional: true

    enum provider: [:push_notification]
  end
end
