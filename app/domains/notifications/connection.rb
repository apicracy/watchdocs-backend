module Notifications
  class Connection < ActionCable::Connection::Base
    def subscribed
      stream_from 'notifications'
    end
  end
end
