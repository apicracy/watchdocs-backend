class Response < ApplicationRecord
  include BodyAndHeadersUpdatable

  belongs_to :endpoint
  has_many :response_headers
  has_many :headers, through: :response_headers

  enum status: %i(outdated up_to_date)
end
