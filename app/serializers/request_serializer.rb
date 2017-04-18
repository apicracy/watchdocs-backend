class RequestSerializer < ActiveModel::Serializer
  attributes :id, :body, :body_draft, :status

  has_many :headers
end
