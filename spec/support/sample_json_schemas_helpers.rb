module SampleJsonSchemasHelpers
  def schema_fixture(name)
    json = File.read(
      Rails.root.join(
        'spec',
        'fixtures',
        'schemas',
        "#{name}.json"
      )
    )
    ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(json))
  end
end

RSpec.configure do |config|
  config.include SampleJsonSchemasHelpers
end
