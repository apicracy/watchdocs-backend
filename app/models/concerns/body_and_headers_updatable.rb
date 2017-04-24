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
    existing_keys = headers.pluck(:key)
    new_keys = new_headers.keys

    fresh_keys = new_keys - existing_keys
    stale_keys = existing_keys - fresh_keys
    update_keys = existing_keys & fresh_keys

    # update_existing_headers(new_headers.slice(fresh_keys))
    # add_fresh_headers(new_headers.slice(fresh_keys))
    # mark_stale_headers(stale_keys)

    update_keys.each do |key|
      headers.find_by(key: key)
             .update_required(new_headers[key])
    end

    fresh_keys.each do |key|
      headers.create(key: key, required: new_headers[key], status: :fresh)
    end

    headers.where(key: stale_keys).update_all(status: :stale)
  end

  # private

  # def update_existing_headers(headers)
end
