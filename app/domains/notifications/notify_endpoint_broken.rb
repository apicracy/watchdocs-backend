module Notifications
  class NotifyEndpointBroken
    attr_reader :channels, :endpoint_id

    def initialize(project_id, endpoint_id)
      users        = Projects::FetchUsers.new.call(project_id)
      @channels    = Channel.where(user_id: users.select(:id))
      @endpoint_id = endpoint_id
    end

    def call
      message = "Endpoint id: #{endpoint_id} has been broken."
      SendPushNotification.new(channels: channels, message: message).call
      # Other providers...
    end
  end
end
