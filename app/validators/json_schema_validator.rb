class JsonSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.nil?
    schema = "#{Dir.pwd}/app/validators/json_schema.json"
    JSON::Validator.validate!(schema, value)
  rescue JSON::Schema::ValidationError => e
    record.errors[attribute] << "json-schema is invalid: #{e.message}"
  end
end
