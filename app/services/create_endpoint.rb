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
      if endpoint.group && name.pluralize == name
        endpoint.update(title: "Show #{name.pluralize} of #{endpoint.group.name}")
      elsif endpoint.group
        endpoint.update(title: "Show #{name} of #{endpoint.group.name} details")
      elsif name.pluralize == name
        endpoint.update(title: "Show #{name.pluralize}")
      else
        endpoint.update(title: "Show #{name} details")
      end
    when 'POST'
      if endpoint.group
        endpoint.update(title: "Create #{name} of #{endpoint.group.name}")
      else
        endpoint.update(title: "Create #{name}")
      end
    when 'PUT'
      if endpoint.group
        endpoint.update(title: "Update #{name} of #{endpoint.group.name}")
      else
        endpoint.update(title: "Update #{name}")
      end
    when 'DELETE'
      if endpoint.group
        endpoint.update(title: "Remove #{name} of #{endpoint.group.name}")
      else
        endpoint.update(title: "Remove #{name}")
      end
    end
  end

  def set_description
    case endpoint.http_method
    when 'GET'
      if endpoint.group && name.pluralize == name
        endpoint.update(summary: "Endpoint showing #{name.pluralize} of #{endpoint.group.name}")
      elsif endpoint.group
        endpoint.update(summary: "Endpoint showing #{name} of #{endpoint.group.name} details")
      elsif name.pluralize == name
        endpoint.update(summary: "Endpoint showing #{name.pluralize}")
      else
        endpoint.update(summary: "Endpoint showing #{name} details")
      end
    when 'POST'
      if endpoint.group
        endpoint.update(summary: "Endpoint creating new #{name} of #{endpoint.group.name}")
      else
        endpoint.update(summary: "Endpoint creating new #{name}")
      end
    when 'PUT'
      if endpoint.group
        endpoint.update(summary: "Endpoint updating #{name} of #{endpoint.group.name}")
      else
        endpoint.update(summary: "Endpoint updating #{name}")
      end
    when 'DELETE'
      if endpoint.group
        endpoint.update(summary: "Endpoint removing #{name} of #{endpoint.group.name}")
      else
        endpoint.update(summary: "Endpoint removing #{name}")
      end
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
