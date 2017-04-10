class Response < ApplicationRecord
  belongs_to :endpoint
  has_many :response_headers
  has_many :headers, through: :response_headers

  def update_body(body)
    if body.present?
      update(body_draft: body)
    else
      update(body: body)
    end
  end
end
