# frozen_string_literal: true

source "https://rubygems.org"

gem 'sinatra', :github => 'sinatra/sinatra'
gem "rackup", "~> 2.2"
gem "puma", "~> 6.6"
gem "activerecord", "~> 8.0"
gem "sqlite3", "~> 2.6"

gem "rerun", "~> 0.14.0"

group :development, :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'database_cleaner-active_record'
end

group :test do
  gem 'simplecov', require: false
end
