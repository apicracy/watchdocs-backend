class ResponseHeader < ApplicationRecord
  belongs_to :response
  belongs_to :header
end
