class RequestSerializer < ActiveModel::Serializer
  attributes :id, :body, :body_draft

  has_many :headers
end
