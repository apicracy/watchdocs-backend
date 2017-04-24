class UrlParam < ApplicationRecord
  belongs_to :endpoint

  validates :key,
            presence: true,
            uniqueness: { scope: :endpoint_id }

  validates :endpoint,
            presence: true

  enum status: %i(fresh up_to_date outdated stale)

  alias_attribute :name, :key
  alias_attribute :example, :example_value

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
