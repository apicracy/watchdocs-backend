class UrlParam < ApplicationRecord
  belongs_to :endpoint

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
    # Escaping fresh or stale status requires user action
    return if fresh? || stale?
    self.status = required_draft? ? :outdated : :up_to_date
  end
end
