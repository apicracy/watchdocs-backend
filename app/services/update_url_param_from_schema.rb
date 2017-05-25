# This service updates response for given endpoint with recorded schema
class UpdateUrlParamFromSchema
  attr_reader :new_required, :url_param

  def initialize(url_param:, required:)
    @new_required = required
    @url_param = url_param
  end

  def call
    return if previous_required == new_required

    if previous_required.present?
      url_param.update(required_draft: new_required)
    else
      url_param.update(required: new_required)
    end
  end

  private

  def previous_required
    url_param.required
  end
end
