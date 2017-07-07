# Delayed extensions provide a very easy and simple way to make method calls asynchronous.
# By default, all class methods and ActionMailer deliveries can be performed asynchronously.

# They are disabled by default in Sidekiq 5+.
# Use Sidekiq::Extensions.enable_delay! to turn them on.
# See: https://github.com/mperham/sidekiq/wiki/Delayed-extensions

Sidekiq::Extensions.enable_delay!
