class Response < ApplicationRecord
  include BodyAndHeadersUpdatable

  validates :http_status_code,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: :endpoint_id }

  validates :endpoint,
            presence: true

  belongs_to :endpoint
  has_many :headers, as: :headerable, dependent: :destroy

  enum status: %i(outdated up_to_date)
end
