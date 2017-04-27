class Request < ApplicationRecord
  include BodyAndHeadersUpdatable
  include EndpointBelongable

  has_many :headers, as: :headerable, dependent: :destroy

  enum status: %i(outdated up_to_date)
end
