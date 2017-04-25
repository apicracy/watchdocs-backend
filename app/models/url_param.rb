class UrlParam < ApplicationRecord
  belongs_to :endpoint

  validates :name,
            presence: true,
            uniqueness: { scope: [:endpoint_id, :is_part_of_url] }

  validates :endpoint,
            presence: true

  enum status: %i(fresh up_to_date outdated stale)

  scope :not_stale,
        -> { where.not(status: :stale) }
  scope :url_members,
        -> { where(is_part_of_url: true) }

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
