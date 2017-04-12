module JsonHelper
  def json
    @json ||= JSON.parse(response.body)
  end

  def clear_json
    @json = nil
  end

  def serialized(object)
    JSON.parse(
      ActiveModelSerializers::SerializableResource.new(object).to_json
    )
  end
end
