class CreateEndpoint
  attr_reader :endpoint, :project

  def initialize(initial_params)
    @endpoint = Endpoint.new(initial_params)
    @project = @endpoint.project
  end

  def call
    return endpoint unless endpoint.save
    track unless in_sample_project?
    endpoint
  end

  private

  def in_sample_project?
    endpoint.project.sample
  end

  def track
    return unless first_endpoint_created?
    ActiveCampaignTracking.for(endpoint.user.email)
                          .create_event(
                            ActiveCampaignTracking::EVENTS[:first_endpoint_created]
                          )
  rescue => e
    Rails.logger.error "ActiveCampaignTracking Error: #{e.message} #{e.backtrace}"
  end

  def first_endpoint_created?
    endpoint.project.endpoints.count == 1
  end
end
