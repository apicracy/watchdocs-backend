class Header < ApplicationRecord
  belongs_to :headerable, polymorphic: true

  enum status: %i(fresh up_to_date outdated stale)

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
