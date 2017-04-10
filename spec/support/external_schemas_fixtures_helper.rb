module ExternalSchemasFixturesHelper
  def external_schema_fixture(name)
    json = File.read(
      Rails.root.join(
        'spec',
        'fixtures',
        'external_schemas',
        "#{name}.json"
      )
    )
    ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(json))
  end
end
