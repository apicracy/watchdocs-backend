# This service updates request for given endpoint with recorded schema
class UpdateRequestSchema
  attr_reader :request, :new_body

  def initialize(request:, body:)
    @request = request
    @new_body = body
  end

  def call
    return if previous_body == new_body

    if previous_body.present?
      request.update(body_draft: new_body)
    else
      request.update(body: new_body)
    end
  end

  private

  def previous_body
    request.body
  end
end
