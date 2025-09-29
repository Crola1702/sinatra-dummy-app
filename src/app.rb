# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'ruby-prof'
require 'fileutils'
require_relative 'models'
require_relative 'errors'

profile = RubyProf::Profile.new

def save_profiling(result, path)
  timestamp = Time.now.to_i
  profile_path = "profiling/#{path}/#{timestamp}/"
  puts "[DEBUG] Saving profile to #{profile_path}"
  FileUtils.mkdir_p(profile_path)

  printer = RubyProf::MultiPrinter.new(result, printers=[:flat, :graph_html, :call_tree, :dot])
  printer.print(:path => profile_path, :profile => "profile")
  puts "[DEBUG] Profile saved"
end

get '/' do
  profile.start
  res = 'Hello world!'
  save_profiling(profile.stop, "get_root")
  res
end

# Get user
get '/users/:id' do
  profile.start
  user = User.find_by(id: params['id'])
  raise NotFoundError, 'User not found' if user.nil?

  res = [200, {}, user.to_json]
  save_profiling(profile.stop, "get_user")
  res
rescue ApiError => e
  [e.status_code, {}, JSON.dump({ message: e })]
end

# Create user
post '/users' do
  profile.start
  request.body.rewind
  request_body = request.body.read
  data = JSON.parse(request_body, { symbolize_names: true })

  raise BadRequestError, 'Must specify a name' unless data.key? :name

  user = User.create(name: data[:name])

  res = [201, {}, user.to_json]
  save_profiling(profile.stop, "post_users")
  res
rescue ApiError => e
  [e.status_code, {}, JSON.dump({ message: e })]
end

# Get messages
get '/users/:id/messages' do
  profile.start
  user = User.find_by(id: params['id'])
  raise NotFoundError, "User with id #{params['id']} does not exist" if user.nil?

  messages = Message.where('receiver_id = :rec_id or sender_id = :send_id', { rec_id: user.id, send_id: user.id })
  res = [200, {}, messages.to_json]
  save_profiling(profile.stop, "get_user_messages")
  res
rescue ApiError => e
  [e.status_code, {}, JSON.dump({ message: e })]
end

# Create message
post '/users/:id/messages' do
  profile.start
  sender = User.find_by(id: params['id'])
  raise NotFoundError, "User with id #{params['id']} does not exist" if sender.nil?

  request.body.rewind
  request_body = request.body.read
  data = JSON.parse(request_body, { symbolize_names: true })

  %i[to content].each do |k|
    raise BadRequestError, "Missing '#{k}' key" unless data.key? k
  end

  raise BadRequestError, 'Message content is empty' if data[:content].empty?

  receiver = User.find_by(id: data[:to])
  raise NotFoundError, "User with id #{params['id']} does not exist" if receiver.nil?

  msg = Message.create(sender_id: sender.id, receiver_id: receiver.id, content: data[:content])
  res = [201, {}, msg.to_json]
  save_profiling(profile.stop, "post_user_message")
  res
rescue ApiError => e
  [e.status_code, {}, JSON.dump({ message: e })]
end

post '/users/:id/messages/multiple/:to_id' do
  profile.start
  sender = User.find_by(id: params['id'])
  raise NotFoundError, "User with id #{params['id']} does not exist" if sender.nil?

  receiver = User.find_by(id: params['to_id'])
  raise NotFoundError, "User with id #{params['to_id']} does not exist" if receiver.nil?

  # We have a list of messages to send
  request.body.rewind
  request_body = request.body.read
  data = JSON.parse(request_body, { symbolize_names: true })

  sent_messages = []

  data.each_with_index do |msg, i|
    raise BadRequestError, "Missing content key in message #{i}" unless msg.key? :content

    new_msg = Message.create(sender_id: sender.id, receiver_id: receiver.id, content: msg[:content])
    sent_messages << new_msg
  end
  res = [201, {}, sent_messages.to_json]
  save_profiling(profile.stop, "post_user_messages_multiple")
  res
rescue ApiError => e
  [e.status_code, {}, JSON.dump({ message: e })]
end

