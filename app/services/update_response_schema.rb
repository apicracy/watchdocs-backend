# This service updates response for given endpoint with recorded schema
class UpdateResponseSchema
  attr_reader :endpoint, :status, :body, :response

  def initialize(endpoint:, status:, body:)
    @endpoint = endpoint
    @status = status
    @body = body
    @response = endpoint.responses
                        .find_or_initialize_by(http_status_code: status)
  end

  def call
    update_body
    update_status
  end

  private

  def update_body
    return if response.body == body

    if response.body
      response.update(body_draft: body)
    else
      response.update(body: body)
    end
  end

  def update_status
    response.update(status: response.body_draft.present? ? :outdated : :up_to_date)
  end
end
