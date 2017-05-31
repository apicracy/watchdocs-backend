class Endpoint < ApplicationRecord
  include Groupable

  has_one :request, dependent: :destroy, required: true
  has_many :url_params, dependent: :destroy
  has_many :responses, dependent: :destroy

  enum status: %i(outdated up_to_date)

  validates :http_method,
            :project,
            :request,
            presence: true

  validates :url,
            presence: true,
            uniqueness: { scope: [:http_method, :project_id] },
            format: { with: UrlPath::VALID_PATH }

  METHODS = %w(GET POST PUT DELETE).freeze

  before_validation :autocorrect_url
  before_validation :build_request, on: :create, unless: :request
  after_touch       :refresh_status
  after_create      :refresh_status
  after_save        :sync_url_params

  delegate :user, to: :project

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
    self.url = UrlPath.autocorrect(url)
  end

  def refresh_status
    new_status = if responses.outdated.any? ||
                    request&.outdated? ||
                    url_params.outdated.any?
                   :outdated
                 else
                   :up_to_date
                 end
    # We don't want further callbacks :)
    # This is just cache updating
    update_column(:status, new_status)
  end
end
