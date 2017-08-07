class EndpointSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :status,
             :description,
             :project_id,
             :group_id,
             :title

  attribute :http_method, key: :method

  has_one :request
  has_many :responses
  has_many :url_params

  def responses
    object.responses.order(:http_status_code)
  end

  def title
    case object.http_method
    when 'GET'
      object.update(title: "Get #{name} details")
    when 'POST'
      object.update(title: "Create #{name} resource")
    when 'PUT'
      object.update(title: "Update #{name} resource")
    when 'DELETE'
      object.update(title: "Remove #{name} resource")
    end
  end

  def description
    case object.http_method
    when 'GET'
      object.update(summary: "Endpoint geting #{name} details")
    when 'POST'
      object.update(summary: "Endpoint creating new #{name} resource")
    when 'PUT'
      object.update(summary: "Endpoint updating #{name} resource")
    when 'DELETE'
      object.update(summary: "Endpoint removing #{name} resource")
    end
  end

  def name
    name = object.url.split('/').last.gsub! '_', ' '
  end

  class RequestSerializer < ActiveModel::Serializer
    attributes :id,
               :status
  end

  class ResponseSerializer < ActiveModel::Serializer
    attributes :id,
               :status,
               :http_status_code
  end
end
