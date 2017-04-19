class EndpointSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :status,
             :description

  attribute :http_method, key: :method

  has_one :request
  has_many :responses
  has_many :url_params

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
