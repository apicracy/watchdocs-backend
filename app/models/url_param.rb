class UrlParam < ApplicationRecord
  belongs_to :endpoint

  def update_required(new_required)
    if required.present?
      update(required_draft: new_required)
    else
      update(required: new_required)
    end
  end
end
