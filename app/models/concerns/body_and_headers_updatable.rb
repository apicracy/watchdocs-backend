module BodyAndHeadersUpdatable
  extend ActiveSupport::Concern

  def update_body(new_body)
    if body.present?
      update(body_draft: new_body)
    else
      update(body: new_body)
    end
  end

  def update_headers(new_headers)
    new_headers.each do |key, required|
      headers.find_or_create_by(key: key)
             .update_required(required)
    end
  end
end
