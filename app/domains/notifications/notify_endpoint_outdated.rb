module Notifications
  class NotifyEndpointOutdated
    attr_reader :channels, :endpoint, :project

    def initialize(project_id, endpoint_id)
      users        = Projects::FetchUsers.new.call(project_id)
      @channels    = Channel.where(user_id: users.select(:id))
      @endpoint = ::Endpoint.find(endpoint_id)
      @project = ::Project.find(project_id)
    end

    def call
      message = "Endpoint #{endpoint_name} is outdated"
      SendPushNotification.new(channels: channels.push_notification, message: message).call
      SendSlackNotification.new(channels: channels.slack, message: slack_message).call
      # Other providers...
    end

    private

    def slack_message
      "*#{project.name}*: #{endpoint_name} is outdated. Go to #{endpoint_path} to review changes."
    end

    def endpoint_name
      "[#{endpoint.http_method}] #{endpoint.url}"
    end

    def endpoint_path
      "#{ENV['FRONTEND_DOMAIN']}/#{project.slug}/editor/endpoint/#{endpoint.id}"
    end
  end
end
