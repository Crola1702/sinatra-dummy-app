# https://api.rubyonrails.org/v8.0.1/files/activerecord/README_rdoc.html
require 'active_record'

DATA_DIR = File.dirname(File.expand_path(__FILE__), 2) + "/data"
DB_NAME = ENV['DB_NAME'] || 'data.db'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: "#{DATA_DIR}/#{DB_NAME}")

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
  end

  create_table :messages, force: true do |t|
    t.belongs_to :receiver
    t.belongs_to :sender
    t.string :content
  end
end

class User < ActiveRecord::Base
end

class Message < ActiveRecord::Base
end
