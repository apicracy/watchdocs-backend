class Request < ApplicationRecord
  include BodyAndHeadersUpdatable

  has_many :headers, as: :headerable, dependent: :destroy
  belongs_to :endpoint

  validates :endpoint,
            presence: true

  enum status: %i(outdated up_to_date)

  delegate :user, to: :endpoint
end
