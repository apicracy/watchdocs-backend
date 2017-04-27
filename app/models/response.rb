class Response < ApplicationRecord
  include BodyAndHeadersUpdatable
  include EndpointBelongable

  validates :http_status_code,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: :endpoint_id }

  has_many :headers, as: :headerable, dependent: :destroy

  enum status: %i(outdated up_to_date)
end
