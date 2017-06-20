module Notifications
  class Channel < ActionCable::Channel::Base
    def subscribed
      stream_from 'notifications'
    end
  end
end
