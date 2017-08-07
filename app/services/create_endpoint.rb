class CreateEndpoint
  attr_reader :endpoint, :project

  def initialize(initial_params)
    @endpoint = Endpoint.new(initial_params)
    @project = @endpoint.project
    set_title
    set_description
  end

  def call
    return endpoint unless endpoint.save
    track unless in_sample_project?
    endpoint
  end

  private

  def set_title
    case endpoint.http_method
    when 'GET'
      endpoint.update(title: "Get #{name} details")
    when 'POST'
      endpoint.update(title: "Create #{name} resource")
    when 'PUT'
      endpoint.update(title: "Update #{name} resource")
    when 'DELETE'
      endpoint.update(title: "Remove #{name} resource")
    end
  end

  def set_description
    case endpoint.http_method
    when 'GET'
      endpoint.update(summary: "Endpoint geting #{name} details")
    when 'POST'
      endpoint.update(summary: "Endpoint creating new #{name} resource")
    when 'PUT'
      endpoint.update(summary: "Endpoint updating #{name} resource")
    when 'DELETE'
      endpoint.update(summary: "Endpoint removing #{name} resource")
    end
  end

  def name
    CreateGroupName.new(url: endpoint[:url]).parse_url if endpoint[:url]
  end

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
