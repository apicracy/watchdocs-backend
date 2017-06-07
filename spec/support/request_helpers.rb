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

  def decoded_jwt_token_from_response(response)
    token = response.headers['Authorization'].split(' ').last
    hmac_secret = ENV['DEVISE_JWT_SECRET_KEY']
    JWT.decode token, hmac_secret, true
  end
end
