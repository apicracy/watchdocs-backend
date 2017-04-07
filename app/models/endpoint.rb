class Endpoint < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :project
  has_one :request
  has_many :url_params
  has_many :responses
end
