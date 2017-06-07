require 'rails_helper'

RSpec.describe 'POST /login', type: :request do
  let(:user) { Fabricate(:user) }
  let(:url) { '/login' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
      expect(json).to eq(serialized(user))
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decoded_jwt_token_from_response(response)
      expect(decoded_token.first['sub']).to be_present
    end

    it 'token lifetime is 24h' do
      decoded_token = decoded_jwt_token_from_response(response)
      expiration_time = Time.zone.at(decoded_token.first['exp'])
      expect(Time.current + 23.hours < expiration_time).to be_truthy
      expect(Time.current + 24.hours < expiration_time).to be_falsy
    end
  end

  context 'when login params are incorrect' do
    before { post url }
    it_behaves_like 'unauthorized'
  end

  def decoded_jwt_token_from_response(response)
    token = response.headers['Authorization'].split(' ').last
    hmac_secret = ENV['DEVISE_JWT_SECRET_KEY']
    JWT.decode token, hmac_secret, true
  end
end
