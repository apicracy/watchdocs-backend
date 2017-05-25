# This service updates response for given endpoint with recorded schema
class UpdateResponseSchema
  attr_reader :response, :new_body

  def initialize(response:, body:)
    @response = response
    @new_body = body
  end

  def call
    return if previous_body == new_body

    if previous_body.present?
      response.update(body_draft: new_body)
    else
      response.update(body: new_body)
    end
  end

  private

  def previous_body
    response.body
  end
end
