class Endpoint < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :project
  has_one :request
  has_many :url_params
  has_many :responses

  enum status: %i(outdated up_to_date)

  METHODS = %w(GET POST PUT DELETE).freeze

  def update_request(body: nil, headers: nil)
    request ||= build_request
    request.update_body(body) if body
    request.update_headers(headers) if headers
  end

  def update_response_for_status(status_code, body: nil, headers: nil)
    response = responses.find_or_initialize_by(http_status_code: status_code)
    response.update_body(body) if body
    response.update_headers(headers) if headers
    response
  end

  # TODO: Move to decorator in the future
  def description
    {
      title: title,
      content: summary
    }
  end
end
