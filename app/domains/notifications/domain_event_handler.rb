module Notifications
  class DomainEventHandler
    def self.endpoint_outdated(project_id, endpoint_id)
      NotifyEndpointOutdated.new(project_id, endpoint_id).call
    end

    # etc...
  end
end
