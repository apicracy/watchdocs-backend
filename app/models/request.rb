class Request < ApplicationRecord
  belongs_to :endpoint
  has_many :request_headers
  has_many :headers, through: :request_headers
end
