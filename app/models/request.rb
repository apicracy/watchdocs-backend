class Request < ApplicationRecord
  belongs_to :endpoint
  has_many :request_headers
  has_many :headers, through: :request_headers

  def update_body(new_body)
    if body.present?
      update(body_draft: new_body)
    else
      update(body: new_body)
    end
  end
end
