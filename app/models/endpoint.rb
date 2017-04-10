class Endpoint < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :project
  has_one :request
  has_many :url_params
  has_many :responses

  def update_request(body, headers)
    request ||= build_request
    request.update_body(body)
    request.update_headers(headers)
  end

  def update_response(status, body, headers)
    response = responses.find_or_initialize_by(status: status)
    response.update_body(body)
    response.update_headers(headers)
  end
end
