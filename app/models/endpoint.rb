class Endpoint < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :project
  has_one :request
  has_many :url_params
  has_many :responses

  METHODS = %w(GET POST PUT DELETE).freeze

  def update_request(body: nil, headers: nil)
    request ||= build_request
    request.update_body(body) if body
    request.update_headers(headers) if headers
  end

  def update_response_for_status(status, body: nil, headers: nil)
    response = responses.find_or_initialize_by(status: status)
    response.update_body(body) if body
    response.update_headers(headers) if headers
    response
  end
end
