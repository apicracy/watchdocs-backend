class Request < ApplicationRecord
  include BodyAndHeadersUpdatable

  belongs_to :endpoint
  has_many :headers, as: :headerable
end
