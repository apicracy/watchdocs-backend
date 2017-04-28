class Request < ApplicationRecord
  include BodyAndHeadersUpdatable

  belongs_to :endpoint
  has_many :headers,
           as: :headerable,
           dependent: :destroy,
           inverse_of: :headerable

  validates :endpoint,
            presence: true

  enum status: %i(outdated up_to_date)

  delegate :user, to: :endpoint
end
