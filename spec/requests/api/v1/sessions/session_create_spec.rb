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
    before { post url, params: params }

    it 'returns 200' do
      expect(response).to have_http_status(200)
      expect(json).to eq(serialized(user))
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      token = response.headers['Authorization'].split(' ').last
      hmac_secret = ENV['DEVISE_JWT_SECRET_KEY']
      decoded_token = JWT.decode token, hmac_secret, true
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }
    it_behaves_like 'unauthorized'
  end
end
