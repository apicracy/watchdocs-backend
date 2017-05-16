class JsonSchemaValidator < ActiveModel::EachValidator
  JSON_META_SCHEMA = File.read(
    Rails.root.join(
      'lib',
      'json_schema.json'
    )
  )

  def validate_each(record, attribute, value)
    return true if value.blank?
    JSON::Validator.validate!(JSON_META_SCHEMA, value)
  rescue JSON::Schema::ValidationError => e
    record.errors[attribute] << "json-schema is invalid: #{e.message}"
  end
end
