class EndpointSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :status,
             :description,
             :project_id,
             :group_id,
             :order_number

  attribute :http_method, key: :method

  has_one :request
  has_many :responses
  has_many :url_params

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
