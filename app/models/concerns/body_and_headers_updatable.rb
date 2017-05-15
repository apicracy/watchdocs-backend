module BodyAndHeadersUpdatable
  extend ActiveSupport::Concern

  included do
    validates :body,
              :body_draft,
              json_schema: true
  end

  def update_body(new_body)
    if body.present?
      update(body_draft: new_body)
    else
      update(body: new_body)
    end
  end
end
