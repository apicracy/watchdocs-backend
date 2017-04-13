class EndpointSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :status,
             :description

  attribute :request_method, key: :method

  has_one :request
  has_many :responses
  has_many :url_params

  def description
    {
      title: object.title,
      content: object.summary
    }
  end

  class RequestSerializer < ActiveModel::Serializer
    attributes :id,
               :status
  end

  class ResponseSerializer < ActiveModel::Serializer
    attributes :id,
               :status,
               :status_code
  end
end
