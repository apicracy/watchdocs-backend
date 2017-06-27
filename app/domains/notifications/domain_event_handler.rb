module Notifications
  class DomainEventHandler
    def self.endpoint_broken(project_id, endpoint_id)
      NotifyEventBroken.new(project_id, endpoint_id).call
    end

    # etc...
  end
end
