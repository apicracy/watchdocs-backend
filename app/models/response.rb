class Response < ApplicationRecord
  include BodyAndHeadersUpdatable

  belongs_to :endpoint
  has_many :headers, as: :headerable

  enum status: %i(outdated up_to_date)

  validates :http_status_code,
            presence: true,
            uniqueness: { scope: :endpoint_id }
end
