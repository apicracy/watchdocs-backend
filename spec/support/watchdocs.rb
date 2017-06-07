RSpec.configure do |config|
  config.before(:suite) do
    Watchdocs::Rails::Recordings.clear!
  end

  config.after(:suite) do
    Watchdocs::Rails::Recordings.export
  end
end
