# This service updates response for given endpoint with recorded schema
class UpdateResponseSchema
  attr_reader :new_body, :response

  def initialize(endpoint:, status:, body:)
    @new_body = body
    @response = endpoint.responses
                        .find_or_initialize_by(http_status_code: status)
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
