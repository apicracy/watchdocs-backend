class Header < ApplicationRecord
  belongs_to :headerable,
             polymorphic: true,
             inverse_of: :headers

  validates :key,
            presence: true,
            uniqueness: { scope: [:headerable_id, :headerable_type] }

  validates :headerable,
            :required,
            :key,
            presence: true

  enum status: %i(fresh up_to_date outdated stale)

  delegate :user, to: :headerable

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
