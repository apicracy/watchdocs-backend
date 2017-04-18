class ResponseSerializer < ActiveModel::Serializer
  attributes :id,
             :body,
             :body_draft,
             :status,
             :http_status_code

  has_many :headers
end
