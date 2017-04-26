class Endpoint < ApplicationRecord
  include Groupable

  has_one :request, dependent: :destroy
  has_many :url_params, dependent: :destroy
  has_many :responses, dependent: :destroy

  enum status: %i(outdated up_to_date)

  validates :http_method,
            :project,
            :status,
            presence: true

  # Url format should be /path/to/endpoint/:param
  # with leading slash and without finishing one
  # allows params starting with ":"
  validates :url,
            presence: true,
            uniqueness: { scope: [:http_method, :project_id] },
            format: {
              with: %r(\A\/{1}(:?[A-Za-z0-9\-_\.~]+\/)*(:?[A-Za-z0-9\-_\.~]+)\z)
            }

  METHODS = %w(GET POST PUT DELETE).freeze

  before_validation :autocorrect_url
  after_save :sync_url_params

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
    return if title.blank? && summary.blank?
    {
      title: title,
      content: summary
    }
  end

  private

  def sync_url_params
    return true unless url_changed?
    SyncUrlParams.new(self).call
  end

  def autocorrect_url
    return true unless url
    prepend_with_slash
    remove_ending_slash
  end

  def prepend_with_slash
    url.prepend('/') unless url.start_with?('/')
  end

  def remove_ending_slash
    url.chomp!('/') if url.end_with?('/')
  end
end
