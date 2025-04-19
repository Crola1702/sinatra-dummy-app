# frozen_string_literal: true

require 'sinatra'
require 'json'
require_relative 'models'

get '/' do
  'Hello world!'
end

# Get user
get '/users/:id' do
  user = User.find_by(id: params['id'])
  raise 'User not found' if user.nil?

  [200, {}, user.to_json]
rescue RuntimeError => e
  [404, {}, JSON.dump({ message: e })]
end

# Create user
post '/users' do
  request.body.rewind
  request_body = request.body.read
  data = JSON.parse(request_body, { symbolize_names: true })

  raise 'Must specify a name' unless data.key? :name

  user = User.create(name: data[:name])

  [201, {}, user.to_json]
rescue RuntimeError => e
  [400, {}, JSON.dump({ message: e })]
end

# Get messages
get '/users/:id/messages' do
  user = User.find_by(id: params['id'])
  raise "User with id #{params['id']} does not exist" if user.nil?

  messages = Message.where('receiver_id = :rec_id or sender_id = :send_id', { rec_id: user.id, send_id: user.id })
  [200, {}, messages.to_json]
rescue StandardError => e
  [400, {}, JSON.dump({ message: e })]
end

# Create message
post '/users/:id/messages' do
  sender = User.find_by(id: params['id'])
  raise "User with id #{params['id']} does not exist" if sender.nil?

  request.body.rewind
  request_body = request.body.read
  data = JSON.parse(request_body, { symbolize_names: true })

  %i[to content].each do |k|
    raise "Missing '#{k}' key" unless data.key? k
  end

  receiver = User.find_by(id: data[:to])
  raise "User with id #{params['id']} does not exist" if receiver.nil?

  msg = Message.create(sender_id: sender.id, receiver_id: receiver.id, content: data[:content])
  [201, {}, msg.to_json]
rescue StandardError => e
  [400, {}, JSON.dump({ message: e })]
end
