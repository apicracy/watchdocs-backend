class RequestHeader < ApplicationRecord
  belongs_to :request
  belongs_to :header
end
