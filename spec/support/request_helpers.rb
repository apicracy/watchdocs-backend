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
end
