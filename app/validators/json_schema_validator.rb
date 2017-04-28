class JsonSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.nil?
    JSON::Validator.validate!(JSON_META_SCHEMA, value)
  rescue JSON::Schema::ValidationError => e
    record.errors[attribute] << "json-schema is invalid: #{e.message}"
  end
end
