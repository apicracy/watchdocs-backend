class EndpointSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :status,
             :description,
             :project_id,
             :group_id

  attribute :http_method, key: :method

  has_one :request
  has_many :responses
  has_many :url_params

  def description
    return if object.title.blank? && object.summary.blank?
    {
      title: object.title,
      content: object.summary
    }
  end

  def responses
    object.responses.order(:http_status_code)
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
