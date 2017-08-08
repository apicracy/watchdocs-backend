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
      if url_contains_param?
        endpoint.update(title: "Return #{name.singularize} details")
      else
        endpoint.update(title: "Return list of #{name}")
      end
    when 'POST'
      endpoint.update(title: "Create #{name ? name.singularize : ''}")
    when 'PUT'
      endpoint.update(title: "Update #{name.singularize}")
    when 'DELETE'
      endpoint.update(title: "Remove #{name.singularize}")
    end
  end

  def set_description
    case endpoint.http_method
    when 'GET'
      if url_contains_param?
        endpoint.update(summary: "Endpoint returning #{name.singularize} details")
      else
        endpoint.update(summary: "Endpoint returning list of #{name}")
      end
    when 'POST'
      endpoint.update(summary: "Endpoint creating new #{name ? name.singularize : ''}")
    when 'PUT'
      endpoint.update(summary: "Endpoint updating #{name.singularize}")
    when 'DELETE'
      endpoint.update(summary: "Endpoint removing #{name.singularize}")
    end
  end

  def url_contains_param?
    endpoint.url.include?(':')
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
