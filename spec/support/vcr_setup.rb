VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'fixtures', 'vcr_cassettes')
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_request do |req|
    req.uri == Watchdocs::Rails.configuration.export_url
  end
end

RSpec.configure do |c|
  c.around(:each) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)

    if example.metadata[:ignore_param].present?
      options[:match_requests_on] ||= []
      options[:match_requests_on] = options[:match_requests_on] + [:method, VCR.request_matchers.uri_without_param(example.metadata[:ignore_param])]
    end

    options[:record] = :new_episodes
    VCR.use_cassette(name, options) { example.call }
  end
end
