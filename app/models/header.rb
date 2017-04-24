class Header < ApplicationRecord
  include Draftable
  belongs_to :headerable, polymorphic: true

  validates :key,
            presence: true,
            uniqueness: { scope: [:headerable_id, :headerable_type] }

  enum status: %i(fresh up_to_date outdated stale)

  before_save :set_status

  def update_required(new_required)
    draft(:required, new_required)
  end

  private

  def set_status
    # Escaping those statuses requires user action
    return if stale? || fresh?

    self.status = pending_drafts? ? :outdated : :fresh
  end
end
