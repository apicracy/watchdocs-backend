class Response < ApplicationRecord
  include BodyAndHeadersUpdatable

  belongs_to :endpoint
  has_many :headers, as: :headerable

  enum status: %i(outdated up_to_date)
end
