class Endpoint < ApplicationRecord
  include Groupable

  has_one :request, dependent: :destroy, required: true
  has_many :url_params, dependent: :destroy
  has_many :responses, dependent: :destroy

  enum status: %i(outdated up_to_date)

  validates :http_method,
            :project,
            :status,
            :request,
            presence: true

  validates :url,
            presence: true,
            uniqueness: { scope: [:http_method, :project_id] },
            format: { with: UrlPath::VALID_PATH }

  METHODS = %w(GET POST PUT DELETE).freeze

  before_validation :autocorrect_url
  before_validation :build_request, on: :create, unless: :request
  after_save        :sync_url_params
  before_save       :set_status
  after_touch       :set_status

  delegate :user, to: :project

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
    self.url = UrlPath.new(url).corrected_url
  end

  def set_status
    self.status = if responses.any?(&:outdated?) ||
                     request.outdated? ||
                     url_params.any?(&:outdated?)
                    :outdated
                  else
                    :up_to_date
                  end
  end
end
