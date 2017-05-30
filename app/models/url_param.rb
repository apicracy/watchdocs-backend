class UrlParam < ApplicationRecord
  belongs_to :endpoint, touch: true

  validates :name,
            presence: true,
            uniqueness: { scope: [:is_part_of_url, :endpoint_id] }

  validates :endpoint,
            presence: true

  enum status: %i(fresh up_to_date outdated stale)

  scope :not_stale,
        -> { where.not(status: :stale) }
  scope :url_members,
        -> { where(is_part_of_url: true) }

  delegate :user, to: :endpoint

  before_save :set_status

  private

  def set_status
    # Escaping fresh or stale requires user action
    return if fresh? || stale?
    self.status = required_draft.nil? ? :up_to_date : :outdated
  end
end
