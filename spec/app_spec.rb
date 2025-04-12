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
  end
end
