# This service updates response for given endpoint with recorded schema
class UpdateUrlParamFromSchema
  attr_reader :new_required, :param

  def initialize(endpoint:, name:, required:)
    @new_required = required
    @param = endpoint.url_params.find_or_initialize_by(name: name)
  end

  def call
    return if previous_required == new_required

    if previous_required.present?
      param.update(required_draft: new_required)
    else
      param.update(required: new_required)
    end
  end

  private

  def previous_required
    param.required
  end
end
