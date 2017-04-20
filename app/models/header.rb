class Header < ApplicationRecord
  belongs_to :headerable, polymorphic: true

  validates :key,
            presence: true,
            uniqueness: { scope: [:headerable_id, :headerable_type] }

  enum status: %i(fresh up_to_date outdated stale)

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
