# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Chat Application' do
  describe 'GET /' do
    it 'returns hello world' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Hello world!')
    end
  end

  describe 'User routes' do
    let(:user) { User.create(name: 'Test User') }

    describe 'GET /users/:id' do
      context 'when user exists' do
        it 'returns the user' do
          get "/users/#{user.id}"
          expect(last_response).to be_ok
          expect(JSON.parse(last_response.body)['name']).to eq('Test User')
        end
      end

      context 'when user does not exist' do
        it 'returns 404' do
          get '/users/999'
          expect(last_response.status).to eq(404)
        end
      end
    end

    describe 'POST /users/' do
      context 'when user creation requested' do
        it 'returns the new user' do
          post('/users', JSON.generate({ name: 'New User' }))
          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)['name']).to eq('New User')
        end
      end

      context 'when new user has no name' do
        it 'returns 404' do
          post('/users', JSON.generate({}))
          expect(last_response.status).to eq(400)
        end
      end
    end
  end

  describe 'User messages' do
    let(:sender) { User.create(name: 'Test User 1') }
    let(:receiver) { User.create(name: 'Test User 2') }

    describe 'GET /users/:id/messages' do
      context 'when user checks their inbox and has one message' do
        it 'returns a list with one message' do
          Message.create(sender_id: receiver.id, receiver_id: sender.id, content: 'Sample Message')
          get "/users/#{sender.id}/messages"
          expect(last_response.status).to eq(200)
          expect(JSON.parse(last_response.body).size).to eq(1)
        end
      end

      context 'when user does not exist' do
        it 'returns 404' do
          get '/users/999/messages'
          expect(last_response.status).to eq(404)
        end
      end
    end

    describe 'POST /users/:id/messages' do
      context 'when sender user sends message to receiver user' do
        it 'returns the message' do
          post("/users/#{sender.id}/messages", JSON.generate({ to: receiver.id, content: 'Test message' }))
          expect(last_response.status).to eq(201)
          expect(JSON.parse(last_response.body)['sender_id']).to eq(sender.id)
          expect(JSON.parse(last_response.body)['receiver_id']).to eq(receiver.id)
          expect(JSON.parse(last_response.body)['content']).to eq('Test message')
        end
      end

      context 'when sender does not exist' do
        it 'returns 404' do
          post('/users/999/messages', JSON.generate({ to: receiver.id, content: 'Test message' }))
          expect(last_response.status).to eq(404)
        end
      end

      context 'when receiver does not exist' do
        it 'returns 404' do
          post("/users/#{sender.id}/messages", JSON.generate({ to: 999, content: 'Test message' }))
          expect(last_response.status).to eq(404)
        end
      end

      context 'when message content is empty' do
        it 'returns 400' do
          post("/users/#{sender.id}/messages", JSON.generate({ to: receiver.id, content: '' }))
          expect(last_response.status).to eq(400)
        end
      end
    end
  end
end
