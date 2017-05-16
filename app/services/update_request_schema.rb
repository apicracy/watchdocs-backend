# This service updates response for given endpoint with recorded schema
class UpdateRequestSchema
  attr_reader :endpoint, :body, :request

  def initialize(endpoint:, body:)
    @endpoint = endpoint
    @request = endpoint.request
    @body = body
  end

  def call
    update_body
    update_status
  end

  private

  def update_body
    return if request.body == body

    if request.body
      request.update(body_draft: body)
    else
      request.update(body: body)
    end
  end

  def update_status
    request.update(status: request.body_draft.present? ? :outdated : :up_to_date)
  end
end
