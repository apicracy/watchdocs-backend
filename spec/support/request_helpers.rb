module RequestHelpers
  def json
    @json ||= JSON.parse(response.body)
  end

  def clear_json
    @json = nil
  end

  def json_items_ids
    json.map { |item| item['id'] }
  end

  def serialized(object)
    JSON.parse(
      ActiveModelSerializers::SerializableResource.new(object).to_json
    )
  end
end
