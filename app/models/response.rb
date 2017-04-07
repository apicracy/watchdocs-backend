class Response < ApplicationRecord
  belongs_to :endpoint
  has_many :response_headers
  has_many :headers, through: :response_headers
end
