# This service updates response for given endpoint with recorded schema
class UpdateUrlParamFromSchema
  attr_reader :endpoint, :name, :required, :param

  def initialize(endpoint:, name:, required:)
    @endpoint = endpoint
    @name = name
    @required = required
    @param = endpoint.url_params.find_or_initialize_by(name: name)
  end

  def call
    update_required
    update_status
  end

  private

  def update_required
    return if param.required == required

    if param.required
      param.update(required_draft: required)
    else
      param.update(required: required)
    end
  end

  def update_status
    param.update(status: param.required_draft.present? ? :outdated : :up_to_date)
  end
end
