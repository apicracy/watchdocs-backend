ruby '2.3.0'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'haml'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

gem 'active_model_serializers', '~> 0.10.4'
gem 'dotenv-rails', '~> 2.1', '>= 2.1.1'
gem 'devise-jwt', '~> 0.1.1'
gem 'watchdocs-rails', '0.10.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-nav'
  gem 'rubocop', '~> 0.39.0'
  gem 'rubocop-rspec', '~> 1.4', '>= 1.4.1'
end

group :test do
  gem 'database_cleaner', '~> 1.5', '>= 1.5.3'
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webmock', '~> 2.1'
  gem 'vcr', '~> 3.0', '>= 3.0.3'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'cancancan', '~> 2.0'
gem 'json-schema', '~> 2.7'
gem 'validate_url', '~> 1.0', '>= 1.0.2'
gem 'fabrication', '~> 2.14', '>= 2.14.1'
gem 'faker', '~> 1.7', '>= 1.7.3'
gem 'httparty', '~> 0.14.0'
gem 'seed_dump'
