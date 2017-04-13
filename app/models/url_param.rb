class UrlParam < ApplicationRecord
  belongs_to :endpoint

  enum status: %i(incomplete completed full ignored)

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
