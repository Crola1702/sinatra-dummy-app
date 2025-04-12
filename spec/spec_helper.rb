require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  track_files "/src/**/*.rb"
end

require 'rspec'
require 'rack/test'
require 'database_cleaner/active_record'

ENV['RACK_ENV'] = 'test'
ENV['DB_NAME'] = 'data.test.db'

require_relative '../src/app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

def app
  Sinatra::Application
end
