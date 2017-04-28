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

  validates :endpoint,
            presence: true

  validates :http_status_code,
            presence: true,
            numericality: { only_integer: true },
            uniqueness: { scope: :endpoint_id }

  enum status: %i(outdated up_to_date)

  delegate :user, to: :endpoint
end
