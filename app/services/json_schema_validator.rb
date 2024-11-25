require "json-schema"

class JsonSchemaValidator
  def self.validate!(data, schema_path)
    schema = JSON.parse(File.read(schema_path))
    JSON::Validator.validate!(schema, data, strict: true)
  rescue JSON::Schema::ValidationError => e
    raise ValidationError, e.message
  end

  class ValidationError < StandardError; end
end
