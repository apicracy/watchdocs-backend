class ResponseSerializer < ActiveModel::Serializer
  attributes :id,
             :endpoint_id,
             :body,
             :body_draft,
             :status,
             :http_status_code

  has_many :headers
end
