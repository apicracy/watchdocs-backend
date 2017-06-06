module Notifications
  class DomainEventHandler
    def self.endpoint_broken(_endpoint_id)
      # Some endpoint has been broken
      # A place for service of each provider
      # NotifySlack.new.call
    end

    # etc...
  end
end
