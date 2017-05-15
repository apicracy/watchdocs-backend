class Response < ApplicationRecord
  include HttpMessageable

  validates :http_status_code,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: :endpoint_id }
end
